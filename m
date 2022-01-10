Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86F7488FBE
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbiAJF0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:26:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:9482 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238702AbiAJF0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:26:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792360; x=1673328360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ioRk7cwXbBNQJIQEP8s7EVvCPiqFelLbAYEXA+lwOtU=;
  b=auwwcIBXe32HxSljfPQggG8SD/ZTHI6fmv/7vUo1aqgp6zH2ZxQ4xxee
   8Kf73Q+89ULb/yS7fowTSJbMMSpz1dbm23hT9p0hvv5pipetw3iYDnXoc
   2SKhfy8D23hUKxNyd7KwNFagF7c88PnwYWnbWqY9E1eJLYZ/m2TpAYFw8
   ng/i3AO8tAJS0hajEoZmCJ11zLYvlWtnt+vPi0iaDHrQSJOPDDcEABhQm
   Y2dQnfD4bjQW/xIaxWJtML0BJUyZZt+e0Ag+yCkBE41dY3YtKNTbNhHXU
   BYMI3OMbQ0v5UzRtiUC/6bwicsbL+TXPm6bjyMV3ktsSayUK7YYSbU8TP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479403"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479403"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:00 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="622559774"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:25:59 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 3/7] vDPA/ifcvf: implement device MSIX vector allocation helper
Date:   Mon, 10 Jan 2022 13:18:47 +0800
Message-Id: <20220110051851.84807-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110051851.84807-1-lingshan.zhu@intel.com>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements a MSIX vector allocation helper

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 6dc75ca70b37..64fc78eaa1a9 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -58,6 +58,30 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
 	ifcvf_free_irq_vectors(pdev);
 }
 
+static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	u16 max_intr = 0;
+	u16 ret = 0;
+
+	/* all queues and config interrupt  */
+	max_intr = vf->nr_vring + 1;
+	ret = pci_alloc_irq_vectors(pdev, 1, max_intr, PCI_IRQ_MSIX|PCI_IRQ_AFFINITY);
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
-- 
2.27.0

