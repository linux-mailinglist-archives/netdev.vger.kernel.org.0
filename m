Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 350ECD41BD
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfJKNqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:46:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbfJKNqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:46:11 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E4CD81F18
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 13:46:10 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id s14so9489468qtn.4
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 06:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F6im2lqehevFxSustm2POiIh1ja/Qr07vzdrmumUKhs=;
        b=rhMSRgx5JhJl7DKHmkGgE1mRgrSHDVNFScRQmGVn0qUQVJwBvhSS/b2wRHJtOPm/8I
         2bnDG+4znqN2VFss+bOJwCC3k9C501DhU57/zbw8mPABcSMfbbb1FBbEUveu1jvE7q3B
         dTP33D5f1tYgQspr5y0zCdbPwjN14DWSFOYmVh/iyRzqPLx3s8oqfLcI56+rxnZksSZV
         Ieu4daYm6YTX4k/N0RTlXWacyZejguOTDO1D/B/KofkJD7kSRT1pZj+GljlDLedetw4j
         KzEVnUqEtLvpiADqHfkQPcaSmCSSyyw24htdOpw9+K/8uwWjQEqGOCGNZ0j3oGbC+xUB
         FxhA==
X-Gm-Message-State: APjAAAWtqJr7QTYkOwG1Gs0dvJniI61o0Kbn+mfuRFl+RmY5rw/tVkpt
        l0YJihWfz6RbT8s74W50+COL+6kLvddLsJvNNLD3pTBfsMX8Zowy//jub4OmYbxCV/HvbT3eJ5k
        T9D6AOXEvXEIDmWIf
X-Received: by 2002:a37:553:: with SMTP id 80mr15786584qkf.353.1570801569681;
        Fri, 11 Oct 2019 06:46:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzBSNIWMgDBULGnfcG8KW2du/s9n4p7y1d/at9ywE/QoZx3W9olBNIl/DZPL5u6Jq/Z1/F99g==
X-Received: by 2002:a37:553:: with SMTP id 80mr15786541qkf.353.1570801569335;
        Fri, 11 Oct 2019 06:46:09 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id y58sm5129799qta.1.2019.10.11.06.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 06:46:08 -0700 (PDT)
Date:   Fri, 11 Oct 2019 09:46:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC v1 2/2] vhost: batching fetches
Message-ID: <20191011134358.16912-3-mst@redhat.com>
References: <20191011134358.16912-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011134358.16912-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patch applied, new and old code perform identically.

Lots of extra optimizations are now possible, e.g.
we can fetch multiple heads with copy_from/to_user now.
We can get rid of maintaining the log array.  Etc etc.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c  |  2 +-
 drivers/vhost/vhost.c | 50 ++++++++++++++++++++++++++++++++++++-------
 drivers/vhost/vhost.h |  4 +++-
 3 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 39a018a7af2d..e3a8e9db22cd 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -128,7 +128,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
 		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
 
 	f->private_data = n;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 36661d6cb51f..aa383e847865 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -302,6 +302,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 {
 	vq->num = 1;
 	vq->ndescs = 0;
+	vq->first_desc = 0;
 	vq->desc = NULL;
 	vq->avail = NULL;
 	vq->used = NULL;
@@ -390,6 +391,7 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
 		vq->max_descs = dev->iov_limit;
+		vq->batch_descs = dev->iov_limit - UIO_MAXIOV;
 		vq->descs = kmalloc_array(vq->max_descs,
 					  sizeof(*vq->descs),
 					  GFP_KERNEL);
@@ -2366,6 +2368,8 @@ static void pop_split_desc(struct vhost_virtqueue *vq)
 	--vq->ndescs;
 }
 
