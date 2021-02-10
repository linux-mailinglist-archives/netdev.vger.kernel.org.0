Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3F3316D7B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhBJR6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:58:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:60442 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233273AbhBJR5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:57:34 -0500
IronPort-SDR: 8Nqk6+FDxBMKgHIL6D/qMWlXVoKuVhcFAMsfC2EqtzFmCSrZ9w2WcIuYZE1Ru1jr/maDEIbf0q
 KpyGjHOfTUSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236023"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236023"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:09 -0800
IronPort-SDR: xOyFuIOy7qSzCMFmiLdtzXgUPygpLSFkdoby+5PK9Zg0VkWpvBtraiA7wPFIX9Wzb9RuiO6u6/
 uqIVxEkeGSjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235749"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:08 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 08/20] dlb: add runtime power-management support
Date:   Wed, 10 Feb 2021 11:54:11 -0600
Message-Id: <20210210175423.1873-9-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implemented a power-management policy of putting the device in D0 when in
use (when there are any open device files or memory mappings, or there are
any virtual devices), and D3Hot otherwise.

Add resume/suspend callbacks; when the device resumes, reset the hardware
to a known good state.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/misc/dlb/dlb_main.c   | 101 +++++++++++++++++++++++++++++++++-
 drivers/misc/dlb/dlb_pf_ops.c |   8 +++
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 70030d779033..5484d9aee02c 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/pm_runtime.h>
 #include <linux/uaccess.h>
 
 #include "dlb_main.h"
@@ -73,12 +74,35 @@ static int dlb_open(struct inode *i, struct file *f)
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
+	mutex_lock(&dlb->resource_mutex);
+	/*
+	 * Decrement the device's usage count and suspend it when
+	 * the application stops using it.
+	 */
+	pm_runtime_put_sync_suspend(&dlb->pdev->dev);
+
+	mutex_unlock(&dlb->resource_mutex);
+
 	return 0;
 }
 
 static const struct file_operations dlb_fops = {
 	.owner   = THIS_MODULE,
 	.open    = dlb_open,
+	.release = dlb_close,
 	.unlocked_ioctl = dlb_ioctl,
 };
 
@@ -97,6 +121,12 @@ int dlb_init_domain(struct dlb *dlb, u32 domain_id)
 
 	dlb->sched_domains[domain_id] = domain;
 
+	/*
+	 * The matching put is in dlb_free_domain, executed when the domain's
+	 * refcnt reaches zero.
+	 */
+	pm_runtime_get_sync(&dlb->pdev->dev);
+
 	return 0;
 }
 
@@ -121,7 +151,21 @@ static int __dlb_free_domain(struct dlb_domain *domain)
 
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
@@ -230,6 +274,14 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
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
@@ -253,6 +305,9 @@ static void dlb_remove(struct pci_dev *pdev)
 {
 	struct dlb *dlb = pci_get_drvdata(pdev);
 
+	/* Undo the PM operation in dlb_probe(). */
+	pm_runtime_get_noresume(&pdev->dev);
+
 	dlb_resource_free(&dlb->hw);
 
 	device_destroy(dlb_class, dlb->dev_number);
@@ -264,17 +319,61 @@ static void dlb_remove(struct pci_dev *pdev)
 	spin_unlock(&dlb_ids_lock);
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
+	ret = dlb->ops->wait_for_device_ready(dlb, pdev);
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
index 5dea0037d14b..494a482368f6 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -2,6 +2,7 @@
 /* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
 
 #include <linux/delay.h>
+#include <linux/pm_runtime.h>
 
 #include "dlb_main.h"
 #include "dlb_regs.h"
@@ -50,6 +51,13 @@ static int dlb_pf_init_driver_state(struct dlb *dlb)
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
2.17.1

