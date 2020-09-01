Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A5925A0F2
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbgIAVoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbgIAVn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:43:56 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E879FC061246;
        Tue,  1 Sep 2020 14:43:55 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o20so1598270pfp.11;
        Tue, 01 Sep 2020 14:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d5EYoQdI5GiOhLcTx7JrnzA5XeLUDDs4+6VUPTSerPA=;
        b=Dhr0OXSwMkG0bRpkTfycNq261oGM88ld3HaGT3E/qiZGe/CdlJ41K8bw+aCIUes69H
         0dd805tI8SzDwAaFs18ppQNN0JdU9mgi51MUyl3ckHbRrE3eq4NHSL6b6QUu69qVR5ph
         zULkGeHqp6O2+QyGozxijvqnTMvjQnd3tT3m97lBpGzfoqxRZ/Fxq8RC7J7NGwMD5jqj
         vBK84i3k3UJJb4ammM98wvJUYeq/B1XXvpspB7FCRCweLA+NABS2W+qqrKDq+ZSNvfcr
         q5EgjxGIarGgNaUU4l6smACAWRRS46lqpu85wpXO8BKW8bExl7wcMGbOiIrpidbvPsDi
         bU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d5EYoQdI5GiOhLcTx7JrnzA5XeLUDDs4+6VUPTSerPA=;
        b=TWTKq5oiDKnG3nLPftW+RhWqB7APS3iGTrbgHIeuqORjpOXWD8es7H7HckwZwT/OsK
         ECfzByLW5F1XjZeFTc+DaWZa6oWeUDLRbR3y0PMwSbvCYzspFBecJCZ9nN857PmFUomt
         W6HJs+Nw8yktOLKTAZEc8POnarE2r8GzsFPMgYhw9GrOeXEe4BhlBlQsu9Wfbbpm4tQl
         YK/CNQMGKdYvEgefNYCrfjr62WO41kCl6ECZPQ/A68RBm+HMNr94yQ9cpeN+X1J99TB6
         388uQCdBpBIed6Lu6qCDiPRZDRZllp5KZxToljhRkulS9M1AE3WWjSeay9wPKqyzFdSP
         1KEw==
X-Gm-Message-State: AOAM530IcMcDtP3PN3ipLsEAhw2W5r+OMx5jx6gxrvRn8sSAhGHRpA31
        Ra5iKG/1MKgdaVG2T9cBH3IFFAw85sg=
X-Google-Smtp-Source: ABdhPJwCkzLE4JLcy+xP6c4nIhaJCg/VHIRjnnKb01VhjmdOkUx+uCtA6k7TaOvhj7O3wXxtQU8Isw==
X-Received: by 2002:a62:7d51:: with SMTP id y78mr200417pfc.182.1598996635003;
        Tue, 01 Sep 2020 14:43:55 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 131sm128663pfy.5.2020.09.01.14.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 14:43:54 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER)
Subject: [PATCH net-next 2/3] net: systemport: fetch and use clock resources
Date:   Tue,  1 Sep 2020 14:43:47 -0700
Message-Id: <20200901214348.1523403-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200901214348.1523403-1-f.fainelli@gmail.com>
References: <20200901214348.1523403-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We disable clocks shortly after probing the device to save as much power as
possible in case the interface is never used. When bcm_sysport_open() is
invoked, clocks are enabled, and disabled in bcm_sysport_stop().

A similar scheme is applied to the suspend/resume functions.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 30 +++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bcmsysport.h |  1 +
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index dfed9ade6950..91eadba5540c 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -20,6 +20,7 @@
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <net/dsa.h>
+#include <linux/clk.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 
@@ -186,6 +187,11 @@ static int bcm_sysport_set_features(struct net_device *dev,
 				    netdev_features_t features)
 {
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
+	int ret;
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
 
 	/* Read CRC forward */
 	if (!priv->is_lite)
@@ -197,6 +203,8 @@ static int bcm_sysport_set_features(struct net_device *dev,
 	bcm_sysport_set_rx_csum(dev, features);
 	bcm_sysport_set_tx_csum(dev, features);
 
+	clk_disable_unprepare(priv->clk);
+
 	return 0;
 }
 
@@ -1940,6 +1948,8 @@ static int bcm_sysport_open(struct net_device *dev)
 	unsigned int i;
 	int ret;
 
+	clk_prepare_enable(priv->clk);
+
 	/* Reset UniMAC */
 	umac_reset(priv);
 
@@ -1970,7 +1980,8 @@ static int bcm_sysport_open(struct net_device *dev)
 				0, priv->phy_interface);
 	if (!phydev) {
 		netdev_err(dev, "could not attach to PHY\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_clk_disable;
 	}
 
 	/* Reset house keeping link status */
@@ -2048,6 +2059,8 @@ static int bcm_sysport_open(struct net_device *dev)
 	free_irq(priv->irq0, dev);
 out_phy_disconnect:
 	phy_disconnect(phydev);
+out_clk_disable:
+	clk_disable_unprepare(priv->clk);
 	return ret;
 }
 
@@ -2106,6 +2119,8 @@ static int bcm_sysport_stop(struct net_device *dev)
 	/* Disconnect from PHY */
 	phy_disconnect(dev->phydev);
 
+	clk_disable_unprepare(priv->clk);
+
 	return 0;
 }
 
@@ -2487,6 +2502,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	/* Initialize private members */
 	priv = netdev_priv(dev);
 
+	priv->clk = devm_clk_get_optional(&pdev->dev, "sw_sysport");
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
 	/* Allocate number of TX rings */
 	priv->tx_rings = devm_kcalloc(&pdev->dev, txq,
 				      sizeof(struct bcm_sysport_tx_ring),
@@ -2588,6 +2607,8 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 		goto err_deregister_notifier;
 	}
 
+	clk_prepare_enable(priv->clk);
+
 	priv->rev = topctrl_readl(priv, REV_CNTL) & REV_MASK;
 	dev_info(&pdev->dev,
 		 "Broadcom SYSTEMPORT%s " REV_FMT
@@ -2596,6 +2617,8 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 		 (priv->rev >> 8) & 0xff, priv->rev & 0xff,
 		 priv->irq0, priv->irq1, txq, rxq);
 
+	clk_disable_unprepare(priv->clk);
+
 	return 0;
 
 err_deregister_notifier:
@@ -2752,6 +2775,8 @@ static int __maybe_unused bcm_sysport_suspend(struct device *d)
 	if (device_may_wakeup(d) && priv->wolopts)
 		ret = bcm_sysport_suspend_to_wol(priv);
 
+	clk_disable_unprepare(priv->clk);
+
 	return ret;
 }
 
@@ -2765,6 +2790,8 @@ static int __maybe_unused bcm_sysport_resume(struct device *d)
 	if (!netif_running(dev))
 		return 0;
 
+	clk_prepare_enable(priv->clk);
+
 	umac_reset(priv);
 
 	/* Disable the UniMAC RX/TX */
@@ -2844,6 +2871,7 @@ static int __maybe_unused bcm_sysport_resume(struct device *d)
 out_free_tx_rings:
 	for (i = 0; i < dev->num_tx_queues; i++)
 		bcm_sysport_fini_tx_ring(priv, i);
+	clk_disable_unprepare(priv->clk);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 6d80735fbc7f..51800053e88c 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -770,6 +770,7 @@ struct bcm_sysport_priv {
 	u32			wolopts;
 	u8			sopass[SOPASS_MAX];
 	unsigned int		wol_irq_disabled:1;
+	struct clk		*clk;
 
 	/* MIB related fields */
 	struct bcm_sysport_mib	mib;
-- 
2.25.1

