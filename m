Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B02F203604
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgFVLob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbgFVLo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:44:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417C7C061794;
        Mon, 22 Jun 2020 04:44:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a127so8282988pfa.12;
        Mon, 22 Jun 2020 04:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WzDzrg/pch1EgVKcPwg7I2YaiPXfTbbhSV+G88b8TxU=;
        b=LrBa16egO6ZcXQeENGdXRQ7FIz7WVhoOD47Fz0V1DDN8wUgEvTxyDSjCnq2w32QLLg
         DWTRxEXLYqeiwyIH2VPOZ8fFEG3TCsJ4rUqVGnAWpeexvJ2NG/jznb895mdb5txpUifl
         MPq5saQvtjhNwzGKFs+bNDAcqlXYWf7cO1cXzm3V5qTqgyUl/vCI+LIiNqEzHSweaDbN
         JItcbJi/N8NjMDIwiu561FllXW0nhP9uVxb97qAdf+hcH+dJTikr4J3dTOJfoOaNuAoz
         8PztmvySg+/OLHx7gEkyz+pJDKgFCqdVVvHiK5/rNIZd5l8U7AqiMrthl048ShMYj633
         /D4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WzDzrg/pch1EgVKcPwg7I2YaiPXfTbbhSV+G88b8TxU=;
        b=hN5EmsXyOD8+MgwAnwtTIDLJFjUSz74IXoapnme7jyT6rMgPZ8MlyVZln/RniQlGho
         DME9Cjfs1Qz9nnUGTqXx2PIAbzmuZ5lZJdpsoCc8ZQJNA7xX5M+GmfZrkMDBD3cDFV1W
         ZvgiQ5nsgON6E/VQzS0yxN786KxJh1pUk+aKkHUxssgI+uFLWxGgLSoCdefmFL2Dfx00
         1I06Pw6nNV+iOm1o84gpoKJP6kF+7Y6iDuZVJD8X31xRvKtq6pErudIahmRlz3ePdBG5
         JGb9frG4vD/WRehwmbTHTKAZvBCKeO14z9PtxyW5VWIc30JMB5qNTqxVJeVDz5at/LLb
         L0Xw==
X-Gm-Message-State: AOAM530XKavUempk9vzU+CyB21fepQ/0IGlH8Q/VK7LPPnCkTJAB6q5r
        qbHHZgs8hhSxTYfYwrSpjjs=
X-Google-Smtp-Source: ABdhPJw5y8pVGRO9YS9EL2B22De7BqsHzxNEVwiayIQ15BCyd9Z7GI041VolqqPSR2j7lDxhzqFXOQ==
X-Received: by 2002:a63:d317:: with SMTP id b23mr12566402pgg.132.1592826266721;
        Mon, 22 Jun 2020 04:44:26 -0700 (PDT)
Received: from varodek.localdomain ([2401:4900:b8b:123e:d7ae:5602:b3d:9c0])
        by smtp.gmail.com with ESMTPSA id j17sm14081032pjy.22.2020.06.22.04.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:44:26 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 4/5] tulip: tulip_core: use generic power management
Date:   Mon, 22 Jun 2020 17:12:27 +0530
Message-Id: <20200622114228.60027-5-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
References: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the support of generic PM callbacks, drivers no longer need to use
legacy .suspend() and .resume() in which they had to maintain PCI
states changes and device's power state themselves.

Earlier, .suspend() and .resume() were invoking pci_disable_device()
and pci_enable_device() respectively to manage the device's power state.
driver also invoked pci_save/restore_state() and pci_set_power_sitate().
With generic PM, it is no longer needed. The driver is expected to just
implement driver-specific operations and leave power transitions to PCI
core.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/dec/tulip/tulip_core.c | 51 +++++----------------
 1 file changed, 12 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 15efc294f513..9db23527275a 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1803,13 +1803,9 @@ static void tulip_set_wolopts (struct pci_dev *pdev, u32 wolopts)
 	}
 }
 
-#ifdef CONFIG_PM
-
-
-static int tulip_suspend (struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused tulip_suspend(struct device *dev_d)
 {
-	pci_power_t pstate;
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct tulip_private *tp = netdev_priv(dev);
 
 	if (!dev)
@@ -1825,45 +1821,27 @@ static int tulip_suspend (struct pci_dev *pdev, pm_message_t state)
 	free_irq(tp->pdev->irq, dev);
 
 save_state:
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pstate = pci_choose_state(pdev, state);
-	if (state.event == PM_EVENT_SUSPEND && pstate != PCI_D0) {
-		int rc;
-
-		tulip_set_wolopts(pdev, tp->wolinfo.wolopts);
-		rc = pci_enable_wake(pdev, pstate, tp->wolinfo.wolopts);
-		if (rc)
-			pr_err("pci_enable_wake failed (%d)\n", rc);
-	}
-	pci_set_power_state(pdev, pstate);
+	tulip_set_wolopts(to_pci_dev(dev_d), tp->wolinfo.wolopts);
+	device_set_wakeup_enable(dev_d, !!tp->wolinfo.wolopts);
 
 	return 0;
 }
 
-
-static int tulip_resume(struct pci_dev *pdev)
+static int __maybe_unused tulip_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct pci_dev *pdev = to_pci_dev(dev_d);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct tulip_private *tp = netdev_priv(dev);
 	void __iomem *ioaddr = tp->base_addr;
-	int retval;
 	unsigned int tmp;
+	int retval = 0;
 
 	if (!dev)
 		return -EINVAL;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
 	if (!netif_running(dev))
 		return 0;
 
-	if ((retval = pci_enable_device(pdev))) {
-		pr_err("pci_enable_device failed in resume\n");
-		return retval;
-	}
-
 	retval = request_irq(pdev->irq, tulip_interrupt, IRQF_SHARED,
 			     dev->name, dev);
 	if (retval) {
@@ -1872,8 +1850,7 @@ static int tulip_resume(struct pci_dev *pdev)
 	}
 
 	if (tp->flags & COMET_PM) {
-		pci_enable_wake(pdev, PCI_D3hot, 0);
-		pci_enable_wake(pdev, PCI_D3cold, 0);
+		device_set_wakeup_enable(dev_d, 0);
 
 		/* Clear the PMES flag */
 		tmp = ioread32(ioaddr + CSR20);
@@ -1891,9 +1868,6 @@ static int tulip_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#endif /* CONFIG_PM */
-
-
 static void tulip_remove_one(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata (pdev);
@@ -1937,15 +1911,14 @@ static void poll_tulip (struct net_device *dev)
 }
 #endif
 
+static SIMPLE_DEV_PM_OPS(tulip_pm_ops, tulip_suspend, tulip_resume);
+
 static struct pci_driver tulip_driver = {
 	.name		= DRV_NAME,
 	.id_table	= tulip_pci_tbl,
 	.probe		= tulip_init_one,
 	.remove		= tulip_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= tulip_suspend,
-	.resume		= tulip_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &tulip_pm_ops,
 };
 
 
-- 
2.27.0

