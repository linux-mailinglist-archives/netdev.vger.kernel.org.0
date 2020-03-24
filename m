Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2583F190465
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgCXERY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:17:24 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:46615 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbgCXERU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:17:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585023438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YwKoxCY9zp3dq8gYd1TE4cqYMZSbqD28WCOqrJJiQJ4=;
        b=brIavciI3j26a8Y2m24f7CpqoqBvDIl2kyiDmlzGZOYM5Lx+OpoG8tp7aSLdEavE48ngIB
        Mwm3J8azPk1rl02L5hapjCje5E29QstDseitPGG2VIR0mGLpOCX9Eoh51OsF3Iu3mFoLbu
        b6kdTFFdbtF3K2/2R9fSLmklapv6M8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-d0MD3QV_NL-jAfbzpaKD4w-1; Tue, 24 Mar 2020 00:17:14 -0400
X-MC-Unique: d0MD3QV_NL-jAfbzpaKD4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEF5718A5505;
        Tue, 24 Mar 2020 04:17:11 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-216.pek2.redhat.com [10.72.13.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4E0D10002A9;
        Tue, 24 Mar 2020 04:16:59 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, Bie Tiwei <tiwei.bie@intel.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V7 8/8] virtio: Intel IFC VF driver for VDPA
Date:   Tue, 24 Mar 2020 12:14:58 +0800
Message-Id: <20200324041458.27384-9-jasowang@redhat.com>
In-Reply-To: <20200324041458.27384-1-jasowang@redhat.com>
References: <20200324041458.27384-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Lingshan <lingshan.zhu@intel.com>

This commit introduced two layers to drive IFC VF:

(1) ifcvf_base layer, which handles IFC VF NIC hardware operations and
    configurations.

(2) ifcvf_main layer, which complies to VDPA bus framework,
    implemented device operations for VDPA bus, handles device probe,
    bus attaching, vring operations, etc.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Signed-off-by: Bie Tiwei <tiwei.bie@intel.com>
Signed-off-by: Wang Xiao <xiao.w.wang@intel.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/vdpa/Kconfig            |  10 +
 drivers/virtio/vdpa/Makefile           |   1 +
 drivers/virtio/vdpa/ifcvf/Makefile     |   3 +
 drivers/virtio/vdpa/ifcvf/ifcvf_base.c | 386 ++++++++++++++++++++
 drivers/virtio/vdpa/ifcvf/ifcvf_base.h | 132 +++++++
 drivers/virtio/vdpa/ifcvf/ifcvf_main.c | 474 +++++++++++++++++++++++++
 6 files changed, 1006 insertions(+)
 create mode 100644 drivers/virtio/vdpa/ifcvf/Makefile
 create mode 100644 drivers/virtio/vdpa/ifcvf/ifcvf_base.c
 create mode 100644 drivers/virtio/vdpa/ifcvf/ifcvf_base.h
 create mode 100644 drivers/virtio/vdpa/ifcvf/ifcvf_main.c

diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
index 9baa1d8da002..ae7aeed96723 100644
--- a/drivers/virtio/vdpa/Kconfig
+++ b/drivers/virtio/vdpa/Kconfig
@@ -22,4 +22,14 @@ config VDPA_SIM
 	  to RX. This device is used for testing, prototyping and
 	  development of vDPA.
=20
+config IFCVF
+	tristate "Intel IFC VF VDPA driver"
+	depends on VDPA && PCI_MSI
+	default n
+	help
+	  This kernel module can drive Intel IFC VF NIC to offload
+	  virtio dataplane traffic to hardware.
+	  To compile this driver as a module, choose M here: the module will
+	  be called ifcvf.
+
 endif # VDPA_MENU
diff --git a/drivers/virtio/vdpa/Makefile b/drivers/virtio/vdpa/Makefile
index 3814af8e097b..8bbb686ca7a2 100644
--- a/drivers/virtio/vdpa/Makefile
+++ b/drivers/virtio/vdpa/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_VDPA) +=3D vdpa.o
 obj-$(CONFIG_VDPA_SIM) +=3D vdpa_sim/
