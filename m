Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2781B6197B8
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiKDNXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiKDNX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:23:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5FC116E;
        Fri,  4 Nov 2022 06:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFED0621C5;
        Fri,  4 Nov 2022 13:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA01CC433B5;
        Fri,  4 Nov 2022 13:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667568203;
        bh=AJRG1F0KZBlWU86CntXsmLwGiM1W2ZH8BaiqNl/r0hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ym9s01HmsnMITeIy7D3ykW6ou4XhKBurS+9uvVhI1JgEcDsbfvK6pHQdFLWvApyhG
         FjQ37hxDnOAMqqUXutSjxgrgxHqBQK6/QhA1dg3lwU8xHbUbZMCSYdqMkqtDXWD8dL
         yg4ddhHyC7NYdM1Rw4dp7LyesiqQyvqwV/kWifwBeaIw/0fevj3tcrRakj/QO8/x61
         AYJGCuQ5UXjJR5jZMuNd0xRK760gqDbLWha663vGguFOszPpdJm1ek+H1yfMeE5hJE
         Wt8cWR5+kX5Gdt4uRTtfqvm8BIdDRWcSh7Fvh1FyMjix8q7Qh7BXziMzecZA3MpGq/
         yTNxdPNVhqM1A==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vigneshr@ti.com, vibhore@ti.com, srk@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 2/5] net: ethernet: ti: am65-cpsw: Add suspend/resume support
Date:   Fri,  4 Nov 2022 15:23:07 +0200
Message-Id: <20221104132310.31577-3-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104132310.31577-1-rogerq@kernel.org>
References: <20221104132310.31577-1-rogerq@kernel.org>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Move the init/free dma calls to ndo_open/close() hooks so
it is symmetric and easier to invoke from suspend/resume handler.

As CPTS looses contect during suspend/resume, invoke the
necessary CPTS suspend/resume helpers.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 221 +++++++++++++++++------
 1 file changed, 166 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index c50b137f92d7..057ca7a23306 100644
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
@@ -132,6 +133,11 @@
 			 NETIF_MSG_IFUP	| NETIF_MSG_PROBE | NETIF_MSG_IFDOWN | \
 			 NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
 
+static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common);
+static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common);
+static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common);
+static void am65_cpsw_nuss_free_rx_chns(struct am65_cpsw_common *common);
+
 static void am65_cpsw_port_set_sl_mac(struct am65_cpsw_port *slave,
 				      const u8 *dev_addr)
 {
@@ -373,6 +379,20 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	if (common->usage_count)
 		return 0;
 
+	/* init tx/rx channels */
+	ret = am65_cpsw_nuss_init_tx_chns(common);
+	if (ret) {
+		dev_err(common->dev, "init_tx_chns failed\n");
+		return ret;
+	}
+
+	ret = am65_cpsw_nuss_init_rx_chns(common);
+	if (ret) {
+		dev_err(common->dev, "init_rx_chns failed\n");
+		am65_cpsw_nuss_free_tx_chns(common);
+		return ret;
+	}
+
 	/* Control register */
 	writel(AM65_CPSW_CTL_P0_ENABLE | AM65_CPSW_CTL_P0_TX_CRC_REMOVE |
 	       AM65_CPSW_CTL_VLAN_AWARE | AM65_CPSW_CTL_P0_RX_PAD,
@@ -401,6 +421,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	/* disable priority elevation */
 	writel(0, common->cpsw_base + AM65_CPSW_REG_PTYPE);
 
+	cpsw_ale_control_set(common->ale, 0, ALE_CLEAR, 1);
 	cpsw_ale_start(common->ale);
 
 	/* limit to one RX flow only */
@@ -432,7 +453,8 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 						  GFP_KERNEL);
 		if (!skb) {
 			dev_err(common->dev, "cannot allocate skb\n");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err;
 		}
 
 		ret = am65_cpsw_nuss_rx_push(common, skb);
@@ -441,7 +463,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 				"cannot submit skb to channel rx, error %d\n",
 				ret);
 			kfree_skb(skb);
-			return ret;
+			goto err;
 		}
 		kmemleak_not_leak(skb);
 	}
