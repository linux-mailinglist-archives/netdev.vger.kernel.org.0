Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE9534F90
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347498AbiEZMos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347401AbiEZMoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A74095484
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 05:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653569044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igBXv3+/zStPVZqqltRrzn4uh7XDamvAt3SF6+Ki2IY=;
        b=O6UNl/8Mys+7/WVXrf2g84aPikrhAxfeJ04gYijrlZ3P6hVI49TFS3Ps8N0fDux0hiB2Yy
        u4v8vcfnHidYGC/c0jOloJV4gEKaQzBX1OAo5S3NBctFATR6ujuJL0/7E9y8lK/fwhwDDj
        11Jxv+ibMs7RxAOsoXvL6dvYC2i4e/g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-1h-jbKVWMUuvVIVxS4rPaw-1; Thu, 26 May 2022 08:44:00 -0400
X-MC-Unique: 1h-jbKVWMUuvVIVxS4rPaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF9B5185A7BA;
        Thu, 26 May 2022 12:43:59 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2FE640CFD0B;
        Thu, 26 May 2022 12:43:54 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Cc:     martinh@xilinx.com, Stefano Garzarella <sgarzare@redhat.com>,
        martinpo@xilinx.com, lvivier@redhat.com, pabloc@xilinx.com,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>, lulu@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, Piotr.Uminski@intel.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, ecree.xilinx@gmail.com,
        gautam.dawar@amd.com, habetsm.xilinx@gmail.com,
        tanuj.kamde@amd.com, hanand@xilinx.com, dinang@xilinx.com,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH v4 3/4] vhost-vdpa: uAPI to stop the device
Date:   Thu, 26 May 2022 14:43:37 +0200
Message-Id: <20220526124338.36247-4-eperezma@redhat.com>
In-Reply-To: <20220526124338.36247-1-eperezma@redhat.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
index 32713db5831d..d1d19555c4b7 100644
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
+	case VHOST_VDPA_STOP:
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
2.31.1

