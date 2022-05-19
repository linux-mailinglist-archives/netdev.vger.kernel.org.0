Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6454552D438
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiESNmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238910AbiESNlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:41:03 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED02226E4
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:40:49 -0700 (PDT)
Received: (qmail 7180 invoked from network); 19 May 2022 13:40:46 -0000
Received: from p200300cf0719280076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:719:2800:76d4:35ff:feb7:be92]:39198 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <patchwork-bot+netdevbpf@kernel.org>; Thu, 19 May 2022 15:40:46 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        yangyingliang@huawei.com, davem@davemloft.net, edumazet@google.com
Subject: [PATCH v3] tulip: convert to devres
Date:   Thu, 19 May 2022 15:40:44 +0200
Message-ID: <4749559.31r3eYUQgx@eto.sf-tec.de>
In-Reply-To: <165269761404.8728.16015739218131453967.git-patchwork-notify@kernel.org>
References: <2630407.mvXUDI8C0e@eto.sf-tec.de> <165269761404.8728.16015739218131453967.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Works fine on my HP C3600:

[  274.452394] tulip0: no phy info, aborting mtable build
[  274.499041] tulip0:  MII transceiver #1 config 1000 status 782d advertising 01e1
[  274.750691] net eth0: Digital DS21142/43 Tulip rev 65 at MMIO 0xf4008000, 00:30:6e:08:7d:21, IRQ 17
[  283.104520] net eth0: Setting full-duplex based on MII#1 link partner capability of c1e1

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/net/ethernet/dec/tulip/eeprom.c     |  7 ++-
 drivers/net/ethernet/dec/tulip/tulip_core.c | 64 ++++++---------------
 2 files changed, 20 insertions(+), 51 deletions(-)

v2: rebased

v3: fixed typo in variable for CONFIG_GSC code

diff --git a/drivers/net/ethernet/dec/tulip/eeprom.c b/drivers/net/ethernet/dec/tulip/eeprom.c
index ba0a69b363f8..d5657ff15e3c 100644
--- a/drivers/net/ethernet/dec/tulip/eeprom.c
+++ b/drivers/net/ethernet/dec/tulip/eeprom.c
@@ -117,8 +117,8 @@ static void tulip_build_fake_mediatable(struct tulip_private *tp)
 			  0x00, 0x06  /* ttm bit map */
 			};
 
-		tp->mtable = kmalloc(sizeof(struct mediatable) +
-				     sizeof(struct medialeaf), GFP_KERNEL);
+		tp->mtable = devm_kmalloc(&tp->pdev->dev, sizeof(struct mediatable) +
+					  sizeof(struct medialeaf), GFP_KERNEL);
 
 		if (tp->mtable == NULL)
 			return; /* Horrible, impossible failure. */
@@ -224,7 +224,8 @@ void tulip_parse_eeprom(struct net_device *dev)
 		        return;
 		}
 
-		mtable = kmalloc(struct_size(mtable, mleaf, count), GFP_KERNEL);
+		mtable = devm_kmalloc(&tp->pdev->dev, struct_size(mtable, mleaf, count),
+				      GFP_KERNEL);
 		if (mtable == NULL)
 			return;				/* Horrible, impossible failure. */
 		last_mediatable = tp->mtable = mtable;
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 0040dcaab945..1a09d3753073 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1389,7 +1389,7 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 *	And back to business
 	 */
 
