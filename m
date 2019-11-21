Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF4D10533C
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 14:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfKUNhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 08:37:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:27188 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbfKUNhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 08:37:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 05:37:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="238178558"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by fmsmga002.fm.intel.com with ESMTP; 21 Nov 2019 05:37:00 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com, Zhu Lingshan <lingshan.zhu@intel.com>,
        Xiao Wang <xiao.w.wang@intel.com>
Subject: [RFC V1 2/2] vhost: Support for virtio_mdev and vhost_mdev
Date:   Thu, 21 Nov 2019 21:34:37 +0800
Message-Id: <1574343277-8835-3-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574343277-8835-1-git-send-email-lingshan.zhu@intel.com>
References: <1574343277-8835-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds functions to support virtio_mdev and vhost_mdev.
Implemented interfaces in struct mdev_virtio_ops and supportive
functions including status operations, features operations,
hardware enable / disable and etc.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Signed-off-by: Xiao Wang <xiao.w.wang@intel.com>
Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>

---
 drivers/vhost/ifcvf/ifcvf_base.c | 194 +++++++++++++++++++++++++++++++
 drivers/vhost/ifcvf/ifcvf_main.c | 242 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 435 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/ifcvf/ifcvf_base.c b/drivers/vhost/ifcvf/ifcvf_base.c
index ec5985f..d56a069 100644
--- a/drivers/vhost/ifcvf/ifcvf_base.c
+++ b/drivers/vhost/ifcvf/ifcvf_base.c
@@ -127,3 +127,197 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev)
 
 	return 0;
 }
