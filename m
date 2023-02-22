Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F67A69FD6A
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjBVVEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbjBVVES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:04:18 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997854391F;
        Wed, 22 Feb 2023 13:04:12 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id w23so8990223qtn.6;
        Wed, 22 Feb 2023 13:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SSxvCKNu+UmJDrQHidvT2hOlScvmWeOdZokVN4GsHg=;
        b=Buy0wdcfgxY9795QEeYYGIFEizP24tWX1Xqlf3KhG6UuBYg61P/7X9bJkMzWfg+Zsi
         LbMt8z1ExOEZKftnL7d0xvg311hkZvB67gy0rAjOfltk7rQPN/f41AaknNw8F6VbrKbm
         zP5iM5ERVHL4+8VG8uZ4Jx1lesWvMSYlH/E2GZFwTPuMRcZfdTHFpA1c7JkLvb/kh6rU
         E+9cDdrKWd3WlCJahIZTrV7NEeLdQWqAQFYoeNR0nW0T+ub1TgaRAyE00NGNi/jXHIr0
         o4YUQzNLfShC/x9MVrGjMX0ZXGkCjcDsDa3f38+MCuzp4fP6XjWk83OSK65eCL1O4gmG
         4frg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9SSxvCKNu+UmJDrQHidvT2hOlScvmWeOdZokVN4GsHg=;
        b=7LWnJj8GxDVxMXIfJGLZEt2RWu0vuLAXAXKf/Hiy0+G5qYqaNrhJc8UGClt/xNIkkB
         1g26QoqfXNqKuL2MMCmEBwqiceEzzZKS069OqGTIk/p2RT2Z1atawRd3EklhKBlXANa1
         kc58htiY4kP+jIxhXwF/Nc7nfKAc151vWn2ZiSyHPgGBAQq0lloE6EPeML+K/ZlLeDMv
         hTEZw1+vE0hBlKCQmcP0TX+vsASHikuwYe/ycXi+Sefuq19eMwjNbkS0Mv6ERBn/QjlA
         TYKZER4GaO58OTOzVd++P44GFRCH4jXnQRsYemtOUgurg0/9EuF8S+z/pEI+je8aFi8a
         I2kA==
X-Gm-Message-State: AO0yUKXAS6eMGsXJunLLLNEvIiMFWr39B0+avKUo4/i1VhGYj5Mscqw/
        xwa2Zz8m2usw6qNrnZccSmg=
X-Google-Smtp-Source: AK7set9xeYmK5ACKt3skhKCynlN3Olw3Y5Mk2HxQOzgT5ipJku93iCTMAf0dO/Lvq6wJhLNlQV3UIQ==
X-Received: by 2002:a05:622a:4ce:b0:3b6:9b37:e03c with SMTP id q14-20020a05622a04ce00b003b69b37e03cmr15275132qtx.7.1677099851304;
        Wed, 22 Feb 2023 13:04:11 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id n129-20020a37bd87000000b0073b81e888bfsm3273438qkf.56.2023.02.22.13.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 13:04:10 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [RFC PATCH net-next 6/7] net: sunhme: Consolidate mac address initialization
Date:   Wed, 22 Feb 2023 16:03:54 -0500
Message-Id: <20230222210355.2741485-7-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230222210355.2741485-1-seanga2@gmail.com>
References: <20230222210355.2741485-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mac address initialization is braodly the same between PCI and SBUS,
and one was clearly copied from the other. Consolidate them. We still have
to have some ifdefs because pci_(un)map_rom is only implemented for PCI,
and idprom is only implemented for SPARC.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 284 ++++++++++++++----------------
 1 file changed, 135 insertions(+), 149 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 75993834729a..9b55adbe61df 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -34,6 +34,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/of.h>
 #include <linux/random.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -47,7 +48,6 @@
 #include <asm/oplib.h>
 #include <asm/prom.h>
 #include <linux/of_device.h>
-#include <linux/of.h>
 #endif
 #include <linux/uaccess.h>
 
