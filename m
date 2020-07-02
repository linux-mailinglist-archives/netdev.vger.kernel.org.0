Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D218211E2C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgGBIWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:22:46 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59442 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728405AbgGBIWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:22:44 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628MVLp081794;
        Thu, 2 Jul 2020 03:22:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678151;
        bh=IPYADznch2oF3OT/2Ql57mNeeC/uA2ZY2VCc9l5fLDQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=jqWlLeQ9s6a2LzJ90q0eTRXI5o1EmG8SozWZzBplGqsuBatOB7Zko1A+JOTHZj22m
         9DGm7+CujGMVyKRoLMYgkJHUNzoFaqWqAdgztVhdGI1jwaNFR+IxX+ZEnx9G/DHKPQ
         2PbN+666Ca0qrF+bUCdRBfv2TAG8DeJST3AMvhxw=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628MV1X030784
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:22:31 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:22:31 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:22:31 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYJ006145;
        Thu, 2 Jul 2020 03:22:24 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 07/22] virtio_pci: Use request_threaded_irq() instead of request_irq()
Date:   Thu, 2 Jul 2020 13:51:28 +0530
Message-ID: <20200702082143.25259-8-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the virtio drivers (like virtio_rpmsg_bus.c) use sleeping
functions like mutex_*() in the virtqueue callback. Use
request_threaded_irq() instead of request_irq() in order for
the virtqueue callbacks to be executed in thread context instead
of interrupt context.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/virtio/virtio_pci_common.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 222d630c41fc..60998b4f1f30 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -140,9 +140,9 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 	v = vp_dev->msix_used_vectors;
 	snprintf(vp_dev->msix_names[v], sizeof *vp_dev->msix_names,
 		 "%s-config", name);
-	err = request_irq(pci_irq_vector(vp_dev->pci_dev, v),
-			  vp_config_changed, 0, vp_dev->msix_names[v],
-			  vp_dev);
+	err = request_threaded_irq(pci_irq_vector(vp_dev->pci_dev, v), 0,
+				   vp_config_changed, 0, vp_dev->msix_names[v],
+				   vp_dev);
 	if (err)
 		goto error;
 	++vp_dev->msix_used_vectors;
@@ -159,9 +159,9 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 		v = vp_dev->msix_used_vectors;
 		snprintf(vp_dev->msix_names[v], sizeof *vp_dev->msix_names,
 			 "%s-virtqueues", name);
-		err = request_irq(pci_irq_vector(vp_dev->pci_dev, v),
-				  vp_vring_interrupt, 0, vp_dev->msix_names[v],
-				  vp_dev);
+		err = request_threaded_irq(pci_irq_vector(vp_dev->pci_dev, v),
+					   0, vp_vring_interrupt, 0,
+					   vp_dev->msix_names[v], vp_dev);
 		if (err)
 			goto error;
 		++vp_dev->msix_used_vectors;
@@ -336,10 +336,11 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
 			 sizeof *vp_dev->msix_names,
 			 "%s-%s",
 			 dev_name(&vp_dev->vdev.dev), names[i]);
-		err = request_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec),
-				  vring_interrupt, 0,
-				  vp_dev->msix_names[msix_vec],
-				  vqs[i]);
+		err = request_threaded_irq(pci_irq_vector(vp_dev->pci_dev,
+							  msix_vec),
+					   0, vring_interrupt, 0,
+					   vp_dev->msix_names[msix_vec],
+					   vqs[i]);
 		if (err)
 			goto error_find;
 	}
@@ -361,8 +362,8 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned nvqs,
 	if (!vp_dev->vqs)
 		return -ENOMEM;
 
-	err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, IRQF_SHARED,
-			dev_name(&vdev->dev), vp_dev);
+	err = request_threaded_irq(vp_dev->pci_dev->irq, 0, vp_interrupt,
+				   IRQF_SHARED, dev_name(&vdev->dev), vp_dev);
 	if (err)
 		goto out_del_vqs;
 
-- 
2.17.1

