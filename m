Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AC41F0BD3
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 16:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgFGOLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 10:11:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49837 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726643AbgFGOLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 10:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MNomocnYPHbzHcE+IFuejg9s84X+zufjtkid2cknZoA=;
        b=Gm2YsFatxkmNZDpbhjSTIMjGeBcTZlyB1K/Ujfuh1apmECXoZqeTpoIqprxivfhuai4hfI
        weMJCnpbe19FVgPX4KjOMmef0ad+Su64ev32kxueuhxbmAoh8SkrA9YnXvG2K1kOlNofDy
        LqhPQBr+RdFG+8rsEktCVV0jZIxJWRw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-pkaIQJURM8eHJ46JKP9QcQ-1; Sun, 07 Jun 2020 10:11:29 -0400
X-MC-Unique: pkaIQJURM8eHJ46JKP9QcQ-1
Received: by mail-wm1-f69.google.com with SMTP id r1so626918wmh.7
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 07:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MNomocnYPHbzHcE+IFuejg9s84X+zufjtkid2cknZoA=;
        b=klgK3AL7UKyCQmcEc/2200hfzOr5BOQvPxjOU12F4xCQoMckL/mantUwOv7nL07AqB
         qSAw2uyabnCMvzberNDGG6x/fBeSpraT7DF6qMbIpt+MeXPwDYikoOTqHHnBKcqnWeBx
         6sAAngS7H9VLXNknVjM4SHslcKUgPu7XJbU7Rhs+Gn/uzHIm637shmlhNM5fbhXIGwcD
         GDv0T8hdlnVHusWQDctlIazYOSMJVMWXYjs5KYDYao45WV6HPn5qqaN4OwHJu1bU5XBA
         EYeaGukVBQBZZAGV8VGI4wQXaSNrTGjc6n6RfFFWqEIeoK2dnUQXizVav68tg8YCQxmh
         dB9w==
X-Gm-Message-State: AOAM531hUVz/rf1FZKWeLpjnRF7ldm215hdb5Lm+bqT9nSGqThoyL4Jj
        ruqdxbW808oHVMDSRwb1AK9VTP1HxPEi91IQfLHZjF/3kY8Faj8MMiip451YRrA7aoPJrdZwXQP
        XWiv9N7cABGb4daFX
X-Received: by 2002:a1c:3bc2:: with SMTP id i185mr12228822wma.33.1591539088476;
        Sun, 07 Jun 2020 07:11:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdad21dm6EJ6xbNHajCaM8myJDjPDAs62/UjCzrQbA59rVVDFGCsKzQ80upERpslO3gcMqcw==
X-Received: by 2002:a1c:3bc2:: with SMTP id i185mr12228794wma.33.1591539088121;
        Sun, 07 Jun 2020 07:11:28 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id v7sm15095075wro.76.2020.06.07.07.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:27 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 02/13] vhost: use batched version by default
Message-ID: <20200607141057.704085-3-mst@redhat.com>
References: <20200607141057.704085-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200607141057.704085-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As testing shows no performance change, switch to that now.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Link: https://lore.kernel.org/r/20200401183118.8334-3-eperezma@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 251 +-----------------------------------------
 drivers/vhost/vhost.h |   4 -
 2 files changed, 2 insertions(+), 253 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e682ed551587..33a72edb3ccd 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2078,253 +2078,6 @@ static unsigned next_desc(struct vhost_virtqueue *vq, struct vring_desc *desc)
 	return next;
 }
 
