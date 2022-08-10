Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF04958F155
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiHJRPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiHJRPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:15:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69DDE647C5
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 10:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660151738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+9sF3KA2QSMcF5wWOCwmBqvZxHtmEUvtswHt6xdWHZc=;
        b=LfjM/GcmJKPmQ5fgHosTOHZK7O0CFvnDrQvh78zvg4ABaMeR99Nbvx+GqlQq1mCpsZO/qN
        FtwxceRN64iTXVm4z6I5EedHBiz95dW3k6psFGlP/0QRT3ga4miOamXnTIkm8AHjfVvH4a
        XFL2c2899DzYMCUQQZT13tsoxbDEDlw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-7mK-R0nDNJ2lHUSOMexoYA-1; Wed, 10 Aug 2022 13:15:35 -0400
X-MC-Unique: 7mK-R0nDNJ2lHUSOMexoYA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DA111824603;
        Wed, 10 Aug 2022 17:15:34 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A414B1415125;
        Wed, 10 Aug 2022 17:15:29 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     dinang@xilinx.com, martinpo@xilinx.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Piotr.Uminski@intel.com, gautam.dawar@amd.com,
        ecree.xilinx@gmail.com, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, pabloc@xilinx.com,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        Longpeng <longpeng2@huawei.com>, lulu@redhat.com,
        hanand@xilinx.com, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v7 3/4] vhost-vdpa: uAPI to suspend the device
Date:   Wed, 10 Aug 2022 19:15:11 +0200
Message-Id: <20220810171512.2343333-4-eperezma@redhat.com>
In-Reply-To: <20220810171512.2343333-1-eperezma@redhat.com>
References: <20220810171512.2343333-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

After a successful return of the ioctl call the device must not process
more virtqueue descriptors. The device can answer to read or writes of
config fields as if it were not suspended. In particular, writing to
"queue_enable" with a value of 1 will not make the device start
processing buffers of the virtqueue.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Message-Id: <20220623160738.632852-4-eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
v7: Delete argument to ioctl, unused
---
 drivers/vhost/vdpa.c       | 19 +++++++++++++++++++
 include/uapi/linux/vhost.h |  9 +++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 3d636e192061..7fa671ac4bdf 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -478,6 +478,22 @@ static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
 	return 0;
 }
 
+/* After a successful return of ioctl the device must not process more
+ * virtqueue descriptors. The device can answer to read or writes of config
+ * fields as if it were not suspended. In particular, writing to "queue_enable"
+ * with a value of 1 will not make the device start processing buffers.
+ */
+static long vhost_vdpa_suspend(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	if (!ops->suspend)
+		return -EOPNOTSUPP;
+
+	return ops->suspend(vdpa);
+}
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -654,6 +670,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_VQS_COUNT:
 		r = vhost_vdpa_get_vqs_count(v, argp);
 		break;
+	case VHOST_VDPA_SUSPEND:
+		r = vhost_vdpa_suspend(v);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index cab645d4a645..f9f115a7c75b 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -171,4 +171,13 @@
 #define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
 					     struct vhost_vring_state)
 
+/* Suspend a device so it does not process virtqueue requests anymore
+ *
+ * After the return of ioctl the device must preserve all the necessary state
+ * (the virtqueue vring base plus the possible device specific states) that is
+ * required for restoring in the future. The device must not change its
+ * configuration after that point.
+ */
+#define VHOST_VDPA_SUSPEND		_IO(VHOST_VIRTIO, 0x7D)
+
 #endif
-- 
2.31.1

