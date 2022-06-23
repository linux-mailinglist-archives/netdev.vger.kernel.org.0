Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF13D557F5E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiFWQIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiFWQIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:08:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDF5713DC3
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 09:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656000483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p0H1iSQcDJbUvtJG+KGPPnxre+ECDIYiae0HlZqGFM8=;
        b=AwUt+2NAwc0Nf4mHMl1DD7aEf/7iDZ+rTjgnVl46GBNLzaj6NeqOmqUFipEujfnfuPyQ6n
        v2Q/XXaTm5/Bf74SKkVe5ay8fjV3vgihkt4Jcf17UFyFnjOP+YvYvMdekgXqHJ3+6une0D
        XDiVKrP+Eolvd1FLk00xukyy0QGJW0c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-ePvZj1VdPKqa5ABW6Kv0RQ-1; Thu, 23 Jun 2022 12:08:00 -0400
X-MC-Unique: ePvZj1VdPKqa5ABW6Kv0RQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6590F8032ED;
        Thu, 23 Jun 2022 16:07:59 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 078392166B26;
        Thu, 23 Jun 2022 16:07:54 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        lulu@redhat.com, tanuj.kamde@amd.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, Piotr.Uminski@intel.com,
        habetsm.xilinx@gmail.com, gautam.dawar@amd.com, pabloc@xilinx.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, lvivier@redhat.com,
        Longpeng <longpeng2@huawei.com>, dinang@xilinx.com,
        martinh@xilinx.com, martinpo@xilinx.com,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, hanand@xilinx.com,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v6 3/4] vhost-vdpa: uAPI to suspend the device
Date:   Thu, 23 Jun 2022 18:07:37 +0200
Message-Id: <20220623160738.632852-4-eperezma@redhat.com>
In-Reply-To: <20220623160738.632852-1-eperezma@redhat.com>
References: <20220623160738.632852-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

After a successful return of the ioctl call the device must not process
more virtqueue descriptors. The device can answer to read or writes of
config fields as if it were not suspended. In particular, writing to
"queue_enable" with a value of 1 will not make the device start
processing buffers of the virtqueue.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c       | 19 +++++++++++++++++++
 include/uapi/linux/vhost.h | 14 ++++++++++++++
 2 files changed, 33 insertions(+)

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
index cab645d4a645..6d9f45163155 100644
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

