Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87A32E0C20
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgLVOyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgLVOyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:54:43 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA93C06179C
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:53:52 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id lj6so1425210pjb.0
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WVpiMFISEK5bmULf4ejx2zyXWwfYVm8DL2A3XwWC6mc=;
        b=OmIRUy+rIhe49YYTypJqWrWUDFVliVfMzFwBNejj8/ATpVRBmzn49pWWFjfMhEWatu
         aAG9YzI7NKx0JHeowGhEpmWy+wIs+tE0IeOxCaNQxHI0wkhLVPguC4XYrZHOFhajcYJM
         Pik6ODfmxn4JGlYErcl1qGjAn20nV0o+woNjr16axEcllzptRlBdeSok6KqsHS0l5Xn2
         jXr5Pcu1njxAnR2uE5dN/ei2ZRykH21L5aJaNNKjVvAQhXvZwLUTf7zb1PEAzJ4QSW9W
         +GeOPURhko8s7Tap9AS+oweCf/uy3mBXGl1zrTv/o27yQdCAVn5BYZBkCEZ0KuzUxbxo
         VYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WVpiMFISEK5bmULf4ejx2zyXWwfYVm8DL2A3XwWC6mc=;
        b=db45FLG69g0qhn9LiV5WrymBeY/Pj0Psa21uVb+LwS/f9XqpjSK8lUwKMF7ErfBTUN
         kisl7BH24lDe3ninBSGLxaxVOGOyGrqB+iMWI2GYB4Ng312K2KLK7FnB8v6EZLBTJ90z
         G5XM5BJ5Cl0ekBj45tLVY/1BEY0zWCBb54bW3jjzqlgQU1gXYhTHlBrAdR/+YPooQLY7
         INEsPvxSJGGr5S0Gaq3LgxYrrXkuTY8+diCi+bW7J8e5I1Vsre9rVc3rnMO28B37bCDA
         ZeZzw7AlpWby4+6XgXtaiNFpcaDDI988Ju8WfMikt3VaZFUYtpc3LTK5YsPf3aYMTGVo
         twAg==
X-Gm-Message-State: AOAM531IPO8W7bWdsuNQO3xM4geDoW+zlN0ZP6DbyztPKIEYaFHTLZVp
        GxQYhmt5x+jt6LYTJFmjXxtk
X-Google-Smtp-Source: ABdhPJyUXGBubCUCYwRou9orBsnPOEmQF6msO4OENePqz427fxTAlf17KzWGs2+ZUPyEhT+cwqjVSg==
X-Received: by 2002:a17:90b:14d3:: with SMTP id jz19mr22693411pjb.196.1608648832012;
        Tue, 22 Dec 2020 06:53:52 -0800 (PST)
Received: from localhost ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id z125sm19528369pfz.121.2020.12.22.06.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 06:53:51 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC v2 07/13] vduse: support get/set virtqueue state
Date:   Tue, 22 Dec 2020 22:52:15 +0800
Message-Id: <20201222145221.711-8-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222145221.711-1-xieyongji@bytedance.com>
References: <20201222145221.711-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes vhost-vdpa bus driver can get/set virtqueue
state from userspace VDUSE process.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 Documentation/driver-api/vduse.rst |  4 +++
 drivers/vdpa/vdpa_user/vduse_dev.c | 54 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vduse.h         |  9 +++++++
 3 files changed, 67 insertions(+)

diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
index da9b3040f20a..623f7b040ccf 100644
--- a/Documentation/driver-api/vduse.rst
+++ b/Documentation/driver-api/vduse.rst
@@ -30,6 +30,10 @@ The following types of messages are provided by the VDUSE framework now:
 
 - VDUSE_GET_VQ_READY: Get ready status of virtqueue
 
+- VDUSE_SET_VQ_STATE: Set the state (last_avail_idx) for virtqueue
+
+- VDUSE_GET_VQ_STATE: Get the state (last_avail_idx) for virtqueue
+
 - VDUSE_SET_FEATURES: Set virtio features supported by the driver
 
 - VDUSE_GET_FEATURES: Get virtio features supported by the device
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 4a869b9698ef..b974333ed4e9 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -291,6 +291,40 @@ static bool vduse_dev_get_vq_ready(struct vduse_dev *dev,
 	return ready;
 }
 
