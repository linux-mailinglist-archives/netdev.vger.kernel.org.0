Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DC24BA3D3
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbiBQO5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:57:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbiBQO5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:57:05 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 06:56:50 PST
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB07655A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1645109810;
  x=1676645810;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QxcUKmOttRZJLYW7ut8tqGGUV1itp+JVUMIR7K85mzc=;
  b=JKB2+AESiIaF+213Td96HbIfcmp0UBraUEwT7IE7h1nkK/lCScbkE7bu
   +Rpi5AB10k3F5XPl8ugzO7l0K/HQWcEB6FvfiM+F9RIrdmgSdM0K+jb3b
   TaLm03D/N2btaojcIVU55hYADKcMXRdjdbILktdfWiYappTjLe4IeasA/
   IszgsQckKOCGAUNEu2Eqjs31JTnlGZmCk2hpzvuLnkvyG8rOmMMUawQIu
   aY+3VBKfsir4dE0Ed+IDgDz7+1ui10BI9Zqx8mUp7FF3o1ZVj4O4s4oOJ
   hu0tUXGzN07VmMupTxb1wshYaZUDq7ukOcmTj58qBW69p8ftAqYBMpOMx
   g==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     <kernel@axis.com>, Lars Persson <larper@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: stmmac: Enable NAPI before interrupts go live
Date:   Thu, 17 Feb 2022 15:55:26 +0100
Message-ID: <20220217145527.2696444-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lars Persson <larper@axis.com>

The stmmac_open function has a race window between enabling the RX
path and its interrupt to the point where napi_enabled is called.

A chatty network with plenty of broadcast/multicast traffic has the
potential to completely fill the RX ring before the interrupt handler
is installed. In this scenario the single interrupt taken will find
napi disabled and the RX ring will not be processed. No further RX
interrupt will be delivered because the ring is full.

The RX stall could eventually clear because the TX path will trigger a
DMA interrupt once the tx_coal_frames threshold is reached and then
NAPI becomes scheduled.

Fixes: 523f11b5d4fd72efb ("net: stmmac: move hardware setup for stmmac_open to new function")
Signed-off-by: Lars Persson <larper@axis.com>
[vincent.whitchurch@axis.com: Forward-port to mainline, change xdp_open too]
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6708ca2aa4f7..8bd4123515b0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3753,11 +3753,12 @@ static int stmmac_open(struct net_device *dev)
 	/* We may have called phylink_speed_down before */
 	phylink_speed_up(priv->phylink);
 
+	stmmac_enable_all_queues(priv);
+
 	ret = stmmac_request_irq(dev);
 	if (ret)
 		goto irq_error;
 
-	stmmac_enable_all_queues(priv);
 	netif_tx_start_all_queues(priv->dev);
 
 	return 0;
@@ -3768,6 +3769,7 @@ static int stmmac_open(struct net_device *dev)
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
 
+	stmmac_disable_all_queues(priv);
 	stmmac_hw_teardown(dev);
 init_error:
 	free_dma_desc_resources(priv);
@@ -6562,12 +6564,13 @@ int stmmac_xdp_open(struct net_device *dev)
 	/* Start Rx & Tx DMA Channels */
 	stmmac_start_all_dma(priv);
 
+	/* Enable NAPI process*/
+	stmmac_enable_all_queues(priv);
+
 	ret = stmmac_request_irq(dev);
 	if (ret)
 		goto irq_error;
 
-	/* Enable NAPI process*/
-	stmmac_enable_all_queues(priv);
 	netif_carrier_on(dev);
 	netif_tx_start_all_queues(dev);
 
@@ -6577,6 +6580,7 @@ int stmmac_xdp_open(struct net_device *dev)
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
 
+	stmmac_disable_all_queues(priv);
 	stmmac_hw_teardown(dev);
 init_error:
 	free_dma_desc_resources(priv);
-- 
2.34.1

