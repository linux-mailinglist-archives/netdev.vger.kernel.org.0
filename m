Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6907614B0B2
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 09:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgA1IKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 03:10:05 -0500
Received: from inva020.nxp.com ([92.121.34.13]:38064 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgA1IKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 03:10:05 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 00CB01A0EE6;
        Tue, 28 Jan 2020 09:10:01 +0100 (CET)
Received: from inv0113.in-blr01.nxp.com (inv0113.in-blr01.nxp.com [165.114.116.118])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 731061A0A8E;
        Tue, 28 Jan 2020 09:10:00 +0100 (CET)
Received: from lsv0210.swis.in-blr01.nxp.com (lsv0210.swis.in-blr01.nxp.com [92.120.145.207])
        by inv0113.in-blr01.nxp.com (Postfix) with ESMTP id D4379327;
        Tue, 28 Jan 2020 13:39:59 +0530 (IST)
From:   Makarand Pawagi <makarand.pawagi@nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux@armlinux.org.uk
Cc:     jon@solid-run.com, cristian.sovaiala@nxp.com,
        laurentiu.tudor@nxp.com, ioana.ciornei@nxp.com, V.Sethi@nxp.com,
        calvin.johnson@nxp.com, pankaj.bansal@nxp.com,
        lorenzo.pieralisi@arm.com, guohanjun@huawei.com,
        sudeep.holla@arm.com, rjw@rjwysocki.net, lenb@kernel.org,
        stuyoder@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        maz@kernel.org, shameerali.kolothum.thodi@huawei.com,
        will@kernel.org, robin.murphy@arm.com, nleeder@codeaurora.org,
        Makarand Pawagi <makarand.pawagi@nxp.com>
Subject: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Date:   Tue, 28 Jan 2020 13:38:45 +0530
Message-Id: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ACPI support is added in the fsl-mc driver. Driver will parse
MC DSDT table to extract memory and other resorces.

Interrupt (GIC ITS) information will be extracted from MADT table
by drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c.

IORT table will be parsed to configure DMA.

Signed-off-by: Makarand Pawagi <makarand.pawagi@nxp.com>
---
 drivers/acpi/arm64/iort.c                   | 53 +++++++++++++++++++++
 drivers/bus/fsl-mc/dprc-driver.c            |  3 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c             | 48 +++++++++++++------
 drivers/bus/fsl-mc/fsl-mc-msi.c             | 10 +++-
 drivers/bus/fsl-mc/fsl-mc-private.h         |  4 +-
 drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c | 71 ++++++++++++++++++++++++++++-
 include/linux/acpi_iort.h                   |  5 ++
 7 files changed, 174 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 33f7198..beb9cd5 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/pci.h>
+#include <linux/fsl/mc.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
@@ -622,6 +623,29 @@ static int iort_dev_find_its_id(struct device *dev, u32 req_id,
 }
 
 /**
+ * iort_get_fsl_mc_device_domain() - Find MSI domain related to a device
+ * @dev: The device.
+ * @mc_icid: ICID for the fsl_mc device.
+ *
+ * Returns: the MSI domain for this device, NULL otherwise
+ */
+struct irq_domain *iort_get_fsl_mc_device_domain(struct device *dev,
+							u32 mc_icid)
+{
+	struct fwnode_handle *handle;
+	int its_id;
+
+	if (iort_dev_find_its_id(dev, mc_icid, 0, &its_id))
+		return NULL;
+
+	handle = iort_find_domain_token(its_id);
+	if (!handle)
+		return NULL;
+
+	return irq_find_matching_fwnode(handle, DOMAIN_BUS_FSL_MC_MSI);
+}
+
+/**
  * iort_get_device_domain() - Find MSI domain related to a device
  * @dev: The device.
  * @req_id: Requester ID for the device.
@@ -924,6 +948,21 @@ static int iort_pci_iommu_init(struct pci_dev *pdev, u16 alias, void *data)
 	return iort_iommu_xlate(info->dev, parent, streamid);
 }
 
+static int iort_fsl_mc_iommu_init(struct device *dev,
+				struct acpi_iort_node *node, u32 *streamid)
+{
+	struct acpi_iort_node *parent;
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+
+	parent = iort_node_map_id(node, mc_dev->icid, streamid,
+						IORT_IOMMU_TYPE);
+
+	if (parent)
+		return iort_iommu_xlate(dev, parent, *streamid);
+
+	return 0;
+}
+
 /**
  * iort_iommu_configure - Set-up IOMMU configuration for a device.
  *
@@ -962,6 +1001,20 @@ const struct iommu_ops *iort_iommu_configure(struct device *dev)
 
 		if (!err && iort_pci_rc_supports_ats(node))
 			dev->iommu_fwspec->flags |= IOMMU_FWSPEC_PCI_RC_ATS;
+	} else if (dev_is_fsl_mc(dev)) {
+		struct device *dma_dev = dev;
+
+		if (!(to_acpi_device_node(dma_dev->fwnode))) {
+			while (dev_is_fsl_mc(dma_dev))
+				dma_dev = dma_dev->parent;
+		}
+
+		node = iort_scan_node(ACPI_IORT_NODE_NAMED_COMPONENT,
+					iort_match_node_callback, dma_dev);
+		if (!node)
+			return NULL;
+
+		err = iort_fsl_mc_iommu_init(dev, node, &streamid);
 	} else {
 		int i = 0;
 
diff --git a/drivers/bus/fsl-mc/dprc-driver.c b/drivers/bus/fsl-mc/dprc-driver.c
index c8b1c38..31dd790 100644
--- a/drivers/bus/fsl-mc/dprc-driver.c
+++ b/drivers/bus/fsl-mc/dprc-driver.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2014-2016 Freescale Semiconductor, Inc.
  * Author: German Rivera <German.Rivera@freescale.com>
+ * Copyright 2018-2020 NXP
  *
  */
 
@@ -638,7 +639,7 @@ static int dprc_probe(struct fsl_mc_device *mc_dev)
 			return -EINVAL;
 
 		error = fsl_mc_find_msi_domain(parent_dev,
-					       &mc_msi_domain);
+					&mc_msi_domain, mc_dev);
 		if (error < 0) {
 			dev_warn(&mc_dev->dev,
 				 "WARNING: MC bus without interrupt support\n");
diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index a07cc19..5d388e4 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -4,11 +4,13 @@
  *
  * Copyright (C) 2014-2016 Freescale Semiconductor, Inc.
  * Author: German Rivera <German.Rivera@freescale.com>
+ * Copyright 2018-2020 NXP
  *
  */
 
 #define pr_fmt(fmt) "fsl-mc: " fmt
 
+#include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
@@ -129,12 +131,25 @@ static int fsl_mc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static int fsl_mc_dma_configure(struct device *dev)
 {
+	enum dev_dma_attr attr;
 	struct device *dma_dev = dev;
+	int err = -ENODEV;
 
 	while (dev_is_fsl_mc(dma_dev))
 		dma_dev = dma_dev->parent;
 
-	return of_dma_configure(dev, dma_dev->of_node, 0);
+	if (dma_dev->of_node)
+		err = of_dma_configure(dev, dma_dev->of_node, 1);
+	else {
+		if (has_acpi_companion(dma_dev)) {
+			attr = acpi_get_dma_attr(to_acpi_device_node
+							(dma_dev->fwnode));
+			if (attr != DEV_DMA_NOT_SUPPORTED)
+				err = acpi_dma_configure(dev, attr);
+		}
+	}
+
+	return err;
 }
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
@@ -863,7 +878,7 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 	phys_addr_t mc_portal_phys_addr;
 	u32 mc_portal_size;
 	struct mc_version mc_version;
-	struct resource res;
+	struct resource *plat_res;
 
 	mc = devm_kzalloc(&pdev->dev, sizeof(*mc), GFP_KERNEL);
 	if (!mc)
@@ -874,16 +889,9 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 	/*
 	 * Get physical address of MC portal for the root DPRC:
 	 */
-	error = of_address_to_resource(pdev->dev.of_node, 0, &res);
-	if (error < 0) {
-		dev_err(&pdev->dev,
-			"of_address_to_resource() failed for %pOF\n",
-			pdev->dev.of_node);
-		return error;
-	}
-
-	mc_portal_phys_addr = res.start;
-	mc_portal_size = resource_size(&res);
+	plat_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mc_portal_phys_addr = plat_res->start;
+	mc_portal_size = resource_size(plat_res);
 	error = fsl_create_mc_io(&pdev->dev, mc_portal_phys_addr,
 				 mc_portal_size, NULL,
 				 FSL_MC_IO_ATOMIC_CONTEXT_PORTAL, &mc_io);
@@ -900,11 +908,13 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "MC firmware version: %u.%u.%u\n",
 		 mc_version.major, mc_version.minor, mc_version.revision);
 
