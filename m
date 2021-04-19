Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8779B363B9F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbhDSGjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:39:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:32762 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237333AbhDSGj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 02:39:27 -0400
IronPort-SDR: jEwma3yMuU6JddU1++B4+0yu20YVO9/Dsg5BXqD9d+amb5lKtDtPoPhJn6DdSDIh018QWuLdL2
 7GSZbXNb0DbQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9958"; a="174766099"
X-IronPort-AV: E=Sophos;i="5.82,233,1613462400"; 
   d="scan'208";a="174766099"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 23:38:58 -0700
IronPort-SDR: CSXiDEOhDz6OgR2Lqzqgm0VFS1cRn7K1u7bFJ2FJJJvBHr/fAGcoMdxwlHtR5WFbMBlA3H12Hf
 hF/E9OUGf5Zg==
X-IronPort-AV: E=Sophos;i="5.82,233,1613462400"; 
   d="scan'208";a="523328547"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 23:38:55 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA
Date:   Mon, 19 Apr 2021 14:33:25 +0800
Message-Id: <20210419063326.3748-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210419063326.3748-1-lingshan.zhu@intel.com>
References: <20210419063326.3748-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
for vDPA.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
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
index 66927ec81fa5..9a4a6df91f08 100644
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
@@ -514,6 +527,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
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