@@ -450,7 +472,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		ret = k3_udma_glue_enable_tx_chn(common->tx_chns[i].tx_chn);
 		if (ret)
-			return ret;
+			goto err;
 		napi_enable(&common->tx_chns[i].napi_tx);
 	}
 
@@ -462,6 +484,12 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 
 	dev_dbg(common->dev, "cpsw_nuss started\n");
 	return 0;
+
+err:
+	am65_cpsw_nuss_free_tx_chns(common);
+	am65_cpsw_nuss_free_rx_chns(common);
+
+	return ret;
 }
 
 static void am65_cpsw_nuss_tx_cleanup(void *data, dma_addr_t desc_dma);
@@ -515,6 +543,9 @@ static int am65_cpsw_nuss_common_stop(struct am65_cpsw_common *common)
 	writel(0, common->cpsw_base + AM65_CPSW_REG_CTL);
 	writel(0, common->cpsw_base + AM65_CPSW_REG_STAT_PORT_EN);
 
+	am65_cpsw_nuss_free_tx_chns(common);
+	am65_cpsw_nuss_free_rx_chns(common);
+
 	dev_dbg(common->dev, "cpsw_nuss stopped\n");
 	return 0;
 }
@@ -555,11 +586,29 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	int ret, i;
+	u32 reg;
+	int tmo;
 
 	ret = pm_runtime_resume_and_get(common->dev);
 	if (ret < 0)
 		return ret;
 
+	/* Idle MAC port */
+	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
+
+	tmo = cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
+	dev_info(common->dev, "down msc_sl %08x tmo %d\n",
+		 cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS), tmo);
+
+	cpsw_sl_ctl_reset(port->slave.mac_sl);
+
+	/* soft reset MAC */
+	cpsw_sl_reg_write(port->slave.mac_sl, CPSW_SL_SOFT_RESET, 1);
+	mdelay(1);
+	reg = cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_SOFT_RESET);
+	if (reg)
+		dev_info(common->dev, "mac reset not yet done\n");
+
 	/* Notify the stack of the actual queue counts. */
 	ret = netif_set_real_num_tx_queues(ndev, common->tx_ch_num);
 	if (ret) {
@@ -1499,9 +1548,9 @@ static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
 	cpsw_sl_ctl_reset(port->slave.mac_sl);
 }
 
-static void am65_cpsw_nuss_free_tx_chns(void *data)
+static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common)
 {
-	struct am65_cpsw_common *common = data;
+	struct device *dev = common->dev;
 	int i;
 
 	for (i = 0; i < common->tx_ch_num; i++) {
@@ -1513,7 +1562,11 @@ static void am65_cpsw_nuss_free_tx_chns(void *data)
 		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
 			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
 
-		memset(tx_chn, 0, sizeof(*tx_chn));
+		/* Don't clear tx_chn memory as we need to preserve
+		 * data between suspend/resume
+		 */
+		if (!(tx_chn->irq < 0))
+			devm_free_irq(dev, tx_chn->irq, tx_chn);
 	}
 }
 
@@ -1522,12 +1575,10 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 	struct device *dev = common->dev;
 	int i;
 
-	devm_remove_action(dev, am65_cpsw_nuss_free_tx_chns, common);
-
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		if (tx_chn->irq)
+		if (!(tx_chn->irq < 0))
 			devm_free_irq(dev, tx_chn->irq, tx_chn);
 
 		netif_napi_del(&tx_chn->napi_tx);
@@ -1597,7 +1648,7 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 		}
 
 		tx_chn->irq = k3_udma_glue_tx_get_irq(tx_chn->tx_chn);
-		if (tx_chn->irq <= 0) {
+		if (tx_chn->irq < 0) {
 			dev_err(dev, "Failed to get tx dma irq %d\n",
 				tx_chn->irq);
 			goto err;
@@ -1606,25 +1657,36 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 		snprintf(tx_chn->tx_chn_name,
 			 sizeof(tx_chn->tx_chn_name), "%s-tx%d",
 			 dev_name(dev), tx_chn->id);
+
+		ret = devm_request_irq(dev, tx_chn->irq,
+				       am65_cpsw_nuss_tx_irq,
+				       IRQF_TRIGGER_HIGH,
+				       tx_chn->tx_chn_name, tx_chn);
+		if (ret) {
+			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
+				tx_chn->id, tx_chn->irq, ret);
+			tx_chn->irq = -EINVAL;
+			goto err;
+		}
 	}
 
