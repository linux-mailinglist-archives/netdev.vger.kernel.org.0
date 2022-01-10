Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C449E488FCB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiAJF1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:27:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:9544 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238742AbiAJF1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:27:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792424; x=1673328424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Y43mCzCtOa4jeMuuqM5GMSSeh6Z308UfkfH52saLW0=;
  b=JEIn8FarUEbXjNcLo5vO6YH8bCvMwMyRi9eVqE2NT4XxlW9qjhIRSHqz
   K3ceqb5vu0ALWrNpVOTBzKrLECyf+FLsolSlm+1UMW1r9ub//S0XKYWLD
   Bc6fb8Hht/ko4sVXUug4l9H2S62Es844CRKcX5zTbF/cxMPcJMPmUCZqE
   CcZMeoYhRarrIDY8sUaZEWdO2Noo04UeOZm/oj0MSRujdJ21rNEeET/Tp
   Cgua1XLS/Uj1B/8RiCtfisG96Umd5EX5+RuA+6tq5CPbuQ8dFFRGo51VB
   w+YnLx/UrG8VeJFCuSp7sk2Sx8YmYwqwHelEDQPGziHDr20R2h4WVcFrD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479532"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479532"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:27:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="489892333"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:27:02 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 7/7] vDPA/ifcvf: improve irq requester, to handle per_vq/shared/config irq
Date:   Mon, 10 Jan 2022 13:19:47 +0800
Message-Id: <20220110051947.84901-8-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110051947.84901-1-lingshan.zhu@intel.com>
References: <20220110051947.84901-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit expends irq requester abilities to handle per vq irq,
shared irq and config irq.

On some platforms, the device can not get enough vectors for every
virtqueue and config interrupt, the device needs to work under such
circumstances.

Normally a device can get enough vectors, so every virtqueue and
config interrupt can have its own vector/irq. If the total vector
number is less than all virtqueues + 1(config interrupt), all
virtqueues need to share a vector/irq and config interrupt is
enabled. If the total vector number < 2, all vitequeues share
a vector/irq, and config interrupt is disabled. Otherwise it will
fail if allocation for vectors fails.

This commit also made necessary chages to the irq cleaner to
free per vq irq/shared irq and config irq.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |  6 +--
 drivers/vdpa/ifcvf/ifcvf_main.c | 78 +++++++++++++++------------------
 2 files changed, 38 insertions(+), 46 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 1d5431040d7d..1d0afb63f06c 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -27,8 +27,6 @@
 
 #define IFCVF_QUEUE_ALIGNMENT	PAGE_SIZE
 #define IFCVF_QUEUE_MAX		32768
-#define IFCVF_MSI_CONFIG_OFF	0
-#define IFCVF_MSI_QUEUE_OFF	1
 #define IFCVF_PCI_MAX_RESOURCE	6
 
 #define IFCVF_LM_CFG_SIZE		0x40
@@ -102,11 +100,13 @@ struct ifcvf_hw {
 	u8 notify_bar;
 	/* Notificaiton bar address */
 	void __iomem *notify_base;
+	u8 vector_per_vq;
+	u16 padding;
 	phys_addr_t notify_base_pa;
 	u32 notify_off_multiplier;
+	u32 dev_type;
 	u64 req_features;
 	u64 hw_features;
-	u32 dev_type;
 	struct virtio_pci_common_cfg __iomem *common_cfg;
 	void __iomem *net_cfg;
 	struct vring_info vring[IFCVF_MAX_QUEUES];
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 414b5dfd04ca..ec76e342bd7e 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -17,6 +17,8 @@
 #define DRIVER_AUTHOR   "Intel Corporation"
 #define IFCVF_DRIVER_NAME       "ifcvf"
 
+static struct vdpa_config_ops ifc_vdpa_ops;
+
 static irqreturn_t ifcvf_config_changed(int irq, void *arg)
 {
 	struct ifcvf_hw *vf = arg;
@@ -63,13 +65,20 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
 	struct ifcvf_hw *vf = &adapter->vf;
 	int i;
 
+	if (vf->vector_per_vq)
+		for (i = 0; i < queues; i++) {
+			devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
+			vf->vring[i].irq = -EINVAL;
+		}
+	else
+		devm_free_irq(&pdev->dev, vf->vring[0].irq, vf);
 
-	for (i = 0; i < queues; i++) {
-		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
-		vf->vring[i].irq = -EINVAL;
+
+	if (vf->config_irq != -EINVAL) {
+		devm_free_irq(&pdev->dev, vf->config_irq, vf);
+		vf->config_irq = -EINVAL;
 	}
 
-	devm_free_irq(&pdev->dev, vf->config_irq, vf);
 	ifcvf_free_irq_vectors(pdev);
 }
 
@@ -191,52 +200,35 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter, int config_ve
 
 static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 {
-	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
-	int vector, i, ret, irq;
-	u16 max_intr;
+	u16 nvectors, max_vectors;
+	int config_vector, ret;
 
-	/* all queues and config interrupt  */
-	max_intr = vf->nr_vring + 1;
+	nvectors = ifcvf_alloc_vectors(adapter);
+	if (nvectors < 0)
+		return nvectors;
 
-	ret = pci_alloc_irq_vectors(pdev, max_intr,
-				    max_intr, PCI_IRQ_MSIX);
-	if (ret < 0) {
-		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
-		return ret;
-	}
+	vf->vector_per_vq = true;
+	max_vectors = vf->nr_vring + 1;
+	config_vector = vf->nr_vring;
 
-	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
-		 pci_name(pdev));
-	vector = 0;
-	vf->config_irq = pci_irq_vector(pdev, vector);
-	ret = devm_request_irq(&pdev->dev, vf->config_irq,
-			       ifcvf_config_changed, 0,
-			       vf->config_msix_name, vf);
-	if (ret) {
-		IFCVF_ERR(pdev, "Failed to request config irq\n");
-		return ret;
+	if (nvectors < max_vectors) {
+		vf->vector_per_vq = false;
+		config_vector = 1;
+		ifc_vdpa_ops.get_vq_irq = NULL;
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
+	if (nvectors < 2)
+		config_vector = 0;
 
-			return ret;
-		}
+	ret = ifcvf_request_vq_irq(adapter, vf->vector_per_vq);
+	if (ret)
+		return ret;
 
-		vf->vring[i].irq = irq;
-	}
+	ret = ifcvf_request_config_irq(adapter, config_vector);
+
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -573,7 +565,7 @@ static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_devic
  * IFCVF currently does't have on-chip IOMMU, so not
  * implemented set_map()/dma_map()/dma_unmap()
  */
-static const struct vdpa_config_ops ifc_vdpa_ops = {
+static struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_features	= ifcvf_vdpa_get_features,
 	.set_features	= ifcvf_vdpa_set_features,
 	.get_status	= ifcvf_vdpa_get_status,
-- 
2.27.0

