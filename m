Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E97E9CDB
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 14:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfJ3N7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 09:59:53 -0400
Received: from forward101p.mail.yandex.net ([77.88.28.101]:54553 "EHLO
        forward101p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbfJ3N7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 09:59:53 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Oct 2019 09:59:51 EDT
Received: from mxback13g.mail.yandex.net (mxback13g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:92])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id 0EE433281C63;
        Wed, 30 Oct 2019 16:54:24 +0300 (MSK)
Received: from iva8-e1a842234f87.qloud-c.yandex.net (iva8-e1a842234f87.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:e1a8:4223])
        by mxback13g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id XdRHidBpFf-sMPCvR3M;
        Wed, 30 Oct 2019 16:54:24 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1572443664;
        bh=03l/30FMS82CFhGnplZOj90sCc7C0ySutIdyr15O1OE=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=AiTD+CrQA0BlduaOCrVqhA51GYC7+pFYVZNzPahTffxwT2yp/f1jxAO0OsCptER57
         i0XDdjHGO1m1UGOdrOA+aT5TQCDzCznmBa7/A6QHJRBGOhWDUPcxMmmJQzfFxdHnO5
         4jkYAfD/nmUhDNB+8SN5oESPThou7KTsLtjFoSVs=
Authentication-Results: mxback13g.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by iva8-e1a842234f87.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id iQ85YfuBaZ-sEUurF50;
        Wed, 30 Oct 2019 16:54:20 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        axboe@kernel.dk, peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, bhelgaas@google.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 2/5] net: stmmac: Split devicetree parse
Date:   Wed, 30 Oct 2019 21:53:44 +0800
Message-Id: <20191030135347.3636-3-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030135347.3636-1-jiaxun.yang@flygoat.com>
References: <20191030135347.3636-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCI based devices can share devicetree info parse with platform
device based devices after split dt parse frpm dt probe.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 63 ++++++++++++++-----
 .../ethernet/stmicro/stmmac/stmmac_platform.h |  3 +
 2 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 170c3a052b14..7e29bc76b7c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -385,25 +385,19 @@ static int stmmac_of_get_mac_mode(struct device_node *np)
 }
 
 /**
- * stmmac_probe_config_dt - parse device-tree driver parameters
- * @pdev: platform_device structure
- * @mac: MAC address to use
+ * stmmac_parse_config_dt - parse device-tree driver parameters
+ * @np: device_mode structure
+ * @plat: plat_stmmacenet_data structure
  * Description:
  * this function is to read the driver parameters from device-tree and
  * set some private fields that will be used by the main at runtime.
  */
-struct plat_stmmacenet_data *
-stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
+int stmmac_parse_config_dt(struct device_node *np,
+				struct plat_stmmacenet_data *plat)
 {
-	struct device_node *np = pdev->dev.of_node;
-	struct plat_stmmacenet_data *plat;
 	struct stmmac_dma_cfg *dma_cfg;
 	int rc;
 
-	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
-	if (!plat)
-		return ERR_PTR(-ENOMEM);
-
 	*mac = of_get_mac_address(np);
 	if (IS_ERR(*mac)) {
 		if (PTR_ERR(*mac) == -EPROBE_DEFER)
@@ -414,7 +408,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 
 	plat->phy_interface = of_get_phy_mode(np);
 	if (plat->phy_interface < 0)
-		return ERR_PTR(plat->phy_interface);
+		return plat->phy_interface;
 
 	plat->interface = stmmac_of_get_mac_mode(np);
 	if (plat->interface < 0)
@@ -453,7 +447,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	/* To Configure PHY by using all device-tree supported properties */
 	rc = stmmac_dt_phy(plat, np, &pdev->dev);
 	if (rc)
-		return ERR_PTR(rc);
+		return rc;
 
 	of_property_read_u32(np, "tx-fifo-depth", &plat->tx_fifo_size);
 
@@ -531,7 +525,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 			       GFP_KERNEL);
 	if (!dma_cfg) {
 		stmmac_remove_config_dt(pdev, plat);
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 	plat->dma_cfg = dma_cfg;
 
@@ -560,7 +554,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	rc = stmmac_mtl_setup(pdev, plat);
 	if (rc) {
 		stmmac_remove_config_dt(pdev, plat);
-		return ERR_PTR(rc);
+		return rc;
 	}
 
 	/* clock setup */
@@ -604,14 +598,43 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		plat->stmmac_rst = NULL;
 	}
 
-	return plat;
+	return 0;
 
 error_hw_init:
 	clk_disable_unprepare(plat->pclk);
 error_pclk_get:
 	clk_disable_unprepare(plat->stmmac_clk);
 
-	return ERR_PTR(-EPROBE_DEFER);
+	return -EPROBE_DEFER;
+}
+
+/**
+ * stmmac_probe_config_dt - probe and setup stmmac platform data by devicetree
+ * @pdev: platform_device structure
+ * @mac: MAC address to use
+ * Description:
+ * this function is to set up plat_stmmacenet_data  private structure
+ * for platform drivers.
+ */
+struct plat_stmmacenet_data *
+stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct plat_stmmacenet_data *plat;
+	int rc;
+
+	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
+	if (!plat)
+		return ERR_PTR(-ENOMEM);
+
+	rc = stmmac_parse_config_dt(np, plat);
+
+	if (rc) {
+		free(plat);
+		return ERR_PTR(rc);
+	}
+
+	return plat;
 }
 
 /**
@@ -628,6 +651,11 @@ void stmmac_remove_config_dt(struct platform_device *pdev,
 	of_node_put(plat->mdio_node);
 }
 #else
+int stmmac_parse_config_dt(struct device_node *np,
+				struct plat_stmmacenet_data *plat)
+{
+	return -EINVAL;
+}
 struct plat_stmmacenet_data *
 stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 {
@@ -639,6 +667,7 @@ void stmmac_remove_config_dt(struct platform_device *pdev,
 {
 }
 #endif /* CONFIG_OF */
+EXPORT_SYMBOL_GPL(stmmac_parse_config_dt);
 EXPORT_SYMBOL_GPL(stmmac_probe_config_dt);
 EXPORT_SYMBOL_GPL(stmmac_remove_config_dt);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
index 3a4663b7b460..0e4aec1f502a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
@@ -11,6 +11,9 @@
 
 #include "stmmac.h"
 
+int stmmac_parse_config_dt(struct device_node *np,
+				struct plat_stmmacenet_data *plat);
+
 struct plat_stmmacenet_data *
 stmmac_probe_config_dt(struct platform_device *pdev, const char **mac);
 void stmmac_remove_config_dt(struct platform_device *pdev,
-- 
2.23.0

