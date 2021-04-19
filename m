Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49D1363BA2
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbhDSGjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:39:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:32762 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237214AbhDSGj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 02:39:29 -0400
IronPort-SDR: OGLaISLx6Yn2hDfCj0Yry9aDPRUQsUHLTbXWy9R/TsDFf0kHtXc8Nn655O39yK9Wh+dVhI8XQQ
 Pw9CTkGMcd/w==
X-IronPort-AV: E=McAfee;i="6200,9189,9958"; a="174766104"
X-IronPort-AV: E=Sophos;i="5.82,233,1613462400"; 
   d="scan'208";a="174766104"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 23:39:00 -0700
IronPort-SDR: wH9HZJ09KeG3XJL9rB96XhUZmwQUVyfP5DDpoOLbnjfZ4VZoGcBfhPofa/QOH2L+KAf+ZC0m3Z
 q4zpRNO/R7hA==
X-IronPort-AV: E=Sophos;i="5.82,233,1613462400"; 
   d="scan'208";a="523328560"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 23:38:58 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 3/3] vDPA/ifcvf: get_config_size should return dev specific config size
Date:   Mon, 19 Apr 2021 14:33:26 +0800
Message-Id: <20210419063326.3748-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210419063326.3748-1-lingshan.zhu@intel.com>
References: <20210419063326.3748-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_config_size() should return the size based on the decected
device type.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 9a4a6df91f08..e48e6b74fe2e 100644
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

