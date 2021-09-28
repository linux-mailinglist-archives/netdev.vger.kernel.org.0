Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DAB41A42A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbhI1AYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbhI1AYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 20:24:11 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B216BC061575;
        Mon, 27 Sep 2021 17:22:32 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id m7so22070009qke.8;
        Mon, 27 Sep 2021 17:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0dOOqTPqD213PUS/mgbjl/GrYaIJKVoRPsmSTRpXF8c=;
        b=BF3wHI+rf7dpq6rs5/uhCevN3xwV+P7a1pa0uQ2yCQ69LPFOWT08OaM3YxhVe6oJvM
         ZrZkQfEuL8b2I2XZCFka+iBnSsKB8p6qsUT4D2B5gnlOq8ZI4Lf2N0lWxZNbwQ9iv655
         PP2rN9bPGgc5pqg28ixH/E13oXlJZ1TEuHOgQaZP7VRovYaxaBF2gmpw55HZQP8LXcuq
         ULlvdpjR/HGVBV3su7i8Z3aTjtHC36R44Ubq5T29CdYuvxauI4rab2ymqOyXpIsi4n0I
         RHuICuhpuxvWXnKSgopbZIV0jrOhx9vtvpnikySsdD99bnf4zZ482g7f3A9PfNjZhCPx
         6bPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0dOOqTPqD213PUS/mgbjl/GrYaIJKVoRPsmSTRpXF8c=;
        b=CCIgkFLBbBvKcmysBM7ncaksHzgYaty8wrpd9wcKsxmPXTV39mlcqTp6okzmz1VwbA
         jmDRBavilPpUlhGyU0astSo0cDPSJB0oTudgterCCj4HL0RE7zRcCybhav2X41fD7bm2
         cIYJUkZvyBT25q4rwYeOBBydjNK29WUt55l0WA2q3Fh2Afdk+mYq7x1nBOCPqyQUHxsk
         41R7vZx0EGUka9/+3dkhNDDsKitP5wPtntuRpqz4lpz5R5+0QwRN8E9ijhMvatzsQQiu
         dStQK4v5niHsuSrhxX3CoyMFzrQ8cNYCId2JqTEueAP0Tna1qrnd9xJTDC+mS7a/WEJR
         Z7WQ==
X-Gm-Message-State: AOAM533iKxS0vYbbhtiPiEkV3UCpVGjgacHZb5A4sIIfYbkjXYfXynjc
        wV2rX6PaeSlr1fklZMPs0Dw18x4VZz0=
X-Google-Smtp-Source: ABdhPJzUT7xTm+i6YO7aJMcd1vmuSjW1QrLgoyHKQRXPavZngXvlNmOuJUiG8V/w3GsBpyi/6afUng==
X-Received: by 2002:a37:a953:: with SMTP id s80mr2841088qke.211.1632788551775;
        Mon, 27 Sep 2021 17:22:31 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1ce2:35c5:917e:20d7])
        by smtp.gmail.com with ESMTPSA id 31sm5672308qtb.85.2021.09.27.17.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:22:31 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v2 3/4] net: implement ->sock_is_readable for UDP and AF_UNIX
Date:   Mon, 27 Sep 2021 17:22:11 -0700
Message-Id: <20210928002212.14498-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
References: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Yucong noticed we can't poll() sockets in sockmap even when
they are the destination sockets of redirections. This is
because we never poll any psock queues in ->poll(), except
for TCP. Now we can overwrite >sock_is_readable() and
implement and invoke it for UDP and AF_UNIX sockets.

Reported-by: Yucong Sun <sunyucong@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  1 +
 net/core/skmsg.c      | 14 ++++++++++++++
 net/ipv4/udp.c        |  2 ++
 net/ipv4/udp_bpf.c    |  1 +
 net/unix/af_unix.c    |  4 ++++
 net/unix/unix_bpf.c   |  2 ++
 6 files changed, 24 insertions(+)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 8f577739fc36..a25434207dca 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -128,6 +128,7 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 			     struct sk_msg *msg, u32 bytes);
 int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		   int len, int flags);
+bool sk_msg_is_readable(struct sock *sk);
 
 static inline void sk_msg_check_to_free(struct sk_msg *msg, u32 i, u32 bytes)
 {
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b28928..93ae48581ad2 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -474,6 +474,20 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
 
+bool sk_msg_is_readable(struct sock *sk)
+{
+	struct sk_psock *psock;
+	bool empty = true;
+
+	psock = sk_psock_get_checked(sk);
+	if (IS_ERR_OR_NULL(psock))
+		return false;
+	empty = sk_psock_queue_empty(psock);
+	sk_psock_put(sk, psock);
+	return !empty;
+}
+EXPORT_SYMBOL_GPL(sk_msg_is_readable);
+
 static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 						  struct sk_buff *skb)
 {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8851c9463b4b..9f49c0967504 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2866,6 +2866,8 @@ __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	    !(sk->sk_shutdown & RCV_SHUTDOWN) && first_packet_length(sk) == -1)
 		mask &= ~(EPOLLIN | EPOLLRDNORM);
 
+	if (sk_is_readable(sk))
+		mask |= EPOLLIN | EPOLLRDNORM;
 	return mask;
 
 }
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 7a1d5f473878..bbe6569c9ad3 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -114,6 +114,7 @@ static void udp_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 	*prot        = *base;
 	prot->close  = sock_map_close;
 	prot->recvmsg = udp_bpf_recvmsg;
+	prot->sock_is_readable = sk_msg_is_readable;
 }
 
 static void udp_bpf_check_v6_needs_rebuild(struct proto *ops)
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 92345c9bb60c..f1cbaa0ccf6b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3014,6 +3014,8 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 	/* readable? */
 	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	if (sk_is_readable(sk))
+		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
 	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
@@ -3053,6 +3055,8 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 	/* readable? */
 	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	if (sk_is_readable(sk))
+		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
 	if (sk->sk_type == SOCK_SEQPACKET) {
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index b927e2baae50..452376c6f419 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -102,6 +102,7 @@ static void unix_dgram_bpf_rebuild_protos(struct proto *prot, const struct proto
 	*prot        = *base;
 	prot->close  = sock_map_close;
 	prot->recvmsg = unix_bpf_recvmsg;
+	prot->sock_is_readable = sk_msg_is_readable;
 }
 
 static void unix_stream_bpf_rebuild_protos(struct proto *prot,
@@ -110,6 +111,7 @@ static void unix_stream_bpf_rebuild_protos(struct proto *prot,
 	*prot        = *base;
 	prot->close  = sock_map_close;
 	prot->recvmsg = unix_bpf_recvmsg;
+	prot->sock_is_readable = sk_msg_is_readable;
 	prot->unhash  = sock_map_unhash;
 }
 
-- 
2.30.2