+#define VHOST_DESC_FLAGS (VRING_DESC_F_INDIRECT | VRING_DESC_F_WRITE | \
+			  VRING_DESC_F_NEXT)
 static int push_split_desc(struct vhost_virtqueue *vq, struct vring_desc *desc, u16 id)
 {
 	struct vhost_desc *h;
@@ -2375,7 +2379,7 @@ static int push_split_desc(struct vhost_virtqueue *vq, struct vring_desc *desc,
 	h = &vq->descs[vq->ndescs++];
 	h->addr = vhost64_to_cpu(vq, desc->addr);
 	h->len = vhost32_to_cpu(vq, desc->len);
-	h->flags = vhost16_to_cpu(vq, desc->flags);
+	h->flags = vhost16_to_cpu(vq, desc->flags) & VHOST_DESC_FLAGS;
 	h->id = id;
 
 	return 0;
@@ -2450,7 +2454,7 @@ static int fetch_indirect_descs(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-static int fetch_descs(struct vhost_virtqueue *vq)
+static int fetch_buf(struct vhost_virtqueue *vq)
 {
 	struct vring_desc desc;
 	unsigned int i, head, found = 0;
@@ -2462,7 +2466,11 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	/* Check it isn't doing very strange things with descriptor numbers. */
 	last_avail_idx = vq->last_avail_idx;
 
-	if (vq->avail_idx == vq->last_avail_idx) {
+	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
+		/* If we already have work to do, don't bother re-checking. */
+		if (likely(vq->ndescs))
+			return vq->num;
+
 		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
 			vq_err(vq, "Failed to access avail idx at %p\n",
 				&vq->avail->idx);
@@ -2541,6 +2549,24 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	return 0;
 }
 
+static int fetch_descs(struct vhost_virtqueue *vq)
+{
+	int ret = 0;
+
+	if (unlikely(vq->first_desc >= vq->ndescs)) {
+		vq->first_desc = 0;
+		vq->ndescs = 0;
+	}
+
+	if (vq->ndescs)
+		return 0;
+
+	while (!ret && vq->ndescs <= vq->batch_descs)
+		ret = fetch_buf(vq);
+
+	return vq->ndescs ? 0 : ret;
+}
+
 /* This looks in the virtqueue and for the first available buffer, and converts
  * it to an iovec for convenient access.  Since descriptors consist of some
  * number of output then some number of input descriptors, it's actually two
@@ -2562,6 +2588,8 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
 	if (ret)
 		return ret;
 
+	/* Note: indirect descriptors are not batched */
+	/* TODO: batch up to a limit */
 	last = peek_split_desc(vq);
 	id = last->id;
 
@@ -2584,12 +2612,12 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
 	if (unlikely(log))
 		*log_num = 0;
 
-	for (i = 0; i < vq->ndescs; ++i) {
+	for (i = vq->first_desc; i < vq->ndescs; ++i) {
 		unsigned iov_count = *in_num + *out_num;
 		struct vhost_desc *desc = &vq->descs[i];
 		int access;
 
-		if (desc->flags & ~(VRING_DESC_F_INDIRECT | VRING_DESC_F_WRITE)) {
+		if (desc->flags & ~VHOST_DESC_FLAGS) {
 			vq_err(vq, "Unexpected flags: 0x%x at descriptor id 0x%x\n",
 			       desc->flags, desc->id);
 			ret = -EINVAL;
@@ -2628,15 +2656,21 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
 			}
 			*out_num += ret;
 		}
+
+		ret = desc->id;
+
+		if (!(desc->flags & VRING_DESC_F_NEXT))
+			break;
 	}
 
-	ret = id;
-	vq->ndescs = 0;
+	vq->first_desc = i + 1;
 
 	return ret;
 
 err:
-	vhost_discard_vq_desc(vq, 1);
+	for (i = vq->first_desc; i < vq->ndescs; ++i)
+		if (!(desc->flags & VRING_DESC_F_NEXT))
+			vhost_discard_vq_desc(vq, 1);
 	vq->ndescs = 0;
 
 	return ret;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 1724f61b6c2d..8b88e0c903da 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -100,7 +100,9 @@ struct vhost_virtqueue {
 
 	struct vhost_desc *descs;
 	int ndescs;
+	int first_desc;
 	int max_descs;
+	int batch_descs;
 
 	const struct vhost_umem_node *meta_iotlb[VHOST_NUM_ADDRS];
 	struct file *kick;
@@ -245,7 +247,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
 
 #define vq_err(vq, fmt, ...) do {                                  \
-		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
+		pr_err(pr_fmt(fmt), ##__VA_ARGS__);       \
 		if ((vq)->error_ctx)                               \
 				eventfd_signal((vq)->error_ctx, 1);\
 	} while (0)
-- 
MST

