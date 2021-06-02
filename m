Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E72A398499
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhFBIxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:53:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:29880 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232852AbhFBIxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 04:53:36 -0400
IronPort-SDR: 8yc/Um/296r70J7jdjV5dxWG7SpcrZhYW3WRxW4xIoSE2zwRJWkMYjNqiIAtqb7br417yk2Bpr
 /vd5f7FXxr5w==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="289368388"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="289368388"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:51:54 -0700
IronPort-SDR: ei4V3d31jN+D2Qq/IdxgxhfomvQinCQg9UBA2Mn4PJ2rtIK5ixbH5EXHJd9lcNMtNfVrh4M2Yt
 zMhgKG8ViAUA==
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="479628292"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:51:51 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RESEND PATCH V4 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
Date:   Wed,  2 Jun 2021 16:45:50 +0800
Message-Id: <20210602084550.289599-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210602084550.289599-1-lingshan.zhu@intel.com>
References: <20210602084550.289599-1-lingshan.zhu@intel.com>
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
index ab0ab5cf0f6e..46a992eab3e5 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -413,6 +413,21 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
 	return vf->vring[qid].irq;
 }
 
+static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
+							       u16 idx)
+{
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	struct vdpa_notification_area area;
+
+	area.addr = vf->vring[idx].notify_pa;
+	if (!vf->notify_off_multiplier)
+		area.size = PAGE_SIZE;
+	else
+		area.size = vf->notify_off_multiplier;
+
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