-	error = get_mc_addr_translation_ranges(&pdev->dev,
+	if (dev_of_node(&pdev->dev)) {
+		error = get_mc_addr_translation_ranges(&pdev->dev,
 					       &mc->translation_ranges,
 					       &mc->num_translation_ranges);
-	if (error < 0)
-		goto error_cleanup_mc_io;
+		if (error < 0)
+			goto error_cleanup_mc_io;
+	}
 
 	error = dprc_get_container_id(mc_io, 0, &container_id);
 	if (error < 0) {
@@ -931,6 +941,7 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 		goto error_cleanup_mc_io;
 
 	mc->root_mc_bus_dev = mc_bus_dev;
+	mc_bus_dev->dev.fwnode = pdev->dev.fwnode;
 	return 0;
 
 error_cleanup_mc_io:
@@ -964,11 +975,18 @@ static const struct of_device_id fsl_mc_bus_match_table[] = {
 
 MODULE_DEVICE_TABLE(of, fsl_mc_bus_match_table);
 
+static const struct acpi_device_id fsl_mc_bus_acpi_match_table[] = {
+	{"NXP0008", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, fsl_mc_bus_acpi_match_table);
+
 static struct platform_driver fsl_mc_bus_driver = {
 	.driver = {
 		   .name = "fsl_mc_bus",
 		   .pm = NULL,
 		   .of_match_table = fsl_mc_bus_match_table,
+		   .acpi_match_table = fsl_mc_bus_acpi_match_table,
 		   },
 	.probe = fsl_mc_bus_probe,
 	.remove = fsl_mc_bus_remove,
diff --git a/drivers/bus/fsl-mc/fsl-mc-msi.c b/drivers/bus/fsl-mc/fsl-mc-msi.c
index 8b9c66d..bd10952 100644
--- a/drivers/bus/fsl-mc/fsl-mc-msi.c
+++ b/drivers/bus/fsl-mc/fsl-mc-msi.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2015-2016 Freescale Semiconductor, Inc.
  * Author: German Rivera <German.Rivera@freescale.com>
+ * Copyright 2020 NXP
  *
  */
 
@@ -13,6 +14,7 @@
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
+#include <linux/acpi_iort.h>
 
 #include "fsl-mc-private.h"
 
@@ -178,13 +180,19 @@ struct irq_domain *fsl_mc_msi_create_irq_domain(struct fwnode_handle *fwnode,
 }
 
 int fsl_mc_find_msi_domain(struct device *mc_platform_dev,
-			   struct irq_domain **mc_msi_domain)
+			   struct irq_domain **mc_msi_domain,
+				struct fsl_mc_device *mc_dev)
 {
 	struct irq_domain *msi_domain;
 	struct device_node *mc_of_node = mc_platform_dev->of_node;
 
 	msi_domain = of_msi_get_domain(mc_platform_dev, mc_of_node,
 				       DOMAIN_BUS_FSL_MC_MSI);
+
+	if (!msi_domain)
+		msi_domain = iort_get_fsl_mc_device_domain(mc_platform_dev,
+								mc_dev->icid);
+
 	if (!msi_domain) {
 		pr_err("Unable to find fsl-mc MSI domain for %pOF\n",
 		       mc_of_node);
diff --git a/drivers/bus/fsl-mc/fsl-mc-private.h b/drivers/bus/fsl-mc/fsl-mc-private.h
index 21ca8c756..e8f4c0f 100644
--- a/drivers/bus/fsl-mc/fsl-mc-private.h
+++ b/drivers/bus/fsl-mc/fsl-mc-private.h
@@ -3,6 +3,7 @@
  * Freescale Management Complex (MC) bus private declarations
  *
  * Copyright (C) 2016 Freescale Semiconductor, Inc.
+ * Copyright 2020 NXP
  *
  */
 #ifndef _FSL_MC_PRIVATE_H_
@@ -596,7 +597,8 @@ int fsl_mc_msi_domain_alloc_irqs(struct device *dev,
 void fsl_mc_msi_domain_free_irqs(struct device *dev);
 
 int fsl_mc_find_msi_domain(struct device *mc_platform_dev,
-			   struct irq_domain **mc_msi_domain);
+			   struct irq_domain **mc_msi_domain,
+				struct fsl_mc_device *mc_dev);
 
 int fsl_mc_populate_irq_pool(struct fsl_mc_bus *mc_bus,
 			     unsigned int irq_count);
diff --git a/drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c b/drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c
index 606efa6..df99170 100644
--- a/drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c
+++ b/drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c
@@ -4,9 +4,11 @@
  *
  * Copyright (C) 2015-2016 Freescale Semiconductor, Inc.
  * Author: German Rivera <German.Rivera@freescale.com>
+ * Copyright 2020 NXP
  *
  */
 
+#include <linux/acpi_iort.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
 #include <linux/irq.h>
@@ -66,7 +68,66 @@ static const struct of_device_id its_device_id[] = {
 	{},
 };
 
-static int __init its_fsl_mc_msi_init(void)
+static int __init its_fsl_mc_msi_init_one(struct fwnode_handle *handle,
+					const char *name)
+{
+	struct irq_domain *parent;
+	struct irq_domain *mc_msi_domain;
+
+	parent = irq_find_matching_fwnode(handle, DOMAIN_BUS_NEXUS);
+	if (!parent || !msi_get_domain_info(parent)) {
+		pr_err("%s: Unable to locate ITS domain\n", name);
+		return -ENXIO;
+	}
+
+	mc_msi_domain = fsl_mc_msi_create_irq_domain(
+					 handle,
+					 &its_fsl_mc_msi_domain_info,
+					 parent);
+	if (!mc_msi_domain)
+		pr_err("ACPIF: unable to create fsl-mc domain\n");
+
+	pr_info("fsl-mc MSI: domain created\n");
+
+	return 0;
+}
+
+static int __init
+its_fsl_mc_msi_parse_madt(union acpi_subtable_headers *header,
+			const unsigned long end)
+{
+	struct acpi_madt_generic_translator *its_entry;
+	struct fwnode_handle *dom_handle;
+	const char *node_name;
+	int err = -ENXIO;
+
+	its_entry = (struct acpi_madt_generic_translator *)header;
+	node_name = kasprintf(GFP_KERNEL, "ITS@0x%lx",
+				(long)its_entry->base_address);
+
+	dom_handle = iort_find_domain_token(its_entry->translation_id);
+	if (!dom_handle) {
+		pr_err("%s: Unable to locate ITS domain handle\n", node_name);
+		goto out;
+	}
+
+	err = its_fsl_mc_msi_init_one(dom_handle, node_name);
+	if (!err)
+		pr_info("fsl-mc MSI: %s domain created\n", node_name);
+
+out:
+	kfree(node_name);
+	return err;
+}
+
+static int __init its_fsl_mc_acpi_msi_init(void)
+{
+	acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_TRANSLATOR,
+				its_fsl_mc_msi_parse_madt, 0);
+	return 0;
+}
+
+static int __init its_fsl_mc_of_msi_init(void)
 {
 	struct device_node *np;
 	struct irq_domain *parent;
@@ -96,8 +157,14 @@ static int __init its_fsl_mc_msi_init(void)
 
 		pr_info("fsl-mc MSI: %pOF domain created\n", np);
 	}
-
 	return 0;
 }
 
+static int __init its_fsl_mc_msi_init(void)
+{
+	its_fsl_mc_of_msi_init();
+	its_fsl_mc_acpi_msi_init();
+
+	return 0;
+}
 early_initcall(its_fsl_mc_msi_init);
diff --git a/include/linux/acpi_iort.h b/include/linux/acpi_iort.h
index 8e7e2ec..0afc608 100644
--- a/include/linux/acpi_iort.h
+++ b/include/linux/acpi_iort.h
@@ -30,6 +30,8 @@ struct fwnode_handle *iort_find_domain_token(int trans_id);
 void acpi_iort_init(void);
 u32 iort_msi_map_rid(struct device *dev, u32 req_id);
 struct irq_domain *iort_get_device_domain(struct device *dev, u32 req_id);
+struct irq_domain *iort_get_fsl_mc_device_domain(struct device *dev,
+								u32 req_id);
 void acpi_configure_pmsi_domain(struct device *dev);
 int iort_pmsi_get_dev_id(struct device *dev, u32 *dev_id);
 /* IOMMU interface */
@@ -40,6 +42,9 @@ int iort_iommu_msi_get_resv_regions(struct device *dev, struct list_head *head);
 static inline void acpi_iort_init(void) { }
 static inline u32 iort_msi_map_rid(struct device *dev, u32 req_id)
 { return req_id; }
+static inline struct irq_domain *iort_get_fsl_mc_device_domain
+					(struct device *dev, u32 req_id)
+{ return NULL; }
 static inline struct irq_domain *iort_get_device_domain(struct device *dev,
 							u32 req_id)
 { return NULL; }
-- 
2.7.4

