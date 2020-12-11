Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CC92D7E66
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgLKSqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388094AbgLKSpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:45:22 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED0EC0613D6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 10:44:42 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id i3so7526292pfd.6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 10:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u8gEU0haplgtfIG9/9aT+MTGKgLy3g0FEmQJ/9+pug8=;
        b=RfCpJ3tU/gxQ7cIm1JwEECALhuXqHW/fn3WGb15CwyVgqZdM2/rlTx90vNdtUnb+fG
         pIWkdMf1WtqIW9ACEvlqYUKI48QNgHHeK9Ti3/ke3Hc0e5CxoJzLokDUZEQH0FVJgYlq
         bttwgrtDsqkeO1pTpcC/h8lFwb/KiIb7gqVpXeYnJ1JU4bnTQAstb64wD+qKskK+89+o
         Knea40rClNn0Jcb4EvDDVy4VoFjteWUYuFLfGaauBbW+ZAWBOpyGOXdBYW300s5odtYp
         SxUJ3O2bAMdHsKXNTE1WhIYf+I4hzi6C9YR8r/X7TnlDkyayx5KBSL24kCQ5OOUgm5RY
         leoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u8gEU0haplgtfIG9/9aT+MTGKgLy3g0FEmQJ/9+pug8=;
        b=kDlHxeGUpHEB8oAb+cqd5DmfC8vUSR5rnOx/jtBPrdfqcMqD678/i55l98tq5N1XL8
         OFOeu18s+NwNKRHx/ZQJjVKqM4h5fXXE2Kr5UNG5M8iBwc7QZeGtVYlrE3+CuEf7oaXv
         YrSc2/Jpnhqgh6tvYZr6GQaYb1KuWdnl4YVDX8qrpjvNhOKdNDKoHzT+V/uBbUpQyyO6
         Xvj4oyRemlbUItfx4DGwRkF8ba49fRRBUjnlo0eaLYMdDfTKADLS5AQrvIyPB372C8Si
         MKRWi2EzZC+b+3TYuF7jZ8F1Hu7f9dP1r76mrP2rtp4CFWx+pchNl8LHs/tVzZkyXxtn
         O7zw==
X-Gm-Message-State: AOAM532E8lGy9Fg31qMhGiUaMS84q3RMFzGOg8h4VybemnEGqNo5VJqm
        Eb1xSasSMe2ytPHZX9Q+KEQ=
X-Google-Smtp-Source: ABdhPJwB9HM11FdsXGvxlo0GEbu9t9GY1K+mCAWmdTlq+wtaVjMbGfykJ2diGyl/aIvTKKodZn0ryQ==
X-Received: by 2002:a62:14c4:0:b029:19d:d3f5:c304 with SMTP id 187-20020a6214c40000b029019dd3f5c304mr12663430pfu.55.1607712282073;
        Fri, 11 Dec 2020 10:44:42 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id h4sm11783486pgp.8.2020.12.11.10.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 10:44:41 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 2/2] tcp: Add receive timestamp support for receive zerocopy.
Date:   Fri, 11 Dec 2020 10:44:19 -0800
Message-Id: <20201211184419.1271335-3-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
In-Reply-To: <20201211184419.1271335-1-arjunroy.kdev@gmail.com>
References: <20201211184419.1271335-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

tcp_recvmsg() uses the CMSG mechanism to receive control information
like packet receive timestamps. This patch adds CMSG fields to
struct tcp_zerocopy_receive, and provides receive timestamps
if available to the user.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 include/uapi/linux/tcp.h |   4 ++
 net/ipv4/tcp.c           | 100 ++++++++++++++++++++++++++++-----------
 2 files changed, 77 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 13ceeb395eb8..50ce6cfd1416 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -353,5 +353,9 @@ struct tcp_zerocopy_receive {
 	__u64 copybuf_address;	/* in: copybuf address (small reads) */
 	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
 	__u32 flags; /* in: flags */
+	__u64 msg_control; /* ancillary data */
+	__u64 msg_controllen;
+	__u32 msg_flags;
+	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
 };
 #endif /* _UAPI_LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d2d9f62dfc88..6e902f381e47 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1745,6 +1745,20 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(tcp_set_rcvlowat);
 
