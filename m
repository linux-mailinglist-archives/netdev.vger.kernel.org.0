Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39432488FCA
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbiAJF1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:27:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:9532 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238739AbiAJF1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:27:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792423; x=1673328423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C3u87lHKZw5KqrSIqgM7CnXVDqNPk+IDdddK2e/V1wU=;
  b=BQhGCpo6M0sguIeDY+uthCug6BFslDgoYjFArRkd7DbnHVODxzvOgF0/
   KY7vfb1nNI/u2UZS/H9B/jMLxqUtE7TJmyojj/XCL4IVS63TnbstO0fz8
   b8kBTdThIEHj8JF0AKnpdBPycSaG4LJ8s3nGMirbf4d+ZdNBUC41KzPN9
   neTb8+L/1uc0Z8imlhhreTtZJAwZlibPZK/aEZE3ACqtZXwOFPIlALN8t
   rtY+1n+DsyidP6oEKPSumSIz9efhVElN2Zzp6318EoPoZZJaNlt2fHn2w
   6dU9DcAoIB+0KXvlmMJ5vwJlw1jmVfyBJ5dcINmagKgVGaOksrireDiLJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479527"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479527"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:27:02 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="489892325"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:27:00 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 6/7] vDPA/ifcvf: implement config interrupt request helper
Date:   Mon, 10 Jan 2022 13:19:46 +0800
Message-Id: <20220110051947.84901-7-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110051947.84901-1-lingshan.zhu@intel.com>
References: <20220110051947.84901-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements new helper to request config interrupt by
a given MSIX vector.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |  6 ------
 drivers/vdpa/ifcvf/ifcvf_main.c | 26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index fc496d10cf8d..38f91dc6481f 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -330,12 +330,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 
 	ifcvf = vf_to_adapter(hw);
 	cfg = hw->common_cfg;
-	ifc_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
-
-	if (ifc_ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
-		IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\n");
-		return -EINVAL;
-	}
 
 	for (i = 0; i < hw->nr_vring; i++) {
 		if (!hw->vring[i].ready)
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ce2fbc429fbe..414b5dfd04ca 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -162,6 +162,32 @@ static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter, u8 vector_per_vq)
 	return ret;
 }
 
+static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter, int config_vector)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
+	int ret;
+
+	if (!config_vector) {
+		IFCVF_INFO(pdev, "No config interrupt because of no vectors\n");
+		vf->config_irq = -EINVAL;
+		return 0;
+	}
+
+	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
+		 pci_name(pdev));
+	vf->config_irq = pci_irq_vector(pdev, config_vector);
+	ret = devm_request_irq(&pdev->dev, vf->config_irq,
+			       ifcvf_config_changed, 0,
+			       vf->config_msix_name, vf);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to request config irq\n");
+		return ret;
+	}
+		ifcvf_set_config_vector(vf, config_vector);
+
+	return 0;
+}
 
 static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 {
-- 
2.27.0

