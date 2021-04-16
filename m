Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C56361A7D
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 09:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239519AbhDPHW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 03:22:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:57485 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239271AbhDPHW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 03:22:27 -0400
IronPort-SDR: nnHSKsVdR1aKfBTU8DYCPNDMeCMhO+U0YQ227D+R2pvenNL91sOJvl1yu6RMUY6ngJWtg4YYle
 AgxLeM9Lbqjg==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="194561115"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="194561115"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:22:03 -0700
IronPort-SDR: aEUdZ80edj3XHNnznvC+Sg6M6e6RqRDyhVnkOWA16iGpMx+g5D5441uXJLBCK+TtSIVq9zRqV5
 F0SAW4AN2t6g==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="425489818"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:21:59 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 3/3] vDPA/ifcvf: get_config_size should return dev specific config size
Date:   Fri, 16 Apr 2021 15:16:28 +0800
Message-Id: <20210416071628.4984-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210416071628.4984-1-lingshan.zhu@intel.com>
References: <20210416071628.4984-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_config_size() should return the size based on the decected
device type.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 376b2014916a..3b6f7862dbb8 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -356,7 +356,24 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
 
 static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
 {
-	return sizeof(struct virtio_net_config);
+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	struct pci_dev *pdev = adapter->pdev;
+	size_t size;
+
+	switch (vf->dev_type) {
+	case VIRTIO_ID_NET:
+		size = sizeof(struct virtio_net_config);
+		break;
+	case VIRTIO_ID_BLOCK:
+		size = sizeof(struct virtio_blk_config);
+		break;
+	default:
+		size = 0;
+		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
+	}
+
+	return size;
 }
 
 static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
-- 
2.27.0

