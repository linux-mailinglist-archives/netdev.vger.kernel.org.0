Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEEC3DD3A7
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhHBK1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:27:43 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:13101 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233258AbhHBK1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:27:42 -0400
X-IronPort-AV: E=Sophos;i="5.84,288,1620658800"; 
   d="scan'208";a="89548963"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 02 Aug 2021 19:27:32 +0900
Received: from localhost.localdomain (unknown [10.226.92.138])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 044AD4006DF1;
        Mon,  2 Aug 2021 19:27:26 +0900 (JST)
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
Subject: [PATCH net-next v2 5/8] ravb: Add gstrings_stats and gstrings_size to struct ravb_hw_info
Date:   Mon,  2 Aug 2021 11:26:51 +0100
Message-Id: <20210802102654.5996-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device stats strings for R-Car and RZ/G2L are different.

R-Car provides 30 device stats, whereas RZ/G2L provides only 15. In
addition, RZ/G2L has stats "rx_queue_0_csum_offload_errors" instead of
"rx_queue_0_missed_errors".

Add structure variables gstrings_stats and gstrings_size to struct
ravb_hw_info, so that subsequent SoCs can be added without any code
changes in the ravb_get_strings function.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      | 2 ++
 drivers/net/ethernet/renesas/ravb_main.c | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index a42c34eaebc2..b765b2b7d9e9 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -989,6 +989,8 @@ enum ravb_chip_id {
 };
 
 struct ravb_hw_info {
+	const char (*gstrings_stats)[ETH_GSTRING_LEN];
+	size_t gstrings_size;
 	enum ravb_chip_id chip_id;
 	int num_gstat_queue;
 	int num_tx_desc;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index baeb868b07ed..7a69668cb512 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1178,9 +1178,12 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
 
 static void ravb_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
+
 	switch (stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, ravb_gstrings_stats, sizeof(ravb_gstrings_stats));
+		memcpy(data, info->gstrings_stats, info->gstrings_size);
 		break;
 	}
 }
@@ -1927,6 +1930,8 @@ static int ravb_mdio_release(struct ravb_private *priv)
 }
 
 static const struct ravb_hw_info ravb_gen3_hw_info = {
+	.gstrings_stats = ravb_gstrings_stats,
+	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.chip_id = RCAR_GEN3,
 	.num_gstat_queue = NUM_RX_QUEUE,
 	.num_tx_desc = NUM_TX_DESC_GEN3,
@@ -1935,6 +1940,8 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
+	.gstrings_stats = ravb_gstrings_stats,
+	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.chip_id = RCAR_GEN2,
 	.num_gstat_queue = NUM_RX_QUEUE,
 	.num_tx_desc = NUM_TX_DESC_GEN2,
-- 
2.17.1

