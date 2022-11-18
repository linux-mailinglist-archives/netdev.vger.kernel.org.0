Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802156302B9
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiKRXOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiKRXNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:39 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C40C68A6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:58 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id a22-20020a17090a6d9600b0021896eb5554so615713pjk.1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+5c/WgZHdCy2oUygsf8Vt6i9S6K2W0JMjMSgHf0dYXs=;
        b=QT4emBu2VRElbZazXpWMqzy7bREKeBA1ZetVzWmchnArzLwUMjv8+EpjYxP/vNcpii
         CWYonfsq8L3aQsk4IGdUp9Hq40Tukg5ft1UUNdy+RQ/1FfYpr+Qcz1hwCi+g3dyGK3X0
         CG8/lK8f7zsRXogGNDPJt0axG4Lru/UmRaWl+qJYXrQg0N1q0FtiMvOevMRnrB7DIJa+
         PrebUhBou+KT0Ua7SdqJn9c5W7af/ley/DpVFNgEm9Ucttv9MrnaVQqkAKbOBLuJlohy
         dPq4k2Nd6DGuC/puYWg8TvznSQy9gSDcJrX2Cu+2tdc4lZZvVb1qlLeJuJuZJ+/Mcpe2
         8B5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+5c/WgZHdCy2oUygsf8Vt6i9S6K2W0JMjMSgHf0dYXs=;
        b=ugYmhFlX4NCPqL0Y8uMPAyvz+4N1knY+Ww7zAnf/F3DH8M4l9KBiRVAkjWH54YBj2P
         EBDni7JQDsjT9zYzv5M54q45CeY2F48xYy4nZaDxLz16BK2U7rLJrAhIlKpv3CmuwU1g
         7CzulkakG6C5FJbFyY2zocsU/hJi76P7UEcGzEZggoKGQSHA1ViCWbrKYEehAkU9PKqX
         qFak2gPfkCjWgvYJTNEpIZj0uwcp2Hc68m8djx0XkagSp3Yy1PPLFbHQpgl6TBJUoFOn
         5nXt8sGjYUf04Fvn3F9A3ELPSYJd2W+5SsZa4vKXTvBIMdnIDzPBee1mGUHuceGnfrSs
         vQDA==
X-Gm-Message-State: ANoB5pl1KUxRg1RuzvYMZr/1gSTT8m9GPLR5hdG8qSUDrMqsS2PgOSng
        bEzKTyI+It6VXYyRQaTovqss+40xtMmG5g==
X-Google-Smtp-Source: AA0mqf4TVghu32zAXuAxJtx8ec0wyX5z3dK5ChtP5QvXDrWGPXWj86XM+88bqPtWlc0WVe03G4DmOw==
X-Received: by 2002:a17:902:dac2:b0:189:7d5:26ea with SMTP id q2-20020a170902dac200b0018907d526eamr1473704plx.145.1668812251189;
        Fri, 18 Nov 2022 14:57:31 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:30 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 14/19] pds_vdpa: Add new PCI VF device for PDS vDPA services
Date:   Fri, 18 Nov 2022 14:56:51 -0800
Message-Id: <20221118225656.48309-15-snelson@pensando.io>
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

This is the initial PCI driver framework for the new pds_vdpa VF
device driver, an auxiliary_bus client of the pds_core driver.
This does the very basics of registering for the new PCI
device 1dd8:100b, setting up debugfs entries, and registering
with devlink.

The new PCI device id has not made it to the official PCI ID Repository
yet, but will soon be registered there.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/vdpa/pds/Makefile       |   7 +
 drivers/vdpa/pds/debugfs.c      |  44 +++++++
 drivers/vdpa/pds/debugfs.h      |  22 ++++
 drivers/vdpa/pds/pci_drv.c      | 143 +++++++++++++++++++++
 drivers/vdpa/pds/pci_drv.h      |  46 +++++++
 include/linux/pds/pds_core_if.h |   1 +
 include/linux/pds/pds_vdpa.h    | 219 ++++++++++++++++++++++++++++++++
 7 files changed, 482 insertions(+)
 create mode 100644 drivers/vdpa/pds/Makefile
 create mode 100644 drivers/vdpa/pds/debugfs.c
 create mode 100644 drivers/vdpa/pds/debugfs.h
 create mode 100644 drivers/vdpa/pds/pci_drv.c
 create mode 100644 drivers/vdpa/pds/pci_drv.h
 create mode 100644 include/linux/pds/pds_vdpa.h

diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
new file mode 100644
index 000000000000..3ba28a875574
--- /dev/null
+++ b/drivers/vdpa/pds/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright(c) 2022 Pensando Systems, Inc
+
+obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
+
+pds_vdpa-y := pci_drv.o	\
+	      debugfs.o
diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
new file mode 100644
index 000000000000..f5b6654ae89b
--- /dev/null
+++ b/drivers/vdpa/pds/debugfs.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_vdpa.h>
+
+#include "pci_drv.h"
+#include "debugfs.h"
+
+#ifdef CONFIG_DEBUG_FS
+
+static struct dentry *dbfs_dir;
+
+void
+pds_vdpa_debugfs_create(void)
+{
+	dbfs_dir = debugfs_create_dir(PDS_VDPA_DRV_NAME, NULL);
+}
+
+void
+pds_vdpa_debugfs_destroy(void)
+{
+	debugfs_remove_recursive(dbfs_dir);
+	dbfs_dir = NULL;
+}
+
+void
+pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev)
+{
+	vdpa_pdev->dentry = debugfs_create_dir(pci_name(vdpa_pdev->pdev), dbfs_dir);
+}
+
+void
+pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev)
+{
+	debugfs_remove_recursive(vdpa_pdev->dentry);
+	vdpa_pdev->dentry = NULL;
+}
+
+#endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
new file mode 100644
index 000000000000..ac31ab47746b
--- /dev/null
+++ b/drivers/vdpa/pds/debugfs.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _PDS_VDPA_DEBUGFS_H_
+#define _PDS_VDPA_DEBUGFS_H_
+
+#include <linux/debugfs.h>
+
+#ifdef CONFIG_DEBUG_FS
+
+void pds_vdpa_debugfs_create(void);
+void pds_vdpa_debugfs_destroy(void);
+void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
+void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
+#else
+static inline void pds_vdpa_debugfs_create(void) { }
+static inline void pds_vdpa_debugfs_destroy(void) { }
+static inline void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
+static inline void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
+#endif
+
+#endif /* _PDS_VDPA_DEBUGFS_H_ */
diff --git a/drivers/vdpa/pds/pci_drv.c b/drivers/vdpa/pds/pci_drv.c
new file mode 100644
index 000000000000..369e11153f21
--- /dev/null
+++ b/drivers/vdpa/pds/pci_drv.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/aer.h>
+#include <linux/types.h>
+#include <linux/vdpa.h>
+
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_vdpa.h>
+
+#include "pci_drv.h"
+#include "debugfs.h"
+
+static void
+pds_vdpa_dma_action(void *data)
+{
+	pci_free_irq_vectors((struct pci_dev *)data);
+}
+
+static int
+pds_vdpa_pci_probe(struct pci_dev *pdev,
+		   const struct pci_device_id *id)
+{
+	struct pds_vdpa_pci_device *vdpa_pdev;
+	struct device *dev = &pdev->dev;
+	int err;
+
+	vdpa_pdev = kzalloc(sizeof(*vdpa_pdev), GFP_KERNEL);
+	if (!vdpa_pdev)
+		return -ENOMEM;
+	pci_set_drvdata(pdev, vdpa_pdev);
+
+	vdpa_pdev->pdev = pdev;
+	vdpa_pdev->vf_id = pci_iov_vf_id(pdev);
+	vdpa_pdev->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
+
+	/* Query system for DMA addressing limitation for the device. */
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(PDS_CORE_ADDR_LEN));
+	if (err) {
+		dev_err(dev, "Unable to obtain 64-bit DMA for consistent allocations, aborting. %pe\n",
+			ERR_PTR(err));
+		goto err_out_free_mem;
+	}
+
+	pci_enable_pcie_error_reporting(pdev);
+
+	/* Use devres management */
+	err = pcim_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Cannot enable PCI device: %pe\n", ERR_PTR(err));
+		goto err_out_free_mem;
+	}
+
+	err = devm_add_action_or_reset(dev, pds_vdpa_dma_action, pdev);
+	if (err) {
+		dev_err(dev, "Failed adding devres for freeing irq vectors: %pe\n",
+			ERR_PTR(err));
+		goto err_out_pci_release_device;
+	}
+
+	pci_set_master(pdev);
+
+	pds_vdpa_debugfs_add_pcidev(vdpa_pdev);
+
+	dev_info(dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d vdpa_aux %p vdpa_pdev %p\n",
+		 __func__, pci_dev_id(vdpa_pdev->pdev->physfn),
+		 vdpa_pdev->pci_id, vdpa_pdev->pci_id, vdpa_pdev->vf_id,
+		 pci_domain_nr(pdev->bus), vdpa_pdev->vdpa_aux, vdpa_pdev);
+
+	return 0;
+
+err_out_pci_release_device:
+	pci_disable_device(pdev);
+err_out_free_mem:
+	pci_disable_pcie_error_reporting(pdev);
+	kfree(vdpa_pdev);
+	return err;
+}
+
+static void
+pds_vdpa_pci_remove(struct pci_dev *pdev)
+{
+	struct pds_vdpa_pci_device *vdpa_pdev = pci_get_drvdata(pdev);
+
+	pds_vdpa_debugfs_del_pcidev(vdpa_pdev);
+	pci_clear_master(pdev);
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
+	kfree(vdpa_pdev);
+
+	dev_info(&pdev->dev, "Removed\n");
+}
+
+static const struct pci_device_id
+pds_vdpa_pci_table[] = {
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_VDPA_VF) },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, pds_vdpa_pci_table);
+
+static struct pci_driver
+pds_vdpa_pci_driver = {
+	.name = PDS_VDPA_DRV_NAME,
+	.id_table = pds_vdpa_pci_table,
+	.probe = pds_vdpa_pci_probe,
+	.remove = pds_vdpa_pci_remove
+};
+
+static void __exit
+pds_vdpa_pci_cleanup(void)
+{
+	pci_unregister_driver(&pds_vdpa_pci_driver);
+
+	pds_vdpa_debugfs_destroy();
+}
+module_exit(pds_vdpa_pci_cleanup);
+
+static int __init
+pds_vdpa_pci_init(void)
+{
+	int err;
+
+	pds_vdpa_debugfs_create();
+
+	err = pci_register_driver(&pds_vdpa_pci_driver);
+	if (err) {
+		pr_err("%s: pci driver register failed: %pe\n", __func__, ERR_PTR(err));
+		goto err_pci;
+	}
+
+	return 0;
+
+err_pci:
+	pds_vdpa_debugfs_destroy();
+	return err;
+}
+module_init(pds_vdpa_pci_init);
+
+MODULE_DESCRIPTION(PDS_VDPA_DRV_DESCRIPTION);
+MODULE_AUTHOR("Pensando Systems, Inc");
+MODULE_LICENSE("GPL");
diff --git a/drivers/vdpa/pds/pci_drv.h b/drivers/vdpa/pds/pci_drv.h
new file mode 100644
index 000000000000..747809e0df9e
--- /dev/null
+++ b/drivers/vdpa/pds/pci_drv.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _PCI_DRV_H
+#define _PCI_DRV_H
+
+#include <linux/pci.h>
+#include <linux/virtio_pci_modern.h>
+
+#define PDS_VDPA_DRV_NAME           "pds_vdpa"
+#define PDS_VDPA_DRV_DESCRIPTION    "Pensando vDPA VF Device Driver"
+
+#define PDS_VDPA_BAR_BASE	0
+#define PDS_VDPA_BAR_INTR	2
+#define PDS_VDPA_BAR_DBELL	4
+
+struct pds_dev_bar {
+	int           index;
+	void __iomem  *vaddr;
+	phys_addr_t   pa;
+	unsigned long len;
+};
+
+struct pds_vdpa_intr_info {
+	int index;
+	int irq;
+	int qid;
+	char name[32];
+};
+
+struct pds_vdpa_pci_device {
+	struct pci_dev *pdev;
+	struct pds_vdpa_aux *vdpa_aux;
+
+	int vf_id;
+	int pci_id;
+
+	int nintrs;
+	struct pds_vdpa_intr_info *intrs;
+
+	struct dentry *dentry;
+
+	struct virtio_pci_modern_device vd_mdev;
+};
+
+#endif /* _PCI_DRV_H */
diff --git a/include/linux/pds/pds_core_if.h b/include/linux/pds/pds_core_if.h
index 6333ec351e14..6e92697657e4 100644
--- a/include/linux/pds/pds_core_if.h
+++ b/include/linux/pds/pds_core_if.h
@@ -8,6 +8,7 @@
 
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
 #define PCI_DEVICE_ID_PENSANDO_CORE_PF		0x100c
