Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5084D41AD
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 08:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240018AbiCJHWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 02:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239869AbiCJHV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 02:21:59 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694C9D4455;
        Wed,  9 Mar 2022 23:20:58 -0800 (PST)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KDgRn0BK6zfYpy;
        Thu, 10 Mar 2022 15:19:33 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 15:20:56 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 15:20:55 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <mst@redhat.com>, <sgarzare@redhat.com>, <stefanha@redhat.com>,
        <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>, <gdawar@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH v2 1/2] vdpa: support exposing the config size to userspace
Date:   Thu, 10 Mar 2022 15:20:50 +0800
Message-ID: <20220310072051.2175-2-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20220310072051.2175-1-longpeng2@huawei.com>
References: <20220310072051.2175-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

- GET_CONFIG_SIZE: return the size of the virtio config space.

The size contains the fields which are conditional on feature
bits.

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 drivers/vhost/vdpa.c       | 17 +++++++++++++++++
 include/linux/vdpa.h       |  3 ++-
 include/uapi/linux/vhost.h |  4 ++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec5249e..605c7ae 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -355,6 +355,20 @@ static long vhost_vdpa_get_iova_range(struct vhost_vdpa *v, u32 __user *argp)
 	return 0;
 }
 
+static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+	u32 size;
+
+	size = ops->get_config_size(vdpa);
+
+	if (copy_to_user(argp, &size, sizeof(size)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -492,6 +506,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_IOVA_RANGE:
 		r = vhost_vdpa_get_iova_range(v, argp);
 		break;
+	case VHOST_VDPA_GET_CONFIG_SIZE:
+		r = vhost_vdpa_get_config_size(v, argp);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 721089b..a526919 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -207,7 +207,8 @@ struct vdpa_map_file {
  * @reset:			Reset device
  *				@vdev: vdpa device
  *				Returns integer: success (0) or error (< 0)
- * @get_config_size:		Get the size of the configuration space
+ * @get_config_size:		Get the size of the configuration space includes
+ *				fields that are conditional on feature bits.
  *				@vdev: vdpa device
  *				Returns size_t: configuration size
  * @get_config:			Read from device specific configuration space
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860..bc74e95 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -150,4 +150,8 @@
 /* Get the valid iova range */
 #define VHOST_VDPA_GET_IOVA_RANGE	_IOR(VHOST_VIRTIO, 0x78, \
 					     struct vhost_vdpa_iova_range)
+
+/* Get the config size */
+#define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
+
 #endif
-- 
1.8.3.1

