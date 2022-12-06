Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E04A64401A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiLFJpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiLFJol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:44:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4AF1DDCE;
        Tue,  6 Dec 2022 01:44:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0132B818DC;
        Tue,  6 Dec 2022 09:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2872C433D6;
        Tue,  6 Dec 2022 09:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670319875;
        bh=YUV//X6HxHjXUQ1u7/m0WgbXNCSgLyJRZ3XKO02tN/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uN7AS7+plpDJKhxaAzhxi4VHVpFHL7ZPMikxwAhj7G1XnfZWeyTB83BnMpW4OwDyu
         /r/zv8zs5hRR2x8utaoKBS68jB6qUCTVnzZWvS1LOzAM1zhQChEVmum+X7yUf6yeeQ
         CD2rICOrj/h++ZAoRhgWRalePMLFaWyVfhcW7+mY3efhQ71x3WJBRdkW9shE4R91a7
         zHBK+7l8e9oB1s8XCc88R6T9RnDuDpkzmTGlgBZ2rv/1tgPV7nX0je465Ep9r9BVg7
         bAAFgZ2BOBRm/Yk5wsL3Wicd1t4EWuYDBeMzlp+kRuumfV5VCvY4mTzTYddJDTSE8T
         vrSlMgt+vqTQQ==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v5 net-next 3/6] Revert "net: ethernet: ti: am65-cpsw: Add suspend/resume support"
Date:   Tue,  6 Dec 2022 11:44:16 +0200
Message-Id: <20221206094419.19478-4-rogerq@kernel.org>
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

This reverts commit fd23df72f2be317d38d9fde0a8996b8e7454fd2a.

This commit broke set channel operation. Revert this and
implement it with a different approach in a separate patch.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 221 ++++++-----------------
 1 file changed, 55 insertions(+), 166 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 04e673902d53..4836960b0dd8 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -24,7 +24,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
-#include <linux/rtnetlink.h>
 #include <linux/mfd/syscon.h>
 #include <linux/sys_soc.h>
 #include <linux/dma/ti-cppi5.h>
@@ -133,11 +132,6 @@
 			 NETIF_MSG_IFUP	| NETIF_MSG_PROBE | NETIF_MSG_IFDOWN | \
 			 NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
 
-static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common);
-static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common);
-static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common);
-static void am65_cpsw_nuss_free_rx_chns(struct am65_cpsw_common *common);
-
 static void am65_cpsw_port_set_sl_mac(struct am65_cpsw_port *slave,
 				      const u8 *dev_addr)
 {
@@ -379,20 +373,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	if (common->usage_count)
 		return 0;
 
-	/* init tx/rx channels */
-	ret = am65_cpsw_nuss_init_tx_chns(common);
-	if (ret) {
-		dev_err(common->dev, "init_tx_chns failed\n");
-		return ret;
-	}
-
-	ret = am65_cpsw_nuss_init_rx_chns(common);
-	if (ret) {
-		dev_err(common->dev, "init_rx_chns failed\n");
-		am65_cpsw_nuss_free_tx_chns(common);
-		return ret;
-	}
-
 	/* Control register */
 	writel(AM65_CPSW_CTL_P0_ENABLE | AM65_CPSW_CTL_P0_TX_CRC_REMOVE |
 	       AM65_CPSW_CTL_VLAN_AWARE | AM65_CPSW_CTL_P0_RX_PAD,
@@ -421,7 +401,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	/* disable priority elevation */
 	writel(0, common->cpsw_base + AM65_CPSW_REG_PTYPE);
 
-	cpsw_ale_control_set(common->ale, 0, ALE_CLEAR, 1);
 	cpsw_ale_start(common->ale);
 
 	/* limit to one RX flow only */
@@ -453,8 +432,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 						  GFP_KERNEL);
 		if (!skb) {
 			dev_err(common->dev, "cannot allocate skb\n");
-			ret = -ENOMEM;
-			goto err;
+			return -ENOMEM;
 		}
 
 		ret = am65_cpsw_nuss_rx_push(common, skb);
@@ -463,7 +441,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 				"cannot submit skb to channel rx, error %d\n",
 				ret);
 			kfree_skb(skb);
-			goto err;
+			return ret;
 		}
 		kmemleak_not_leak(skb);
 	}
@@ -472,7 +450,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		ret = k3_udma_glue_enable_tx_chn(common->tx_chns[i].tx_chn);
 		if (ret)
-			goto err;
+			return ret;
 		napi_enable(&common->tx_chns[i].napi_tx);
 	}
 
@@ -484,12 +462,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 
 	dev_dbg(common->dev, "cpsw_nuss started\n");
 	return 0;
-
-err:
-	am65_cpsw_nuss_free_tx_chns(common);
-	am65_cpsw_nuss_free_rx_chns(common);
-
-	return ret;
 }
 
 static void am65_cpsw_nuss_tx_cleanup(void *data, dma_addr_t desc_dma);
@@ -543,9 +515,6 @@ static int am65_cpsw_nuss_common_stop(struct am65_cpsw_common *common)
 	writel(0, common->cpsw_base + AM65_CPSW_REG_CTL);
 	writel(0, common->cpsw_base + AM65_CPSW_REG_STAT_PORT_EN);
 
