Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B70462C56B
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239113AbiKPQvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239058AbiKPQur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:50:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F3030E;
        Wed, 16 Nov 2022 08:49:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98A08B81DB4;
        Wed, 16 Nov 2022 16:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DC8C433D6;
        Wed, 16 Nov 2022 16:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668617364;
        bh=E6yZWb4Zgw7rrjeckDWIQDswo1fWS678H2ta34vLVeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnG/VCOBKFFnDY0bj7dOu9i1eGZ/wMIkTyHAjXKBJeijtkZ25bkh8qZ7Ro8Nt9ets
         darTkPByZzoBHA0QdYc20TxKbYQE/+s3WWQE6NwsKU4oPQjH+Cywyw1scyQcUz83cf
         4hBybG0L/nKEtlvjAiY5ENe5x4Z0XfOGGd3bogXgS5GqOLZL0MlYcBcKwTDJLMBK+v
         W+Hwb5yH+tvDQKWo9PDGDhJeaOyREfytjYkn4j8rx4AW74Z/6hPb4ngHa1N44wJlwZ
         9MEv26Mu6VCwUbXy6TDmJ2423NhXO5u12Y+18bpU3SbmpzYRuIefMrfksiEx44nWNj
         olKV1LlIa5s4Q==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 1/4] net: ethernet: ti: am65-cpsw: Fix set channel operation
Date:   Wed, 16 Nov 2022 18:49:12 +0200
Message-Id: <20221116164915.13236-2-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221116164915.13236-1-rogerq@kernel.org>
References: <20221116164915.13236-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set channel operation "ethtool -L tx <n>" broke with
the recent suspend/resume changes.

Revert back to original driver behaviour of not freeing
the TX/RX IRQs at am65_cpsw_nuss_common_stop(). We will
now free them only on .suspend() as we need to release
the DMA channels (as DMA looses context) and re-acquiring
them on .resume() may not necessarily give us the same
IRQs.

Introduce am65_cpsw_nuss_remove_rx_chns() which is similar
to am65_cpsw_nuss_remove_tx_chns() and invoke them both in
.suspend().

At .resume() call am65_cpsw_nuss_init_rx/tx_chns() to
acquire the DMA channels.

To as IRQs need to be requested after knowing the IRQ
numbers, move am65_cpsw_nuss_ndev_add_tx_napi() call to
am65_cpsw_nuss_init_tx_chns().

Also fixes the below warning during suspend/resume on multi
CPU system.

[   67.347684] ------------[ cut here ]------------
[   67.347700] Unbalanced enable for IRQ 119
[   67.347726] WARNING: CPU: 0 PID: 1080 at kernel/irq/manage.c:781 __enable_irq+0x4c/0x80
[   67.347754] Modules linked in: wlcore_sdio wl18xx wlcore mac80211 libarc4 cfg80211 rfkill crct10dif_ce sch_fq_codel ipv6
[   67.347803] CPU: 0 PID: 1080 Comm: rtcwake Not tainted 6.1.0-rc4-00023-gc826e5480732-dirty #203
[   67.347812] Hardware name: Texas Instruments AM625 (DT)
[   67.347818] pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   67.347829] pc : __enable_irq+0x4c/0x80
[   67.347838] lr : __enable_irq+0x4c/0x80
[   67.347846] sp : ffff80000999ba00
[   67.347850] x29: ffff80000999ba00 x28: ffff0000011c1c80 x27: 0000000000000000
[   67.347863] x26: 00000000000001f4 x25: ffff000001058358 x24: ffff000001059080
[   67.347876] x23: ffff000001058080 x22: ffff000001060000 x21: 0000000000000077
[   67.347888] x20: ffff0000011c1c80 x19: ffff000001429600 x18: 0000000000000001
[   67.347900] x17: 0000000000000080 x16: fffffc000176e008 x15: ffff0000011c21b0
[   67.347913] x14: 0000000000000000 x13: 3931312051524920 x12: 726f6620656c6261
[   67.347925] x11: 656820747563205b x10: 000000000000000a x9 : ffff80000999ba00
[   67.347938] x8 : ffff800009121068 x7 : ffff80000999b810 x6 : 00000000fffff17f
[   67.347950] x5 : ffff00007fb99b18 x4 : 0000000000000000 x3 : 0000000000000027
[   67.347962] x2 : ffff00007fb99b20 x1 : 50dd48f7f19deb00 x0 : 0000000000000000
[   67.347975] Call trace:
[   67.347980]  __enable_irq+0x4c/0x80
[   67.347989]  enable_irq+0x4c/0xa0
[   67.347999]  am65_cpsw_nuss_ndo_slave_open+0x4b0/0x568
[   67.348015]  am65_cpsw_nuss_resume+0x68/0x160
[   67.348025]  dpm_run_callback.isra.0+0x28/0x88
[   67.348040]  device_resume+0x78/0x160
[   67.348050]  dpm_resume+0xc0/0x1f8
[   67.348057]  dpm_resume_end+0x18/0x30
[   67.348063]  suspend_devices_and_enter+0x1cc/0x4e0
[   67.348075]  pm_suspend+0x1f8/0x268
[   67.348084]  state_store+0x8c/0x118
[   67.348092]  kobj_attr_store+0x18/0x30
[   67.348104]  sysfs_kf_write+0x44/0x58
[   67.348117]  kernfs_fop_write_iter+0x118/0x1a8
[   67.348127]  vfs_write+0x31c/0x418
[   67.348140]  ksys_write+0x6c/0xf8
[   67.348150]  __arm64_sys_write+0x1c/0x28
[   67.348160]  invoke_syscall+0x44/0x108
[   67.348172]  el0_svc_common.constprop.0+0x44/0xf0
[   67.348182]  do_el0_svc+0x2c/0xc8
[   67.348191]  el0_svc+0x2c/0x88
[   67.348201]  el0t_64_sync_handler+0xb8/0xc0
[   67.348209]  el0t_64_sync+0x18c/0x190
[   67.348218] ---[ end trace 0000000000000000 ]---

