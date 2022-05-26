Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8064534F89
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347452AbiEZMoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347302AbiEZMoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 136976FD1E
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 05:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653569041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8x5uANMvf2VwsZlPdXrxHBVNofiKHdnw5YtD1/im1sQ=;
        b=ie0dsr9LGGD92GHQpxnZmhIW9lvvsm5+ao6q+cLY5zO+BQnVuMNHXGxzu9pbVW/I6WMbfD
        fANd+m1+LnXlA+hqLu1wT6N5k0obJZ6Y1Okw6x5bC2uqzdCTlt7th8IzHGtx9Xi64TeAPT
        ipHnKu6V+9PMytQFktvvoGuEdDT9KAU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-fqCUuj4vOj-qFAorRxaclA-1; Thu, 26 May 2022 08:43:55 -0400
X-MC-Unique: fqCUuj4vOj-qFAorRxaclA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABD391C00AC9;
        Thu, 26 May 2022 12:43:54 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C68B400DB3A;
        Thu, 26 May 2022 12:43:50 +0000 (UTC)
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
Subject: [PATCH v4 2/4] vhost-vdpa: introduce STOP backend feature bit
Date:   Thu, 26 May 2022 14:43:36 +0200
Message-Id: <20220526124338.36247-3-eperezma@redhat.com>
In-Reply-To: <20220526124338.36247-1-eperezma@redhat.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
 drivers/vhost/vdpa.c             | 16 +++++++++++++++-
 include/uapi/linux/vhost_types.h |  2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 1f1d1c425573..32713db5831d 100644
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
@@ -575,7 +583,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	if (cmd == VHOST_SET_BACKEND_FEATURES) {
 		if (copy_from_user(&features, featurep, sizeof(features)))
 			return -EFAULT;
-		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
+		if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
+				 BIT_ULL(VHOST_BACKEND_F_STOP)))
+			return -EOPNOTSUPP;
+		if ((features & BIT_ULL(VHOST_BACKEND_F_STOP)) &&
+		     !vhost_vdpa_can_stop(v))
 			return -EOPNOTSUPP;
 		vhost_set_backend_features(&v->vdev, features);
 		return 0;
@@ -624,6 +636,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		break;
 	case VHOST_GET_BACKEND_FEATURES:
 		features = VHOST_VDPA_BACKEND_FEATURES;
+		if (vhost_vdpa_can_stop(v))
+			features |= BIT_ULL(VHOST_BACKEND_F_STOP);
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
2.31.1

