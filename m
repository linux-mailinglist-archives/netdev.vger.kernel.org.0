Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00FEB4513
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 03:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390703AbfIQBFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 21:05:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:34819 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbfIQBFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 21:05:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 18:05:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,514,1559545200"; 
   d="scan'208";a="180611948"
Received: from dpdk-virtio-tbie-2.sh.intel.com ([10.67.104.71])
  by orsmga008.jf.intel.com with ESMTP; 16 Sep 2019 18:04:58 -0700
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com, tiwei.bie@intel.com
Subject: [RFC v4 1/3] vfio: support getting vfio device from device fd
Date:   Tue, 17 Sep 2019 09:02:02 +0800
Message-Id: <20190917010204.30376-2-tiwei.bie@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190917010204.30376-1-tiwei.bie@intel.com>
References: <20190917010204.30376-1-tiwei.bie@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the support for getting VFIO device
from VFIO device fd. With this support, it's possible for
vhost to get VFIO device from the group fd and device fd
set by the userspace.

Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
---
 drivers/vfio/vfio.c  | 25 +++++++++++++++++++++++++
 include/linux/vfio.h |  4 ++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 388597930b64..697fd079bb3f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -890,6 +890,31 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 	return device;
 }
 
+struct vfio_device *vfio_device_get_from_fd(struct vfio_group *group,
+					    int device_fd)
+{
+	struct fd f;
+	struct vfio_device *it, *device = ERR_PTR(-ENODEV);
+
+	f = fdget(device_fd);
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+
+	mutex_lock(&group->device_lock);
+	list_for_each_entry(it, &group->device_list, group_next) {
+		if (it == f.file->private_data) {
+			device = it;
+			vfio_device_get(device);
+			break;
+		}
+	}
+	mutex_unlock(&group->device_lock);
+
+	fdput(f);
+	return device;
+}
+EXPORT_SYMBOL_GPL(vfio_device_get_from_fd);
+
 /*
  * Caller must hold a reference to the vfio_device
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e42a711a2800..e75b24fd7c5c 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -15,6 +15,8 @@
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
+struct vfio_group;
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
@@ -50,6 +52,8 @@ extern int vfio_add_group_dev(struct device *dev,
 
 extern void *vfio_del_group_dev(struct device *dev);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
+extern struct vfio_device *vfio_device_get_from_fd(struct vfio_group *group,
+						   int device_fd);
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
 
-- 
2.17.1

