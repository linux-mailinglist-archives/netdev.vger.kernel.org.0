Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06231F1968
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgFHMz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:55:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33777 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728007AbgFHMxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pyZgoc1IoaMWB9Jefr7e/GoAFJJxo7imj3dgpBB/etA=;
        b=MIkoL279Rs5lwqGyWsNvXdGFNE1oUgW44V7RSdCSvGbTFXmZxncrySsD1PT9SDbtGnnQx9
        iQphV1ppTqzObFRHfFoSBZxvoVYNbu9ExqNA/pojgviCap5/gyGxCDVdEaTxtG6ubYzHoA
        8bReyyeAs1sTFEWd82PqNdsqVbfndmM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511--D4hnQiePiusV9EVhe4D8w-1; Mon, 08 Jun 2020 08:52:57 -0400
X-MC-Unique: -D4hnQiePiusV9EVhe4D8w-1
Received: by mail-wm1-f70.google.com with SMTP id a7so1503182wmf.1
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 05:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pyZgoc1IoaMWB9Jefr7e/GoAFJJxo7imj3dgpBB/etA=;
        b=SAeEOTD4rea/ac9SO85hZ4oRMnyovzA0Q2WsJI/NioCCLvtROkvuW5WXdYiB0YxV2z
         NL/nMfB3AU9LM9SEoVJ7JJvhnKokVc4ih5i2R5TacDyWk/RXK5APf13BvOA3YX/Ko28X
         XFFbSqbxIcYohM19ld8+4/8+7Lp12vKz0Lq7qwHk5hST7WnXBzFL4vfo2Y7eY5BeMARn
         exJjDIV/kTAnuHvPOqCybRbfylcIiqaF7Q8VeiaZoLftk89mFUY127+dLgiLkUrsAE41
         BfTlacgefrIOfmr7cdoKj/h8+2uIV8oSxz7RcO0dKNPBNi+lBikMg/9CJvIwHv2ZNP+c
         jDTA==
X-Gm-Message-State: AOAM533lWiIRZPtzZlZyT+8c64I/RXajNmDgCRSDn+HUonb6p14B+2BU
        RRoBCI3cPzl70C73c8U8k3zGQL9hjguXr01ETIWKY2JDq0Na8PhNgOweFFqTfnyUHcjhOEjMKI7
        tNYJlQhr8ykw6S6nX
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr17016540wmi.165.1591620776335;
        Mon, 08 Jun 2020 05:52:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEdknqoJU3HSkUfhKPXzphp7+7B7/1HQpacB61dXsZyraKBYychpqxInl7px+4iWcK/8HI/Q==
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr17016499wmi.165.1591620775843;
        Mon, 08 Jun 2020 05:52:55 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id g187sm22919251wma.17.2020.06.08.05.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:52:55 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:52:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v6 01/11] vhost: option to fetch descriptors through an
 independent struct
Message-ID: <20200608125238.728563-2-mst@redhat.com>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idea is to support multiple ring formats by converting
to a format-independent array of descriptors.

This costs extra cycles, but we gain in ability
to fetch a batch of descriptors in one go, which
is good for code cache locality.

When used, this causes a minor performance degradation,
it's been kept as simple as possible for ease of review.
A follow-up patch gets us back the performance by adding batching.

To simplify benchmarking, I kept the old code around so one can switch
back and forth between old and new code. This will go away in the final
submission.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Link: https://lore.kernel.org/r/20200401183118.8334-2-eperezma@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 305 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  16 +++
 2 files changed, 320 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 172da092107e..180b7b58c76b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -303,6 +303,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
 {
 	vq->num = 1;
+	vq->ndescs = 0;
 	vq->desc = NULL;
 	vq->avail = NULL;
 	vq->used = NULL;
@@ -373,6 +374,9 @@ static int vhost_worker(void *data)
 
 static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 {
+	kfree(vq->descs);
+	vq->descs = NULL;
+	vq->max_descs = 0;
 	kfree(vq->indirect);
 	vq->indirect = NULL;
 	kfree(vq->log);
@@ -389,6 +393,10 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
+		vq->max_descs = dev->iov_limit;
+		vq->descs = kmalloc_array(vq->max_descs,
+					  sizeof(*vq->descs),
+					  GFP_KERNEL);
 		vq->indirect = kmalloc_array(UIO_MAXIOV,
 					     sizeof(*vq->indirect),
 					     GFP_KERNEL);
@@ -396,7 +404,7 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 					GFP_KERNEL);
 		vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
 					  GFP_KERNEL);
