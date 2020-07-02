Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9D211E66
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgGBIYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:24:13 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59786 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgGBIYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:24:09 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628NcaD082119;
        Thu, 2 Jul 2020 03:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678218;
        bh=zm7vsB22cjejSvvY0tRsRTmZ5Goqgh+xoXKUJZr3zYs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=CCPOpSxeBAuME1xDmOTn/JsRonmd8GITXRmGxtdVhklINpBtKg/tofEOdGb8PlIu5
         l6v+0G7IlmXLuoB6lytDGCZQ/pSLvNgrRf6NPtcQq6V0+r6yOaWxhk9Kg9a1Hw4fuq
         6imQ0jP4hR/OYKA/bSfI0wrjSrY8XrE1eNRCcN5Y=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628Nc1r032193
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:23:38 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:23:38 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:23:37 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYV006145;
        Thu, 2 Jul 2020 03:23:32 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 19/22] PCI: endpoint: Add EP function driver to provide VHOST interface
Date:   Thu, 2 Jul 2020 13:51:40 +0530
Message-ID: <20200702082143.25259-20-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new endpoint function driver to register VHOST device and
provide interface for the VHOST driver to access virtqueues
created by the remote host (using VIRTIO).

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/pci/endpoint/functions/Kconfig        |   11 +
 drivers/pci/endpoint/functions/Makefile       |    1 +
 .../pci/endpoint/functions/pci-epf-vhost.c    | 1144 +++++++++++++++++
 drivers/vhost/vhost_cfs.c                     |   13 -
 include/linux/vhost.h                         |   14 +
 5 files changed, 1170 insertions(+), 13 deletions(-)
 create mode 100644 drivers/pci/endpoint/functions/pci-epf-vhost.c

diff --git a/drivers/pci/endpoint/functions/Kconfig b/drivers/pci/endpoint/functions/Kconfig
index 55ac7bb2d469..21830576e1f4 100644
--- a/drivers/pci/endpoint/functions/Kconfig
+++ b/drivers/pci/endpoint/functions/Kconfig
@@ -24,3 +24,14 @@ config PCI_EPF_NTB
 	   device tree.
 
 	   If in doubt, say "N" to disable Endpoint NTB driver.
+
+config PCI_EPF_VHOST
+	tristate "PCI Endpoint VHOST driver"
+	depends on PCI_ENDPOINT
+	help
+	   Select this configuration option to enable the VHOST driver
+	   for PCI Endpoint. EPF VHOST driver implements VIRTIO backend
+	   for EPF and uses the VHOST framework to bind any VHOST driver
+	   to the VHOST device created by this driver.
+
+	   If in doubt, say "N" to disable Endpoint VHOST driver.
diff --git a/drivers/pci/endpoint/functions/Makefile b/drivers/pci/endpoint/functions/Makefile
index 96ab932a537a..39d4f9daf63a 100644
--- a/drivers/pci/endpoint/functions/Makefile
+++ b/drivers/pci/endpoint/functions/Makefile
@@ -5,3 +5,4 @@
 
 obj-$(CONFIG_PCI_EPF_TEST)		+= pci-epf-test.o
 obj-$(CONFIG_PCI_EPF_NTB)		+= pci-epf-ntb.o
