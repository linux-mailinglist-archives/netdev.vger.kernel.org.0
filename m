Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D58D2CC96A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbgLBWLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbgLBWLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:11:30 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F170C061A4B
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:10:26 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id w16so111678pga.9
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qXiSxAhJ4A9JePiUyw4j89U2PONGSo4LDlTvKPop6aY=;
        b=kdQNxIR2uZ/CY7Pe09wN0SK+g/UM2YavBIdxE15/u0Dd+6H/afVb1pbQx3BSPYpDnJ
         YKzFj1TFxgwm7d/nUvK0aAPgHAgQSlcr4juKXVqcOErLd5/CGYXfmeNmOpKAAAPUtPVS
         6G8WQJUYa4UOOdOsPzLokWB7G4UWf4EMsz1pGBgh6bjQDMDsFdpPNe6/ODkziPdIiOl0
         Up/cWHx/1H+BbnOBdklJ7cIVf7NDSBhcFVfNQniUEJqLrTpIOVKTADpUtIXLYsr4q2cu
         mPX6FPOIJLmZsvJzO7ia/gKMQc+BPj1A/pBLARFzr3JL9C2ejn3vSWkQKDzGfIppTvjO
         HIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qXiSxAhJ4A9JePiUyw4j89U2PONGSo4LDlTvKPop6aY=;
        b=sZscwIFv1GDmCpKXIgWOXFRB+LqsTW6Xxew4CTmIIzl0KdbFNMMgs4sRyMHzsM+izM
         /9GOLHcspFk43XT9n1Yv7X7Mmz43DBbYwJy6k7oft8H5lj6gsRPHMd2tVf9mUQZXk6iE
         Ax31ftQp/lPjYvBn6bHwniYS0bqGb6Z7sLe/gfjNf1bnSCGVORNsomu66P96DYZoq7WT
         AP68Gr2+e8/XDheWUi3YjoKco3slzjmrMizySnrHNxykVizTPk3sugnOaE8vyHOLI8Fq
         7fiGSr5kwf7SRbpx4H/gOc451MQ4q9djNCkr/apaQlb/gjvMqIqmVPj9+ntlw9Wxo5tw
         a8aw==
X-Gm-Message-State: AOAM5303Q2iJjT8auD2xJo4LvPo18uwH3g3y3WMpcwmT1OWOOFuht1Re
        vp+c/gLy+7nC+sQy6gPNwGwPKsEk7K8=
X-Google-Smtp-Source: ABdhPJwJTTdiyIn/iRtc4wTA+1cFxVkN1rl/yhAgcsn8FPGQoYlBm8VblojeOnwoFHROYMwl//61nQ==
X-Received: by 2002:a05:6a00:848:b029:197:e659:e236 with SMTP id q8-20020a056a000848b0290197e659e236mr79674pfk.74.1606947025725;
        Wed, 02 Dec 2020 14:10:25 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id p16sm4872pju.47.2020.12.02.14.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:10:25 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v2 8/8] net-zerocopy: Defer vm zap unless actually needed.
Date:   Wed,  2 Dec 2020 14:09:45 -0800
Message-Id: <20201202220945.911116-9-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Zapping pages is required only if we are calling vm_insert_page into a
region where pages had previously been mapped. Receive zerocopy allows
reusing such regions, and hitherto called zap_page_range() before
calling vm_insert_page() in that range.

zap_page_range() can also be triggered from userspace with
madvise(MADV_DONTNEED). If userspace is configured to call this before
reusing a segment, or if there was nothing mapped at this virtual
address to begin with, we can avoid calling zap_page_range() under the
socket lock. That said, if userspace does not do that, then we are
still responsible for calling zap_page_range().

This patch adds a flag that the user can use to hint to the kernel
that a zap is not required. If the flag is not set, or if an older
user application does not have a flags field at all, then the kernel
calls zap_page_range as before. Also, if the flag is set but a zap is
still required, the kernel performs that zap as necessary. Thus
incorrectly indicating that a zap can be avoided does not change the
correctness of operation. It also increases the batchsize for
vm_insert_pages and prefetches the page struct for the batch since
we're about to bump the refcount.

An alternative mechanism could be to not have a flag, assume by
default a zap is not needed, and fall back to zapping if needed.
However, this would harm performance for older applications for which
a zap is necessary, and thus we implement it with an explicit flag
so newer applications can opt in.

