Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635AB32ED11
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 15:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhCEOZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 09:25:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:27033 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230424AbhCEOZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 09:25:33 -0500
IronPort-SDR: y6VpTttk8X87TxgQ5uNYyNh8qGUMMUt5vigZl0QbJcZonriKu1kHJKGCGVYPuTtZ/dCCOZwHIA
 uipTu2jEedVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="167555605"
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="167555605"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 06:25:32 -0800
IronPort-SDR: rZXrLbp1RBDOEctapPF+rx/mn3ybLmOJu5au/rvumThP/roD1ccH7QajI+bZvGU+yOic8k3FCZ
 U3w7qCgVBWTg==
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="408315662"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 06:25:30 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
Date:   Fri,  5 Mar 2021 22:19:59 +0800
Message-Id: <20210305142000.18521-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305142000.18521-1-lingshan.zhu@intel.com>
References: <20210305142000.18521-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-net
for vDPA.
C5000X-PL vendor id 0x1AF4, device id 0x1000,
subvendor id 0x8086, sub device id 0x0001

To distinguish C5000X-PL from other ifcvf driven devices,
the original ifcvf device is named "N3000".

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h | 13 +++++++++----
 drivers/vdpa/ifcvf/ifcvf_main.c | 13 +++++++++----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 64696d63fe07..794d1505d857 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -18,10 +18,15 @@
 #include <uapi/linux/virtio_config.h>
 #include <uapi/linux/virtio_pci.h>
 
-#define IFCVF_VENDOR_ID		0x1AF4
-#define IFCVF_DEVICE_ID		0x1041
-#define IFCVF_SUBSYS_VENDOR_ID	0x8086
-#define IFCVF_SUBSYS_DEVICE_ID	0x001A
+#define N3000_VENDOR_ID		0x1AF4
+#define N3000_DEVICE_ID		0x1041
+#define N3000_SUBSYS_VENDOR_ID	0x8086
+#define N3000_SUBSYS_DEVICE_ID	0x001A
+
+#define C5000X_PL_VENDOR_ID		0x1AF4
+#define C5000X_PL_DEVICE_ID		0x1000
+#define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
+#define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
 
 #define IFCVF_SUPPORTED_FEATURES \
 		((1ULL << VIRTIO_NET_F_MAC)			| \
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index e501ee07de17..fd5befc5cbcc 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -480,10 +480,15 @@ static void ifcvf_remove(struct pci_dev *pdev)
 }
 
 static struct pci_device_id ifcvf_pci_ids[] = {
-	{ PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
-		IFCVF_DEVICE_ID,
-		IFCVF_SUBSYS_VENDOR_ID,
-		IFCVF_SUBSYS_DEVICE_ID) },
+	{ PCI_DEVICE_SUB(N3000_VENDOR_ID,
+			 N3000_DEVICE_ID,
+			 N3000_SUBSYS_VENDOR_ID,
+			 N3000_SUBSYS_DEVICE_ID) },
+	{ PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
+			 C5000X_PL_DEVICE_ID,
+			 C5000X_PL_SUBSYS_VENDOR_ID,
+			 C5000X_PL_SUBSYS_DEVICE_ID) },
+
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
-- 
2.27.0

