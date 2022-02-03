Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22914A7FE0
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 08:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348145AbiBCHe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 02:34:56 -0500
Received: from mga07.intel.com ([134.134.136.100]:32409 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349404AbiBCHey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 02:34:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643873694; x=1675409694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rSwoLbyA72TP/SebBPb/0ufsRtBQVDEQqkekIksYfZQ=;
  b=WgvvJlHrBt5kDbSFOA5tMZsR9er3QltHL3RLDYvqtlZHJfZCUMu0ZECn
   eEsbnN06KeP0HPmXR5LyvxYLOaab6+1iWgJD7hK5bATXWgWkoapp7UMnu
   mGTaetWT5A5tLuEOe3BI29IvRKNCeSDZmlWDcEhv429kd3AXtDhlnsgVP
   +FUwMw1b93/CIkhaKCWJharz/7YPJVeGsorrdi29Z13ZrgCGJt1Y8sYWh
   LSlT0gZIbq2Ao22KzlqiKhqEbuvNu2Q0VBx1zRbEGzc+H5GMXsNISR5aE
   ng9w6ew1xL3ycuW09g3FTAmTrWXbzfFr04skERyj6omGB0mt/fHjShy+T
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="311397576"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="311397576"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 23:34:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="771703686"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 23:34:52 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 2/4] vDPA/ifcvf: implement device MSIX vector allocator
Date:   Thu,  3 Feb 2022 15:27:33 +0800
Message-Id: <20220203072735.189716-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220203072735.189716-1-lingshan.zhu@intel.com>
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements a MSIX vector allocation helper
for vqs and config interrupts.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 35 +++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index d1a6b5ab543c..44c89ab0b6da 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -58,14 +58,45 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
 	ifcvf_free_irq_vectors(pdev);
 }
 
+/* ifcvf MSIX vectors allocator, this helper tries to allocate
+ * vectors for all virtqueues and the config interrupt.
+ * It returns the number of allocated vectors, negative
+ * return value when fails.
+ */
+static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int max_intr, ret;
+
+	/* all queues and config interrupt  */
+	max_intr = vf->nr_vring + 1;
+	ret = pci_alloc_irq_vectors(pdev, 1, max_intr, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+
+	if (ret < 0) {
+		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
+		return ret;
+	}
+
+	if (ret < max_intr)
+		IFCVF_INFO(pdev,
+			   "Requested %u vectors, however only %u allocated, lower performance\n",
+			   max_intr, ret);
+
+	return ret;
+}
+
 static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
-	int vector, i, ret, irq;
+	int vector, nvectors, i, ret, irq;
 	u16 max_intr;
 
-	/* all queues and config interrupt  */
+	nvectors = ifcvf_alloc_vectors(adapter);
+	if (!(nvectors > 0))
+		return nvectors;
+
 	max_intr = vf->nr_vring + 1;
 
 	ret = pci_alloc_irq_vectors(pdev, max_intr,
-- 
2.27.0

