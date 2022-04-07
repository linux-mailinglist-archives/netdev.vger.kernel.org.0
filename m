Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B144F807A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiDGN20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 09:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiDGN2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 09:28:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BB5EBAF5;
        Thu,  7 Apr 2022 06:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DEDA612E7;
        Thu,  7 Apr 2022 13:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB49C385A4;
        Thu,  7 Apr 2022 13:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649337983;
        bh=erBJ0JV2fhHFMqGKNptNKRo3neyxVGLELAUAeXYtWtk=;
        h=From:To:Cc:Subject:Date:From;
        b=X/sqENeziCwdcnj14lsc8fogNSX8411vFdwoKjUbwJCEY43bY9rj8rrH4UnYtMZXX
         VwgcCZBS9kQOzFuNS1w9gi6XQvfUpYKzcUr0SG8APWdfRTvnyU3Jfo8cW1E9RoX3h3
         fzZbiEq99/d/HQk/33mNdy479/rScfUNwn5fNm6kQNAoLUEwhHOfVbmwlkk0LUgSh5
         sEXCAUaUT+SW3/+c1tEOnKQNKC/5ISWW93S9ChrV1RDC75fWMJTLYM/RmD2UbSeF1V
         ioQ4r86TdhjTLFZKQeorC4W6bsZcVzxgSS9Zbk4H+TjI4MrrlfYtmjaWxoRjFCJZrM
         Bl0DACw8n748g==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     davem@davemloft.net
Cc:     dinguyen@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com
Subject: [PATCH] net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link
Date:   Thu,  7 Apr 2022 08:25:21 -0500
Message-Id: <20220407132521.579713-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using a fixed-link, the altr_tse_pcs driver crashes
due to null-pointer dereference as no phy_device is provided to
tse_pcs_fix_mac_speed function. Fix this by adding a check for
phy_dev before calling the tse_pcs_fix_mac_speed() function.

Also clean up the tse_pcs_fix_mac_speed function a bit. There is
no need to check for splitter_base and sgmii_adapter_base
because the driver will fail if these 2 variables are not
derived from the device tree.

Fixes: fb3bbdb85989 ("net: ethernet: Add TSE PCS support to dwmac-socfpga")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c  |  8 --------
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h  |  4 ++++
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 13 +++++--------
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
index cd478d2cd871..00f6d347eaf7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
@@ -57,10 +57,6 @@
 #define TSE_PCS_USE_SGMII_ENA				BIT(0)
 #define TSE_PCS_IF_USE_SGMII				0x03
 
-#define SGMII_ADAPTER_CTRL_REG				0x00
-#define SGMII_ADAPTER_DISABLE				0x0001
-#define SGMII_ADAPTER_ENABLE				0x0000
-
 #define AUTONEGO_LINK_TIMER				20
 
 static int tse_pcs_reset(void __iomem *base, struct tse_pcs *pcs)
@@ -202,12 +198,8 @@ void tse_pcs_fix_mac_speed(struct tse_pcs *pcs, struct phy_device *phy_dev,
 			   unsigned int speed)
 {
 	void __iomem *tse_pcs_base = pcs->tse_pcs_base;
-	void __iomem *sgmii_adapter_base = pcs->sgmii_adapter_base;
 	u32 val;
 
-	writew(SGMII_ADAPTER_ENABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-
 	pcs->autoneg = phy_dev->autoneg;
 
 	if (phy_dev->autoneg == AUTONEG_ENABLE) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
index 442812c0a4bd..694ac25ef426 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
@@ -10,6 +10,10 @@
 #include <linux/phy.h>
 #include <linux/timer.h>
 
+#define SGMII_ADAPTER_CTRL_REG		0x00
+#define SGMII_ADAPTER_ENABLE		0x0000
+#define SGMII_ADAPTER_DISABLE		0x0001
+
 struct tse_pcs {
 	struct device *dev;
 	void __iomem *tse_pcs_base;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index b7c2579c963b..ac9e6c7a33b5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -18,9 +18,6 @@
 
 #include "altr_tse_pcs.h"
 
-#define SGMII_ADAPTER_CTRL_REG                          0x00
-#define SGMII_ADAPTER_DISABLE                           0x0001
-
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII 0x0
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII 0x1
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII 0x2
@@ -62,16 +59,14 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct socfpga_dwmac *dwmac = (struct socfpga_dwmac *)priv;
 	void __iomem *splitter_base = dwmac->splitter_base;
-	void __iomem *tse_pcs_base = dwmac->pcs.tse_pcs_base;
 	void __iomem *sgmii_adapter_base = dwmac->pcs.sgmii_adapter_base;
 	struct device *dev = dwmac->dev;
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct phy_device *phy_dev = ndev->phydev;
 	u32 val;
 
-	if ((tse_pcs_base) && (sgmii_adapter_base))
-		writew(SGMII_ADAPTER_DISABLE,
-		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	writew(SGMII_ADAPTER_DISABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 
 	if (splitter_base) {
 		val = readl(splitter_base + EMAC_SPLITTER_CTRL_REG);
@@ -93,7 +88,9 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 		writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
 	}
 
-	if (tse_pcs_base && sgmii_adapter_base)
+	writew(SGMII_ADAPTER_ENABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	if (phy_dev)
 		tse_pcs_fix_mac_speed(&dwmac->pcs, phy_dev, speed);
 }
 
-- 
2.25.1

