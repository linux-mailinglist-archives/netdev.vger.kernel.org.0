Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49453E9CF6
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfJ3OBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:01:46 -0400
Received: from forward103j.mail.yandex.net ([5.45.198.246]:54056 "EHLO
        forward103j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbfJ3OBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:01:45 -0400
Received: from mxback7o.mail.yandex.net (mxback7o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::21])
        by forward103j.mail.yandex.net (Yandex) with ESMTP id E32C96741E8E;
        Wed, 30 Oct 2019 16:54:36 +0300 (MSK)
Received: from iva8-e1a842234f87.qloud-c.yandex.net (iva8-e1a842234f87.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:e1a8:4223])
        by mxback7o.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 48FFXf50Ah-sZN0FjPD;
        Wed, 30 Oct 2019 16:54:36 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1572443676;
        bh=j0qExup+mjN9/866l9U9/4+EErx2RZW+CoBkOGAlloM=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=dYPNLQ+JtpRNu+87bHmlt3SOg/VR93n/nw51idJw3BG9Xny4NRxHUQEHSIIYPtddE
         FwGOs9eALbIioCxlSgTBSVFvrOY1zCk6WQvy5alkktNQvqBrWamjW2FoY4uQ4AaGh3
         PeGd6tCV1HUjQNF/otycaUVpZoVvQtbThU0ORzb8=
Authentication-Results: mxback7o.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by iva8-e1a842234f87.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id iQ85YfuBaZ-sOUuwUUB;
        Wed, 30 Oct 2019 16:54:34 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        axboe@kernel.dk, peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, bhelgaas@google.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 3/5] net: stmmac: pci: Add Loongson GMAC
Date:   Wed, 30 Oct 2019 21:53:45 +0800
Message-Id: <20191030135347.3636-4-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030135347.3636-1-jiaxun.yang@flygoat.com>
References: <20191030135347.3636-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This device will be setup by parsing DeviceTree node
of pci device.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  | 52 ++++++++++++++++++-
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 292045f4581f..640a2a5b8d41 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -12,8 +12,11 @@
 #include <linux/clk-provider.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
 
 #include "stmmac.h"
+#include "stmmac_platform.h"
 
 /*
  * This struct is used to associate PCI Function of MAC controller on a board,
@@ -33,6 +36,7 @@ struct stmmac_pci_dmi_data {
 
 struct stmmac_pci_info {
 	int (*setup)(struct pci_dev *pdev, struct plat_stmmacenet_data *plat);
+	bool of_irq;
 };
 
 static int stmmac_pci_find_phy_addr(struct pci_dev *pdev,
@@ -444,6 +448,30 @@ static const struct stmmac_pci_info snps_gmac5_pci_info = {
 	.setup = snps_gmac5_default_data,
 };
 
+static int loongson_pci_of_setup(struct pci_dev *pdev,
+			struct plat_stmmacenet_data *plat)
+{
+	struct device_node  *np;
+	np = pci_device_to_OF_node(pdev);
+
+	if(!np) {
+		dev_err(&pdev->dev, "Unable to get OF node\n");
+		return -ENODEV;
+	}
+
+	if(!of_device_is_compatible(np, "loongson,pci-gmac")) {
+		dev_err(&pdev->dev, "Device compatible mismatch\n");
+		return -ENODEV;
+	}
+
+	return  stmmac_parse_config_dt(np, plat);
+}
+
+static const struct stmmac_pci_info loongson_of_pci_info = {
+	.setup = loongson_pci_of_setup,
+	.of_irq = true,
+};
+
 /**
  * stmmac_pci_probe
  *
@@ -508,8 +536,27 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 
 	memset(&res, 0, sizeof(res));
 	res.addr = pcim_iomap_table(pdev)[i];
-	res.wol_irq = pdev->irq;
-	res.irq = pdev->irq;
+
+	if(info->of_irq) {
+		struct device_node  *np;	
+		np = pci_device_to_OF_node(pdev);
+
+		res.irq = of_irq_get_byname(np, "macirq");
+		if (res.irq < 0)
+			return res.irq;
+		res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
+		if (res.wol_irq < 0) {
+		if (res.wol_irq == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		res.wol_irq = res.irq;
+		}
+		res.lpi_irq = of_irq_get_byname(np, "eth_lpi");
+		if (res.lpi_irq == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+	} else {
+		res.wol_irq = pdev->irq;
+		res.irq = pdev->irq;
+	}
 
 	return stmmac_dvr_probe(&pdev->dev, plat, &res);
 }
@@ -602,6 +649,7 @@ static const struct pci_device_id stmmac_id_table[] = {
 	STMMAC_DEVICE(INTEL, STMMAC_EHL_SGMII1G_ID, ehl_sgmii1g_pci_info),
 	STMMAC_DEVICE(INTEL, STMMAC_TGL_SGMII1G_ID, tgl_sgmii1g_pci_info),
 	STMMAC_DEVICE(SYNOPSYS, STMMAC_GMAC5_ID, snps_gmac5_pci_info),
+	STMMAC_DEVICE(LOONGSON,  PCI_DEVICE_ID_LOONGSON_GMAC, loongson_of_pci_info),
 	{}
 };
 
-- 
2.23.0