When using RPC-style traffic with medium sized (tens of KB) RPCs, this
change yields an efficency improvement of about 30% for QPS/CPU usage.
---
 include/uapi/linux/tcp.h |   2 +
 net/ipv4/tcp.c           | 147 ++++++++++++++++++++++++++-------------
 2 files changed, 99 insertions(+), 50 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 62db78b9c1a0..13ceeb395eb8 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -343,6 +343,7 @@ struct tcp_diag_md5sig {
 
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
+#define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
 struct tcp_zerocopy_receive {
 	__u64 address;		/* in: address of mapping */
 	__u32 length;		/* in/out: number of bytes to map/mapped */
@@ -351,5 +352,6 @@ struct tcp_zerocopy_receive {
 	__s32 err; /* out: socket error */
 	__u64 copybuf_address;	/* in: copybuf address (small reads) */
 	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
+	__u32 flags; /* in: flags */
 };
 #endif /* _UAPI_LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 49480ce162db..83d16f04f464 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1909,51 +1909,101 @@ static int tcp_zerocopy_handle_leftover_data(struct tcp_zerocopy_receive *zc,
 	return zc->copybuf_len < 0 ? 0 : copylen;
 }
 
+static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
+					      struct page **pending_pages,
+					      unsigned long pages_remaining,
+					      unsigned long *address,
+					      u32 *length,
+					      u32 *seq,
+					      struct tcp_zerocopy_receive *zc,
+					      u32 total_bytes_to_map,
+					      int err)
+{
+	/* At least one page did not map. Try zapping if we skipped earlier. */
+	if (err == -EBUSY &&
+	    zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT) {
+		u32 maybe_zap_len;
+
+		maybe_zap_len = total_bytes_to_map -  /* All bytes to map */
+				*length + /* Mapped or pending */
+				(pages_remaining * PAGE_SIZE); /* Failed map. */
+		zap_page_range(vma, *address, maybe_zap_len);
+		err = 0;
+	}
+
+	if (!err) {
+		unsigned long leftover_pages = pages_remaining;
+		int bytes_mapped;
+
+		/* We called zap_page_range, try to reinsert. */
+		err = vm_insert_pages(vma, *address,
+				      pending_pages,
+				      &pages_remaining);
+		bytes_mapped = PAGE_SIZE * (leftover_pages - pages_remaining);
+		*seq += bytes_mapped;
+		*address += bytes_mapped;
+	}
+	if (err) {
+		/* Either we were unable to zap, OR we zapped, retried an
+		 * insert, and still had an issue. Either ways, pages_remaining
+		 * is the number of pages we were unable to map, and we unroll
+		 * some state we speculatively touched before.
+		 */
+		const int bytes_not_mapped = PAGE_SIZE * pages_remaining;
+
+		*length -= bytes_not_mapped;
+		zc->recv_skip_hint += bytes_not_mapped;
+	}
+	return err;
+}
+
 static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 					struct page **pages,
-					unsigned long pages_to_map,
-					unsigned long *insert_addr,
-					u32 *length_with_pending,
+					unsigned int pages_to_map,
+					unsigned long *address,
+					u32 *length,
 					u32 *seq,
-					struct tcp_zerocopy_receive *zc)
+					struct tcp_zerocopy_receive *zc,
+					u32 total_bytes_to_map)
 {
 	unsigned long pages_remaining = pages_to_map;
-	int bytes_mapped;
-	int ret;
+	unsigned int pages_mapped;
+	unsigned int bytes_mapped;
+	int err;
 
-	ret = vm_insert_pages(vma, *insert_addr, pages, &pages_remaining);
-	bytes_mapped = PAGE_SIZE * (pages_to_map - pages_remaining);
+	err = vm_insert_pages(vma, *address, pages, &pages_remaining);
+	pages_mapped = pages_to_map - (unsigned int)pages_remaining;
+	bytes_mapped = PAGE_SIZE * pages_mapped;
 	/* Even if vm_insert_pages fails, it may have partially succeeded in
 	 * mapping (some but not all of the pages).
 	 */
 	*seq += bytes_mapped;
-	*insert_addr += bytes_mapped;
-	if (ret) {
-		/* But if vm_insert_pages did fail, we have to unroll some state
-		 * we speculatively touched before.
-		 */
-		const int bytes_not_mapped = PAGE_SIZE * pages_remaining;
-		*length_with_pending -= bytes_not_mapped;
-		zc->recv_skip_hint += bytes_not_mapped;
-	}
-	return ret;
+	*address += bytes_mapped;
+
+	if (likely(!err))
+		return 0;
+
+	/* Error: maybe zap and retry + rollback state for failed inserts. */
+	return tcp_zerocopy_vm_insert_batch_error(vma, pages + pages_mapped,
+		pages_remaining, address, length, seq, zc, total_bytes_to_map,
+		err);
 }
 
