Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5012335FE0
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbfFEPHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbfFEPHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 11:07:13 -0400
Received: from localhost.localdomain (cpe-70-114-128-244.austin.res.rr.com [70.114.128.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B66C20872;
        Wed,  5 Jun 2019 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559747232;
        bh=rJmtyvAPI31J7b9KWiJY6BZEgIOoCteKqJHOB5EZQUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+lnjH96pm9orER3kSLTnPC6vp3mnOnJDK0QyGbQoTsQ6Fa2JLvXYMVNcHaXpvTtV
         vGMrvy7agrXq2TyqtJotwrLLkvLDsGG9wybi1Ptl6LZttl4zXKY6IcuarVejwW58Nn
         gQMcQ6We48q7ahN8WyC/ebbo41y/EgRCYAGDSmBg=
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     netdev@vger.kernel.org
Cc:     dinguyen@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        davem@davemloft.net, dalon.westergreen@intel.com
Subject: [PATCH 2/2] net: stmmac: socfpga: fix phy and ptp_ref setup for Arria10/Stratix10
Date:   Wed,  5 Jun 2019 10:05:51 -0500
Message-Id: <20190605150551.12791-2-dinguyen@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190605150551.12791-1-dinguyen@kernel.org>
References: <20190605150551.12791-1-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the Arria10, Agilex, and Stratix10 SoC, there are a few differences from
the Cyclone5 and Arria5:
 - The emac PHY setup bits are in separate registers.
 - The PTP reference clock select mask is different.
 - The register to enable the emac signal from FPGA is different.

Thus, this patch creates a separate function for setting the phy modes on
Arria10/Agilex/Stratix10. The separation is based a new DTS binding:
"altr,socfpga-stmmac-a10-s10".

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   | 117 ++++++++++++++++--
 1 file changed, 104 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 75a6471db76c..d939f7b99b94 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -38,9 +38,12 @@
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_WIDTH 2
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_MASK 0x00000003
 #define SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK 0x00000010
+#define SYSMGR_GEN10_EMACGRP_CTRL_PTP_REF_CLK_MASK 0x00000100
 
 #define SYSMGR_FPGAGRP_MODULE_REG  0x00000028
 #define SYSMGR_FPGAGRP_MODULE_EMAC 0x00000004
+#define SYSMGR_FPGAINTF_EMAC_REG	0x00000070
+#define SYSMGR_FPGAINTF_EMAC_BIT	0x1
 
 #define EMAC_SPLITTER_CTRL_REG			0x0
 #define EMAC_SPLITTER_CTRL_SPEED_MASK		0x3
@@ -48,6 +51,11 @@
 #define EMAC_SPLITTER_CTRL_SPEED_100		0x3
 #define EMAC_SPLITTER_CTRL_SPEED_1000		0x0
 
+struct socfpga_dwmac;
+struct socfpga_dwmac_ops {
+	int (*set_phy_mode)(struct socfpga_dwmac *dwmac_priv);
+};
+
 struct socfpga_dwmac {
 	int	interface;
 	u32	reg_offset;
@@ -59,6 +67,7 @@ struct socfpga_dwmac {
 	void __iomem *splitter_base;
 	bool f2h_ptp_ref_clk;
 	struct tse_pcs pcs;
+	const struct socfpga_dwmac_ops *ops;
 };
 
 static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
@@ -233,28 +242,36 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 	return ret;
 }
 
-static int socfpga_dwmac_set_phy_mode(struct socfpga_dwmac *dwmac)
+static int socfpga_set_phy_mode_common(int phymode, u32 *val)
 {
-	struct regmap *sys_mgr_base_addr = dwmac->sys_mgr_base_addr;
-	int phymode = dwmac->interface;
-	u32 reg_offset = dwmac->reg_offset;
-	u32 reg_shift = dwmac->reg_shift;
-	u32 ctrl, val, module;
-
 	switch (phymode) {
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
-		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII;
+		*val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII;
 		break;
 	case PHY_INTERFACE_MODE_MII:
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_SGMII:
-		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII;
+		*val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII;
 		break;
 	case PHY_INTERFACE_MODE_RMII:
-		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII;
+		*val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII;
 		break;
 	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int socfpga_gen5_set_phy_mode(struct socfpga_dwmac *dwmac)
+{
+	struct regmap *sys_mgr_base_addr = dwmac->sys_mgr_base_addr;
+	int phymode = dwmac->interface;
+	u32 reg_offset = dwmac->reg_offset;
+	u32 reg_shift = dwmac->reg_shift;
+	u32 ctrl, val, module;
+
+	if (socfpga_set_phy_mode_common(phymode, &val)) {
 		dev_err(dwmac->dev, "bad phy mode %d\n", phymode);
 		return -EINVAL;
 	}
@@ -305,6 +322,62 @@ static int socfpga_dwmac_set_phy_mode(struct socfpga_dwmac *dwmac)
 	return 0;
 }
 
+static int socfpga_gen10_set_phy_mode(struct socfpga_dwmac *dwmac)
+{
+	struct regmap *sys_mgr_base_addr = dwmac->sys_mgr_base_addr;
+	int phymode = dwmac->interface;
+	u32 reg_offset = dwmac->reg_offset;
+	u32 reg_shift = dwmac->reg_shift;
+	u32 ctrl, val, module;
+
+	if (socfpga_set_phy_mode_common(phymode, &val))
+		return -EINVAL;
+
+	/* Overwrite val to GMII if splitter core is enabled. The phymode here
+	 * is the actual phy mode on phy hardware, but phy interface from
+	 * EMAC core is GMII.
+	 */
+	if (dwmac->splitter_base)
+		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII;
+
+	/* Assert reset to the enet controller before changing the phy mode */
+	reset_control_assert(dwmac->stmmac_ocp_rst);
+	reset_control_assert(dwmac->stmmac_rst);
+
+	regmap_read(sys_mgr_base_addr, reg_offset, &ctrl);
+	ctrl &= ~(SYSMGR_EMACGRP_CTRL_PHYSEL_MASK);
+	ctrl |= val;
+
+	if (dwmac->f2h_ptp_ref_clk ||
+	    phymode == PHY_INTERFACE_MODE_MII ||
+	    phymode == PHY_INTERFACE_MODE_GMII ||
+	    phymode == PHY_INTERFACE_MODE_SGMII) {
+		ctrl |= SYSMGR_GEN10_EMACGRP_CTRL_PTP_REF_CLK_MASK;
+		regmap_read(sys_mgr_base_addr, SYSMGR_FPGAINTF_EMAC_REG,
+			    &module);
+		module |= (SYSMGR_FPGAINTF_EMAC_BIT << reg_shift);
+		regmap_write(sys_mgr_base_addr, SYSMGR_FPGAINTF_EMAC_REG,
+			     module);
+	} else {
+		ctrl &= ~SYSMGR_GEN10_EMACGRP_CTRL_PTP_REF_CLK_MASK;
+	}
+
+	regmap_write(sys_mgr_base_addr, reg_offset, ctrl);
+
+	/* Deassert reset for the phy configuration to be sampled by
+	 * the enet controller, and operation to start in requested mode
+	 */
+	reset_control_deassert(dwmac->stmmac_ocp_rst);
+	reset_control_deassert(dwmac->stmmac_rst);
+	if (phymode == PHY_INTERFACE_MODE_SGMII) {
+		if (tse_pcs_init(dwmac->pcs.tse_pcs_base, &dwmac->pcs) != 0) {
+			dev_err(dwmac->dev, "Unable to initialize TSE PCS");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 static int socfpga_dwmac_probe(struct platform_device *pdev)
 {
 	struct plat_stmmacenet_data *plat_dat;
@@ -314,6 +387,13 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	struct socfpga_dwmac	*dwmac;
 	struct net_device	*ndev;
 	struct stmmac_priv	*stpriv;
+	const struct socfpga_dwmac_ops *ops;
+
+	ops = device_get_match_data(&pdev->dev);
+	if (!ops) {
+		dev_err(&pdev->dev, "no of match data provided\n");
+		return -EINVAL;
+	}
 
 	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
 	if (ret)
@@ -344,6 +424,7 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 		goto err_remove_config_dt;
 	}
 
+	dwmac->ops = ops;
 	plat_dat->bsp_priv = dwmac;
 	plat_dat->fix_mac_speed = socfpga_dwmac_fix_mac_speed;
 
@@ -360,7 +441,7 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	 */
 	dwmac->stmmac_rst = stpriv->plat->stmmac_rst;
 
-	ret = socfpga_dwmac_set_phy_mode(dwmac);
+	ret = ops->set_phy_mode(dwmac);
 	if (ret)
 		goto err_dvr_remove;
 
@@ -379,8 +460,9 @@ static int socfpga_dwmac_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct socfpga_dwmac *dwmac_priv = get_stmmac_bsp_priv(dev);
 
-	socfpga_dwmac_set_phy_mode(priv->plat->bsp_priv);
+	dwmac_priv->ops->set_phy_mode(priv->plat->bsp_priv);
 
 	/* Before the enet controller is suspended, the phy is suspended.
 	 * This causes the phy clock to be gated. The enet controller is
@@ -407,8 +489,17 @@ static int socfpga_dwmac_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(socfpga_dwmac_pm_ops, stmmac_suspend,
 					       socfpga_dwmac_resume);
 
+static const struct socfpga_dwmac_ops socfpga_gen5_ops = {
+	.set_phy_mode = socfpga_gen5_set_phy_mode,
+};
+
+static const struct socfpga_dwmac_ops socfpga_gen10_ops = {
+	.set_phy_mode = socfpga_gen10_set_phy_mode,
+};
+
 static const struct of_device_id socfpga_dwmac_match[] = {
-	{ .compatible = "altr,socfpga-stmmac" },
+	{ .compatible = "altr,socfpga-stmmac", .data = &socfpga_gen5_ops },
+	{ .compatible = "altr,socfpga-stmmac-a10-s10", .data = &socfpga_gen10_ops },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, socfpga_dwmac_match);
-- 
2.20.0

