Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AC7488FC0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbiAJF0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:26:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:9482 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238715AbiAJF0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:26:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792364; x=1673328364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vwEflBjEi/Ibz5v2X+ulh3NV9ceFr49WwWhf2QgLebY=;
  b=b3vHsfw7vI8HbsIcWCDgN5ZcaMVdmVu1QyABkd+ckPK0uFRPaQep08yu
   gBziE3G4svav9H34rHQCn/Syinv2W8W3UO6k72NyQ5baJqBKme4M33yKq
   OoEab61PQtTp3f0i1WzxEUMA/WDdlhbgJejmUOZDX9Fr4ddF9JdPx6oUF
   K0x6UaSRldkveRvMGi7crFK8r+lNCgWfm4hiE/w9Bxjve9h6kTtlP1xVP
   +pLhhl7K0PyOGgJwvWVnHUG0qiMrJbyYEZl2CDrEiFz4Btc3S/jQcOxeE
   Odc/jgBaXBRLReFMHphe3pphsA/Uppu9eH8Uu5C6WNuKrGj55xZGb/xtN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479408"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479408"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="622559812"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:02 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 5/7] vDPA/ifcvf: irq request helpers for both shared and per_vq irq
Date:   Mon, 10 Jan 2022 13:18:49 +0800
Message-Id: <20220110051851.84807-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110051851.84807-1-lingshan.zhu@intel.com>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements new irq request helpers:
ifcvf_request_shared_vq_irq() for a shared irq, in this case,
all virtqueues would share one irq/vector. This can help the
device work on some platforms that can not provide enough
MSIX vectors

ifcvf_request_per_vq_irq() for per vq irqs, in this case,
every virtqueue has its own irq/vector

ifcvf_request_vq_irq() calls either of the above two, depends on
the number of allocated vectors.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |  9 -----
 drivers/vdpa/ifcvf/ifcvf_main.c | 66 +++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 696a41560eaa..fc496d10cf8d 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -349,15 +349,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
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
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 19e1d1cd71a3..ce2fbc429fbe 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -97,6 +97,72 @@ static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
 	return ret;
 }
 
+static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int i, vector, ret, irq;
+
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
+			ifcvf_free_irq(adapter, i);
+		} else {
+			vf->vring[i].irq = irq;
+			ifcvf_set_vq_vector(vf, i, vector);
+		}
+	}
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
+	irq = pci_irq_vector(pdev, vector);
+	ret = devm_request_irq(&pdev->dev, irq,
+			       ifcvf_shared_intr_handler, 0,
+			       "ifcvf_shared_irq",
+			       vf);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to request shared irq for vf\n");
+
+		return ret;
+	}
+
+	for (i = 0; i < vf->nr_vring; i++) {
+		vf->vring[i].irq = irq;
+		ifcvf_set_vq_vector(vf, i, vector);
+	}
+
+	return 0;
+
+}
+
+static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter, u8 vector_per_vq)
+{
+	int ret;
+
+	if (vector_per_vq)
+		ret = ifcvf_request_per_vq_irq(adapter);
+	else
+		ret = ifcvf_request_shared_vq_irq(adapter);
+
+	return ret;
+}
+
+
 static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
-- 
2.27.0

