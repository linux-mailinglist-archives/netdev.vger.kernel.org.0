Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11DE3F013B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhHRKEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:04:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:28419 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232782AbhHRKED (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 06:04:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="216327747"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="216327747"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 03:03:28 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="520889144"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.62])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 03:03:22 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/2] vDPA/ifcvf: detect and use the onboard number of queues directly
Date:   Wed, 18 Aug 2021 17:57:13 +0800
Message-Id: <20210818095714.3220-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210818095714.3220-1-lingshan.zhu@intel.com>
References: <20210818095714.3220-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To enable this multi-queue feature for ifcvf, this commit
intends to detect and use the onboard number of queues
directly than IFCVF_MAX_QUEUE_PAIRS = 1 (removed)

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |  8 +++++---
 drivers/vdpa/ifcvf/ifcvf_base.h | 10 ++++------
 drivers/vdpa/ifcvf/ifcvf_main.c | 21 ++++++++++++---------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 6e197fe0fcf9..2808f1ba9f7b 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -158,7 +158,9 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 		return -EIO;
 	}
 
-	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+	hw->nr_vring = ifc_ioread16(&hw->common_cfg->num_queues);
+
+	for (i = 0; i < hw->nr_vring; i++) {
 		ifc_iowrite16(i, &hw->common_cfg->queue_select);
 		notify_off = ifc_ioread16(&hw->common_cfg->queue_notify_off);
 		hw->vring[i].notify_addr = hw->notify_base +
@@ -304,7 +306,7 @@ u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid)
 	u32 q_pair_id;
 
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
-	q_pair_id = qid / (IFCVF_MAX_QUEUE_PAIRS * 2);
+	q_pair_id = qid / hw->nr_vring;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
 	last_avail_idx = ifc_ioread16(avail_idx_addr);
 
@@ -318,7 +320,7 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
 	u32 q_pair_id;
 
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
-	q_pair_id = qid / (IFCVF_MAX_QUEUE_PAIRS * 2);
+	q_pair_id = qid / hw->nr_vring;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
 	hw->vring[qid].last_avail_idx = num;
 	ifc_iowrite16(num, avail_idx_addr);
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 1601e87870da..97d9019a3ec0 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -31,8 +31,8 @@
 		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
 		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
 
-/* Only one queue pair for now. */
-#define IFCVF_MAX_QUEUE_PAIRS	1
+/* Max 8 data queue pairs(16 queues) and one control vq for now. */
+#define IFCVF_MAX_QUEUES	17
 
 #define IFCVF_QUEUE_ALIGNMENT	PAGE_SIZE
 #define IFCVF_QUEUE_MAX		32768
@@ -51,8 +51,6 @@
 #define ifcvf_private_to_vf(adapter) \
 	(&((struct ifcvf_adapter *)adapter)->vf)
 
-#define IFCVF_MAX_INTR (IFCVF_MAX_QUEUE_PAIRS * 2 + 1)
-
 struct vring_info {
 	u64 desc;
 	u64 avail;
@@ -83,7 +81,7 @@ struct ifcvf_hw {
 	u32 dev_type;
 	struct virtio_pci_common_cfg __iomem *common_cfg;
 	void __iomem *net_cfg;
-	struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
+	struct vring_info vring[IFCVF_MAX_QUEUES];
 	void __iomem * const *base;
 	char config_msix_name[256];
 	struct vdpa_callback config_cb;
@@ -103,7 +101,7 @@ struct ifcvf_vring_lm_cfg {
 
 struct ifcvf_lm_cfg {
 	u8 reserved[IFCVF_LM_RING_STATE_OFFSET];
-	struct ifcvf_vring_lm_cfg vring_lm_cfg[IFCVF_MAX_QUEUE_PAIRS];
+	struct ifcvf_vring_lm_cfg vring_lm_cfg[IFCVF_MAX_QUEUES];
 };
 
 struct ifcvf_vdpa_mgmt_dev {
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 4b623253f460..e34c2ec2b69b 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -63,9 +63,13 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
 	int vector, i, ret, irq;
+	u16 max_intr;
 
-	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
-				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
+	/* all queues and config interrupt  */
+	max_intr = vf->nr_vring + 1;
+
+	ret = pci_alloc_irq_vectors(pdev, max_intr,
+				    max_intr, PCI_IRQ_MSIX);
 	if (ret < 0) {
 		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
 		return ret;
@@ -83,7 +87,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 		return ret;
 	}
 
-	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+	for (i = 0; i < vf->nr_vring; i++) {
 		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
 			 pci_name(pdev), i);
 		vector = i + IFCVF_MSI_QUEUE_OFF;
@@ -112,7 +116,6 @@ static int ifcvf_start_datapath(void *private)
 	u8 status;
 	int ret;
 
-	vf->nr_vring = IFCVF_MAX_QUEUE_PAIRS * 2;
 	ret = ifcvf_start_hw(vf);
 	if (ret < 0) {
 		status = ifcvf_get_status(vf);
@@ -128,7 +131,7 @@ static int ifcvf_stop_datapath(void *private)
 	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
 	int i;
 
-	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
+	for (i = 0; i < vf->nr_vring; i++)
 		vf->vring[i].cb.callback = NULL;
 
 	ifcvf_stop_hw(vf);
@@ -141,7 +144,7 @@ static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
 	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
 	int i;
 
-	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+	for (i = 0; i < vf->nr_vring; i++) {
 		vf->vring[i].last_avail_idx = 0;
 		vf->vring[i].desc = 0;
 		vf->vring[i].avail = 0;
@@ -227,7 +230,7 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
 	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) &&
 	    !(status & VIRTIO_CONFIG_S_DRIVER_OK)) {
 		ifcvf_stop_datapath(adapter);
-		ifcvf_free_irq(adapter, IFCVF_MAX_QUEUE_PAIRS * 2);
+		ifcvf_free_irq(adapter, vf->nr_vring);
 	}
 
 	if (status == 0) {
@@ -526,13 +529,13 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
 		goto err;
 	}
 
-	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
+	for (i = 0; i < vf->nr_vring; i++)
 		vf->vring[i].irq = -EINVAL;
 
 	vf->hw_features = ifcvf_get_hw_features(vf);
 
 	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
-	ret = _vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
+	ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to register to vDPA bus");
 		goto err;
-- 
2.27.0

