Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3BA35F0C3
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350325AbhDNJYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:24:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:26135 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348698AbhDNJY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 05:24:29 -0400
IronPort-SDR: LnV2rzYkcCFsgAzfVh7CETP0evYJVX8sEAkMN+qQTNJhunUH9KgNZRSNl56FDo3khxQifF1zfd
 3P9Hpq4+146w==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="174709611"
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="174709611"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 02:24:08 -0700
IronPort-SDR: FnRRq6L3gRk3Auawzws+8SRx6P5dR0jGKMsHTu2nqQMHity/KuenDtuV4LwdXFb5hSzpgivqPa
 HItbTFFjBpdg==
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="424648471"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 02:24:05 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA
Date:   Wed, 14 Apr 2021 17:18:31 +0800
Message-Id: <20210414091832.5132-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210414091832.5132-1-lingshan.zhu@intel.com>
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
for vDPA.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h | 17 ++++++++++++++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 10 +++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 1c04cd256fa7..8b403522bf06 100644
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
@@ -37,6 +43,15 @@
 		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
 		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
 
+#define IFCVF_BLK_SUPPORTED_FEATURES \
+		((1ULL << VIRTIO_BLK_F_SIZE_MAX)		| \
+		 (1ULL << VIRTIO_BLK_F_SEG_MAX)			| \
+		 (1ULL << VIRTIO_BLK_F_BLK_SIZE)		| \
+		 (1ULL << VIRTIO_BLK_F_TOPOLOGY)		| \
+		 (1ULL << VIRTIO_BLK_F_MQ)			| \
+		 (1ULL << VIRTIO_F_VERSION_1)			| \
+		 (1ULL << VIRTIO_F_ACCESS_PLATFORM))
+
 /* Only one queue pair for now. */
 #define IFCVF_MAX_QUEUE_PAIRS	1
 
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 99b0a6b4c227..9b6a38b798fa 100644
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
+		features = ifcvf_get_features(vf) & IFCVF_BLK_SUPPORTED_FEATURES;
 
 	return features;
 }
@@ -509,6 +513,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
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

