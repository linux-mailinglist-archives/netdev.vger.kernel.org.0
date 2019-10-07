Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEBACEA97
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfJGR17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:27:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39252 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfJGR17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 13:27:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id v4so9077753pff.6;
        Mon, 07 Oct 2019 10:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rewVBm4IqqEvTaYiuvZUBNZZiDgXMthoGgqbVwwE7fI=;
        b=RVrYNxECPmgNvxSfK06La7b07vRhlukaBBdvvvYhmTRZo+aO+qTFH2ZblgGiJxB9/5
         OvP5MHzQJKg0rzKqupUtvizgdPVhCKRAfrl49yPNVOVlXxRj4npFks9mYqju8oOCAGQA
         dGvcGzd+f++le3NzgBXVDh49kuno995vYdpX8WI3wyUL4iMiYtAfbzX3WrQnWf8RTa93
         oupjUTkdAb3z8UShfYW7aIlM2F3OFyXoVUq5uLaols5fO7kLCvhUr4DbN49+FIN01Lyu
         hBW1an4CIKtF0lcrO6Yfz34VNGvjnv0RBxADmA2g5Paue/HhIaFbgH57xCO8M/TXH8An
         BGcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rewVBm4IqqEvTaYiuvZUBNZZiDgXMthoGgqbVwwE7fI=;
        b=fCeL3WXvlkqGbjmy8aJUJMNyqOmxp6QhHLzwsLtOgx6+yZf5/7P383KB0YET+AUU4A
         SCYFsrZ3EKVNT730U7bhLem7RpiBjQ7jl1JrSc5c0L0LEFbmx7I0rQubjHwniHVf3O8A
         2ehDnTnlcikzJfK4GKh7z3a65wPlMtZsQpveD2ztc9pSkavs1q32oRYolm5VJOYaCRR9
         mZwZOg04JK/V9qEgKSihFutXRxUP+rXjDpD/AiAP0/FdEntOawPe+6Rmn5dD3hI0RE15
         MM7FT4BOST0vjGLR9i684DBRP0BJx1IjW+av5I9iV5VcR940WzOFiRUuii94Rbygj1C2
         nj0g==
X-Gm-Message-State: APjAAAUBJvZY8iyIVCO/OB6V+XQXDOACnCOuLdVboJa9Ed85gFFfhxhB
        cgx5YqE9fM0+Ejv1Fh21sOA=
X-Google-Smtp-Source: APXvYqyBCbO+Qi4CHuA8UQrMr7Jemry4iV0QSvxPw701kJ52QWmD9TrnfhS56eXUMVEYY/OzlknSgg==
X-Received: by 2002:a17:90a:1aa9:: with SMTP id p38mr447244pjp.142.1570469276472;
        Mon, 07 Oct 2019 10:27:56 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id k95sm115110pje.10.2019.10.07.10.27.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 10:27:55 -0700 (PDT)
Subject: [RFC PATCH v2] e1000e: Use rtnl_lock to prevent race conditions
 between net and pci/pm
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     alexander.duyck@gmail.com
Cc:     zdai@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jeffrey.t.kirsher@intel.com, zdai@us.ibm.com, davem@davemloft.net
Date:   Mon, 07 Oct 2019 10:27:55 -0700
Message-ID: <20191007172559.11166.29328.stgit@localhost.localdomain>
In-Reply-To: <CAKgT0UdwqGGKvaSJ+3vd-_d-6t9MB=No+7SpkbOT2PnynRK+2w@mail.gmail.com>
References: <CAKgT0UdwqGGKvaSJ+3vd-_d-6t9MB=No+7SpkbOT2PnynRK+2w@mail.gmail.com>
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

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---

RFC v2: Dropped some unused variables
	Added logic to check for device present before removing to pm_freeze
	Fixed misplaced err_irq to before rtnl_unlock()

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