-	am65_cpsw_nuss_free_tx_chns(common);
-	am65_cpsw_nuss_free_rx_chns(common);
-
 	dev_dbg(common->dev, "cpsw_nuss stopped\n");
 	return 0;
 }
@@ -586,29 +555,11 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	int ret, i;
-	u32 reg;
-	int tmo;
 
 	ret = pm_runtime_resume_and_get(common->dev);
 	if (ret < 0)
 		return ret;
 
-	/* Idle MAC port */
-	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
-
-	tmo = cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
-	dev_info(common->dev, "down msc_sl %08x tmo %d\n",
-		 cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS), tmo);
-
-	cpsw_sl_ctl_reset(port->slave.mac_sl);
-
-	/* soft reset MAC */
-	cpsw_sl_reg_write(port->slave.mac_sl, CPSW_SL_SOFT_RESET, 1);
-	mdelay(1);
-	reg = cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_SOFT_RESET);
-	if (reg)
-		dev_info(common->dev, "mac reset not yet done\n");
-
 	/* Notify the stack of the actual queue counts. */
 	ret = netif_set_real_num_tx_queues(ndev, common->tx_ch_num);
 	if (ret) {
@@ -1539,9 +1490,9 @@ static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
 	cpsw_sl_ctl_reset(port->slave.mac_sl);
 }
 
-static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common)
+static void am65_cpsw_nuss_free_tx_chns(void *data)
 {
-	struct device *dev = common->dev;
+	struct am65_cpsw_common *common = data;
 	int i;
 
 	for (i = 0; i < common->tx_ch_num; i++) {
@@ -1553,11 +1504,7 @@ static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common)
 		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
 			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
 
-		/* Don't clear tx_chn memory as we need to preserve
-		 * data between suspend/resume
-		 */
-		if (!(tx_chn->irq < 0))
-			devm_free_irq(dev, tx_chn->irq, tx_chn);
+		memset(tx_chn, 0, sizeof(*tx_chn));
 	}
 }
 
@@ -1566,10 +1513,12 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 	struct device *dev = common->dev;
 	int i;
 
+	devm_remove_action(dev, am65_cpsw_nuss_free_tx_chns, common);
+
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		if (!(tx_chn->irq < 0))
+		if (tx_chn->irq)
 			devm_free_irq(dev, tx_chn->irq, tx_chn);
 
 		netif_napi_del(&tx_chn->napi_tx);
@@ -1639,7 +1588,7 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 		}
 
 		tx_chn->irq = k3_udma_glue_tx_get_irq(tx_chn->tx_chn);
-		if (tx_chn->irq < 0) {
+		if (tx_chn->irq <= 0) {
 			dev_err(dev, "Failed to get tx dma irq %d\n",
 				tx_chn->irq);
 			goto err;
@@ -1648,36 +1597,25 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 		snprintf(tx_chn->tx_chn_name,
 			 sizeof(tx_chn->tx_chn_name), "%s-tx%d",
 			 dev_name(dev), tx_chn->id);
-
-		ret = devm_request_irq(dev, tx_chn->irq,
-				       am65_cpsw_nuss_tx_irq,
-				       IRQF_TRIGGER_HIGH,
-				       tx_chn->tx_chn_name, tx_chn);
-		if (ret) {
-			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
-				tx_chn->id, tx_chn->irq, ret);
-			tx_chn->irq = -EINVAL;
-			goto err;
-		}
 	}
 
-	return 0;
-
 err:
-	am65_cpsw_nuss_free_tx_chns(common);
+	i = devm_add_action(dev, am65_cpsw_nuss_free_tx_chns, common);
+	if (i) {
+		dev_err(dev, "Failed to add free_tx_chns action %d\n", i);
+		return i;
+	}
 
 	return ret;
 }
 
-static void am65_cpsw_nuss_free_rx_chns(struct am65_cpsw_common *common)
+static void am65_cpsw_nuss_free_rx_chns(void *data)
 {
+	struct am65_cpsw_common *common = data;
 	struct am65_cpsw_rx_chn *rx_chn;
 
 	rx_chn = &common->rx_chns;
 
-	if (!(rx_chn->irq < 0))
-		devm_free_irq(common->dev, rx_chn->irq, common);
-
 	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
 		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
 
@@ -1700,7 +1638,7 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 
 	rx_cfg.swdata_size = AM65_CPSW_NAV_SW_DATA_SIZE;
 	rx_cfg.flow_id_num = AM65_CPSW_MAX_RX_FLOWS;
-	rx_cfg.flow_id_base = -1;
+	rx_cfg.flow_id_base = common->rx_flow_id_base;
 
 	/* init all flows */
 	rx_chn->dev = dev;
@@ -1772,20 +1710,12 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 		}
 	}
 
-	ret = devm_request_irq(dev, rx_chn->irq,
-			       am65_cpsw_nuss_rx_irq,
-			       IRQF_TRIGGER_HIGH, dev_name(dev), common);
-	if (ret) {
-		dev_err(dev, "failure requesting rx irq %u, %d\n",
-			rx_chn->irq, ret);
-		rx_chn->irq = -EINVAL;
-		goto err;
-	}
-
-	return 0;
-
 err:
