Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147DA3806C9
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhENKF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:05:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:4949 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232968AbhENKFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 06:05:55 -0400
IronPort-SDR: LVKnD17mxU+qtpbfWtwyUQ2mRfEQicaYcU4M28pFQHcx7SQnTetu2RYWdNJdqblGSqvD8PZ3OW
 fGoxJAwQj/Lw==
X-IronPort-AV: E=McAfee;i="6200,9189,9983"; a="198195258"
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="198195258"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 03:04:44 -0700
IronPort-SDR: x4XG2Ek49QearfQP2tNfyFnPGfB7y1A9f5DDO4yeMwa+021/nrapZzwN+N0mCxN93YWEMrHQc9
 eGMwV6AOiXfA==
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="626910444"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 03:04:42 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
Date:   Fri, 14 May 2021 17:59:13 +0800
Message-Id: <20210514095913.41777-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210514095913.41777-1-lingshan.zhu@intel.com>
References: <20210514095913.41777-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements doorbell mapping feature for ifcvf.
This feature maps the notify page to userspace, to eliminate
vmexit when kick a vq.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ab0ab5cf0f6e..41c09437602d 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -413,6 +413,21 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
 	return vf->vring[qid].irq;
 }
 
+static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
+							       u16 idx)
+{
+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	struct pci_dev *pdev = adapter->pdev;
+	struct vdpa_notification_area area;
+
+	area.addr = vf->vring[idx].notify_pa;
+	area.size = PAGE_SIZE;
+	if (area.addr % PAGE_SIZE)
+		IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE aligned\n", idx);
+	return area;
+}
+
 /*
  * IFCVF currently does't have on-chip IOMMU, so not
  * implemented set_map()/dma_map()/dma_unmap()
@@ -440,6 +455,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_config	= ifcvf_vdpa_get_config,
 	.set_config	= ifcvf_vdpa_set_config,
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
+	.get_vq_notification = ifcvf_get_vq_notification,
 };
 
 static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
2.27.0