@@ -2313,6 +2313,133 @@ static const struct net_device_ops hme_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+#ifdef CONFIG_PCI
+static int is_quattro_p(struct pci_dev *pdev)
+{
+	struct pci_dev *busdev = pdev->bus->self;
+	struct pci_dev *this_pdev;
+	int n_hmes;
+
+	if (!busdev || busdev->vendor != PCI_VENDOR_ID_DEC ||
+	    busdev->device != PCI_DEVICE_ID_DEC_21153)
+		return 0;
+
+	n_hmes = 0;
+	list_for_each_entry(this_pdev, &pdev->bus->devices, bus_list) {
+		if (this_pdev->vendor == PCI_VENDOR_ID_SUN &&
+		    this_pdev->device == PCI_DEVICE_ID_SUN_HAPPYMEAL)
+			n_hmes++;
+	}
+
+	if (n_hmes != 4)
+		return 0;
+
+	return 1;
+}
+
+/* Fetch MAC address from vital product data of PCI ROM. */
+static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsigned char *dev_addr)
+{
+	int this_offset;
+
+	for (this_offset = 0x20; this_offset < len; this_offset++) {
+		void __iomem *p = rom_base + this_offset;
+
+		if (readb(p + 0) != 0x90 ||
+		    readb(p + 1) != 0x00 ||
+		    readb(p + 2) != 0x09 ||
+		    readb(p + 3) != 0x4e ||
+		    readb(p + 4) != 0x41 ||
+		    readb(p + 5) != 0x06)
+			continue;
+
+		this_offset += 6;
+		p += 6;
+
+		if (index == 0) {
+			int i;
+
+			for (i = 0; i < 6; i++)
+				dev_addr[i] = readb(p + i);
+			return 1;
+		}
+		index--;
+	}
+	return 0;
+}
+
+static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
+						unsigned char *dev_addr)
+{
+	size_t size;
+	void __iomem *p = pci_map_rom(pdev, &size);
+
+	if (p) {
+		int index = 0;
+		int found;
+
+		if (is_quattro_p(pdev))
+			index = PCI_SLOT(pdev->devfn);
+
+		found = readb(p) == 0x55 &&
+			readb(p + 1) == 0xaa &&
+			find_eth_addr_in_vpd(p, (64 * 1024), index, dev_addr);
+		pci_unmap_rom(pdev, p);
+		if (found)
+			return;
+	}
+
+	/* Sun MAC prefix then 3 random bytes. */
+	dev_addr[0] = 0x08;
+	dev_addr[1] = 0x00;
+	dev_addr[2] = 0x20;
+	get_random_bytes(&dev_addr[3], 3);
+}
+#endif /* !(CONFIG_SPARC) */
+
+static void happy_meal_addr_init(struct happy_meal *hp,
+				 struct device_node *dp, int qfe_slot)
+{
+	int i;
+
+	for (i = 0; i < 6; i++) {
+		if (macaddr[i] != 0)
+			break;
+	}
+
+	if (i < 6) { /* a mac address was given */
+		u8 addr[ETH_ALEN];
+
+		for (i = 0; i < 6; i++)
+			addr[i] = macaddr[i];
+		eth_hw_addr_set(hp->dev, addr);
+		macaddr[5]++;
+	} else {
+#ifdef CONFIG_SPARC
+		const unsigned char *addr;
+		int len;
+
+		/* If user did not specify a MAC address specifically, use
+		 * the Quattro local-mac-address property...
+		 */
+		if (qfe_slot != -1) {
+			addr = of_get_property(dp, "local-mac-address", &len);
+			if (addr && len == 6) {
+				eth_hw_addr_set(hp->dev, addr);
+				return;
+			}
+		}
+
+		eth_hw_addr_set(hp->dev, idprom->id_ethaddr);
+#else
+		u8 addr[ETH_ALEN];
+
+		get_hme_mac_nonsparc(hp->happy_dev, addr);
+		eth_hw_addr_set(hp->dev, addr);
+#endif
+	}
+}
+
 #ifdef CONFIG_SBUS
 static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 {
@@ -2320,8 +2447,7 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	struct quattro *qp = NULL;
 	struct happy_meal *hp;
 	struct net_device *dev;
-	int i, qfe_slot = -1;
-	u8 addr[ETH_ALEN];
+	int qfe_slot = -1;
 	int err;
 
 	sbus_dp = op->dev.parent->of_node;
@@ -2346,34 +2472,11 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 		return -ENOMEM;
 	SET_NETDEV_DEV(dev, &op->dev);
 
-	/* If user did not specify a MAC address specifically, use
-	 * the Quattro local-mac-address property...
-	 */
-	for (i = 0; i < 6; i++) {
-		if (macaddr[i] != 0)
-			break;
-	}
-	if (i < 6) { /* a mac address was given */
-		for (i = 0; i < 6; i++)
-			addr[i] = macaddr[i];
-		eth_hw_addr_set(dev, addr);
-		macaddr[5]++;
-	} else {
-		const unsigned char *addr;
-		int len;
-
-		addr = of_get_property(dp, "local-mac-address", &len);
-
-		if (qfe_slot != -1 && addr && len == ETH_ALEN)
-			eth_hw_addr_set(dev, addr);
-		else
-			eth_hw_addr_set(dev, idprom->id_ethaddr);
-	}
-
 	hp = netdev_priv(dev);
-
+	hp->dev = dev;
 	hp->happy_dev = op;
 	hp->dma_dev = &op->dev;
+	happy_meal_addr_init(hp, dp, qfe_slot);
 
 	spin_lock_init(&hp->happy_lock);
 
@@ -2451,7 +2554,6 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 
 	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
 
-	hp->dev = dev;
 	dev->netdev_ops = &hme_netdev_ops;
 	dev->watchdog_timeo = 5*HZ;
 	dev->ethtool_ops = &hme_ethtool_ops;
@@ -2504,104 +2606,17 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 #endif
 
 #ifdef CONFIG_PCI
-#ifndef CONFIG_SPARC
-static int is_quattro_p(struct pci_dev *pdev)
-{
-	struct pci_dev *busdev = pdev->bus->self;
-	struct pci_dev *this_pdev;
-	int n_hmes;
-
-	if (busdev == NULL ||
-	    busdev->vendor != PCI_VENDOR_ID_DEC ||
-	    busdev->device != PCI_DEVICE_ID_DEC_21153)
-		return 0;
-
-	n_hmes = 0;
-	list_for_each_entry(this_pdev, &pdev->bus->devices, bus_list) {
-		if (this_pdev->vendor == PCI_VENDOR_ID_SUN &&
-		    this_pdev->device == PCI_DEVICE_ID_SUN_HAPPYMEAL)
-			n_hmes++;
-	}
-
-	if (n_hmes != 4)
-		return 0;
-
-	return 1;
-}
-
-/* Fetch MAC address from vital product data of PCI ROM. */
-static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsigned char *dev_addr)
-{
-	int this_offset;
-
-	for (this_offset = 0x20; this_offset < len; this_offset++) {
-		void __iomem *p = rom_base + this_offset;
-
-		if (readb(p + 0) != 0x90 ||
-		    readb(p + 1) != 0x00 ||
-		    readb(p + 2) != 0x09 ||
-		    readb(p + 3) != 0x4e ||
-		    readb(p + 4) != 0x41 ||
-		    readb(p + 5) != 0x06)
-			continue;
-
-		this_offset += 6;
-		p += 6;
-
-		if (index == 0) {
-			int i;
-
-			for (i = 0; i < 6; i++)
-				dev_addr[i] = readb(p + i);
-			return 1;
-		}
-		index--;
-	}
-	return 0;
-}
-
-static void get_hme_mac_nonsparc(struct pci_dev *pdev, unsigned char *dev_addr)
-{
-	size_t size;
-	void __iomem *p = pci_map_rom(pdev, &size);
-
-	if (p) {
-		int index = 0;
-		int found;
-
-		if (is_quattro_p(pdev))
-			index = PCI_SLOT(pdev->devfn);
-
-		found = readb(p) == 0x55 &&
-			readb(p + 1) == 0xaa &&
-			find_eth_addr_in_vpd(p, (64 * 1024), index, dev_addr);
-		pci_unmap_rom(pdev, p);
-		if (found)
-			return;
-	}
-
-	/* Sun MAC prefix then 3 random bytes. */
-	dev_addr[0] = 0x08;
-	dev_addr[1] = 0x00;
-	dev_addr[2] = 0x20;
-	get_random_bytes(&dev_addr[3], 3);
-}
-#endif /* !(CONFIG_SPARC) */
-
 static int happy_meal_pci_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
 	struct quattro *qp = NULL;
