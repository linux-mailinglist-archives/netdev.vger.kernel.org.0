Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A65F2CCA01
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgLBWyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgLBWyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:54:35 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4B5C061A47
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:53:55 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id x24so2194575pfn.6
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sW7XgTXjijFkHwuI3jul9atpINhPCxmibaWgL857oB8=;
        b=ICuGaMdGg6dXWXsI9xWzG/dsvyHbz/s1gWYR1dmK5KasL1BNOwwz5Q1AFBvBC0G7SR
         RWDWWhLM0zbcxiJsVEDrvzrQ7la1IHeTcc6aZJp9krSl/tleXUEyvpcC6iKpPuzSHisx
         oHDsPgA4+K/eD5CMB5gsYDljaIti44hodMHmC8dsOfVWppakkhMc7KGYTMuSr3feVQNT
         jVAFWE+YzNYPoxH8rBt4rJWLo0hZHNDm6IugWdpGro0lLMYdi0kr7O04rFv34wYMK3zw
         zhKX7bjpSi7u4haTrj68jbomDGL8XPrkmTNR34Jqr1QD5NugC+h20rr50+d5KYuwa+OC
         I9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sW7XgTXjijFkHwuI3jul9atpINhPCxmibaWgL857oB8=;
        b=gXZYVOoX4gQuvBlJau1f21PWXeycwOz3K8TVTk5GGXrPdzZqamZcDAjdbzb09CnwU8
         DfY621Z3sTrDsgyXVlJFksMFAx1Z1KoLNlFM6SqSphCU+QeaZAxNbutuhVPFcGp38Rmv
         xnRj7rEskZDpzphyLoobwdr0w3Foql+RQf6QUSGXc1gKgsmAiMIP2eD7QUJGChn/RNaT
         5+b5kF8AbYKZ63GT6racKB61Or+tixbzTvjxHC5Tvx17vD4qriWH9Y57Yioi2B5dr2t8
         hUlRpIDnGgOY9/wSkirfy/Z75VVHiKwlWynJkPFwrs3wteRr6yEnVvnPIpz3ZtBZOg2g
         RRcQ==
X-Gm-Message-State: AOAM533NfNwjzSBoRhh0FM4LXgtmN5rB5W2jRyj0oFTvLMdx5ojH7gEC
        dhDWL9fQYhhui6E0sj/fAGJQhgtGNLk=
X-Google-Smtp-Source: ABdhPJyxlWGI6nqDeh0tA8q4ijgOQ9An0VmO+NRakIqXHIjaXOlLns9VXfja4YOKutLTK4ul4evWbQ==
X-Received: by 2002:a63:de4e:: with SMTP id y14mr422762pgi.411.1606949634830;
        Wed, 02 Dec 2020 14:53:54 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id i3sm39962pjs.34.2020.12.02.14.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:53:54 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v3 1/8] net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.
Date:   Wed,  2 Dec 2020 14:53:42 -0800
Message-Id: <20201202225349.935284-2-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
References: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

When TCP receive zerocopy does not successfully map the entire
requested space, it outputs a 'hint' that the caller should recvmsg().

Augment zerocopy to accept a user buffer that it tries to copy this
hint into - if it is possible to copy the entire hint, it will do so.
This elides a recvmsg() call for received traffic that isn't exactly
page-aligned in size.

This was tested with RPC-style traffic of arbitrary sizes. Normally,
each received message required at least one getsockopt() call, and one
recvmsg() call for the remaining unaligned data.

With this change, almost all of the recvmsg() calls are eliminated,
leading to a savings of about 25%-50% in number of system calls
for RPC-style workloads.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 include/uapi/linux/tcp.h |  2 +
 net/ipv4/tcp.c           | 84 ++++++++++++++++++++++++++++++++--------
 2 files changed, 70 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index cfcb10b75483..62db78b9c1a0 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -349,5 +349,7 @@ struct tcp_zerocopy_receive {
 	__u32 recv_skip_hint;	/* out: amount of bytes to skip */
 	__u32 inq; /* out: amount of bytes in read queue */
 	__s32 err; /* out: socket error */
+	__u64 copybuf_address;	/* in: copybuf address (small reads) */
+	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
 };
 #endif /* _UAPI_LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b2bc3d7fe9e8..887c6e986927 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1743,6 +1743,52 @@ int tcp_mmap(struct file *file, struct socket *sock,
 }
 EXPORT_SYMBOL(tcp_mmap);
 
