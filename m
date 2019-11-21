Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 771A210533E
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 14:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfKUNhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 08:37:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:27188 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbfKUNg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 08:36:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 05:36:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="238178535"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by fmsmga002.fm.intel.com with ESMTP; 21 Nov 2019 05:36:55 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com, Zhu Lingshan <lingshan.zhu@intel.com>,
        Xiao Wang <xiao.w.wang@intel.com>
Subject: [RFC V1 1/2] vhost: IFC VF initialization functions
Date:   Thu, 21 Nov 2019 21:34:36 +0800
Message-Id: <1574343277-8835-2-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574343277-8835-1-git-send-email-lingshan.zhu@intel.com>
References: <1574343277-8835-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit intends to add initialization functions for
IFC VF, including: probe / remove / mdev operations and
sysfs interfaces.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Signed-off-by: Xiao Wang <xiao.w.wang@intel.com>
Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
---
 drivers/vhost/Kconfig            |  12 ++
 drivers/vhost/Makefile           |   2 +
 drivers/vhost/ifcvf/Makefile     |   2 +
 drivers/vhost/ifcvf/ifcvf_base.c | 129 ++++++++++++++++
 drivers/vhost/ifcvf/ifcvf_base.h | 123 +++++++++++++++
 drivers/vhost/ifcvf/ifcvf_main.c | 315 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 583 insertions(+)
 create mode 100644 drivers/vhost/ifcvf/Makefile
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
 create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index a4cf67a..7fa2a45 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -46,6 +46,18 @@ config VHOST_MDEV
 	To compile this driver as a module, choose M here: the module will
 	be called vhost_mdev.
 
+config IFCVF
+	tristate "Intel IFC VF VDPA driver"
+	depends on MDEV_VIRTIO
+	select VHOST
+	default n
+	---help---
+	This kernel module can drive Intel IFC VF NIC to offload
+	vhost dataplane traffic to hardware.
+
+	To compile this driver as a module, choose M here: the module will
+	be called ifcvf.
+
 config VHOST
 	tristate
 	---help---
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index ad9c0f8..4cc484d 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -14,3 +14,5 @@ obj-$(CONFIG_VHOST_MDEV) += vhost_mdev.o
 vhost_mdev-y := mdev.o
 
 obj-$(CONFIG_VHOST)	+= vhost.o
