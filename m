Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C54849B081
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574396AbiAYJhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:37:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:43254 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1574019AbiAYJb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 04:31:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643103088; x=1674639088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/BarL4LjMS3Q++t6GST4rWeN1SsD5trpG6ZWkvycAl8=;
  b=lemRF52sy1QyMA0C5iLqsE7H6zy+h1tbYakZiHHmF8YnIHOjHKE7Ajlz
   iXZ8TSc3kAwSgM/ujZNj4bggXYABeSXOFB81SfoGh4zWQgCSvkvZH5VxG
   SMrwjcFyxavxzR7Cuw2/V75R+xKNqR6VRWifw2Y047YvPpj62NWTw2myq
   9OmHV11Igchx+0i/HgA2efCRW/EhkErIuF6PEk+chI8ZtpS9Ysk5QAlyU
   eH47wBigNtnUek6trUiUtmawkZZbv70II0DL8P9KN9+KXzKWb9rR3GBwU
   2Cxn7psW/8oqbFFvRUh0h3VrF5LBm/iVziGCpfc5Ms/ndxYRGlDLhTN/D
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="226240759"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="226240759"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:25:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="520318800"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:25:03 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 2/4] vDPA/ifcvf: implement device MSIX vector allocator
Date:   Tue, 25 Jan 2022 17:17:42 +0800
Message-Id: <20220125091744.115996-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220125091744.115996-1-lingshan.zhu@intel.com>
References: <20220125091744.115996-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements a MSIX vector allocation helper
for vqs and config interrupts.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index d1a6b5ab543c..7e2af2d2aaf5 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -58,14 +58,40 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
 	ifcvf_free_irq_vectors(pdev);
 }
 
+static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	u16 max_intr, ret;
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
 	int vector, i, ret, irq;
-	u16 max_intr;
+	u16 nvectors, max_intr;
+
+	nvectors = ifcvf_alloc_vectors(adapter);
+	if (!(nvectors > 0))
+		return nvectors;
 
-	/* all queues and config interrupt  */
 	max_intr = vf->nr_vring + 1;
 
 	ret = pci_alloc_irq_vectors(pdev, max_intr,
-- 
2.27.0

