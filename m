Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10454B59F0
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 19:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350001AbiBNSbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 13:31:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbiBNSbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 13:31:20 -0500
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA46652DF
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 10:31:12 -0800 (PST)
Received: (qmail 3113 invoked from network); 14 Feb 2022 18:29:25 -0000
Received: from p200300cf070c090076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:70c:900:76d4:35ff:feb7:be92]:55228 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 19:29:25 +0100
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     netdev@vger.kernel.org
Subject: [PATCH 4/x] sunhme: switch to devres
Date:   Mon, 14 Feb 2022 19:31:09 +0100
Message-ID: <11922663.O9o76ZdvQC@eto.sf-tec.de>
In-Reply-To: <4686583.GXAFRqVoOG@eto.sf-tec.de>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
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

This not only removes a lot of code, it also fixes the memleak of the DMA
memory when register_netdev() fails.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/net/ethernet/sun/sunhme.c | 55 +++++++++----------------------
 1 file changed, 16 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 980a936ce8d1..ec78f43f75c9 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2952,7 +2952,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	struct happy_meal *hp;
 	struct net_device *dev;
 	void __iomem *hpreg_base;
-	unsigned long hpreg_res;
 	int i, qfe_slot = -1;
 	char prom_name[64];
 	u8 addr[ETH_ALEN];
@@ -2969,7 +2968,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		strcpy(prom_name, "SUNW,hme");
 #endif
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 
 	if (err)
 		goto err_out;
@@ -2987,10 +2986,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
@@ -3009,21 +3009,23 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
@@ -3089,11 +3091,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
@@ -3127,11 +3128,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	happy_meal_set_initial_advertisement(hp);
 	spin_unlock_irq(&hp->happy_lock);
 
-	err = register_netdev(hp->dev);
+	err = devm_register_netdev(&pdev->dev, dev);
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_iounmap;
+		goto err_out_clear_quattro;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3164,37 +3165,14 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
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
@@ -3206,7 +3184,6 @@ static struct pci_driver hme_pci_driver = {
 	.name		= "hme",
 	.id_table	= happymeal_pci_ids,
 	.probe		= happy_meal_pci_probe,
-	.remove		= happy_meal_pci_remove,
 };
 
 static int __init happy_meal_pci_init(void)
-- 
2.34.1




