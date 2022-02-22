Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956584BF274
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 08:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiBVHJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 02:09:20 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiBVHJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 02:09:11 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5050FB18AE
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 23:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645513726; x=1677049726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vMuxhCZ+IJK4Gtzhc243HRjcYNVBlDW5WrZzbPagQkk=;
  b=FdhlNDWiQYyQu0MPrpXVlotq7MLOSl2hIDD5GxSJOVm0W6rconNrQ6ha
   DuC9svDspbvf6PUKW9+SVZn/yE/0pQp28LLg7b9hGLj/Undq6vm474swr
   48DYuwJzTQPk0chT4TUcDwJDBQOJPldJeYjoCdFob6LOJZ2A5WHCnHS9v
   b3tIai8ZNLW7Gu4Oge8os+dACMImP/n70XYUI4Ndjw+Hz5t6vC1imCOWX
   9hbAJaXlnZvGMv40hGHbwIHBBlOMNZ2n+DH8GUpcXUUWCI2AHTRQH5d6O
   kqR2RWVeO7xV7OR6eNj4O6UCKsdb9pfrmhIDbz0Cg8H0ECF+LWuvCj/0b
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="249207311"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="249207311"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 23:08:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="776207143"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 23:08:44 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 4/5] vDPA/ifcvf: implement shared IRQ feature
Date:   Tue, 22 Feb 2022 15:01:08 +0800
Message-Id: <20220222070109.931260-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220222070109.931260-1-lingshan.zhu@intel.com>
References: <20220222070109.931260-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms/devices, there may not be enough MSI vectors
allocated for the virtqueues and config changes. In such a case,
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

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |  48 +++---
 drivers/vdpa/ifcvf/ifcvf_base.h |  15 +-
 drivers/vdpa/ifcvf/ifcvf_main.c | 294 ++++++++++++++++++++++++++++----
 3 files changed, 300 insertions(+), 57 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index b9fdc5258611..ba4866f871dd 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -15,6 +15,26 @@ struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
 	return container_of(hw, struct ifcvf_adapter, vf);
 }
 
+u16 ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+
+	vp_iowrite16(qid, &cfg->queue_select);
+	vp_iowrite16(vector, &cfg->queue_msix_vector);
+
+	return vp_ioread16(&cfg->queue_msix_vector);
+}
+
+u16 ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+
+	cfg = hw->common_cfg;
+	vp_iowrite16(vector,  &cfg->msix_config);
+
+	return vp_ioread16(&cfg->msix_config);
+}
+
 static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
 				  struct virtio_pci_cap *cap)
 {
@@ -131,6 +151,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 			notify_off * hw->notify_off_multiplier;
 		hw->vring[i].notify_pa = hw->notify_base_pa +
 			notify_off * hw->notify_off_multiplier;
+		hw->vring[i].irq = -EINVAL;
 	}
 
 	hw->lm_cfg = hw->base[IFCVF_LM_BAR];
@@ -140,6 +161,9 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 		  hw->common_cfg, hw->notify_base, hw->isr,
 		  hw->dev_cfg, hw->notify_off_multiplier);
 
+	hw->vqs_reused_irq = -EINVAL;
+	hw->config_irq = -EINVAL;
+
 	return 0;
 }
 
@@ -321,13 +345,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 
 	ifcvf = vf_to_adapter(hw);
 	cfg = hw->common_cfg;
-	vp_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
-
-	if (vp_ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
-		IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\n");
-		return -EINVAL;
-	}
-
 	for (i = 0; i < hw->nr_vring; i++) {
 		if (!hw->vring[i].ready)
 			break;
@@ -340,15 +357,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 		vp_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
 				     &cfg->queue_used_hi);
 		vp_iowrite16(hw->vring[i].size, &cfg->queue_size);
-		vp_iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_vector);
-
-		if (vp_ioread16(&cfg->queue_msix_vector) ==
-		    VIRTIO_MSI_NO_VECTOR) {
-			IFCVF_ERR(ifcvf->pdev,
-				  "No msix vector for queue %u\n", i);
-			return -EINVAL;
-		}
-
 		ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
 		vp_iowrite16(1, &cfg->queue_enable);
 	}
@@ -362,14 +370,10 @@ static void ifcvf_hw_disable(struct ifcvf_hw *hw)
 	u32 i;
 
 	cfg = hw->common_cfg;
-	vp_iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->msix_config);
-
+	ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);
 	for (i = 0; i < hw->nr_vring; i++) {
-		vp_iowrite16(i, &cfg->queue_select);
-		vp_iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->queue_msix_vector);
+		ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR)
 	}
-
-	vp_ioread16(&cfg->queue_msix_vector);
 }
 
 int ifcvf_start_hw(struct ifcvf_hw *hw)
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 25c591a3eae2..dcd31accfce5 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -28,8 +28,6 @@
 
 #define IFCVF_QUEUE_ALIGNMENT	PAGE_SIZE
 #define IFCVF_QUEUE_MAX		32768
