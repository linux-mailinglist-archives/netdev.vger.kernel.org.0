Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79348533B2B
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242721AbiEYLAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242595AbiEYLAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:00:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B9107090B
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 04:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653476408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NlxBW7wk8695Knmv4EkJy0sRMvfqe1PLsU+Qmw4ofPU=;
        b=L5z1iWSZ3+Ji1rkGh1407i6DwMdusVMbdSTibVWn0GnPUG0LMl8g6jQs5OyiDGU5k7gnwl
        e88iCdV26YkBL+WLSCpKRw8BZsxVRVRhoybq9ki2Xlrz5wrHxMUlrw6swIYv99hMNKQDcE
        s5qn6+8xB3XPZ3xjU2UMg/FVSBhJSLo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-k3rwf3ytO6ebUOz1zbXP5Q-1; Wed, 25 May 2022 07:00:06 -0400
X-MC-Unique: k3rwf3ytO6ebUOz1zbXP5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C59EC29AB3EB;
        Wed, 25 May 2022 11:00:04 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE2A17AD8;
        Wed, 25 May 2022 10:59:56 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        ecree.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>, dinang@xilinx.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>, gautam.dawar@amd.com,
        lulu@redhat.com, martinpo@xilinx.com, pabloc@xilinx.com,
        Longpeng <longpeng2@huawei.com>, Piotr.Uminski@intel.com,
        tanuj.kamde@amd.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhang Min <zhang.min9@zte.com.cn>, hanand@xilinx.com
Subject: [PATCH v3 3/4] vhost-vdpa: uAPI to stop the device
Date:   Wed, 25 May 2022 12:59:21 +0200
Message-Id: <20220525105922.2413991-4-eperezma@redhat.com>
In-Reply-To: <20220525105922.2413991-1-eperezma@redhat.com>
References: <20220525105922.2413991-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ioctl adds support for stop the device from userspace.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c       | 18 ++++++++++++++++++
 include/uapi/linux/vhost.h | 14 ++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 32713db5831d..a5d33bad92f9 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -478,6 +478,21 @@ static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
 	return 0;
 }
 
+static long vhost_vdpa_stop(struct vhost_vdpa *v, u32 __user *argp)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+	int stop;
+
+	if (!ops->stop)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&stop, argp, sizeof(stop)))
+		return -EFAULT;
+
+	return ops->stop(vdpa, stop);
+}
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -650,6 +665,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_VQS_COUNT:
 		r = vhost_vdpa_get_vqs_count(v, argp);
 		break;
+	case VHOST_STOP:
+		r = vhost_vdpa_stop(v, argp);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index cab645d4a645..c7e47b29bf61 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -171,4 +171,18 @@
 #define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
 					     struct vhost_vring_state)
 
+/* Stop or resume a device so it does not process virtqueue requests anymore
+ *
+ * After the return of ioctl with stop != 0, the device must finish any
+ * pending operations like in flight requests. It must also preserve all
+ * the necessary state (the virtqueue vring base plus the possible device
+ * specific states) that is required for restoring in the future. The
+ * device must not change its configuration after that point.
+ *
+ * After the return of ioctl with stop == 0, the device can continue
+ * processing buffers as long as typical conditions are met (vq is enabled,
+ * DRIVER_OK status bit is enabled, etc).
+ */
+#define VHOST_VDPA_STOP			_IOW(VHOST_VIRTIO, 0x7D, int)
+
 #endif
-- 
2.27.0

