Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91ECC215449
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 10:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgGFI7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgGFI7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:59:23 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA887C061794;
        Mon,  6 Jul 2020 01:59:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u185so14666574pfu.1;
        Mon, 06 Jul 2020 01:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Siz3bxxyV1/zH62RcfdMI8QZg8xb8VeCbmLg5psjeec=;
        b=o+2UI8AaZABsIZxHHojuhY2GLtTdQdF/g27z33gX4YJ4G8kKCqaLAgA4oRBn7bhKM5
         AUdrAegYSggJsTf1mTop1GjAt9DsOj89Ey1XWAxN0XFTlpeTGFfS1k7GbChPc/Fxa6eZ
         nOp/4MT1x8CSmxXtrfinXKL2kKLgWhwbjup5DaCSDNr6hQonSlyopnn1NtWllEHd6+21
         5LdcRX0BzlVvWt7N57JRyH+d1dWCC0lH3NKsv7nweeMn4mLJspOVNMVB7mefVKkqGdIk
         WefPXyMwXkgBG6fPhrLMlbVerybcHFC5GFoz/VJSmQTTqEQqA5hv2/37+94oSQNPYkd1
         J3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Siz3bxxyV1/zH62RcfdMI8QZg8xb8VeCbmLg5psjeec=;
        b=DONEaGkNe1cIYRso3ZR14tHkoit285AxFpha9t3sGjl/YwyPhIczWXAL93cX3n7n56
         jFKB2YJKwhfxIr/HyyNdHW/HWaPsOoxztYSyAsZbAW1wG2nDT51qkW6mvHbE7mXbYbx2
         JcHrrfGzTpUa8Hal27F+kUzULSEefAVA4un+fpw7cFe31wzDo4nElHwXjnn4U7RU1pms
         R+eafsYiSN+lBiaewbNJ4/GbSgttgLj+eB8qp4Lvp2B5QxksQj9Up8+7WUnLEHY26/7X
         BH+v2K3oos88Qk98bg6rwq8eYIYIcoOqFsYOsViJxDDC3+Qlkm7UJULSSo5M9ssjBlN3
         J19A==
X-Gm-Message-State: AOAM531cZkXliPLUw7uzcR4k+M1sIIXs0QHtlWi03BDkvpX8S2c9TPyM
        pwhk2FwsV2AkZ+Wfss7Q01E=
X-Google-Smtp-Source: ABdhPJyCM6S5r1KIMCNbQvS4tyfGD51BelscWg9R1EmysmNM1+jREFRtNDTZgc3o+vIXMVaqncLcsg==
X-Received: by 2002:a63:c60f:: with SMTP id w15mr20360473pgg.113.1594025963187;
        Mon, 06 Jul 2020 01:59:23 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id a19sm10068149pfn.136.2020.07.06.01.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 01:59:22 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 1/3] sun/sungem: use generic power management
Date:   Mon,  6 Jul 2020 14:27:44 +0530
Message-Id: <20200706085746.221992-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706085746.221992-1-vaibhavgupta40@gmail.com>
References: <20200706085746.221992-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states. And they use PCI
helper functions to do it.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

In this driver:
gem_suspend() calls gem_do_stop() which in turn invokes
pci_disable_device(). As the PCI helper function is not called at the
end/start of the function body, breaking the function in two parts
may change its behavior.

The only other function invoking gem_do_stop() is gem_close(). Hence,
gem_close() and gem_suspend() can do the required end steps on their own.

The same case is with gem_resume(). Both gem_resume() and gem_open()
invoke gem_do_start(). Again, make the caller functions do the required
steps on their own.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/sun/sungem.c | 76 +++++++++++++++++--------------
 1 file changed, 43 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 2d392a7b179a..0e9d2cf7979b 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2139,20 +2139,6 @@ static int gem_do_start(struct net_device *dev)
 	struct gem *gp = netdev_priv(dev);
 	int rc;
 
