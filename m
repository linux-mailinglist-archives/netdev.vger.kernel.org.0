Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3DD644013
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiLFJpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiLFJom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:44:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CF91B9CB;
        Tue,  6 Dec 2022 01:44:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E45EBB818E2;
        Tue,  6 Dec 2022 09:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181BCC43470;
        Tue,  6 Dec 2022 09:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670319878;
        bh=KwOC16sAb3gp7rYWDcKaZTwcztj1jlcYqvinDHQ6C00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMNxWSqe2VKpEtiPCe+S3UL5OOGMZ6vpunEmNil3pnKeVCw+jX5JFgywuCs0B+2rf
         onEM+3iTcL5mijhSlj3Ijh87YyFGMFA8oLKf0Q3UxY4D4MQpuGEAEwMp3M8CBW9l1r
         zPghL5fkgZtjF/BjhQa0IgY3CA25b30GY/RQhy4906PunEr1rTtUIAe+IO1ZxaH0fi
         ODV90cghurc4FQH9VFGmVnkxAkuvaS7Gtos0Om6/zci1WWyRSQVYy7szksl+DdVtlU
         cdFYVKkOTyBx9pTiQ2BV0mH4/tX758i7e+6CZytmMxm2MdeHE6OgbCfhV8J9klQEJF
         oLM1Mryy3BnjA==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v5 net-next 4/6] net: ethernet: ti: am65-cpsw: Add suspend/resume support
Date:   Tue,  6 Dec 2022 11:44:17 +0200
Message-Id: <20221206094419.19478-5-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221206094419.19478-1-rogerq@kernel.org>
References: <20221206094419.19478-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PM handlers for System suspend/resume.

As DMA driver doesn't yet support suspend/resume we free up
the DMA channels at suspend and acquire and initialize them
at resume.

In this revised approach we do not free the TX/RX IRQs at
am65_cpsw_nuss_common_stop() as it causes problems.
We will now free them only on .suspend() as we need to release
the DMA channels (as DMA looses context) and re-acquiring
them on .resume() may not necessarily give us the same
IRQs.

To make this easier:
- introduce am65_cpsw_nuss_remove_rx_chns() which is
   similar to am65_cpsw_nuss_remove_tx_chns(). These will
   be invoked in pm.suspend() to release the DMA channels
   and free up the IRQs.
- move napi_add() and request_irq() calls to
   am65_cpsw_nuss_init_rx/tx_chns() so we can invoke them
   in pm.resume() to acquire the DMA channels and IRQs.

As CPTS looses contect during suspend/resume, invoke the
necessary CPTS suspend/resume helpers.

ALE_CLEAR command is issued in cpsw_ale_start() so no need
to issue it before the call to cpsw_ale_start().

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 222 ++++++++++++++++++-----
 1 file changed, 173 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4836960b0dd8..d4618edd2f9c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
+#include <linux/rtnetlink.h>
 #include <linux/mfd/syscon.h>
 #include <linux/sys_soc.h>
 #include <linux/dma/ti-cppi5.h>
@@ -555,11 +556,26 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	int ret, i;
+	u32 reg;
 
 	ret = pm_runtime_resume_and_get(common->dev);
 	if (ret < 0)
 		return ret;
 
+	/* Idle MAC port */
+	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
+	cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
+	cpsw_sl_ctl_reset(port->slave.mac_sl);
+
+	/* soft reset MAC */
+	cpsw_sl_reg_write(port->slave.mac_sl, CPSW_SL_SOFT_RESET, 1);
+	mdelay(1);
+	reg = cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_SOFT_RESET);
+	if (reg) {
+		dev_err(common->dev, "soft RESET didn't complete\n");
+		return -ETIMEDOUT;
+	}
+
 	/* Notify the stack of the actual queue counts. */
 	ret = netif_set_real_num_tx_queues(ndev, common->tx_ch_num);
 	if (ret) {
@@ -1533,6 +1549,32 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 	}
 }
 
