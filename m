Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8F843BBF6
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhJZVBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:01:48 -0400
Received: from mx4.wp.pl ([212.77.101.12]:51109 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235572AbhJZVBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 17:01:48 -0400
Received: (wp-smtpd smtp.wp.pl 32638 invoked from network); 26 Oct 2021 22:59:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1635281958; bh=WgW57u+5yEbJUHlDaeErLMbW3u24lbfeHj4ACnB7IUw=;
          h=From:To:Cc:Subject;
          b=Wugg7n9O/oDiE6acVmuSQ/SMjOvtm4JeOIKpMT2xGoxbVrlitjbm76N4FMj0oaCOl
           UgVwf+enWFmng1S3YoMNlPNv+gah/cUTMYRDRpuQCp9fv1+c+xIr1trEA4IYmswp61
           qzXaneeTrWD+K8Ota6xXbBmLvTwH5pbovp8MHhm8=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 26 Oct 2021 22:59:18 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH 1/2] net: lantiq_xrx200: Hardcode the burst length value
Date:   Tue, 26 Oct 2021 22:59:01 +0200
Message-Id: <20211026205902.335936-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 43aa16e0fb2cd16703b4d22842b9e459
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [kaNk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All SoCs with this IP core support 8 burst length. Hauke
suggested to hardcode this value and simplify the driver.

Link: https://lkml.org/lkml/2021/9/14/1533
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index ecf1e11d9b91..0da09ea81980 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -25,6 +25,7 @@
 #define XRX200_DMA_DATA_LEN	(SZ_64K - 1)
 #define XRX200_DMA_RX		0
 #define XRX200_DMA_TX		1
+#define XRX200_DMA_BURST_LEN	8
 
 /* cpu port mac */
 #define PMAC_RX_IPG		0x0024
@@ -73,9 +74,6 @@ struct xrx200_priv {
 	struct net_device *net_dev;
 	struct device *dev;
 
-	int tx_burst_len;
-	int rx_burst_len;
-
 	__iomem void *pmac_reg;
 };
 
@@ -323,7 +321,7 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
 		goto err_drop;
 
 	/* dma needs to start on a burst length value aligned address */
-	byte_offset = mapping % (priv->tx_burst_len * 4);
+	byte_offset = mapping % (XRX200_DMA_BURST_LEN * 4);
 
 	desc->addr = mapping - byte_offset;
 	/* Make sure the address is written before we give it to HW */
@@ -422,7 +420,8 @@ static int xrx200_dma_init(struct xrx200_priv *priv)
 	int ret = 0;
 	int i;
 
-	ltq_dma_init_port(DMA_PORT_ETOP, priv->tx_burst_len, rx_burst_len);
+	ltq_dma_init_port(DMA_PORT_ETOP, XRX200_DMA_BURST_LEN,
+			  XRX200_DMA_BURST_LEN);
 
 	ch_rx->dma.nr = XRX200_DMA_RX;
 	ch_rx->dma.dev = priv->dev;
@@ -531,18 +530,6 @@ static int xrx200_probe(struct platform_device *pdev)
 	if (err)
 		eth_hw_addr_random(net_dev);
 
-	err = device_property_read_u32(dev, "lantiq,tx-burst-length", &priv->tx_burst_len);
-	if (err < 0) {
-		dev_err(dev, "unable to read tx-burst-length property\n");
-		return err;
-	}
-
-	err = device_property_read_u32(dev, "lantiq,rx-burst-length", &priv->rx_burst_len);
-	if (err < 0) {
-		dev_err(dev, "unable to read rx-burst-length property\n");
-		return err;
-	}
-
 	/* bring up the dma engine and IP core */
 	err = xrx200_dma_init(priv);
 	if (err)
-- 
2.30.2