+obj-$(CONFIG_PCI_EPF_VHOST)		+= pci-epf-vhost.o
diff --git a/drivers/pci/endpoint/functions/pci-epf-vhost.c b/drivers/pci/endpoint/functions/pci-epf-vhost.c
new file mode 100644
index 000000000000..d090e5e88575
--- /dev/null
+++ b/drivers/pci/endpoint/functions/pci-epf-vhost.c
@@ -0,0 +1,1144 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * Endpoint Function Driver to implement VHOST functionality
+ *
+ * Copyright (C) 2020 Texas Instruments
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vhost.h>
+#include <linux/vringh.h>
+
+#include <linux/pci-epc.h>
+#include <linux/pci-epf.h>
+
+#include <uapi/linux/virtio_pci.h>
+
+#define MAX_VQS		8
+
+#define VHOST_QUEUE_STATUS_ENABLE	BIT(0)
+
+#define VHOST_DEVICE_CONFIG_SIZE	1024
+#define EPF_VHOST_MAX_INTERRUPTS	(MAX_VQS + 1)
+
+static struct workqueue_struct *kpcivhost_workqueue;
+
+struct epf_vhost_queue {
+	struct delayed_work cmd_handler;
+	struct vhost_virtqueue *vq;
+	struct epf_vhost *vhost;
+	phys_addr_t phys_addr;
+	void __iomem *addr;
+	unsigned int size;
+};
+
+struct epf_vhost {
+	const struct pci_epc_features *epc_features;
+	struct epf_vhost_queue vqueue[MAX_VQS];
+	struct delayed_work cmd_handler;
+	struct delayed_work cfs_work;
+	struct epf_vhost_reg *reg;
+	struct config_group group;
+	size_t msix_table_offset;
+	struct vhost_dev vdev;
+	struct pci_epf *epf;
+	struct vring vring;
+	int msix_bar;
+};
+
+static inline struct epf_vhost *to_epf_vhost_from_ci(struct config_item *item)
+{
+	return container_of(to_config_group(item), struct epf_vhost, group);
+}
+
+#define to_epf_vhost(v) container_of((v), struct epf_vhost, vdev)
+
+struct epf_vhost_reg_queue {
+	u8 cmd;
+	u8 cmd_status;
+	u16 status;
+	u16 num_buffers;
+	u16 msix_vector;
+	u64 queue_addr;
+} __packed;
+
+enum queue_cmd {
+	QUEUE_CMD_NONE,
+	QUEUE_CMD_ACTIVATE,
+	QUEUE_CMD_DEACTIVATE,
+	QUEUE_CMD_NOTIFY,
+};
+
+enum queue_cmd_status {
+	QUEUE_CMD_STATUS_NONE,
+	QUEUE_CMD_STATUS_OKAY,
+	QUEUE_CMD_STATUS_ERROR,
+};
+
+struct epf_vhost_reg {
+	u64 host_features;
+	u64 guest_features;
+	u16 msix_config;
+	u16 num_queues;
+	u8 device_status;
+	u8 config_generation;
+	u32 isr;
+	u8 cmd;
+	u8 cmd_status;
+	struct epf_vhost_reg_queue vq[MAX_VQS];
+} __packed;
+
+enum host_cmd {
+	HOST_CMD_NONE,
+	HOST_CMD_SET_STATUS,
+	HOST_CMD_FINALIZE_FEATURES,
+	HOST_CMD_RESET,
+};
+
+enum host_cmd_status {
+	HOST_CMD_STATUS_NONE,
+	HOST_CMD_STATUS_OKAY,
+	HOST_CMD_STATUS_ERROR,
+};
+
+static struct pci_epf_header epf_vhost_header = {
+	.vendorid	= PCI_ANY_ID,
+	.deviceid	= PCI_ANY_ID,
+	.baseclass_code	= PCI_CLASS_OTHERS,
+	.interrupt_pin	= PCI_INTERRUPT_INTA,
+};
+
+/* pci_epf_vhost_cmd_handler - Handle commands from remote EPF virtio driver
+ * @work: The work_struct holding the pci_epf_vhost_cmd_handler() function that
+ *   is scheduled
+ *
+ * Handle commands from the remote EPF virtio driver and sends notification to
+ * the vhost client driver. The remote EPF virtio driver sends commands when the
+ * virtio driver status is updated or when the feature negotiation is complete or
+ * if the virtio driver wants to reset the device.
+ */
+static void pci_epf_vhost_cmd_handler(struct work_struct *work)
+{
+	struct epf_vhost_reg *reg;
+	struct epf_vhost *vhost;
+	struct vhost_dev *vdev;
+	struct device *dev;
+	u8 command;
+
+	vhost = container_of(work, struct epf_vhost, cmd_handler.work);
+	vdev = &vhost->vdev;
+	dev = &vhost->epf->dev;
+	reg = vhost->reg;
+
+	command = reg->cmd;
+	if (!command)
+		goto reset_handler;
+
+	reg->cmd = 0;
+
+	switch (command) {
+	case HOST_CMD_SET_STATUS:
+		blocking_notifier_call_chain(&vdev->notifier, NOTIFY_SET_STATUS,
+					     NULL);
+		reg->cmd_status = HOST_CMD_STATUS_OKAY;
+		break;
+	case HOST_CMD_FINALIZE_FEATURES:
+		vdev->features = reg->guest_features;
+		blocking_notifier_call_chain(&vdev->notifier,
+					     NOTIFY_FINALIZE_FEATURES, 0);
+		reg->cmd_status = HOST_CMD_STATUS_OKAY;
+		break;
+	case HOST_CMD_RESET:
+		blocking_notifier_call_chain(&vdev->notifier, NOTIFY_RESET, 0);
+		reg->cmd_status = HOST_CMD_STATUS_OKAY;
+		break;
+	default:
+		dev_err(dev, "UNKNOWN command: %d\n", command);
+		break;
+	}
+
+reset_handler:
+	queue_delayed_work(kpcivhost_workqueue, &vhost->cmd_handler,
+			   msecs_to_jiffies(1));
+}
+
+/* pci_epf_vhost_queue_activate - Map virtqueue local address to remote
+ *   virtqueue address provided by EPF virtio
+ * @vqueue: struct epf_vhost_queue holding the local virtqueue address
+ *
+ * In order for the local system to access the remote virtqueue, the address
+ * reserved in local system should be mapped to the remote virtqueue address.
+ * Map local virtqueue address to remote virtqueue address here.
+ */
+static int pci_epf_vhost_queue_activate(struct epf_vhost_queue *vqueue)
+{
+	struct epf_vhost_reg_queue *reg_queue;
+	struct vhost_virtqueue *vq;
+	struct epf_vhost_reg *reg;
+	phys_addr_t vq_phys_addr;
+	struct epf_vhost *vhost;
+	struct pci_epf *epf;
+	struct pci_epc *epc;
+	struct device *dev;
+	u64 vq_remote_addr;
+	size_t vq_size;
+	u8 func_no;
+	int ret;
+
+	vhost = vqueue->vhost;
+	epf = vhost->epf;
+	dev = &epf->dev;
+	epc = epf->epc;
+	func_no = epf->func_no;
+
+	vq = vqueue->vq;
+	reg = vhost->reg;
+	reg_queue = &reg->vq[vq->index];
+	vq_phys_addr = vqueue->phys_addr;
+	vq_remote_addr = reg_queue->queue_addr;
+	vq_size = vqueue->size;
+
+	ret = pci_epc_map_addr(epc, func_no, vq_phys_addr, vq_remote_addr,
+			       vq_size);
+	if (ret) {
+		dev_err(dev, "Failed to map outbound address\n");
+		return ret;
+	}
+
+	reg_queue->status |= VHOST_QUEUE_STATUS_ENABLE;
+
+	return 0;
+}
+
+/* pci_epf_vhost_queue_deactivate - Unmap virtqueue local address from remote
+ *   virtqueue address
+ * @vqueue: struct epf_vhost_queue holding the local virtqueue address
+ *
+ * Unmap virtqueue local address from remote virtqueue address.
+ */
+static void pci_epf_vhost_queue_deactivate(struct epf_vhost_queue *vqueue)
+{
+	struct epf_vhost_reg_queue *reg_queue;
+	struct vhost_virtqueue *vq;
+	struct epf_vhost_reg *reg;
+	phys_addr_t vq_phys_addr;
+	struct epf_vhost *vhost;
+	struct pci_epf *epf;
+	struct pci_epc *epc;
+	u8 func_no;
+
+	vhost = vqueue->vhost;
+
+	epf = vhost->epf;
+	epc = epf->epc;
+	func_no = epf->func_no;
+	vq_phys_addr = vqueue->phys_addr;
+
+	pci_epc_unmap_addr(epc, func_no, vq_phys_addr);
+
+	reg = vhost->reg;
+	vq = vqueue->vq;
+	reg_queue = &reg->vq[vq->index];
+	reg_queue->status &= ~VHOST_QUEUE_STATUS_ENABLE;
+}
+
+/* pci_epf_vhost_queue_cmd_handler - Handle commands from remote EPF virtio
+ *   driver sent for a particular virtqueue
+ * @work: The work_struct holding the pci_epf_vhost_queue_cmd_handler()
+ *   function that is scheduled
+ *
+ * Handle commands from the remote EPF virtio driver sent for a particular
+ * virtqueue to activate/de-activate a virtqueue or to send notification to
+ * the vhost client driver.
+ */
+static void pci_epf_vhost_queue_cmd_handler(struct work_struct *work)
+{
+	struct epf_vhost_reg_queue *reg_queue;
+	struct epf_vhost_queue *vqueue;
+	struct vhost_virtqueue *vq;
+	struct epf_vhost_reg *reg;
+	struct epf_vhost *vhost;
+	struct device *dev;
+	u8 command;
+	int ret;
+
+	vqueue = container_of(work, struct epf_vhost_queue, cmd_handler.work);
+	vhost = vqueue->vhost;
+	reg = vhost->reg;
+	vq = vqueue->vq;
+	reg_queue = &reg->vq[vq->index];
+	dev = &vhost->epf->dev;
+
+	command = reg_queue->cmd;
+	if (!command)
+		goto reset_handler;
+
+	reg_queue->cmd = 0;
+	vq = vqueue->vq;
+
+	switch (command) {
+	case QUEUE_CMD_ACTIVATE:
+		ret = pci_epf_vhost_queue_activate(vqueue);
+		if (ret)
+			reg_queue->cmd_status = QUEUE_CMD_STATUS_ERROR;
+		else
+			reg_queue->cmd_status = QUEUE_CMD_STATUS_OKAY;
+		break;
+	case QUEUE_CMD_DEACTIVATE:
+		pci_epf_vhost_queue_deactivate(vqueue);
+		reg_queue->cmd_status = QUEUE_CMD_STATUS_OKAY;
+		break;
+	case QUEUE_CMD_NOTIFY:
+		vhost_virtqueue_callback(vqueue->vq);
+		reg_queue->cmd_status = QUEUE_CMD_STATUS_OKAY;
+		break;
+	default:
+		dev_err(dev, "UNKNOWN QUEUE command: %d\n", command);
+		break;
+}
+
+reset_handler:
+	queue_delayed_work(kpcivhost_workqueue, &vqueue->cmd_handler,
+			   msecs_to_jiffies(1));
+}
+
+/* pci_epf_vhost_write - Write data to buffer provided by remote virtio driver
+ * @vdev: Vhost device that communicates with remove virtio device
+ * @dst: Buffer address present in the memory of the remote system to which
+ *   data should be written
+ * @src: Buffer address in the local device provided by the vhost client driver
+ * @len: Length of the data to be copied from @src to @dst
+ *
+ * Write data to buffer provided by remote virtio driver from buffer provided
+ * by vhost client driver.
+ */
+static int pci_epf_vhost_write(struct vhost_dev *vdev, u64 dst, void *src, int len)
+{
+	const struct pci_epc_features *epc_features;
+	struct epf_vhost *vhost;
+	phys_addr_t phys_addr;
+	struct pci_epf *epf;
+	struct pci_epc *epc;
+	void __iomem *addr;
+	struct device *dev;
+	int offset, ret;
+	u64 dst_addr;
+	size_t align;
+	u8 func_no;
+
+	vhost = to_epf_vhost(vdev);
+	epf = vhost->epf;
+	dev = &epf->dev;
+	epc = epf->epc;
+	func_no = epf->func_no;
+	epc_features = vhost->epc_features;
+	align = epc_features->align;
+
+	offset = dst & (align - 1);
+	dst_addr = dst & ~(align - 1);
+
+	addr = pci_epc_mem_alloc_addr(epc, &phys_addr, len);
+	if (!addr) {
+		dev_err(dev, "Failed to allocate outbound address\n");
+		return -ENOMEM;
+	}
+
+	ret = pci_epc_map_addr(epc, func_no, phys_addr, dst_addr, len);
+	if (ret) {
+		dev_err(dev, "Failed to map outbound address\n");
+		goto ret;
+	}
+
+	memcpy_toio(addr + offset, src, len);
+
+	pci_epc_unmap_addr(epc, func_no, phys_addr);
+
+ret:
+	pci_epc_mem_free_addr(epc, phys_addr, addr, len);
+
+	return ret;
+}
+
+/* ntb_vhost_read - Read data from buffer provided by remote virtio driver
+ * @vdev: Vhost device that communicates with remove virtio device
+ * @dst: Buffer address in the local device provided by the vhost client driver
+ * @src: Buffer address in the remote device provided by the remote virtio
+ *   driver
+ * @len: Length of the data to be copied from @src to @dst
+ *
+ * Read data from buffer provided by remote virtio driver to address provided
+ * by vhost client driver.
+ */
+static int pci_epf_vhost_read(struct vhost_dev *vdev, void *dst, u64 src, int len)
+{
+	const struct pci_epc_features *epc_features;
+	struct epf_vhost *vhost;
+	phys_addr_t phys_addr;
+	struct pci_epf *epf;
+	struct pci_epc *epc;
+	void __iomem *addr;
+	struct device *dev;
+	int offset, ret;
+	u64 src_addr;
+	size_t align;
+	u8 func_no;
+
+	vhost = to_epf_vhost(vdev);
+	epf = vhost->epf;
+	dev = &epf->dev;
+	epc = epf->epc;
+	func_no = epf->func_no;
+	epc_features = vhost->epc_features;
+	align = epc_features->align;
+
+	offset = src & (align - 1);
+	src_addr = src & ~(align - 1);
+
+	addr = pci_epc_mem_alloc_addr(epc, &phys_addr, len);
+	if (!addr) {
+		dev_err(dev, "Failed to allocate outbound address\n");
+		return -ENOMEM;
+	}
+
+	ret = pci_epc_map_addr(epc, func_no, phys_addr, src_addr, len);
+	if (ret) {
+		dev_err(dev, "Failed to map outbound address\n");
+		goto ret;
+	}
+
+	memcpy_fromio(dst, addr + offset, len);
+
+	pci_epc_unmap_addr(epc, func_no, phys_addr);
+
+ret:
+	pci_epc_mem_free_addr(epc, phys_addr, addr, len);
+
+	return ret;
+}
+
+/* pci_epf_vhost_notify - Send notification to the remote virtqueue
+ * @vq: The local vhost virtqueue corresponding to the remote virtio virtqueue
+ *
+ * Use endpoint core framework to raise MSI-X interrupt to notify the remote
+ * virtqueue.
+ */
+static void  pci_epf_vhost_notify(struct vhost_virtqueue *vq)
+{
+	struct epf_vhost_reg_queue *reg_queue;
+	struct epf_vhost_reg *reg;
+	struct epf_vhost *vhost;
+	struct vhost_dev *vdev;
+	struct pci_epf *epf;
+	struct pci_epc *epc;
+	u8 func_no;
+
+	vdev = vq->dev;
+	vhost = to_epf_vhost(vdev);
+	epf = vhost->epf;
+	func_no = epf->func_no;
+	epc = epf->epc;
+	reg = vhost->reg;
+	reg_queue = &reg->vq[vq->index];
+
+	pci_epc_raise_irq(epc, func_no, PCI_EPC_IRQ_MSIX,
+			  reg_queue->msix_vector + 1);
+}
+
+/* pci_epf_vhost_del_vqs - Delete all the vqs associated with the vhost device
+ * @vdev: Vhost device that communicates with remove virtio device
+ *
+ * Delete all the vqs associated with the vhost device and free the memory
+ * address reserved for accessing the remote virtqueue.
+ */
+static void pci_epf_vhost_del_vqs(struct vhost_dev *vdev)
+{
+	struct epf_vhost_queue *vqueue;
+	struct vhost_virtqueue *vq;
+	phys_addr_t vq_phys_addr;
+	struct epf_vhost *vhost;
+	void __iomem *vq_addr;
+	unsigned int vq_size;
+	struct pci_epf *epf;
+	struct pci_epc *epc;
+	int i;
+
+	vhost = to_epf_vhost(vdev);
+	epf = vhost->epf;
+	epc = epf->epc;
+
+	for (i = 0; i < vdev->nvqs; i++) {
+		vq = vdev->vqs[i];
+		if (IS_ERR_OR_NULL(vq))
+			continue;
+
+		vqueue = &vhost->vqueue[i];
+		vq_phys_addr = vqueue->phys_addr;
+		vq_addr = vqueue->addr;
+		vq_size = vqueue->size;
+		pci_epc_mem_free_addr(epc, vq_phys_addr, vq_addr, vq_size);
+		kfree(vq);
+	}
+}
+
+/* pci_epf_vhost_create_vq - Create a new vhost virtqueue
+ * @vdev: Vhost device that communicates with remove virtio device
+ * @index: Index of the vhost virtqueue
+ * @num_bufs: The number of buffers that should be supported by the vhost
+ *   virtqueue (number of descriptors in the vhost virtqueue)
+ * @callback: Callback function associated with the virtqueue
+ *
+ * Create a new vhost virtqueue which can be used by the vhost client driver
+ * to access the remote virtio. This sets up the local address of the vhost
+ * virtqueue but shouldn't be accessed until the virtio sets the status to
+ * VIRTIO_CONFIG_S_DRIVER_OK.
+ */
+static struct vhost_virtqueue *
+pci_epf_vhost_create_vq(struct vhost_dev *vdev, int index,
+			unsigned int num_bufs,
+			void (*callback)(struct vhost_virtqueue *))
+{
+	struct epf_vhost_reg_queue *reg_queue;
+	struct epf_vhost_queue *vqueue;
+	struct epf_vhost_reg *reg;
+	struct vhost_virtqueue *vq;
+	phys_addr_t vq_phys_addr;
+	struct epf_vhost *vhost;
+	struct vringh *vringh;
+	void __iomem *vq_addr;
+	unsigned int vq_size;
+	struct vring *vring;
+	struct pci_epf *epf;
+	struct pci_epc *epc;
+	struct device *dev;
+	int ret;
+
+	vhost = to_epf_vhost(vdev);
+	vqueue = &vhost->vqueue[index];
+	reg = vhost->reg;
+	reg_queue = &reg->vq[index];
+	epf = vhost->epf;
+	epc = epf->epc;
+	dev = &epf->dev;
+
+	vq = kzalloc(sizeof(*vq), GFP_KERNEL);
+	if (!vq)
+		return ERR_PTR(-ENOMEM);
+
+	vq->dev = vdev;
+	vq->callback = callback;
+	vq->num = num_bufs;
+	vq->index = index;
+	vq->notify = pci_epf_vhost_notify;
+	vq->type = VHOST_TYPE_MMIO;
+
+	vqueue->vq = vq;
+	vqueue->vhost = vhost;
+
+	vringh = &vq->vringh;
+	vring = &vringh->vring;
+	reg_queue->num_buffers = num_bufs;
+
+	vq_size = vring_size(num_bufs, VIRTIO_PCI_VRING_ALIGN);
+	vq_addr = pci_epc_mem_alloc_addr(epc, &vq_phys_addr, vq_size);
+	if (!vq_addr) {
+		dev_err(dev, "Failed to allocate virtqueue address\n");
+		ret = -ENOMEM;
+		goto err_mem_alloc_addr;
+	}
+
+	vring_init(vring, num_bufs, vq_addr, VIRTIO_PCI_VRING_ALIGN);
+	ret = vringh_init_mmio(vringh, 0, num_bufs, false, vring->desc,
+			       vring->avail, vring->used);
+	if (ret) {
+		dev_err(dev, "Failed to init vringh\n");
+		goto err_init_mmio;
+	}
+
+	vqueue->phys_addr = vq_phys_addr;
+	vqueue->addr = vq_addr;
+	vqueue->size = vq_size;
+
+	INIT_DELAYED_WORK(&vqueue->cmd_handler, pci_epf_vhost_queue_cmd_handler);
+	queue_work(kpcivhost_workqueue, &vqueue->cmd_handler.work);
+
+	return vq;
+
+err_init_mmio:
+	pci_epc_mem_free_addr(epc, vq_phys_addr, vq_addr, vq_size);
+
+err_mem_alloc_addr:
+	kfree(vq);
+
+	return ERR_PTR(ret);
+}
+
+/* pci_epf_vhost_create_vqs - Create vhost virtqueues for vhost device
+ * @vdev: Vhost device that communicates with the remote virtio device
+ * @nvqs: Number of vhost virtqueues to be created
+ * @num_bufs: The number of buffers that should be supported by the vhost
+ *   virtqueue (number of descriptors in the vhost virtqueue)
+ * @vqs: Pointers to all the created vhost virtqueues
+ * @callback: Callback function associated with the virtqueue
+ * @names: Names associated with each virtqueue
+ *
+ * Create vhost virtqueues for vhost device. This acts as a wrapper to
+ * pci_epf_vhost_create_vq() which creates individual vhost virtqueue.
+ */
+static int pci_epf_vhost_create_vqs(struct vhost_dev *vdev, unsigned int nvqs,
+				    unsigned int num_bufs,
+				    struct vhost_virtqueue *vqs[],
+				    vhost_vq_callback_t *callbacks[],
+				    const char * const names[])
+{
+	struct epf_vhost *vhost;
+	struct pci_epf *epf;
+	struct device *dev;
+	int ret, i;
+
+	vhost = to_epf_vhost(vdev);
+	epf = vhost->epf;
+	dev = &epf->dev;
+
+	for (i = 0; i < nvqs; i++) {
+		vqs[i] = pci_epf_vhost_create_vq(vdev, i, num_bufs,
+						 callbacks[i]);
+		if (IS_ERR_OR_NULL(vqs[i])) {
+			ret = PTR_ERR(vqs[i]);
+			dev_err(dev, "Failed to create virtqueue\n");
+			goto err;
+		}
+	}
+
+	vdev->nvqs = nvqs;
+	vdev->vqs = vqs;
+
+	return 0;
+
+err:
+	pci_epf_vhost_del_vqs(vdev);
+	return ret;
+}
+
+/* pci_epf_vhost_set_features - vhost_config_ops to set vhost device features
+ * @vdev: Vhost device that communicates with the remote virtio device
+ * @features: Features supported by the vhost client driver
+ *
+ * vhost_config_ops invoked by the vhost client driver to set vhost device
+ * features.
+ */
+static int pci_epf_vhost_set_features(struct vhost_dev *vdev, u64 features)
+{
+	struct epf_vhost_reg *reg;
+	struct epf_vhost *vhost;
+
+	vhost = to_epf_vhost(vdev);
+	reg = vhost->reg;
+
+	reg->host_features = features;
+
+	return 0;
+}
+
+/* ntb_vhost_set_status - vhost_config_ops to set vhost device status
+ * @vdev: Vhost device that communicates with the remote virtio device
+ * @status: Vhost device status configured by vhost client driver
+ *
+ * vhost_config_ops invoked by the vhost client driver to set vhost device
+ * status.
+ */
+static int pci_epf_vhost_set_status(struct vhost_dev *vdev, u8 status)
+{
+	struct epf_vhost_reg *reg;
+	struct epf_vhost *vhost;
+
+	vhost = to_epf_vhost(vdev);
+	reg = vhost->reg;
+
+	reg->device_status = status;
+
+	return 0;
+}
+
+/* ntb_vhost_get_status - vhost_config_ops to get vhost device status
+ * @vdev: Vhost device that communicates with the remote virtio device
+ *
+ * vhost_config_ops invoked by the vhost client driver to get vhost device
+ * status set by the remote virtio driver.
+ */
+static u8 pci_epf_vhost_get_status(struct vhost_dev *vdev)
+{
+	struct epf_vhost_reg *reg;
+	struct epf_vhost *vhost;
+
+	vhost = to_epf_vhost(vdev);
+	reg = vhost->reg;
+
+	return reg->device_status;
+}
+
+static const struct vhost_config_ops pci_epf_vhost_ops = {
+	.create_vqs	= pci_epf_vhost_create_vqs,
+	.del_vqs	= pci_epf_vhost_del_vqs,
+	.write		= pci_epf_vhost_write,
+	.read		= pci_epf_vhost_read,
+	.set_features	= pci_epf_vhost_set_features,
+	.set_status	= pci_epf_vhost_set_status,
+	.get_status	= pci_epf_vhost_get_status,
+};
+
+/* pci_epf_vhost_write_header - Write to PCIe standard configuration space
+ *   header
+ * @vhost: EPF vhost containing the vhost device that communicates with the
+ *   remote virtio device
+ *
+ * Invokes endpoint core framework's pci_epc_write_header() to write to the
+ * standard configuration space header.
+ */
+static int pci_epf_vhost_write_header(struct epf_vhost *vhost)
+{
+	struct pci_epf_header *header;
+	struct vhost_dev *vdev;
+	struct pci_epc *epc;
+	struct pci_epf *epf;
+	struct device *dev;
+	u8 func_no;
+	int ret;
+
+	vdev = &vhost->vdev;
+	epf = vhost->epf;
+	dev = &epf->dev;
+	epc = epf->epc;
+	func_no = epf->func_no;
+	header = epf->header;
+
+	ret = pci_epc_write_header(epc, func_no, header);
+	if (ret) {
+		dev_err(dev, "Configuration header write failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+/* pci_epf_vhost_release_dev - Callback function to free device
+ * @dev: Device in vhost_dev that has to be freed
+ *
+ * Callback function from device core invoked to free the device after
+ * all references have been removed. This frees the allocated memory for
+ * struct ntb_vhost.
+ */
+static void pci_epf_vhost_release_dev(struct device *dev)
+{
+	struct epf_vhost *vhost;
+	struct vhost_dev *vdev;
+
+	vdev = to_vhost_dev(dev);
+	vhost = to_epf_vhost(vdev);
+
+	kfree(vhost);
+}
+
+/* pci_epf_vhost_register - Register a vhost device
+ * @vhost: EPF vhost containing the vhost device that communicates with the
+ *   remote virtio device
+ *
+ * Invoked vhost_register_device() to register a vhost device after populating
+ * the deviceID and vendorID of the vhost device.
+ */
+static int pci_epf_vhost_register(struct epf_vhost *vhost)
+{
+	struct vhost_dev *vdev;
+	struct pci_epf *epf;
+	struct device *dev;
+	int ret;
+
+	vdev = &vhost->vdev;
+	epf = vhost->epf;
+	dev = &epf->dev;
+
+	vdev->dev.parent = dev;
+	vdev->dev.release = pci_epf_vhost_release_dev;
+	vdev->id.device = vhost->epf->header->subsys_id;
+	vdev->id.vendor = vhost->epf->header->subsys_vendor_id;
+	vdev->ops = &pci_epf_vhost_ops;
+
+	ret = vhost_register_device(vdev);
+	if (ret) {
+		dev_err(dev, "Failed to register vhost device\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+/* pci_epf_vhost_configure_bar - Configure BAR of EPF device
+ * @vhost: EPF vhost containing the vhost device that communicates with the
+ *   remote virtio device
+ *
+ * Allocate memory for the standard virtio configuration space and map it to
+ * the first free BAR.
+ */
+static int pci_epf_vhost_configure_bar(struct epf_vhost *vhost)
+{
+	size_t msix_table_size = 0, pba_size = 0, align, bar_size;
+	const struct pci_epc_features *epc_features;
+	struct pci_epf_bar *epf_bar;
+	struct vhost_dev *vdev;
+	struct pci_epf *epf;
+	struct pci_epc *epc;
+	struct device *dev;
+	bool msix_capable;
+	u32 config_size;
+	int barno, ret;
+	void *base;
+	u64 size;
+
+	vdev = &vhost->vdev;
+	epf = vhost->epf;
+	dev = &epf->dev;
+	epc = epf->epc;
+
+	epc_features = vhost->epc_features;
+	barno = pci_epc_get_first_free_bar(epc_features);
+	if (barno < 0) {
+		dev_err(dev, "Failed to get free BAR\n");
+		return barno;
+	}
+
+	size = epc_features->bar_fixed_size[barno];
+	align = epc_features->align;
+	/* Check if epc_features is populated incorrectly */
+	if ((!IS_ALIGNED(size, align)))
+		return -EINVAL;
+
+	config_size = sizeof(struct epf_vhost_reg) + VHOST_DEVICE_CONFIG_SIZE;
+	config_size = ALIGN(config_size, 8);
+
+	msix_capable = epc_features->msix_capable;
+	if (msix_capable) {
+		msix_table_size = PCI_MSIX_ENTRY_SIZE * epf->msix_interrupts;
+		vhost->msix_table_offset = config_size;
+		vhost->msix_bar = barno;
+		/* Align to QWORD or 8 Bytes */
+		pba_size = ALIGN(DIV_ROUND_UP(epf->msix_interrupts, 8), 8);
+	}
+
+	bar_size = config_size + msix_table_size + pba_size;
+
+	if (!align)
+		bar_size = roundup_pow_of_two(bar_size);
+	else
+		bar_size = ALIGN(bar_size, align);
+
+	if (!size)
+		size = bar_size;
+	else if (size < bar_size)
+		return -EINVAL;
+
+	base = pci_epf_alloc_space(epf, size, barno, align,
+				   PRIMARY_INTERFACE);
+	if (!base) {
+		dev_err(dev, "Failed to allocate configuration region\n");
+		return -ENOMEM;
+	}
+
+	epf_bar = &epf->bar[barno];
+	ret = pci_epc_set_bar(epc, epf->func_no, epf_bar);
+	if (ret) {
+		dev_err(dev, "Failed to set BAR: %d\n", barno);
+		goto err_set_bar;
+	}
+
+	vhost->reg = base;
+
+	return 0;
+
+err_set_bar:
+	pci_epf_free_space(epf, base, barno, PRIMARY_INTERFACE);
+
+	return ret;
+}
+
+/* pci_epf_vhost_configure_interrupts - Configure MSI/MSI-X capability of EPF
+ *   device
+ * @vhost: EPF vhost containing the vhost device that communicates with the
+ *   remote virtio device
+ *
+ * Configure MSI/MSI-X capability of EPF device. This will be used to interrupt
+ * the vhost virtqueue.
+ */
+static int pci_epf_vhost_configure_interrupts(struct epf_vhost *vhost)
+{
+	const struct pci_epc_features *epc_features;
+	struct pci_epf *epf;
+	struct pci_epc *epc;
+	struct device *dev;
+	int ret;
+
+	epc_features = vhost->epc_features;
+	epf = vhost->epf;
+	dev = &epf->dev;
+	epc = epf->epc;
+
+	if (epc_features->msi_capable) {
+		ret = pci_epc_set_msi(epc, epf->func_no,
+				      EPF_VHOST_MAX_INTERRUPTS);
+		if (ret) {
+			dev_err(dev, "MSI configuration failed\n");
+			return ret;
+		}
+	}
+
+	if (epc_features->msix_capable) {
+		ret = pci_epc_set_msix(epc, epf->func_no,
+				       EPF_VHOST_MAX_INTERRUPTS,
+				       vhost->msix_bar,
+				       vhost->msix_table_offset);
+		if (ret) {
+			dev_err(dev, "MSI-X configuration failed\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/* pci_epf_vhost_cfs_link - Link vhost client driver with EPF vhost to get
+ *   the deviceID and driverID to be writtent to the PCIe config space
+ * @epf_vhost_item: Config item representing the EPF vhost created by this
+ *   driver
+ * @epf: Endpoint function device that is bound to the endpoint controller
+ *
+ * This is invoked when the user creates a softlink between the vhost client
+ * to the EPF vhost. This gets the deviceID and vendorID data from the vhost
+ * client and copies it to the subys_id and subsys_vendor_id of the EPF
+ * header. This will be used by the remote virtio to bind a virtio client
+ * driver.
+ */
+static int pci_epf_vhost_cfs_link(struct config_item *epf_vhost_item,
+				  struct config_item *driver_item)
+{
+	struct vhost_driver_item *vdriver_item;
+	struct epf_vhost *vhost;
+
+	vdriver_item = to_vhost_driver_item(driver_item);
+	vhost = to_epf_vhost_from_ci(epf_vhost_item);
+
+	vhost->epf->header->subsys_id = vdriver_item->device;
+	vhost->epf->header->subsys_vendor_id = vdriver_item->vendor;
+
+	return 0;
+}
+
+static struct configfs_item_operations pci_epf_vhost_cfs_ops = {
+	.allow_link	= pci_epf_vhost_cfs_link,
+};
+
+static const struct config_item_type pci_epf_vhost_cfs_type = {
+	.ct_item_ops	= &pci_epf_vhost_cfs_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+/* pci_epf_vhost_cfs_work - Delayed work function to create configfs directory
+ *   to perform EPF vhost specific initializations
+ * @work: The work_struct holding the pci_epf_vhost_cfs_work() function that
+ *   is scheduled
+ *
+ * This is a delayed work function to create configfs directory to perform EPF
+ * vhost specific initializations. This configfs directory will be a
+ * sub-directory to the directory created by the user to create pci_epf device.
+ */
+static void pci_epf_vhost_cfs_work(struct work_struct *work)
+{
+	struct epf_vhost *vhost = container_of(work, struct epf_vhost,
+					       cfs_work.work);
+	struct pci_epf *epf = vhost->epf;
+	struct device *dev = &epf->dev;
+	struct config_group *group;
+	struct vhost_dev *vdev;
+	int ret;
+
+	if (!epf->group) {
+		queue_delayed_work(kpcivhost_workqueue, &vhost->cfs_work,
+				   msecs_to_jiffies(50));
+		return;
+	}
+
+	vdev = &vhost->vdev;
+	group = &vhost->group;
+	config_group_init_type_name(group, dev_name(dev), &pci_epf_vhost_cfs_type);
+	ret = configfs_register_group(epf->group, group);
+	if (ret) {
+		dev_err(dev, "Failed to register configfs group %s\n", dev_name(dev));
+		return;
+	}
+}
+
+/* pci_epf_vhost_probe - Initialize struct epf_vhost when a new EPF device is
+ *   created
+ * @epf: Endpoint function device that is bound to this driver
+ *
+ * Probe function to initialize struct epf_vhost when a new EPF device is
+ * created.
+ */
+static int pci_epf_vhost_probe(struct pci_epf *epf)
+{
+	struct epf_vhost *vhost;
+
+	vhost = kzalloc(sizeof(*vhost), GFP_KERNEL);
+	if (!vhost)
+		return -ENOMEM;
+
+	epf->header = &epf_vhost_header;
+	vhost->epf = epf;
+
+	epf_set_drvdata(epf, vhost);
+	INIT_DELAYED_WORK(&vhost->cmd_handler, pci_epf_vhost_cmd_handler);
+	INIT_DELAYED_WORK(&vhost->cfs_work, pci_epf_vhost_cfs_work);
+	queue_delayed_work(kpcivhost_workqueue, &vhost->cfs_work,
+			   msecs_to_jiffies(50));
+
+	return 0;
+}
+
+/* pci_epf_vhost_remove - Free the initializations performed by
+ *   pci_epf_vhost_probe()
+ * @epf: Endpoint function device that is bound to this driver
+ *
+ * Free the initializations performed by pci_epf_vhost_probe().
+ */
+static int pci_epf_vhost_remove(struct pci_epf *epf)
+{
+	struct epf_vhost *vhost;
+
+	vhost = epf_get_drvdata(epf);
+	cancel_delayed_work_sync(&vhost->cfs_work);
+
+	return 0;
+}
+
+/* pci_epf_vhost_bind - Bind callback to initialize the PCIe EP controller
+ * @epf: Endpoint function device that is bound to the endpoint controller
+ *
+ * pci_epf_vhost_bind() is invoked when an endpoint controller is bound to
+ * endpoint function. This function initializes the endpoint controller
+ * with vhost endpoint function specific data.
+ */
+static int pci_epf_vhost_bind(struct pci_epf *epf)
+{
+	const struct pci_epc_features *epc_features;
+	struct epf_vhost *vhost;
+	struct pci_epc *epc;
+	struct device *dev;
+	int ret;
+
+	vhost = epf_get_drvdata(epf);
+	dev = &epf->dev;
+	epc = epf->epc;
+
+	epc_features = pci_epc_get_features(epc, epf->func_no);
+	if (!epc_features) {
+		dev_err(dev, "Fail to get EPC features\n");
+		return -EINVAL;
+	}
+	vhost->epc_features = epc_features;
+
+	ret = pci_epf_vhost_write_header(vhost);
+	if (ret) {
+		dev_err(dev, "Failed to bind VHOST config header\n");
+		return ret;
+	}
+
+	ret = pci_epf_vhost_configure_bar(vhost);
+	if (ret) {
+		dev_err(dev, "Failed to configure BAR\n");
+		return ret;
+	}
+
+	ret = pci_epf_vhost_configure_interrupts(vhost);
+	if (ret) {
+		dev_err(dev, "Failed to configure BAR\n");
+		return ret;
+	}
+
+	ret = pci_epf_vhost_register(vhost);
+	if (ret) {
+		dev_err(dev, "Failed to bind VHOST config header\n");
+		return ret;
+	}
+
+	queue_work(kpcivhost_workqueue, &vhost->cmd_handler.work);
+
+	return ret;
+}
+
+/* pci_epf_vhost_unbind - Inbind callback to cleanup the PCIe EP controller
+ * @epf: Endpoint function device that is bound to the endpoint controller
+ *
+ * pci_epf_vhost_unbind() is invoked when the binding between endpoint
+ * controller is removed from endpoint function. This will unregister vhost
+ * device and cancel pending cmd_handler work.
+ */
+static void pci_epf_vhost_unbind(struct pci_epf *epf)
+{
+	struct epf_vhost *vhost;
+	struct vhost_dev *vdev;
+
+	vhost = epf_get_drvdata(epf);
+	vdev = &vhost->vdev;
+
+	cancel_delayed_work_sync(&vhost->cmd_handler);
+	if (device_is_registered(&vdev->dev))
+		vhost_unregister_device(vdev);
+}
+
+static struct pci_epf_ops epf_ops = {
+	.bind	= pci_epf_vhost_bind,
+	.unbind	= pci_epf_vhost_unbind,
+};
+
+static const struct pci_epf_device_id pci_epf_vhost_ids[] = {
+	{
+		.name = "pci-epf-vhost",
+	},
+	{ },
+};
+
+static struct pci_epf_driver epf_vhost_driver = {
+	.driver.name	= "pci_epf_vhost",
+	.probe		= pci_epf_vhost_probe,
+	.remove		= pci_epf_vhost_remove,
+	.id_table	= pci_epf_vhost_ids,
+	.ops		= &epf_ops,
+	.owner		= THIS_MODULE,
+};
+
+static int __init pci_epf_vhost_init(void)
+{
+	int ret;
+
+	kpcivhost_workqueue = alloc_workqueue("kpcivhost", WQ_MEM_RECLAIM |
+					      WQ_HIGHPRI, 0);
+	ret = pci_epf_register_driver(&epf_vhost_driver);
+	if (ret) {
+		pr_err("Failed to register pci epf vhost driver --> %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+module_init(pci_epf_vhost_init);
+
+static void __exit pci_epf_vhost_exit(void)
+{
+	pci_epf_unregister_driver(&epf_vhost_driver);
+}
+module_exit(pci_epf_vhost_exit);
+
+MODULE_DESCRIPTION("PCI EPF VHOST DRIVER");
+MODULE_AUTHOR("Kishon Vijay Abraham I <kishon@ti.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/vhost/vhost_cfs.c b/drivers/vhost/vhost_cfs.c
index ae46e71968f1..ab0393289200 100644
--- a/drivers/vhost/vhost_cfs.c
+++ b/drivers/vhost/vhost_cfs.c
@@ -18,12 +18,6 @@ static struct config_group *vhost_driver_group;
 /* VHOST device like PCIe EP, NTB etc., */
 static struct config_group *vhost_device_group;
 
-struct vhost_driver_item {
-	struct config_group group;
-	u32 vendor;
-	u32 device;
-};
-
 struct vhost_driver_group {
 	struct config_group group;
 };
@@ -33,13 +27,6 @@ struct vhost_device_item {
 	struct vhost_dev *vdev;
 };
 
-static inline
-struct vhost_driver_item *to_vhost_driver_item(struct config_item *item)
-{
-	return container_of(to_config_group(item), struct vhost_driver_item,
-			    group);
-}
-
 static inline
 struct vhost_device_item *to_vhost_device_item(struct config_item *item)
 {
diff --git a/include/linux/vhost.h b/include/linux/vhost.h
index be9341ffd266..640650311310 100644
--- a/include/linux/vhost.h
+++ b/include/linux/vhost.h
@@ -74,6 +74,7 @@ struct vhost_virtqueue {
 	struct vhost_dev *dev;
 	enum vhost_type type;
 	struct vringh vringh;
+	int index;
 	void (*callback)(struct vhost_virtqueue *vq);
 	void (*notify)(struct vhost_virtqueue *vq);
 
@@ -148,6 +149,12 @@ struct vhost_msg_node {
   struct list_head node;
 };
 
+struct vhost_driver_item {
+	struct config_group group;
+	u32 vendor;
+	u32 device;
+};
+
 enum vhost_notify_event {
 	NOTIFY_SET_STATUS,
 	NOTIFY_FINALIZE_FEATURES,
@@ -230,6 +237,13 @@ static inline void *vhost_get_drvdata(struct vhost_dev *vdev)
 	return dev_get_drvdata(&vdev->dev);
 }
 
+static inline
+struct vhost_driver_item *to_vhost_driver_item(struct config_item *item)
+{
+	return container_of(to_config_group(item), struct vhost_driver_item,
+			    group);
+}
+
 int vhost_register_driver(struct vhost_driver *driver);
 void vhost_unregister_driver(struct vhost_driver *driver);
 int vhost_register_device(struct vhost_dev *vdev);
-- 
2.17.1