+static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common)
+{
+	struct device *dev = common->dev;
+	int i, ret = 0;
+
+	for (i = 0; i < common->tx_ch_num; i++) {
+		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
+
+		netif_napi_add_tx(common->dma_ndev, &tx_chn->napi_tx,
+				  am65_cpsw_nuss_tx_poll);
+
+		ret = devm_request_irq(dev, tx_chn->irq,
+				       am65_cpsw_nuss_tx_irq,
+				       IRQF_TRIGGER_HIGH,
+				       tx_chn->tx_chn_name, tx_chn);
+		if (ret) {
+			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
+				tx_chn->id, tx_chn->irq, ret);
+			goto err;
+		}
+	}
+
+err:
+	return ret;
+}
+
 static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 {
 	u32  max_desc_num = ALIGN(AM65_CPSW_MAX_TX_DESC, MAX_SKB_FRAGS);
@@ -1599,6 +1641,12 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 			 dev_name(dev), tx_chn->id);
 	}
 
+	ret = am65_cpsw_nuss_ndev_add_tx_napi(common);
+	if (ret) {
+		dev_err(dev, "Failed to add tx NAPI %d\n", ret);
+		goto err;
+	}
+
 err:
 	i = devm_add_action(dev, am65_cpsw_nuss_free_tx_chns, common);
 	if (i) {
@@ -1623,6 +1671,29 @@ static void am65_cpsw_nuss_free_rx_chns(void *data)
 		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
 }
 
+static void am65_cpsw_nuss_remove_rx_chns(void *data)
+{
+	struct am65_cpsw_common *common = data;
+	struct am65_cpsw_rx_chn *rx_chn;
+	struct device *dev = common->dev;
+
+	rx_chn = &common->rx_chns;
+	devm_remove_action(dev, am65_cpsw_nuss_free_rx_chns, common);
+
+	if (!(rx_chn->irq < 0))
+		devm_free_irq(dev, rx_chn->irq, common);
+
+	netif_napi_del(&common->napi_rx);
+
+	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
+		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
+
+	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
+		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
+
+	common->rx_flow_id_base = -1;
+}
+
 static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 {
 	struct am65_cpsw_rx_chn *rx_chn = &common->rx_chns;
@@ -1710,6 +1781,18 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 		}
 	}
 
+	netif_napi_add(common->dma_ndev, &common->napi_rx,
+		       am65_cpsw_nuss_rx_poll);
+
+	ret = devm_request_irq(dev, rx_chn->irq,
+			       am65_cpsw_nuss_rx_irq,
+			       IRQF_TRIGGER_HIGH, dev_name(dev), common);
+	if (ret) {
+		dev_err(dev, "failure requesting rx irq %u, %d\n",
+			rx_chn->irq, ret);
+		goto err;
+	}
+
 err:
 	i = devm_add_action(dev, am65_cpsw_nuss_free_rx_chns, common);
 	if (i) {
@@ -1981,6 +2064,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	port->slave.phylink_config.dev = &port->ndev->dev;
 	port->slave.phylink_config.type = PHYLINK_NETDEV;
 	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
+	port->slave.phylink_config.mac_managed_pm = true; /* MAC does PM */
 
 	if (phy_interface_mode_is_rgmii(port->slave.phy_if)) {
 		phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
@@ -2034,35 +2118,6 @@ static int am65_cpsw_nuss_init_ndevs(struct am65_cpsw_common *common)
 			return ret;
 	}
 
-	netif_napi_add(common->dma_ndev, &common->napi_rx,
-		       am65_cpsw_nuss_rx_poll);
-
-	return ret;
-}
-
-static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common)
-{
-	struct device *dev = common->dev;
-	int i, ret = 0;
-
-	for (i = 0; i < common->tx_ch_num; i++) {
-		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
-
-		netif_napi_add_tx(common->dma_ndev, &tx_chn->napi_tx,
-				  am65_cpsw_nuss_tx_poll);
-
-		ret = devm_request_irq(dev, tx_chn->irq,
-				       am65_cpsw_nuss_tx_irq,
-				       IRQF_TRIGGER_HIGH,
-				       tx_chn->tx_chn_name, tx_chn);
-		if (ret) {
-			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
-				tx_chn->id, tx_chn->irq, ret);
-			goto err;
-		}
-	}
-
-err:
 	return ret;
 }
 
@@ -2528,18 +2583,13 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 	struct am65_cpsw_port *port;
 	int ret = 0, i;
 
