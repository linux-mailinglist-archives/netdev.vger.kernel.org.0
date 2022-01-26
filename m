Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D7549CA27
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241581AbiAZM40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:56:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:29550 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241587AbiAZM4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643201781; x=1674737781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5NJ3FMThsR2Sh4bv3AkEj5WMXeNKF2d6jBkW/cN1UEM=;
  b=PYOTCA8O5PcT4b8n6eUcDXtsCEp0OFIf51kHGD08FGaRkAjjESUstwxD
   CWIZv8mZfZyF42snwEmT5k/II005zkPjUVKNOfSJmRISprhifCll+k/Z+
   wEH3zP+t3LAkNBbMTU6hAAcxbQOAq83IBzGDu/ew1F/U1QOMAPTcd0R7J
   th8TMLiKLn3zLOUgViA0SbJh0KVIlEU4/y5273cTCvkm4dl6AYedkTIA+
   i91ecj2wFaxj0b2SoVmm5NtAxfZ33zTKY1lLsGtwfTvtnHtXxcqzZJ/iV
   ocVpvDDQmEMyapFrV2IuUe5gnsyWXOqGvtPaSX4OoEObqMHceYb3M8z9c
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244141271"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="244141271"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="520783510"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:18 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 4/4] vDPA/ifcvf: implement shared IRQ feature
Date:   Wed, 26 Jan 2022 20:49:12 +0800
Message-Id: <20220126124912.90205-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126124912.90205-1-lingshan.zhu@intel.com>
References: <20220126124912.90205-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms/devices, there may not be enough MSI vector
slots allocated for virtqueues and config changes. In such a case,
the interrupt sources(virtqueues, config changes) must share
an IRQ/vector, to avoid initialization failures, keep
the device functional.

This commit handles three cases:
(1) number of the allocated vectors == the number of virtqueues + 1
(config changes), every virtqueue and the config interrupt has
a separated vector/IRQ, the best and the most likely case.
(2) number of the allocated vectors is less than the best case, but
greater than 1. In this case, all virtqueues share a vector/IRQ,
the config interrupt has a separated vector/IRQ
(3) only one vector is allocated, in this case, the virtqueues and
the config interrupt share a vector/IRQ. The worst and most
unlikely case.

Otherwise, it needs to fail.

This commit introduces some helper functions:
ifcvf_set_vq_vector() and ifcvf_set_config_vector() sets virtqueue
vector and config vector in the device config space, so that
the device can send interrupt DMA.

This commit adds some fields in struct ifcvf_hw and re-placed
the existed fields to be aligned with the cacheline.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |  47 +++++--
 drivers/vdpa/ifcvf/ifcvf_base.h |  23 ++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 241 +++++++++++++++++++++++++++-----
 3 files changed, 254 insertions(+), 57 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 397692ae671c..18dcb63ab1e3 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -15,6 +15,36 @@ struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
 	return container_of(hw, struct ifcvf_adapter, vf);
 }
 
+int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
+
+	ifc_iowrite16(qid, &cfg->queue_select);
+	ifc_iowrite16(vector, &cfg->queue_msix_vector);
+	if (ifc_ioread16(&cfg->queue_msix_vector) == VIRTIO_MSI_NO_VECTOR) {
+		IFCVF_ERR(ifcvf->pdev, "No msix vector for queue %u\n", qid);
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
+
+	cfg = hw->common_cfg;
+	ifc_iowrite16(vector,  &cfg->msix_config);
+	if (ifc_ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
+		IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
 				  struct virtio_pci_cap *cap)
 {
@@ -140,6 +170,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 		  hw->common_cfg, hw->notify_base, hw->isr,
 		  hw->dev_cfg, hw->notify_off_multiplier);
 
+	hw->vqs_shared_irq = -EINVAL;
+
 	return 0;
 }
 
@@ -321,12 +353,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 
 	ifcvf = vf_to_adapter(hw);
 	cfg = hw->common_cfg;
-	ifc_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
-
-	if (ifc_ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
-		IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\n");
-		return -EINVAL;
-	}
 
 	for (i = 0; i < hw->nr_vring; i++) {
 		if (!hw->vring[i].ready)
@@ -340,15 +366,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 		ifc_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
 				     &cfg->queue_used_hi);
 		ifc_iowrite16(hw->vring[i].size, &cfg->queue_size);
