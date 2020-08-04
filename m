Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5887423B8B9
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgHDKZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:25:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:29375 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgHDKZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 06:25:25 -0400
IronPort-SDR: B93MxYmO4K3WeJ3o2QVOa8Bdk9By1tAfxEQft+BTVuQy1ki8fi0L3g615Rh2USfv9ysIw+v1S5
 6jIQoyyp/DAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="237146609"
X-IronPort-AV: E=Sophos;i="5.75,433,1589266800"; 
   d="scan'208";a="237146609"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 03:25:25 -0700
IronPort-SDR: /0RVEfgju9VaF9xmo8ygzfV/HOYmfFaIf2GRKeBWFsOMbiohTJlfu1lhlD65XmfvJziaMnydV3
 Nv3Gendtu4qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,433,1589266800"; 
   d="scan'208";a="330560245"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Aug 2020 03:25:23 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH] vDPA: dont change vq irq after DRIVER_OK
Date:   Tue,  4 Aug 2020 18:21:23 +0800
Message-Id: <20200804102123.69978-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IRQ of a vq is not expected to be changed in a DRIVER_OK ~ !DRIVER_OK
period for irq offloading purposes. Place this comment at the side of
bus ops get_vq_irq than in set_status in vhost_vdpa.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/vdpa.c | 1 -
 include/linux/vdpa.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 278ea2f00172..26f166a8192e 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -222,7 +222,6 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 
 	ops->set_status(vdpa, status);
 
-	/* vq irq is not expected to be changed once DRIVER_OK is set */
 	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) && !(status_old & VIRTIO_CONFIG_S_DRIVER_OK))
 		for (i = 0; i < nvqs; i++)
 			vhost_vdpa_setup_vq_irq(v, i);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index ba898486f2c7..03aa9f77f192 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -183,6 +183,7 @@ struct vdpa_config_ops {
 	u64 (*get_vq_state)(struct vdpa_device *vdev, u16 idx);
 	struct vdpa_notification_area
 	(*get_vq_notification)(struct vdpa_device *vdev, u16 idx);
+	/* vq irq is not expected to be changed once DRIVER_OK is set */
 	int (*get_vq_irq)(struct vdpa_device *vdv, u16 idx);
 
 	/* Device ops */
-- 
2.18.4

