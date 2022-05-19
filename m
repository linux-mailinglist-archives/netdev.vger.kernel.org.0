Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9217A52DE4D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244717AbiESUXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244706AbiESUXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:23:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B161AEE32
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:23:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nrmgD-0005Hb-HD
        for netdev@vger.kernel.org; Thu, 19 May 2022 22:23:29 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2DC4F8262B
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 20:23:28 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 93A8A82620;
        Thu, 19 May 2022 20:23:27 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7fcc0e17;
        Thu, 19 May 2022 20:23:26 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 2/4] can: can-dev: move to netif_napi_add_weight()
Date:   Thu, 19 May 2022 22:23:06 +0200
Message-Id: <20220519202308.1435903-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220519202308.1435903-1-mkl@pengutronix.de>
References: <20220519202308.1435903-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

We want to remove the weight argument from the basic version of the
netif_napi_add() call. Move all the callers in drivers/net/can that
pass a custom weight (i.e. not NAPI_POLL_WEIGHT or 64) to the
netif_napi_add_weight() API.

Link: https://lore.kernel.org/all/20220517002345.1812104-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c         | 2 +-
 drivers/net/can/c_can/c_can_main.c | 3 ++-
 drivers/net/can/dev/rx-offload.c   | 3 ++-
 drivers/net/can/grcan.c            | 2 +-
 drivers/net/can/janz-ican3.c       | 2 +-
 drivers/net/can/mscan/mscan.c      | 2 +-
 drivers/net/can/pch_can.c          | 2 +-
 drivers/net/can/rcar/rcar_can.c    | 4 ++--
 drivers/net/can/rcar/rcar_canfd.c  | 4 ++--
 drivers/net/can/xilinx_can.c       | 2 +-
 10 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index a00655ccda02..953aef8d3978 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1317,7 +1317,7 @@ static int at91_can_probe(struct platform_device *pdev)
 	priv->pdata = dev_get_platdata(&pdev->dev);
 	priv->mb0_id = 0x7ff;
 
-	netif_napi_add(dev, &priv->napi, at91_poll, get_mb_rx_num(priv));
+	netif_napi_add_weight(dev, &priv->napi, at91_poll, get_mb_rx_num(priv));
 
 	if (at91_is_sam9263(priv))
 		dev->sysfs_groups[0] = &at91_sysfs_attr_group;
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index faa217f26771..2034dbe30958 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -1246,7 +1246,8 @@ struct net_device *alloc_c_can_dev(int msg_obj_num)
 	priv->tx.tail = 0;
 	priv->tx.obj_num = msg_obj_tx_num;
 
-	netif_napi_add(dev, &priv->napi, c_can_poll, priv->msg_obj_rx_num);
+	netif_napi_add_weight(dev, &priv->napi, c_can_poll,
+			      priv->msg_obj_rx_num);
 
 	priv->dev = dev;
 	priv->can.bittiming_const = &c_can_bittiming_const;
diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
index 6d0dc18c03e7..509d21170c8c 100644
--- a/drivers/net/can/dev/rx-offload.c
+++ b/drivers/net/can/dev/rx-offload.c
@@ -337,7 +337,8 @@ static int can_rx_offload_init_queue(struct net_device *dev,
 	skb_queue_head_init(&offload->skb_queue);
 	__skb_queue_head_init(&offload->skb_irq_queue);
 
-	netif_napi_add(dev, &offload->napi, can_rx_offload_napi_poll, weight);
+	netif_napi_add_weight(dev, &offload->napi, can_rx_offload_napi_poll,
+			      weight);
 
 	dev_dbg(dev->dev.parent, "%s: skb_queue_len_max=%d\n",
 		__func__, offload->skb_queue_len_max);
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 5215bd9b2c80..76df4807d366 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1609,7 +1609,7 @@ static int grcan_setup_netdev(struct platform_device *ofdev,
 		timer_setup(&priv->hang_timer, grcan_initiate_running_reset, 0);
 	}
 
-	netif_napi_add(dev, &priv->napi, grcan_poll, GRCAN_NAPI_WEIGHT);
+	netif_napi_add_weight(dev, &priv->napi, grcan_poll, GRCAN_NAPI_WEIGHT);
 
 	SET_NETDEV_DEV(dev, &ofdev->dev);
 	dev_info(&ofdev->dev, "regs=0x%p, irq=%d, clock=%d\n",
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 808c105cf8f7..35bfb82d6929 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1910,7 +1910,7 @@ static int ican3_probe(struct platform_device *pdev)
 	mod = netdev_priv(ndev);
 	mod->ndev = ndev;
 	mod->num = pdata->modno;
-	netif_napi_add(ndev, &mod->napi, ican3_napi, ICAN3_RX_BUFFERS);
+	netif_napi_add_weight(ndev, &mod->napi, ican3_napi, ICAN3_RX_BUFFERS);
 	skb_queue_head_init(&mod->echoq);
 	spin_lock_init(&mod->lock);
 	init_completion(&mod->termination_comp);
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 5b5802fac772..78a21ab63601 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -679,7 +679,7 @@ struct net_device *alloc_mscandev(void)
 
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 
-	netif_napi_add(dev, &priv->napi, mscan_rx_poll, 8);
+	netif_napi_add_weight(dev, &priv->napi, mscan_rx_poll, 8);
 
 	priv->can.bittiming_const = &mscan_bittiming_const;
 	priv->can.do_set_bittiming = mscan_do_set_bittiming;
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 888bef03de09..fde3ac516d26 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -1189,7 +1189,7 @@ static int pch_can_probe(struct pci_dev *pdev,
 	ndev->netdev_ops = &pch_can_netdev_ops;
 	priv->can.clock.freq = PCH_CAN_CLK; /* Hz */
 
-	netif_napi_add(ndev, &priv->napi, pch_can_poll, PCH_RX_OBJ_END);
+	netif_napi_add_weight(ndev, &priv->napi, pch_can_poll, PCH_RX_OBJ_END);
 
 	rc = pci_enable_msi(priv->dev);
 	if (rc) {
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 33e37395379d..103f1a92eee2 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -803,8 +803,8 @@ static int rcar_can_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
-	netif_napi_add(ndev, &priv->napi, rcar_can_rx_poll,
-		       RCAR_CAN_NAPI_WEIGHT);
+	netif_napi_add_weight(ndev, &priv->napi, rcar_can_rx_poll,
+			      RCAR_CAN_NAPI_WEIGHT);
 	err = register_candev(ndev);
 	if (err) {
 		dev_err(&pdev->dev, "register_candev() failed, error %d\n",
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 1e121e04208c..f75ebaa35519 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1789,8 +1789,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->gpriv = gpriv;
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
-	netif_napi_add(ndev, &priv->napi, rcar_canfd_rx_poll,
-		       RCANFD_NAPI_WEIGHT);
+	netif_napi_add_weight(ndev, &priv->napi, rcar_canfd_rx_poll,
+			      RCANFD_NAPI_WEIGHT);
 	spin_lock_init(&priv->tx_lock);
 	devm_can_led_init(ndev);
 	gpriv->ch[priv->channel] = priv;
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 43f0c6a064ba..7f730b471e9f 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1804,7 +1804,7 @@ static int xcan_probe(struct platform_device *pdev)
 
 	priv->can.clock.freq = clk_get_rate(priv->can_clk);
 
-	netif_napi_add(ndev, &priv->napi, xcan_rx_poll, rx_max);
+	netif_napi_add_weight(ndev, &priv->napi, xcan_rx_poll, rx_max);
 
 	ret = register_candev(ndev);
 	if (ret) {
-- 
2.35.1


