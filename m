Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6E58F156
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbiHJRPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbiHJRPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:15:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E52645D0EC
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 10:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660151738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iMpQUSDWpUJEJo5k/gaQy5pnVja3hB7pQ6/xlm1Oxjw=;
        b=cTlIUHLx4Au1pmPyYboIOVW0kT98IX3bdbdxXa5qEdTZs3dbJYX1e9VYGrkWTnLRDmmkxq
        tZAHmpRp5vMCNZdtzSypeDJLFXOa3tLM1BzVbeLKMnSVylTNbR2nN370ekoEWPRx6JWK29
        oN6Dkgz8UMcY0w+XTILKMixMXKW4k9o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-WG9qIJSPMvadnQW-uALkAw-1; Wed, 10 Aug 2022 13:15:30 -0400
X-MC-Unique: WG9qIJSPMvadnQW-uALkAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 613C61019C8D;
        Wed, 10 Aug 2022 17:15:29 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E15A81415128;
        Wed, 10 Aug 2022 17:15:24 +0000 (UTC)
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
Subject: [PATCH v7 2/4] vhost-vdpa: introduce SUSPEND backend feature bit
Date:   Wed, 10 Aug 2022 19:15:10 +0200
Message-Id: <20220810171512.2343333-3-eperezma@redhat.com>
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

Userland knows if it can suspend the device or not by checking this feature
bit.

It's only offered if the vdpa driver backend implements the suspend()
operation callback, and to offer it or userland to ack it if the backend
does not offer that callback is an error.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Message-Id: <20220623160738.632852-3-eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vdpa.c             | 16 +++++++++++++++-
 include/uapi/linux/vhost_types.h |  2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 23dcbfdfa13b..3d636e192061 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 	return 0;
 }
 
+static bool vhost_vdpa_can_suspend(const struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	return ops->suspend;
+}
+
 static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -577,7 +585,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	if (cmd == VHOST_SET_BACKEND_FEATURES) {
 		if (copy_from_user(&features, featurep, sizeof(features)))
 			return -EFAULT;
-		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
+		if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
+				 BIT_ULL(VHOST_BACKEND_F_SUSPEND)))
+			return -EOPNOTSUPP;
+		if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
+		     !vhost_vdpa_can_suspend(v))
 			return -EOPNOTSUPP;
 		vhost_set_backend_features(&v->vdev, features);
 		return 0;
@@ -628,6 +640,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		break;
 	case VHOST_GET_BACKEND_FEATURES:
 		features = VHOST_VDPA_BACKEND_FEATURES;
+		if (vhost_vdpa_can_suspend(v))
+			features |= BIT_ULL(VHOST_BACKEND_F_SUSPEND);
 		if (copy_to_user(featurep, &features, sizeof(features)))
 			r = -EFAULT;
 		break;
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 634cee485abb..1bdd6e363f4c 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -161,5 +161,7 @@ struct vhost_vdpa_iova_range {
  * message
  */
 #define VHOST_BACKEND_F_IOTLB_ASID  0x3
+/* Device can be suspended */
+#define VHOST_BACKEND_F_SUSPEND  0x4
 
 #endif
-- 
2.31.1

