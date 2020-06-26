Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9566920B7F0
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgFZSRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:17:39 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:48620 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgFZSRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:17:34 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHLZ1002436;
        Fri, 26 Jun 2020 13:17:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593195441;
        bh=BNg+DQH/3TSrqnuqngB8EXZIV8fz3RCqpdutiE3KweQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=igXLvPGbyjxH+HFjg2vIA5Gby6uJ8R/ukJ4qN28rnhHe4QQNNPEVKscRbnLXLOrAa
         GX2hlYKwGhINjUajwP3/VEemWYQVRRUHRGz7n8e/WbpJvowoxSECg14RVoFLZo73At
         rIqsxgOD2O2Mosipsy5tfFsz2/tRGlSoPubpEj/c=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHLhW004381;
        Fri, 26 Jun 2020 13:17:21 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 26
 Jun 2020 13:17:21 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 26 Jun 2020 13:17:21 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHKcE081657;
        Fri, 26 Jun 2020 13:17:21 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 6/6] net: ethernet: ti: am65-cpsw-nuss: enable am65x sr2.0 support
Date:   Fri, 26 Jun 2020 21:17:09 +0300
Message-ID: <20200626181709.22635-7-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626181709.22635-1-grygorii.strashko@ti.com>
References: <20200626181709.22635-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AM65x SR2.0 MCU CPSW has fixed errata i2027 "CPSW: CPSW Does Not
Support CPPI Receive Checksum (Host to Ethernet) Offload Feature". This
errata also fixed for J271E SoC.

Use SOC bus data for K3 SoC identification and apply i2027 errata w/a only
for the AM65x SR1.0 SoC.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 47 ++++++++++++++++++++----
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  2 +-
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 7a921a480f29..9fdcd90e8323 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -23,6 +23,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
+#include <linux/sys_soc.h>
 #include <linux/dma/ti-cppi5.h>
 #include <linux/dma/k3-udma-glue.h>
 
@@ -148,10 +149,11 @@ static void am65_cpsw_nuss_get_ver(struct am65_cpsw_common *common)
 	common->nuss_ver = readl(common->ss_base);
 	common->cpsw_ver = readl(common->cpsw_base);
 	dev_info(common->dev,
-		 "initializing am65 cpsw nuss version 0x%08X, cpsw version 0x%08X Ports: %u\n",
+		 "initializing am65 cpsw nuss version 0x%08X, cpsw version 0x%08X Ports: %u quirks:%08x\n",
 		common->nuss_ver,
 		common->cpsw_ver,
-		common->port_num + 1);
+		common->port_num + 1,
+		common->pdata.quirks);
 }
 
 void am65_cpsw_nuss_adjust_link(struct net_device *ndev)
@@ -1877,7 +1879,7 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
 
 	/* Disable TX checksum offload by default due to HW bug */
-	if (common->pdata->quirks & AM65_CPSW_QUIRK_I2027_NO_TX_CSUM)
+	if (common->pdata.quirks & AM65_CPSW_QUIRK_I2027_NO_TX_CSUM)
 		port->ndev->features &= ~NETIF_F_HW_CSUM;
 
 	ndev_priv->stats = netdev_alloc_pcpu_stats(struct am65_cpsw_ndev_stats);
@@ -1981,21 +1983,50 @@ static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
 	}
 }
 
+struct am65_cpsw_soc_pdata {
+	u32	quirks_dis;
+};
+
+static const struct am65_cpsw_soc_pdata am65x_soc_sr2_0 = {
+	.quirks_dis = AM65_CPSW_QUIRK_I2027_NO_TX_CSUM,
+};
+
+static const struct soc_device_attribute am65_cpsw_socinfo[] = {
+	{ .family = "AM65X",
+	  .revision = "SR2.0",
+	  .data = &am65x_soc_sr2_0
+	},
+	{/* sentinel */}
+};
+
 static const struct am65_cpsw_pdata am65x_sr1_0 = {
 	.quirks = AM65_CPSW_QUIRK_I2027_NO_TX_CSUM,
 };
 
-static const struct am65_cpsw_pdata j721e_sr1_0 = {
+static const struct am65_cpsw_pdata j721e_pdata = {
 	.quirks = 0,
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
-	{ .compatible = "ti,am654-cpsw-nuss", .data = &am65x_sr1_0 },
-	{ .compatible = "ti,j721e-cpsw-nuss", .data = &j721e_sr1_0 },
+	{ .compatible = "ti,am654-cpsw-nuss", .data = &am65x_sr1_0},
+	{ .compatible = "ti,j721e-cpsw-nuss", .data = &j721e_pdata},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, am65_cpsw_nuss_of_mtable);
 
+static void am65_cpsw_nuss_apply_socinfo(struct am65_cpsw_common *common)
+{
+	const struct soc_device_attribute *soc;
+
+	soc = soc_device_match(am65_cpsw_socinfo);
+	if (soc && soc->data) {
+		const struct am65_cpsw_soc_pdata *socdata = soc->data;
+
+		/* disable quirks */
+		common->pdata.quirks &= ~socdata->quirks_dis;
+	}
+}
+
 static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 {
 	struct cpsw_ale_params ale_params = { 0 };
@@ -2014,7 +2045,9 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	of_id = of_match_device(am65_cpsw_nuss_of_mtable, dev);
 	if (!of_id)
 		return -EINVAL;
-	common->pdata = of_id->data;
+	common->pdata = *(const struct am65_cpsw_pdata *)of_id->data;
+
+	am65_cpsw_nuss_apply_socinfo(common);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cpsw_nuss");
 	common->ss_base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 9faf4fb1409b..94f666ea0e53 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -82,7 +82,7 @@ struct am65_cpsw_pdata {
 struct am65_cpsw_common {
 	struct device		*dev;
 	struct device		*mdio_dev;
-	const struct am65_cpsw_pdata *pdata;
+	struct am65_cpsw_pdata	pdata;
 
 	void __iomem		*ss_base;
 	void __iomem		*cpsw_base;
-- 
2.17.1