-static int get_indirect(struct vhost_virtqueue *vq,
-			struct iovec iov[], unsigned int iov_size,
-			unsigned int *out_num, unsigned int *in_num,
-			struct vhost_log *log, unsigned int *log_num,
-			struct vring_desc *indirect)
-{
-	struct vring_desc desc;
-	unsigned int i = 0, count, found = 0;
-	u32 len = vhost32_to_cpu(vq, indirect->len);
-	struct iov_iter from;
-	int ret, access;
-
-	/* Sanity check */
-	if (unlikely(len % sizeof desc)) {
-		vq_err(vq, "Invalid length in indirect descriptor: "
-		       "len 0x%llx not multiple of 0x%zx\n",
-		       (unsigned long long)len,
-		       sizeof desc);
-		return -EINVAL;
-	}
-
-	ret = translate_desc(vq, vhost64_to_cpu(vq, indirect->addr), len, vq->indirect,
-			     UIO_MAXIOV, VHOST_ACCESS_RO);
-	if (unlikely(ret < 0)) {
-		if (ret != -EAGAIN)
-			vq_err(vq, "Translation failure %d in indirect.\n", ret);
-		return ret;
-	}
-	iov_iter_init(&from, READ, vq->indirect, ret, len);
-
-	/* We will use the result as an address to read from, so most
-	 * architectures only need a compiler barrier here. */
-	read_barrier_depends();
-
-	count = len / sizeof desc;
-	/* Buffers are chained via a 16 bit next field, so
-	 * we can have at most 2^16 of these. */
-	if (unlikely(count > USHRT_MAX + 1)) {
-		vq_err(vq, "Indirect buffer length too big: %d\n",
-		       indirect->len);
-		return -E2BIG;
-	}
-
-	do {
-		unsigned iov_count = *in_num + *out_num;
-		if (unlikely(++found > count)) {
-			vq_err(vq, "Loop detected: last one at %u "
-			       "indirect size %u\n",
-			       i, count);
-			return -EINVAL;
-		}
-		if (unlikely(!copy_from_iter_full(&desc, sizeof(desc), &from))) {
-			vq_err(vq, "Failed indirect descriptor: idx %d, %zx\n",
-			       i, (size_t)vhost64_to_cpu(vq, indirect->addr) + i * sizeof desc);
-			return -EINVAL;
-		}
-		if (unlikely(desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT))) {
-			vq_err(vq, "Nested indirect descriptor: idx %d, %zx\n",
-			       i, (size_t)vhost64_to_cpu(vq, indirect->addr) + i * sizeof desc);
-			return -EINVAL;
-		}
-
-		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
-			access = VHOST_ACCESS_WO;
-		else
-			access = VHOST_ACCESS_RO;
-
-		ret = translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
-				     vhost32_to_cpu(vq, desc.len), iov + iov_count,
-				     iov_size - iov_count, access);
-		if (unlikely(ret < 0)) {
-			if (ret != -EAGAIN)
-				vq_err(vq, "Translation failure %d indirect idx %d\n",
-					ret, i);
-			return ret;
-		}
-		/* If this is an input descriptor, increment that count. */
-		if (access == VHOST_ACCESS_WO) {
-			*in_num += ret;
-			if (unlikely(log && ret)) {
-				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
-				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
-				++*log_num;
-			}
-		} else {
-			/* If it's an output descriptor, they're all supposed
-			 * to come before any input descriptors. */
-			if (unlikely(*in_num)) {
-				vq_err(vq, "Indirect descriptor "
-				       "has out after in: idx %d\n", i);
-				return -EINVAL;
-			}
-			*out_num += ret;
-		}
-	} while ((i = next_desc(vq, &desc)) != -1);
-	return 0;
-}
-
-/* This looks in the virtqueue and for the first available buffer, and converts
- * it to an iovec for convenient access.  Since descriptors consist of some
- * number of output then some number of input descriptors, it's actually two
- * iovecs, but we pack them into one and note how many of each there were.
- *
- * This function returns the descriptor number found, or vq->num (which is
- * never a valid descriptor number) if none was found.  A negative code is
- * returned on error. */
-int vhost_get_vq_desc(struct vhost_virtqueue *vq,
-		      struct iovec iov[], unsigned int iov_size,
-		      unsigned int *out_num, unsigned int *in_num,
-		      struct vhost_log *log, unsigned int *log_num)
-{
-	struct vring_desc desc;
-	unsigned int i, head, found = 0;
-	u16 last_avail_idx;
-	__virtio16 avail_idx;
-	__virtio16 ring_head;
-	int ret, access;
-
-	/* Check it isn't doing very strange things with descriptor numbers. */
-	last_avail_idx = vq->last_avail_idx;
-
-	if (vq->avail_idx == vq->last_avail_idx) {
-		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
-			vq_err(vq, "Failed to access avail idx at %p\n",
-				&vq->avail->idx);
-			return -EFAULT;
-		}
-		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
-
-		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
-			vq_err(vq, "Guest moved used index from %u to %u",
-				last_avail_idx, vq->avail_idx);
-			return -EFAULT;
-		}
-
-		/* If there's nothing new since last we looked, return
-		 * invalid.
-		 */
-		if (vq->avail_idx == last_avail_idx)
-			return vq->num;
-
-		/* Only get avail ring entries after they have been
-		 * exposed by guest.
-		 */
-		smp_rmb();
-	}
-
-	/* Grab the next descriptor number they're advertising, and increment
-	 * the index we've seen. */
-	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
-		vq_err(vq, "Failed to read head: idx %d address %p\n",
-		       last_avail_idx,
-		       &vq->avail->ring[last_avail_idx % vq->num]);
-		return -EFAULT;
-	}
-
-	head = vhost16_to_cpu(vq, ring_head);
-
-	/* If their number is silly, that's an error. */
-	if (unlikely(head >= vq->num)) {
-		vq_err(vq, "Guest says index %u > %u is available",
-		       head, vq->num);
-		return -EINVAL;
-	}
-
-	/* When we start there are none of either input nor output. */
-	*out_num = *in_num = 0;
-	if (unlikely(log))
-		*log_num = 0;
-
-	i = head;
-	do {
-		unsigned iov_count = *in_num + *out_num;
-		if (unlikely(i >= vq->num)) {
-			vq_err(vq, "Desc index is %u > %u, head = %u",
-			       i, vq->num, head);
-			return -EINVAL;
-		}
-		if (unlikely(++found > vq->num)) {
-			vq_err(vq, "Loop detected: last one at %u "
-			       "vq size %u head %u\n",
-			       i, vq->num, head);
-			return -EINVAL;
-		}
-		ret = vhost_get_desc(vq, &desc, i);
-		if (unlikely(ret)) {
-			vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
-			       i, vq->desc + i);
-			return -EFAULT;
-		}
-		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT)) {
-			ret = get_indirect(vq, iov, iov_size,
-					   out_num, in_num,
-					   log, log_num, &desc);
-			if (unlikely(ret < 0)) {
-				if (ret != -EAGAIN)
-					vq_err(vq, "Failure detected "
-						"in indirect descriptor at idx %d\n", i);
-				return ret;
-			}
-			continue;
-		}
-
-		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
-			access = VHOST_ACCESS_WO;
-		else
-			access = VHOST_ACCESS_RO;
-		ret = translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
-				     vhost32_to_cpu(vq, desc.len), iov + iov_count,
-				     iov_size - iov_count, access);
-		if (unlikely(ret < 0)) {
-			if (ret != -EAGAIN)
-				vq_err(vq, "Translation failure %d descriptor idx %d\n",
-					ret, i);
-			return ret;
-		}
-		if (access == VHOST_ACCESS_WO) {
-			/* If this is an input descriptor,
-			 * increment that count. */
-			*in_num += ret;
-			if (unlikely(log && ret)) {
-				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
-				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
-				++*log_num;
-			}
-		} else {
-			/* If it's an output descriptor, they're all supposed
-			 * to come before any input descriptors. */
-			if (unlikely(*in_num)) {
-				vq_err(vq, "Descriptor has out after in: "
-				       "idx %d\n", i);
-				return -EINVAL;
-			}
-			*out_num += ret;
-		}
-	} while ((i = next_desc(vq, &desc)) != -1);
-
-	/* On success, increment avail index. */
-	vq->last_avail_idx++;
-
-	/* Assume notifications from guest are disabled at this point,
-	 * if they aren't we would need to update avail_event index. */
-	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
-	return head;
-}
-EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
-
 static struct vhost_desc *peek_split_desc(struct vhost_virtqueue *vq)
 {
 	BUG_ON(!vq->ndescs);
@@ -2538,7 +2291,7 @@ static int fetch_descs(struct vhost_virtqueue *vq)
  * This function returns the descriptor number found, or vq->num (which is
  * never a valid descriptor number) if none was found.  A negative code is
  * returned on error. */
-int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
+int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		      struct iovec iov[], unsigned int iov_size,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num)
@@ -2613,7 +2366,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
+EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 87089d51490d..8a7b4191bc48 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -189,10 +189,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
 
-int vhost_get_vq_desc_batch(struct vhost_virtqueue *,
-		      struct iovec iov[], unsigned int iov_count,
-		      unsigned int *out_num, unsigned int *in_num,
-		      struct vhost_log *log, unsigned int *log_num);
 int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_count,
 		      unsigned int *out_num, unsigned int *in_num,
-- 
MST