+#define TCP_ZEROCOPY_PAGE_BATCH_SIZE 32
 static int tcp_zerocopy_receive(struct sock *sk,
 				struct tcp_zerocopy_receive *zc)
 {
-	u32 length = 0, offset, vma_len, avail_len, aligned_len, copylen = 0;
+	u32 length = 0, offset, vma_len, avail_len, copylen = 0;
 	unsigned long address = (unsigned long)zc->address;
+	struct page *pages[TCP_ZEROCOPY_PAGE_BATCH_SIZE];
 	s32 copybuf_len = zc->copybuf_len;
 	struct tcp_sock *tp = tcp_sk(sk);
-	#define PAGE_BATCH_SIZE 8
-	struct page *pages[PAGE_BATCH_SIZE];
 	const skb_frag_t *frags = NULL;
+	unsigned int pages_to_map = 0;
 	struct vm_area_struct *vma;
 	struct sk_buff *skb = NULL;
-	unsigned long pg_idx = 0;
-	unsigned long curr_addr;
 	u32 seq = tp->copied_seq;
+	u32 total_bytes_to_map;
 	int inq = tcp_inq(sk);
 	int ret;
 
@@ -1987,34 +2037,24 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	}
 	vma_len = min_t(unsigned long, zc->length, vma->vm_end - address);
 	avail_len = min_t(u32, vma_len, inq);
-	aligned_len = avail_len & ~(PAGE_SIZE - 1);
-	if (aligned_len) {
-		zap_page_range(vma, address, aligned_len);
-		zc->length = aligned_len;
+	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
+	if (total_bytes_to_map) {
+		if (!(zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT))
+			zap_page_range(vma, address, total_bytes_to_map);
+		zc->length = total_bytes_to_map;
 		zc->recv_skip_hint = 0;
 	} else {
 		zc->length = avail_len;
 		zc->recv_skip_hint = avail_len;
 	}
 	ret = 0;
-	curr_addr = address;
 	while (length + PAGE_SIZE <= zc->length) {
 		int mappable_offset;
+		struct page *page;
 
 		if (zc->recv_skip_hint < PAGE_SIZE) {
 			u32 offset_frag;
 
-			/* If we're here, finish the current batch. */
-			if (pg_idx) {
-				ret = tcp_zerocopy_vm_insert_batch(vma, pages,
-								   pg_idx,
-								   &curr_addr,
-								   &length,
-								   &seq, zc);
-				if (ret)
-					goto out;
-				pg_idx = 0;
-			}
 			if (skb) {
 				if (zc->recv_skip_hint > 0)
 					break;
@@ -2035,24 +2075,31 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			zc->recv_skip_hint = mappable_offset;
 			break;
 		}
-		pages[pg_idx] = skb_frag_page(frags);
-		pg_idx++;
+		page = skb_frag_page(frags);
+		prefetchw(page);
+		pages[pages_to_map++] = page;
 		length += PAGE_SIZE;
 		zc->recv_skip_hint -= PAGE_SIZE;
 		frags++;
-		if (pg_idx == PAGE_BATCH_SIZE) {
-			ret = tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
-							   &curr_addr, &length,
-							   &seq, zc);
+		if (pages_to_map == TCP_ZEROCOPY_PAGE_BATCH_SIZE ||
+		    zc->recv_skip_hint < PAGE_SIZE) {
+			/* Either full batch, or we're about to go to next skb
+			 * (and we cannot unroll failed ops across skbs).
+			 */
+			ret = tcp_zerocopy_vm_insert_batch(vma, pages,
+							   pages_to_map,
+							   &address, &length,
+							   &seq, zc,
+							   total_bytes_to_map);
 			if (ret)
 				goto out;
-			pg_idx = 0;
+			pages_to_map = 0;
 		}
 	}
-	if (pg_idx) {
-		ret = tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
-						   &curr_addr, &length, &seq,
-						   zc);
+	if (pages_to_map) {
+		ret = tcp_zerocopy_vm_insert_batch(vma, pages, pages_to_map,
+						   &address, &length, &seq,
+						   zc, total_bytes_to_map);
 	}
 out:
 	mmap_read_unlock(current->mm);
-- 
2.29.2.576.ga3fc446d84-goog

