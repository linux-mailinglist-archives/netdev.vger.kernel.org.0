Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F6035F0C4
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350346AbhDNJYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:24:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:26135 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350278AbhDNJYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 05:24:33 -0400
IronPort-SDR: 1gamoEltVEOeC9yc18sbTKA9NC2z8g3BWxDF15fRxUZnSTLIojzYxUI1vLKJW7qneb/nPiTkMT
 W2hlh/7vuoAA==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="174709620"
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="174709620"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 02:24:11 -0700
IronPort-SDR: Z+lCQ2wpwHMYl9Ms9Fo0q5WnUi2F2x6tcWxAgSrwJ6QWzTjiuzgM9J23MPeqObhjGGhh0n5UZj
 0XbC13vOlfdQ==
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="424648494"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 02:24:08 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 3/3] vDPA/ifcvf: get_config_size should return dev specific config size
Date:   Wed, 14 Apr 2021 17:18:32 +0800
Message-Id: <20210414091832.5132-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210414091832.5132-1-lingshan.zhu@intel.com>
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_config_size() should return the size based on the decected
device type.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 9b6a38b798fa..b48b9789b69e 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -347,7 +347,16 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
 
 static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
 {
-	return sizeof(struct virtio_net_config);
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	size_t size;
+
+	if (vf->dev_type == VIRTIO_ID_NET)
+		size = sizeof(struct virtio_net_config);
+
+	if (vf->dev_type == VIRTIO_ID_BLOCK)
+		size = sizeof(struct virtio_blk_config);
+
+	return size;
 }
 
 static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
-- 
2.27.0

