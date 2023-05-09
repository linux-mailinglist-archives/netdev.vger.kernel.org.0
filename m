Return-Path: <netdev+bounces-1031-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C64046FBE48
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94AE42811F0
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3ECE38A;
	Tue,  9 May 2023 04:38:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90305191
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:38:53 +0000 (UTC)
X-Greylist: delayed 595 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 08 May 2023 21:38:51 PDT
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539837688
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:38:51 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 7915E101E6941;
	Tue,  9 May 2023 06:28:54 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by h08.hostsharing.net (Postfix) with ESMTPSA id 14C2C6092A98;
	Tue,  9 May 2023 06:28:54 +0200 (CEST)
X-Mailbox-Line: From 342380d989ce26bc49f0e5d45fbb0416a5f7809f Mon Sep 17 00:00:00 2001
Message-Id: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Tue, 9 May 2023 06:28:56 +0200
Subject: [PATCH net-next] net: enc28j60: Use threaded interrupt instead of
 workqueue
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, Philipp Rosenberger <p.rosenberger@kunbus.com>, Zhi Han <hanzhi09@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

From: Philipp Rosenberger <p.rosenberger@kunbus.com>

The Microchip ENC28J60 SPI Ethernet driver schedules a work item from
the interrupt handler because accesses to the SPI bus may sleep.

On PREEMPT_RT (which forces interrupt handling into threads) this
old-fashioned approach unnecessarily increases latency because an
interrupt results in first waking the interrupt thread, then scheduling
the work item.  So, a double indirection to handle an interrupt.

Avoid by converting the driver to modern threaded interrupt handling.

Signed-off-by: Philipp Rosenberger <p.rosenberger@kunbus.com>
Signed-off-by: Zhi Han <hanzhi09@gmail.com>
[lukas: rewrite commit message, linewrap request_threaded_irq() call]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/ethernet/microchip/enc28j60.c | 28 +++++------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
index 176efbeae127..d6c9491537e4 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -58,7 +58,6 @@ struct enc28j60_net {
 	struct mutex lock;
 	struct sk_buff *tx_skb;
 	struct work_struct tx_work;
-	struct work_struct irq_work;
 	struct work_struct setrx_work;
 	struct work_struct restart_work;
 	u8 bank;		/* current register bank selected */
@@ -1118,10 +1117,9 @@ static int enc28j60_rx_interrupt(struct net_device *ndev)
 	return ret;
 }
 
-static void enc28j60_irq_work_handler(struct work_struct *work)
+static irqreturn_t enc28j60_irq(int irq, void *dev_id)
 {
-	struct enc28j60_net *priv =
-		container_of(work, struct enc28j60_net, irq_work);
+	struct enc28j60_net *priv = dev_id;
 	struct net_device *ndev = priv->netdev;
 	int intflags, loop;
 
@@ -1225,6 +1223,8 @@ static void enc28j60_irq_work_handler(struct work_struct *work)
 
 	/* re-enable interrupts */
 	locked_reg_bfset(priv, EIE, EIE_INTIE);
+
+	return IRQ_HANDLED;
 }
 
 /*
@@ -1309,22 +1309,6 @@ static void enc28j60_tx_work_handler(struct work_struct *work)
 	enc28j60_hw_tx(priv);
 }
 
-static irqreturn_t enc28j60_irq(int irq, void *dev_id)
-{
-	struct enc28j60_net *priv = dev_id;
-
-	/*
-	 * Can't do anything in interrupt context because we need to
-	 * block (spi_sync() is blocking) so fire of the interrupt
-	 * handling workqueue.
-	 * Remember that we access enc28j60 registers through SPI bus
-	 * via spi_sync() call.
-	 */
-	schedule_work(&priv->irq_work);
-
-	return IRQ_HANDLED;
-}
-
 static void enc28j60_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 	struct enc28j60_net *priv = netdev_priv(ndev);
@@ -1559,7 +1543,6 @@ static int enc28j60_probe(struct spi_device *spi)
 	mutex_init(&priv->lock);
 	INIT_WORK(&priv->tx_work, enc28j60_tx_work_handler);
 	INIT_WORK(&priv->setrx_work, enc28j60_setrx_work_handler);
-	INIT_WORK(&priv->irq_work, enc28j60_irq_work_handler);
 	INIT_WORK(&priv->restart_work, enc28j60_restart_work_handler);
 	spi_set_drvdata(spi, priv);	/* spi to priv reference */
 	SET_NETDEV_DEV(dev, &spi->dev);
@@ -1578,7 +1561,8 @@ static int enc28j60_probe(struct spi_device *spi)
 	/* Board setup must set the relevant edge trigger type;
 	 * level triggers won't currently work.
 	 */
-	ret = request_irq(spi->irq, enc28j60_irq, 0, DRV_NAME, priv);
+	ret = request_threaded_irq(spi->irq, NULL, enc28j60_irq, IRQF_ONESHOT,
+				   DRV_NAME, priv);
 	if (ret < 0) {
 		if (netif_msg_probe(priv))
 			dev_err(&spi->dev, "request irq %d failed (ret = %d)\n",
-- 
2.39.2


