Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942496B5FB0
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjCKSTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjCKSTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:19:30 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42595B419;
        Sat, 11 Mar 2023 10:19:18 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id y3so5761223qvn.4;
        Sat, 11 Mar 2023 10:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9qc042YGsZJMxlp8gBrIPO5C05rmMgtPlJZkGwaGiY=;
        b=GbPae1jg3ObtbqHz9p8sGK0acHd0Q95uJetufdC84Ma4+lIRPr5S8w/Puozgee9zPH
         GBvm11j6nufguY5QiVCmjmgE9Me3Mhd7OkaeklYXzPSMm34A2awhkt8Yik0z5cNm41iv
         OW50SWy2scYNf+Tg8CsH9X7cKXpPvqzdqPp9MQIQnOWHKjIlyuffBBmENIqTU3buOm5j
         ntKx+/9YDl/k5U+KxeWAM+YUhGjhqotE48IiRS9kB3/348/c1fJO/Nm4EiUiSDffO7Xz
         DawrM42qPWkTCm3ein+y2LDM1XdXT8v0BtEBr5Pqd8Ooo+enaYncN+d9Dx7axF3oENS8
         L6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9qc042YGsZJMxlp8gBrIPO5C05rmMgtPlJZkGwaGiY=;
        b=B5p2hYZzR54bpUCx7D99jhAWNTox61intjOJGBX1Zkqr3Vqq4oLBUd9rBOFYNuZUnJ
         FWEcElvPMUrlefbxIfH8OHhGLWP/ldvAtlHMnq9PKMpl8SqCPviQug6z4c+cyPSx5A9k
         6ux17dvOixrg9wxyRgNYEwwgUnCN3WRdvVm1zMI8kWY7zd3N8LnoF52RDecYVEmXbsq/
         AdpxW0WSOlCFf+mlHQSJJdbo4Jn5hE5IQt+EqW6EQX89GaSvUQWTz+khoKWmqmSOoUkH
         Has75tVEwiLx3TpNgAWMocya9Ly/Z10r4xxr8LbZfazSx0RBa/2RS42a5YfW5n1IEhLo
         7oCg==
X-Gm-Message-State: AO0yUKXqfjpV13boaUNl6BVbQn+rBncs3lO8dets6d858Xdk/XSGhdKK
        ICbaQtNETzVJvUrCEGtVyjo=
X-Google-Smtp-Source: AK7set+/8Mn/M3ucLyCcVBqPfTCtMDgcR1XTePfBwt8MJFHhv4pVj9Ac8rg0RtO336LNfRskJVSCNg==
X-Received: by 2002:a05:6214:2523:b0:56e:a290:aa92 with SMTP id gg3-20020a056214252300b0056ea290aa92mr5846280qvb.9.1678558757972;
        Sat, 11 Mar 2023 10:19:17 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id y12-20020ac8524c000000b003b643951117sm2252556qtn.38.2023.03.11.10.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:19:17 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 9/9] net: sunhme: Consolidate common probe tasks
Date:   Sat, 11 Mar 2023 13:19:05 -0500
Message-Id: <20230311181905.3593904-10-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311181905.3593904-1-seanga2@gmail.com>
References: <20230311181905.3593904-1-seanga2@gmail.com>
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

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 183 ++++++++++++------------------
 1 file changed, 71 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 0b903ece624a..5c66efe93fd0 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2430,6 +2430,71 @@ static void happy_meal_addr_init(struct happy_meal *hp,
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
@@ -2511,70 +2576,18 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
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
 
@@ -2689,21 +2702,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
 
@@ -2714,50 +2712,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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

