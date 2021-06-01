Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56794396D6B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 08:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhFAGgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 02:36:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:35631 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhFAGgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 02:36:14 -0400
IronPort-SDR: 91KIK59/M1LRNK/3tZxQkllBvGKG+PaJ5t7AuWod82FOfOY4ccyzpbGu4bk4NR3GFKLtBa/4/P
 eiWA1gw/EfWQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267361150"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267361150"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 23:34:33 -0700
IronPort-SDR: N8QGlVauSPU46wudV08MV7CUmBMQI7zFzfF3ys80T0NGH7FiTphBHDT5eibx4HUpOrXpDYDp1T
 DrTWY73BiJZA==
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="446839328"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 23:34:30 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
Date:   Tue,  1 Jun 2021 14:28:50 +0800
Message-Id: <20210601062850.4547-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210601062850.4547-1-lingshan.zhu@intel.com>
References: <20210601062850.4547-1-lingshan.zhu@intel.com>
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
 drivers/vdpa/ifcvf/ifcvf_main.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ab0ab5cf0f6e..d41db042612c 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -413,6 +413,26 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
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
+	if (area.addr % PAGE_SIZE)
+		IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE aligned\n", idx);
+
+	return area;
+}
+
 /*
  * IFCVF currently does't have on-chip IOMMU, so not
  * implemented set_map()/dma_map()/dma_unmap()
@@ -440,6 +460,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_config	= ifcvf_vdpa_get_config,
 	.set_config	= ifcvf_vdpa_set_config,
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
+	.get_vq_notification = ifcvf_get_vq_notification,
 };
 
 static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
2.27.0

