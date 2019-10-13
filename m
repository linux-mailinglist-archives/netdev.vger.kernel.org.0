Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39CE2D5600
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 13:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfJMLmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 07:42:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbfJMLmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 07:42:18 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3AAA885542
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 11:42:18 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id n135so14010120qke.23
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 04:42:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VlkGH0pPsogo4RGpmLxmqdlk6CzYlrN9pEKnKorf1kA=;
        b=WUMwGvbYqc7jwgMXXHdyYPi68oRck4zNX/YTnquwKhiLT0/vgbL2ZUWZH6qrW35B3d
         0DQYf+GOg30vYjE5dhyDPWoyUfmhyUcp1B0/JJqpZdJLVNXOiJtsGptflyQb3XpVLu1w
         F9Bf2ekHA7uDXJbeCj60AbK0M/dYAUloDj52dppIBDwQdkIoIkdMGQubl3cN6FOXsFST
         ZqoOkW7i+ZoqIySsy9+xsBPwA++icrZI8WKnKuUni1tGLnvOnIo6a4y8u2+3/klWXxBA
         Zv7pE3p/Ay6GSCgGTxcLu8RSzxIjQaAmUD8zGKTSax+damXyvPyvzy71cXb7kJnkuCdL
         UMhg==
X-Gm-Message-State: APjAAAVXaACeunJIR2TlGtJLi8CmphZbo56L98XNOsih9HIAjTv9JQgX
        6WOzvsD7Q7XeTB+u2MnXj0Drx4dTTVh7038AxiKtDvjyv7iusZcHY8LAxTRTnUjve0Te6ngEXOL
        6bobzA0T9W3YqCd1t
X-Received: by 2002:ac8:714e:: with SMTP id h14mr27418227qtp.147.1570966937483;
        Sun, 13 Oct 2019 04:42:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyYimpSTvhcckQtLZD53yWv4WgHADBLclb+YHlyxz+Z/NJEvovKmGJ+6dCcHZZQ6RfAZhXcyg==
X-Received: by 2002:ac8:714e:: with SMTP id h14mr27418205qtp.147.1570966937130;
        Sun, 13 Oct 2019 04:42:17 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id t199sm6492912qke.36.2019.10.13.04.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 04:42:16 -0700 (PDT)
Date:   Sun, 13 Oct 2019 07:42:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v4 3/5] vhost: batching fetches
Message-ID: <20191013113940.2863-4-mst@redhat.com>
References: <20191013113940.2863-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013113940.2863-1-mst@redhat.com>
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
 drivers/vhost/vhost.c | 48 +++++++++++++++++++++++++++++++++++--------
 drivers/vhost/vhost.h |  4 +++-
 3 files changed, 44 insertions(+), 10 deletions(-)

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
index 649131c5729c..d46c28149f6f 100644
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
 	unsigned int i, head, found = 0;
 	struct vhost_desc *last;
@@ -2463,7 +2467,11 @@ static int fetch_descs(struct vhost_virtqueue *vq)
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
@@ -2554,6 +2562,24 @@ static int fetch_descs(struct vhost_virtqueue *vq)
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
@@ -2579,12 +2605,12 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
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
@@ -2623,15 +2649,21 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
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
+		if (!(vq->descs[i].flags & VRING_DESC_F_NEXT))
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

