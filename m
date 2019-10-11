Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E62AD4477
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfJKPez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 11:34:55 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42762 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfJKPez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 11:34:55 -0400
Received: by mail-qt1-f196.google.com with SMTP id w14so14424282qto.9
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 08:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=2TneVaqkEeq7iRsx8qpUF3PWYTP/k7iRKEvf+OH4SAM=;
        b=hvgkB9NSY9OOOARCqHzjvawgDiVddbwdhx2EG1OuiCP48FoQLPnOa326Vc93eys/HQ
         7EDSX1VDepP6ekoR+uaacLRAVgTx//XgcaBU4/LdB/jaq3hbjs2tlvvNgyNlU7EwPYxN
         1KbxAPuznBJQYgSjPl4i7ORR9ijB80EG3SELMDE6HhyZPbDdicR6COroWcyh6pxxlG5v
         91018w7D7y3/jnwUhgMZYMk35ISopyB9uHKJyqgPzJJ77P6Z4l5ezFzPFbHxKjVprAtS
         Tr2SWpexie93ePcAmnoHP4Kmi9u4JEfecfUVQ1jxdep0903Q6Z4eXA3AFtWxIH931E9l
         ec0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=2TneVaqkEeq7iRsx8qpUF3PWYTP/k7iRKEvf+OH4SAM=;
        b=PSZj6DrWaC769dYc2Od0AMZ7pFOQVH+IuJuqZn+NzCYFwmdAKhKWq8BLgAOvIQdv3h
         ulVrmBwpQ1R4fbcfyAt5XOOpTr5heXFighbNZghk8MV6hbbUlnp8as1pj8j3dT1XK3vC
         k+sYgYmm6dCzLmK4vSE9Qqzr8Q4k3odiujIH4vbDgUhiiDqyYf6nNDqZRrUey4ASVC+r
         PFVnD71Lk2dKxxFh72HR83BBiarD6z2s9EruB8o+/DKfavgtKRn0ZwEQvm4Q84PYiPCB
         niyBszXhCyoXM8AGzGz3lFN8h4FXahAifvMjvMdnLqrZpqNjF/N32tMK9spGVtBidOah
         m/hA==
X-Gm-Message-State: APjAAAUmJ9GYEgIW6WMCi7VSImUGIWF6TnOOOUCGL77eELXpBdVlS0Bb
        GoYbGrODNNyAUzNnxwFHWUI=
X-Google-Smtp-Source: APXvYqx5GuDSEFLUieBCplZoo7+ZF+DCt+DvOTvBNBAQa2iTVa0mNRjgSfSL9deseyETIedwJLL0oQ==
X-Received: by 2002:ac8:108e:: with SMTP id a14mr17902032qtj.225.1570808094266;
        Fri, 11 Oct 2019 08:34:54 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 63sm4345649qkh.82.2019.10.11.08.34.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 08:34:53 -0700 (PDT)
Subject: [next-queue PATCH v2 1/2] e1000e: Use rtnl_lock to prevent race
 conditions between net and pci/pm
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     alexander.h.duyck@linux.intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Date:   Fri, 11 Oct 2019 08:34:52 -0700
Message-ID: <20191011153452.22313.70522.stgit@localhost.localdomain>
In-Reply-To: <20191011153219.22313.60179.stgit@localhost.localdomain>
References: <20191011153219.22313.60179.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

