Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18D34904E8
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiAQJ3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 04:29:38 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:31098 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235737AbiAQJ3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 04:29:32 -0500
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JcmjS3ZX2z1FClV;
        Mon, 17 Jan 2022 17:25:48 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 17 Jan 2022 17:29:31 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 17 Jan 2022 17:29:30 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>, <sgarzare@redhat.com>,
        <stefanha@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>, Longpeng <longpeng2@huawei.com>
Subject: [RFC 2/3] vdpa: support exposing the count of vqs to userspace
Date:   Mon, 17 Jan 2022 17:29:20 +0800
Message-ID: <20220117092921.1573-3-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20220117092921.1573-1-longpeng2@huawei.com>
References: <20220117092921.1573-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

- GET_VQS_COUNT: the count of virtqueues that exposed

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 drivers/vhost/vdpa.c       | 13 +++++++++++++
 include/uapi/linux/vhost.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 1eea14a4ea56..c1074278fc6b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -369,6 +369,16 @@ static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
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
@@ -509,6 +519,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_CONFIG_SIZE:
 		r = vhost_vdpa_get_config_size(v, argp);
 		break;
+	case VHOST_VDPA_GET_VQS_COUNT:
+		r = vhost_vdpa_get_vqs_count(v, argp);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index bc74e95a273a..5d99e7c242a2 100644
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
2.23.0

