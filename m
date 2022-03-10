Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404604D41AF
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 08:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbiCJHWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 02:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239874AbiCJHV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 02:21:59 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8BD131118;
        Wed,  9 Mar 2022 23:20:58 -0800 (PST)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KDgR904vvzBrf7;
        Thu, 10 Mar 2022 15:19:01 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 15:20:57 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 15:20:56 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <mst@redhat.com>, <sgarzare@redhat.com>, <stefanha@redhat.com>,
        <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>, <gdawar@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH v2 2/2] vdpa: support exposing the count of vqs to userspace
Date:   Thu, 10 Mar 2022 15:20:51 +0800
Message-ID: <20220310072051.2175-3-longpeng2@huawei.com>
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

- GET_VQS_COUNT: the count of virtqueues that exposed

And change vdpa_device.nvqs and vhost_vdpa.nvqs to use u32.

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 drivers/vdpa/vdpa.c        |  6 +++---
 drivers/vhost/vdpa.c       | 23 +++++++++++++++++++----
 include/linux/vdpa.h       |  6 +++---
 include/uapi/linux/vhost.h |  3 +++
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 1ea5254..2b75c00 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -232,7 +232,7 @@ static int vdpa_name_match(struct device *dev, const void *data)
 	return (strcmp(dev_name(&vdev->dev), data) == 0);
 }
 
-static int __vdpa_register_device(struct vdpa_device *vdev, int nvqs)
+static int __vdpa_register_device(struct vdpa_device *vdev, u32 nvqs)
 {
 	struct device *dev;
 
@@ -257,7 +257,7 @@ static int __vdpa_register_device(struct vdpa_device *vdev, int nvqs)
  *
  * Return: Returns an error when fail to add device to vDPA bus
  */
-int _vdpa_register_device(struct vdpa_device *vdev, int nvqs)
+int _vdpa_register_device(struct vdpa_device *vdev, u32 nvqs)
 {
 	if (!vdev->mdev)
 		return -EINVAL;
@@ -274,7 +274,7 @@ int _vdpa_register_device(struct vdpa_device *vdev, int nvqs)
  *
  * Return: Returns an error when fail to add to vDPA bus
  */
-int vdpa_register_device(struct vdpa_device *vdev, int nvqs)
+int vdpa_register_device(struct vdpa_device *vdev, u32 nvqs)
 {
 	int err;
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 605c7ae..69b3f05 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -42,7 +42,7 @@ struct vhost_vdpa {
 	struct device dev;
 	struct cdev cdev;
 	atomic_t opened;
-	int nvqs;
+	u32 nvqs;
 	int virtio_id;
 	int minor;
 	struct eventfd_ctx *config_ctx;
@@ -158,7 +158,8 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	u8 status, status_old;
-	int ret, nvqs = v->nvqs;
+	u32 nvqs = v->nvqs;
+	int ret;
 	u16 i;
 
 	if (copy_from_user(&status, statusp, sizeof(status)))
@@ -369,6 +370,16 @@ static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
 	return 0;
 }
 
+static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+
+	if (copy_to_user(argp, &vdpa->nvqs, sizeof(vdpa->nvqs)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -509,6 +520,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_CONFIG_SIZE:
 		r = vhost_vdpa_get_config_size(v, argp);
 		break;
+	case VHOST_VDPA_GET_VQS_COUNT:
+		r = vhost_vdpa_get_vqs_count(v, argp);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
@@ -965,7 +979,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	struct vhost_vdpa *v;
 	struct vhost_dev *dev;
 	struct vhost_virtqueue **vqs;
-	int nvqs, i, r, opened;
+	int r, opened;
+	u32 i, nvqs;
 
 	v = container_of(inode->i_cdev, struct vhost_vdpa, cdev);
 
@@ -1018,7 +1033,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 static void vhost_vdpa_clean_irq(struct vhost_vdpa *v)
 {
-	int i;
+	u32 i;
 
 	for (i = 0; i < v->nvqs; i++)
 		vhost_vdpa_unsetup_vq_irq(v, i);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index a526919..8943a20 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -83,7 +83,7 @@ struct vdpa_device {
 	unsigned int index;
 	bool features_valid;
 	bool use_va;
-	int nvqs;
+	u32 nvqs;
 	struct vdpa_mgmt_dev *mdev;
 };
 
@@ -338,10 +338,10 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 				       dev_struct, member)), name, use_va), \
 				       dev_struct, member)
 
-int vdpa_register_device(struct vdpa_device *vdev, int nvqs);
+int vdpa_register_device(struct vdpa_device *vdev, u32 nvqs);
 void vdpa_unregister_device(struct vdpa_device *vdev);
 
-int _vdpa_register_device(struct vdpa_device *vdev, int nvqs);
+int _vdpa_register_device(struct vdpa_device *vdev, u32 nvqs);
 void _vdpa_unregister_device(struct vdpa_device *vdev);
 
 /**
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index bc74e95..5d99e7c 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -154,4 +154,7 @@
 /* Get the config size */
 #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
 
+/* Get the count of all virtqueues */
+#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
+
 #endif
-- 
1.8.3.1