This patch is meant to address possible race conditions that can exist
between network configuration and power management. A similar issue was
fixed for igb in commit 9474933caf21 ("igb: close/suspend race in
netif_device_detach").

In addition it consolidates the code so that the PCI error handling code
will essentially perform the power management freeze on the device prior to
attempting a reset, and will thaw the device afterwards if that is what it
is planning to do. Otherwise when we call close on the interface it should
see it is detached and not attempt to call the logic to down the interface
and free the IRQs again.

>From what I can tell the check that was adding the check for __E1000_DOWN
in e1000e_close was added when runtime power management was added. However
it should not be relevant for us as we perform a call to
pm_runtime_get_sync before we call e1000_down/free_irq so it should always
be back up before we call into this anyway.

Reported-by: Morumuri Srivalli <smorumu1@in.ibm.com>
Tested-by: David Dai <zdai@linux.vnet.ibm.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   68 ++++++++++++++--------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index d7d56e42a6aa..db1591eef28e 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4715,12 +4715,12 @@ int e1000e_close(struct net_device *netdev)
 
 	pm_runtime_get_sync(&pdev->dev);
 
-	if (!test_bit(__E1000_DOWN, &adapter->state)) {
+	if (netif_device_present(netdev)) {
 		e1000e_down(adapter, true);
 		e1000_free_irq(adapter);
 
 		/* Link status message must follow this format */
-		pr_info("%s NIC Link is Down\n", adapter->netdev->name);
+		pr_info("%s NIC Link is Down\n", netdev->name);
 	}
 
 	napi_disable(&adapter->napi);
@@ -6298,10 +6298,14 @@ static int e1000e_pm_freeze(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	bool present;
 
+	rtnl_lock();
+
+	present = netif_device_present(netdev);
 	netif_device_detach(netdev);
 
-	if (netif_running(netdev)) {
+	if (present && netif_running(netdev)) {
 		int count = E1000_CHECK_RESET_COUNT;
 
 		while (test_bit(__E1000_RESETTING, &adapter->state) && count--)
@@ -6313,6 +6317,8 @@ static int e1000e_pm_freeze(struct device *dev)
 		e1000e_down(adapter, false);
 		e1000_free_irq(adapter);
 	}
+	rtnl_unlock();
+
 	e1000e_reset_interrupt_capability(adapter);
 
 	/* Allow time for pending master requests to run */
@@ -6560,6 +6566,30 @@ static void e1000e_disable_aspm_locked(struct pci_dev *pdev, u16 state)
 	__e1000e_disable_aspm(pdev, state, 1);
 }
 
+static int e1000e_pm_thaw(struct device *dev)
+{
+	struct net_device *netdev = dev_get_drvdata(dev);
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	int rc = 0;
+
+	e1000e_set_interrupt_capability(adapter);
+
+	rtnl_lock();
+	if (netif_running(netdev)) {
+		rc = e1000_request_irq(adapter);
+		if (rc)
+			goto err_irq;
+
+		e1000e_up(adapter);
+	}
+
+	netif_device_attach(netdev);
+err_irq:
+	rtnl_unlock();
+
+	return rc;
+}
+
 #ifdef CONFIG_PM
 static int __e1000_resume(struct pci_dev *pdev)
 {
@@ -6627,26 +6657,6 @@ static int __e1000_resume(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int e1000e_pm_thaw(struct device *dev)
-{
-	struct net_device *netdev = dev_get_drvdata(dev);
-	struct e1000_adapter *adapter = netdev_priv(netdev);
-
-	e1000e_set_interrupt_capability(adapter);
-	if (netif_running(netdev)) {
-		u32 err = e1000_request_irq(adapter);
-
-		if (err)
-			return err;
-
-		e1000e_up(adapter);
-	}
-
-	netif_device_attach(netdev);
-
-	return 0;
-}
-
 static int e1000e_pm_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -6818,16 +6828,11 @@ static void e1000_netpoll(struct net_device *netdev)
 static pci_ers_result_t e1000_io_error_detected(struct pci_dev *pdev,
 						pci_channel_state_t state)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct e1000_adapter *adapter = netdev_priv(netdev);
-
-	netif_device_detach(netdev);
+	e1000e_pm_freeze(&pdev->dev);
 
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
 
-	if (netif_running(netdev))
-		e1000e_down(adapter, true);
 	pci_disable_device(pdev);
 
 	/* Request a slot slot reset. */
@@ -6893,10 +6898,7 @@ static void e1000_io_resume(struct pci_dev *pdev)
 
 	e1000_init_manageability_pt(adapter);
 
-	if (netif_running(netdev))
-		e1000e_up(adapter);
-
-	netif_device_attach(netdev);
+	e1000e_pm_thaw(&pdev->dev);
 
 	/* If the controller has AMT, do not set DRV_LOAD until the interface
 	 * is up.  For all other cases, let the f/w know that the h/w is now

