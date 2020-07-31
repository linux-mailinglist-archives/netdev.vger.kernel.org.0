Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711A0233F93
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbgGaHAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:00:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:8274 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731575AbgGaG77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:59:59 -0400
IronPort-SDR: iglRBUCDj/xs8HOQqn+NqPTbKUylYccAfVDhhKW6hl0+gHeNfj1rLfoZPVcEGvevS+qVuOabJ1
 WOPcjq9MNKgw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131810481"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="131810481"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 23:59:58 -0700
IronPort-SDR: txmNrT9hwpKtf+0HrhfgR0pTovoFnXQQUxIr1py9xf4xGyp3AjZH3Xb/SBTVxYGSFm6RcLcu3G
 PFobSw/51tNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="273136596"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jul 2020 23:59:55 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 5/6] ifcvf: implement vdpa_config_ops.get_vq_irq()
Date:   Fri, 31 Jul 2020 14:55:32 +0800
Message-Id: <20200731065533.4144-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200731065533.4144-1-lingshan.zhu@intel.com>
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implemented vdpa_config_ops.get_vq_irq() in ifcvf,
and initialized vq irq to -EINVAL. So that ifcvf can report
irq number of a vq, or -EINVAL if the vq is not assigned an
irq number.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index f5a60c14b979..a902b29b0d29 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -50,8 +50,10 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
 	int i;
 
 
-	for (i = 0; i < queues; i++)
+	for (i = 0; i < queues; i++) {
 		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
+		vf->vring[i].irq = -EINVAL;
+	}
 
 	ifcvf_free_irq_vectors(pdev);
 }
@@ -352,6 +354,14 @@ static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
 	vf->config_cb.private = cb->private;
 }
 
+static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
+				 u16 qid)
+{
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+
+	return vf->vring[qid].irq;
+}
+
 /*
  * IFCVF currently does't have on-chip IOMMU, so not
  * implemented set_map()/dma_map()/dma_unmap()
@@ -369,6 +379,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_vq_ready	= ifcvf_vdpa_get_vq_ready,
 	.set_vq_num	= ifcvf_vdpa_set_vq_num,
 	.set_vq_address	= ifcvf_vdpa_set_vq_address,
+	.get_vq_irq	= ifcvf_vdpa_get_vq_irq,
 	.kick_vq	= ifcvf_vdpa_kick_vq,
 	.get_generation	= ifcvf_vdpa_get_generation,
 	.get_device_id	= ifcvf_vdpa_get_device_id,
@@ -384,7 +395,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct device *dev = &pdev->dev;
 	struct ifcvf_adapter *adapter;
 	struct ifcvf_hw *vf;
-	int ret;
+	int ret, i;
 
 	ret = pcim_enable_device(pdev);
 	if (ret) {
@@ -441,6 +452,9 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err;
 	}
 
+	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
+		vf->vring[i].irq = -EINVAL;
+
 	ret = vdpa_register_device(&adapter->vdpa);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to register ifcvf to vdpa bus");
-- 
2.18.4