-#define IFCVF_MSI_CONFIG_OFF	0
-#define IFCVF_MSI_QUEUE_OFF	1
 #define IFCVF_PCI_MAX_RESOURCE	6
 
 #define IFCVF_LM_CFG_SIZE		0x40
@@ -43,6 +41,13 @@
 #define ifcvf_private_to_vf(adapter) \
 	(&((struct ifcvf_adapter *)adapter)->vf)
 
+/* all vqs and config interrupt has its own vector */
+#define MSIX_VECTOR_PER_VQ_AND_CONFIG		1
+/* all vqs share a vector, and config interrupt has a separate vector */
+#define MSIX_VECTOR_SHARED_VQ_AND_CONFIG	2
+/* all vqs and config interrupt share a vector */
+#define MSIX_VECTOR_DEV_SHARED			3
+
 struct vring_info {
 	u64 desc;
 	u64 avail;
@@ -77,9 +82,11 @@ struct ifcvf_hw {
 	void __iomem * const *base;
 	char config_msix_name[256];
 	struct vdpa_callback config_cb;
-	unsigned int config_irq;
+	int config_irq;
+	int vqs_reused_irq;
 	/* virtio-net or virtio-blk device config size */
 	u32 config_size;
+	u8 msix_vector_status;
 };
 
 struct ifcvf_adapter {
@@ -124,4 +131,6 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
 int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
 u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
+u16 ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector);
+u16 ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
 #endif /* _IFCVF_H_ */
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 964f7ac142ba..3b48e717e89f 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -27,7 +27,7 @@ static irqreturn_t ifcvf_config_changed(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
+static irqreturn_t ifcvf_vq_intr_handler(int irq, void *arg)
 {
 	struct vring_info *vring = arg;
 
@@ -37,24 +37,98 @@ static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t ifcvf_vqs_reused_intr_handler(int irq, void *arg)
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
+static irqreturn_t ifcvf_dev_intr_handler(int irq, void *arg)
+{
+	struct ifcvf_hw *vf = arg;
+	u8 isr;
+
+	isr = vp_ioread8(vf->isr);
+	if (isr & VIRTIO_PCI_ISR_CONFIG)
+		ifcvf_config_changed(irq, arg);
+
+	return ifcvf_vqs_reused_intr_handler(irq, arg);
+}
+
 static void ifcvf_free_irq_vectors(void *data)
 {
 	pci_free_irq_vectors(data);
 }
 
-static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
+static void ifcvf_free_per_vq_irq(struct ifcvf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
 	int i;
 
+	for (i = 0; i < vf->nr_vring; i++) {
+		if (vf->vring[i].irq != -EINVAL) {
+			devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
+			vf->vring[i].irq = -EINVAL;
+		}
+	}
+}
 
-	for (i = 0; i < queues; i++) {
-		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
-		vf->vring[i].irq = -EINVAL;
+static void ifcvf_free_vqs_reused_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+
+	if (vf->vqs_reused_irq != -EINVAL) {
+		devm_free_irq(&pdev->dev, vf->vqs_reused_irq, vf);
+		vf->vqs_reused_irq = -EINVAL;
 	}
 
-	devm_free_irq(&pdev->dev, vf->config_irq, vf);
+}
+
+static void ifcvf_free_vq_irq(struct ifcvf_adapter *adapter)
+{
+	struct ifcvf_hw *vf = &adapter->vf;
+
+	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
+		ifcvf_free_per_vq_irq(adapter);
+	else
+		ifcvf_free_vqs_reused_irq(adapter);
+}
+
+static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+
+	if (vf->config_irq == -EINVAL)
+		return;
+
+	/* If the irq is shared by all vqs and the config interrupt,
+	 * it is already freed in ifcvf_free_vq_irq, so here only
+	 * need to free config irq when msix_vector_status != MSIX_VECTOR_DEV_SHARED
+	 */
+	if (vf->msix_vector_status != MSIX_VECTOR_DEV_SHARED) {
+		devm_free_irq(&pdev->dev, vf->config_irq, vf);
+		vf->config_irq = -EINVAL;
+	}
+}
+
+static void ifcvf_free_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+
+	ifcvf_free_vq_irq(adapter);
+	ifcvf_free_config_irq(adapter);
 	ifcvf_free_irq_vectors(pdev);
 }
 
@@ -86,48 +160,201 @@ static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
 	return ret;
 }
 
-static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
-	int vector, nvectors, i, ret, irq;
+	int i, vector, ret, irq;
 
