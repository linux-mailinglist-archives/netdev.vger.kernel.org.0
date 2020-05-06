Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EEF1C7910
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgEFSO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:14:26 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:34946 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbgEFSOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:14:25 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046IEHcu113080;
        Wed, 6 May 2020 13:14:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588788857;
        bh=20L7n6cKqltPv3wfvOhFIcwvOiMLy97rJd2UNg8HT1E=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=qKM3NlF2qKZBetc/pTXOWYjeoXLSZbW827xDp3o7pdGlZGVCL7Q3NjqTzvuy23Luw
         JywQPQZFTGs4ps5gqw8jZ039+A2XwTA733sCwAIgPvRBfls2YsqvQqRbVnazvnX2Xh
         kwQd0CFk8PxXEAM6TqKp5n/QCNPIeRihB+aHkVWw=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046IEHEV023467
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 13:14:17 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 13:14:17 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 13:14:17 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046IEGgc018766;
        Wed, 6 May 2020 13:14:16 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 1/3] net: ethernet: ti: am65-cpsw-nuss: use of_platform_device_create() for mdio
Date:   Wed, 6 May 2020 21:13:59 +0300
Message-ID: <20200506181401.28699-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506181401.28699-1-grygorii.strashko@ti.com>
References: <20200506181401.28699-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MCU CPSW expected to populate only MDIO device, but follow up patches
will add "compatible" property to the MCU CPSW CPTS node which will cause
creation of CPTS device and MCU CPSW init failure. Hence, switch to use
of_platform_device_create() instead of of_platform_populate() for MDIO
device population.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 24 ++++++++++++++++++------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  2 ++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index bb391286d89e..64c9eba3c32a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2030,10 +2030,21 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
-	/* We do not want to force this, as in some cases may not have child */
-	if (ret)
-		dev_warn(dev, "populating child nodes err:%d\n", ret);
+	node = of_get_child_by_name(dev->of_node, "mdio");
+	if (!node) {
+		dev_warn(dev, "MDIO node not found\n");
+	} else if (of_device_is_available(node)) {
+		struct platform_device *mdio_pdev;
+
+		mdio_pdev = of_platform_device_create(node, NULL, dev);
+		if (!mdio_pdev) {
+			ret = -ENODEV;
+			goto err_pm_clear;
+		}
+
+		common->mdio_dev =  &mdio_pdev->dev;
+	}
+	of_node_put(node);
 
 	am65_cpsw_nuss_get_ver(common);
 
@@ -2089,7 +2100,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	return 0;
 
 err_of_clear:
-	of_platform_depopulate(dev);
+	of_platform_device_destroy(common->mdio_dev, NULL);
+err_pm_clear:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 	return ret;
@@ -2114,7 +2126,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
 
-	of_platform_depopulate(dev);
+	of_platform_device_destroy(common->mdio_dev, NULL);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index b1cddfd05a45..8a6382188cb5 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/platform_device.h>
 
 struct am65_cpts;
 
@@ -76,6 +77,7 @@ struct am65_cpsw_pdata {
 
 struct am65_cpsw_common {
 	struct device		*dev;
+	struct device		*mdio_dev;
 	const struct am65_cpsw_pdata *pdata;
 
 	void __iomem		*ss_base;
-- 
2.17.1