-#ifdef CONFIG_SPARC
-	struct device_node *dp;
-#endif
+	struct device_node *dp = NULL;
 	struct happy_meal *hp;
 	struct net_device *dev;
 	void __iomem *hpreg_base;
 	struct resource *hpreg_res;
-	int i, qfe_slot = -1;
+	int qfe_slot = -1;
 	char prom_name[64];
-	u8 addr[ETH_ALEN];
 	int err;
 
 	/* Now make sure pci_dev cookie is there. */
@@ -2644,7 +2659,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hp = netdev_priv(dev);
-
+	hp->dev = dev;
 	hp->happy_dev = pdev;
 	hp->dma_dev = &pdev->dev;
 
@@ -2680,35 +2695,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		goto err_out_clear_quattro;
 	}
 
-	for (i = 0; i < 6; i++) {
-		if (macaddr[i] != 0)
-			break;
-	}
-	if (i < 6) { /* a mac address was given */
-		for (i = 0; i < 6; i++)
-			addr[i] = macaddr[i];
-		eth_hw_addr_set(dev, addr);
-		macaddr[5]++;
-	} else {
-#ifdef CONFIG_SPARC
-		const unsigned char *addr;
-		int len;
-
-		if (qfe_slot != -1 &&
-		    (addr = of_get_property(dp, "local-mac-address", &len))
-			!= NULL &&
-		    len == 6) {
-			eth_hw_addr_set(dev, addr);
-		} else {
-			eth_hw_addr_set(dev, idprom->id_ethaddr);
-		}
-#else
-		u8 addr[ETH_ALEN];
-
-		get_hme_mac_nonsparc(pdev, addr);
-		eth_hw_addr_set(dev, addr);
-#endif
-	}
+	happy_meal_addr_init(hp, dp, qfe_slot);
 
 	/* Layout registers. */
 	hp->gregs      = (hpreg_base + 0x0000UL);
@@ -2757,7 +2744,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
 
 	hp->irq = pdev->irq;
-	hp->dev = dev;
 	dev->netdev_ops = &hme_netdev_ops;
 	dev->watchdog_timeo = 5*HZ;
 	dev->ethtool_ops = &hme_ethtool_ops;
-- 
2.37.1

