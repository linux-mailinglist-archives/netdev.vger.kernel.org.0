Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B145A4DE0
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 15:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiH2NZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 09:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiH2NZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 09:25:11 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E3263D3
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 06:22:29 -0700 (PDT)
Received: (qmail 30353 invoked from network); 29 Aug 2022 13:22:13 -0000
Received: from p200300cf07107500405132fffec6f8de.dip0.t-ipconnect.de ([2003:cf:710:7500:4051:32ff:fec6:f8de]:53896 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 15:22:13 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     netdev@vger.kernel.org
Cc:     Sean Anderson <seanga2@gmail.com>
Subject: [PATCH 4/4 v2] sunhme: switch to devres
Date:   Mon, 29 Aug 2022 15:22:06 +0200
Message-ID: <5854720.lOV4Wx5bFT@eto.sf-tec.de>
In-Reply-To: <11922663.O9o76ZdvQC@eto.sf-tec.de>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de> <11922663.O9o76ZdvQC@eto.sf-tec.de>
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

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/net/ethernet/sun/sunhme.c | 60 +++++++++----------------------
 1 file changed, 17 insertions(+), 43 deletions(-)

v2:
 -return -EBUSY in case the PCI region can't be requested

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index eebe8c5f480c..df6e630a5024 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2933,7 +2933,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	struct happy_meal *hp;
 	struct net_device *dev;
 	void __iomem *hpreg_base;
-	unsigned long hpreg_res;
 	int i, qfe_slot = -1;
 	char prom_name[64];
 	u8 addr[ETH_ALEN];
@@ -2950,7 +2949,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		strcpy(prom_name, "SUNW,hme");
 #endif
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 
 	if (err)
 		goto err_out;
@@ -2968,10 +2967,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 			goto err_out;
 	}
 
-	dev = alloc_etherdev(sizeof(struct happy_meal));
-	err = -ENOMEM;
-	if (!dev)
+	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
+	if (!dev) {
+		err = -ENOMEM;
 		goto err_out;
+	}
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	if (hme_version_printed++ == 0)
@@ -2990,21 +2990,24 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		qp->happy_meals[qfe_slot] = dev;
 	}
 
-	hpreg_res = pci_resource_start(pdev, 0);
-	err = -ENODEV;
 	if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
 		printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI device base address.\n");
 		goto err_out_clear_quattro;
 	}
-	if (pci_request_regions(pdev, DRV_NAME)) {
+
+	if (!devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
+				  pci_resource_len(pdev, 0),
+				  DRV_NAME)) {
 		printk(KERN_ERR "happymeal(PCI): Cannot obtain PCI resources, "
 		       "aborting.\n");
+		err = -EBUSY;
 		goto err_out_clear_quattro;
 	}
 
-	if ((hpreg_base = ioremap(hpreg_res, 0x8000)) == NULL) {
+	hpreg_base = pcim_iomap(pdev, 0, 0x8000);
+	if (!hpreg_base) {
 		printk(KERN_ERR "happymeal(PCI): Unable to remap card memory.\n");
-		goto err_out_free_res;
+		goto err_out_clear_quattro;
 	}
 
 	for (i = 0; i < 6; i++) {
@@ -3070,11 +3073,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	hp->happy_bursts = DMA_BURSTBITS;
 #endif
 
-	hp->happy_block = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
+	hp->happy_block = dmam_alloc_coherent(&pdev->dev, PAGE_SIZE,
 					     &hp->hblock_dvma, GFP_KERNEL);
-	err = -ENODEV;
 	if (!hp->happy_block)
-		goto err_out_iounmap;
+		goto err_out_clear_quattro;
 
 	hp->linkcheck = 0;
 	hp->timer_state = asleep;
@@ -3108,11 +3110,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	happy_meal_set_initial_advertisement(hp);
 	spin_unlock_irq(&hp->happy_lock);
 
-	err = register_netdev(hp->dev);
+	err = devm_register_netdev(&pdev->dev, dev);
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_free_coherent;
+		goto err_out_clear_quattro;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3145,41 +3147,14 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
-err_out_free_coherent:
-	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
-			  hp->happy_block, hp->hblock_dvma);
-
-err_out_iounmap:
-	iounmap(hp->gregs);
-
-err_out_free_res:
-	pci_release_regions(pdev);
-
 err_out_clear_quattro:
 	if (qp != NULL)
 		qp->happy_meals[qfe_slot] = NULL;
 
-	free_netdev(dev);
-
 err_out:
 	return err;
 }
 
-static void happy_meal_pci_remove(struct pci_dev *pdev)
-{
-	struct happy_meal *hp = pci_get_drvdata(pdev);
-	struct net_device *net_dev = hp->dev;
-
-	unregister_netdev(net_dev);
-
-	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
-			  hp->happy_block, hp->hblock_dvma);
-	iounmap(hp->gregs);
-	pci_release_regions(hp->happy_dev);
-
-	free_netdev(net_dev);
-}
-
 static const struct pci_device_id happymeal_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SUN, PCI_DEVICE_ID_SUN_HAPPYMEAL) },
 	{ }			/* Terminating entry */
@@ -3191,7 +3166,6 @@ static struct pci_driver hme_pci_driver = {
 	.name		= "hme",
 	.id_table	= happymeal_pci_ids,
 	.probe		= happy_meal_pci_probe,
-	.remove		= happy_meal_pci_remove,
 };
 
 static int __init happy_meal_pci_init(void)
-- 
2.35.3