-		ifc_iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_vector);
-
-		if (ifc_ioread16(&cfg->queue_msix_vector) ==
-		    VIRTIO_MSI_NO_VECTOR) {
-			IFCVF_ERR(ifcvf->pdev,
-				  "No msix vector for queue %u\n", i);
-			return -EINVAL;
-		}
-
 		ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
 		ifc_iowrite16(1, &cfg->queue_enable);
 	}
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 949b4fb9d554..9cfe088c82e9 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -27,8 +27,6 @@
 
 #define IFCVF_QUEUE_ALIGNMENT	PAGE_SIZE
 #define IFCVF_QUEUE_MAX		32768
-#define IFCVF_MSI_CONFIG_OFF	0
-#define IFCVF_MSI_QUEUE_OFF	1
 #define IFCVF_PCI_MAX_RESOURCE	6
 
 #define IFCVF_LM_CFG_SIZE		0x40
@@ -42,6 +40,13 @@
 #define ifcvf_private_to_vf(adapter) \
 	(&((struct ifcvf_adapter *)adapter)->vf)
 
+/* all vqs and config interrupt has its own vector */
+#define MSIX_VECTOR_PER_VQ_AND_CONFIG		1
+/* all vqs share a vector, and config interrupt has a separate vector */
+#define MSIX_VECTOR_SHARED_VQ_AND_CONFIG	2
+/* all vqs and config interrupt share a vector */
+#define MSIX_VECTOR_DEV_SHARED			3
+
 static inline u8 ifc_ioread8(u8 __iomem *addr)
 {
 	return ioread8(addr);
@@ -97,25 +102,27 @@ struct ifcvf_hw {
 	u8 __iomem *isr;
 	/* Live migration */
 	u8 __iomem *lm_cfg;
-	u16 nr_vring;
 	/* Notification bar number */
 	u8 notify_bar;
+	u8 msix_vector_status;
+	/* virtio-net or virtio-blk device config size */
+	u32 config_size;
 	/* Notificaiton bar address */
 	void __iomem *notify_base;
 	phys_addr_t notify_base_pa;
 	u32 notify_off_multiplier;
+	u32 dev_type;
 	u64 req_features;
 	u64 hw_features;
-	u32 dev_type;
 	struct virtio_pci_common_cfg __iomem *common_cfg;
 	void __iomem *dev_cfg;
 	struct vring_info vring[IFCVF_MAX_QUEUES];
 	void __iomem * const *base;
 	char config_msix_name[256];
 	struct vdpa_callback config_cb;
-	unsigned int config_irq;
-	/* virtio-net or virtio-blk device config size */
-	u32 config_size;
+	int config_irq;
+	int vqs_shared_irq;
+	u16 nr_vring;
 };
 
 struct ifcvf_adapter {
@@ -160,4 +167,6 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
 int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
 u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
+int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector);
+int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
 #endif /* _IFCVF_H_ */
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 44c89ab0b6da..53f0033a018a 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -17,6 +17,7 @@
 #define DRIVER_AUTHOR   "Intel Corporation"
 #define IFCVF_DRIVER_NAME       "ifcvf"
 
+/* handles config interrupt */
 static irqreturn_t ifcvf_config_changed(int irq, void *arg)
 {
 	struct ifcvf_hw *vf = arg;
@@ -27,6 +28,7 @@ static irqreturn_t ifcvf_config_changed(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+/* handles vqs interrupt */
 static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
 {
 	struct vring_info *vring = arg;
@@ -37,24 +39,77 @@ static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+/* handls vqs shared interrupt */
+static irqreturn_t ifcvf_vq_shared_intr_handler(int irq, void *arg)
+{
+	struct ifcvf_hw *vf = arg;
+	struct vring_info *vring;
+	int i;
+
+	for (i = 0; i < vf->nr_vring; i++) {
+		vring = &vf->vring[i];
+		if (vring->cb.callback)
+			vf->vring->cb.callback(vring->cb.private);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/* handles a shared interrupt for vqs and config */
+static irqreturn_t ifcvf_dev_shared_intr_handler(int irq, void *arg)
+{
+	struct ifcvf_hw *vf = arg;
+	u8 isr;
+
+	isr = ifc_ioread8(vf->isr);
+	if (isr & VIRTIO_PCI_ISR_CONFIG)
+		ifcvf_config_changed(irq, arg);
+
+	return ifcvf_vq_shared_intr_handler(irq, arg);
+}
+
 static void ifcvf_free_irq_vectors(void *data)
 {
 	pci_free_irq_vectors(data);
 }
 
-static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
+static void ifcvf_free_vq_irq(struct ifcvf_adapter *adapter, int queues)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
 	int i;
 
+	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG) {
+		for (i = 0; i < queues; i++) {
+			devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
+			vf->vring[i].irq = -EINVAL;
+		}
+	} else {
+		devm_free_irq(&pdev->dev, vf->vqs_shared_irq, vf);
+	}	vf->vqs_shared_irq = -EINVAL;
+}
 
-	for (i = 0; i < queues; i++) {
-		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
-		vf->vring[i].irq = -EINVAL;
+static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+
+	/* If the irq is shared by all vqs and the config interrupt,
+	 * it is already freed in ifcvf_free_vq_irq, so here only
+	 * need to free config irq when msix_vector_status != MSIX_VECTOR_DEV_SHARED
+	 */
+	if (vf->msix_vector_status != MSIX_VECTOR_DEV_SHARED) {
+		devm_free_irq(&pdev->dev, vf->config_irq, vf);
+		vf->config_irq = -EINVAL;
 	}
+}
+
+static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
+{
+	struct pci_dev *pdev = adapter->pdev;
 
-	devm_free_irq(&pdev->dev, vf->config_irq, vf);
+	ifcvf_free_vq_irq(adapter, queues);
+	ifcvf_free_config_irq(adapter);
 	ifcvf_free_irq_vectors(pdev);
 }
 
@@ -86,58 +141,171 @@ static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
 	return ret;
 }
 
-static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
-	int vector, nvectors, i, ret, irq;
-	u16 max_intr;
+	int i, vector, ret, irq;
 
-	nvectors = ifcvf_alloc_vectors(adapter);
-	if (!(nvectors > 0))
-		return nvectors;
+	for (i = 0; i < vf->nr_vring; i++) {
+		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n", pci_name(pdev), i);
+		vector = i;
+		irq = pci_irq_vector(pdev, vector);
+		ret = devm_request_irq(&pdev->dev, irq,
+				       ifcvf_intr_handler, 0,
+				       vf->vring[i].msix_name,
+				       &vf->vring[i]);
+		if (ret) {
+			IFCVF_ERR(pdev, "Failed to request irq for vq %d\n", i);
+			ifcvf_free_vq_irq(adapter, i);
+		} else {
+			vf->vring[i].irq = irq;
+			ifcvf_set_vq_vector(vf, i, vector);
+		}
+	}
 
-	max_intr = vf->nr_vring + 1;
+	vf->vqs_shared_irq = -EINVAL;
+
+	return 0;
+}
+
+static int ifcvf_request_shared_vq_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int i, vector, ret, irq;
+
+	vector = 0;
+	/* reuse msix_name[256] space of vring0 to store shared vqs interrupt name */
+	snprintf(vf->vring[0].msix_name, 256, "ifcvf[%s]-vqs-shared-irq\n", pci_name(pdev));
+	irq = pci_irq_vector(pdev, vector);
+	ret = devm_request_irq(&pdev->dev, irq,
+			       ifcvf_vq_shared_intr_handler, 0,
+			       vf->vring[0].msix_name, vf);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to request shared irq for vf\n");
+
+		return ret;
+	}
+
+	vf->vqs_shared_irq = irq;
+	for (i = 0; i < vf->nr_vring; i++) {
+		vf->vring[i].irq = -EINVAL;
+		ifcvf_set_vq_vector(vf, i, vector);
+	}
+
+	return 0;
+
+}
+
+static int ifcvf_request_dev_shared_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int i, vector, ret, irq;
+
+	vector = 0;
+	/* reuse msix_name[256] space of vring0 to store shared device interrupt name */
+	snprintf(vf->vring[0].msix_name, 256, "ifcvf[%s]-dev-shared-irq\n", pci_name(pdev));
+	irq = pci_irq_vector(pdev, vector);
+	ret = devm_request_irq(&pdev->dev, irq,
+			       ifcvf_dev_shared_intr_handler, 0,
+			       vf->vring[0].msix_name, vf);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to request shared irq for vf\n");
 
