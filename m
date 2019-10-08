Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC2BFD02AF
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbfJHVQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:16:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38638 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730674AbfJHVQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:16:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id h195so134351pfe.5
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 14:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=9BgLihdw1ZoyXxJf00Tp5DPDBIpdV66c7ObSF0tnLfs=;
        b=pKvwcmZ3xe0XMI3Ya/L5wFZ7MGKLCiROvKWI0Kd4vXrPCLv/DjL+FOADw7hpe1jP53
         Qj0qlXiAilGyuwiLvj9UsqxIwcL7fsEY6b9U23v3ix+I5+td4jtaGaghqmGlUmwb6c+b
         Cn2frpZlHhvn+X/AhqbAqQdJqyVQgo01kM042F2mhsAR6hvCG7R4rddIFKL2XhZscBZC
         +BWquFmjZU5iMMaTpNvZg/xcUGYTxZlwgvJb4pewCILoMRSJObIM1aGeIlECX4GgWFkV
         GBXrqamNhfqGnGE1PYlfGJ6e43K3rUn22/etB81boYhfYkkjVCOCIg7Xzxheaj4U3YVP
         XUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9BgLihdw1ZoyXxJf00Tp5DPDBIpdV66c7ObSF0tnLfs=;
        b=d6GDKGM2giBOMAjGhzCSd5ni4JQ8305EUmDu24Z6T13glsIgYcDrp/QV5Xy3ehA9X4
         k94LJ7tJ/mbC/ZBS50/H6DO+Z4COEC6zrEZ6mJ5j8GSH6EsGsf9Mn/E8xb7/dEaqVype
         yC1f/0zmuikjAqYWpYpg8+yDQT8YliaOk1nwxFT9sqTl0id/ZRUTg+XHQsBA1Xe0ADz9
         U3WeuZwBUdbjt9K7f4ReT11JSVbJ7AotrHekoiUzyUVPj/yHqA970LTFAad0iHBTVncQ
         kE39SpkhnmrDDXInNg311Eqrr6JBq0HEynq5kbEeeppfvjb1yU3Zc2PT2xrVfK9tBtB+
         EP3A==
X-Gm-Message-State: APjAAAU5AQp4mbiMy64xZWwtZv2zyGvYBN12BSQu2PVq2ww74UxOcR5h
        DEE+E3nRzM1Z77Qcnupas90=
X-Google-Smtp-Source: APXvYqzsQzfz8Sq+HWGNdatcN5154Rodhhpyu6UgfUFg8rd7NvsUxAviSh9bDWId77DslFKGRkC33Q==
X-Received: by 2002:a17:90a:1617:: with SMTP id n23mr8326148pja.75.1570569399944;
        Tue, 08 Oct 2019 14:16:39 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 193sm54319pfc.59.2019.10.08.14.16.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 14:16:39 -0700 (PDT)
Subject: [next-queue PATCH 1/2] e1000e: Use rtnl_lock to prevent race
 conditions between net and pci/pm
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     alexander.h.duyck@linux.intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Date:   Tue, 08 Oct 2019 14:16:38 -0700
Message-ID: <20191008211638.4575.93695.stgit@localhost.localdomain>
In-Reply-To: <20191008210639.4575.44144.stgit@localhost.localdomain>
References: <20191008210639.4575.44144.stgit@localhost.localdomain>
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

Reported-by: Morumuri Srivalli  <smorumu1@in.ibm.com>
Tested-by: David Dai <zdai@linux.vnet.ibm.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   40 +++++++++++++++-------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index d7d56e42a6aa..8b4e589aca36 100644
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
@@ -6626,27 +6632,31 @@ static int __e1000_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int e1000e_pm_thaw(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	int rc = 0;
 
 	e1000e_set_interrupt_capability(adapter);
-	if (netif_running(netdev)) {
-		u32 err = e1000_request_irq(adapter);
 
-		if (err)
-			return err;
+	rtnl_lock();
+	if (netif_running(netdev)) {
+		rc = e1000_request_irq(adapter);
+		if (rc)
+			goto err_irq;
 
 		e1000e_up(adapter);
 	}
 
 	netif_device_attach(netdev);
+err_irq:
+	rtnl_unlock();
 
-	return 0;
+	return rc;
 }
 
+#ifdef CONFIG_PM_SLEEP
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