+static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
+				   struct sk_buff *skb, u32 copylen,
+				   u32 *offset, u32 *seq)
+{
+	unsigned long copy_address = (unsigned long)zc->copybuf_address;
+	struct msghdr msg = {};
+	struct iovec iov;
+	int err;
+
+	if (copy_address != zc->copybuf_address)
+		return -EINVAL;
+
+	err = import_single_range(READ, (void __user *)copy_address,
+				  copylen, &iov, &msg.msg_iter);
+	if (err)
+		return err;
+	err = skb_copy_datagram_msg(skb, *offset, &msg, copylen);
+	if (err)
+		return err;
+	zc->recv_skip_hint -= copylen;
+	*offset += copylen;
+	*seq += copylen;
+	return (__s32)copylen;
+}
+
+static int tcp_zerocopy_handle_leftover_data(struct tcp_zerocopy_receive *zc,
+					     struct sock *sk,
+					     struct sk_buff *skb,
+					     u32 *seq,
+					     s32 copybuf_len)
+{
+	u32 offset, copylen = min_t(u32, copybuf_len, zc->recv_skip_hint);
+
+	if (!copylen)
+		return 0;
+	/* skb is null if inq < PAGE_SIZE. */
+	if (skb)
+		offset = *seq - TCP_SKB_CB(skb)->seq;
+	else
+		skb = tcp_recv_skb(sk, *seq, &offset);
+
+	zc->copybuf_len = tcp_copy_straggler_data(zc, skb, copylen, &offset,
+						  seq);
+	return zc->copybuf_len < 0 ? 0 : copylen;
+}
+
 static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 					struct page **pages,
 					unsigned long pages_to_map,
@@ -1776,8 +1822,10 @@ static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 static int tcp_zerocopy_receive(struct sock *sk,
 				struct tcp_zerocopy_receive *zc)
 {
+	u32 length = 0, offset, vma_len, avail_len, aligned_len, copylen = 0;
 	unsigned long address = (unsigned long)zc->address;
-	u32 length = 0, seq, offset, zap_len;
+	s32 copybuf_len = zc->copybuf_len;
+	struct tcp_sock *tp = tcp_sk(sk);
 	#define PAGE_BATCH_SIZE 8
 	struct page *pages[PAGE_BATCH_SIZE];
 	const skb_frag_t *frags = NULL;
@@ -1785,10 +1833,12 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	struct sk_buff *skb = NULL;
 	unsigned long pg_idx = 0;
 	unsigned long curr_addr;
-	struct tcp_sock *tp;
-	int inq;
+	u32 seq = tp->copied_seq;
+	int inq = tcp_inq(sk);
 	int ret;
 
+	zc->copybuf_len = 0;
+
 	if (address & (PAGE_SIZE - 1) || address != zc->address)
 		return -EINVAL;
 
@@ -1797,8 +1847,6 @@ static int tcp_zerocopy_receive(struct sock *sk,
 
 	sock_rps_record_flow(sk);
 
-	tp = tcp_sk(sk);
-
 	mmap_read_lock(current->mm);
 
 	vma = find_vma(current->mm, address);
@@ -1806,17 +1854,16 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		mmap_read_unlock(current->mm);
 		return -EINVAL;
 	}
-	zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
-
-	seq = tp->copied_seq;
-	inq = tcp_inq(sk);
-	zc->length = min_t(u32, zc->length, inq);
-	zap_len = zc->length & ~(PAGE_SIZE - 1);
-	if (zap_len) {
-		zap_page_range(vma, address, zap_len);
+	vma_len = min_t(unsigned long, zc->length, vma->vm_end - address);
+	avail_len = min_t(u32, vma_len, inq);
+	aligned_len = avail_len & ~(PAGE_SIZE - 1);
+	if (aligned_len) {
+		zap_page_range(vma, address, aligned_len);
+		zc->length = aligned_len;
 		zc->recv_skip_hint = 0;
 	} else {
-		zc->recv_skip_hint = zc->length;
+		zc->length = avail_len;
+		zc->recv_skip_hint = avail_len;
 	}
 	ret = 0;
 	curr_addr = address;
@@ -1885,13 +1932,18 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	}
 out:
 	mmap_read_unlock(current->mm);
-	if (length) {
+	/* Try to copy straggler data. */
+	if (!ret)
+		copylen = tcp_zerocopy_handle_leftover_data(zc, sk, skb, &seq,
+							    copybuf_len);
+
+	if (length + copylen) {
 		WRITE_ONCE(tp->copied_seq, seq);
 		tcp_rcv_space_adjust(sk);
 
 		/* Clean up data we have read: This will do ACK frames. */
 		tcp_recv_skb(sk, seq, &offset);
-		tcp_cleanup_rbuf(sk, length);
+		tcp_cleanup_rbuf(sk, length + copylen);
 		ret = 0;
 		if (length == zc->length)
 			zc->recv_skip_hint = 0;
-- 
2.29.2.576.ga3fc446d84-goog

