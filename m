Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB07398473
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhFBIqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:46:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:27150 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232755AbhFBIqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 04:46:33 -0400
IronPort-SDR: BR4piCboEXoWTSAz8XdTHBYERbMRF+SPWqo+jCwy0k3IHq8HP6hUH7Hvf4ebZPieIhhMAwiFnN
 rUKJxLbgBBiQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="183419600"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="183419600"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:44:50 -0700
IronPort-SDR: eUXwdQJ9nDYJKRmS5ZRryKvLvXWHDr3uAaQr02JTFG08Zv0IYfMH4cE4dvprEU9n1YLeArBgq+
 GTM5cxooWGcA==
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="479626593"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:44:48 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
Date:   Wed,  2 Jun 2021 16:39:06 +0800
Message-Id: <20210602083906.289150-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210602083906.289150-1-lingshan.zhu@intel.com>
References: <20210602083906.289150-1-lingshan.zhu@intel.com>
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
index ab0ab5cf0f6e..4f0b2e9973f0 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -413,6 +413,23 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
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
@@ -440,6 +457,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_config	= ifcvf_vdpa_get_config,
 	.set_config	= ifcvf_vdpa_set_config,
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
+	.get_vq_notification = ifcvf_get_vq_notification,
 };
 
 static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
2.27.0