-		if (!vq->indirect || !vq->log || !vq->heads)
+		if (!vq->indirect || !vq->log || !vq->heads || !vq->descs)
 			goto err_nomem;
 	}
 	return 0;
@@ -488,6 +496,8 @@ void vhost_dev_init(struct vhost_dev *dev,
 
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
+		vq->descs = NULL;
+		vq->max_descs = 0;
 		vq->log = NULL;
 		vq->indirect = NULL;
 		vq->heads = NULL;
@@ -2315,6 +2325,299 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
+static struct vhost_desc *peek_split_desc(struct vhost_virtqueue *vq)
+{
+	BUG_ON(!vq->ndescs);
+	return &vq->descs[vq->ndescs - 1];
+}
+
+static void pop_split_desc(struct vhost_virtqueue *vq)
+{
+	BUG_ON(!vq->ndescs);
+	--vq->ndescs;
+}
+
+#define VHOST_DESC_FLAGS (VRING_DESC_F_INDIRECT | VRING_DESC_F_WRITE | \
+			  VRING_DESC_F_NEXT)
+static int push_split_desc(struct vhost_virtqueue *vq, struct vring_desc *desc, u16 id)
+{
+	struct vhost_desc *h;
+
+	if (unlikely(vq->ndescs >= vq->max_descs))
+		return -EINVAL;
+	h = &vq->descs[vq->ndescs++];
+	h->addr = vhost64_to_cpu(vq, desc->addr);
+	h->len = vhost32_to_cpu(vq, desc->len);
+	h->flags = vhost16_to_cpu(vq, desc->flags) & VHOST_DESC_FLAGS;
+	h->id = id;
+
+	return 0;
+}
+
+static int fetch_indirect_descs(struct vhost_virtqueue *vq,
+				struct vhost_desc *indirect,
+				u16 head)
+{
+	struct vring_desc desc;
+	unsigned int i = 0, count, found = 0;
+	u32 len = indirect->len;
+	struct iov_iter from;
+	int ret;
+
+	/* Sanity check */
+	if (unlikely(len % sizeof desc)) {
+		vq_err(vq, "Invalid length in indirect descriptor: "
+		       "len 0x%llx not multiple of 0x%zx\n",
+		       (unsigned long long)len,
+		       sizeof desc);
+		return -EINVAL;
+	}
+
+	ret = translate_desc(vq, indirect->addr, len, vq->indirect,
+			     UIO_MAXIOV, VHOST_ACCESS_RO);
+	if (unlikely(ret < 0)) {
+		if (ret != -EAGAIN)
+			vq_err(vq, "Translation failure %d in indirect.\n", ret);
+		return ret;
+	}
+	iov_iter_init(&from, READ, vq->indirect, ret, len);
+
+	/* We will use the result as an address to read from, so most
+	 * architectures only need a compiler barrier here. */
+	read_barrier_depends();
+
+	count = len / sizeof desc;
+	/* Buffers are chained via a 16 bit next field, so
+	 * we can have at most 2^16 of these. */
+	if (unlikely(count > USHRT_MAX + 1)) {
+		vq_err(vq, "Indirect buffer length too big: %d\n",
+		       indirect->len);
+		return -E2BIG;
+	}
+	if (unlikely(vq->ndescs + count > vq->max_descs)) {
+		vq_err(vq, "Too many indirect + direct descs: %d + %d\n",
+		       vq->ndescs, indirect->len);
+		return -E2BIG;
+	}
+
+	do {
+		if (unlikely(++found > count)) {
+			vq_err(vq, "Loop detected: last one at %u "
+			       "indirect size %u\n",
+			       i, count);
+			return -EINVAL;
+		}
+		if (unlikely(!copy_from_iter_full(&desc, sizeof(desc), &from))) {
+			vq_err(vq, "Failed indirect descriptor: idx %d, %zx\n",
+			       i, (size_t)indirect->addr + i * sizeof desc);
+			return -EINVAL;
+		}
+		if (unlikely(desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT))) {
+			vq_err(vq, "Nested indirect descriptor: idx %d, %zx\n",
+			       i, (size_t)indirect->addr + i * sizeof desc);
+			return -EINVAL;
+		}
+
+		/* Note: push_split_desc can't fail here:
+		 * we never fetch unless there's space. */
+		ret = push_split_desc(vq, &desc, head);
+		WARN_ON(ret);
+	} while ((i = next_desc(vq, &desc)) != -1);
+	return 0;
+}
+
+/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
+ * A negative code is returned on error. */
+static int fetch_descs(struct vhost_virtqueue *vq)
+{
+	unsigned int i, head, found = 0;
+	struct vhost_desc *last;
+	struct vring_desc desc;
+	__virtio16 avail_idx;
+	__virtio16 ring_head;
+	u16 last_avail_idx;
+	int ret;
+
+	/* Check it isn't doing very strange things with descriptor numbers. */
+	last_avail_idx = vq->last_avail_idx;
+
+	if (vq->avail_idx == vq->last_avail_idx) {
+		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
+			vq_err(vq, "Failed to access avail idx at %p\n",
+				&vq->avail->idx);
+			return -EFAULT;
+		}
+		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
+
+		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
+			vq_err(vq, "Guest moved used index from %u to %u",
+				last_avail_idx, vq->avail_idx);
+			return -EFAULT;
+		}
+
+		/* If there's nothing new since last we looked, return
+		 * invalid.
+		 */
+		if (vq->avail_idx == last_avail_idx)
+			return 0;
+
+		/* Only get avail ring entries after they have been
+		 * exposed by guest.
+		 */
+		smp_rmb();
+	}
+
+	/* Grab the next descriptor number they're advertising */
+	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
+		vq_err(vq, "Failed to read head: idx %d address %p\n",
+		       last_avail_idx,
+		       &vq->avail->ring[last_avail_idx % vq->num]);
+		return -EFAULT;
+	}
+
+	head = vhost16_to_cpu(vq, ring_head);
+
+	/* If their number is silly, that's an error. */
+	if (unlikely(head >= vq->num)) {
+		vq_err(vq, "Guest says index %u > %u is available",
+		       head, vq->num);
+		return -EINVAL;
+	}
+
+	i = head;
+	do {
+		if (unlikely(i >= vq->num)) {
+			vq_err(vq, "Desc index is %u > %u, head = %u",
+			       i, vq->num, head);
+			return -EINVAL;
+		}
+		if (unlikely(++found > vq->num)) {
+			vq_err(vq, "Loop detected: last one at %u "
+			       "vq size %u head %u\n",
+			       i, vq->num, head);
+			return -EINVAL;
+		}
+		ret = vhost_get_desc(vq, &desc, i);
+		if (unlikely(ret)) {
+			vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
+			       i, vq->desc + i);
+			return -EFAULT;
+		}
+		ret = push_split_desc(vq, &desc, head);
+		if (unlikely(ret)) {
+			vq_err(vq, "Failed to save descriptor: idx %d\n", i);
+			return -EINVAL;
+		}
+	} while ((i = next_desc(vq, &desc)) != -1);
+
+	last = peek_split_desc(vq);
+	if (unlikely(last->flags & VRING_DESC_F_INDIRECT)) {
+		pop_split_desc(vq);
+		ret = fetch_indirect_descs(vq, last, head);
+		if (unlikely(ret < 0)) {
+			if (ret != -EAGAIN)
+				vq_err(vq, "Failure detected "
+				       "in indirect descriptor at idx %d\n", head);
+			return ret;
+		}
+	}
+
+	/* Assume notifications from guest are disabled at this point,
+	 * if they aren't we would need to update avail_event index. */
+	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
+
+	/* On success, increment avail index. */
+	vq->last_avail_idx++;
+
+	return 1;
+}
+
+/* This looks in the virtqueue and for the first available buffer, and converts
+ * it to an iovec for convenient access.  Since descriptors consist of some
+ * number of output then some number of input descriptors, it's actually two
+ * iovecs, but we pack them into one and note how many of each there were.
+ *
+ * This function returns the descriptor number found, or vq->num (which is
+ * never a valid descriptor number) if none was found.  A negative code is
+ * returned on error. */
+int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
+		      struct iovec iov[], unsigned int iov_size,
+		      unsigned int *out_num, unsigned int *in_num,
+		      struct vhost_log *log, unsigned int *log_num)
+{
+	int ret = fetch_descs(vq);
+	int i;
+
+	if (ret <= 0)
+		goto err_fetch;
+
+	/* Now convert to IOV */
+	/* When we start there are none of either input nor output. */
+	*out_num = *in_num = 0;
+	if (unlikely(log))
+		*log_num = 0;
+
+	for (i = 0; i < vq->ndescs; ++i) {
+		unsigned iov_count = *in_num + *out_num;
+		struct vhost_desc *desc = &vq->descs[i];
+		int access;
+
+		if (desc->flags & ~VHOST_DESC_FLAGS) {
+			vq_err(vq, "Unexpected flags: 0x%x at descriptor id 0x%x\n",
+			       desc->flags, desc->id);
+			ret = -EINVAL;
+			goto err;
+		}
+		if (desc->flags & VRING_DESC_F_WRITE)
+			access = VHOST_ACCESS_WO;
+		else
+			access = VHOST_ACCESS_RO;
+		ret = translate_desc(vq, desc->addr,
+				     desc->len, iov + iov_count,
+				     iov_size - iov_count, access);
+		if (unlikely(ret < 0)) {
+			if (ret != -EAGAIN)
+				vq_err(vq, "Translation failure %d descriptor idx %d\n",
+					ret, i);
+			goto err;
+		}
+		if (access == VHOST_ACCESS_WO) {
+			/* If this is an input descriptor,
+			 * increment that count. */
+			*in_num += ret;
+			if (unlikely(log && ret)) {
+				log[*log_num].addr = desc->addr;
+				log[*log_num].len = desc->len;
+				++*log_num;
+			}
+		} else {
+			/* If it's an output descriptor, they're all supposed
+			 * to come before any input descriptors. */
+			if (unlikely(*in_num)) {
+				vq_err(vq, "Descriptor has out after in: "
+				       "idx %d\n", i);
+				ret = -EINVAL;
+				goto err;
+			}
+			*out_num += ret;
+		}
+
+		ret = desc->id;
+	}
+
+	vq->ndescs = 0;
+
+	return ret;
+
+err:
+	vhost_discard_vq_desc(vq, 1);
+err_fetch:
+	vq->ndescs = 0;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
+
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index c8e96a095d3b..87089d51490d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -60,6 +60,13 @@ enum vhost_uaddr_type {
 	VHOST_NUM_ADDRS = 3,
 };
 
+struct vhost_desc {
+	u64 addr;
+	u32 len;
+	u16 flags; /* VRING_DESC_F_WRITE, VRING_DESC_F_NEXT */
+	u16 id;
+};
+
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
@@ -71,6 +78,11 @@ struct vhost_virtqueue {
 	vring_avail_t __user *avail;
 	vring_used_t __user *used;
 	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
+
+	struct vhost_desc *descs;
+	int ndescs;
+	int max_descs;
+
 	struct file *kick;
 	struct eventfd_ctx *call_ctx;
 	struct eventfd_ctx *error_ctx;
@@ -177,6 +189,10 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
 
+int vhost_get_vq_desc_batch(struct vhost_virtqueue *,
+		      struct iovec iov[], unsigned int iov_count,
+		      unsigned int *out_num, unsigned int *in_num,
+		      struct vhost_log *log, unsigned int *log_num);
 int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_count,
 		      unsigned int *out_num, unsigned int *in_num,
-- 
MST

