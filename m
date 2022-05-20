Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7981352F187
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352187AbiETRYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352176AbiETRYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:24:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BA17187DB6
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653067428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RwJhQswXs8DRWPiKRZyfAdOUa8pNFYiVHsGQwvzSwJs=;
        b=WKUFLcroXLT23vgoFE1btWfOH7dB8fPCjfTio/oZOpCvABM2zQpu1wvReHIG/OUJfygvEg
        5Yn5Qh+YL+jjTJpz3RsPHtglAT2m7Qjq8x3Ag6Y4RPku++FssT1/RWzru4A0WQ2kSCcQWh
        8s2gHcRffs14ICzU8Abmo+7kx/Joa0o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-hTE2Afj0PlaaSHtniuPgdA-1; Fri, 20 May 2022 13:23:44 -0400
X-MC-Unique: hTE2Afj0PlaaSHtniuPgdA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83F088015BA;
        Fri, 20 May 2022 17:23:42 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB6AF492C14;
        Fri, 20 May 2022 17:23:37 +0000 (UTC)
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
Subject: [PATCH 2/4] vhost-vdpa: introduce STOP backend feature bit
Date:   Fri, 20 May 2022 19:23:23 +0200
Message-Id: <20220520172325.980884-3-eperezma@redhat.com>
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

Userland knows if it can stop the device or not by checking this feature
bit.

It's only offered if the vdpa driver backend implements the stop()
operation callback, and try to set it if the backend does not offer that
callback is an error.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c             | 13 +++++++++++++
 include/uapi/linux/vhost_types.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 1f1d1c425573..a325bc259afb 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 	return 0;
 }
 
+static bool vhost_vdpa_can_stop(const struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	return ops->stop;
+}
+
 static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -577,6 +585,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 			return -EFAULT;
 		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
 			return -EOPNOTSUPP;
+		if ((features & VHOST_BACKEND_F_STOP) &&
+		     !vhost_vdpa_can_stop(v))
+			return -EOPNOTSUPP;
 		vhost_set_backend_features(&v->vdev, features);
 		return 0;
 	}
@@ -624,6 +635,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		break;
 	case VHOST_GET_BACKEND_FEATURES:
 		features = VHOST_VDPA_BACKEND_FEATURES;
+		if (vhost_vdpa_can_stop(v))
+			features |= VHOST_BACKEND_F_STOP;
 		if (copy_to_user(featurep, &features, sizeof(features)))
 			r = -EFAULT;
 		break;
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 634cee485abb..2758e665791b 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -161,5 +161,7 @@ struct vhost_vdpa_iova_range {
  * message
  */
 #define VHOST_BACKEND_F_IOTLB_ASID  0x3
+/* Stop device from processing virtqueue buffers */
+#define VHOST_BACKEND_F_STOP  0x4
 
 #endif
-- 
2.27.0