+static void tcp_update_recv_tstamps(struct sk_buff *skb,
+				    struct scm_timestamping_internal *tss)
+{
+	if (skb->tstamp)
+		tss->ts[0] = ktime_to_timespec64(skb->tstamp);
+	else
+		tss->ts[0] = (struct timespec64) {0};
+
+	if (skb_hwtstamps(skb)->hwtstamp)
+		tss->ts[2] = ktime_to_timespec64(skb_hwtstamps(skb)->hwtstamp);
+	else
+		tss->ts[2] = (struct timespec64) {0};
+}
+
 #ifdef CONFIG_MMU
 static const struct vm_operations_struct tcp_vm_ops = {
 };
@@ -1848,11 +1862,11 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 			      struct scm_timestamping_internal *tss,
 			      int *cmsg_flags);
 static int receive_fallback_to_copy(struct sock *sk,
-				    struct tcp_zerocopy_receive *zc, int inq)
+				    struct tcp_zerocopy_receive *zc, int inq,
+				    struct scm_timestamping_internal *tss)
 {
 	unsigned long copy_address = (unsigned long)zc->copybuf_address;
-	struct scm_timestamping_internal tss_unused;
-	int err, cmsg_flags_unused;
+	int err;
 	struct msghdr msg = {};
 	struct iovec iov;
 
@@ -1868,7 +1882,7 @@ static int receive_fallback_to_copy(struct sock *sk,
 		return err;
 
 	err = tcp_recvmsg_locked(sk, &msg, inq, /*nonblock=*/1, /*flags=*/0,
-				 &tss_unused, &cmsg_flags_unused);
+				 tss, &zc->msg_flags);
 	if (err < 0)
 		return err;
 
@@ -1913,17 +1927,24 @@ static int tcp_zerocopy_handle_leftover_data(struct tcp_zerocopy_receive *zc,
 					     struct sock *sk,
 					     struct sk_buff *skb,
 					     u32 *seq,
-					     s32 copybuf_len)
+					     s32 copybuf_len,
+					     struct scm_timestamping_internal
+						*tss)
 {
 	u32 offset, copylen = min_t(u32, copybuf_len, zc->recv_skip_hint);
 
 	if (!copylen)
 		return 0;
 	/* skb is null if inq < PAGE_SIZE. */
-	if (skb)
+	if (skb) {
 		offset = *seq - TCP_SKB_CB(skb)->seq;
-	else
+	} else {
 		skb = tcp_recv_skb(sk, *seq, &offset);
+		if (TCP_SKB_CB(skb)->has_rxtstamp) {
+			tcp_update_recv_tstamps(skb, tss);
+			zc->msg_flags |= TCP_CMSG_TS;
+		}
+	}
 
 	zc->copybuf_len = tcp_copy_straggler_data(zc, skb, copylen, &offset,
 						  seq);
@@ -2012,7 +2033,8 @@ static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 
 #define TCP_ZEROCOPY_PAGE_BATCH_SIZE 32
 static int tcp_zerocopy_receive(struct sock *sk,
-				struct tcp_zerocopy_receive *zc)
+				struct tcp_zerocopy_receive *zc,
+				struct scm_timestamping_internal *tss)
 {
 	u32 length = 0, offset, vma_len, avail_len, copylen = 0;
 	unsigned long address = (unsigned long)zc->address;
@@ -2029,6 +2051,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	int ret;
 
 	zc->copybuf_len = 0;
+	zc->msg_flags = 0;
 
 	if (address & (PAGE_SIZE - 1) || address != zc->address)
 		return -EINVAL;
@@ -2039,7 +2062,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	sock_rps_record_flow(sk);
 
 	if (inq && inq <= copybuf_len)
-		return receive_fallback_to_copy(sk, zc, inq);
+		return receive_fallback_to_copy(sk, zc, inq, tss);
 
 	if (inq < PAGE_SIZE) {
 		zc->length = 0;
@@ -2084,6 +2107,11 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			} else {
 				skb = tcp_recv_skb(sk, seq, &offset);
 			}
+
+			if (TCP_SKB_CB(skb)->has_rxtstamp) {
+				tcp_update_recv_tstamps(skb, tss);
+				zc->msg_flags |= TCP_CMSG_TS;
+			}
 			zc->recv_skip_hint = skb->len - offset;
 			frags = skb_advance_to_frag(skb, offset, &offset_frag);
 			if (!frags || offset_frag)
@@ -2127,7 +2155,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	/* Try to copy straggler data. */
 	if (!ret)
 		copylen = tcp_zerocopy_handle_leftover_data(zc, sk, skb, &seq,
-							    copybuf_len);
+							    copybuf_len, tss);
 
 	if (length + copylen) {
 		WRITE_ONCE(tp->copied_seq, seq);
@@ -2148,20 +2176,6 @@ static int tcp_zerocopy_receive(struct sock *sk,
 }
 #endif
 
-static void tcp_update_recv_tstamps(struct sk_buff *skb,
-				    struct scm_timestamping_internal *tss)
-{
-	if (skb->tstamp)
-		tss->ts[0] = ktime_to_timespec64(skb->tstamp);
-	else
-		tss->ts[0] = (struct timespec64) {0};
-
-	if (skb_hwtstamps(skb)->hwtstamp)
-		tss->ts[2] = ktime_to_timespec64(skb_hwtstamps(skb)->hwtstamp);
-	else
-		tss->ts[2] = (struct timespec64) {0};
-}
-
 /* Similar to __sock_recv_timestamp, but does not require an skb */
 static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
 			       struct scm_timestamping_internal *tss)