+static int vduse_dev_get_vq_state(struct vduse_dev *dev,
+				struct vduse_virtqueue *vq,
+				struct vdpa_vq_state *state)
+{
+	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_GET_VQ_STATE);
+	int ret;
+
+	msg->req.size = sizeof(struct vduse_vq_state);
+	msg->req.vq_state.index = vq->index;
+
+	ret = vduse_dev_msg_sync(dev, msg);
+	state->avail_index = msg->resp.vq_state.avail_idx;
+	vduse_dev_msg_put(msg);
+
+	return ret;
+}
+
+static int vduse_dev_set_vq_state(struct vduse_dev *dev,
+				struct vduse_virtqueue *vq,
+				const struct vdpa_vq_state *state)
+{
+	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_SET_VQ_STATE);
+	int ret;
+
+	msg->req.size = sizeof(struct vduse_vq_state);
+	msg->req.vq_state.index = vq->index;
+	msg->req.vq_state.avail_idx = state->avail_index;
+
+	ret = vduse_dev_msg_sync(dev, msg);
+	vduse_dev_msg_put(msg);
+
+	return ret;
+}
+
 static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
@@ -431,6 +465,24 @@ static bool vduse_vdpa_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
 	return vq->ready;
 }
 
+static int vduse_vdpa_set_vq_state(struct vdpa_device *vdpa, u16 idx,
+				const struct vdpa_vq_state *state)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	return vduse_dev_set_vq_state(dev, vq, state);
+}
+
+static int vduse_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 idx,
+				struct vdpa_vq_state *state)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	return vduse_dev_get_vq_state(dev, vq, state);
+}
+
 static u32 vduse_vdpa_get_vq_align(struct vdpa_device *vdpa)
 {
 	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
@@ -532,6 +584,8 @@ static const struct vdpa_config_ops vduse_vdpa_config_ops = {
 	.set_vq_num             = vduse_vdpa_set_vq_num,
 	.set_vq_ready		= vduse_vdpa_set_vq_ready,
 	.get_vq_ready		= vduse_vdpa_get_vq_ready,
+	.set_vq_state		= vduse_vdpa_set_vq_state,
+	.get_vq_state		= vduse_vdpa_get_vq_state,
 	.get_vq_align		= vduse_vdpa_get_vq_align,
 	.get_features		= vduse_vdpa_get_features,
 	.set_features		= vduse_vdpa_set_features,
diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
index f8579abdaa3b..873305dfd93f 100644
--- a/include/uapi/linux/vduse.h
+++ b/include/uapi/linux/vduse.h
@@ -13,6 +13,8 @@ enum vduse_req_type {
 	VDUSE_SET_VQ_ADDR,
 	VDUSE_SET_VQ_READY,
 	VDUSE_GET_VQ_READY,
+	VDUSE_SET_VQ_STATE,
+	VDUSE_GET_VQ_STATE,
 	VDUSE_SET_FEATURES,
 	VDUSE_GET_FEATURES,
 	VDUSE_SET_STATUS,
@@ -38,6 +40,11 @@ struct vduse_vq_ready {
 	__u8 ready;
 };
 
+struct vduse_vq_state {
+	__u32 index;
+	__u16 avail_idx;
+};
+
 struct vduse_dev_config_data {
 	__u32 offset;
 	__u32 len;
@@ -53,6 +60,7 @@ struct vduse_dev_request {
 		struct vduse_vq_num vq_num; /* virtqueue num */
 		struct vduse_vq_addr vq_addr; /* virtqueue address */
 		struct vduse_vq_ready vq_ready; /* virtqueue ready status */
+		struct vduse_vq_state vq_state; /* virtqueue state */
 		struct vduse_dev_config_data config; /* virtio device config space */
 		__u64 features; /* virtio features */
 		__u8 status; /* device status */
@@ -64,6 +72,7 @@ struct vduse_dev_response {
 	__s32 result; /* the result of request */
 	union {
 		struct vduse_vq_ready vq_ready; /* virtqueue ready status */
+		struct vduse_vq_state vq_state; /* virtqueue state */
 		struct vduse_dev_config_data config; /* virtio device config space */
 		__u64 features; /* virtio features */
 		__u8 status; /* device status */
-- 
2.11.0

