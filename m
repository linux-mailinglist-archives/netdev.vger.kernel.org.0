Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0194E3806C6
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhENKF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:05:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:4949 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232800AbhENKFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 06:05:53 -0400
IronPort-SDR: z0S/FA/v/p8vZbUYlCluivB3qonxbG9eilKDqHKLZXkidr7U7dQyHTumbUKGKMIRRcxZvNiOD7
 COXCKp5/oaTw==
X-IronPort-AV: E=McAfee;i="6200,9189,9983"; a="198195255"
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="198195255"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 03:04:42 -0700
IronPort-SDR: Os7nvULX0grsqC960ZtdHLoskEzG0z4vyNYpLl7H98YLmerkKXa1c+M6gPUGZxgHgQG5pA1yt1
 xQc9H7ECk3Qw==
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="626910435"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 03:04:41 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 1/2] vDPA/ifcvf: record virtio notify base
Date:   Fri, 14 May 2021 17:59:12 +0800
Message-Id: <20210514095913.41777-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210514095913.41777-1-lingshan.zhu@intel.com>
References: <20210514095913.41777-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit records virtio notify base physical addr and
calculate doorbell physical address for vqs.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
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