-	/* Enable the cell */
-	gem_get_cell(gp);
-
-	/* Make sure PCI access and bus master are enabled */
-	rc = pci_enable_device(gp->pdev);
-	if (rc) {
-		netdev_err(dev, "Failed to enable chip on PCI bus !\n");
-
-		/* Put cell and forget it for now, it will be considered as
-		 * still asleep, a new sleep cycle may bring it back
-		 */
-		gem_put_cell(gp);
-		return -ENXIO;
-	}
 	pci_set_master(gp->pdev);
 
 	/* Init & setup chip hardware */
@@ -2230,13 +2216,6 @@ static void gem_do_stop(struct net_device *dev, int wol)
 
 	/* Shut the PHY down eventually and setup WOL */
 	gem_stop_phy(gp, wol);
-
-	/* Make sure bus master is disabled */
-	pci_disable_device(gp->pdev);
-
-	/* Cell not needed neither if no WOL */
-	if (!wol)
-		gem_put_cell(gp);
 }
 
 static void gem_reset_task(struct work_struct *work)
@@ -2288,26 +2267,53 @@ static void gem_reset_task(struct work_struct *work)
 
 static int gem_open(struct net_device *dev)
 {
+	struct gem *gp = netdev_priv(dev);
+	int rc;
+
 	/* We allow open while suspended, we just do nothing,
 	 * the chip will be initialized in resume()
 	 */
-	if (netif_device_present(dev))
+	if (netif_device_present(dev)) {
+		/* Enable the cell */
+		gem_get_cell(gp);
+
+		/* Make sure PCI access and bus master are enabled */
+		rc = pci_enable_device(gp->pdev);
+		if (rc) {
+			netdev_err(dev, "Failed to enable chip on PCI bus !\n");
+
+			/* Put cell and forget it for now, it will be considered
+			 *as still asleep, a new sleep cycle may bring it back
+			 */
+			gem_put_cell(gp);
+			return -ENXIO;
+		}
 		return gem_do_start(dev);
+	}
+
 	return 0;
 }
 
 static int gem_close(struct net_device *dev)
 {
-	if (netif_device_present(dev))
+	struct gem *gp = netdev_priv(dev);
+
+	if (netif_device_present(dev)) {
 		gem_do_stop(dev, 0);
 
+		/* Make sure bus master is disabled */
+		pci_disable_device(gp->pdev);
+
+		/* Cell not needed neither if no WOL */
+		if (!gp->asleep_wol)
+			gem_put_cell(gp);
+	}
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int gem_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused gem_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct gem *gp = netdev_priv(dev);
 
 	/* Lock the network stack first to avoid racing with open/close,
@@ -2336,15 +2342,19 @@ static int gem_suspend(struct pci_dev *pdev, pm_message_t state)
 	gp->asleep_wol = !!gp->wake_on_lan;
 	gem_do_stop(dev, gp->asleep_wol);
 
+	/* Cell not needed neither if no WOL */
+	if (!gp->asleep_wol)
+		gem_put_cell(gp);
+
 	/* Unlock the network stack */
 	rtnl_unlock();
 
 	return 0;
 }
 
-static int gem_resume(struct pci_dev *pdev)
+static int __maybe_unused gem_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct gem *gp = netdev_priv(dev);
 
 	/* See locking comment in gem_suspend */
@@ -2359,6 +2369,9 @@ static int gem_resume(struct pci_dev *pdev)
 		return 0;
 	}
 
+	/* Enable the cell */
+	gem_get_cell(gp);
+
 	/* Restart chip. If that fails there isn't much we can do, we
 	 * leave things stopped.
 	 */
@@ -2375,7 +2388,6 @@ static int gem_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 static struct net_device_stats *gem_get_stats(struct net_device *dev)
 {
@@ -3019,16 +3031,14 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 }
 
+static SIMPLE_DEV_PM_OPS(gem_pm_ops, gem_suspend, gem_resume);
 
 static struct pci_driver gem_driver = {
 	.name		= GEM_MODULE_NAME,
 	.id_table	= gem_pci_tbl,
 	.probe		= gem_init_one,
 	.remove		= gem_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= gem_suspend,
-	.resume		= gem_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &gem_pm_ops,
 };
 
 module_pci_driver(gem_driver);
-- 
2.27.0

