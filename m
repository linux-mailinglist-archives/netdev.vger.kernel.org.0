Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D2E36065D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhDOJ7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:59:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:65315 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232294AbhDOJ71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 05:59:27 -0400
IronPort-SDR: JQ3u8krA8A+ayFzI4RMAF7KRbmoAaPBZCyb8UGh7yMne5eEXvmjWnTtp/EWxW1xFQJ//dxXy99
 BrFUSNzC6h1Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174321448"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174321448"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 02:59:04 -0700
IronPort-SDR: AptOkeCkx0s85LJH4TjZFNfA6zvizGwZ6gcGZdSPqAVxuz7Jhl2t0gjF59bMkolL3BBGabWYZy
 vOdRc4Ipknxg==
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425123484"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 02:59:01 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 3/3] vDPA/ifcvf: get_config_size should return dev specific config size
Date:   Thu, 15 Apr 2021 17:53:36 +0800
Message-Id: <20210415095336.4792-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210415095336.4792-1-lingshan.zhu@intel.com>
References: <20210415095336.4792-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_config_size() should return the size based on the decected
device type.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index cea1313b1a3f..6844c49fe1de 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -347,7 +347,23 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
 
 static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
 {
-	return sizeof(struct virtio_net_config);
+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	struct pci_dev *pdev = adapter->pdev;
+	size_t size;
+
+	if (vf->dev_type == VIRTIO_ID_NET)
+		size = sizeof(struct virtio_net_config);
+
+	else if (vf->dev_type == VIRTIO_ID_BLOCK)
+		size = sizeof(struct virtio_blk_config);
+
+	else {
+		size = 0;
+		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
+	}
+
+	return size;
 }
 
 static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
-- 
2.27.0

