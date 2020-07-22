Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AC42295C9
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732043AbgGVKNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:13:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:37386 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731827AbgGVKNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:13:21 -0400
IronPort-SDR: 5dkfsi4YfZ+2srQSCMbDjonH32sYHA6dhspJR7m7RAGewxxrsG7DBm+F8NtMawl3IXlgt+/Oly
 7nqHFcJraNhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="214940315"
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="214940315"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 03:13:20 -0700
IronPort-SDR: FY9KCOpktDHzDuajtg8/rqOb+yrEV5T9/UX3QNi/KMhKXnSf9Q1AbHt291eRu1MS+vNhEpAFfr
 C1xCULTYWsPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="392634941"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jul 2020 03:13:18 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 5/6] ifcvf: replace irq_request/free with vDPA helpers
Date:   Wed, 22 Jul 2020 18:08:58 +0800
Message-Id: <20200722100859.221669-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200722100859.221669-1-lingshan.zhu@intel.com>
References: <20200722100859.221669-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit replaced irq_request/free() with vDPA helpers
vdpa_devm_request/free_irq() so that it can request/free
irq and setup irq offloading on order.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index f5a60c14b979..65aab6bcaccb 100644
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
+		vdpa_devm_free_irq(&pdev->dev, vdpa, vf->vring[i].irq, i, &vf->vring[i]);
 
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
+	/* This is config interrupt, config accesses all go
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
+		ret = vdpa_devm_request_irq(&pdev->dev, vdpa, irq,
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
2.18.4