+
+obj-$(CONFIG_IFCVF)	+= ifcvf/
diff --git a/drivers/vhost/ifcvf/Makefile b/drivers/vhost/ifcvf/Makefile
new file mode 100644
index 0000000..aa12148
--- /dev/null
+++ b/drivers/vhost/ifcvf/Makefile
@@ -0,0 +1,2 @@
+obj-m += ifcvf.o
+ifcvf-$(CONFIG_IFCVF)+= ifcvf_main.o ifcvf_base.o
diff --git a/drivers/vhost/ifcvf/ifcvf_base.c b/drivers/vhost/ifcvf/ifcvf_base.c
new file mode 100644
index 0000000..ec5985f
--- /dev/null
+++ b/drivers/vhost/ifcvf/ifcvf_base.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2019 Intel Corporation.
+ */
+
+#include "ifcvf_base.h"
+
+struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
+{
+	return container_of(hw, struct ifcvf_adapter, vf);
+}
+
+static void *get_cap_addr(struct ifcvf_hw *hw, struct virtio_pci_cap *cap)
+{
+	struct ifcvf_adapter *ifcvf;
+	u32 length, offset;
+	u8 bar;
+
+	length = le32_to_cpu(cap->length);
+	offset = le32_to_cpu(cap->offset);
+	bar = cap->bar;
+
+	ifcvf = vf_to_adapter(hw);
+	if (bar >= IFCVF_PCI_MAX_RESOURCE) {
+		IFCVF_DBG(ifcvf->dev,
+			  "Invalid bar number %u to get capabilities\n", bar);
+		return NULL;
+	}
+
+	if (offset + length > hw->mem_resource[bar].len) {
+		IFCVF_DBG(ifcvf->dev,
+			  "offset(%u) + len(%u) overflows bar%u to get capabilities\n",
+			  offset, length, bar);
+		return NULL;
+	}
+
+	return hw->mem_resource[bar].addr + offset;
+}
+
+int ifcvf_read_config_range(struct pci_dev *dev,
+			    uint32_t *val, int size, int where)
+{
+	int ret, i;
+
+	for (i = 0; i < size; i += 4) {
+		ret = pci_read_config_dword(dev, where + i, val + i / 4);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev)
+{
+	struct virtio_pci_cap cap;
+	u16 notify_off;
+	int ret;
+	u8 pos;
+	u32 i;
+
+	ret = pci_read_config_byte(dev, PCI_CAPABILITY_LIST, &pos);
+	if (ret < 0) {
+		IFCVF_ERR(&dev->dev, "Failed to read PCI capability list\n");
+		return -EIO;
+	}
+
+	while (pos) {
+		ret = ifcvf_read_config_range(dev, (u32 *)&cap,
+					      sizeof(cap), pos);
+		if (ret < 0) {
+			IFCVF_ERR(&dev->dev,
+				  "Failed to get PCI capability at %x\n", pos);
+			break;
+		}
+
+		if (cap.cap_vndr != PCI_CAP_ID_VNDR)
+			goto next;
+
+		switch (cap.cfg_type) {
+		case VIRTIO_PCI_CAP_COMMON_CFG:
+			hw->common_cfg = get_cap_addr(hw, &cap);
+			IFCVF_DBG(&dev->dev, "hw->common_cfg = %p\n",
+				  hw->common_cfg);
+			break;
+		case VIRTIO_PCI_CAP_NOTIFY_CFG:
+			pci_read_config_dword(dev, pos + sizeof(cap),
+					      &hw->notify_off_multiplier);
+			hw->notify_bar = cap.bar;
+			hw->notify_base = get_cap_addr(hw, &cap);
+			IFCVF_DBG(&dev->dev, "hw->notify_base = %p\n",
+				  hw->notify_base);
+			break;
+		case VIRTIO_PCI_CAP_ISR_CFG:
+			hw->isr = get_cap_addr(hw, &cap);
+			IFCVF_DBG(&dev->dev, "hw->isr = %p\n", hw->isr);
+			break;
+		case VIRTIO_PCI_CAP_DEVICE_CFG:
+			hw->net_cfg = get_cap_addr(hw, &cap);
+			IFCVF_DBG(&dev->dev, "hw->net_cfg = %p\n", hw->net_cfg);
+			break;
+		}
+
+next:
+		pos = cap.cap_next;
+	}
+
+	if (hw->common_cfg == NULL || hw->notify_base == NULL ||
+	    hw->isr == NULL || hw->net_cfg == NULL) {
+		IFCVF_ERR(&dev->dev, "Incomplete PCI capabilities\n");
+		return -EIO;
+	}
+
+	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+		iowrite16(i, &hw->common_cfg->queue_select);
+		notify_off = ioread16(&hw->common_cfg->queue_notify_off);
+		hw->vring->notify_addr[i] = (u16 __iomem *)((u8 *)hw->notify_base +
+				     notify_off * hw->notify_off_multiplier);
+	}
+
+	hw->lm_cfg = hw->mem_resource[IFCVF_LM_BAR].addr;
+
+	IFCVF_DBG(&dev->dev,
+		  "PCI capability mapping: common cfg: %p, notify base: %p\n, isr cfg: %p, device cfg: %p, multiplier: %u\n",
+		  hw->common_cfg, hw->notify_base, hw->isr,
+		  hw->net_cfg, hw->notify_off_multiplier);
+
+	return 0;
+}
diff --git a/drivers/vhost/ifcvf/ifcvf_base.h b/drivers/vhost/ifcvf/ifcvf_base.h
new file mode 100644
index 0000000..a1e33ef
--- /dev/null
+++ b/drivers/vhost/ifcvf/ifcvf_base.h
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Intel Corporation.
+ */
+
+#ifndef _IFCVF_H_
+#define _IFCVF_H_
+
+#include <linux/mdev_virtio.h>
+#include <linux/mdev.h>
+#include <linux/pci.h>
+#include <linux/pci_regs.h>
+#include <uapi/linux/virtio_net.h>
+#include <uapi/linux/virtio_config.h>
+#include <uapi/linux/virtio_pci.h>
+
+#define IFCVF_VENDOR_ID		0x1AF4
+#define IFCVF_DEVICE_ID		0x1041
+#define IFCVF_SUBSYS_VENDOR_ID	0x8086
+#define IFCVF_SUBSYS_DEVICE_ID	0x001A
+
+#define IFCVF_MDEV_LIMIT	1
+
+#define IFCVF_SUPPORTED_FEATURES \
+		((1ULL << VIRTIO_NET_F_MAC)			| \
+		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
+		 (1ULL << VIRTIO_F_VERSION_1)			| \
+		 (1ULL << VIRTIO_F_ORDER_PLATFORM)		| \
+		 (1ULL << VIRTIO_F_IOMMU_PLATFORM)		| \
+		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
+
+/* Only one queue pair for now. */
+#define IFCVF_MAX_QUEUE_PAIRS	1
+
+#define IFCVF_QUEUE_ALIGNMENT	PAGE_SIZE
+#define IFCVF_QUEUE_MAX		32768
+#define IFCVF_MSI_CONFIG_OFF	0
+#define IFCVF_MSI_QUEUE_OFF	1
+#define IFCVF_PCI_MAX_RESOURCE	6
+
+#define IFCVF_LM_CFG_SIZE		0x40
+#define IFCVF_LM_RING_STATE_OFFSET	0x20
+#define IFCVF_LM_BAR			4
+
+#define IFCVF_ERR(dev, fmt, ...)	dev_err(dev, fmt, ##__VA_ARGS__)
+#define IFCVF_DBG(dev, fmt, ...)	dev_dbg(dev, fmt, ##__VA_ARGS__)
+#define IFCVF_INFO(dev, fmt, ...)	dev_info(dev, fmt, ##__VA_ARGS__)
+
+#define ifcvf_private_to_vf(adapter) \
+	(&((struct ifcvf_adapter *)adapter)->vf)
+
+#define IFCVF_MAX_INTR (IFCVF_MAX_QUEUE_PAIRS * 2 + 1)
+
+struct ifcvf_pci_mem_resource {
+	u64      phys_addr;
+	u64      len;
+	/* Virtual address, NULL when not mapped. */
+	u8       *addr;
+};
+
+struct vring_info {
+	u64 desc;
+	u64 avail;
+	u64 used;
+	u16 size;
+	u16 last_avail_idx;
+	u16 last_used_idx;
+	bool ready;
+	char msix_name[256];
+	u16 __iomem *notify_addr[IFCVF_MAX_QUEUE_PAIRS * 2];
+	struct virtio_mdev_callback cb;
+};
+
+struct ifcvf_hw {
+	u8	__iomem *isr;
+	/* Live migration */
+	u8	__iomem	*lm_cfg;
+	u16	nr_vring;
+	/* Notification bar number */
+	u8	notify_bar;
+	/* Notificaiton bar address */
+	u16	__iomem *notify_base;
+	u32	notify_off_multiplier;
+	u64	req_features;
+	struct	virtio_pci_common_cfg __iomem	*common_cfg;
+	struct	virtio_net_config __iomem	*net_cfg;
+	struct	vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
+	struct	ifcvf_pci_mem_resource mem_resource[IFCVF_PCI_MAX_RESOURCE];
+};
+
+struct ifcvf_adapter {
+	struct	device *dev;
+	struct	mutex mdev_lock;
+	int	mdev_count;
+	int	vectors;
+	struct	ifcvf_hw vf;
+};
+
+struct ifcvf_vring_lm_cfg {
+	u32 idx_addr[2];
+	u8 reserved[IFCVF_LM_CFG_SIZE - 8];
+};
+
+struct ifcvf_lm_cfg {
+	u8 reserved[IFCVF_LM_RING_STATE_OFFSET];
+	struct ifcvf_vring_lm_cfg vring_lm_cfg[IFCVF_MAX_QUEUE_PAIRS];
+};
+
+int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev);
+int ifcvf_start_hw(struct ifcvf_hw *hw);
+void ifcvf_stop_hw(struct ifcvf_hw *hw);
+void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid);
+void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
+			   void *dst, int length);
+void ifcvf_write_net_config(struct ifcvf_hw *hw, u64 offset,
+			    const void *src, int length);
+u8 ifcvf_get_status(struct ifcvf_hw *hw);
+void ifcvf_set_status(struct ifcvf_hw *hw, u8 status);
+void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
+void ifcvf_reset(struct ifcvf_hw *hw);
+u64 ifcvf_get_features(struct ifcvf_hw *hw);
+struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
+#endif /* _IFCVF_H_ */
diff --git a/drivers/vhost/ifcvf/ifcvf_main.c b/drivers/vhost/ifcvf/ifcvf_main.c
new file mode 100644
index 0000000..4f602a3
--- /dev/null
+++ b/drivers/vhost/ifcvf/ifcvf_main.c
@@ -0,0 +1,315 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Intel IFC VF NIC driver for vhost dataplane offloading
+ *
+ * Copyright (C) 2019 Intel Corporation.
+ *
+ * Author: Zhu Lingshan <lingshan.zhu@intel.com>
+ *
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/mdev.h>
+#include <linux/pci.h>
+#include <linux/sysfs.h>
+#include "ifcvf_base.h"
+
+#define VERSION_STRING	"0.1"
+#define DRIVER_AUTHOR	"Intel Corporation"
+#define IFCVF_DRIVER_NAME	"ifcvf"
+
+static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
+{
+	struct vring_info *vring = arg;
+
+	if (vring->cb.callback)
+		return vring->cb.callback(vring->cb.private);
+
+	return IRQ_HANDLED;
+}
+
+static const struct mdev_virtio_ops ifc_mdev_ops = {
+	NULL,
+};
+
+static int ifcvf_init_msix(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = to_pci_dev(adapter->dev);
+	struct ifcvf_hw *vf = &adapter->vf;
+	int vector, i, ret, irq;
+
+	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
+				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		IFCVF_ERR(adapter->dev, "Failed to alloc irq vectors\n");
+		return ret;
+	}
+
+	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+		vector = i + IFCVF_MSI_QUEUE_OFF;
+		irq = pci_irq_vector(pdev, vector);
+		ret = request_irq(irq, ifcvf_intr_handler, 0,
+				  pci_name(pdev), &vf->vring[i]);
+		if (ret) {
+			IFCVF_ERR(adapter->dev,
+				  "Failed to request irq for vq %d\n", i);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void ifcvf_destroy_adapter(struct ifcvf_adapter *adapter)
+{
+	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
+	struct pci_dev *pdev = to_pci_dev(adapter->dev);
+	int i, vector, irq;
+
+	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+		vector = i + IFCVF_MSI_QUEUE_OFF;
+		irq = pci_irq_vector(pdev, vector);
+		free_irq(irq, &vf->vring[i]);
+	}
+}
+
+static ssize_t name_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	const char *name = "IFC VF virtio/vhost accelerator (virtio ring compatible)";
+
+	return sprintf(buf, "%s\n", name);
+}
+MDEV_TYPE_ATTR_RO(name);
+
+static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
+			       char *buf)
+{
+	return sprintf(buf, "%s\n", "virtio_mdev");
+}
+MDEV_TYPE_ATTR_RO(device_api);
+
+static ssize_t available_instances_show(struct kobject *kobj,
+					struct device *dev, char *buf)
+{
+	struct pci_dev *pdev;
+	struct ifcvf_adapter *adapter;
+
+	pdev = to_pci_dev(dev);
+	adapter = pci_get_drvdata(pdev);
+
+	return sprintf(buf, "%d\n", adapter->mdev_count);
+}
+MDEV_TYPE_ATTR_RO(available_instances);
+
+static ssize_t type_show(struct kobject *kobj,
+			 struct device *dev, char *buf)
+{
+	return sprintf(buf, "%s\n", "net");
+}
+MDEV_TYPE_ATTR_RO(type);
+
+static struct attribute *mdev_types_attrs[] = {
+	&mdev_type_attr_name.attr,
+	&mdev_type_attr_device_api.attr,
+	&mdev_type_attr_available_instances.attr,
+	&mdev_type_attr_type.attr,
+	NULL,
+};
+
+static struct attribute_group mdev_type_group_virtio = {
+	.name  = "virtio_mdev",
+	.attrs = mdev_types_attrs,
+};
+
+static struct attribute_group mdev_type_group_vhost = {
+	.name  = "vhost_mdev",
+	.attrs = mdev_types_attrs,
+};
+
+static struct attribute_group *mdev_type_groups[] = {
+	&mdev_type_group_virtio,
+	&mdev_type_group_vhost,
+	NULL,
+};
+
+const struct attribute_group *mdev_dev_groups[] = {
+	NULL,
+};
+
+static int ifcvf_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
+{
+	struct device *dev = mdev_parent_dev(mdev);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
+	int ret = 0;
+
+	mutex_lock(&adapter->mdev_lock);
+
+	if (adapter->mdev_count < IFCVF_MDEV_LIMIT) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	mdev_virtio_set_ops(mdev, &ifc_mdev_ops);
+	if (!strcmp(kobj->name, "ifcvf-virtio_mdev"))
+		mdev_virtio_set_class_id(mdev, MDEV_VIRTIO_CLASS_ID_VIRTIO);
+
+	if (!strcmp(kobj->name, "ifcvf-vhost_mdev"))
+		mdev_virtio_set_class_id(mdev, MDEV_VIRTIO_CLASS_ID_VHOST);
+
+	mdev_set_drvdata(mdev, adapter);
+	mdev_set_iommu_device(mdev_dev(mdev), dev);
+	adapter->mdev_count--;
+
+out:
+	mutex_unlock(&adapter->mdev_lock);
+	return ret;
+}
+
+static int ifcvf_mdev_remove(struct mdev_device *mdev)
+{
+	struct device *dev = mdev_parent_dev(mdev);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
+
+	mutex_lock(&adapter->mdev_lock);
+	adapter->mdev_count++;
+	mutex_unlock(&adapter->mdev_lock);
+
+	return 0;
+}
+
+static const struct mdev_parent_ops ifcvf_mdev_fops = {
+	.owner			= THIS_MODULE,
+	.supported_type_groups	= mdev_type_groups,
+	.mdev_attr_groups	= mdev_dev_groups,
+	.create			= ifcvf_mdev_create,
+	.remove			= ifcvf_mdev_remove,
+};
+
+static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct device *dev = &pdev->dev;
+	struct ifcvf_adapter *adapter;
+	struct ifcvf_hw *vf;
+	int ret, i;
+
+	adapter = kzalloc(sizeof(struct ifcvf_adapter), GFP_KERNEL);
+	if (adapter == NULL) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	mutex_init(&adapter->mdev_lock);
+	adapter->mdev_count = IFCVF_MDEV_LIMIT;
+	adapter->dev = dev;
+	pci_set_drvdata(pdev, adapter);
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		IFCVF_ERR(adapter->dev, "Failed to enable device\n");
+		goto free_adapter;
+	}
+
+	ret = pci_request_regions(pdev, IFCVF_DRIVER_NAME);
+	if (ret) {
+		IFCVF_ERR(adapter->dev, "Failed to request MMIO region\n");
+		goto disable_device;
+	}
+
+	pci_set_master(pdev);
+	ret = ifcvf_init_msix(adapter);
+	if (ret) {
+		IFCVF_ERR(adapter->dev, "Failed to initialize MSI-X\n");
+		goto free_msix;
+	}
+
+	vf = &adapter->vf;
+	for (i = 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
+		vf->mem_resource[i].phys_addr = pci_resource_start(pdev, i);
+		vf->mem_resource[i].len = pci_resource_len(pdev, i);
+		if (!vf->mem_resource[i].len) {
+			vf->mem_resource[i].addr = NULL;
+			continue;
+		}
+
+		vf->mem_resource[i].addr = pci_iomap_range(pdev, i, 0,
+				vf->mem_resource[i].len);
+		if (!vf->mem_resource[i].addr) {
+			IFCVF_ERR(adapter->dev, "Failed to map IO resource %d\n",
+				  i);
+			ret = -EINVAL;
+			goto free_msix;
+		}
+	}
+
+	if (ifcvf_init_hw(vf, pdev) < 0) {
+		ret = -EINVAL;
+		goto destroy_adapter;
+	}
+
+	ret = mdev_virtio_register_device(dev, &ifcvf_mdev_fops);
+	if (ret) {
+		IFCVF_ERR(adapter->dev, "Failed to register mdev device\n");
+		goto destroy_adapter;
+	}
+
+	return 0;
+
+destroy_adapter:
+	ifcvf_destroy_adapter(adapter);
+free_msix:
+	pci_free_irq_vectors(pdev);
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+free_adapter:
+	kfree(adapter);
+fail:
+	return ret;
+}
+
+static void ifcvf_remove(struct pci_dev *pdev)
+{
+	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+	struct ifcvf_hw *vf;
+	int i;
+
+	mdev_virtio_unregister_device(dev);
+	vf = &adapter->vf;
+	for (i = 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
+		if (vf->mem_resource[i].addr) {
+			pci_iounmap(pdev, vf->mem_resource[i].addr);
+			vf->mem_resource[i].addr = NULL;
+		}
+	}
+
+	ifcvf_destroy_adapter(adapter);
+	pci_free_irq_vectors(pdev);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	kfree(adapter);
+}
+
+static struct pci_device_id ifcvf_pci_ids[] = {
+	{ PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
+		IFCVF_DEVICE_ID,
+		IFCVF_SUBSYS_VENDOR_ID,
+		IFCVF_SUBSYS_DEVICE_ID) },
+	{ 0 },
+};
+MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
+
+static struct pci_driver ifcvf_driver = {
+	.name     = IFCVF_DRIVER_NAME,
+	.id_table = ifcvf_pci_ids,
+	.probe    = ifcvf_probe,
+	.remove   = ifcvf_remove,
+};
+
+module_pci_driver(ifcvf_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(VERSION_STRING);
+MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
1.8.3.1

