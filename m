Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA2C3F0B97
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhHRTJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:09:32 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:22399 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233836AbhHRTJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:09:11 -0400
X-IronPort-AV: E=Sophos;i="5.84,332,1620658800"; 
   d="scan'208";a="91033568"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 19 Aug 2021 04:08:26 +0900
Received: from localhost.localdomain (unknown [10.226.93.61])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 05A8B40D5D67;
        Thu, 19 Aug 2021 04:08:22 +0900 (JST)
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
Subject: [PATCH net-next v3 5/9] ravb: Add stats_len to struct ravb_hw_info
Date:   Wed, 18 Aug 2021 20:07:56 +0100
Message-Id: <20210818190800.20191-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car provides 30 device stats, whereas RZ/G2L provides only 15. In
addition, RZ/G2L has stats "rx_queue_0_csum_offload_errors" instead of
"rx_queue_0_missed_errors".

Replace RAVB_STATS_LEN macro with a structure variable stats_len to
struct ravb_hw_info, to support subsequent SoCs without any code changes
to the ravb_get_sset_count function.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
---
v2->v3:
 * No change.Added Rb tag from Sergei.
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 976242ed6f7a..cec0c062d9bb 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -990,6 +990,7 @@ enum ravb_chip_id {
 
 struct ravb_hw_info {
 	enum ravb_chip_id chip_id;
+	int stats_len;
 	size_t max_rx_len;
 	unsigned aligned_tx: 1;
 };
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index d9bb5a261d40..1fb03d04d9b4 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1133,13 +1133,14 @@ static const char ravb_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"rx_queue_1_over_errors",
 };
 
-#define RAVB_STATS_LEN	ARRAY_SIZE(ravb_gstrings_stats)
-
 static int ravb_get_sset_count(struct net_device *netdev, int sset)
 {
+	struct ravb_private *priv = netdev_priv(netdev);
+	const struct ravb_hw_info *info = priv->info;
+
 	switch (sset) {
 	case ETH_SS_STATS:
-		return RAVB_STATS_LEN;
+		return info->stats_len;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1926,11 +1927,13 @@ static int ravb_mdio_release(struct ravb_private *priv)
 
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.chip_id = RCAR_GEN3,
+	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.chip_id = RCAR_GEN2,
+	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
 };
-- 
2.17.1