+obj-$(CONFIG_IFCVF)    +=3D ifcvf/
diff --git a/drivers/virtio/vdpa/ifcvf/Makefile b/drivers/virtio/vdpa/ifc=
vf/Makefile
new file mode 100644
index 000000000000..d709915995ab
--- /dev/null
+++ b/drivers/virtio/vdpa/ifcvf/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_IFCVF) +=3D ifcvf.o
+ifcvf-$(CONFIG_IFCVF) +=3D ifcvf_main.o ifcvf_base.o
diff --git a/drivers/virtio/vdpa/ifcvf/ifcvf_base.c b/drivers/virtio/vdpa=
/ifcvf/ifcvf_base.c
new file mode 100644
index 000000000000..630e0aad9d05
--- /dev/null
+++ b/drivers/virtio/vdpa/ifcvf/ifcvf_base.c
@@ -0,0 +1,386 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Intel IFC VF NIC driver for virtio dataplane offloading
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ *
+ * Author: Zhu Lingshan <lingshan.zhu@intel.com>
+ *
+ */
+
+#include "ifcvf_base.h"
+
+static inline u8 ifc_ioread8(u8 __iomem *addr)
+{
+	return ioread8(addr);
+}
+static inline u16 ifc_ioread16 (__le16 __iomem *addr)
+{
+	return ioread16(addr);
+}
+
+static inline u32 ifc_ioread32(__le32 __iomem *addr)
+{
+	return ioread32(addr);
+}
+
+static inline void ifc_iowrite8(u8 value, u8 __iomem *addr)
+{
+	iowrite8(value, addr);
+}
+
+static inline void ifc_iowrite16(u16 value, __le16 __iomem *addr)
+{
+	iowrite16(value, addr);
+}
+
+static inline void ifc_iowrite32(u32 value, __le32 __iomem *addr)
+{
+	iowrite32(value, addr);
+}
+
+static void ifc_iowrite64_twopart(u64 val,
+				  __le32 __iomem *lo, __le32 __iomem *hi)
+{
+	ifc_iowrite32((u32)val, lo);
+	ifc_iowrite32(val >> 32, hi);
+}
+
+struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
+{
+	return container_of(hw, struct ifcvf_adapter, vf);
+}
+
+static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
+				  struct virtio_pci_cap *cap)
+{
+	struct ifcvf_adapter *ifcvf;
+	u32 length, offset;
+	u8 bar;
+
+	length =3D le32_to_cpu(cap->length);
+	offset =3D le32_to_cpu(cap->offset);
+	bar =3D cap->bar;
+
+	ifcvf =3D vf_to_adapter(hw);
+	if (bar >=3D IFCVF_PCI_MAX_RESOURCE) {
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
+static int ifcvf_read_config_range(struct pci_dev *dev,
+				   uint32_t *val, int size, int where)
+{
+	int ret, i;
+
+	for (i =3D 0; i < size; i +=3D 4) {
+		ret =3D pci_read_config_dword(dev, where + i, val + i / 4);
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
+	ret =3D pci_read_config_byte(dev, PCI_CAPABILITY_LIST, &pos);
+	if (ret < 0) {
+		IFCVF_ERR(&dev->dev, "Failed to read PCI capability list\n");
+		return -EIO;
+	}
+
+	while (pos) {
+		ret =3D ifcvf_read_config_range(dev, (u32 *)&cap,
+					      sizeof(cap), pos);
+		if (ret < 0) {
+			IFCVF_ERR(&dev->dev,
+				  "Failed to get PCI capability at %x\n", pos);
+			break;
+		}
+
+		if (cap.cap_vndr !=3D PCI_CAP_ID_VNDR)
+			goto next;
+
+		switch (cap.cfg_type) {
+		case VIRTIO_PCI_CAP_COMMON_CFG:
+			hw->common_cfg =3D get_cap_addr(hw, &cap);
+			IFCVF_DBG(&dev->dev, "hw->common_cfg =3D %p\n",
+				  hw->common_cfg);
+			break;
+		case VIRTIO_PCI_CAP_NOTIFY_CFG:
+			pci_read_config_dword(dev, pos + sizeof(cap),
+					      &hw->notify_off_multiplier);
+			hw->notify_bar =3D cap.bar;
+			hw->notify_base =3D get_cap_addr(hw, &cap);
+			IFCVF_DBG(&dev->dev, "hw->notify_base =3D %p\n",
+				  hw->notify_base);
+			break;
+		case VIRTIO_PCI_CAP_ISR_CFG:
+			hw->isr =3D get_cap_addr(hw, &cap);
+			IFCVF_DBG(&dev->dev, "hw->isr =3D %p\n", hw->isr);
+			break;
+		case VIRTIO_PCI_CAP_DEVICE_CFG:
+			hw->net_cfg =3D get_cap_addr(hw, &cap);
+			IFCVF_DBG(&dev->dev, "hw->net_cfg =3D %p\n", hw->net_cfg);
+			break;
+		}
+
+next:
+		pos =3D cap.cap_next;
+	}
+
+	if (hw->common_cfg =3D=3D NULL || hw->notify_base =3D=3D NULL ||
+	    hw->isr =3D=3D NULL || hw->net_cfg =3D=3D NULL) {
+		IFCVF_ERR(&dev->dev, "Incomplete PCI capabilities\n");
+		return -EIO;
+	}
+
+	for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+		ifc_iowrite16(i, &hw->common_cfg->queue_select);
+		notify_off =3D ifc_ioread16(&hw->common_cfg->queue_notify_off);
+		hw->vring[i].notify_addr =3D hw->notify_base +
+			notify_off * hw->notify_off_multiplier;
+	}
+
+	hw->lm_cfg =3D hw->mem_resource[IFCVF_LM_BAR].addr;
+
+	IFCVF_DBG(&dev->dev,
+		  "PCI capability mapping: common cfg: %p, notify base: %p\n, isr cfg:=
 %p, device cfg: %p, multiplier: %u\n",
+		  hw->common_cfg, hw->notify_base, hw->isr,
+		  hw->net_cfg, hw->notify_off_multiplier);
+
+	return 0;
+}
+
+u8 ifcvf_get_status(struct ifcvf_hw *hw)
+{
+	return ifc_ioread8(&hw->common_cfg->device_status);
+}
+
+void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
+{
+	ifc_iowrite8(status, &hw->common_cfg->device_status);
+}
+
+void ifcvf_reset(struct ifcvf_hw *hw)
+{
+	ifcvf_set_status(hw, 0);
+	/* flush set_status, make sure VF is stopped, reset */
+	ifcvf_get_status(hw);
+}
+
+static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
+{
+	if (status !=3D 0)
+		status |=3D ifcvf_get_status(hw);
+
+	ifcvf_set_status(hw, status);
+	ifcvf_get_status(hw);
+}
+
+u64 ifcvf_get_features(struct ifcvf_hw *hw)
+{
+	struct virtio_pci_common_cfg __iomem *cfg =3D hw->common_cfg;
+	u32 features_lo, features_hi;
+
+	ifc_iowrite32(0, &cfg->device_feature_select);
+	features_lo =3D ifc_ioread32(&cfg->device_feature);
+
+	ifc_iowrite32(1, &cfg->device_feature_select);
+	features_hi =3D ifc_ioread32(&cfg->device_feature);
+
+	return ((u64)features_hi << 32) | features_lo;
+}
+
+void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
+			   void *dst, int length)
+{
+	u8 old_gen, new_gen, *p;
+	int i;
+
+	WARN_ON(offset + length > sizeof(struct virtio_net_config));
+	do {
+		old_gen =3D ifc_ioread8(&hw->common_cfg->config_generation);
+		p =3D dst;
+		for (i =3D 0; i < length; i++)
+			*p++ =3D ifc_ioread8(hw->net_cfg + offset + i);
+
+		new_gen =3D ifc_ioread8(&hw->common_cfg->config_generation);
+	} while (old_gen !=3D new_gen);
+}
+
+void ifcvf_write_net_config(struct ifcvf_hw *hw, u64 offset,
+			    const void *src, int length)
+{
+	const u8 *p;
+	int i;
+
+	p =3D src;
+	WARN_ON(offset + length > sizeof(struct virtio_net_config));
+	for (i =3D 0; i < length; i++)
+		ifc_iowrite8(*p++, hw->net_cfg + offset + i);
+}
+
+static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
+{
+	struct virtio_pci_common_cfg __iomem *cfg =3D hw->common_cfg;
+
+	ifc_iowrite32(0, &cfg->guest_feature_select);
+	ifc_iowrite32((u32)features, &cfg->guest_feature);
+
+	ifc_iowrite32(1, &cfg->guest_feature_select);
+	ifc_iowrite32(features >> 32, &cfg->guest_feature);
+}
+
+static int ifcvf_config_features(struct ifcvf_hw *hw)
+{
+	struct ifcvf_adapter *ifcvf;
+
+	ifcvf =3D vf_to_adapter(hw);
+	ifcvf_set_features(hw, hw->req_features);
+	ifcvf_add_status(hw, VIRTIO_CONFIG_S_FEATURES_OK);
+
+	if (!(ifcvf_get_status(hw) & VIRTIO_CONFIG_S_FEATURES_OK)) {
+		IFCVF_ERR(ifcvf->dev, "Failed to set FEATURES_OK status\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+u64 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid)
+{
+	struct ifcvf_lm_cfg __iomem *ifcvf_lm;
+	void __iomem *avail_idx_addr;
+	u16 last_avail_idx;
+	u32 q_pair_id;
+
+	ifcvf_lm =3D (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
+	q_pair_id =3D qid / (IFCVF_MAX_QUEUE_PAIRS * 2);
+	avail_idx_addr =3D &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2]=
;
+	last_avail_idx =3D ifc_ioread16(avail_idx_addr);
+
+	return last_avail_idx;
+}
+
+int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u64 num)
+{
+	struct ifcvf_lm_cfg __iomem *ifcvf_lm;
+	void __iomem *avail_idx_addr;
+	u32 q_pair_id;
+
+	ifcvf_lm =3D (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
+	q_pair_id =3D qid / (IFCVF_MAX_QUEUE_PAIRS * 2);
+	avail_idx_addr =3D &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2]=
;
+	hw->vring[qid].last_avail_idx =3D num;
+	ifc_iowrite16(num, avail_idx_addr);
+
+	return 0;
+}
+
+static int ifcvf_hw_enable(struct ifcvf_hw *hw)
+{
+	struct ifcvf_lm_cfg __iomem *ifcvf_lm;
+	struct virtio_pci_common_cfg __iomem *cfg;
+	struct ifcvf_adapter *ifcvf;
+	u32 i;
+
+	ifcvf_lm =3D (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
+	ifcvf =3D vf_to_adapter(hw);
+	cfg =3D hw->common_cfg;
+	ifc_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
+
+	if (ifc_ioread16(&cfg->msix_config) =3D=3D VIRTIO_MSI_NO_VECTOR) {
+		IFCVF_ERR(ifcvf->dev, "No msix vector for device config\n");
+		return -EINVAL;
+	}
+
+	for (i =3D 0; i < hw->nr_vring; i++) {
+		if (!hw->vring[i].ready)
+			break;
+
+		ifc_iowrite16(i, &cfg->queue_select);
+		ifc_iowrite64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
+				     &cfg->queue_desc_hi);
+		ifc_iowrite64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
+				      &cfg->queue_avail_hi);
+		ifc_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
+				     &cfg->queue_used_hi);
+		ifc_iowrite16(hw->vring[i].size, &cfg->queue_size);
+		ifc_iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_vector);
+
+		if (ifc_ioread16(&cfg->queue_msix_vector) =3D=3D
+		    VIRTIO_MSI_NO_VECTOR) {
+			IFCVF_ERR(ifcvf->dev,
+				  "No msix vector for queue %u\n", i);
+			return -EINVAL;
+		}
+
+		ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
+		ifc_iowrite16(1, &cfg->queue_enable);
+	}
+
+	return 0;
+}
+
+static void ifcvf_hw_disable(struct ifcvf_hw *hw)
+{
+	struct virtio_pci_common_cfg __iomem *cfg;
+	u32 i;
+
+	cfg =3D hw->common_cfg;
+	ifc_iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->msix_config);
+
+	for (i =3D 0; i < hw->nr_vring; i++) {
+		ifc_iowrite16(i, &cfg->queue_select);
+		ifc_iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->queue_msix_vector);
+	}
+
+	ifc_ioread16(&cfg->queue_msix_vector);
+}
+
+int ifcvf_start_hw(struct ifcvf_hw *hw)
+{
+	ifcvf_reset(hw);
+	ifcvf_add_status(hw, VIRTIO_CONFIG_S_ACKNOWLEDGE);
+	ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER);
+
+	if (ifcvf_config_features(hw) < 0)
+		return -EINVAL;
+
+	if (ifcvf_hw_enable(hw) < 0)
+		return -EINVAL;
+
+	ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER_OK);
+
+	return 0;
+}
+
+void ifcvf_stop_hw(struct ifcvf_hw *hw)
+{
+	ifcvf_hw_disable(hw);
+	ifcvf_reset(hw);
+}
+
+void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
+{
+	ifc_iowrite16(qid, hw->vring[qid].notify_addr);
+}
diff --git a/drivers/virtio/vdpa/ifcvf/ifcvf_base.h b/drivers/virtio/vdpa=
/ifcvf/ifcvf_base.h
new file mode 100644
index 000000000000..83bbdca5c089
--- /dev/null
+++ b/drivers/virtio/vdpa/ifcvf/ifcvf_base.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Intel IFC VF NIC driver for virtio dataplane offloading
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ *
+ * Author: Zhu Lingshan <lingshan.zhu@intel.com>
+ *
+ */
+
+#ifndef _IFCVF_H_
+#define _IFCVF_H_
+
+#include <linux/pci.h>
+#include <linux/pci_regs.h>
+#include <linux/vdpa.h>
+#include <uapi/linux/virtio_net.h>
+#include <uapi/linux/virtio_config.h>
+#include <uapi/linux/virtio_pci.h>
+
+#define IFCVF_VENDOR_ID		0x1AF4
+#define IFCVF_DEVICE_ID		0x1041
+#define IFCVF_SUBSYS_VENDOR_ID	0x8086
+#define IFCVF_SUBSYS_DEVICE_ID	0x001A
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
+	void     __iomem *addr;
+};
+
+struct vring_info {
+	u64 desc;
+	u64 avail;
+	u64 used;
+	u16 size;
+	u16 last_avail_idx;
+	bool ready;
+	void __iomem *notify_addr;
+	u32 irq;
+	struct vdpa_callback cb;
+	char msix_name[256];
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
+	void	__iomem *notify_base;
+	u32	notify_off_multiplier;
+	u64	req_features;
+	struct	virtio_pci_common_cfg __iomem	*common_cfg;
+	void  __iomem	*net_cfg;
+	struct	vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
+	struct	ifcvf_pci_mem_resource mem_resource[IFCVF_PCI_MAX_RESOURCE];
+};
+
+struct ifcvf_adapter {
+	struct	vdpa_device vdpa;
+	struct	device *dev;
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
+struct vdpa_ifcvf_dev {
+	struct class	*vd_class;
+	struct idr	vd_idr;
+	struct device	dev;
+	struct kobject  *devices_kobj;
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
+u64 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
+int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u64 num);
+struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
+#endif /* _IFCVF_H_ */
diff --git a/drivers/virtio/vdpa/ifcvf/ifcvf_main.c b/drivers/virtio/vdpa=
/ifcvf/ifcvf_main.c
new file mode 100644
index 000000000000..157ac7ef49d6
--- /dev/null
+++ b/drivers/virtio/vdpa/ifcvf/ifcvf_main.c
@@ -0,0 +1,474 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Intel IFC VF NIC driver for virtio dataplane offloading
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ *
+ * Author: Zhu Lingshan <lingshan.zhu@intel.com>
+ *
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/sysfs.h>
+#include "ifcvf_base.h"
+
+#define VERSION_STRING  "0.1"
+#define DRIVER_AUTHOR   "Intel Corporation"
+#define IFCVF_DRIVER_NAME       "ifcvf"
+
+static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
+{
+	struct vring_info *vring =3D arg;
+
+	if (vring->cb.callback)
+		return vring->cb.callback(vring->cb.private);
+
+	return IRQ_HANDLED;
+}
+
+static int ifcvf_start_datapath(void *private)
+{
+	struct ifcvf_hw *vf =3D ifcvf_private_to_vf(private);
+	struct ifcvf_adapter *ifcvf;
+	u8 status;
+	int ret;
+
+	ifcvf =3D vf_to_adapter(vf);
+	vf->nr_vring =3D IFCVF_MAX_QUEUE_PAIRS * 2;
+	ret =3D ifcvf_start_hw(vf);
+	if (ret < 0) {
+		status =3D ifcvf_get_status(vf);
+		status |=3D VIRTIO_CONFIG_S_FAILED;
+		ifcvf_set_status(vf, status);
+	}
+
+	return ret;
+}
+
+static int ifcvf_stop_datapath(void *private)
+{
+	struct ifcvf_hw *vf =3D ifcvf_private_to_vf(private);
+	int i;
+
+	for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
+		vf->vring[i].cb.callback =3D NULL;
+
+	ifcvf_stop_hw(vf);
+
+	return 0;
+}
+
+static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
+{
+	struct ifcvf_hw *vf =3D ifcvf_private_to_vf(adapter);
+	int i;
+
+	for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+		vf->vring[i].last_avail_idx =3D 0;
+		vf->vring[i].desc =3D 0;
+		vf->vring[i].avail =3D 0;
+		vf->vring[i].used =3D 0;
+		vf->vring[i].ready =3D 0;
+		vf->vring[i].cb.callback =3D NULL;
+		vf->vring[i].cb.private =3D NULL;
+	}
+
+	ifcvf_reset(vf);
+}
+
+static struct ifcvf_adapter *vdpa_to_adapter(struct vdpa_device *vdpa_de=
v)
+{
+	return container_of(vdpa_dev, struct ifcvf_adapter, vdpa);
+}
+
+static struct ifcvf_hw *vdpa_to_vf(struct vdpa_device *vdpa_dev)
+{
+	struct ifcvf_adapter *adapter =3D vdpa_to_adapter(vdpa_dev);
+
+	return &adapter->vf;
+}
+
+static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+	u64 features;
+
+	features =3D ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
+
+	return features;
+}
+
+static int ifcvf_vdpa_set_features(struct vdpa_device *vdpa_dev, u64 fea=
tures)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	vf->req_features =3D features;
+
+	return 0;
+}
+
+static u8 ifcvf_vdpa_get_status(struct vdpa_device *vdpa_dev)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	return ifcvf_get_status(vf);
+}
+
+static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 statu=
s)
+{
+	struct ifcvf_adapter *adapter;
+	struct ifcvf_hw *vf;
+
+	vf  =3D vdpa_to_vf(vdpa_dev);
+	adapter =3D dev_get_drvdata(vdpa_dev->dev.parent);
+
+	if (status =3D=3D 0) {
+		ifcvf_stop_datapath(adapter);
+		ifcvf_reset_vring(adapter);
+		return;
+	}
+
+	if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+		if (ifcvf_start_datapath(adapter) < 0)
+			IFCVF_ERR(adapter->dev,
+				  "Failed to set ifcvf vdpa  status %u\n",
+				  status);
+	}
+
+	ifcvf_set_status(vf, status);
+}
+
+static u16 ifcvf_vdpa_get_vq_num_max(struct vdpa_device *vdpa_dev)
+{
+	return IFCVF_QUEUE_MAX;
+}
+
+static u64 ifcvf_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid=
)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	return ifcvf_get_vq_state(vf, qid);
+}
+
+static int ifcvf_vdpa_set_vq_state(struct vdpa_device *vdpa_dev, u16 qid=
,
+				   u64 num)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	return ifcvf_set_vq_state(vf, qid, num);
+}
+
+static void ifcvf_vdpa_set_vq_cb(struct vdpa_device *vdpa_dev, u16 qid,
+				 struct vdpa_callback *cb)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	vf->vring[qid].cb =3D *cb;
+}
+
+static void ifcvf_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev,
+				    u16 qid, bool ready)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	vf->vring[qid].ready =3D ready;
+}
+
+static bool ifcvf_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qi=
d)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	return vf->vring[qid].ready;
+}
+
+static void ifcvf_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid,
+				  u32 num)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	vf->vring[qid].size =3D num;
+}
+
+static int ifcvf_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 q=
id,
+				     u64 desc_area, u64 driver_area,
+				     u64 device_area)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	vf->vring[qid].desc =3D desc_area;
+	vf->vring[qid].avail =3D driver_area;
+	vf->vring[qid].used =3D device_area;
+
+	return 0;
+}
+
+static void ifcvf_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	ifcvf_notify_queue(vf, qid);
+}
+
+static u32 ifcvf_vdpa_get_generation(struct vdpa_device *vdpa_dev)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	return ioread8(&vf->common_cfg->config_generation);
+}
+
+static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
+{
+	return VIRTIO_ID_NET;
+}
+
+static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
+{
+	return IFCVF_SUBSYS_VENDOR_ID;
+}
+
+static u16 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
+{
+	return IFCVF_QUEUE_ALIGNMENT;
+}
+
+static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
+				  unsigned int offset,
+				  void *buf, unsigned int len)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	WARN_ON(offset + len > sizeof(struct virtio_net_config));
+	ifcvf_read_net_config(vf, offset, buf, len);
+}
+
+static void ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
+				  unsigned int offset, const void *buf,
+				  unsigned int len)
+{
+	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
+
+	WARN_ON(offset + len > sizeof(struct virtio_net_config));
+	ifcvf_write_net_config(vf, offset, buf, len);
+}
+
+static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
+				     struct vdpa_callback *cb)
+{
+	/* We don't support config interrupt */
+}
+
+static void ifcvf_free_irq(struct ifcvf_adapter *adapter)
+{
+	struct ifcvf_hw *vf =3D ifcvf_private_to_vf(adapter);
+	struct pci_dev *pdev =3D to_pci_dev(adapter->dev);
+	int i, vector, irq;
+
+	for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+		if (vf->vring[i].irq) {
+			vector =3D i + IFCVF_MSI_QUEUE_OFF;
+			irq =3D pci_irq_vector(pdev, vector);
+			free_irq(irq, &vf->vring[i]);
+		}
+	}
+}
+
+
+static void ifcvf_free(struct vdpa_device *vdpa_dev)
+{
+	struct ifcvf_adapter *adapter =3D vdpa_to_adapter(vdpa_dev);
+	struct pci_dev *pdev =3D to_pci_dev(adapter->dev);
+	struct ifcvf_hw *vf =3D &adapter->vf;
+	int i;
+
+	for (i =3D 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
+		if (vf->mem_resource[i].addr) {
+			pci_iounmap(pdev, vf->mem_resource[i].addr);
+			vf->mem_resource[i].addr =3D NULL;
+		}
+	}
+
+	ifcvf_free_irq(adapter);
+	pci_free_irq_vectors(pdev);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+/*
+ * IFCVF currently does't have on-chip IOMMU, so not
+ * implemented set_map()/dma_map()/dma_unmap()
+ */
+static const struct vdpa_config_ops ifc_vdpa_ops =3D {
+	.get_features	=3D ifcvf_vdpa_get_features,
+	.set_features	=3D ifcvf_vdpa_set_features,
+	.get_status	=3D ifcvf_vdpa_get_status,
+	.set_status	=3D ifcvf_vdpa_set_status,
+	.get_vq_num_max	=3D ifcvf_vdpa_get_vq_num_max,
+	.get_vq_state	=3D ifcvf_vdpa_get_vq_state,
+	.set_vq_state	=3D ifcvf_vdpa_set_vq_state,
+	.set_vq_cb	=3D ifcvf_vdpa_set_vq_cb,
+	.set_vq_ready	=3D ifcvf_vdpa_set_vq_ready,
+	.get_vq_ready	=3D ifcvf_vdpa_get_vq_ready,
+	.set_vq_num	=3D ifcvf_vdpa_set_vq_num,
+	.set_vq_address	=3D ifcvf_vdpa_set_vq_address,
+	.kick_vq	=3D ifcvf_vdpa_kick_vq,
+	.get_generation	=3D ifcvf_vdpa_get_generation,
+	.get_device_id	=3D ifcvf_vdpa_get_device_id,
+	.get_vendor_id	=3D ifcvf_vdpa_get_vendor_id,
+	.get_vq_align	=3D ifcvf_vdpa_get_vq_align,
+	.get_config	=3D ifcvf_vdpa_get_config,
+	.set_config	=3D ifcvf_vdpa_set_config,
+	.set_config_cb  =3D ifcvf_vdpa_set_config_cb,
+	.free		=3D ifcvf_free,
+};
+
+static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev =3D to_pci_dev(adapter->dev);
+	struct ifcvf_hw *vf =3D &adapter->vf;
+	int vector, i, ret, irq;
+
+
+	for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
+			 pci_name(pdev), i);
+		vector =3D i + IFCVF_MSI_QUEUE_OFF;
+		irq =3D pci_irq_vector(pdev, vector);
+		ret =3D request_irq(irq, ifcvf_intr_handler, 0,
+				  vf->vring[i].msix_name, &vf->vring[i]);
+		if (ret) {
+			IFCVF_ERR(adapter->dev,
+				  "Failed to request irq for vq %d\n", i);
+			return ret;
+		}
+		vf->vring[i].irq =3D irq;
+	}
+
+	return 0;
+}
+
+static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id =
*id)
+{
+	struct device *dev =3D &pdev->dev;
+	struct ifcvf_adapter *adapter;
+	struct ifcvf_hw *vf;
+	int ret, i;
+
+	ret =3D pci_enable_device(pdev);
+	if (ret) {
+		IFCVF_ERR(&pdev->dev, "Failed to enable device\n");
+		goto err_enable;
+	}
+
+	ret =3D pci_request_regions(pdev, IFCVF_DRIVER_NAME);
+	if (ret) {
+		IFCVF_ERR(&pdev->dev, "Failed to request MMIO region\n");
+		goto err_regions;
+	}
+
+	ret =3D pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
+				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		IFCVF_ERR(&pdev->dev, "Failed to alloc irq vectors\n");
+		goto err_vectors;
+	}
+
+	adapter =3D vdpa_alloc_device(ifcvf_adapter, vdpa, dev, &ifc_vdpa_ops);
+	if (adapter =3D=3D NULL) {
+		IFCVF_ERR(&pdev->dev, "Failed to allocate vDPA structure");
+		ret =3D -ENOMEM;
+		goto err_alloc;
+	}
+
+	adapter->dev =3D dev;
+	pci_set_master(pdev);
+	pci_set_drvdata(pdev, adapter);
+
+	ret =3D ifcvf_request_irq(adapter);
+	if (ret) {
+		IFCVF_ERR(&pdev->dev, "Failed to request MSI-X irq\n");
+		goto err_msix;
+	}
+
+	vf =3D &adapter->vf;
+	for (i =3D 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
+		vf->mem_resource[i].phys_addr =3D pci_resource_start(pdev, i);
+		vf->mem_resource[i].len =3D pci_resource_len(pdev, i);
+		if (!vf->mem_resource[i].len)
+			continue;
+
+		vf->mem_resource[i].addr =3D pci_iomap_range(pdev, i, 0,
+				vf->mem_resource[i].len);
+		if (!vf->mem_resource[i].addr) {
+			IFCVF_ERR(&pdev->dev,
+				  "Failed to map IO resource %d\n", i);
+			ret =3D -EINVAL;
+			goto err_msix;
+		}
+	}
+
+	if (ifcvf_init_hw(vf, pdev) < 0) {
+		ret =3D -EINVAL;
+		goto err_msix;
+	}
+
+	ret =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret)
+		ret =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+
+	if (ret) {
+		IFCVF_ERR(adapter->dev, "No usable DMA confiugration\n");
+		ret =3D -EINVAL;
+		goto err_msix;
+	}
+
+	adapter->vdpa.dma_dev =3D dev;
+	ret =3D vdpa_register_device(&adapter->vdpa);
+	if (ret) {
+		IFCVF_ERR(adapter->dev, "Failed to register ifcvf to vdpa bus");
+		goto err_msix;
+	}
+
+	return 0;
+
+err_msix:
+	put_device(&adapter->vdpa.dev);
+	return ret;
+err_alloc:
+	pci_free_irq_vectors(pdev);
+err_vectors:
+	pci_release_regions(pdev);
+err_regions:
+	pci_disable_device(pdev);
+err_enable:
+	return ret;
+}
+
+static void ifcvf_remove(struct pci_dev *pdev)
+{
+	struct ifcvf_adapter *adapter =3D pci_get_drvdata(pdev);
+
+	vdpa_unregister_device(&adapter->vdpa);
+}
+
+static struct pci_device_id ifcvf_pci_ids[] =3D {
+	{ PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
+		IFCVF_DEVICE_ID,
+		IFCVF_SUBSYS_VENDOR_ID,
+		IFCVF_SUBSYS_DEVICE_ID) },
+	{ 0 },
+};
+MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
+
+static struct pci_driver ifcvf_driver =3D {
+	.name     =3D IFCVF_DRIVER_NAME,
+	.id_table =3D ifcvf_pci_ids,
+	.probe    =3D ifcvf_probe,
+	.remove   =3D ifcvf_remove,
+};
+
+module_pci_driver(ifcvf_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(VERSION_STRING);
--=20
2.20.1

