Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFC349CA25
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbiAZM4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:56:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:29543 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241569AbiAZM4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:56:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643201777; x=1674737777;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rSwoLbyA72TP/SebBPb/0ufsRtBQVDEQqkekIksYfZQ=;
  b=cF2jhJz6PmL+Fy/QTD5jT3s/KDzAopqvdhkTHnEy28uTIXeByZni1oFL
   E1PUkr0tdfQlFkVrBrDtCml5ePgrCJHSbfKg82jk29hDB3KKPKuy5R7sq
   qVXCfA1zwlGSIquj10xJGa8wFT9fHmPsGGhRzvyZuVJC9o+xbSfMibZ+a
   8I9Ca9oAasQVe79eHniWPucg2itRiLBpZF3x0PoNy59vjh+w7WfYYAepG
   mUZ2VIY/bmJNlJnDoENY+agJqwOLTa7qma03e1H/OKMV2E0wv5sUOdmK3
   6DZ8NJ5ifWCwkRqKhYYTp9lYRKevkMVyRD9vU9/nWiyK5HdqGkYjmWRU4
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244141259"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="244141259"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:16 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="520783494"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:14 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 2/4] vDPA/ifcvf: implement device MSIX vector allocator
Date:   Wed, 26 Jan 2022 20:49:10 +0800
Message-Id: <20220126124912.90205-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126124912.90205-1-lingshan.zhu@intel.com>
References: <20220126124912.90205-1-lingshan.zhu@intel.com>
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

