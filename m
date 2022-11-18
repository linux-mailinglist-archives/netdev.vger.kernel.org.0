Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A746302AA
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbiKRXNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiKRXMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:12:51 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FFDC5B7A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:36 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v17so5825183plo.1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QZlLw0+EHV2ra4CorGQFzhSPOechGgDT1UrFdhEmXSE=;
        b=m68OWmGH/AyQyx+toSB5yGe0UYA6L1FWI2kbxrD1S1kJ/9AJuUwpMfXvGxxxb3kKFX
         Y7Znoapxxn8B8YiRioUz2v3KngZRhc99ocpsdBsEUY4QXmnLMDFVIQO4oBwB/Mw7B+kg
         k03CqEr+LkDfWRNxHCvezssEIbTumSYvKTEtvmR/DzMujqq8uk/g5d9NE8mjp4TBv8yy
         WYDriwFUMCOcqEAPyBlgOSmV2tDCI1y3r3XG0EyheqZU4I507hh+9/m+QLyx6m2tHRNW
         o0cgFDq0IN4iQJxGNYIu2+rIFao+aPn2L6JfU8q29KVAAQmmQHEw92CJQAFIBjFWUjlP
         WM4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZlLw0+EHV2ra4CorGQFzhSPOechGgDT1UrFdhEmXSE=;
        b=qHRVDu5aFi0YDIAM4B0YQpfKQ0Osu7Cg35dKJEZkr9btbsTagFPcUCMrOT1GpsmIIT
         H/wu+hqg3hLimbV+dQug9O/28e9+YG20UcZG70co0AlKmmY0I/HeS8Df5PZLwhMC0AFt
         Cs4DYcsRdWrayI5XqaOfHEdeD2fvV7fuwA5IEnDASku+1KWIHXTz4/GnyHKgAfa2RbVO
         tsCV8McmMd4V4qDgIXfS8OOBtYO4WF7dqQbeE6H2CpnWY7Ccw28nY4HYZmgg9KGL+2pB
         k07ExfrNz2rh9RMklTNlli3Nsq3wBl/9R4lE2Vvrb+m4CPDpAhPr0jUQO4nptGCUCr2S
         whpg==
X-Gm-Message-State: ANoB5plt076zOS69JmSO8yVO8uCGbSKFDZOXgZyrZ6oDoRXITbW3HuMS
        B5Nf7fMuqmgRFDrbPZ7eMWTjoLMX+jHxnQ==
X-Google-Smtp-Source: AA0mqf5OumyaBxkWDZZdwUaFWY/U1/qFn+jzo3BS88De9chvL3RCLe+PWvqhHQhnJ6tFoIM00XeDrw==
X-Received: by 2002:a17:902:9a03:b0:186:9f20:e7e2 with SMTP id v3-20020a1709029a0300b001869f20e7e2mr1343686plp.174.1668812233378;
        Fri, 18 Nov 2022 14:57:13 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:12 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 01/19] pds_core: initial framework for pds_core driver
Date:   Fri, 18 Nov 2022 14:56:38 -0800
Message-Id: <20221118225656.48309-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the initial PCI driver framework for the new pds_core device
driver and its family of client drivers.  This does the very basics of
registering for the new PCI device 1dd8:100c, setting up debugfs entries,
and registering with devlink.

The new PCI device id has not made it to the official PCI ID Repository
yet, but will soon be registered there.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/pds_core/Makefile   |   9 +
 drivers/net/ethernet/pensando/pds_core/core.h |  68 ++
 .../net/ethernet/pensando/pds_core/debugfs.c  |  47 ++
 .../net/ethernet/pensando/pds_core/devlink.c  |  55 ++
 drivers/net/ethernet/pensando/pds_core/main.c | 263 ++++++++
 include/linux/pds/pds_common.h                |  13 +
 include/linux/pds/pds_core_if.h               | 581 ++++++++++++++++++
 7 files changed, 1036 insertions(+)
 create mode 100644 drivers/net/ethernet/pensando/pds_core/Makefile
 create mode 100644 drivers/net/ethernet/pensando/pds_core/core.h
 create mode 100644 drivers/net/ethernet/pensando/pds_core/debugfs.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/devlink.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/main.c
 create mode 100644 include/linux/pds/pds_common.h
 create mode 100644 include/linux/pds/pds_core_if.h

