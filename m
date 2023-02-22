Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61D469FD6C
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjBVVE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbjBVVE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:04:26 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C686D43904;
        Wed, 22 Feb 2023 13:04:13 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id s12so8996579qtq.11;
        Wed, 22 Feb 2023 13:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yXr/s2TKmMBOXDm6+X+zKiZZwzkCCBL69oZT8Z4557o=;
        b=cjpu0YUr+1xre38DZlqX8caGfg+da0ZwHYzXFm+ZjG1KVnYEifsRIS3XRX/n8hD/Mw
         fh1YmB65VElEoVx0X8MSj6F3V1YAa8JO0zAz8weXmMHaaOzelVk+4yhpWvSM0ei6ZXW+
         IpmImj8uHsdehlSoPusBziGC1xswNPCWaI631bX0/pq6RXIcAdjEMxC8FBwcKK52J24W
         UcTkf6UY1rUeJHFus/DGsFkUPvUFo5c+XQSGdDgWo42UfsSALgYREO+BmX0pxcXZBReW
         Zf0Yqgqxa8eU41O0+ZziIYRx2uEaSdTjFNpL6fV0dTb1UGYKiyu3WylTO0TFYKZrbT61
         mtag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yXr/s2TKmMBOXDm6+X+zKiZZwzkCCBL69oZT8Z4557o=;
        b=d6k6LFlEMZdPWybnb1OjIiYSQYBCbOnIUsKJq5cfbAHRZQ0ymgkDjDW3ltx0qoZJNd
         cJpkKzy89H613bOScNoJ5pU3+RSJYbOZDGxIs9TYZ9aALcGB01BnoF0jRquZXTto3DBF
         oMnIST9TsKROMPqwFoUdnKxkUxaXLRCcnD10dkbbo6idn4QPh+MIH/2tL4EdBEeqB9A3
         EGZSFHB4ZlIYmVnllWbH+5vLFsvTLR48AP2najPrXGdQJeCNe4q2WWWjsbRdmt4NOZIZ
         yOFazvqe/q5WeuwD1mf2BghMxIuE6fzsnT2f9rVt7mLZYbN+ABsRYwVWJRZAf9Jl/0Kt
         IPeg==
X-Gm-Message-State: AO0yUKX0kBhlKoyNxjEZGDcBBhopZ2eBXchDGS1tRhIXkKnppCeO5OKo
        ZlpJQXRjVWCwuKmbFT/rfZ+uG8u+P6HD+w==
X-Google-Smtp-Source: AK7set/ZHzosCWfS0spg7U1MCGDHbCSuXbfAPCJEnEdiTUU3ew9wsp2pQfwtl0izCtH318LmF7P9Rg==
X-Received: by 2002:ac8:59cc:0:b0:3b7:ed2c:fbb7 with SMTP id f12-20020ac859cc000000b003b7ed2cfbb7mr18187799qtf.0.1677099852766;
        Wed, 22 Feb 2023 13:04:12 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id 128-20020a370b86000000b0073b59128298sm5138439qkl.48.2023.02.22.13.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 13:04:12 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [RFC PATCH net-next 7/7] net: sunhme: Consolidate common probe tasks
Date:   Wed, 22 Feb 2023 16:03:55 -0500
Message-Id: <20230222210355.2741485-8-seanga2@gmail.com>
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

Most of the second half of the PCI/SBUS probe functions are the same.
Consolidate them into a common function.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 183 ++++++++++++------------------
 1 file changed, 71 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 9b55adbe61df..9404dd4b1023 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2440,6 +2440,71 @@ static void happy_meal_addr_init(struct happy_meal *hp,
 	}
 }
 
+static int happy_meal_common_probe(struct happy_meal *hp,
+				   struct device_node *dp, int minor_rev)
+{
+	struct net_device *dev = hp->dev;
+	int err;
+
+#ifdef CONFIG_SPARC
+	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
+	if (hp->hm_revision == 0xff)
+		hp->hm_revision = 0xc0 | minor_rev;
+#else
+	/* works with this on non-sparc hosts */
+	hp->hm_revision = 0x20;
+#endif
+
+	/* Now enable the feature flags we can. */
+	if (hp->hm_revision == 0x20 || hp->hm_revision == 0x21)
+		hp->happy_flags |= HFLAG_20_21;
+	else if (hp->hm_revision != 0xa0)
+		hp->happy_flags |= HFLAG_NOT_A0;
+
+	hp->happy_block = dmam_alloc_coherent(hp->dma_dev, PAGE_SIZE,
+					      &hp->hblock_dvma, GFP_KERNEL);
+	if (!hp->happy_block)
+		return -ENOMEM;
+
+	/* Force check of the link first time we are brought up. */
+	hp->linkcheck = 0;
+
+	/* Force timer state to 'asleep' with count of zero. */
+	hp->timer_state = asleep;
+	hp->timer_ticks = 0;
+
+	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
+
+	dev->netdev_ops = &hme_netdev_ops;
+	dev->watchdog_timeo = 5 * HZ;
+	dev->ethtool_ops = &hme_ethtool_ops;
+
+	/* Happy Meal can do it all... */
+	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
+	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+
+#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
+	/* Hook up SBUS register/descriptor accessors. */
+	hp->read_desc32 = sbus_hme_read_desc32;
+	hp->write_txd = sbus_hme_write_txd;
+	hp->write_rxd = sbus_hme_write_rxd;
+	hp->read32 = sbus_hme_read32;
+	hp->write32 = sbus_hme_write32;
+#endif
+
+	/* Grrr, Happy Meal comes up by default not advertising
+	 * full duplex 100baseT capabilities, fix this.
+	 */
+	spin_lock_irq(&hp->happy_lock);
+	happy_meal_set_initial_advertisement(hp);
+	spin_unlock_irq(&hp->happy_lock);
+
+	err = devm_register_netdev(hp->dma_dev, dev);
+	if (err)
+		dev_err(hp->dma_dev, "Cannot register net device, aborting.\n");
+	return err;
+}
+
 #ifdef CONFIG_SBUS
 static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 {
@@ -2521,70 +2586,18 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 		goto err_out_clear_quattro;
 	}
 
