Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D37353C830
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243397AbiFCKKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243465AbiFCKKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:10:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A81D3B3CE
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 03:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654251025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VJfV/hotJTL7ZePv0RbAazmYZHrUQpKxi4Jb173Q20w=;
        b=Owgufx5oHAQ/94ZPzQ3GtGh6WRkfhSgqE6A54U/HjhLhBkX7/4QFtfjf7xduIxd33sRLIR
        WXdqXH95X0XE2IVbpYahZSypcViks9jcqVEszAjgad8DWPiGIFGCAvyiqM+g4jJ0IZ3RkK
        TFXQiIyu7BzUZBkZVVJxvTsYGiOTyJw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-y528ceswNBifW8e9WJwpEQ-1; Fri, 03 Jun 2022 06:10:21 -0400
X-MC-Unique: y528ceswNBifW8e9WJwpEQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4ABF038005D1;
        Fri,  3 Jun 2022 10:10:09 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.40.192.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39019492C3B;
        Fri,  3 Jun 2022 10:10:04 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Longpeng <longpeng2@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>, dinang@xilinx.com,
        Piotr.Uminski@intel.com, martinpo@xilinx.com, tanuj.kamde@amd.com,
        Parav Pandit <parav@nvidia.com>,
        Zhang Min <zhang.min9@zte.com.cn>, habetsm.xilinx@gmail.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, lulu@redhat.com,
        hanand@xilinx.com, martinh@xilinx.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>, ecree.xilinx@gmail.com,
        pabloc@xilinx.com, lvivier@redhat.com, Eli Cohen <elic@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v5 3/4] vhost-vdpa: uAPI to suspend the device
Date:   Fri,  3 Jun 2022 12:09:43 +0200
Message-Id: <20220603100944.871727-4-eperezma@redhat.com>
In-Reply-To: <20220603100944.871727-1-eperezma@redhat.com>
References: <20220603100944.871727-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ioctl adds support for suspending the device from userspace.

This is a must before getting virtqueue indexes (base) for live migration,
since the device could modify them after userland gets them. There are
individual ways to perform that action for some devices
(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
way to perform it for any vhost device (and, in particular, vhost-vdpa).

After a successful return of ioctl with suspend = 1, the device must not
process more virtqueue descriptors, and it must not send any config
interrupt. The device can answer to read or writes of config fields as
if it were not suspended. In particular, writing to "queue_enable" with
a value of 1 will not make the device start processing buffers of the
virtqueue until the device is resumed (suspend = 0).

After a successful return of ioctl with suspend = 0, the device will
start processing data of the virtqueues if other expected conditions are
met (queue is enabled, DRIVER_OK has already been set to status, etc.)
If not, the device should be in the same state as if no call to suspend
callback with suspend = 1 has been performed.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c       | 31 +++++++++++++++++++++++++++++++
 include/uapi/linux/vhost.h | 14 ++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index f4b492526c6f8..cb47c10bbf471 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -478,6 +478,34 @@ static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
 	return 0;
 }
 
+/* After a successful return of ioctl with suspend = 1, the device must not
+ * process more virtqueue descriptors, and it must not send any config
+ * interrupt. The device can answer to read or writes of config fields as if it
+ * were not suspended. In particular, writing to "queue_enable" with a value of
+ * 1 will not make the device start processing buffers of the virtqueue until
+ * the device is resumed (suspend = 0).
+ *
+ * After a successful return of ioctl with suspend = 0, the device will start
+ * processing data of the virtqueues if other expected conditions are met
+ * (queue is enabled, DRIVER_OK has already been set to status, etc.) If not,
+ * the device should be in the same state as if no call to suspend callback
+ * with suspend = 1 has been performed.
+ */
+static long vhost_vdpa_suspend(struct vhost_vdpa *v, u32 __user *argp)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+	int suspend;
+
+	if (!ops->suspend)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&suspend, argp, sizeof(suspend)))
+		return -EFAULT;
+
+	return ops->suspend(vdpa, suspend);
+}
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -652,6 +680,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_VQS_COUNT:
 		r = vhost_vdpa_get_vqs_count(v, argp);
 		break;
+	case VHOST_VDPA_SUSPEND:
+		r = vhost_vdpa_suspend(v, argp);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index cab645d4a6455..6d9f451631557 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -171,4 +171,18 @@
 #define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
 					     struct vhost_vring_state)
 
+/* Suspend or resume a device so it does not process virtqueue requests anymore
+ *
+ * After the return of ioctl with suspend != 0, the device must finish any
+ * pending operations like in flight requests. It must also preserve all the
+ * necessary state (the virtqueue vring base plus the possible device specific
+ * states) that is required for restoring in the future. The device must not
+ * change its configuration after that point.
+ *
+ * After the return of ioctl with suspend == 0, the device can continue
+ * processing buffers as long as typical conditions are met (vq is enabled,
+ * DRIVER_OK status bit is enabled, etc).
+ */
+#define VHOST_VDPA_SUSPEND		_IOW(VHOST_VIRTIO, 0x7D, int)
+
 #endif
-- 
2.31.1