-	ret = am65_cpsw_nuss_ndev_add_tx_napi(common);
+	/* init tx channels */
+	ret = am65_cpsw_nuss_init_tx_chns(common);
 	if (ret)
 		return ret;
-
-	ret = devm_request_irq(dev, common->rx_chns.irq,
-			       am65_cpsw_nuss_rx_irq,
-			       IRQF_TRIGGER_HIGH, dev_name(dev), common);
-	if (ret) {
-		dev_err(dev, "failure requesting rx irq %u, %d\n",
-			common->rx_chns.irq, ret);
+	ret = am65_cpsw_nuss_init_rx_chns(common);
+	if (ret)
 		return ret;
-	}
 
 	ret = am65_cpsw_nuss_register_devlink(common);
 	if (ret)
@@ -2584,10 +2634,8 @@ int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx)
 
 	common->tx_ch_num = num_tx;
 	ret = am65_cpsw_nuss_init_tx_chns(common);
-	if (ret)
-		return ret;
 
-	return am65_cpsw_nuss_ndev_add_tx_napi(common);
+	return ret;
 }
 
 struct am65_cpsw_soc_pdata {
@@ -2736,14 +2784,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 	am65_cpsw_nuss_get_ver(common);
 
-	/* init tx channels */
-	ret = am65_cpsw_nuss_init_tx_chns(common);
-	if (ret)
-		goto err_of_clear;
-	ret = am65_cpsw_nuss_init_rx_chns(common);
-	if (ret)
-		goto err_of_clear;
-
 	ret = am65_cpsw_nuss_init_host_p(common);
 	if (ret)
 		goto err_of_clear;
@@ -2828,10 +2868,94 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int am65_cpsw_nuss_suspend(struct device *dev)
+{
+	struct am65_cpsw_common *common = dev_get_drvdata(dev);
+	struct am65_cpsw_port *port;
+	struct net_device *ndev;
+	int i, ret;
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+		ndev = port->ndev;
+
+		if (!ndev)
+			continue;
+
+		netif_device_detach(ndev);
+		if (netif_running(ndev)) {
+			rtnl_lock();
+			ret = am65_cpsw_nuss_ndo_slave_stop(ndev);
+			rtnl_unlock();
+			if (ret < 0) {
+				netdev_err(ndev, "failed to stop: %d", ret);
+				return ret;
+			}
+		}
+	}
+
+	am65_cpts_suspend(common->cpts);
+
+	am65_cpsw_nuss_remove_rx_chns(common);
+	am65_cpsw_nuss_remove_tx_chns(common);
+
+	return 0;
+}
+
+static int am65_cpsw_nuss_resume(struct device *dev)
+{
+	struct am65_cpsw_common *common = dev_get_drvdata(dev);
+	struct am65_cpsw_port *port;
+	struct net_device *ndev;
+	int i, ret;
+
+	ret = am65_cpsw_nuss_init_tx_chns(common);
+	if (ret)
+		return ret;
+	ret = am65_cpsw_nuss_init_rx_chns(common);
+	if (ret)
+		return ret;
+
+	/* If RX IRQ was disabled before suspend, keep it disabled */
+	if (common->rx_irq_disabled)
+		disable_irq(common->rx_chns.irq);
+
+	am65_cpts_resume(common->cpts);
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+		ndev = port->ndev;
+
+		if (!ndev)
+			continue;
+
+		if (netif_running(ndev)) {
+			rtnl_lock();
+			ret = am65_cpsw_nuss_ndo_slave_open(ndev);
+			rtnl_unlock();
+			if (ret < 0) {
+				netdev_err(ndev, "failed to start: %d", ret);
+				return ret;
+			}
+		}
+
+		netif_device_attach(ndev);
+	}
+
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static const struct dev_pm_ops am65_cpsw_nuss_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(am65_cpsw_nuss_suspend, am65_cpsw_nuss_resume)
+};
+
 static struct platform_driver am65_cpsw_nuss_driver = {
 	.driver = {
 		.name	 = AM65_CPSW_DRV_NAME,
 		.of_match_table = am65_cpsw_nuss_of_mtable,
+		.pm = &am65_cpsw_nuss_dev_pm_ops,
 	},
 	.probe = am65_cpsw_nuss_probe,
 	.remove = am65_cpsw_nuss_remove,
-- 
2.17.1

