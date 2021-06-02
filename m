Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6154F398497
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhFBIxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:53:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:29880 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232852AbhFBIxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 04:53:33 -0400
IronPort-SDR: /WKyteKSNArsSBRwc+z8XtRQ9gSCUjAjpR5Udd9O2KUyZ2WiiPcY4odCIKPBD15nLlp5HI5NBX
 mPmSIMBPZDdg==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="289368382"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="289368382"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:51:51 -0700
IronPort-SDR: HQk58lqDtJOfKXMsE3ahfoPzWHseHV3X52lOfpUm+n/cv14OWLB6BsDMZ2b4uvUoZRpX5ce+sV
 QROKaL0rbCNQ==
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="479628287"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:51:49 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RESEND PATCH V4 1/2] vDPA/ifcvf: record virtio notify base
Date:   Wed,  2 Jun 2021 16:45:49 +0800
Message-Id: <20210602084550.289599-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210602084550.289599-1-lingshan.zhu@intel.com>
References: <20210602084550.289599-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit records virtio notify base physical addr and
calculate doorbell physical address for vqs.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 4 ++++
 drivers/vdpa/ifcvf/ifcvf_base.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 1a661ab45af5..6e197fe0fcf9 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -133,6 +133,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 					      &hw->notify_off_multiplier);
 			hw->notify_bar = cap.bar;
 			hw->notify_base = get_cap_addr(hw, &cap);
+			hw->notify_base_pa = pci_resource_start(pdev, cap.bar) +
+					le32_to_cpu(cap.offset);
 			IFCVF_DBG(pdev, "hw->notify_base = %p\n",
 				  hw->notify_base);
 			break;
@@ -161,6 +163,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 		notify_off = ifc_ioread16(&hw->common_cfg->queue_notify_off);
 		hw->vring[i].notify_addr = hw->notify_base +
 			notify_off * hw->notify_off_multiplier;
+		hw->vring[i].notify_pa = hw->notify_base_pa +
+			notify_off * hw->notify_off_multiplier;
 	}
 
 	hw->lm_cfg = hw->base[IFCVF_LM_BAR];
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 0111bfdeb342..447f4ad9c0bf 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -73,6 +73,7 @@ struct vring_info {
 	u16 last_avail_idx;
 	bool ready;
 	void __iomem *notify_addr;
+	phys_addr_t notify_pa;
 	u32 irq;
 	struct vdpa_callback cb;
 	char msix_name[256];
@@ -87,6 +88,7 @@ struct ifcvf_hw {
 	u8 notify_bar;
 	/* Notificaiton bar address */
 	void __iomem *notify_base;
+	phys_addr_t notify_base_pa;
 	u32 notify_off_multiplier;
 	u64 req_features;
 	u64 hw_features;
-- 
2.27.0

