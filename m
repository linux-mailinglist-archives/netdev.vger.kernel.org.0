Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346CA36D3EE
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237677AbhD1I1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:27:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:7991 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231635AbhD1I1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 04:27:46 -0400
IronPort-SDR: qDy/ROmfXerGipvHRgdyTvxz3wCG5nI8sToAqdH7YPPnyox4Z1Grp3Z1AAsDzVxCc9TMSbuSFQ
 0JVUz9ze0eww==
X-IronPort-AV: E=McAfee;i="6200,9189,9967"; a="194573427"
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="194573427"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 01:27:02 -0700
IronPort-SDR: pEieoWPS439dCUpyUuZKXm1DshukFKzgSi+hhDVT3w21b8a+JXdIEe5AMuK9bHNhSEoA8Puo8o
 BTZZhWXslXbg==
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="430192264"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 01:26:59 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
Date:   Wed, 28 Apr 2021 16:21:33 +0800
Message-Id: <20210428082133.6766-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428082133.6766-1-lingshan.zhu@intel.com>
References: <20210428082133.6766-1-lingshan.zhu@intel.com>
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
 drivers/vdpa/ifcvf/ifcvf_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index e48e6b74fe2e..afcb71bc0f51 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -413,6 +413,23 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
 	return vf->vring[qid].irq;
 }
 
+static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
+							       u16 idx)
+{
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	struct vdpa_notification_area area;
+
+	if (vf->notify_pa % PAGE_SIZE) {
+		area.addr = 0;
+		area.size = 0;
+	} else {
+		area.addr = vf->notify_pa;
+		area.size = PAGE_SIZE;
+	}
+
+	return area;
+}
+
 /*
  * IFCVF currently does't have on-chip IOMMU, so not
  * implemented set_map()/dma_map()/dma_unmap()
@@ -440,6 +457,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_config	= ifcvf_vdpa_get_config,
 	.set_config	= ifcvf_vdpa_set_config,
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
+	.get_vq_notification = ifcvf_get_vq_notification,
 };
 
 static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
2.27.0