-	am65_cpsw_nuss_free_rx_chns(common);
+	i = devm_add_action(dev, am65_cpsw_nuss_free_rx_chns, common);
+	if (i) {
+		dev_err(dev, "Failed to add free_rx_chns action %d\n", i);
+		return i;
+	}
 
 	return ret;
 }
@@ -2051,7 +1981,6 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	port->slave.phylink_config.dev = &port->ndev->dev;
 	port->slave.phylink_config.type = PHYLINK_NETDEV;
 	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
-	port->slave.phylink_config.mac_managed_pm = true; /* MAC does PM */
 
 	if (phy_interface_mode_is_rgmii(port->slave.phy_if)) {
 		phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
@@ -2113,16 +2042,28 @@ static int am65_cpsw_nuss_init_ndevs(struct am65_cpsw_common *common)
 
 static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common)
 {
-	int i;
+	struct device *dev = common->dev;
+	int i, ret = 0;
 
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
 		netif_napi_add_tx(common->dma_ndev, &tx_chn->napi_tx,
 				  am65_cpsw_nuss_tx_poll);
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
 	}
 
-	return 0;
+err:
+	return ret;
 }
 
 static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
@@ -2591,6 +2532,15 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 	if (ret)
 		return ret;
 
+	ret = devm_request_irq(dev, common->rx_chns.irq,
+			       am65_cpsw_nuss_rx_irq,
+			       IRQF_TRIGGER_HIGH, dev_name(dev), common);
+	if (ret) {
+		dev_err(dev, "failure requesting rx irq %u, %d\n",
+			common->rx_chns.irq, ret);
+		return ret;
+	}
+
 	ret = am65_cpsw_nuss_register_devlink(common);
 	if (ret)
 		return ret;
@@ -2744,6 +2694,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	if (common->port_num < 1 || common->port_num > AM65_CPSW_MAX_PORTS)
 		return -ENOENT;
 
+	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
 	common->tx_ch_num = 1;
 	common->pf_p0_rx_ptype_rrobin = false;
@@ -2785,6 +2736,14 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 	am65_cpsw_nuss_get_ver(common);
 
+	/* init tx channels */
+	ret = am65_cpsw_nuss_init_tx_chns(common);
+	if (ret)
+		goto err_of_clear;
+	ret = am65_cpsw_nuss_init_rx_chns(common);
+	if (ret)
+		goto err_of_clear;
+
 	ret = am65_cpsw_nuss_init_host_p(common);
 	if (ret)
 		goto err_of_clear;
@@ -2869,80 +2828,10 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int am65_cpsw_nuss_suspend(struct device *dev)
-{
-	struct am65_cpsw_common *common = dev_get_drvdata(dev);
-	struct am65_cpsw_port *port;
-	struct net_device *ndev;
-	int i, ret;
-
-	for (i = 0; i < common->port_num; i++) {
-		port = &common->ports[i];
-		ndev = port->ndev;
-
-		if (!ndev)
-			continue;
-
-		netif_device_detach(ndev);
-		if (netif_running(ndev)) {
-			rtnl_lock();
-			ret = am65_cpsw_nuss_ndo_slave_stop(ndev);
-			rtnl_unlock();
-			if (ret < 0) {
-				netdev_err(ndev, "failed to stop: %d", ret);
-				return ret;
-			}
-		}
-	}
-
-	am65_cpts_suspend(common->cpts);
-
-	return 0;
-}
-
-static int am65_cpsw_nuss_resume(struct device *dev)
-{
-	struct am65_cpsw_common *common = dev_get_drvdata(dev);
-	struct am65_cpsw_port *port;
-	struct net_device *ndev;
-	int i, ret;
-
-	am65_cpts_resume(common->cpts);
-
-	for (i = 0; i < common->port_num; i++) {
-		port = &common->ports[i];
-		ndev = port->ndev;
-
-		if (!ndev)
-			continue;
-
-		if (netif_running(ndev)) {
-			rtnl_lock();
-			ret = am65_cpsw_nuss_ndo_slave_open(ndev);
-			rtnl_unlock();
-			if (ret < 0) {
-				netdev_err(ndev, "failed to start: %d", ret);
-				return ret;
-			}
-		}
-
-		netif_device_attach(ndev);
-	}
-
-	return 0;
-}
-#endif /* CONFIG_PM_SLEEP */
-
-static const struct dev_pm_ops am65_cpsw_nuss_dev_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(am65_cpsw_nuss_suspend, am65_cpsw_nuss_resume)
-};
-
 static struct platform_driver am65_cpsw_nuss_driver = {
 	.driver = {
 		.name	 = AM65_CPSW_DRV_NAME,
 		.of_match_table = am65_cpsw_nuss_of_mtable,
-		.pm = &am65_cpsw_nuss_dev_pm_ops,
 	},
 	.probe = am65_cpsw_nuss_probe,
 	.remove = am65_cpsw_nuss_remove,
-- 
2.17.1

