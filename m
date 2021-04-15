Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DE436065A
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhDOJ71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:59:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:65315 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhDOJ7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 05:59:24 -0400
IronPort-SDR: aDVZPW7/K896FggHVS9g7ra/9LkdDpho6/j8vMaKLa40wxxCXPHZBitmXMXUyMoTqEHhWJrdG7
 BGrX1C9LTAOw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174321441"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174321441"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 02:59:01 -0700
IronPort-SDR: xfgMCm55iX6pNYnWFtkbXlDYrEv2OZmqGlclKC+Q9D15EzYjY2PMoYS7l8lANjtkhMUbT5MWkW
 2TSTDqs5EzFQ==
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425123466"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 02:58:59 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA
Date:   Thu, 15 Apr 2021 17:53:35 +0800
Message-Id: <20210415095336.4792-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210415095336.4792-1-lingshan.zhu@intel.com>
References: <20210415095336.4792-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
for vDPA.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |  8 +++++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 10 +++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 1c04cd256fa7..0111bfdeb342 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -15,6 +15,7 @@
 #include <linux/pci_regs.h>
 #include <linux/vdpa.h>
 #include <uapi/linux/virtio_net.h>
+#include <uapi/linux/virtio_blk.h>
 #include <uapi/linux/virtio_config.h>
 #include <uapi/linux/virtio_pci.h>
 
@@ -28,7 +29,12 @@
 #define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
 #define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
 
-#define IFCVF_SUPPORTED_FEATURES \
+#define C5000X_PL_BLK_VENDOR_ID		0x1AF4
+#define C5000X_PL_BLK_DEVICE_ID		0x1001
+#define C5000X_PL_BLK_SUBSYS_VENDOR_ID	0x8086
+#define C5000X_PL_BLK_SUBSYS_DEVICE_ID	0x0002
+
+#define IFCVF_NET_SUPPORTED_FEATURES \
 		((1ULL << VIRTIO_NET_F_MAC)			| \
 		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
 		 (1ULL << VIRTIO_F_VERSION_1)			| \
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 469a9b5737b7..cea1313b1a3f 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -171,7 +171,11 @@ static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 	u64 features;
 
-	features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
+	if (vf->dev_type == VIRTIO_ID_NET)
+		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
+
+	if (vf->dev_type == VIRTIO_ID_BLOCK)
+		features = ifcvf_get_features(vf);
 
 	return features;
 }
@@ -517,6 +521,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
 			 C5000X_PL_DEVICE_ID,
 			 C5000X_PL_SUBSYS_VENDOR_ID,
 			 C5000X_PL_SUBSYS_DEVICE_ID) },
+	{ PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
+			 C5000X_PL_BLK_DEVICE_ID,
+			 C5000X_PL_BLK_SUBSYS_VENDOR_ID,
+			 C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
 
 	{ 0 },
 };
-- 
2.27.0

