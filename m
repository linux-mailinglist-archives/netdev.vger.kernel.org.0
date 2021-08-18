Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4D73F013C
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhHRKEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:04:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:28419 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233042AbhHRKEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 06:04:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="216327753"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="216327753"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 03:03:29 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="520889163"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.62])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 03:03:24 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/2] vDPA/ifcvf: enable multiqueue and control vq
Date:   Wed, 18 Aug 2021 17:57:14 +0800
Message-Id: <20210818095714.3220-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210818095714.3220-1-lingshan.zhu@intel.com>
References: <20210818095714.3220-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enbales multi-queue and control vq
features for ifcvf

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |  9 ---------
 drivers/vdpa/ifcvf/ifcvf_main.c | 11 +++--------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 97d9019a3ec0..09918af3ecf8 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -22,15 +22,6 @@
 #define N3000_DEVICE_ID		0x1041
 #define N3000_SUBSYS_DEVICE_ID	0x001A
 
-#define IFCVF_NET_SUPPORTED_FEATURES \
-		((1ULL << VIRTIO_NET_F_MAC)			| \
-		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
-		 (1ULL << VIRTIO_F_VERSION_1)			| \
-		 (1ULL << VIRTIO_NET_F_STATUS)			| \
-		 (1ULL << VIRTIO_F_ORDER_PLATFORM)		| \
-		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
-		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
-
 /* Max 8 data queue pairs(16 queues) and one control vq for now. */
 #define IFCVF_MAX_QUEUES	17
 
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index e34c2ec2b69b..b99283a98177 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -174,17 +174,12 @@ static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
 	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 	struct pci_dev *pdev = adapter->pdev;
-
+	u32 type = vf->dev_type;
 	u64 features;
 
-	switch (vf->dev_type) {
-	case VIRTIO_ID_NET:
-		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
-		break;
-	case VIRTIO_ID_BLOCK:
+	if (type == VIRTIO_ID_NET || type == VIRTIO_ID_BLOCK)
 		features = ifcvf_get_features(vf);
-		break;
-	default:
+	else {
 		features = 0;
 		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
 	}
-- 
2.27.0