-	ret = pci_alloc_irq_vectors(pdev, max_intr,
-				    max_intr, PCI_IRQ_MSIX);
-	if (ret < 0) {
-		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
 		return ret;
 	}
 
+	vf->vqs_shared_irq = irq;
+	for (i = 0; i < vf->nr_vring; i++) {
+		vf->vring[i].irq = -EINVAL;
+		ifcvf_set_vq_vector(vf, i, vector);
+	}
+
+	vf->config_irq = irq;
+	ifcvf_set_config_vector(vf, vector);
+
+	return 0;
+
+}
+
+static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter)
+{
+	struct ifcvf_hw *vf = &adapter->vf;
+	int ret;
+
+	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
+		ret = ifcvf_request_per_vq_irq(adapter);
+	else
+		ret = ifcvf_request_shared_vq_irq(adapter);
+
+	return ret;
+}
+
+static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int config_vector, ret;
+
+	if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
+		return 0;
+
+	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
+		/* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector for config interrupt */
+		config_vector = vf->nr_vring;
+
+	if (vf->msix_vector_status ==  MSIX_VECTOR_SHARED_VQ_AND_CONFIG)
+		/* vector 0 for vqs and 1 for config interrupt */
+		config_vector = 1;
+
 	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
 		 pci_name(pdev));
