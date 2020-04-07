Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB211A045D
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 03:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgDGBRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 21:17:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53679 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726924AbgDGBRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 21:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586222231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8mgU4qPEQl/RF2AoqyTwEFpdBnBeIddoD97BtvkCas=;
        b=Ea+E8WTDqmzbkHvxZAPfYaO7ucAa1+OqPuWzfgLcJHBR5GGAwMTQyhqouU4I5szCK7LodP
        LwoeByyu4nk/4DIlgnoZdt9HpLGEjy2OBnBvWb3u52+xPQTWSOHHGamZZBZu5hfp+AkSVS
        caEat2CESGJ9JKNX+rfnwoRkx9eUfA8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-scZdJe_mPEW8Et-TyQgIag-1; Mon, 06 Apr 2020 21:17:09 -0400
X-MC-Unique: scZdJe_mPEW8Et-TyQgIag-1
Received: by mail-wr1-f71.google.com with SMTP id o10so863537wrj.7
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 18:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=q8mgU4qPEQl/RF2AoqyTwEFpdBnBeIddoD97BtvkCas=;
        b=KA4EiHDM2Sv7tdNRa/qA7RokCwEwovpHxcEcepuu5Mqunm1spE7RAqTOHAdK4dNbb6
         zNb6tsHLVUKORtheMBI5w2uW8bFXpfNHDlP32l9q4oQkVnAcHJiSOn5hmMFx9FkYqEPV
         wL/TiUKOFKRVuUd495+aCCfHBS1KHESwDy3CqDwaA2gQ5MScniz6gAuz1c+0uW3YySJF
         g6WRrBUO59S3hO0rhfPAyZ9wTqX3q/pTT40JJ+V9Vw1xBMIG6iQ88dbfSbBwHkI6hxLc
         5lGo9qOi1WI0OcuovUOPbH3aKsQgeONOUpJ+5IKFpdnn5URMsvKQ5bO8A4hVe0/Em/i5
         FLvQ==
X-Gm-Message-State: AGi0PuZ+n0JN7vy2meCoY9JPiQdV201sOrtWqp8mK1OuJ8ZBAMoYqVnh
        OxCYQfV9ySbBfs6dwRxdPJxq2sF7/T+8Dqzmho07awVza3BcNF1H8NLvgnhLnLm+3g+R6pZn2Qa
        JuKN7+Sx2IE2OAPrb
X-Received: by 2002:a05:6000:1090:: with SMTP id y16mr1909180wrw.281.1586222227681;
        Mon, 06 Apr 2020 18:17:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypLtBxE+HkrUnnHVyuz+axir9MepIxi3HViZ5ceUiLom3LyV4EJqP3pCaNddYE/EJgQO/vovpw==
X-Received: by 2002:a05:6000:1090:: with SMTP id y16mr1909144wrw.281.1586222227305;
        Mon, 06 Apr 2020 18:17:07 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id f1sm30369785wrv.37.2020.04.06.18.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:17:06 -0700 (PDT)
Date:   Mon, 6 Apr 2020 21:17:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v8 18/19] vhost: use batched version by default
Message-ID: <20200407011612.478226-19-mst@redhat.com>
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
index 56593ba6decc..6ca658c21e15 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2038,253 +2038,6 @@ static unsigned next_desc(struct vhost_virtqueue *vq, struct vring_desc *desc)
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
@@ -2495,7 +2248,7 @@ static int fetch_descs(struct vhost_virtqueue *vq)
  * This function returns the descriptor number found, or vq->num (which is
  * never a valid descriptor number) if none was found.  A negative code is
  * returned on error. */
-int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
+int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		      struct iovec iov[], unsigned int iov_size,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num)
@@ -2570,7 +2323,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
+EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 0976a2853935..76356edee8e5 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -187,10 +187,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
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

