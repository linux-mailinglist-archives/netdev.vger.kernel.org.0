Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF97533B31
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbiEYLAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242360AbiEYLAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:00:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73F996669F
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 04:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653476401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iHJ6PFjviDqPYy85yFDxjKt/WK/68mxqW6ae6Xic7iM=;
        b=PeguTfUND+j9zoIc85/p3A8BPdeBiO3BxvWBq5jvHKUBcgeO6Y4JAZn8qo9hCTDORDtYlU
        VYXp6Xmn+anq14SmXYvwCUeqJu7PvzNJKIEb5hFzUipyNY6kyA2Ewu2mZPXjLXBq0cRUoI
        BsU1zpHiqYSJEwHshFnRVX0UmoheVxM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-QLLjc54rMoiQyA9K3FxXnA-1; Wed, 25 May 2022 06:59:57 -0400
X-MC-Unique: QLLjc54rMoiQyA9K3FxXnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 603CE85A5BC;
        Wed, 25 May 2022 10:59:56 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73FBE7AD8;
        Wed, 25 May 2022 10:59:48 +0000 (UTC)
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
Subject: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
Date:   Wed, 25 May 2022 12:59:20 +0200
Message-Id: <20220525105922.2413991-3-eperezma@redhat.com>
In-Reply-To: <20220525105922.2413991-1-eperezma@redhat.com>
References: <20220525105922.2413991-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
2.27.0

