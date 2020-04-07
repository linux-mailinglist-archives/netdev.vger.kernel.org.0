Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6964A1A045B
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 03:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgDGBRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 21:17:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34588 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726882AbgDGBRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 21:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586222233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4yUJTneo14gmnV6yvCsrtosUccNNJJsj0HwyG8nxy8=;
        b=dYDUoHtjRkXZ+xjWapTkM64AhkSsBNogYXtxJAE4BqLvL+dZwKsYhapp9jq7FcPPT88UO8
        P6TAAKaOiBNQzlV/fjZhU/VEuIznVMVM1RFkZd9SqWaNffkvA5CRQRhsndzNrMvj9QYRlB
        BbPv950ebFQcnApjoo1wjhBx/3fdNu0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-sXujBEmtPwq5T-iIalohZQ-1; Mon, 06 Apr 2020 21:17:11 -0400
X-MC-Unique: sXujBEmtPwq5T-iIalohZQ-1
Received: by mail-wm1-f70.google.com with SMTP id y1so16811wmj.3
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 18:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=L4yUJTneo14gmnV6yvCsrtosUccNNJJsj0HwyG8nxy8=;
        b=XZd6qLRliVhSynNQolIxwE0Dn0FByIOmGYTG5Z7B6tz+K4yYN1/GnymHz1eLhApReq
         zgHj++Oz5HsZFPKQcJ/5hIPtNG7oFTMTzfs3Qb6jWocOnDvEVTa9mc3kDHYt+WOij2Xb
         vBv7lkgGlzdfmsrefMmrxvMcPHwydg0DSTlPJOCJrBsHAy5/6va/QhIMBMAPMbf5utE4
         lLCo5SHKiOh+QzuR+HcexT2nJbeAxqVmP/xJsdg9oxDFFB95mtDsgnB8FVRxOS2IEErK
         3PdvL243KeL0AM3U52/6tyfCYCczyZtNos9zr9AD9ebjGU2Wzw7ZnEeRDGcLbnChBQHB
         0peg==
X-Gm-Message-State: AGi0PuZx3lDgAPpvgl1K/fTYY0c1f/sw/Z9KQyE7BRAnjD/kk6AQCkpY
        AiWzSr1eiGBDimlaJ1cLxy+meUMHvf6NHLO968nNDyANll2GglCRfgngZabfpFLGqtaboNk1eWB
        poxpaP9Ej9qJoXmQw
X-Received: by 2002:a1c:5fc4:: with SMTP id t187mr374383wmb.181.1586222229740;
        Mon, 06 Apr 2020 18:17:09 -0700 (PDT)
X-Google-Smtp-Source: APiQypKkiNknhVaK+RZPuldKf4eAt3hD9+QrpIeBJqjHyc1vicdnoI2VoW6Zw94N1UlJe5J6ZKdvFQ==
X-Received: by 2002:a1c:5fc4:: with SMTP id t187mr374365wmb.181.1586222229459;
        Mon, 06 Apr 2020 18:17:09 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id a145sm122477wmd.20.2020.04.06.18.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:17:09 -0700 (PDT)
Date:   Mon, 6 Apr 2020 21:17:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v8 19/19] vhost: batching fetches
Message-ID: <20200407011612.478226-20-mst@redhat.com>
References: <20200407011612.478226-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200407011612.478226-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
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
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Link: https://lore.kernel.org/r/20200401183118.8334-4-eperezma@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c  |  2 +-
 drivers/vhost/vhost.c | 47 ++++++++++++++++++++++++++++++++++++++-----
 drivers/vhost/vhost.h |  5 ++++-
 3 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index b06680833f03..251ca723ac3f 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
 		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
 
 	f->private_data = n;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 6ca658c21e15..0395229486a9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -299,6 +299,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 {
 	vq->num = 1;
 	vq->ndescs = 0;
+	vq->first_desc = 0;
 	vq->desc = NULL;
 	vq->avail = NULL;
 	vq->used = NULL;
@@ -367,6 +368,11 @@ static int vhost_worker(void *data)
 	return 0;
 }
 
+static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
+{
+	return vq->max_descs - UIO_MAXIOV;
+}
+
 static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 {
 	kfree(vq->descs);
@@ -389,6 +395,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
 		vq->max_descs = dev->iov_limit;
+		if (vhost_vq_num_batch_descs(vq) < 0) {
+			return -EINVAL;
+		}
 		vq->descs = kmalloc_array(vq->max_descs,
 					  sizeof(*vq->descs),
 					  GFP_KERNEL);
@@ -1570,6 +1579,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 		vq->last_avail_idx = s.num;
 		/* Forget the cached index value. */
 		vq->avail_idx = vq->last_avail_idx;
+		vq->ndescs = vq->first_desc = 0;
 		break;
 	case VHOST_GET_VRING_BASE:
 		s.index = idx;
@@ -2136,7 +2146,7 @@ static int fetch_indirect_descs(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-static int fetch_descs(struct vhost_virtqueue *vq)
+static int fetch_buf(struct vhost_virtqueue *vq)
 {
 	unsigned int i, head, found = 0;
 	struct vhost_desc *last;
@@ -2149,7 +2159,11 @@ static int fetch_descs(struct vhost_virtqueue *vq)
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
@@ -2240,6 +2254,24 @@ static int fetch_descs(struct vhost_virtqueue *vq)
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
+	while (!ret && vq->ndescs <= vhost_vq_num_batch_descs(vq))
+		ret = fetch_buf(vq);
+
+	return vq->ndescs ? 0 : ret;
+}
+
 /* This looks in the virtqueue and for the first available buffer, and converts
  * it to an iovec for convenient access.  Since descriptors consist of some
  * number of output then some number of input descriptors, it's actually two
@@ -2265,7 +2297,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	if (unlikely(log))
 		*log_num = 0;
 
-	for (i = 0; i < vq->ndescs; ++i) {
+	for (i = vq->first_desc; i < vq->ndescs; ++i) {
 		unsigned iov_count = *in_num + *out_num;
 		struct vhost_desc *desc = &vq->descs[i];
 		int access;
@@ -2311,14 +2343,19 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		}
 
 		ret = desc->id;
+
+		if (!(desc->flags & VRING_DESC_F_NEXT))
+			break;
 	}
 
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
index 76356edee8e5..a67bda9792ec 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -81,6 +81,7 @@ struct vhost_virtqueue {
 
 	struct vhost_desc *descs;
 	int ndescs;
+	int first_desc;
 	int max_descs;
 
 	struct file *kick;
@@ -229,7 +230,7 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 			  struct vhost_iotlb_map *map);
 
 #define vq_err(vq, fmt, ...) do {                                  \
-		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
+		pr_err(pr_fmt(fmt), ##__VA_ARGS__);       \
 		if ((vq)->error_ctx)                               \
 				eventfd_signal((vq)->error_ctx, 1);\
 	} while (0)
@@ -255,6 +256,8 @@ static inline void vhost_vq_set_backend(struct vhost_virtqueue *vq,
 					void *private_data)
 {
 	vq->private_data = private_data;
+	vq->ndescs = 0;
+	vq->first_desc = 0;
 }
 
 /**
-- 
MST