-	vector = 0;
-	vf->config_irq = pci_irq_vector(pdev, vector);
+	vf->config_irq = pci_irq_vector(pdev, config_vector);
 	ret = devm_request_irq(&pdev->dev, vf->config_irq,
 			       ifcvf_config_changed, 0,
 			       vf->config_msix_name, vf);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to request config irq\n");
+		ifcvf_free_vq_irq(adapter, vf->nr_vring);
 		return ret;
 	}
+		ifcvf_set_config_vector(vf, config_vector);
 
-	for (i = 0; i < vf->nr_vring; i++) {
-		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
-			 pci_name(pdev), i);
-		vector = i + IFCVF_MSI_QUEUE_OFF;
-		irq = pci_irq_vector(pdev, vector);
-		ret = devm_request_irq(&pdev->dev, irq,
-				       ifcvf_intr_handler, 0,
-				       vf->vring[i].msix_name,
-				       &vf->vring[i]);
-		if (ret) {
-			IFCVF_ERR(pdev,
-				  "Failed to request irq for vq %d\n", i);
-			ifcvf_free_irq(adapter, i);
+	return 0;
+}
 
-			return ret;
-		}
+static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+{
+	struct ifcvf_hw *vf = &adapter->vf;
+	int nvectors, ret, max_intr;
 
-		vf->vring[i].irq = irq;
+	nvectors = ifcvf_alloc_vectors(adapter);
+	if (!(nvectors > 0))
+		return nvectors;
+
+	vf->msix_vector_status = MSIX_VECTOR_PER_VQ_AND_CONFIG;
+	max_intr = vf->nr_vring + 1;
+	if (nvectors < max_intr)
+		vf->msix_vector_status = MSIX_VECTOR_SHARED_VQ_AND_CONFIG;
+
+	if (nvectors == 1) {
+		vf->msix_vector_status = MSIX_VECTOR_DEV_SHARED;
+		ret = ifcvf_request_dev_shared_irq(adapter);
+
+		return ret;
 	}
 
+	ret = ifcvf_request_vq_irq(adapter);
+	if (ret)
+		return ret;
+
+	ret = ifcvf_request_config_irq(adapter);
+
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -441,7 +609,10 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	return vf->vring[qid].irq;
+	if (vf->vqs_shared_irq < 0)
+		return vf->vring[qid].irq;
+	else
+		return -EINVAL;
 }
 
 static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
-- 
2.27.0

