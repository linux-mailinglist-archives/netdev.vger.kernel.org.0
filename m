Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80CE40BA24
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 23:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbhINVWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 17:22:40 -0400
Received: from mx3.wp.pl ([212.77.101.9]:37304 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234767AbhINVWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 17:22:38 -0400
Received: (wp-smtpd smtp.wp.pl 11982 invoked from network); 14 Sep 2021 23:21:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1631654478; bh=xd7no5jcP2vhhqXIdQ8szRMPJzQoYV5X4FKRFyn7Hwo=;
          h=From:To:Subject;
          b=tDp5xrMM3c8b5ZzGpnbxD9mQTsGjNLy4YdWyPrpDB06YSfXs+Lw/6v5x+r/rPRNd3
           nk/ITWrR0llYE/y4p46LXYB8KNIbUv0Asj2ClXI965u7ovyt2LvbyE7seV7fjekyGg
           CQ4gIuZc6TtyljCqG3CMOfVGKmbmBs5Jha9yMQOg=
Received: from 46.204.52.243.nat.umts.dynamic.t-mobile.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[46.204.52.243])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <john@phrozen.org>; 14 Sep 2021 23:21:18 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     john@phrozen.org, tsbogend@alpha.franken.de, olek2@wp.pl,
        maz@kernel.org, ralf@linux-mips.org, ralph.hempel@lantiq.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hauke@hauke-m.de, dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/8] net: lantiq: configure the burst length in ethernet drivers
Date:   Tue, 14 Sep 2021 23:21:02 +0200
Message-Id: <20210914212105.76186-5-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914212105.76186-1-olek2@wp.pl>
References: <20210914212105.76186-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 1980189a75ac07b6a4cb5cbbadb14b87
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [cROR]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure the burst length in Ethernet drivers. This improves
Ethernet performance by 58%. According to the vendor BSP,
8W burst length is supported by ar9 and newer SoCs.

The NAT benchmark results on xRX200 (Down/Up):
* 2W: 330 Mb/s
* 4W: 432 Mb/s    372 Mb/s
* 8W: 520 Mb/s    389 Mb/s

Tested on xRX200 and xRX330.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c   | 21 ++++++++++++++++++---
 drivers/net/ethernet/lantiq_xrx200.c | 21 ++++++++++++++++++---
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 62f8c5212182..2258e3f19161 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -96,6 +96,9 @@ struct ltq_etop_priv {
 	struct ltq_etop_chan ch[MAX_DMA_CHAN];
 	int tx_free[MAX_DMA_CHAN >> 1];
 
+	int tx_burst_len;
+	int rx_burst_len;
+
 	spinlock_t lock;
 };
 
@@ -259,7 +262,7 @@ ltq_etop_hw_init(struct net_device *dev)
 	/* enable crc generation */
 	ltq_etop_w32(PPE32_CGEN, LQ_PPE32_ENET_MAC_CFG);
 
-	ltq_dma_init_port(DMA_PORT_ETOP);
+	ltq_dma_init_port(DMA_PORT_ETOP, priv->tx_burst_len, rx_burst_len);
 
 	for (i = 0; i < MAX_DMA_CHAN; i++) {
 		int irq = LTQ_DMA_CH0_INT + i;
@@ -472,8 +475,8 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 	}
 
-	/* dma needs to start on a 16 byte aligned address */
-	byte_offset = CPHYSADDR(skb->data) % 16;
+	/* dma needs to start on a burst length value aligned address */
+	byte_offset = CPHYSADDR(skb->data) % (priv->tx_burst_len * 4);
 	ch->skb[ch->dma.desc] = skb;
 
 	netif_trans_update(dev);
@@ -667,6 +670,18 @@ ltq_etop_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->lock);
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
+	err = device_property_read_u32(&pdev->dev, "lantiq,tx-burst-length", &priv->tx_burst_len);
+	if (err < 0) {
+		dev_err(&pdev->dev, "unable to read tx-burst-length property\n");
+		return err;
+	}
+
+	err = device_property_read_u32(&pdev->dev, "lantiq,rx-burst-length", &priv->rx_burst_len);
+	if (err < 0) {
+		dev_err(&pdev->dev, "unable to read rx-burst-length property\n");
+		return err;
+	}
+
 	for (i = 0; i < MAX_DMA_CHAN; i++) {
 		if (IS_TX(i))
 			netif_napi_add(dev, &priv->ch[i].napi,
diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index fb78f17d734f..5d96248ce83b 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -71,6 +71,9 @@ struct xrx200_priv {
 	struct net_device *net_dev;
 	struct device *dev;
 
+	int tx_burst_len;
+	int rx_burst_len;
+
 	__iomem void *pmac_reg;
 };
 
@@ -316,8 +319,8 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
 	if (unlikely(dma_mapping_error(priv->dev, mapping)))
 		goto err_drop;
 
-	/* dma needs to start on a 16 byte aligned address */
-	byte_offset = mapping % 16;
+	/* dma needs to start on a burst length value aligned address */
+	byte_offset = mapping % (priv->tx_burst_len * 4);
 
 	desc->addr = mapping - byte_offset;
 	/* Make sure the address is written before we give it to HW */
@@ -369,7 +372,7 @@ static int xrx200_dma_init(struct xrx200_priv *priv)
 	int ret = 0;
 	int i;
 
-	ltq_dma_init_port(DMA_PORT_ETOP);
+	ltq_dma_init_port(DMA_PORT_ETOP, priv->tx_burst_len, rx_burst_len);
 
 	ch_rx->dma.nr = XRX200_DMA_RX;
 	ch_rx->dma.dev = priv->dev;
@@ -478,6 +481,18 @@ static int xrx200_probe(struct platform_device *pdev)
 	if (err)
 		eth_hw_addr_random(net_dev);
 
+	err = device_property_read_u32(dev, "lantiq,tx-burst-length", &priv->tx_burst_len);
+	if (err < 0) {
+		dev_err(dev, "unable to read tx-burst-length property\n");
+		return err;
+	}
+
+	err = device_property_read_u32(dev, "lantiq,rx-burst-length", &priv->rx_burst_len);
+	if (err < 0) {
+		dev_err(dev, "unable to read rx-burst-length property\n");
+		return err;
+	}
+
 	/* bring up the dma engine and IP core */
 	err = xrx200_dma_init(priv);
 	if (err)
-- 
2.30.2

