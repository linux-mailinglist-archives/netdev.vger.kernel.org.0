Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C28C47BA2F
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhLUGu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:50:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:29894 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234467AbhLUGu0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069426; x=1671605426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rlx2YgV6lqCbVkTLLDZQYHYzSrAWqBMYeqSlwN0LX4E=;
  b=LKkhYrwFdfA8DD/N8dVOUk30bhdRodmSi73VWcD5N3f5LDQTPG1iWWHw
   KH/kwUFgBMIK1VmTB1+Hw9glc6v123NYJaHhf4akdT/iOjULHjQDAjvTZ
   j579Sn0mrPOuAc0F+pIaQKpiKPQ6yConZvYdQP2x3IyrdVwYqkYLuTJPj
   VqJOl13z076dcR8mPj/lu/g6nzLeQoGXRew9E/R/At3gABLQ/IhhKHqfM
   XDejVJKp6kOpJQUwixCY5Z+Zq76J1GVkDTJ4SSakkQId8AF4FuBdMCwJ7
   isfX8Lqjv2WU/N/el0evj45I5Imuxm2EryVDyUzOHbO+9rcp33ORJsrgg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107485"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107485"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119041"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:25 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 08/17] dlb: add runtime power-management support
Date:   Tue, 21 Dec 2021 00:50:38 -0600
Message-Id: <20211221065047.290182-9-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implemented a power-management policy of putting the device in D0 when in
use (when there are any open device files or memory mappings, or there are
any virtual devices), and D3Hot otherwise.

Add resume/suspend callbacks; when the device resumes, reset the hardware
to a known good state.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_main.c   | 98 ++++++++++++++++++++++++++++++++++-
 drivers/misc/dlb/dlb_pf_ops.c |  8 +++
 2 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 343bf72dc9c7..4b263e849061 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/pm_runtime.h>
 #include <linux/uaccess.h>
 
 #include "dlb_main.h"
@@ -72,12 +73,32 @@ static int dlb_open(struct inode *i, struct file *f)
 	f->private_data = dlb;
 	dlb->f = f;
 
+	/*
+	 * Increment the device's usage count and immediately wake it
+	 * if it was suspended.
+	 */
+	pm_runtime_get_sync(&dlb->pdev->dev);
+
+	return 0;
+}
+
+static int dlb_close(struct inode *i, struct file *f)
+{
+	struct dlb *dlb = f->private_data;
+
+	/*
+	 * Decrement the device's usage count and suspend it when
+	 * the application stops using it.
+	 */
+	pm_runtime_put_sync_suspend(&dlb->pdev->dev);
+
 	return 0;
 }
 
 static const struct file_operations dlb_fops = {
 	.owner   = THIS_MODULE,
 	.open    = dlb_open,
+	.release = dlb_close,
 };
 
 int dlb_init_domain(struct dlb *dlb, u32 domain_id)
@@ -95,6 +116,12 @@ int dlb_init_domain(struct dlb *dlb, u32 domain_id)
 
 	dlb->sched_domains[domain_id] = domain;
 
+	/*
+	 * The matching put is in dlb_free_domain, executed when the domain's
+	 * refcnt reaches zero.
+	 */
+	pm_runtime_get_sync(&dlb->pdev->dev);
+
 	return 0;
 }
 
@@ -119,7 +146,21 @@ static int __dlb_free_domain(struct dlb_domain *domain)
 
 void dlb_free_domain(struct kref *kref)
 {
-	__dlb_free_domain(container_of(kref, struct dlb_domain, refcnt));
+	struct dlb_domain *domain;
+	struct dlb *dlb;
+
+	domain = container_of(kref, struct dlb_domain, refcnt);
+
+	dlb = domain->dlb;
+
+	__dlb_free_domain(domain);
+
+	/*
+	 * Decrement the device's usage count and suspend it when
+	 * the last application stops using it. The matching get is in
+	 * dlb_init_domain.
+	 */
+	pm_runtime_put_sync_suspend(&dlb->pdev->dev);
 }
 
 static int dlb_domain_close(struct inode *i, struct file *f)
@@ -230,6 +271,14 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	if (ret)
 		goto init_driver_state_fail;
 
+	/*
+	 * Undo the 'get' operation by the PCI layer during probe and
+	 * (if PF) immediately suspend the device. Since the device is only
+	 * enabled when an application requests it, an autosuspend delay is
+	 * likely not beneficial.
+	 */
+	pm_runtime_put_sync_suspend(&pdev->dev);
+
 	return 0;
 
 init_driver_state_fail:
@@ -254,6 +303,9 @@ static void dlb_remove(struct pci_dev *pdev)
 {
 	struct dlb *dlb = pci_get_drvdata(pdev);
 
+	/* Undo the PM operation in dlb_probe(). */
+	pm_runtime_get_noresume(&pdev->dev);
+
 	dlb_resource_free(&dlb->hw);
 
 	device_destroy(dlb_class, dlb->dev_number);
@@ -265,17 +317,61 @@ static void dlb_remove(struct pci_dev *pdev)
 	mutex_unlock(&dlb_ids_lock);
 }
 
+#ifdef CONFIG_PM
+static void dlb_reset_hardware_state(struct dlb *dlb)
+{
+	dlb_reset_device(dlb->pdev);
+}
+
+static int dlb_runtime_suspend(struct device *dev)
+{
+	/* Return and let the PCI subsystem put the device in D3hot. */
+
+	return 0;
+}
+
+static int dlb_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct dlb *dlb = pci_get_drvdata(pdev);
+	int ret;
+
+	/*
+	 * The PCI subsystem put the device in D0, but the device may not have
+	 * completed powering up. Wait until the device is ready before
+	 * proceeding.
+	 */
+	ret = dlb_pf_wait_for_device_ready(dlb, pdev);
+	if (ret)
+		return ret;
+
+	/* Now reinitialize the device state. */
+	dlb_reset_hardware_state(dlb);
+
+	return 0;
+}
+#endif
+
 static struct pci_device_id dlb_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, DLB_PF, DLB_PF) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, dlb_id_table);
 
+#ifdef CONFIG_PM
+static const struct dev_pm_ops dlb_pm_ops = {
+	SET_RUNTIME_PM_OPS(dlb_runtime_suspend, dlb_runtime_resume, NULL)
+};
+#endif
+
 static struct pci_driver dlb_pci_driver = {
 	.name		 = "dlb",
 	.id_table	 = dlb_id_table,
 	.probe		 = dlb_probe,
 	.remove		 = dlb_remove,
+#ifdef CONFIG_PM
+	.driver.pm	 = &dlb_pm_ops,
+#endif
 };
 
 static int __init dlb_init_module(void)
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index 8d179beb9d5b..65213c0475e5 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -2,6 +2,7 @@
 /* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
 
 #include <linux/delay.h>
+#include <linux/pm_runtime.h>
 
 #include "dlb_main.h"
 #include "dlb_regs.h"
@@ -43,6 +44,13 @@ int dlb_pf_init_driver_state(struct dlb *dlb)
 {
 	mutex_init(&dlb->resource_mutex);
 
+	/*
+	 * Allow PF runtime power-management (forbidden by default by the PCI
+	 * layer during scan). The driver puts the device into D3hot while
+	 * there are no scheduling domains to service.
+	 */
+	pm_runtime_allow(&dlb->pdev->dev);
+
 	return 0;
 }
 
-- 
2.27.0

