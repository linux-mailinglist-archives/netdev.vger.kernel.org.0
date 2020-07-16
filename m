Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48547222165
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgGPL2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:28:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:52601 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbgGPL2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 07:28:00 -0400
IronPort-SDR: ndIElFxAbfhTghAaobk/y3qMv77PWHDTvb+b+7H7OtDCXVadbf4diGK0sZ1V02XEBafoyDYcv2
 TSioh/OfFMNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="137485067"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="137485067"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 04:28:00 -0700
IronPort-SDR: RUDirpKe32VoEqNGK2HShQ0WaAzu6emdJeuDjEUbD3qdAXJKHGu9O7o9aUU7Esj4OE1l/p13IB
 wAwHG1GWSDNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="460442862"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga005.jf.intel.com with ESMTP; 16 Jul 2020 04:27:58 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 5/6] ifcvf: replace irq_request/free with vDPA helpers
Date:   Thu, 16 Jul 2020 19:23:48 +0800
Message-Id: <1594898629-18790-6-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit replaced irq_request/free() with helpers in vDPA
core, so that it can request/free irq and setup irq offloading
on order.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index f5a60c1..bd2a317 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -47,11 +47,12 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
+	struct vdpa_device *vdpa = &adapter->vdpa;
 	int i;
 
 
 	for (i = 0; i < queues; i++)
-		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
+		vdpa_free_vq_irq(&pdev->dev, vdpa, vf->vring[i].irq, i, &vf->vring[i]);
 
 	ifcvf_free_irq_vectors(pdev);
 }
@@ -60,6 +61,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
+	struct vdpa_device *vdpa = &adapter->vdpa;
 	int vector, i, ret, irq;
 
 	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
@@ -73,6 +75,10 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 		 pci_name(pdev));
 	vector = 0;
 	irq = pci_irq_vector(pdev, vector);
+	/* This isconfig interrupt, config accesses all go
+	 * through userspace, so no need to setup
+	 * config interrupt offloading.
+	 */
 	ret = devm_request_irq(&pdev->dev, irq,
 			       ifcvf_config_changed, 0,
 			       vf->config_msix_name, vf);
@@ -82,13 +88,11 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 			 pci_name(pdev), i);
 		vector = i + IFCVF_MSI_QUEUE_OFF;
 		irq = pci_irq_vector(pdev, vector);
-		ret = devm_request_irq(&pdev->dev, irq,
+		ret = vdpa_alloc_vq_irq(&pdev->dev, vdpa, irq,
 				       ifcvf_intr_handler, 0,
 				       vf->vring[i].msix_name,
-				       &vf->vring[i]);
+				       &vf->vring[i], i);
 		if (ret) {
-			IFCVF_ERR(pdev,
-				  "Failed to request irq for vq %d\n", i);
 			ifcvf_free_irq(adapter, i);
 
 			return ret;
-- 
1.8.3.1