Fixes: fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 160 +++++++++++++----------
 1 file changed, 88 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index f2e377524088..f8899ac5e249 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -133,10 +133,7 @@
 			 NETIF_MSG_IFUP	| NETIF_MSG_PROBE | NETIF_MSG_IFDOWN | \
 			 NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
 
-static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common);
-static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common);
-static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common);
-static void am65_cpsw_nuss_free_rx_chns(struct am65_cpsw_common *common);
+static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common);
 
 static void am65_cpsw_port_set_sl_mac(struct am65_cpsw_port *slave,
 				      const u8 *dev_addr)
@@ -379,20 +376,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
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
@@ -453,8 +436,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 						  GFP_KERNEL);
 		if (!skb) {
 			dev_err(common->dev, "cannot allocate skb\n");
-			ret = -ENOMEM;
-			goto err;
+			return -ENOMEM;
 		}
 
 		ret = am65_cpsw_nuss_rx_push(common, skb);
@@ -463,7 +445,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 				"cannot submit skb to channel rx, error %d\n",
 				ret);
 			kfree_skb(skb);
-			goto err;
+			return ret;
 		}
 		kmemleak_not_leak(skb);
 	}
@@ -472,7 +454,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		ret = k3_udma_glue_enable_tx_chn(common->tx_chns[i].tx_chn);
 		if (ret)
-			goto err;
+			return ret;
 		napi_enable(&common->tx_chns[i].napi_tx);
 	}
 
@@ -484,12 +466,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 
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
@@ -543,9 +519,6 @@ static int am65_cpsw_nuss_common_stop(struct am65_cpsw_common *common)
 	writel(0, common->cpsw_base + AM65_CPSW_REG_CTL);
 	writel(0, common->cpsw_base + AM65_CPSW_REG_STAT_PORT_EN);
 
-	am65_cpsw_nuss_free_tx_chns(common);
-	am65_cpsw_nuss_free_rx_chns(common);
-
 	dev_dbg(common->dev, "cpsw_nuss stopped\n");
 	return 0;
 }
@@ -597,9 +570,6 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
 
 	tmo = cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
-	dev_info(common->dev, "down msc_sl %08x tmo %d\n",
-		 cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS), tmo);
-
 	cpsw_sl_ctl_reset(port->slave.mac_sl);
 
 	/* soft reset MAC */
@@ -1548,9 +1518,9 @@ static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
 	cpsw_sl_ctl_reset(port->slave.mac_sl);
 }
 
-static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common)
+static void am65_cpsw_nuss_free_tx_chns(void *data)
 {
-	struct device *dev = common->dev;
+	struct am65_cpsw_common *common = data;
 	int i;
 
 	for (i = 0; i < common->tx_ch_num; i++) {
@@ -1562,11 +1532,7 @@ static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common)
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
 
@@ -1575,10 +1541,12 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
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
@@ -1648,7 +1616,7 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 		}
 
 		tx_chn->irq = k3_udma_glue_tx_get_irq(tx_chn->tx_chn);
