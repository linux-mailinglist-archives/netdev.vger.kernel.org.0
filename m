Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69802FDE4D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387955AbhAUA6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 19:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731379AbhAUAml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 19:42:41 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0C5C0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 16:42:00 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y205so370993pfc.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 16:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZFkWSTe9rariNYLFEKpeHv/DiMcKTWhQDCyPUSvB6I=;
        b=QyXCmSUiykaXEiKT2UcGbOuKlXwdrNHQBuci26q0yTBgl4QnuZJkfjWaJTc26uW8gK
         j74AUmsHBI7ckuE39b1oOdtMq2rYzBbBd+Ez1LgE0J6HkG9SzF3fjs1+0n97+tEsLN68
         4scCAqNoa8Vvn/IJM7lx4peUqPdDMxuP8u9bRJ/QWsLWzMGEXZTUR7Cnxiv6W1rSlgq/
         C+AIiUBfyxiXFLLzPvjpjGnPUI/Mc+YHEZt22QhCE2XNJr3uNxLKI4Ft3gezkICHTxgM
         dIdDu+9k5ewY+RrYnafLvzRmh0WNoAzhGoqMkka1PJSNgiSsn+VyW8mCc6l/JeVdOTz5
         Jb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZFkWSTe9rariNYLFEKpeHv/DiMcKTWhQDCyPUSvB6I=;
        b=TexdHocw73Yu8lVsvMrZYuqHXt3MedfIKxtr06ptyunpXMY4uvakeaVDFOrd4cLMqW
         g+KQJMox4Vgxs+zyWRW+zPYgtH5OMeSwtLPEZIaPV3GLcWx1hnBIhWHeQocgkZoOov7r
         NAKa+PTqWGDAoDNB8jK0pei6RUV5ZFbnVe4iEgm/adyUJoaV7LPoP0abhN2SmBgR+U1O
         5xgRRFbt/mvS+1740kpmne+R1P2hiBPLUMPaGWHoRCZh0uogKZxMPXzUh2u1n7+HXYVM
         qiwXyTw2fuMkDpaRH9m0VLX1YIsiL4nF9CEi/idaLSG8XWtvcLDmEabAoMGK2LKekr7w
         w/gw==
X-Gm-Message-State: AOAM533kR3CdPqUnt14TLKUh3BCTL3TPV577WfPZU1QgFSv6v9UzTcBN
        z+xTbMzqlqq0mLu1IFNYVGk=
X-Google-Smtp-Source: ABdhPJwDPSlrn7YERUo6wGQv3pMXvREq3s7iRmof07XhY/kD6VRiKPTJMxqRVmxW0XJXqVmnec2iNQ==
X-Received: by 2002:a65:494f:: with SMTP id q15mr11765930pgs.367.1611189720470;
        Wed, 20 Jan 2021 16:42:00 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id a37sm2874646pgm.79.2021.01.20.16.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 16:42:00 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        kuba@kernel.org
Subject: [net-next v2 2/2] tcp: Add receive timestamp support for receive zerocopy.
Date:   Wed, 20 Jan 2021 16:41:48 -0800
Message-Id: <20210121004148.2340206-3-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
In-Reply-To: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
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
---
 include/uapi/linux/tcp.h |   4 ++
 net/ipv4/tcp.c           | 116 ++++++++++++++++++++++++++++-----------
 2 files changed, 88 insertions(+), 32 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 768e93bd5b51..b216270105af 100644
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
index 28ca6a024f63..0e6f9b8d9f43 100644
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
@@ -1848,13 +1862,13 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
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
 	struct msghdr msg = {};
 	struct iovec iov;
+	int err;
 
 	zc->length = 0;
 	zc->recv_skip_hint = 0;
@@ -1868,7 +1882,7 @@ static int receive_fallback_to_copy(struct sock *sk,
 		return err;
 
 	err = tcp_recvmsg_locked(sk, &msg, inq, /*nonblock=*/1, /*flags=*/0,
-				 &tss_unused, &cmsg_flags_unused);
+				 tss, &zc->msg_flags);
 	if (err < 0)
 		return err;
 
@@ -1909,21 +1923,27 @@ static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
 	return (__s32)copylen;
 }
 