+
+u8 ifcvf_get_status(struct ifcvf_hw *hw)
+{
+	return ioread8(&hw->common_cfg->device_status);
+}
+
+void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
+{
+	iowrite8(status, &hw->common_cfg->device_status);
+}
+
+void ifcvf_reset(struct ifcvf_hw *hw)
+{
+	ifcvf_set_status(hw, 0);
+	ifcvf_get_status(hw);
+}
+
+static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
+{
+	if (status != 0)
+		status |= ifcvf_get_status(hw);
+
+	ifcvf_set_status(hw, status);
+	ifcvf_get_status(hw);
+}
+
+u64 ifcvf_get_features(struct ifcvf_hw *hw)
+{
+	struct virtio_pci_common_cfg *cfg = hw->common_cfg;
+	u32 features_lo, features_hi;
+
+	iowrite32(0, &cfg->device_feature_select);
+	features_lo = ioread32(&cfg->device_feature);
+
+	iowrite32(1, &cfg->device_feature_select);
+	features_hi = ioread32(&cfg->device_feature);
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
+		old_gen = ioread8(&hw->common_cfg->config_generation);
+		p = dst;
+		for (i = 0; i < length; i++)
+			*p++ = ioread8((u8 *)hw->net_cfg + offset + i);
+
+		new_gen = ioread8(&hw->common_cfg->config_generation);
+	} while (old_gen != new_gen);
+}
+
+void ifcvf_write_net_config(struct ifcvf_hw *hw, u64 offset,
+			    const void *src, int length)
+{
+	const u8 *p;
+	int i;
+
+	p = src;
+	WARN_ON(offset + length > sizeof(struct virtio_net_config));
+	for (i = 0; i < length; i++)
+		iowrite8(*p++, (u8 *)hw->net_cfg + offset + i);
+}
+
+static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
+{
+	struct virtio_pci_common_cfg *cfg = hw->common_cfg;
+
+	iowrite32(0, &cfg->guest_feature_select);
+	iowrite32((u32)features, &cfg->guest_feature);
+
+	iowrite32(1, &cfg->guest_feature_select);
+	iowrite32(features >> 32, &cfg->guest_feature);
+}
+
+static int ifcvf_config_features(struct ifcvf_hw *hw)
+{
+	struct ifcvf_adapter *ifcvf;
+
+	ifcvf = vf_to_adapter(hw);
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
+void io_write64_twopart(u64 val, u32 *lo, u32 *hi)
+{
+	iowrite32(val & ((1ULL << 32) - 1), lo);
+	iowrite32(val >> 32, hi);
+}
+
+static int ifcvf_hw_enable(struct ifcvf_hw *hw)
+{
+	struct ifcvf_lm_cfg __iomem *ifcvf_lm;
+	struct virtio_pci_common_cfg *cfg;
+	struct ifcvf_adapter *ifcvf;
+	u32 __iomem *idx_addr;
+	u32 i, val;
+
+	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
+	ifcvf = vf_to_adapter(hw);
+	cfg = hw->common_cfg;
+	iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
+
+	if (ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
+		IFCVF_ERR(ifcvf->dev, "No msix vector for device config\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < hw->nr_vring; i++) {
+		if (!hw->vring[i].ready)
+			break;
+
+		iowrite16(i, &cfg->queue_select);
+		io_write64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
+				   &cfg->queue_desc_hi);
+		io_write64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
+				   &cfg->queue_avail_hi);
+		io_write64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
+				   &cfg->queue_used_hi);
+		iowrite16(hw->vring[i].size, &cfg->queue_size);
+		idx_addr = &ifcvf_lm->vring_lm_cfg[i/IFCVF_MAX_QUEUE_PAIRS * 2].idx_addr[i%IFCVF_MAX_QUEUE_PAIRS * 2];
+		val = hw->vring[i].last_avail_idx |
+			((u32)hw->vring[i].last_used_idx << 16);
+		iowrite32(val, idx_addr);
+		iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_vector);
+
+		if (ioread16(&cfg->queue_msix_vector) ==
+			VIRTIO_MSI_NO_VECTOR) {
+			IFCVF_ERR(ifcvf->dev,
+				  "No msix vector for queue %u\n", i);
+			return -EINVAL;
+		}
+
+		iowrite16(1, &cfg->queue_enable);
+	}
+
+	return 0;
+}
+
+static void ifcvf_hw_disable(struct ifcvf_hw *hw)
+{
+	struct virtio_pci_common_cfg *cfg;
+	u32 i;
+
+	cfg = hw->common_cfg;
+	iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->msix_config);
+
+	for (i = 0; i < hw->nr_vring; i++) {
+		iowrite16(i, &cfg->queue_select);
+		iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->queue_msix_vector);
+	}
+
+	ioread16(&cfg->queue_msix_vector);
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
+	iowrite16(qid, hw->vring->notify_addr[qid]);
+}
diff --git a/drivers/vhost/ifcvf/ifcvf_main.c b/drivers/vhost/ifcvf/ifcvf_main.c
index 4f602a3..bce9609 100644
--- a/drivers/vhost/ifcvf/ifcvf_main.c
+++ b/drivers/vhost/ifcvf/ifcvf_main.c
@@ -29,8 +29,248 @@ static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static int ifcvf_start_datapath(void *private)
+{
+	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
+	struct ifcvf_adapter *ifcvf;
+	u8 status;
+	int ret;
+
+	ifcvf = vf_to_adapter(vf);
+	vf->nr_vring = IFCVF_MAX_QUEUE_PAIRS * 2;
+	ret = ifcvf_start_hw(vf);
+	if (ret < 0) {
+		status = ifcvf_get_status(vf);
+		status |= VIRTIO_CONFIG_S_FAILED;
+		ifcvf_set_status(vf, status);
+	}
+
+	return ret;
+}
+
+static int ifcvf_stop_datapath(void *private)
+{
+	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
+	int i;
+
+	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
+		vf->vring[i].cb.callback = NULL;
+
+	ifcvf_stop_hw(vf);
+
+	return 0;
+}
+
+static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
+{
+	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
+	int i;
+
+	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+		vf->vring[i].last_used_idx = 0;
+		vf->vring[i].last_avail_idx = 0;
+		vf->vring[i].desc = 0;
+		vf->vring[i].avail = 0;
+		vf->vring[i].used = 0;
+		vf->vring[i].ready = 0;
+		vf->vring->cb.callback = NULL;
+		vf->vring->cb.private = NULL;
+	}
+
+	ifcvf_reset(vf);
+}
+
+static struct ifcvf_hw *mdev_to_vf(struct mdev_device *mdev)
+{
+	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
+	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
+
+	return vf;
+}
+
+static u64 ifcvf_mdev_get_features(struct mdev_device *mdev)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+	u64 features;
+
+	features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
+
+	return features;
+}
+
+static int ifcvf_mdev_set_features(struct mdev_device *mdev, u64 features)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	vf->req_features = features;
+
+	return 0;
+}
+
+static u8 ifcvf_mdev_get_status(struct mdev_device *mdev)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	return ifcvf_get_status(vf);
+}
+
+static void ifcvf_mdev_set_status(struct mdev_device *mdev, u8 status)
+{
+	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
+	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
+
+	if (status == 0) {
+		ifcvf_stop_datapath(adapter);
+		ifcvf_reset_vring(adapter);
+		return;
+	}
+
+	if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+		if (ifcvf_start_datapath(adapter) < 0)
+			IFCVF_ERR(adapter->dev, "Failed to set mdev status %u\n",
+				  status);
+	}
+
+	ifcvf_set_status(vf, status);
+}
+
+static u16 ifcvf_mdev_get_vq_num_max(struct mdev_device *mdev)
+{
+	return IFCVF_QUEUE_MAX;
+}
+
+static u64 ifcvf_mdev_get_vq_state(struct mdev_device *mdev, u16 qid)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+	u16 last_avail_idx;
+	u16 __iomem *idx_addr;
+
+	idx_addr = (u16 __iomem *)(vf->lm_cfg + IFCVF_LM_RING_STATE_OFFSET +
+			(qid / 2) * IFCVF_LM_CFG_SIZE + (qid % 2) * 4);
+	last_avail_idx = ioread16(idx_addr);
+
+	return last_avail_idx;
+}
+
+static int ifcvf_mdev_set_vq_state(struct mdev_device *mdev, u16 qid, u64 num)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	vf->vring[qid].last_avail_idx = num;
+
+	return 0;
+}
+
+static void ifcvf_mdev_set_vq_cb(struct mdev_device *mdev, u16 qid,
+				 struct virtio_mdev_callback *cb)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	vf->vring[qid].cb = *cb;
+}
+
+static void ifcvf_mdev_set_vq_ready(struct mdev_device *mdev,
+				    u16 qid, bool ready)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	vf->vring[qid].ready = ready;
+}
+
+static bool ifcvf_mdev_get_vq_ready(struct mdev_device *mdev, u16 qid)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	return vf->vring[qid].ready;
+}
+
+static void ifcvf_mdev_set_vq_num(struct mdev_device *mdev, u16 qid, u32 num)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	vf->vring[qid].size = num;
+}
+
+static int ifcvf_mdev_set_vq_address(struct mdev_device *mdev, u16 qid,
+				     u64 desc_area, u64 driver_area,
+				     u64 device_area)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	vf->vring[qid].desc = desc_area;
+	vf->vring[qid].avail = driver_area;
+	vf->vring[qid].used = device_area;
+
+	return 0;
+}
+
+static void ifcvf_mdev_kick_vq(struct mdev_device *mdev, u16 qid)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	ifcvf_notify_queue(vf, qid);
+}
+
+static u32 ifcvf_mdev_get_generation(struct mdev_device *mdev)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	return ioread8(&vf->common_cfg->config_generation);
+}
+
+static u32 ifcvf_mdev_get_device_id(struct mdev_device *mdev)
+{
+	return VIRTIO_ID_NET;
+}
+
+static u32 ifcvf_mdev_get_vendor_id(struct mdev_device *mdev)
+{
+	return IFCVF_SUBSYS_VENDOR_ID;
+}
+
+static u16 ifcvf_mdev_get_vq_align(struct mdev_device *mdev)
+{
+	return IFCVF_QUEUE_ALIGNMENT;
+}
+
+static void ifcvf_mdev_get_config(struct mdev_device *mdev, unsigned int offset,
+				  void *buf, unsigned int len)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	WARN_ON(offset + len > sizeof(struct virtio_net_config));
+	ifcvf_read_net_config(vf, offset, buf, len);
+}
+
+static void ifcvf_mdev_set_config(struct mdev_device *mdev, unsigned int offset,
+				  const void *buf, unsigned int len)
+{
+	struct ifcvf_hw *vf = mdev_to_vf(mdev);
+
+	WARN_ON(offset + len > sizeof(struct virtio_net_config));
+	ifcvf_write_net_config(vf, offset, buf, len);
+}
+
 static const struct mdev_virtio_ops ifc_mdev_ops = {
-	NULL,
+	.get_features	= ifcvf_mdev_get_features,
+	.set_features	= ifcvf_mdev_set_features,
+	.get_status	= ifcvf_mdev_get_status,
+	.set_status	= ifcvf_mdev_set_status,
+	.get_vq_num_max	= ifcvf_mdev_get_vq_num_max,
+	.get_vq_state	= ifcvf_mdev_get_vq_state,
+	.set_vq_state	= ifcvf_mdev_set_vq_state,
+	.set_vq_cb	= ifcvf_mdev_set_vq_cb,
+	.set_vq_ready	= ifcvf_mdev_set_vq_ready,
+	.get_vq_ready	= ifcvf_mdev_get_vq_ready,
+	.set_vq_num	= ifcvf_mdev_set_vq_num,
+	.set_vq_address	= ifcvf_mdev_set_vq_address,
+	.kick_vq	= ifcvf_mdev_kick_vq,
+	.get_generation	= ifcvf_mdev_get_generation,
+	.get_device_id	= ifcvf_mdev_get_device_id,
+	.get_vendor_id	= ifcvf_mdev_get_vendor_id,
+	.get_vq_align	= ifcvf_mdev_get_vq_align,
+	.get_config	= ifcvf_mdev_get_config,
+	.set_config	= ifcvf_mdev_set_config,
 };
 
 static int ifcvf_init_msix(struct ifcvf_adapter *adapter)
-- 
1.8.3.1