-		if (tx_chn->irq < 0) {
+		if (tx_chn->irq <= 0) {
 			dev_err(dev, "Failed to get tx dma irq %d\n",
 				tx_chn->irq);
 			goto err;
@@ -1657,41 +1625,59 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
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
+	ret = am65_cpsw_nuss_ndev_add_tx_napi(common);
+	if (ret) {
+		dev_err(dev, "Failed to add tx NAPI %d\n", ret);
+		goto err;
+	}
 
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
 
+	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
+		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
+
+	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
+		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
+}
+
+static void am65_cpsw_nuss_remove_rx_chns(void *data)
+{
+	struct am65_cpsw_common *common = data;
+	struct am65_cpsw_rx_chn *rx_chn;
+	struct device *dev = common->dev;
+
+	rx_chn = &common->rx_chns;
+	devm_remove_action(dev, am65_cpsw_nuss_free_rx_chns, common);
+
 	if (!(rx_chn->irq < 0))
-		devm_free_irq(common->dev, rx_chn->irq, common);
+		devm_free_irq(dev, rx_chn->irq, common);
+
+	netif_napi_del(&common->napi_rx);
 
 	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
 		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
 
 	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
 		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
+
+	common->rx_flow_id_base = -1;
 }
 
 static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
@@ -1709,7 +1695,7 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 
 	rx_cfg.swdata_size = AM65_CPSW_NAV_SW_DATA_SIZE;
 	rx_cfg.flow_id_num = AM65_CPSW_MAX_RX_FLOWS;
-	rx_cfg.flow_id_base = -1;
+	rx_cfg.flow_id_base = common->rx_flow_id_base;
 
 	/* init all flows */
 	rx_chn->dev = dev;
@@ -1781,20 +1767,24 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 		}
 	}
 
+	netif_napi_add(common->dma_ndev, &common->napi_rx,
+		       am65_cpsw_nuss_rx_poll);
+
 	ret = devm_request_irq(dev, rx_chn->irq,
 			       am65_cpsw_nuss_rx_irq,
 			       IRQF_TRIGGER_HIGH, dev_name(dev), common);
 	if (ret) {
 		dev_err(dev, "failure requesting rx irq %u, %d\n",
 			rx_chn->irq, ret);
-		rx_chn->irq = -EINVAL;
 		goto err;
 	}
 
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
@@ -2114,24 +2104,33 @@ static int am65_cpsw_nuss_init_ndevs(struct am65_cpsw_common *common)
 			return ret;
 	}
 
-	netif_napi_add(common->dma_ndev, &common->napi_rx,
-		       am65_cpsw_nuss_rx_poll);
-
 	return ret;
 }
 
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
@@ -2597,7 +2596,11 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 	struct am65_cpsw_port *port;
 	int ret = 0, i;
 
-	ret = am65_cpsw_nuss_ndev_add_tx_napi(common);
+	/* init tx channels */
+	ret = am65_cpsw_nuss_init_tx_chns(common);
+	if (ret)
+		return ret;
+	ret = am65_cpsw_nuss_init_rx_chns(common);
 	if (ret)
 		return ret;
 
@@ -2645,10 +2648,8 @@ int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx)
 
 	common->tx_ch_num = num_tx;
 	ret = am65_cpsw_nuss_init_tx_chns(common);
-	if (ret)
-		return ret;
 
-	return am65_cpsw_nuss_ndev_add_tx_napi(common);
+	return ret;
 }
 
 struct am65_cpsw_soc_pdata {
@@ -2756,6 +2757,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	if (common->port_num < 1 || common->port_num > AM65_CPSW_MAX_PORTS)
 		return -ENOENT;
 
+	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
 	common->tx_ch_num = 1;
 	common->pf_p0_rx_ptype_rrobin = false;
@@ -2918,6 +2920,9 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 
 	am65_cpts_suspend(common->cpts);
 
+	am65_cpsw_nuss_remove_rx_chns(common);
+	am65_cpsw_nuss_remove_tx_chns(common);
+
 	return 0;
 }
 
@@ -2929,6 +2934,17 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	int i, ret;
 	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
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
 	am65_cpts_resume(common->cpts);
 
 	for (i = 0; i < common->port_num; i++) {
-- 
2.17.1