@@ -4088,6 +4102,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	}
 #ifdef CONFIG_MMU
 	case TCP_ZEROCOPY_RECEIVE: {
+		struct scm_timestamping_internal tss;
 		struct tcp_zerocopy_receive zc = {};
 		int err;
 
@@ -4103,11 +4118,18 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		if (copy_from_user(&zc, optval, len))
 			return -EFAULT;
 		lock_sock(sk);
-		err = tcp_zerocopy_receive(sk, &zc);
+		err = tcp_zerocopy_receive(sk, &zc, &tss);
 		release_sock(sk);
-		if (len >= offsetofend(struct tcp_zerocopy_receive, err))
-			goto zerocopy_rcv_sk_err;
+		if (len >= offsetofend(struct tcp_zerocopy_receive, msg_flags))
+			goto zerocopy_rcv_cmsg;
 		switch (len) {
+		case offsetofend(struct tcp_zerocopy_receive, msg_flags):
+			goto zerocopy_rcv_cmsg;
+		case offsetofend(struct tcp_zerocopy_receive, msg_controllen):
+		case offsetofend(struct tcp_zerocopy_receive, msg_control):
+		case offsetofend(struct tcp_zerocopy_receive, flags):
+		case offsetofend(struct tcp_zerocopy_receive, copybuf_len):
+		case offsetofend(struct tcp_zerocopy_receive, copybuf_address):
 		case offsetofend(struct tcp_zerocopy_receive, err):
 			goto zerocopy_rcv_sk_err;
 		case offsetofend(struct tcp_zerocopy_receive, inq):
@@ -4116,6 +4138,30 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		default:
 			goto zerocopy_rcv_out;
 		}
+zerocopy_rcv_cmsg:
+		if (zc.msg_flags & TCP_CMSG_TS) {
+			unsigned long msg_control_addr;
+			struct msghdr cmsg_dummy;
+
+			msg_control_addr = (unsigned long)zc.msg_control;
+			cmsg_dummy.msg_control = (void *)msg_control_addr;
+			cmsg_dummy.msg_controllen =
+				(__kernel_size_t)zc.msg_controllen;
+			cmsg_dummy.msg_flags = in_compat_syscall()
+				? MSG_CMSG_COMPAT : 0;
+			zc.msg_flags = 0;
+			if (zc.msg_control == msg_control_addr &&
+			    zc.msg_controllen == cmsg_dummy.msg_controllen) {
+				tcp_recv_timestamp(&cmsg_dummy, sk, &tss);
+				zc.msg_control = (__u64)
+					((uintptr_t)cmsg_dummy.msg_control);
+				zc.msg_controllen =
+					(__u64)cmsg_dummy.msg_controllen;
+				zc.msg_flags = (__u32)cmsg_dummy.msg_flags;
+			}
+		} else {
+			zc.msg_flags = 0;
+		}
 zerocopy_rcv_sk_err:
 		if (!err)
 			zc.err = sock_error(sk);
-- 
2.29.2.576.ga3fc446d84-goog

