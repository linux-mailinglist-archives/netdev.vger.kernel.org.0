Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CAE276707
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgIXDYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:24:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbgIXDYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8jxhWuQvQJfouIbNkDtCkuvd21/UB6/8QLtvL6jnnfc=;
        b=Wu69JwTBo7BKV1ONSTGwhX7Hr2//tlIq/QtTJiYkWBicVO64pveAyz0pjzTOQwhbjUBEl4
        ymxyVzKNIlODnbh6KyCZjPow+//Kt9yTwVla5TA91868Q8zm0t+FoI0yI4fC8+vxRCWgol
        Em0bL0wPA7MtXsPIwedrkKazzP1kbSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-km9jTzOUO3mytN-x6bV2YQ-1; Wed, 23 Sep 2020 23:24:03 -0400
X-MC-Unique: km9jTzOUO3mytN-x6bV2YQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BC7A8910B7;
        Thu, 24 Sep 2020 03:24:02 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87CB93782;
        Thu, 24 Sep 2020 03:23:50 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 12/24] vhost: support ASID in IOTLB API
Date:   Thu, 24 Sep 2020 11:21:13 +0800
Message-Id: <20200924032125.18619-13-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patches allows userspace to send ASID based IOTLB message to
vhost. This idea is to use the reserved u32 field in the existing V2
IOTLB message. Vhost device should advertise this capability via
VHOST_BACKEND_F_IOTLB_ASID backend feature.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c             |  5 ++++-
 drivers/vhost/vhost.c            | 23 ++++++++++++++++++-----
 drivers/vhost/vhost.h            |  4 ++--
 include/uapi/linux/vhost_types.h |  5 ++++-
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index eeefcd971e3f..6552987544d7 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -675,7 +675,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	return ret;
 }
 
-static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
+static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 					struct vhost_iotlb_msg *msg)
 {
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
@@ -684,6 +684,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	struct vhost_iotlb *iotlb = v->iotlb;
 	int r = 0;
 
+	if (asid != 0)
+		return -EINVAL;
+
 	r = vhost_dev_check_owner(dev);
 	if (r)
 		return r;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b45519ca66a7..060662b12de3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -463,7 +463,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		    struct vhost_virtqueue **vqs, int nvqs,
 		    int iov_limit, int weight, int byte_weight,
 		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
+		    int (*msg_handler)(struct vhost_dev *dev, u32 asid,
 				       struct vhost_iotlb_msg *msg))
 {
 	struct vhost_virtqueue *vq;
@@ -1079,11 +1079,14 @@ static bool umem_access_ok(u64 uaddr, u64 size, int access)
 	return true;
 }
 
-static int vhost_process_iotlb_msg(struct vhost_dev *dev,
+static int vhost_process_iotlb_msg(struct vhost_dev *dev, u16 asid,
 				   struct vhost_iotlb_msg *msg)
 {
 	int ret = 0;
 
+	if (asid != 0)
+		return -EINVAL;
+
 	mutex_lock(&dev->mutex);
 	vhost_dev_lock_vqs(dev);
 	switch (msg->type) {
@@ -1130,6 +1133,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 	struct vhost_iotlb_msg msg;
 	size_t offset;
 	int type, ret;
+	u16 asid = 0;
 
 	ret = copy_from_iter(&type, sizeof(type), from);
 	if (ret != sizeof(type)) {
@@ -1145,7 +1149,16 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		offset = offsetof(struct vhost_msg, iotlb) - sizeof(int);
 		break;
 	case VHOST_IOTLB_MSG_V2:
-		offset = sizeof(__u32);
+		if (vhost_backend_has_feature(dev->vqs[0],
+					      VHOST_BACKEND_F_IOTLB_ASID)) {
+			ret = copy_from_iter(&asid, sizeof(asid), from);
+			if (ret != sizeof(asid)) {
+				ret = -EINVAL;
+				goto done;
+			}
+			offset = sizeof(__u16);
+		} else
+			offset = sizeof(__u32);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1160,9 +1173,9 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 	}
 
 	if (dev->msg_handler)
-		ret = dev->msg_handler(dev, &msg);
+		ret = dev->msg_handler(dev, asid, &msg);
 	else
-		ret = vhost_process_iotlb_msg(dev, &msg);
+		ret = vhost_process_iotlb_msg(dev, asid, &msg);
 	if (ret) {
 		ret = -EFAULT;
 		goto done;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9032d3c2a9f4..05e7aaf6071b 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -162,7 +162,7 @@ struct vhost_dev {
 	int byte_weight;
 	u64 kcov_handle;
 	bool use_worker;
-	int (*msg_handler)(struct vhost_dev *dev,
+	int (*msg_handler)(struct vhost_dev *dev, u32 asid,
 			   struct vhost_iotlb_msg *msg);
 };
 
@@ -170,7 +170,7 @@ bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
 		    int nvqs, int iov_limit, int weight, int byte_weight,
 		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
+		    int (*msg_handler)(struct vhost_dev *dev, u32 asid,
 				       struct vhost_iotlb_msg *msg));
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 532571571b4b..2eb55fc9bf2e 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -87,7 +87,7 @@ struct vhost_msg {
 
 struct vhost_msg_v2 {
 	__u32 type;
-	__u32 reserved;
+	__u32 asid;
 	union {
 		struct vhost_iotlb_msg iotlb;
 		__u8 padding[64];
@@ -148,5 +148,8 @@ struct vhost_vdpa_config {
 #define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
 /* IOTLB can accept batching hints */
 #define VHOST_BACKEND_F_IOTLB_BATCH  0x2
+/* IOTLB can accept address space identifier through V2 type of IOTLB
+   message */
+#define VHOST_BACKEND_F_IOTLB_ASID  0x3
 
 #endif
-- 
2.20.1

