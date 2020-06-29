Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C57020E021
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389589AbgF2Umx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730821AbgF2TOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:03 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2454C0086DA;
        Mon, 29 Jun 2020 02:31:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e9so8027913pgo.9;
        Mon, 29 Jun 2020 02:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y9KYjkbiR1My5Ffq4vIf/Hm4e77c+uBf3NZ5oJyz9ys=;
        b=A6ebBXcZgYVQ4MmoB/nHGk8Jgn7ZEian0Q8zKJFOteyApn8XDBK3mz/j1RRpS3Xkv5
         8tOGySH9jVq3r0NEVP3vVtSDCwCAh+1mMz5DoUYHrzS0QsyFzbSuW7ptHRoRgtwtKVl7
         OqxLMbjiwVUNUHekMWK9GrJr0KljM9lMqsKWYJw+mgCZ5aB8kX8G+064BMMLeXTU6O+B
         q1X9y8gnU2yUc9K1gcn+i9uKnE924tcSnqsWjUC2HLOr4gvTlMd3I1LXbtFMykcHsHZm
         F5ZCgLU9wBfcXRGm8bSDEtcVlxGYB2MUkvYHuavM3G630oOVjc2raTslJAPd4sYGW+og
         QdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y9KYjkbiR1My5Ffq4vIf/Hm4e77c+uBf3NZ5oJyz9ys=;
        b=suUFw3lXkusm1UUWuXSQ5+IiXLXIVysvxDYEZQ7nA/9TPT8J0d3DjAhBxpn+PxkJxh
         IA6r8UGhEFJiUWfNOOxFbr4IaHilO42dE61HKRYYL65SRf94nfK5PYU7X/LZskHPI4oB
         dm9yLZxjfT+e76B1vkEmGJt71q7iMHUK7OOApqDLvsj0YYsph0GYAZ7fmeKmwV7ClqA0
         YfG7FoHuwcnHkrMu3uVtrzlafLPmNuU8w6CgFAY0ztr41Xrr1rvwDR/BeJYZfVKHlUYQ
         ZoTYga2sn9xWGVVOO5cstAPq0d+RXTMcZ754oLoZjzu5v4NQJL8HW7hat/yaw3kgqLc5
         2S5w==
X-Gm-Message-State: AOAM531RvnXusMGn6wYDBgo+4tQJ/rYpQf9uHqKsuX3LVmAl5sQql9ec
        yJnEQnhlD2XMsiunX6pFR7M=
X-Google-Smtp-Source: ABdhPJz/nRI7irHgjO0iq6QaoncxuD3EEDuh0r14Hz0DHIyPXF79779I+BckEkrN3/yh9CfuDsdgXg==
X-Received: by 2002:a62:1d81:: with SMTP id d123mr13563954pfd.38.1593423080148;
        Mon, 29 Jun 2020 02:31:20 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id q20sm2921286pfn.111.2020.06.29.02.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 02:31:19 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 1/5] iavf: use generic power management
Date:   Mon, 29 Jun 2020 14:59:39 +0530
Message-Id: <20200629092943.227910-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
References: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the support of generic PM callbacks, drivers no longer need to use
legacy .suspend() and .resume() in which they had to maintain PCI states
changes and device's power state themselves. The required operations are
done by PCI core.

PCI drivers are not expected to invoke PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device(),
pci_set_power_state(), etc. Their tasks are completed by PCI core itself.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 45 ++++++---------------
 1 file changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index fa82768e5eda..93fa0884ca69 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3772,7 +3772,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return err;
 }
 
-#ifdef CONFIG_PM
 /**
  * iavf_suspend - Power management suspend routine
  * @pdev: PCI device information struct
@@ -3780,11 +3779,10 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  *
  * Called when the system (VM) is entering sleep/suspend.
  **/
-static int iavf_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused iavf_suspend(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct iavf_adapter *adapter = netdev_priv(netdev);
-	int retval = 0;
 
 	netif_device_detach(netdev);
 
@@ -3802,12 +3800,6 @@ static int iavf_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-	pci_disable_device(pdev);
-
 	return 0;
 }
 
@@ -3817,24 +3809,13 @@ static int iavf_suspend(struct pci_dev *pdev, pm_message_t state)
  *
  * Called when the system (VM) is resumed from sleep/suspend.
  **/
-static int iavf_resume(struct pci_dev *pdev)
+static int __maybe_unused iavf_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct iavf_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 	u32 err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	/* pci_restore_state clears dev->state_saved so call
-	 * pci_save_state to restore it.
-	 */
-	pci_save_state(pdev);
-
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot enable PCI device from suspend.\n");
-		return err;
-	}
 	pci_set_master(pdev);
 
 	rtnl_lock();
@@ -3858,7 +3839,6 @@ static int iavf_resume(struct pci_dev *pdev)
 	return err;
 }
 
-#endif /* CONFIG_PM */
 /**
  * iavf_remove - Device Removal Routine
  * @pdev: PCI device information struct
@@ -3960,16 +3940,15 @@ static void iavf_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static SIMPLE_DEV_PM_OPS(iavf_pm_ops, iavf_suspend, iavf_resume);
+
 static struct pci_driver iavf_driver = {
-	.name     = iavf_driver_name,
-	.id_table = iavf_pci_tbl,
-	.probe    = iavf_probe,
-	.remove   = iavf_remove,
-#ifdef CONFIG_PM
-	.suspend  = iavf_suspend,
-	.resume   = iavf_resume,
-#endif
-	.shutdown = iavf_shutdown,
+	.name      = iavf_driver_name,
+	.id_table  = iavf_pci_tbl,
+	.probe     = iavf_probe,
+	.remove    = iavf_remove,
+	.driver.pm = &iavf_pm_ops,
+	.shutdown  = iavf_shutdown,
 };
 
 /**
-- 
2.27.0

