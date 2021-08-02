Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5C43DD3A9
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhHBK1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:27:52 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:51043 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233301AbhHBK1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:27:48 -0400
X-IronPort-AV: E=Sophos;i="5.84,288,1620658800"; 
   d="scan'208";a="89524153"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 02 Aug 2021 19:27:38 +0900
Received: from localhost.localdomain (unknown [10.226.92.138])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 803814006DF1;
        Mon,  2 Aug 2021 19:27:33 +0900 (JST)
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
Subject: [PATCH net-next v2 6/8] ravb: Add net_features and net_hw_features to struct ravb_hw_info
Date:   Mon,  2 Aug 2021 11:26:52 +0100
Message-Id: <20210802102654.5996-7-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
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
---
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      |  2 ++
 drivers/net/ethernet/renesas/ravb_main.c | 12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index b765b2b7d9e9..3df813b2e253 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -991,6 +991,8 @@ enum ravb_chip_id {
 struct ravb_hw_info {
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
+	netdev_features_t net_hw_features;
+	netdev_features_t net_features;
 	enum ravb_chip_id chip_id;
 	int num_gstat_queue;
 	int num_tx_desc;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 7a69668cb512..2ac962b5b8fb 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1932,6 +1932,8 @@ static int ravb_mdio_release(struct ravb_private *priv)
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
+	.net_hw_features = NETIF_F_RXCSUM,
+	.net_features = NETIF_F_RXCSUM,
 	.chip_id = RCAR_GEN3,
 	.num_gstat_queue = NUM_RX_QUEUE,
 	.num_tx_desc = NUM_TX_DESC_GEN3,
@@ -1942,6 +1944,8 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
+	.net_hw_features = NETIF_F_RXCSUM,
+	.net_features = NETIF_F_RXCSUM,
 	.chip_id = RCAR_GEN2,
 	.num_gstat_queue = NUM_RX_QUEUE,
 	.num_tx_desc = NUM_TX_DESC_GEN2,
@@ -2077,14 +2081,14 @@ static int ravb_probe(struct platform_device *pdev)
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

