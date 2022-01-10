Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468BD488FC6
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238743AbiAJF1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:27:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:9532 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238715AbiAJF0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:26:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792415; x=1673328415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SkK3KJA5kuRSaw0A/VhI97frWfNhCA3kJuBS59qfbO8=;
  b=nertf6DbHtSoFadCrFfaGCzoPd8dgZwe67Jf9M0jOeREXBzPMQHIrrw/
   dt5zyPArL3cy0U6v9J7nI06C0zDjTvkcMkQ00hTxoSj8yy/nG9k+gdXZW
   bBYeSwz0ZYnh/Aq7SsEgoRp3MzlpZcMcFoepyQnB7mgsragcowV3pSJWC
   6t7LVwZUWml+hwP8i/4oE49BONuNdXM3UZLcg0CHuYbAWKrTrjKHsNBkR
   8UgDCwKn5Bzu8qLF8CgKVe+5TW6txwnG/W9tE1BpgE3FGZqXJUpvX6PFE
   50lZhpLt8c7vgtee1n5Q/UcFsNa+xu5InSbwyc65gsyBw9JQ7D0lKjafQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479497"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479497"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="489892276"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:53 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/7] vDPA/ifcvf: introduce new helpers to set config vector and vq vectors
Date:   Mon, 10 Jan 2022 13:19:42 +0800
Message-Id: <20220110051947.84901-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110051947.84901-1-lingshan.zhu@intel.com>
References: <20220110051947.84901-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces new helpers to set config vector
and vq vectors in virtio common config space.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 30 ++++++++++++++++++++++++++++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 0b5df4cfaf06..696a41560eaa 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -15,6 +15,36 @@ struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
 	return container_of(hw, struct ifcvf_adapter, vf);
 }
 
+int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
+
+	ifc_iowrite16(qid, &cfg->queue_select);
+	ifc_iowrite16(vector, &cfg->queue_msix_vector);
+	if (ifc_ioread16(&cfg->queue_msix_vector) == VIRTIO_MSI_NO_VECTOR) {
+		IFCVF_ERR(ifcvf->pdev, "No msix vector for queue %u\n", qid);
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
+
+	cfg = hw->common_cfg;
+	ifc_iowrite16(vector,  &cfg->msix_config);
+	if (ifc_ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
+		IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
 				  struct virtio_pci_cap *cap)
 {
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index c924a7673afb..1d5431040d7d 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -157,4 +157,6 @@ u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
 int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
 int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
+int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector);
+int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
 #endif /* _IFCVF_H_ */
-- 
2.27.0

