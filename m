Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2093F0B96
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhHRTJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:09:29 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:14414 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233896AbhHRTJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:09:12 -0400
X-IronPort-AV: E=Sophos;i="5.84,332,1620658800"; 
   d="scan'208";a="91033577"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 19 Aug 2021 04:08:34 +0900
Received: from localhost.localdomain (unknown [10.226.93.61])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id EEBF740D5D67;
        Thu, 19 Aug 2021 04:08:30 +0900 (JST)
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
Subject: [PATCH net-next v3 7/9] ravb: Add net_features and net_hw_features to struct ravb_hw_info
Date:   Wed, 18 Aug 2021 20:07:58 +0100
Message-Id: <20210818190800.20191-8-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On R-Car the checksum calculation on RX frames is done by the E-MAC
module, whereas on RZ/G2L it is done by the TOE.

TOE calculates the checksum of received frames from E-MAC and outputs it to
DMAC. TOE also calculates the checksum of transmission frames from DMAC and
outputs it E-MAC.

Add net_features and net_hw_features to struct ravb_hw_info, to support
subsequent SoCs without any code changes in the ravb_probe function.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
---
v2->v3:
 * No Change
 * Added Rb tag from Andrew and Sergei.
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      |  2 ++
 drivers/net/ethernet/renesas/ravb_main.c | 12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 69256d7c5ee7..85eb3c69ac32 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -991,6 +991,8 @@ enum ravb_chip_id {
 struct ravb_hw_info {
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
+	netdev_features_t net_hw_features;
+	netdev_features_t net_features;
 	enum ravb_chip_id chip_id;
 	int stats_len;
 	size_t max_rx_len;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 48d24cd4e71d..6b209ad19de7 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1931,6 +1931,8 @@ static int ravb_mdio_release(struct ravb_private *priv)
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
+	.net_hw_features = NETIF_F_RXCSUM,
+	.net_features = NETIF_F_RXCSUM,
 	.chip_id = RCAR_GEN3,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
@@ -1939,6 +1941,8 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
+	.net_hw_features = NETIF_F_RXCSUM,
+	.net_features = NETIF_F_RXCSUM,
 	.chip_id = RCAR_GEN2,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
@@ -2062,14 +2066,14 @@ static int ravb_probe(struct platform_device *pdev)
 	if (!ndev)
 		return -ENOMEM;
 
-	ndev->features = NETIF_F_RXCSUM;
-	ndev->hw_features = NETIF_F_RXCSUM;
+	info = of_device_get_match_data(&pdev->dev);
+
+	ndev->features = info->net_features;
+	ndev->hw_features = info->net_hw_features;
 
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	info = of_device_get_match_data(&pdev->dev);
-
 	if (info->chip_id == RCAR_GEN3)
 		irq = platform_get_irq_byname(pdev, "ch22");
 	else
-- 
2.17.1

