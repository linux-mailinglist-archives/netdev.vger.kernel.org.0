Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B192B0D64
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgKLTDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgKLTDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:03:06 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E9BC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:03:06 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f27so5000231pgl.1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bxWPmmqXRCqqJnJ/gmtyQ3yO6P918qwJPyfH8rwd70M=;
        b=RgVdynPuJ3ZKfTYtlhq6PtODYm8fGXxfh9D9sHJIcN6gFy/NYVfs9X5dAAUHM4OHAG
         7m0hth9rAyT/zopKi6mh3d06Q246vbxpGiMUyhtEdu1C4zTaifIzxFI6zQhteMylFaxn
         anWWmI8cBwfRJ2VZmpJKZGXXnQHa8NwNW5jeLDOTlp3wLBvf8m76fCzpnwp8b6Pfii+q
         BSHBNCq2Y4lSOs5DWDPdVoHeKZUaV4+mfQ3bKk/Wr4+SiE2EERDJnatM2tPITFcDfyf+
         YDXCtDvd5UP3N4Lz8DkbGbQpB1+mJPSEPrLNvy6MSfYKA6WzZUfhmMxAOyVd0awVavaf
         2ZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bxWPmmqXRCqqJnJ/gmtyQ3yO6P918qwJPyfH8rwd70M=;
        b=F+i2dkF+1kn5bby7GUdCxIVPTrtVgCM5v2nXnNU8mE7mTn8LXl+cvSms+jVyi1CHf7
         MY9cu7D9L2KPGwHubw5pDdumyVCJ1TbY7Xqioq+AsZbj81Q9PslEyPV9R7TpUXp1wxy2
         AnED8Q5yafhUjvk3IOKdTLa4fcODTp4Rt5x6ABW6YJsWJ705Kjppz0xPjdUVS+JMErPt
         rWS8v4YwQxVEURMKHax9sCDMFuklANz2GGRYbMIjet6sD/kx8kAxONjlhgC9v+2EBnNi
         dF8ZeUkf51V9X8P0twAz+6s3svKfPS8NVBFBMEvEx3IiNDtDterOuOLRlG8+KkL/YTCK
         LqWA==
X-Gm-Message-State: AOAM5307sLsYTUHzKSkIhcS55nSFWdwje0Q67q49074lMGbIJ5yZS0fq
        63jFUiGLLJ5jLsIbID7BDRRFMLxZcNc=
X-Google-Smtp-Source: ABdhPJzXJJvQ/SFpAhcFcqoFWMHQc/BhzURWdxp0WrcqJncZU2j5PG0R4a+i60Emrl6Dspd1OTfnaQ==
X-Received: by 2002:a63:1f53:: with SMTP id q19mr797115pgm.286.1605207785968;
        Thu, 12 Nov 2020 11:03:05 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id z7sm7458809pfq.214.2020.11.12.11.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:03:05 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 8/8] tcp: Defer vm zap unless actually needed for recv zerocopy.
Date:   Thu, 12 Nov 2020 11:02:05 -0800
Message-Id: <20201112190205.633640-9-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
References: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
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

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
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
index c06ba63f4caf..309fe0146bb4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1901,51 +1901,101 @@ static int tcp_zerocopy_handle_leftover_data(struct tcp_zerocopy_receive *zc,
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
 
@@ -1979,34 +2029,24 @@ static int tcp_zerocopy_receive(struct sock *sk,
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
@@ -2027,24 +2067,31 @@ static int tcp_zerocopy_receive(struct sock *sk,
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
2.29.2.222.g5d2a92d10f8-goog