-	i = pci_enable_device(pdev);
+	i = pcim_enable_device(pdev);
 	if (i) {
 		pr_err("Cannot enable tulip board #%d, aborting\n", board_idx);
 		return i;
@@ -1398,11 +1398,9 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	irq = pdev->irq;
 
 	/* alloc_etherdev ensures aligned and zeroed private structures */
-	dev = alloc_etherdev (sizeof (*tp));
-	if (!dev) {
-		pci_disable_device(pdev);
+	dev = devm_alloc_etherdev(&pdev->dev, sizeof(*tp));
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	if (pci_resource_len (pdev, 0) < tulip_tbl[chip_idx].io_size) {
@@ -1410,18 +1408,18 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		       pci_name(pdev),
 		       (unsigned long long)pci_resource_len (pdev, 0),
 		       (unsigned long long)pci_resource_start (pdev, 0));
-		goto err_out_free_netdev;
+		return -ENODEV;
 	}
 
 	/* grab all resources from both PIO and MMIO regions, as we
 	 * don't want anyone else messing around with our hardware */
-	if (pci_request_regions (pdev, DRV_NAME))
-		goto err_out_free_netdev;
+	if (pci_request_regions(pdev, DRV_NAME))
+		return -ENODEV;
 
-	ioaddr =  pci_iomap(pdev, TULIP_BAR, tulip_tbl[chip_idx].io_size);
+	ioaddr = pcim_iomap(pdev, TULIP_BAR, tulip_tbl[chip_idx].io_size);
 
 	if (!ioaddr)
-		goto err_out_free_res;
+		return -ENODEV;
 
 	/*
 	 * initialize private data structure 'tp'
@@ -1430,12 +1428,12 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp = netdev_priv(dev);
 	tp->dev = dev;
 
-	tp->rx_ring = dma_alloc_coherent(&pdev->dev,
-					 sizeof(struct tulip_rx_desc) * RX_RING_SIZE +
-					 sizeof(struct tulip_tx_desc) * TX_RING_SIZE,
-					 &tp->rx_ring_dma, GFP_KERNEL);
+	tp->rx_ring = dmam_alloc_coherent(&pdev->dev,
+					  sizeof(struct tulip_rx_desc) * RX_RING_SIZE +
+					  sizeof(struct tulip_tx_desc) * TX_RING_SIZE,
+					  &tp->rx_ring_dma, GFP_KERNEL);
 	if (!tp->rx_ring)
-		goto err_out_mtable;
+		return -ENODEV;
 	tp->tx_ring = (struct tulip_tx_desc *)(tp->rx_ring + RX_RING_SIZE);
 	tp->tx_ring_dma = tp->rx_ring_dma + sizeof(struct tulip_rx_desc) * RX_RING_SIZE;
 
@@ -1695,8 +1693,9 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 	dev->ethtool_ops = &ops;
 
-	if (register_netdev(dev))
-		goto err_out_free_ring;
+	i = register_netdev(dev);
+	if (i)
+		return i;
 
 	pci_set_drvdata(pdev, dev);
 
@@ -1771,24 +1770,6 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tulip_set_power_state (tp, 0, 1);
 
 	return 0;
-
-err_out_free_ring:
-	dma_free_coherent(&pdev->dev,
-			  sizeof(struct tulip_rx_desc) * RX_RING_SIZE +
-			  sizeof(struct tulip_tx_desc) * TX_RING_SIZE,
-			  tp->rx_ring, tp->rx_ring_dma);
-
-err_out_mtable:
-	kfree (tp->mtable);
-	pci_iounmap(pdev, ioaddr);
-
-err_out_free_res:
-	pci_release_regions (pdev);
-
-err_out_free_netdev:
-	free_netdev (dev);
-	pci_disable_device(pdev);
-	return -ENODEV;
 }
 
 
@@ -1888,24 +1869,11 @@ static int __maybe_unused tulip_resume(struct device *dev_d)
 static void tulip_remove_one(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata (pdev);
-	struct tulip_private *tp;
 
 	if (!dev)
 		return;
 
-	tp = netdev_priv(dev);
 	unregister_netdev(dev);
-	dma_free_coherent(&pdev->dev,
-			  sizeof(struct tulip_rx_desc) * RX_RING_SIZE +
-			  sizeof(struct tulip_tx_desc) * TX_RING_SIZE,
-			  tp->rx_ring, tp->rx_ring_dma);
-	kfree (tp->mtable);
-	pci_iounmap(pdev, tp->base_addr);
-	free_netdev (dev);
-	pci_release_regions (pdev);
-	pci_disable_device(pdev);
-
-	/* pci_power_off (pdev, -1); */
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
-- 
2.35.3




