Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF44E3DD3A2
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhHBK1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:27:32 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:37568 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233235AbhHBK1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:27:30 -0400
X-IronPort-AV: E=Sophos;i="5.84,288,1620658800"; 
   d="scan'208";a="89524118"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 02 Aug 2021 19:27:20 +0900
Received: from localhost.localdomain (unknown [10.226.92.138])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id E1D1C4006181;
        Mon,  2 Aug 2021 19:27:16 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct ravb_hw_info
Date:   Mon,  2 Aug 2021 11:26:49 +0100
Message-Id: <20210802102654.5996-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of queues used in retrieving device stats for R-Car is 2,
whereas for RZ/G2L it is 1.

Add the num_gstat_queue variable to struct ravb_hw_info, to add subsequent
SoCs without any code changes to the ravb_get_ethtool_stats function.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 16d1711a0731..38552e0319d3 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -990,6 +990,7 @@ enum ravb_chip_id {
 
 struct ravb_hw_info {
 	enum ravb_chip_id chip_id;
+	int num_gstat_queue;
 	int num_tx_desc;
 	size_t skb_sz;
 };
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 08146c1975e5..30132693edd7 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1149,11 +1149,12 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
 				   struct ethtool_stats *estats, u64 *data)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	int i = 0;
 	int q;
 
 	/* Device-specific stats */
-	for (q = RAVB_BE; q < NUM_RX_QUEUE; q++) {
+	for (q = RAVB_BE; q < info->num_gstat_queue; q++) {
 		struct net_device_stats *stats = &priv->stats[q];
 
 		data[i++] = priv->cur_rx[q];
@@ -1926,12 +1927,14 @@ static int ravb_mdio_release(struct ravb_private *priv)
 
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.chip_id = RCAR_GEN3,
+	.num_gstat_queue = NUM_RX_QUEUE,
 	.num_tx_desc = NUM_TX_DESC_GEN3,
 	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.chip_id = RCAR_GEN2,
+	.num_gstat_queue = NUM_RX_QUEUE,
 	.num_tx_desc = NUM_TX_DESC_GEN2,
 	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,
 };
-- 
2.17.1

