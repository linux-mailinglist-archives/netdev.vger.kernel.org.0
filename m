Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BF14D9304
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 04:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344670AbiCOD1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 23:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344654AbiCOD1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 23:27:14 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6444D4888B;
        Mon, 14 Mar 2022 20:26:03 -0700 (PDT)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KHdxf3K1Qz9sh2;
        Tue, 15 Mar 2022 11:22:14 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:26:01 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:26:00 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <stefanha@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
        <sgarzare@redhat.com>
CC:     <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH v2 3/3] vdpa: support exposing the count of vqs to userspace
Date:   Tue, 15 Mar 2022 11:25:53 +0800
Message-ID: <20220315032553.455-4-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20220315032553.455-1-longpeng2@huawei.com>
References: <20220315032553.455-1-longpeng2@huawei.com>
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

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 drivers/vhost/vdpa.c       | 13 +++++++++++++
 include/uapi/linux/vhost.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 0c82eb5..69b3f05 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -370,6 +370,16 @@ static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
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
@@ -510,6 +520,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
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