-	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
-	if (hp->hm_revision == 0xff)
-		hp->hm_revision = 0xa0;
-
-	/* Now enable the feature flags we can. */
-	if (hp->hm_revision == 0x20 || hp->hm_revision == 0x21)
-		hp->happy_flags = HFLAG_20_21;
-	else if (hp->hm_revision != 0xa0)
-		hp->happy_flags = HFLAG_NOT_A0;
-
 	if (qp != NULL)
 		hp->happy_flags |= HFLAG_QUATTRO;
 
+	hp->irq = op->archdata.irqs[0];
+
 	/* Get the supported DVMA burst sizes from our Happy SBUS. */
 	hp->happy_bursts = of_getintprop_default(sbus_dp,
 						 "burst-sizes", 0x00);
 
-	hp->happy_block = dmam_alloc_coherent(&op->dev, PAGE_SIZE,
-					      &hp->hblock_dvma, GFP_KERNEL);
-	if (!hp->happy_block) {
-		err = -ENOMEM;
+	err = happy_meal_common_probe(hp, dp, 0);
+	if (err)
 		goto err_out_clear_quattro;
-	}
-
-	/* Force check of the link first time we are brought up. */
-	hp->linkcheck = 0;
-
-	/* Force timer state to 'asleep' with count of zero. */
-	hp->timer_state = asleep;
-	hp->timer_ticks = 0;
-
-	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
-
-	dev->netdev_ops = &hme_netdev_ops;
-	dev->watchdog_timeo = 5*HZ;
-	dev->ethtool_ops = &hme_ethtool_ops;
-
-	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
-
-	hp->irq = op->archdata.irqs[0];
-
-#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
-	/* Hook up SBUS register/descriptor accessors. */
-	hp->read_desc32 = sbus_hme_read_desc32;
-	hp->write_txd = sbus_hme_write_txd;
-	hp->write_rxd = sbus_hme_write_rxd;
-	hp->read32 = sbus_hme_read32;
-	hp->write32 = sbus_hme_write32;
-#endif
-
-	/* Grrr, Happy Meal comes up by default not advertising
-	 * full duplex 100baseT capabilities, fix this.
-	 */
-	spin_lock_irq(&hp->happy_lock);
-	happy_meal_set_initial_advertisement(hp);
-	spin_unlock_irq(&hp->happy_lock);
-
-	err = devm_register_netdev(&op->dev, dev);
-	if (err) {
-		dev_err(&op->dev, "Cannot register net device, aborting.\n");
-		goto err_out_clear_quattro;
-	}
 
 	platform_set_drvdata(op, hp);
 
@@ -2704,21 +2717,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	hp->bigmacregs = (hpreg_base + 0x6000UL);
 	hp->tcvregs    = (hpreg_base + 0x7000UL);
 
-#ifdef CONFIG_SPARC
-	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
-	if (hp->hm_revision == 0xff)
-		hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
-#else
-	/* works with this on non-sparc hosts */
-	hp->hm_revision = 0x20;
-#endif
-
-	/* Now enable the feature flags we can. */
-	if (hp->hm_revision == 0x20 || hp->hm_revision == 0x21)
-		hp->happy_flags = HFLAG_20_21;
-	else if (hp->hm_revision != 0xa0 && hp->hm_revision != 0xc0)
-		hp->happy_flags = HFLAG_NOT_A0;
-
 	if (qp != NULL)
 		hp->happy_flags |= HFLAG_QUATTRO;
 
@@ -2729,50 +2727,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	/* Assume PCI happy meals can handle all burst sizes. */
 	hp->happy_bursts = DMA_BURSTBITS;
 #endif
-
-	hp->happy_block = dmam_alloc_coherent(&pdev->dev, PAGE_SIZE,
-					      &hp->hblock_dvma, GFP_KERNEL);
-	if (!hp->happy_block) {
-		err = -ENOMEM;
-		goto err_out_clear_quattro;
-	}
-
-	hp->linkcheck = 0;
-	hp->timer_state = asleep;
-	hp->timer_ticks = 0;
-
-	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
-
 	hp->irq = pdev->irq;
-	dev->netdev_ops = &hme_netdev_ops;
-	dev->watchdog_timeo = 5*HZ;
-	dev->ethtool_ops = &hme_ethtool_ops;
 
-	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
-
-#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
-	/* Hook up PCI register/descriptor accessors. */
-	hp->read_desc32 = pci_hme_read_desc32;
-	hp->write_txd = pci_hme_write_txd;
-	hp->write_rxd = pci_hme_write_rxd;
-	hp->read32 = pci_hme_read32;
-	hp->write32 = pci_hme_write32;
-#endif
-
-	/* Grrr, Happy Meal comes up by default not advertising
-	 * full duplex 100baseT capabilities, fix this.
-	 */
-	spin_lock_irq(&hp->happy_lock);
-	happy_meal_set_initial_advertisement(hp);
-	spin_unlock_irq(&hp->happy_lock);
-
-	err = devm_register_netdev(&pdev->dev, dev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot register net device, aborting.\n");
+	err = happy_meal_common_probe(hp, dp, pdev->revision & 0x0f);
+	if (err)
 		goto err_out_clear_quattro;
-	}
 
 	pci_set_drvdata(pdev, hp);
 
-- 
2.37.1

