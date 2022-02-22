Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767304BF7B0
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 13:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbiBVMCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 07:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiBVMC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 07:02:29 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E0421818
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645531323; x=1677067323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9fQIDwBr2NvpIS534N3oB/rMt0UAWnSWZVgy1I2GBR8=;
  b=Q6euJ8+QLo5YNpSG1jeCbi6q0ATSZwzwiHsXGAykbGn/mSkVwjIdfz3t
   C8mxCstp634v5+j1TgmBpIJblh8buT/2W9Wjx5d++eRKTveE+xwVMftXM
   T6zlBfSO1e8+exG0dMdvMZb9jmJgy7pdSW00OqQtcH/tilD4zwvnT9mRy
   CYqDAHqHMLOMFFOk1SyIY8wEAplcAGT29TE6xEWPa+urUPSKulcGBrMEL
   dzI4rPmNvZTwFWp+NZ9xqiIvXVGCe21P8NI7qqJE71+hV5HknY4Apzvad
   2+WsmS/Kaco2cAU7Zdf+FL5Z5ugW400lcebdPiNKnHOJdSDrRwJp2qOyw
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="338117847"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="338117847"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 04:02:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="490772587"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 04:02:01 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V6 3/5] vDPA/ifcvf: implement device MSIX vector allocator
Date:   Tue, 22 Feb 2022 19:54:26 +0800
Message-Id: <20220222115428.998334-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220222115428.998334-1-lingshan.zhu@intel.com>
References: <20220222115428.998334-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements a MSIX vector allocation helper
for vqs and config interrupts.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 43b7180256c6..964f7ac142ba 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -58,23 +58,44 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
 	ifcvf_free_irq_vectors(pdev);
 }
 
-static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+/* ifcvf MSIX vectors allocator, this helper tries to allocate
+ * vectors for all virtqueues and the config interrupt.
+ * It returns the number of allocated vectors, negative
+ * return value when fails.
+ */
+static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct ifcvf_hw *vf = &adapter->vf;
-	int vector, i, ret, irq;
-	u16 max_intr;
+	int max_intr, ret;
 
 	/* all queues and config interrupt  */
 	max_intr = vf->nr_vring + 1;
+	ret = pci_alloc_irq_vectors(pdev, 1, max_intr, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
 
-	ret = pci_alloc_irq_vectors(pdev, max_intr,
-				    max_intr, PCI_IRQ_MSIX);
 	if (ret < 0) {
 		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
 		return ret;
 	}
 
+	if (ret < max_intr)
+		IFCVF_INFO(pdev,
+			   "Requested %u vectors, however only %u allocated, lower performance\n",
+			   max_intr, ret);
+
+	return ret;
+}
+
+static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int vector, nvectors, i, ret, irq;
+
+	nvectors = ifcvf_alloc_vectors(adapter);
+	if (nvectors <= 0)
+		return -EFAULT;
+
 	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
 		 pci_name(pdev));
 	vector = 0;
-- 
2.27.0

