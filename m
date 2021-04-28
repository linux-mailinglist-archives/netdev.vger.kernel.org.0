Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912DB36D3EC
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbhD1I1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:27:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:7991 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231635AbhD1I1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 04:27:44 -0400
IronPort-SDR: 2zKtKa8S+oFbtnM2IwuXLgHv9V3XXQn3pNz3czSLjsEU69JDM1PljUhMfJd7yeZh0Z0A4jdY3j
 6GtUKV3tZaIw==
X-IronPort-AV: E=McAfee;i="6200,9189,9967"; a="194573424"
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="194573424"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 01:26:59 -0700
IronPort-SDR: qF1yCpea3G+3k0EktqFIR0vwPr4mAoOu/4FPz7HSdbKMJoN2jdxgk3Hi++L/vcBgvGia0r+Isb
 D9KQ0yksG7rw==
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="430192243"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 01:26:57 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/2] vDPA/ifcvf: record virtio notify base
Date:   Wed, 28 Apr 2021 16:21:32 +0800
Message-Id: <20210428082133.6766-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428082133.6766-1-lingshan.zhu@intel.com>
References: <20210428082133.6766-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit records virtio notify base addr to implemente
doorbell mapping feature

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 1 +
 drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 1a661ab45af5..cc61a5bfc5b1 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -133,6 +133,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 					      &hw->notify_off_multiplier);
 			hw->notify_bar = cap.bar;
 			hw->notify_base = get_cap_addr(hw, &cap);
+			hw->notify_pa = pci_resource_start(pdev, cap.bar) + cap.offset;
 			IFCVF_DBG(pdev, "hw->notify_base = %p\n",
 				  hw->notify_base);
 			break;
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 0111bfdeb342..bcca7c1669dd 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -98,6 +98,7 @@ struct ifcvf_hw {
 	char config_msix_name[256];
 	struct vdpa_callback config_cb;
 	unsigned int config_irq;
+	phys_addr_t  notify_pa;
 };
 
 struct ifcvf_adapter {
-- 
2.27.0

