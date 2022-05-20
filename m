Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918CB52F19B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352192AbiETRYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352183AbiETRYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:24:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91EEE188E7B
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653067434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kov56r1jsuiTzaYs0eaT4ViAnRJYvmg/k+QVFy5P/+0=;
        b=RW4nx2laMh5A5Sg/rfmbPuWKSrHo4DJqXnNf1+zP7OvDFj4Xd8x+6hmD0hp44lIvDFFzUR
        W+v6FxyBfBlrNKA7mHfKb0rBvrozXRHcSeTvzfTdgaLfaE9Ggd8A3Wf1diAgalkGjOS9UT
        2pXMVFPA0gCtmiMtHTij1z+EOeQtAF4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-nwlB4FZBM6KK2GEL8ZhIIQ-1; Fri, 20 May 2022 13:23:49 -0400
X-MC-Unique: nwlB4FZBM6KK2GEL8ZhIIQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8842285A5AA;
        Fri, 20 May 2022 17:23:47 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8458492C14;
        Fri, 20 May 2022 17:23:42 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        hanand@xilinx.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        dinang@xilinx.com, Eli Cohen <elic@nvidia.com>, lvivier@redhat.com,
        pabloc@xilinx.com, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, eperezma@redhat.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, lulu@redhat.com, ecree.xilinx@gmail.com,
        Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH 3/4] vhost-vdpa: uAPI to stop the device
Date:   Fri, 20 May 2022 19:23:24 +0200
Message-Id: <20220520172325.980884-4-eperezma@redhat.com>
In-Reply-To: <20220520172325.980884-1-eperezma@redhat.com>
References: <20220520172325.980884-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
 include/uapi/linux/vhost.h |  3 +++
 2 files changed, 21 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a325bc259afb..da4a8c709bc1 100644
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
+	if (copy_to_user(argp, &stop, sizeof(stop)))
+		return -EFAULT;
+
+	return ops->stop(vdpa, stop);
+}
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -649,6 +664,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
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
index cab645d4a645..e7526968ab0c 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -171,4 +171,7 @@
 #define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
 					     struct vhost_vring_state)
 
+/* Stop or resume a device so it does not process virtqueue requests anymore */
+#define VHOST_STOP			_IOW(VHOST_VIRTIO, 0x7D, int)
+
 #endif
-- 
2.27.0