diff --git a/drivers/net/ethernet/pensando/pds_core/Makefile b/drivers/net/ethernet/pensando/pds_core/Makefile
new file mode 100644
index 000000000000..72bbc5fa68ad
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2022 Pensando Systems, Inc
+
+obj-$(CONFIG_PDS_CORE) := pds_core.o
+
+pds_core-y := main.o \
+	      devlink.o
+
+pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
new file mode 100644
index 000000000000..022adc4aea01
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _PDSC_H_
+#define _PDSC_H_
+
+#include <linux/debugfs.h>
+#include <net/devlink.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+
+#define PDSC_DRV_DESCRIPTION	"Pensando Core PF Driver"
+
+struct pdsc_dev_bar {
+	void __iomem *vaddr;
+	phys_addr_t bus_addr;
+	unsigned long len;
+	int res_index;
+};
+
+/* No state flags set means we are in a steady running state */
+enum pdsc_state_flags {
+	PDSC_S_FW_DEAD,		    /* fw stopped, waiting for startup or recovery */
+	PDSC_S_INITING_DRIVER,	    /* initial startup from probe */
+	PDSC_S_STOPPING_DRIVER,	    /* driver remove */
+
+	/* leave this as last */
+	PDSC_S_STATE_SIZE
+};
+
+struct pdsc {
+	struct pci_dev *pdev;
+	struct dentry *dentry;
+	struct device *dev;
+	struct pdsc_dev_bar bars[PDS_CORE_BARS_MAX];
+	int hw_index;
+	int id;
+
+	unsigned long state;
+
+	struct pds_core_dev_info_regs __iomem *info_regs;
+	struct pds_core_dev_cmd_regs __iomem *cmd_regs;
+	struct pds_core_intr __iomem *intr_ctrl;
+	u64 __iomem *intr_status;
+	u64 __iomem *db_pages;
+	dma_addr_t phy_db_pages;
+	u64 __iomem *kern_dbpage;
+};
+
+struct pdsc *pdsc_dl_alloc(struct device *dev);
+void pdsc_dl_free(struct pdsc *pdsc);
+int pdsc_dl_register(struct pdsc *pdsc);
+void pdsc_dl_unregister(struct pdsc *pdsc);
+
+#ifdef CONFIG_DEBUG_FS
+void pdsc_debugfs_create(void);
+void pdsc_debugfs_destroy(void);
+void pdsc_debugfs_add_dev(struct pdsc *pdsc);
+void pdsc_debugfs_del_dev(struct pdsc *pdsc);
+#else
+static inline void pdsc_debugfs_create(void) { }
+static inline void pdsc_debugfs_destroy(void) { }
+static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
+#endif
+
+#endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/pensando/pds_core/debugfs.c b/drivers/net/ethernet/pensando/pds_core/debugfs.c
new file mode 100644
index 000000000000..3f876dcc5431
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/debugfs.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+
+#include "core.h"
+
+static struct dentry *pdsc_dir;
+
+void pdsc_debugfs_create(void)
+{
+	pdsc_dir = debugfs_create_dir(PDS_CORE_DRV_NAME, NULL);
+}
+
+void pdsc_debugfs_destroy(void)
+{
+	debugfs_remove_recursive(pdsc_dir);
+}
+
+static int core_state_show(struct seq_file *seq, void *v)
+{
+	struct pdsc *pdsc = seq->private;
+
+	seq_printf(seq, "%#lx\n", pdsc->state);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(core_state);
+
+void pdsc_debugfs_add_dev(struct pdsc *pdsc)
+{
+	pdsc->dentry = debugfs_create_dir(pci_name(pdsc->pdev), pdsc_dir);
+
+	debugfs_create_file("state", 0400, pdsc->dentry,
+			    pdsc, &core_state_fops);
+}
+
+void pdsc_debugfs_del_dev(struct pdsc *pdsc)
+{
+	debugfs_remove_recursive(pdsc->dentry);
+	pdsc->dentry = NULL;
+}
+#endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/net/ethernet/pensando/pds_core/devlink.c b/drivers/net/ethernet/pensando/pds_core/devlink.c
new file mode 100644
index 000000000000..3538aa9cf9e3
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/devlink.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+
+#include "core.h"
+
+static int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+			    struct netlink_ext_ack *extack)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+
+	return devlink_info_driver_name_put(req, pdsc->pdev->driver->name);
+}
+
+static const struct devlink_ops pdsc_dl_ops = {
+	.info_get	= pdsc_dl_info_get,
+};
+
+struct pdsc *pdsc_dl_alloc(struct device *dev)
+{
+	struct devlink *dl;
+
+	dl = devlink_alloc(&pdsc_dl_ops, sizeof(struct pdsc), dev);
+	if (!dl)
+		return NULL;
+
+	return devlink_priv(dl);
+}
+
+void pdsc_dl_free(struct pdsc *pdsc)
+{
+	struct devlink *dl = priv_to_devlink(pdsc);
+
+	devlink_free(dl);
+}
+
+int pdsc_dl_register(struct pdsc *pdsc)
+{
+	struct devlink *dl = priv_to_devlink(pdsc);
+
+	devlink_register(dl);
+
+	return 0;
+}
+
+void pdsc_dl_unregister(struct pdsc *pdsc)
+{
+	struct devlink *dl = priv_to_devlink(pdsc);
+
+	devlink_unregister(dl);
+}
diff --git a/drivers/net/ethernet/pensando/pds_core/main.c b/drivers/net/ethernet/pensando/pds_core/main.c
new file mode 100644
index 000000000000..4bdbcc1c17a7
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/main.c
@@ -0,0 +1,263 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+/* main PCI driver and mgmt logic */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/aer.h>
+
+#include "core.h"
+
+MODULE_DESCRIPTION(PDSC_DRV_DESCRIPTION);
+MODULE_AUTHOR("Pensando Systems, Inc");
+MODULE_LICENSE("GPL");
+
+/* Supported devices */
+static const struct pci_device_id pdsc_id_table[] = {
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_CORE_PF) },
+	{ 0, }	/* end of table */
+};
+MODULE_DEVICE_TABLE(pci, pdsc_id_table);
+
+static void pdsc_unmap_bars(struct pdsc *pdsc)
+{
+	struct pdsc_dev_bar *bars = pdsc->bars;
+	unsigned int i;
+
+	for (i = 0; i < PDS_CORE_BARS_MAX; i++) {
+		if (bars[i].vaddr) {
+			pcim_iounmap(pdsc->pdev, bars[i].vaddr);
+			bars[i].vaddr = NULL;
+		}
+
+		bars[i].len = 0;
+		bars[i].bus_addr = 0;
+		bars[i].res_index = 0;
+	}
+}
+
+static int pdsc_map_bars(struct pdsc *pdsc)
+{
+	struct pdsc_dev_bar *bar = pdsc->bars;
+	struct pci_dev *pdev = pdsc->pdev;
+	struct device *dev = pdsc->dev;
+	struct pdsc_dev_bar *bars;
+	unsigned int i, j;
+	int num_bars = 0;
+	int err;
+	u32 sig;
+
+	bars = pdsc->bars;
+	num_bars = 0;
+
+	/* Since the PCI interface in the hardware is configurable,
+	 * we need to poke into all the bars to find the set we're
+	 * expecting.  The will be in the right order.
+	 */
+	for (i = 0, j = 0; i < PDS_CORE_BARS_MAX; i++) {
+		if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
+			continue;
+
+		bars[j].len = pci_resource_len(pdev, i);
+		bars[j].bus_addr = pci_resource_start(pdev, i);
+		bars[j].res_index = i;
+
+		/* only map the whole bar 0 */
+		if (j > 0) {
+			bars[j].vaddr = NULL;
+		} else {
+			bars[j].vaddr = pcim_iomap(pdev, i, bars[j].len);
+			if (!bars[j].vaddr) {
+				dev_err(dev,
+					"Cannot memory-map BAR %d, aborting\n",
+					i);
+				return -ENODEV;
+			}
+		}
+
+		j++;
+	}
+	num_bars = j;
+
+	/* BAR0: dev_cmd and interrupts */
+	if (num_bars < 1) {
+		dev_err(dev, "No bars found\n");
+		err = -EFAULT;
+		goto err_out;
+	}
+
+	if (bar->len < PDS_CORE_BAR0_SIZE) {
+		dev_err(dev, "Resource bar size %lu too small\n",
+			bar->len);
+		err = -EFAULT;
+		goto err_out;
+	}
+
+	pdsc->info_regs = bar->vaddr + PDS_CORE_BAR0_DEV_INFO_REGS_OFFSET;
+	pdsc->cmd_regs = bar->vaddr + PDS_CORE_BAR0_DEV_CMD_REGS_OFFSET;
+	pdsc->intr_status = bar->vaddr + PDS_CORE_BAR0_INTR_STATUS_OFFSET;
+	pdsc->intr_ctrl = bar->vaddr + PDS_CORE_BAR0_INTR_CTRL_OFFSET;
+
+	sig = ioread32(&pdsc->info_regs->signature);
+	if (sig != PDS_CORE_DEV_INFO_SIGNATURE) {
+		dev_err(dev, "Incompatible firmware signature %x", sig);
+		err = -EFAULT;
+		goto err_out;
+	}
+
+	/* BAR1: doorbells */
+	bar++;
+	if (num_bars < 2) {
+		dev_err(dev, "Doorbell bar missing\n");
+		err = -EFAULT;
+		goto err_out;
+	}
+
+	pdsc->db_pages = bar->vaddr;
+	pdsc->phy_db_pages = bar->bus_addr;
+
+	return 0;
+
+err_out:
+	pdsc_unmap_bars(pdsc);
+	pdsc->info_regs = NULL;
+	pdsc->cmd_regs = NULL;
+	pdsc->intr_status = NULL;
+	pdsc->intr_ctrl = NULL;
+	return err;
+}
+
+static DEFINE_IDA(pdsc_pf_ida);
+
+static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct pdsc *pdsc;
+	int err;
+
+	pdsc = pdsc_dl_alloc(dev);
+	if (!pdsc)
+		return -ENOMEM;
+
+	pdsc->pdev = pdev;
+	pdsc->dev = &pdev->dev;
+	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
+	set_bit(PDSC_S_INITING_DRIVER, &pdsc->state);
+	pci_set_drvdata(pdev, pdsc);
+	pdsc_debugfs_add_dev(pdsc);
+
+	err = ida_alloc(&pdsc_pf_ida, GFP_KERNEL);
+	if (err < 0) {
+		dev_err(pdsc->dev, "%s: id alloc failed: %pe\n", __func__, ERR_PTR(err));
+		goto err_out_free_devlink;
+	}
+	pdsc->id = err;
+
+	/* Query system for DMA addressing limitation for the device. */
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(PDS_CORE_ADDR_LEN));
+	if (err) {
+		dev_err(dev, "Unable to obtain 64-bit DMA for consistent allocations, aborting: %pe\n",
+			ERR_PTR(err));
+		goto err_out_free_ida;
+	}
+
+	pci_enable_pcie_error_reporting(pdev);
+
+	/* Use devres management */
+	err = pcim_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Cannot enable PCI device: %pe\n", ERR_PTR(err));
+		goto err_out_free_ida;
+	}
+
+	err = pci_request_regions(pdev, PDS_CORE_DRV_NAME);
+	if (err) {
+		dev_err(dev, "Cannot request PCI regions: %pe\n", ERR_PTR(err));
+		goto err_out_pci_disable_device;
+	}
+
+	pcie_print_link_status(pdev);
+	pci_set_master(pdev);
+
+	err = pdsc_map_bars(pdsc);
+	if (err)
+		goto err_out_pci_disable_device;
+
+	/* publish devlink device */
+	err = pdsc_dl_register(pdsc);
+	if (err) {
+		dev_err(dev, "Cannot register devlink: %pe\n", ERR_PTR(err));
+		goto err_out;
+	}
+
+	clear_bit(PDSC_S_INITING_DRIVER, &pdsc->state);
+	return 0;
+
+err_out:
+	pci_clear_master(pdev);
+	pdsc_unmap_bars(pdsc);
+	pci_release_regions(pdev);
+err_out_pci_disable_device:
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
+err_out_free_ida:
+	ida_free(&pdsc_pf_ida, pdsc->id);
+err_out_free_devlink:
+	pdsc_debugfs_del_dev(pdsc);
+	pdsc_dl_free(pdsc);
+
+	return err;
+}
+
+static void pdsc_remove(struct pci_dev *pdev)
+{
+	struct pdsc *pdsc = pci_get_drvdata(pdev);
+
+	/* Undo the devlink registration now to be sure there
+	 * are no requests while we're stopping.
+	 */
+	pdsc_dl_unregister(pdsc);
+
+	/* Device teardown */
+	ida_free(&pdsc_pf_ida, pdsc->id);
+
+	/* PCI teardown */
+	pci_clear_master(pdev);
+	pdsc_unmap_bars(pdsc);
+	pci_release_regions(pdev);
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
+
+	/* Devlink and pdsc struct teardown */
+	pdsc_dl_free(pdsc);
+}
+
+static struct pci_driver pdsc_driver = {
+	.name = PDS_CORE_DRV_NAME,
+	.id_table = pdsc_id_table,
+	.probe = pdsc_probe,
+	.remove = pdsc_remove,
+};
+
+static int __init pdsc_init_module(void)
+{
+	pdsc_debugfs_create();
+	return pci_register_driver(&pdsc_driver);
+}
+
+static void __exit pdsc_cleanup_module(void)
+{
+	pci_unregister_driver(&pdsc_driver);
+	pdsc_debugfs_destroy();
+
+	pr_info("removed\n");
+}
+
+module_init(pdsc_init_module);
+module_exit(pdsc_cleanup_module);
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
new file mode 100644
index 000000000000..7de3c1b8526b
--- /dev/null
+++ b/include/linux/pds/pds_common.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
+/* Copyright (c) 2022 Pensando Systems, Inc.  All rights reserved. */
+
+#ifndef _PDS_COMMON_H_
+#define _PDS_COMMON_H_
+
+#define PDS_CORE_DRV_NAME			"pds_core"
+
+/* the device's internal addressing uses up to 52 bits */
+#define PDS_CORE_ADDR_LEN	52
+#define PDS_CORE_ADDR_MASK	(BIT_ULL(PDS_ADDR_LEN) - 1)
+
+#endif /* _PDS_COMMON_H_ */
diff --git a/include/linux/pds/pds_core_if.h b/include/linux/pds/pds_core_if.h
new file mode 100644
index 000000000000..6333ec351e14
--- /dev/null
+++ b/include/linux/pds/pds_core_if.h
@@ -0,0 +1,581 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
+/* Copyright (c) 2022 Pensando Systems, Inc.  All rights reserved. */
+
+#ifndef _PDS_CORE_IF_H_
+#define _PDS_CORE_IF_H_
+
+#include "pds_common.h"
+
+#define PCI_VENDOR_ID_PENSANDO			0x1dd8
+#define PCI_DEVICE_ID_PENSANDO_CORE_PF		0x100c
+
+#define PDS_CORE_BARS_MAX			4
+#define PDS_CORE_PCI_BAR_DBELL			1
+
+/* Bar0 */
+#define PDS_CORE_DEV_INFO_SIGNATURE		0x44455649 /* 'DEVI' */
+#define PDS_CORE_BAR0_SIZE			0x8000
+#define PDS_CORE_BAR0_DEV_INFO_REGS_OFFSET	0x0000
+#define PDS_CORE_BAR0_DEV_CMD_REGS_OFFSET	0x0800
+#define PDS_CORE_BAR0_DEV_CMD_DATA_REGS_OFFSET	0x0c00
+#define PDS_CORE_BAR0_INTR_STATUS_OFFSET	0x1000
+#define PDS_CORE_BAR0_INTR_CTRL_OFFSET		0x2000
+#define PDS_CORE_DEV_CMD_DONE			0x00000001
+
+#define PDS_CORE_DEVCMD_TIMEOUT			5
+
+#define PDS_CORE_CLIENT_ID			0
+#define PDS_CORE_ASIC_TYPE_CAPRI		0
+
+/*
+ * enum pds_core_cmd_opcode - Device commands
+ */
+enum pds_core_cmd_opcode {
+
+	/* Core init */
+	PDS_CORE_CMD_NOP		= 0,
+	PDS_CORE_CMD_IDENTIFY		= 1,
+	PDS_CORE_CMD_RESET		= 2,
+	PDS_CORE_CMD_INIT		= 3,
+
+	PDS_CORE_CMD_FW_DOWNLOAD	= 4,
+	PDS_CORE_CMD_FW_CONTROL		= 5,
+
+	/* SR/IOV commands */
+	PDS_CORE_CMD_VF_GETATTR		= 60,
+	PDS_CORE_CMD_VF_SETATTR		= 61,
+	PDS_CORE_CMD_VF_CTRL		= 62,
+
+	/* Add commands before this line */
+	PDS_CORE_CMD_MAX,
+	PDS_CORE_CMD_COUNT
+};
+
+/**
+ * struct pds_core_drv_identity - Driver identity information
+ * @drv_type:         Driver type (enum pds_core_driver_type)
+ * @os_dist:          OS distribution, numeric format
+ * @os_dist_str:      OS distribution, string format
+ * @kernel_ver:       Kernel version, numeric format
+ * @kernel_ver_str:   Kernel version, string format
+ * @driver_ver_str:   Driver version, string format
+ */
+struct pds_core_drv_identity {
+	__le32 drv_type;
+	__le32 os_dist;
+	char   os_dist_str[128];
+	__le32 kernel_ver;
+	char   kernel_ver_str[32];
+	char   driver_ver_str[32];
+};
+
+#define PDS_DEV_TYPE_MAX	16
+/**
+ * struct pds_core_dev_identity - Device identity information
+ * @version:	      Version of device identify
+ * @type:	      Identify type (0 for now)
+ * @state:	      Device state
+ * @rsvd:	      Word boundary padding
+ * @nlifs:	      Number of LIFs provisioned
+ * @nintrs:	      Number of interrupts provisioned
+ * @ndbpgs_per_lif:   Number of doorbell pages per LIF
+ * @intr_coal_mult:   Interrupt coalescing multiplication factor
+ *		      Scale user-supplied interrupt coalescing
+ *		      value in usecs to device units using:
+ *		      device units = usecs * mult / div
+ * @intr_coal_div:    Interrupt coalescing division factor
+ *		      Scale user-supplied interrupt coalescing
+ *		      value in usecs to device units using:
+ *		      device units = usecs * mult / div
+ * @vif_types:        How many of each VIF device type is supported
+ */
+struct pds_core_dev_identity {
+	u8     version;
+	u8     type;
+	u8     state;
+	u8     rsvd;
+	__le32 nlifs;
+	__le32 nintrs;
+	__le32 ndbpgs_per_lif;
+	__le32 intr_coal_mult;
+	__le32 intr_coal_div;
+	__le16 vif_types[PDS_DEV_TYPE_MAX];
+};
+
+#define PDS_CORE_IDENTITY_VERSION_1	1
+
+/**
+ * struct pds_core_dev_identify_cmd - Driver/device identify command
+ * @opcode:	Opcode PDS_CORE_CMD_IDENTIFY
+ * @ver:	Highest version of identify supported by driver
+ *
+ * Expects to find driver identification info (struct pds_core_drv_identity)
+ * in cmd_regs->data.  Driver should keep the devcmd interface locked
+ * while preparing the driver info.
+ */
+struct pds_core_dev_identify_cmd {
+	u8 opcode;
+	u8 ver;
+};
+
+/**
+ * struct pds_core_dev_identify_comp - Device identify command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @ver:	Version of identify returned by device
+ *
+ * Device identification info (struct pds_core_dev_identity) can be found
+ * in cmd_regs->data.  Driver should keep the devcmd interface locked
+ * while reading the results.
+ */
+struct pds_core_dev_identify_comp {
+	u8 status;
+	u8 ver;
+};
+
+/**
+ * struct pds_core_dev_reset_cmd - Device reset command
+ * @opcode:	Opcode PDS_CORE_CMD_RESET
+ *
+ * Resets and clears all LIFs, VDevs, and VIFs on the device.
+ */
+struct pds_core_dev_reset_cmd {
+	u8 opcode;
+};
+
+/**
+ * struct pds_core_dev_reset_comp - Reset command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ */
+struct pds_core_dev_reset_comp {
+	u8 status;
+};
+
+/*
+ * struct pds_core_dev_init_data - Pointers and info needed for the Core
+ * initialization PDS_CORE_CMD_INIT command.  The in and out structs are
+ * overlays on the pds_core_dev_cmd_regs.data space for passing data down
+ * to the firmware on init, and then returning initialization results.
+ */
+struct pds_core_dev_init_data_in {
+	__le64 adminq_q_base;
+	__le64 adminq_cq_base;
+	__le64 notifyq_cq_base;
+	__le32 flags;
+	__le16 intr_index;
+	u8     adminq_ring_size;
+	u8     notifyq_ring_size;
+};
+
+struct pds_core_dev_init_data_out {
+	__le32 core_hw_index;
+	__le32 adminq_hw_index;
+	__le32 notifyq_hw_index;
+	u8     adminq_hw_type;
+	u8     notifyq_hw_type;
+};
+
+/**
+ * struct pds_core_dev_init_cmd - Core device initialize
+ * @opcode:          opcode PDS_CORE_CMD_INIT
+ *
+ * Initializes the core device and sets up the AdminQ and NotifyQ.
+ * Expects to find initialization data (struct pds_core_dev_init_data_in)
+ * in cmd_regs->data.  Driver should keep the devcmd interface locked
+ * while preparing the driver info.
+ */
+struct pds_core_dev_init_cmd {
+	u8     opcode;
+};
+
+/**
+ * struct pds_core_dev_init_comp - Core init completion
+ * @status:     Status of the command (enum pds_core_status_code)
+ *
+ * Initialization result data (struct pds_core_dev_init_data_in)
+ * is found in cmd_regs->data.
+ */
+struct pds_core_dev_init_comp {
+	u8     status;
+};
+
+/**
+ * struct pds_core_fw_download_cmd - Firmware download command
+ * @opcode:     opcode
+ * @rsvd:	Word boundary padding
+ * @addr:       DMA address of the firmware buffer
+ * @offset:     offset of the firmware buffer within the full image
+ * @length:     number of valid bytes in the firmware buffer
+ */
+struct pds_core_fw_download_cmd {
+	u8     opcode;
+	u8     rsvd[3];
+	__le32 offset;
+	__le64 addr;
+	__le32 length;
+};
+
+/**
+ * struct pds_core_fw_download_comp - Firmware download completion
+ * @status:     Status of the command (enum pds_core_status_code)
+ */
+struct pds_core_fw_download_comp {
+	u8     status;
+};
+
+/**
+ * enum pds_core_fw_control_oper - FW control operations
+ * @PDS_CORE_FW_INSTALL_ASYNC:     Install firmware asynchronously
+ * @PDS_CORE_FW_INSTALL_STATUS:    Firmware installation status
+ * @PDS_CORE_FW_ACTIVATE_ASYNC:    Activate firmware asynchronously
+ * @PDS_CORE_FW_ACTIVATE_STATUS:   Firmware activate status
+ * @PDS_CORE_FW_UPDATE_CLEANUP:    Cleanup any firmware update leftovers
+ * @PDS_CORE_FW_GET_BOOT:          Return current active firmware slot
+ * @PDS_CORE_FW_SET_BOOT:          Set active firmware slot for next boot
+ * @PDS_CORE_FW_GET_LIST:          Return list of installed firmware images
+ */
+enum pds_core_fw_control_oper {
+	PDS_CORE_FW_INSTALL_ASYNC          = 0,
+	PDS_CORE_FW_INSTALL_STATUS         = 1,
+	PDS_CORE_FW_ACTIVATE_ASYNC         = 2,
+	PDS_CORE_FW_ACTIVATE_STATUS        = 3,
+	PDS_CORE_FW_UPDATE_CLEANUP         = 4,
+	PDS_CORE_FW_GET_BOOT               = 5,
+	PDS_CORE_FW_SET_BOOT               = 6,
+	PDS_CORE_FW_GET_LIST               = 7,
+};
+
+enum pds_core_fw_slot {
+	PDS_CORE_FW_SLOT_INVALID    = 0,
+	PDS_CORE_FW_SLOT_A	        = 1,
+	PDS_CORE_FW_SLOT_B          = 2,
+	PDS_CORE_FW_SLOT_GOLD       = 3,
+};
+
+/**
+ * struct pds_core_fw_control_cmd - Firmware control command
+ * @opcode:    opcode
+ * @rsvd:      Word boundary padding
+ * @oper:      firmware control operation (enum pds_core_fw_control_oper)
+ * @slot:      slot to operate on (enum pds_core_fw_slot)
+ */
+struct pds_core_fw_control_cmd {
+	u8  opcode;
+	u8  rsvd[3];
+	u8  oper;
+	u8  slot;
+};
+
+/**
+ * struct pds_core_fw_control_comp - Firmware control copletion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:	Word alignment space
+ * @slot:	Slot number (enum pds_core_fw_slot)
+ * @rsvd1:	Struct padding
+ * @color:	Color bit
+ */
+struct pds_core_fw_control_comp {
+	u8     status;
+	u8     rsvd[3];
+	u8     slot;
+	u8     rsvd1[10];
+	u8     color;
+};
+
+struct pds_core_fw_name_info {
+#define PDS_CORE_FWSLOT_BUFLEN		8
+#define PDS_CORE_FWVERS_BUFLEN		32
+	char   slotname[PDS_CORE_FWSLOT_BUFLEN];
+	char   fw_version[PDS_CORE_FWVERS_BUFLEN];
+};
+
+struct pds_core_fw_list_info {
+#define PDS_CORE_FWVERS_LIST_LEN	16
+	u8 num_fw_slots;
+	struct pds_core_fw_name_info fw_names[PDS_CORE_FWVERS_LIST_LEN];
+} __packed;
+
+enum pds_core_vf_attr {
+	PDS_CORE_VF_ATTR_SPOOFCHK	= 1,
+	PDS_CORE_VF_ATTR_TRUST		= 2,
+	PDS_CORE_VF_ATTR_MAC		= 3,
+	PDS_CORE_VF_ATTR_LINKSTATE	= 4,
+	PDS_CORE_VF_ATTR_VLAN		= 5,
+	PDS_CORE_VF_ATTR_RATE		= 6,
+	PDS_CORE_VF_ATTR_STATSADDR	= 7,
+};
+
+/**
+ * enum pds_core_vf_link_status - Virtual Function link status
+ * @PDS_CORE_VF_LINK_STATUS_AUTO:   Use link state of the uplink
+ * @PDS_CORE_VF_LINK_STATUS_UP:     Link always up
+ * @PDS_CORE_VF_LINK_STATUS_DOWN:   Link always down
+ */
+enum pds_core_vf_link_status {
+	PDS_CORE_VF_LINK_STATUS_AUTO = 0,
+	PDS_CORE_VF_LINK_STATUS_UP   = 1,
+	PDS_CORE_VF_LINK_STATUS_DOWN = 2,
+};
+
+/**
+ * struct pds_core_vf_setattr_cmd - Set VF attributes on the NIC
+ * @opcode:     Opcode
+ * @attr:       Attribute type (enum pds_core_vf_attr)
+ * @vf_index:   VF index
+ * @macaddr:	mac address
+ * @vlanid:	vlan ID
+ * @maxrate:	max Tx rate in Mbps
+ * @spoofchk:	enable address spoof checking
+ * @trust:	enable VF trust
+ * @linkstate:	set link up or down
+ * @stats:	stats addr struct
+ * @stats.pa:	set DMA address for VF stats
+ * @stats.len:	length of VF stats space
+ * @pad:	force union to specific size
+ */
+struct pds_core_vf_setattr_cmd {
+	u8     opcode;
+	u8     attr;
+	__le16 vf_index;
+	union {
+		u8     macaddr[6];
+		__le16 vlanid;
+		__le32 maxrate;
+		u8     spoofchk;
+		u8     trust;
+		u8     linkstate;
+		struct {
+			__le64 pa;
+			__le32 len;
+		} stats;
+		u8     pad[60];
+	} __packed;
+};
+
+struct pds_core_vf_setattr_comp {
+	u8     status;
+	u8     attr;
+	__le16 vf_index;
+	__le16 comp_index;
+	u8     rsvd[9];
+	u8     color;
+};
+
+/**
+ * struct pds_core_vf_getattr_cmd - Get VF attributes from the NIC
+ * @opcode:     Opcode
+ * @attr:       Attribute type (enum pds_core_vf_attr)
+ * @vf_index:   VF index
+ */
+struct pds_core_vf_getattr_cmd {
+	u8     opcode;
+	u8     attr;
+	__le16 vf_index;
+};
+
+struct pds_core_vf_getattr_comp {
+	u8     status;
+	u8     attr;
+	__le16 vf_index;
+	union {
+		u8     macaddr[6];
+		__le16 vlanid;
+		__le32 maxrate;
+		u8     spoofchk;
+		u8     trust;
+		u8     linkstate;
+		__le64 stats_pa;
+		u8     pad[11];
+	} __packed;
+	u8     color;
+};
+
+enum pds_core_vf_ctrl_opcode {
+	PDS_CORE_VF_CTRL_START_ALL	= 0,
+	PDS_CORE_VF_CTRL_START		= 1,
+};
+
+/**
+ * struct pds_core_vf_ctrl_cmd - VF control command
+ * @opcode:         Opcode for the command
+ * @ctrl_opcode:    VF control operation type
+ * @vf_index:       VF Index. It is unused if op START_ALL is used.
+ */
+struct pds_core_vf_ctrl_cmd {
+	u8	opcode;
+	u8	ctrl_opcode;
+	__le16	vf_index;
+};
+
+/**
+ * struct pds_core_vf_ctrl_comp - VF_CTRL command completion.
+ * @status:     Status of the command (enum pds_core_status_code)
+ */
+struct pds_core_vf_ctrl_comp {
+	u8	status;
+};
+
+/*
+ * union pds_core_dev_cmd - Overlay of core device command structures
+ */
+union pds_core_dev_cmd {
+	u8     opcode;
+	u32    words[16];
+
+	struct pds_core_dev_identify_cmd identify;
+	struct pds_core_dev_init_cmd     init;
+	struct pds_core_dev_reset_cmd    reset;
+	struct pds_core_fw_download_cmd  fw_download;
+	struct pds_core_fw_control_cmd   fw_control;
+
+	struct pds_core_vf_setattr_cmd   vf_setattr;
+	struct pds_core_vf_getattr_cmd   vf_getattr;
+	struct pds_core_vf_ctrl_cmd      vf_ctrl;
+};
+
+/*
+ * union pds_core_dev_comp - Overlay of core device completion structures
+ */
+union pds_core_dev_comp {
+	u8                                status;
+	u8                                bytes[16];
+
+	struct pds_core_dev_identify_comp identify;
+	struct pds_core_dev_reset_comp    reset;
+	struct pds_core_dev_init_comp     init;
+	struct pds_core_fw_download_comp  fw_download;
+	struct pds_core_fw_control_comp   fw_control;
+
+	struct pds_core_vf_setattr_comp   vf_setattr;
+	struct pds_core_vf_getattr_comp   vf_getattr;
+	struct pds_core_vf_ctrl_comp      vf_ctrl;
+};
+
+/**
+ * struct pds_core_dev_hwstamp_regs - Hardware current timestamp registers
+ * @tick_low:        Low 32 bits of hardware timestamp
+ * @tick_high:       High 32 bits of hardware timestamp
+ */
+struct pds_core_dev_hwstamp_regs {
+	u32    tick_low;
+	u32    tick_high;
+};
+
+/**
+ * struct pds_core_dev_info_regs - Device info register format (read-only)
+ * @signature:       Signature value of 0x44455649 ('DEVI')
+ * @version:         Current version of info
+ * @asic_type:       Asic type
+ * @asic_rev:        Asic revision
+ * @fw_status:       Firmware status
+ *			bit 0   - 1 = fw running
+ *			bit 4-7 - 4 bit generation number, changes on fw restart
+ * @fw_heartbeat:    Firmware heartbeat counter
+ * @serial_num:      Serial number
+ * @fw_version:      Firmware version
+ * @oprom_regs:      oprom_regs to store oprom debug enable/disable and bmp
+ * @rsvd_pad1024:    Struct padding
+ * @hwstamp:         Hardware current timestamp registers
+ * @rsvd_pad2048:    Struct padding
+ */
+struct pds_core_dev_info_regs {
+#define PDS_CORE_DEVINFO_FWVERS_BUFLEN 32
+#define PDS_CORE_DEVINFO_SERIAL_BUFLEN 32
+	u32    signature;
+	u8     version;
+	u8     asic_type;
+	u8     asic_rev;
+#define PDS_CORE_FW_STS_F_RUNNING	0x01
+#define PDS_CORE_FW_STS_F_GENERATION	0xF0
+	u8     fw_status;
+	__le32 fw_heartbeat;
+	char   fw_version[PDS_CORE_DEVINFO_FWVERS_BUFLEN];
+	char   serial_num[PDS_CORE_DEVINFO_SERIAL_BUFLEN];
+	u8     oprom_regs[32];     /* reserved */
+	u8     rsvd_pad1024[916];
+	struct pds_core_dev_hwstamp_regs hwstamp;   /* on 1k boundary */
+	u8     rsvd_pad2048[1016];
+} __packed;
+
+/**
+ * struct pds_core_dev_cmd_regs - Device command register format (read-write)
+ * @doorbell:	Device Cmd Doorbell, write-only
+ *              Write a 1 to signal device to process cmd
+ * @done:	Command completed indicator, poll for completion
+ *              bit 0 == 1 when command is complete
+ * @cmd:	Opcode-specific command bytes
+ * @comp:	Opcode-specific response bytes
+ * @rsvd:	Struct padding
+ * @data:	Opcode-specific side-data
+ */
+struct pds_core_dev_cmd_regs {
+	u32                     doorbell;
+	u32                     done;
+	union pds_core_dev_cmd  cmd;
+	union pds_core_dev_comp comp;
+	u8                      rsvd[48];
+	u32                     data[478];
+} __packed;
+
+/**
+ * struct pds_core_dev_regs - Device register format for bar 0 page 0
+ * @info:            Device info registers
+ * @devcmd:          Device command registers
+ */
+struct pds_core_dev_regs {
+	struct pds_core_dev_info_regs info;
+	struct pds_core_dev_cmd_regs  devcmd;
+} __packed;
+
+/*
+ * struct pds_core_vf_stats - VF statistics structure
+ */
+struct pds_core_vf_stats {
+	/* RX */
+	__le64 rx_ucast_bytes;
+	__le64 rx_ucast_packets;
+	__le64 rx_mcast_bytes;
+	__le64 rx_mcast_packets;
+	__le64 rx_bcast_bytes;
+	__le64 rx_bcast_packets;
+	__le64 rsvd0;
+	__le64 rsvd1;
+	/* RX drops */
+	__le64 rx_ucast_drop_bytes;
+	__le64 rx_ucast_drop_packets;
+	__le64 rx_mcast_drop_bytes;
+	__le64 rx_mcast_drop_packets;
+	__le64 rx_bcast_drop_bytes;
+	__le64 rx_bcast_drop_packets;
+	__le64 rx_dma_error;
+	__le64 rsvd2;
+	/* TX */
+	__le64 tx_ucast_bytes;
+	__le64 tx_ucast_packets;
+	__le64 tx_mcast_bytes;
+	__le64 tx_mcast_packets;
+	__le64 tx_bcast_bytes;
+	__le64 tx_bcast_packets;
+	__le64 rsvd3;
+	__le64 rsvd4;
+	/* TX drops */
+	__le64 tx_ucast_drop_bytes;
+	__le64 tx_ucast_drop_packets;
+	__le64 tx_mcast_drop_bytes;
+	__le64 tx_mcast_drop_packets;
+	__le64 tx_bcast_drop_bytes;
+	__le64 tx_bcast_drop_packets;
+	__le64 tx_dma_error;
+	__le64 rsvd5;
+};
+
+#ifndef __CHECKER__
+static_assert(sizeof(struct pds_core_drv_identity) <= 1912);
+static_assert(sizeof(struct pds_core_dev_identity) <= 1912);
+static_assert(sizeof(union pds_core_dev_cmd) == 64);
+static_assert(sizeof(union pds_core_dev_comp) == 16);
+static_assert(sizeof(struct pds_core_dev_info_regs) == 2048);
+static_assert(sizeof(struct pds_core_dev_cmd_regs) == 2048);
+static_assert(sizeof(struct pds_core_dev_regs) == 4096);
+#endif /* __CHECKER__ */
+
+#endif /* _PDS_CORE_REGS_H_ */
-- 
2.17.1

