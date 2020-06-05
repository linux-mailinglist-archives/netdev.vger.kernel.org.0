Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957E41EF561
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 12:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgFEKbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 06:31:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:57119 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbgFEKbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 06:31:01 -0400
IronPort-SDR: f6bPQv6nPW1E5QxE2pJxvyxnYBDKL4yw/8YI5b9dS/NrVzZDvmYLBUpnbod1OpnUUo9E/Kjyme
 PzX2X1Cfj/1g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 03:31:00 -0700
IronPort-SDR: x5l/2qq2NG7AduJUCR//ecPM5gplqMOOPSBppxuPDxBjtehRJNt7jFb213Ks4AKv1K2AqNNpG1
 QftXd9Rhv5cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,476,1583222400"; 
   d="scan'208";a="305024853"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2020 03:30:57 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH RESEND 1/5] ifcvf: move IRQ request/free to status change handlers
Date:   Fri,  5 Jun 2020 18:27:11 +0800
Message-Id: <1591352835-22441-2-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591352835-22441-1-git-send-email-lingshan.zhu@intel.com>
References: <1591352835-22441-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To comply with VIRTIO spec, this commit intends to move IRQ request
and free operations from probe() to device status changing handler,
would handle datapath start/stop in the handler as well.

VIRTIO spec 1.1, section 2.1.2 Device Requirements: Device Status Field
The device MUST NOT consume buffers or send any used buffer
notifications to the driver before DRIVER_OK.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 120 ++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 47 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index abf6a061..d529ed6 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -28,6 +28,60 @@ static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static void ifcvf_free_irq_vectors(void *data)
+{
+	pci_free_irq_vectors(data);
+}
+
+static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int i;
+
+
+	for (i = 0; i < queues; i++)
+		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
+
+	ifcvf_free_irq_vectors(pdev);
+}
+
+static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int vector, i, ret, irq;
+
+	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
+				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
+		return ret;
+	}
+
+	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
+		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
+			 pci_name(pdev), i);
+		vector = i + IFCVF_MSI_QUEUE_OFF;
+		irq = pci_irq_vector(pdev, vector);
+		ret = devm_request_irq(&pdev->dev, irq,
+				       ifcvf_intr_handler, 0,
+				       vf->vring[i].msix_name,
+				       &vf->vring[i]);
+		if (ret) {
+			IFCVF_ERR(pdev,
+				  "Failed to request irq for vq %d\n", i);
+			ifcvf_free_irq(adapter, i);
+
+			return ret;
+		}
+
+		vf->vring[i].irq = irq;
+	}
+
+	return 0;
+}
+
 static int ifcvf_start_datapath(void *private)
 {
 	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
@@ -118,17 +172,34 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
 {
 	struct ifcvf_adapter *adapter;
 	struct ifcvf_hw *vf;
+	u8 status_old;
+	int ret;
 
 	vf  = vdpa_to_vf(vdpa_dev);
 	adapter = dev_get_drvdata(vdpa_dev->dev.parent);
+	status_old = ifcvf_get_status(vf);
 
-	if (status == 0) {
+	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) &&
+	    !(status & VIRTIO_CONFIG_S_DRIVER_OK)) {
 		ifcvf_stop_datapath(adapter);
+		ifcvf_free_irq(adapter, IFCVF_MAX_QUEUE_PAIRS * 2);
+	}
+
+	if (status == 0) {
 		ifcvf_reset_vring(adapter);
 		return;
 	}
 
-	if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
+	    !(status_old & VIRTIO_CONFIG_S_DRIVER_OK)) {
+		ret = ifcvf_request_irq(adapter);
+		if (ret) {
+			status = ifcvf_get_status(vf);
+			status |= VIRTIO_CONFIG_S_FAILED;
+			ifcvf_set_status(vf, status);
+			return;
+		}
+
 		if (ifcvf_start_datapath(adapter) < 0)
 			IFCVF_ERR(adapter->pdev,
 				  "Failed to set ifcvf vdpa  status %u\n",
@@ -284,38 +355,6 @@ static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
 };
 
-static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
-{
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
-	int vector, i, ret, irq;
-
-
-	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
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
-			return ret;
-		}
-		vf->vring[i].irq = irq;
-	}
-
-	return 0;
-}
-
-static void ifcvf_free_irq_vectors(void *data)
-{
-	pci_free_irq_vectors(data);
-}
-
 static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct device *dev = &pdev->dev;
@@ -349,13 +388,6 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 	}
 
-	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
-				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
-	if (ret < 0) {
-		IFCVF_ERR(pdev, "Failed to alloc irq vectors\n");
-		return ret;
-	}
-
 	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
 	if (ret) {
 		IFCVF_ERR(pdev,
@@ -379,12 +411,6 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	adapter->pdev = pdev;
 	adapter->vdpa.dma_dev = &pdev->dev;
 
-	ret = ifcvf_request_irq(adapter);
-	if (ret) {
-		IFCVF_ERR(pdev, "Failed to request MSI-X irq\n");
-		goto err;
-	}
-
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");
-- 
1.8.3.1