+#define PCI_DEVICE_ID_PENSANDO_VDPA_VF          0x100b
 
 #define PDS_CORE_BARS_MAX			4
 #define PDS_CORE_PCI_BAR_DBELL			1
diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
new file mode 100644
index 000000000000..7ecef890f175
--- /dev/null
+++ b/include/linux/pds/pds_vdpa.h
@@ -0,0 +1,219 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _PDS_VDPA_IF_H_
+#define _PDS_VDPA_IF_H_
+
+#include <linux/pds/pds_common.h>
+
+#define PDS_DEV_TYPE_VDPA_STR	"vDPA"
+#define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
+
+/*
+ * enum pds_vdpa_cmd_opcode - vDPA Device commands
+ */
+enum pds_vdpa_cmd_opcode {
+	PDS_VDPA_CMD_INIT		= 48,
+	PDS_VDPA_CMD_IDENT		= 49,
+	PDS_VDPA_CMD_RESET		= 51,
+	PDS_VDPA_CMD_VQ_RESET		= 52,
+	PDS_VDPA_CMD_VQ_INIT		= 53,
+	PDS_VDPA_CMD_STATUS_UPDATE	= 54,
+	PDS_VDPA_CMD_SET_FEATURES	= 55,
+	PDS_VDPA_CMD_SET_ATTR		= 56,
+};
+
+/**
+ * struct pds_vdpa_cmd - generic command
+ * @opcode:	Opcode
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ */
+struct pds_vdpa_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_vdpa_comp - generic command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:	Word boundary padding
+ * @color:	Color bit
+ */
+struct pds_vdpa_comp {
+	u8 status;
+	u8 rsvd[14];
+	u8 color;
+};
+
+/**
+ * struct pds_vdpa_init_cmd - INIT command
+ * @opcode:	Opcode PDS_VDPA_CMD_INIT
+ * @vdpa_index: Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @len:	length of config info DMA space
+ * @config_pa:	address for DMA of virtio_net_config struct
+ */
+struct pds_vdpa_init_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le32 len;
+	__le64 config_pa;
+};
+
+/**
+ * struct pds_vdpa_ident - vDPA identification data
+ * @hw_features:	vDPA features supported by device
+ * @max_vqs:		max queues available (2 queues for a single queuepair)
+ * @max_qlen:		log(2) of maximum number of descriptors
+ * @min_qlen:		log(2) of minimum number of descriptors
+ *
+ * This struct is used in a DMA block that is set up for the PDS_VDPA_CMD_IDENT
+ * transaction.  Set up the DMA block and send the address in the IDENT cmd
+ * data, the DSC will write the ident information, then we can remove the DMA
+ * block after reading the answer.  If the completion status is 0, then there
+ * is valid information, else there was an error and the data should be invalid.
+ */
+struct pds_vdpa_ident {
+	__le64 hw_features;
+	__le16 max_vqs;
+	__le16 max_qlen;
+	__le16 min_qlen;
+};
+
+/**
+ * struct pds_vdpa_ident_cmd - IDENT command
+ * @opcode:	Opcode PDS_VDPA_CMD_IDENT
+ * @rsvd:       Word boundary padding
+ * @vf_id:	VF id
+ * @len:	length of ident info DMA space
+ * @ident_pa:	address for DMA of ident info (struct pds_vdpa_ident)
+ *			only used for this transaction, then forgotten by DSC
+ */
+struct pds_vdpa_ident_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	__le32 len;
+	__le64 ident_pa;
+};
+
+/**
+ * struct pds_vdpa_status_cmd - STATUS_UPDATE command
+ * @opcode:	Opcode PDS_VDPA_CMD_STATUS_UPDATE
+ * @vdpa_index: Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @status:	new status bits
+ */
+struct pds_vdpa_status_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	u8     status;
+};
+
+/**
+ * enum pds_vdpa_attr - List of VDPA device attributes
+ * @PDS_VDPA_ATTR_MAC:          MAC address
+ * @PDS_VDPA_ATTR_MAX_VQ_PAIRS: Max virtqueue pairs
+ */
+enum pds_vdpa_attr {
+	PDS_VDPA_ATTR_MAC          = 1,
+	PDS_VDPA_ATTR_MAX_VQ_PAIRS = 2,
+};
+
+/**
+ * struct pds_vdpa_setattr_cmd - SET_ATTR command
+ * @opcode:		Opcode PDS_VDPA_CMD_SET_ATTR
+ * @vdpa_index:		Index for vdpa subdevice
+ * @vf_id:		VF id
+ * @attr:		attribute to be changed (enum pds_vdpa_attr)
+ * @pad:		Word boundary padding
+ * @mac:		new mac address to be assigned as vdpa device address
+ * @max_vq_pairs:	new limit of virtqueue pairs
+ */
+struct pds_vdpa_setattr_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	u8     attr;
+	u8     pad[3];
+	union {
+		u8 mac[6];
+		__le16 max_vq_pairs;
+	} __packed;
+};
+
+/**
+ * struct pds_vdpa_vq_init_cmd - queue init command
+ * @opcode: Opcode PDS_VDPA_CMD_VQ_INIT
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @qid:	Queue id (bit0 clear = rx, bit0 set = tx, qid=N is ctrlq)
+ * @len:	log(2) of max descriptor count
+ * @desc_addr:	DMA address of descriptor area
+ * @avail_addr:	DMA address of available descriptors (aka driver area)
+ * @used_addr:	DMA address of used descriptors (aka device area)
+ * @intr_index:	interrupt index
+ */
+struct pds_vdpa_vq_init_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le16 qid;
+	__le16 len;
+	__le64 desc_addr;
+	__le64 avail_addr;
+	__le64 used_addr;
+	__le16 intr_index;
+};
+
+/**
+ * struct pds_vdpa_vq_init_comp - queue init completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @hw_qtype:	HW queue type, used in doorbell selection
+ * @hw_qindex:	HW queue index, used in doorbell selection
+ * @rsvd:	Word boundary padding
+ * @color:	Color bit
+ */
+struct pds_vdpa_vq_init_comp {
+	u8     status;
+	u8     hw_qtype;
+	__le16 hw_qindex;
+	u8     rsvd[11];
+	u8     color;
+};
+
+/**
+ * struct pds_vdpa_vq_reset_cmd - queue reset command
+ * @opcode:	Opcode PDS_VDPA_CMD_VQ_RESET
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @qid:	Queue id
+ */
+struct pds_vdpa_vq_reset_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le16 qid;
+};
+
+/**
+ * struct pds_vdpa_set_features_cmd - set hw features
+ * @opcode: Opcode PDS_VDPA_CMD_SET_FEATURES
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @rsvd:       Word boundary padding
+ * @features:	Feature bit mask
+ */
+struct pds_vdpa_set_features_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le32 rsvd;
+	__le64 features;
+};
+
+#endif /* _PDS_VDPA_IF_H_ */
-- 
2.17.1

