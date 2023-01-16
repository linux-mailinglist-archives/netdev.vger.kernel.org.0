Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863D166B6BC
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 05:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjAPEql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 23:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjAPEpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 23:45:53 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A857A26D;
        Sun, 15 Jan 2023 20:45:52 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30G4jMZe041321;
        Sun, 15 Jan 2023 22:45:22 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673844322;
        bh=B7H8aF71bS6Sz69AQiK3GFz08lgnJzSENqOOnco03DE=;
        h=From:To:CC:Subject:Date;
        b=NHYKZXGxjFuQbfnVbPsQhKHnL3In/Hyj4++ThccNsFxk9RKH0MKzHRaYgH/qRXsBX
         JKcejXmzPGgwyppK0MA+KJRfyX8OWD2o7e8zL17Azqz8TSa6KuhcJAO1lQX67RFh67
         lL1cATTugREPmZ25/9QAoSaj7pBZWsrsxsuLegmU=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30G4jM4M071874
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 15 Jan 2023 22:45:22 -0600
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Sun, 15
 Jan 2023 22:45:21 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Sun, 15 Jan 2023 22:45:22 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30G4jIP0115043;
        Sun, 15 Jan 2023 22:45:18 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH net-next v2] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action
Date:   Mon, 16 Jan 2023 10:15:17 +0530
Message-ID: <20230116044517.310461-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
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
Reviewed-by: Roger Quadros <rogerq@kernel.org>
---
Changes from v1:
1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
   error was reported by kernel test robot <lkp@intel.com> at:
   https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
2. Collect Reviewed-by tag from Roger Quadros.

v1:
https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/

 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  8 ++++++++
 drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
 drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 5cac98284184..00f25d8a026b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1913,6 +1913,12 @@ static int am65_cpsw_am654_get_efuse_macid(struct device_node *of_node,
 	return 0;
 }
 
+static void am65_cpsw_cpts_cleanup(struct am65_cpsw_common *common)
+{
+	if (IS_ENABLED(CONFIG_TI_K3_AM65_CPTS) && common->cpts)
+		am65_cpts_release(common->cpts);
+}
+
 static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
@@ -2917,6 +2923,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 err_free_phylink:
 	am65_cpsw_nuss_phylink_cleanup(common);
+	am65_cpsw_cpts_cleanup(common);
 err_of_clear:
 	of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
@@ -2945,6 +2952,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
 	am65_cpsw_nuss_phylink_cleanup(common);
+	am65_cpsw_cpts_cleanup(common);
 	am65_cpsw_disable_serdes_phy(common);
 
 	of_platform_device_destroy(common->mdio_dev, NULL);
diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 9535396b28cd..a297890152d9 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -929,14 +929,13 @@ static int am65_cpts_of_parse(struct am65_cpts *cpts, struct device_node *node)
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
@@ -1014,18 +1013,12 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
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
 
 	dev_info(dev, "CPTS ver 0x%08x, freq:%u, add_val:%u\n",
@@ -1034,6 +1027,8 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 
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

