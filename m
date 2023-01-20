Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30B9674B2D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjATEtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjATEs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:48:59 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106AFCC5DF;
        Thu, 19 Jan 2023 20:43:07 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30K4g74S056583;
        Thu, 19 Jan 2023 22:42:07 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674189727;
        bh=VmPAiVtJ/5QjF3XOyBjiVoWGrQL4J0otBtfEwbji0q8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=qR0Tl9h1tHGooAIT/cyOXIjI+ar0uo/ccUsoxmPrRUtQ1mICXWsUpJojvwN5rU6AD
         7qSze15t8I8A8bopacqXcE9N/dv8uVZKIT4dmzRfcRXy5STUj8y8rZsAMO6Ps0F/78
         r4ysLkCsVXPrGEhRSicOOlluszhES8KJqVwnyNdc=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30K4g7YO075078
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Jan 2023 22:42:07 -0600
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 19
 Jan 2023 22:42:06 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 19 Jan 2023 22:42:06 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30K4g2vb104265;
        Thu, 19 Jan 2023 22:42:02 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <leon@kernel.org>
CC:     <leonro@nvidia.com>, <anthony.l.nguyen@intel.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH net-next v4 2/2] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action
Date:   Fri, 20 Jan 2023 10:12:01 +0530
Message-ID: <20230120044201.357950-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118095439.114222-3-s-vadapalli@ti.com>
References: <20230118095439.114222-3-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The am65_cpts_release() function is registered as a devm_action in the
am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
actions associated with the am65-cpsw driver's device.

In the event of probe failure or probe deferral, the platform_drv_probe()
function invokes dev_pm_domain_detach() which powers off the CPSW and the
CPSW's CPTS hardware, both of which share the same power domain. Since the
am65_cpts_disable() function invoked by the am65_cpts_release() function
attempts to reset the CPTS hardware by writing to its registers, the CPTS
hardware is assumed to be powered on at this point. However, the hardware
is powered off before the devm actions are executed.

Fix this by getting rid of the devm action for am65_cpts_release() and
invoking it directly on the cleanup and exit paths.

Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
---
Changes from v3:
1. Rebase patch on net-next commit: cff9b79e9ad5
2. Collect Reviewed-by tags from Leon Romanovsky, Tony Nguyen and
   Roger Quadros.

 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  2 ++
 drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
 drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index fde4800cf81a..b23027874cc4 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2914,6 +2914,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 err_free_phylink:
 	am65_cpsw_nuss_phylink_cleanup(common);
+	am65_cpts_release(common->cpts);
 err_of_clear:
 	of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
@@ -2942,6 +2943,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
 	am65_cpsw_nuss_phylink_cleanup(common);
+	am65_cpts_release(common->cpts);
 	am65_cpsw_disable_serdes_phy(common);
 
 	of_platform_device_destroy(common->mdio_dev, NULL);
diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index bf0f74b20ba6..16ee9c29cb35 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -1052,14 +1052,13 @@ static int am65_cpts_of_parse(struct am65_cpts *cpts, struct device_node *node)
 	return cpts_of_mux_clk_setup(cpts, node);
 }
 
-static void am65_cpts_release(void *data)
+void am65_cpts_release(struct am65_cpts *cpts)
 {
-	struct am65_cpts *cpts = data;
-
 	ptp_clock_unregister(cpts->ptp_clock);
 	am65_cpts_disable(cpts);
 	clk_disable_unprepare(cpts->refclk);
 }
+EXPORT_SYMBOL_GPL(am65_cpts_release);
 
 struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 				   struct device_node *node)
@@ -1139,18 +1138,12 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 	}
 	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
 
-	ret = devm_add_action_or_reset(dev, am65_cpts_release, cpts);
-	if (ret) {
-		dev_err(dev, "failed to add ptpclk reset action %d", ret);
-		return ERR_PTR(ret);
-	}
-
 	ret = devm_request_threaded_irq(dev, cpts->irq, NULL,
 					am65_cpts_interrupt,
 					IRQF_ONESHOT, dev_name(dev), cpts);
 	if (ret < 0) {
 		dev_err(cpts->dev, "error attaching irq %d\n", ret);
-		return ERR_PTR(ret);
+		goto reset_ptpclk;
 	}
 
 	dev_info(dev, "CPTS ver 0x%08x, freq:%u, add_val:%u pps:%d\n",
@@ -1159,6 +1152,8 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 
 	return cpts;
 
+reset_ptpclk:
+	am65_cpts_release(cpts);
 refclk_disable:
 	clk_disable_unprepare(cpts->refclk);
 	return ERR_PTR(ret);
diff --git a/drivers/net/ethernet/ti/am65-cpts.h b/drivers/net/ethernet/ti/am65-cpts.h
index bd08f4b2edd2..6e14df0be113 100644
--- a/drivers/net/ethernet/ti/am65-cpts.h
+++ b/drivers/net/ethernet/ti/am65-cpts.h
@@ -18,6 +18,7 @@ struct am65_cpts_estf_cfg {
 };
 
 #if IS_ENABLED(CONFIG_TI_K3_AM65_CPTS)
+void am65_cpts_release(struct am65_cpts *cpts);
 struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 				   struct device_node *node);
 int am65_cpts_phc_index(struct am65_cpts *cpts);
@@ -31,6 +32,10 @@ void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx);
 void am65_cpts_suspend(struct am65_cpts *cpts);
 void am65_cpts_resume(struct am65_cpts *cpts);
 #else
+static inline void am65_cpts_release(struct am65_cpts *cpts)
+{
+}
+
 static inline struct am65_cpts *am65_cpts_create(struct device *dev,
 						 void __iomem *regs,
 						 struct device_node *node)
-- 
2.25.1

