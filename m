Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84C220357B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgFVLRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgFVLPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:15:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD849C061794;
        Mon, 22 Jun 2020 04:15:19 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id a127so8253490pfa.12;
        Mon, 22 Jun 2020 04:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=boZlC9cES8mgQCV+vpw6dNMvA6C5kwGu41XuL0MFGgA=;
        b=PRvKW7jpjFDQZB+xI+fv7l1+6uyRhIvN+jwRydmIvNXCfTHEFJUgIg7UFP/RCCvpC3
         iheuYvX9zRE9A4DGoFqwHyuGxl2yHCIOGDIFemHkWrJpTF83FSgJnht6I8Q1s6yCyLeu
         L5+v8WzaxYUv2CRjdFQnOlxYYwUwOUY+QiCeLTg+tMJey/+Os8vE9E6pvteqbOuCLdNn
         B/vy/3/GUoGB3p7VTZLaHBiie2hkKxp7LLkBuSelFeM2Lj85kPrNzL8tVQEwh6msaSRW
         gDI0ald+clzrjHgJUFKfp9+BjXv8KmJ8TT9k4mfSQzqgZqwPdFWjA3mvwEMqYQjp6zNS
         n2hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=boZlC9cES8mgQCV+vpw6dNMvA6C5kwGu41XuL0MFGgA=;
        b=oIWVP3lNHjTYNnfdk2FD71bN4K5XDty+zKfbKripfPMD7F8c/YqOOwQjvN/KdEeQ6o
         7T5bRwHdlyE8NbQ/dlL6v8eU/pukcpiFnjg+SdnA1+RutozYHDPHFu6l3YJ1Il7C/Q/P
         QFjMo91lTUgRTSGe54+dx3BbnHN4tAW4WBVkedU+tgj0k0EAIraa25CItu+cm06JQF1H
         mKhArY74XtMuXOUOnZ2ZLGpKE4+TnA0M2ZF4WzvPqQrWjavdIJx1HXhbaocT6mwPuD+E
         lypaiAV+52M9yZ15VyhlghLwT7ByyeMsS2LDJ67AJ5uLsPjPMRNpjTCTvbJjxw3wHsOh
         yjOw==
X-Gm-Message-State: AOAM533Ag0cH5MueP3z0Ml2+K1uZZtJSCC1r3ZV6V2j8Lty9tMllSFN3
        LwE2bKhh0+yHUSnIDCAqtJE=
X-Google-Smtp-Source: ABdhPJw/taOWEhajmwkCme2jqEzJdtG/AhwlsDmEpk+Ykf4yZTn3KQJ1fZ6y0ECdx3diyFSwpM7XaA==
X-Received: by 2002:a63:c004:: with SMTP id h4mr12497488pgg.385.1592824519235;
        Mon, 22 Jun 2020 04:15:19 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id n189sm13950150pfn.108.2020.06.22.04.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:15:18 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Don Fry <pcnet32@frontier.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v2 1/3] pcnet32: Convert to generic power management
Date:   Mon, 22 Jun 2020 16:43:58 +0530
Message-Id: <20200622111400.55956-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622111400.55956-1-vaibhavgupta40@gmail.com>
References: <20200622111400.55956-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove legacy PM callbacks and use generic operations. With legacy code,
drivers were responsible for handling PCI PM operations like
pci_save_state(). In generic code, all these are handled by PCI core.

The generic suspend() and resume() are called at the same point the legacy
ones were called. Thus, it does not affect the normal functioning of the
driver.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/amd/pcnet32.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 07e8211eea51..d32f54d760e7 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -2913,30 +2913,27 @@ static void pcnet32_watchdog(struct timer_list *t)
 	mod_timer(&lp->watchdog_timer, round_jiffies(PCNET32_WATCHDOG_TIMEOUT));
 }
 
-static int pcnet32_pm_suspend(struct pci_dev *pdev, pm_message_t state)
+static int pcnet32_pm_suspend(struct device *device_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(device_d);
 
 	if (netif_running(dev)) {
 		netif_device_detach(dev);
 		pcnet32_close(dev);
 	}
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
 	return 0;
 }
 
-static int pcnet32_pm_resume(struct pci_dev *pdev)
+static int pcnet32_pm_resume(struct device *device_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
+	struct net_device *dev = dev_get_drvdata(device_d);
 
 	if (netif_running(dev)) {
 		pcnet32_open(dev);
 		netif_device_attach(dev);
 	}
+
 	return 0;
 }
 
@@ -2957,13 +2954,16 @@ static void pcnet32_remove_one(struct pci_dev *pdev)
 	}
 }
 
+static SIMPLE_DEV_PM_OPS(pcnet32_pm_ops, pcnet32_pm_suspend, pcnet32_pm_resume);
+
 static struct pci_driver pcnet32_driver = {
 	.name = DRV_NAME,
 	.probe = pcnet32_probe_pci,
 	.remove = pcnet32_remove_one,
 	.id_table = pcnet32_pci_tbl,
-	.suspend = pcnet32_pm_suspend,
-	.resume = pcnet32_pm_resume,
+	.driver = {
+		.pm = &pcnet32_pm_ops,
+	},
 };
 
 /* An additional parameter that may be passed in... */
-- 
2.27.0

