Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F5356142F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiF3IIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbiF3IHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:07:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C9941627;
        Thu, 30 Jun 2022 01:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656576472; x=1688112472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QRztPqLPpCR+G/Am0XR/jSeACTyPFrOzNB1djYsPfM4=;
  b=XV8NK5fJ5XHB5/aJUuPP5U9FvpKDlpHmXqr2/rLHzSKjq6RpACb2fE41
   cxTNeAj/8osH7E2lkJwesFtP5C94vkBSLRRYO+47gKQHPhiyHoKMvQdw/
   7itBCz7W/KOBlzGzB2wS2mVn+a/eU0WZwYUkoYQ/PkWGzlaDfJbeVed0u
   nKKPVhTmAH7tmlm41OG5Mpx3WrWSBmT6nYwQo93eO+2P7uqRoNSTT5Bo/
   thrCYl8enSmxoerhTlXPiXh7E/ZnNK9xBDvarq2aNn6lRN7fWAoap/tLy
   I8UeKt9Q5MR/ZS5OgSvTuXzA0fAx5cGSmBpRMJI4UQdX5gtxDoxC5hq/A
   g==;
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="102426685"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 01:07:51 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 01:07:51 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 01:07:47 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Daire McNamara" <daire.mcnamara@microchip.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>
Subject: [PATCH v1 06/14] net: macb: add polarfire soc reset support
Date:   Thu, 30 Jun 2022 09:05:25 +0100
Message-ID: <20220630080532.323731-7-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630080532.323731-1-conor.dooley@microchip.com>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To date, the Microchip PolarFire SoC (MPFS) has been using the
cdns,macb compatible, however the generic device does not have reset
support. Add a new compatible & .data for MPFS to hook into the reset
functionality added for zynqmp support (and make the zynqmp init
function generic in the process).

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 25 +++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d89098f4ede8..325f0463fd42 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4689,33 +4689,32 @@ static const struct macb_config np4_config = {
 	.usrio = &macb_default_usrio,
 };
 
-static int zynqmp_init(struct platform_device *pdev)
+static int init_reset_optional(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct macb *bp = netdev_priv(dev);
 	int ret;
 
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
-		/* Ensure PS-GTR PHY device used in SGMII mode is ready */
+		/* Ensure PHY device used in SGMII mode is ready */
 		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
 
 		if (IS_ERR(bp->sgmii_phy)) {
 			ret = PTR_ERR(bp->sgmii_phy);
 			dev_err_probe(&pdev->dev, ret,
-				      "failed to get PS-GTR PHY\n");
+				      "failed to get SGMII PHY\n");
 			return ret;
 		}
 
 		ret = phy_init(bp->sgmii_phy);
 		if (ret) {
-			dev_err(&pdev->dev, "failed to init PS-GTR PHY: %d\n",
+			dev_err(&pdev->dev, "failed to init SGMII PHY: %d\n",
 				ret);
 			return ret;
 		}
 	}
 
-	/* Fully reset GEM controller at hardware level using zynqmp-reset driver,
-	 * if mapped in device tree.
+	/* Fully reset controller at hardware level if mapped in device tree
 	 */
 	ret = device_reset_optional(&pdev->dev);
 	if (ret) {
@@ -4737,7 +4736,7 @@ static const struct macb_config zynqmp_config = {
 			MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
-	.init = zynqmp_init,
+	.init = init_reset_optional,
 	.jumbo_max_len = 10240,
 	.usrio = &macb_default_usrio,
 };
@@ -4751,6 +4750,17 @@ static const struct macb_config zynq_config = {
 	.usrio = &macb_default_usrio,
 };
 
+static const struct macb_config mpfs_config = {
+	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
+			MACB_CAPS_JUMBO |
+			MACB_CAPS_GEM_HAS_PTP,
+	.dma_burst_length = 16,
+	.clk_init = macb_clk_init,
+	.init = init_reset_optional,
+	.usrio = &macb_default_usrio,
+	.jumbo_max_len = 10240,
+};
+
 static const struct macb_config sama7g5_gem_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_CLK_HW_CHG |
 		MACB_CAPS_MIIONRGMII,
@@ -4787,6 +4797,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config},
 	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
 	{ .compatible = "sifive,fu540-c000-gem", .data = &fu540_c000_config },
+	{ .compatible = "microchip,mpfs-macb", .data = &mpfs_config },
 	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
 	{ .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
 	{ /* sentinel */ }
-- 
2.36.1