-	nvectors = ifcvf_alloc_vectors(adapter);
-	if (nvectors <= 0)
-		return -EFAULT;
+	vf->vqs_reused_irq = -EINVAL;
+	for (i = 0; i < vf->nr_vring; i++) {
+		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n", pci_name(pdev), i);
+		vector = i;
+		irq = pci_irq_vector(pdev, vector);
+		ret = devm_request_irq(&pdev->dev, irq,
+				       ifcvf_vq_intr_handler, 0,
+				       vf->vring[i].msix_name,
+				       &vf->vring[i]);
+		if (ret) {
+			IFCVF_ERR(pdev, "Failed to request irq for vq %d\n", i);
+			goto err;
+		}
+
+		vf->vring[i].irq = irq;
+		ret = ifcvf_set_vq_vector(vf, i, vector);
+		if (ret == VIRTIO_MSI_NO_VECTOR) {
+			IFCVF_ERR(pdev, "No msix vector for vq %u\n", i);
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	ifcvf_free_irq(adapter);
+
+	return -EFAULT;
+}
+
+static int ifcvf_request_vqs_reused_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int i, vector, ret, irq;
+
+	vector = 0;
+	snprintf(vf->vring[0].msix_name, 256, "ifcvf[%s]-vqs-reused-irq\n", pci_name(pdev));
+	irq = pci_irq_vector(pdev, vector);
+	ret = devm_request_irq(&pdev->dev, irq,
+			       ifcvf_vqs_reused_intr_handler, 0,
+			       vf->vring[0].msix_name, vf);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to request reused irq for the device\n");
+		goto err;
+	}
+
+	vf->vqs_reused_irq = irq;
+	for (i = 0; i < vf->nr_vring; i++) {
+		vf->vring[i].irq = -EINVAL;
+		ret = ifcvf_set_vq_vector(vf, i, vector);
+		if (ret == VIRTIO_MSI_NO_VECTOR) {
+			IFCVF_ERR(pdev, "No msix vector for vq %u\n", i);
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	ifcvf_free_irq(adapter);
+
+	return -EFAULT;
+}
+
+static int ifcvf_request_dev_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int i, vector, ret, irq;
+
+	vector = 0;
+	snprintf(vf->vring[0].msix_name, 256, "ifcvf[%s]-dev-irq\n", pci_name(pdev));
+	irq = pci_irq_vector(pdev, vector);
+	ret = devm_request_irq(&pdev->dev, irq,
+			       ifcvf_dev_intr_handler, 0,
+			       vf->vring[0].msix_name, vf);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to request irq for the device\n");
+		goto err;
+	}
+
+	vf->vqs_reused_irq = irq;
+	for (i = 0; i < vf->nr_vring; i++) {
+		vf->vring[i].irq = -EINVAL;
+		ret = ifcvf_set_vq_vector(vf, i, vector);
+		if (ret == VIRTIO_MSI_NO_VECTOR) {
+			IFCVF_ERR(pdev, "No msix vector for vq %u\n", i);
+			goto err;
+		}
+	}
+
+	vf->config_irq = irq;
+	ret = ifcvf_set_config_vector(vf, vector);
+	if (ret == VIRTIO_MSI_NO_VECTOR) {
+		IFCVF_ERR(pdev, "No msix vector for device config\n");
+		goto err;
+	}
+
+	return 0;
+err:
+	ifcvf_free_irq(adapter);
+
+	return -EFAULT;
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
+		ret = ifcvf_request_vqs_reused_irq(adapter);
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
-		return ret;
+		goto err;
 	}
 
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
+	ret = ifcvf_set_config_vector(vf, config_vector);
+	if (ret == VIRTIO_MSI_NO_VECTOR) {
+		IFCVF_ERR(pdev, "No msix vector for device config\n");
+		goto err;
+	}
 
-			return ret;
-		}
+	return 0;
+err:
+	ifcvf_free_irq(adapter);
 
-		vf->vring[i].irq = irq;
+	return -EFAULT;
+}
+
+static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+{
+	struct ifcvf_hw *vf = &adapter->vf;
+	int nvectors, ret, max_intr;
+
+	nvectors = ifcvf_alloc_vectors(adapter);
+	if (nvectors <= 0)
+		return -EFAULT;
+
+	vf->msix_vector_status = MSIX_VECTOR_PER_VQ_AND_CONFIG;
+	max_intr = vf->nr_vring + 1;
+	if (nvectors < max_intr)
+		vf->msix_vector_status = MSIX_VECTOR_SHARED_VQ_AND_CONFIG;
+
+	if (nvectors == 1) {
+		vf->msix_vector_status = MSIX_VECTOR_DEV_SHARED;
+		ret = ifcvf_request_dev_irq(adapter);
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
 
@@ -284,7 +511,7 @@ static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
 
 	if (status_old & VIRTIO_CONFIG_S_DRIVER_OK) {
 		ifcvf_stop_datapath(adapter);
-		ifcvf_free_irq(adapter, vf->nr_vring);
+		ifcvf_free_irq(adapter);
 	}
 
 	ifcvf_reset_vring(adapter);
@@ -431,7 +658,10 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	return vf->vring[qid].irq;
+	if (vf->vqs_reused_irq < 0)
+		return vf->vring[qid].irq;
+	else
+		return -EINVAL;
 }
 
 static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
-- 
2.27.0

