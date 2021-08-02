Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43413DD3AE
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhHBK2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:28:03 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:53001 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233245AbhHBK2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:28:01 -0400
X-IronPort-AV: E=Sophos;i="5.84,288,1620658800"; 
   d="scan'208";a="89524171"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 02 Aug 2021 19:27:51 +0900
Received: from localhost.localdomain (unknown [10.226.92.138])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id F0EE54006181;
        Mon,  2 Aug 2021 19:27:45 +0900 (JST)
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
Subject: [PATCH net-next v2 8/8] ravb: Add tx_drop_cntrs to struct ravb_hw_info
Date:   Mon,  2 Aug 2021 11:26:54 +0100
Message-Id: <20210802102654.5996-9-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register for retrieving TX drop counters is present only on R-Car Gen3
and RZ/G2L; it is not present on R-Car Gen2.

Add the tx_drop_cntrs hw feature bit to struct ravb_hw_info, to enable this
feature specifically for R-Car Gen3 now and later extend it to RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 0d640dbe1eed..35fbb9f60ba8 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1001,6 +1001,7 @@ struct ravb_hw_info {
 
 	/* hardware features */
 	unsigned internal_delay:1;	/* RAVB has internal delays */
+	unsigned tx_drop_cntrs:1;	/* RAVB has TX error counters */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 02acae4d51c1..6af3f978c84c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1633,13 +1633,14 @@ static u16 ravb_select_queue(struct net_device *ndev, struct sk_buff *skb,
 static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	struct net_device_stats *nstats, *stats0, *stats1;
 
 	nstats = &ndev->stats;
 	stats0 = &priv->stats[RAVB_BE];
 	stats1 = &priv->stats[RAVB_NC];
 
-	if (priv->chip_id == RCAR_GEN3) {
+	if (info->tx_drop_cntrs) {
 		nstats->tx_dropped += ravb_read(ndev, TROCR);
 		ravb_write(ndev, 0, TROCR);	/* (write clear) */
 	}
@@ -1940,6 +1941,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.internal_delay = 1,
+	.tx_drop_cntrs = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
-- 
2.17.1