+	return 0;
+
 err:
-	i = devm_add_action(dev, am65_cpsw_nuss_free_tx_chns, common);
-	if (i) {
-		dev_err(dev, "Failed to add free_tx_chns action %d\n", i);
-		return i;
-	}
+	am65_cpsw_nuss_free_tx_chns(common);
 
 	return ret;
 }
 
-static void am65_cpsw_nuss_free_rx_chns(void *data)
+static void am65_cpsw_nuss_free_rx_chns(struct am65_cpsw_common *common)
 {
-	struct am65_cpsw_common *common = data;
 	struct am65_cpsw_rx_chn *rx_chn;
 
 	rx_chn = &common->rx_chns;
 
+	if (!(rx_chn->irq < 0))
+		devm_free_irq(common->dev, rx_chn->irq, common);
+
 	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
 		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
 
@@ -1647,7 +1709,7 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 
 	rx_cfg.swdata_size = AM65_CPSW_NAV_SW_DATA_SIZE;
 	rx_cfg.flow_id_num = AM65_CPSW_MAX_RX_FLOWS;
-	rx_cfg.flow_id_base = common->rx_flow_id_base;
+	rx_cfg.flow_id_base = -1;
 
 	/* init all flows */
 	rx_chn->dev = dev;
@@ -1719,13 +1781,21 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 		}
 	}
 
-err:
-	i = devm_add_action(dev, am65_cpsw_nuss_free_rx_chns, common);
-	if (i) {
-		dev_err(dev, "Failed to add free_rx_chns action %d\n", i);
-		return i;
+	ret = devm_request_irq(dev, rx_chn->irq,
+			       am65_cpsw_nuss_rx_irq,
+			       IRQF_TRIGGER_HIGH, dev_name(dev), common);
+	if (ret) {
+		dev_err(dev, "failure requesting rx irq %u, %d\n",
+			rx_chn->irq, ret);
+		rx_chn->irq = -EINVAL;
+		goto err;
 	}
 
+	return 0;
+
+err:
+	am65_cpsw_nuss_free_rx_chns(common);
+
 	return ret;
 }
 
@@ -1990,6 +2060,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	port->slave.phylink_config.dev = &port->ndev->dev;
 	port->slave.phylink_config.type = PHYLINK_NETDEV;
 	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
+	port->slave.phylink_config.mac_managed_pm = true; /* MAC does PM */
 
 	if (phy_interface_mode_is_rgmii(port->slave.phy_if)) {
 		phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
@@ -2051,28 +2122,16 @@ static int am65_cpsw_nuss_init_ndevs(struct am65_cpsw_common *common)
 
 static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common)
 {
-	struct device *dev = common->dev;
-	int i, ret = 0;
+	int i;
 
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
 		netif_napi_add_tx(common->dma_ndev, &tx_chn->napi_tx,
 				  am65_cpsw_nuss_tx_poll);
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
 	}
 
-err:
-	return ret;
+	return 0;
 }
 
 static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
@@ -2542,15 +2601,6 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 	if (ret)
 		return ret;
 
-	ret = devm_request_irq(dev, common->rx_chns.irq,
-			       am65_cpsw_nuss_rx_irq,
-			       IRQF_TRIGGER_HIGH, dev_name(dev), common);
-	if (ret) {
-		dev_err(dev, "failure requesting rx irq %u, %d\n",
-			common->rx_chns.irq, ret);
-		return ret;
-	}
-
 	ret = am65_cpsw_nuss_register_devlink(common);
 	if (ret)
 		return ret;
@@ -2705,7 +2755,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	if (common->port_num < 1 || common->port_num > AM65_CPSW_MAX_PORTS)
 		return -ENOENT;
 
-	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
 	common->tx_ch_num = 1;
 	common->pf_p0_rx_ptype_rrobin = false;
@@ -2747,14 +2796,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
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
@@ -2839,10 +2880,80 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
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

