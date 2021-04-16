Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29260361A7A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 09:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbhDPHWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 03:22:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:57485 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239271AbhDPHWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 03:22:23 -0400
IronPort-SDR: 1WvXt7qtPBC9EnBAf4RI/14ejcL/lGv7QzxTr2hMsfxtvB6uhOXrvX7UT/w9oRTWo5HUcjkCyk
 z+LNHs/9Fimw==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="194561101"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="194561101"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:21:59 -0700
IronPort-SDR: aEwE3dLl1P66Bo+toyXfqFYvzmp7sVdwQmxjgd0EDBNkngDcN4H+RnZBlsdb2PByMWW01Sftuz
 c6i+4e2GLSPw==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="425489790"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:21:54 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA
Date:   Fri, 16 Apr 2021 15:16:27 +0800
Message-Id: <20210416071628.4984-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210416071628.4984-1-lingshan.zhu@intel.com>
References: <20210416071628.4984-1-lingshan.zhu@intel.com>
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
 drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

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
index 469a9b5737b7..376b2014916a 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -168,10 +168,23 @@ static struct ifcvf_hw *vdpa_to_vf(struct vdpa_device *vdpa_dev)
 
 static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
 {
+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	struct pci_dev *pdev = adapter->pdev;
+
 	u64 features;
 
-	features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
+	switch (vf->dev_type) {
+	case VIRTIO_ID_NET:
+		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
+		break;
+	case VIRTIO_ID_BLOCK:
+		features = ifcvf_get_features(vf);
+		break;
+	default:
+		features = 0;
+		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
+	}
 
 	return features;
 }
@@ -517,6 +530,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
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

