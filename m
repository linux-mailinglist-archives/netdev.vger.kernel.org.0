Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C6C398471
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhFBIqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:46:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:27150 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230415AbhFBIqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 04:46:30 -0400
IronPort-SDR: VXA6gfFaGi6PT+8NrTA1NZTJ+a5/wuck80PpBvllkpwjAiBWg0u1S1++9yFYvhnCtkHyeqHfGa
 BHzswLW8isvw==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="183419592"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="183419592"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:44:48 -0700
IronPort-SDR: 4bDbYmEkng4Jyq2QaecZaQ6n9V9ta1/DHk5ubwCjSh8Ni8WUy21wiP1EqFfCEkudloiVxiTRrR
 SOxONV+JWElg==
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="479626585"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:44:46 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 1/2] vDPA/ifcvf: record virtio notify base
Date:   Wed,  2 Jun 2021 16:39:05 +0800
Message-Id: <20210602083906.289150-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210602083906.289150-1-lingshan.zhu@intel.com>
References: <20210602083906.289150-1-lingshan.zhu@intel.com>
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

