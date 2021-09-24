Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1A7417D79
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344818AbhIXWHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344739AbhIXWHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:07:01 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFD4C061571;
        Fri, 24 Sep 2021 15:05:28 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id c7so29999861qka.2;
        Fri, 24 Sep 2021 15:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9AaGoiEPLlbptgntBN+mJpO46ns+attsaZXlwJ1z2hk=;
        b=SwFdHxrA1axmOZxfJkxsuFkd/PYieFc5voQ0gOYYpQ069Rgiu2q4+vwGQc/ExNKVHL
         NB4Imvcm6mSiuO5t3+NDfWvrsty73rQEGaTQZop+zPimvc8bcZ7sLybtYfDukpCYQA25
         KGV8DK4Yy2Vqg0RR5Dkd/lxQinXUZfanHBokhf5QL8lrP4+mFu1IAvzUCpot5IMprfHN
         vdpr6Isx512fGpGlrEYqJh3ZkLkaoTmupMoiDVRwkj5wjM0yI+WMhjLTdw7tS/1T25Y2
         59xGh9UwlR5/MqvDsRy4J5mDWv+1f++oNuU6Tlf4M13K+lMKXLUrYVfWFM+RvuxbUWzB
         I2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9AaGoiEPLlbptgntBN+mJpO46ns+attsaZXlwJ1z2hk=;
        b=DwM/uiBMR05ncnfPlVfN4FfYzeFYfO6OnI2OrbBaVUw2090AWToqUZ06GbWu8E6Hcp
         f1xoxL2swHU15PqshNllQHJ3zkP330XSbnfdrk/mG8yerYMXYNcAqoIktIoqZGopVoaU
         I6/vyk2phSz8gBF16E9/Uy3pyAKz2pSxh0geCjqPdXrNtp9t31E8mZhtMdG+ZcWxsh9e
         WAnK/U7ffiINFQPPxbyVNYX/m2ZdZcDqJWjQA/Dpx0jXGSFEHAwv9vPA3aiOydxzIQmK
         IWMpEZIGfV2dWNNHrrkhAxytC8kMNKvtVMP1my9YZxg5AK4osfRNThIwKGHDTD+/dpzQ
         k/rA==
X-Gm-Message-State: AOAM531ByKchsyJvO2VsuFReD8PtX9Zu7212jofPKbwFCEh9ycS2yMz6
        Msjnc+SxIChLm1BmXoFhVRcPgURly0c=
X-Google-Smtp-Source: ABdhPJwrhlm5tiahG/Rui/WhldLGX3vY7bPxj6GZQzeUfb359FqsO9hAKoDvoso6kE3KRtYnW9a/jg==
X-Received: by 2002:a37:6596:: with SMTP id z144mr13295209qkb.292.1632521127163;
        Fri, 24 Sep 2021 15:05:27 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c4dc:647c:f35b:bfc4])
        by smtp.gmail.com with ESMTPSA id h2sm7895683qkf.106.2021.09.24.15.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 15:05:26 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf 2/3] net: poll psock queues too for sockmap sockets
Date:   Fri, 24 Sep 2021 15:05:06 -0700
Message-Id: <20210924220507.24543-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924220507.24543-1-xiyou.wangcong@gmail.com>
References: <20210924220507.24543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Yucong noticed we can't poll() sockets in sockmap even
when they are the destination sockets of redirections.
This is because we never poll any psock queues in ->poll().
We can not overwrite ->poll() as it is in struct proto_ops,
not in struct proto.

So introduce sk_msg_poll() to poll psock ingress_msg queue
and let sockets which support sockmap invoke it directly.

Reported-by: Yucong Sun <sunyucong@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  6 ++++++
 net/core/skmsg.c      | 15 +++++++++++++++
 net/ipv4/tcp.c        |  2 ++
 net/ipv4/udp.c        |  2 ++
 net/unix/af_unix.c    |  5 +++++
 5 files changed, 30 insertions(+)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index d47097f2c8c0..163b0cc1703a 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -128,6 +128,7 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 			     struct sk_msg *msg, u32 bytes);
 int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		   int len, int flags);
+__poll_t sk_msg_poll(struct sock *sk);
 
 static inline void sk_msg_check_to_free(struct sk_msg *msg, u32 i, u32 bytes)
 {
@@ -562,5 +563,10 @@ static inline void skb_bpf_redirect_clear(struct sk_buff *skb)
 {
 	skb->_sk_redir = 0;
 }
+#else
+static inline __poll_t sk_msg_poll(struct sock *sk)
+{
+	return 0;
+}
 #endif /* CONFIG_NET_SOCK_MSG */
 #endif /* _LINUX_SKMSG_H */
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b28928..8e6d7ea43eca 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -474,6 +474,21 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
 
+__poll_t sk_msg_poll(struct sock *sk)
+{
+	struct sk_psock *psock;
+	__poll_t mask = 0;
+
+	psock = sk_psock_get_checked(sk);
+	if (IS_ERR_OR_NULL(psock))
+		return 0;
+	if (!sk_psock_queue_empty(psock))
+		mask |= EPOLLIN | EPOLLRDNORM;
+	sk_psock_put(sk, psock);
+	return mask;
+}
+EXPORT_SYMBOL_GPL(sk_msg_poll);
+
 static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 						  struct sk_buff *skb)
 {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8b48df73c85..2eb1a87ba056 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -280,6 +280,7 @@
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
 #include <net/busy_poll.h>
+#include <linux/skmsg.h>
 
 /* Track pending CMSGs. */
 enum {
@@ -563,6 +564,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 
 		if (tcp_stream_is_readable(sk, target))
 			mask |= EPOLLIN | EPOLLRDNORM;
+		mask |= sk_msg_poll(sk);
 
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
 			if (__sk_stream_is_writeable(sk, 1)) {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8851c9463b4b..fbc989d27388 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -97,6 +97,7 @@
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/skmsg.h>
 #include <net/net_namespace.h>
 #include <net/icmp.h>
 #include <net/inet_hashtables.h>
@@ -2866,6 +2867,7 @@ __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	    !(sk->sk_shutdown & RCV_SHUTDOWN) && first_packet_length(sk) == -1)
 		mask &= ~(EPOLLIN | EPOLLRDNORM);
 
+	mask |= sk_msg_poll(sk);
 	return mask;
 
 }
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 92345c9bb60c..5d705541d082 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -114,6 +114,7 @@
 #include <linux/freezer.h>
 #include <linux/file.h>
 #include <linux/btf_ids.h>
+#include <linux/skmsg.h>
 
 #include "scm.h"
 
@@ -3015,6 +3016,8 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
+	mask |= sk_msg_poll(sk);
+
 	/* Connection-based need to check for termination and startup */
 	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
 	    sk->sk_state == TCP_CLOSE)
@@ -3054,6 +3057,8 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
+	mask |= sk_msg_poll(sk);
+
 	/* Connection-based need to check for termination and startup */
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		if (sk->sk_state == TCP_CLOSE)
-- 
2.30.2