-static int tcp_zerocopy_handle_leftover_data(struct tcp_zerocopy_receive *zc,
-					     struct sock *sk,
-					     struct sk_buff *skb,
-					     u32 *seq,
-					     s32 copybuf_len)
+static int tcp_zc_handle_leftover(struct tcp_zerocopy_receive *zc,
+				  struct sock *sk,
+				  struct sk_buff *skb,
+				  u32 *seq,
+				  s32 copybuf_len,
+				  struct scm_timestamping_internal *tss)
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
@@ -2010,9 +2030,37 @@ static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 		err);
 }
 
+static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
+			       struct scm_timestamping_internal *tss);
+static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
+				      struct tcp_zerocopy_receive *zc,
+				      struct scm_timestamping_internal *tss)
+{
+	unsigned long msg_control_addr;
+	struct msghdr cmsg_dummy;
+
+	msg_control_addr = (unsigned long)zc->msg_control;
+	cmsg_dummy.msg_control = (void *)msg_control_addr;
+	cmsg_dummy.msg_controllen =
+		(__kernel_size_t)zc->msg_controllen;
+	cmsg_dummy.msg_flags = in_compat_syscall()
+		? MSG_CMSG_COMPAT : 0;
+	zc->msg_flags = 0;
+	if (zc->msg_control == msg_control_addr &&
+	    zc->msg_controllen == cmsg_dummy.msg_controllen) {
+		tcp_recv_timestamp(&cmsg_dummy, sk, tss);
+		zc->msg_control = (__u64)
+			((uintptr_t)cmsg_dummy.msg_control);
+		zc->msg_controllen =
+			(__u64)cmsg_dummy.msg_controllen;
+		zc->msg_flags = (__u32)cmsg_dummy.msg_flags;
+	}
+}
+
 #define TCP_ZEROCOPY_PAGE_BATCH_SIZE 32
 static int tcp_zerocopy_receive(struct sock *sk,
-				struct tcp_zerocopy_receive *zc)
+				struct tcp_zerocopy_receive *zc,
+				struct scm_timestamping_internal *tss)
 {
 	u32 length = 0, offset, vma_len, avail_len, copylen = 0;
 	unsigned long address = (unsigned long)zc->address;
@@ -2029,6 +2077,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	int ret;
 
 	zc->copybuf_len = 0;
+	zc->msg_flags = 0;
 
 	if (address & (PAGE_SIZE - 1) || address != zc->address)
 		return -EINVAL;
@@ -2039,7 +2088,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	sock_rps_record_flow(sk);
 
 	if (inq && inq <= copybuf_len)
-		return receive_fallback_to_copy(sk, zc, inq);
+		return receive_fallback_to_copy(sk, zc, inq, tss);
 
 	if (inq < PAGE_SIZE) {
 		zc->length = 0;
@@ -2084,6 +2133,11 @@ static int tcp_zerocopy_receive(struct sock *sk,
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
@@ -2126,8 +2180,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	mmap_read_unlock(current->mm);
 	/* Try to copy straggler data. */
 	if (!ret)
-		copylen = tcp_zerocopy_handle_leftover_data(zc, sk, skb, &seq,
-							    copybuf_len);
+		copylen = tcp_zc_handle_leftover(zc, sk, skb, &seq, copybuf_len, tss);
 
 	if (length + copylen) {
 		WRITE_ONCE(tp->copied_seq, seq);
@@ -2148,20 +2201,6 @@ static int tcp_zerocopy_receive(struct sock *sk,
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
@@ -4089,6 +4128,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	}
 #ifdef CONFIG_MMU
 	case TCP_ZEROCOPY_RECEIVE: {
+		struct scm_timestamping_internal tss;
 		struct tcp_zerocopy_receive zc = {};
 		int err;
 
@@ -4104,11 +4144,18 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
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
@@ -4117,6 +4164,11 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		default:
 			goto zerocopy_rcv_out;
 		}
+zerocopy_rcv_cmsg:
+		if (zc.msg_flags & TCP_CMSG_TS)
+			tcp_zc_finalize_rx_tstamp(sk, &zc, &tss);
+		else
+			zc.msg_flags = 0;
 zerocopy_rcv_sk_err:
 		if (!err)
 			zc.err = sock_error(sk);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

