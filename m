Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE413A73A0
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhFOCZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:25:23 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:36698 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhFOCZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:25:22 -0400
Received: by mail-qk1-f179.google.com with SMTP id i68so36960365qke.3;
        Mon, 14 Jun 2021 19:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=utSDi74JoxgeFkn6+VzF9KRMzUGip+skVUxRXuPWjX0=;
        b=I5MKGwIiqyzjIfqJa0sA7eJ9/pLktaqzVsh5G6k6BX/pJGIJKjyy05IFd8TpJLa5MA
         pXVcT1zjFGmXQ/m4EcTpgsuOy4uwuIX7pHde7HQEmAmTdvKogrOGmcpWh9gWK4zb7f5S
         xvAqt94OQqYWg9jdo14jKMlgcwJ8vs355aYUVHFSGqQ/FOPSdXZOc7XBT4znoCd97s93
         oRGejrt0m4i/9UedHt9CnpmZWYJhGzCSTKP80WTSDzZcdYCPKfgNsTAw8VimNyvY5pxm
         nl+vfR7rsrII0EvWhyCzwh/LMsAcYd71pzKfMUTHHOhrsRnnBcv2bWIqM7MdMDe20Lsr
         GUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=utSDi74JoxgeFkn6+VzF9KRMzUGip+skVUxRXuPWjX0=;
        b=p+sZPti+0p3OS9SiE7csyIyefutOhNmKwk1E9U4H3spJVVEqwelmwgHdvYn2m3ahVW
         xqUJyQV+kYV34iYS1VjaH+jau0Wfg7OYygoYUGwNwSiA/pFdxC0TXd5MHqtTY0VJqXKe
         1wceWw0H4fTgjIymgP2pES/CknYC/D6djdswjIL6znRQjQbd3sjhG6zHu9oBU4sFIzqT
         b75KVaq0y2szYCH0dXCF02301SFG4WIpIEAut4nj4uN8dLCPSATmOPVxaV75eHonglPW
         7daL0PjBfijARzh9xiakIgKGVgv2qe1JCeNxKbbbZF/qShyPOg2goW47MVlDO+PbKI4u
         g1Bg==
X-Gm-Message-State: AOAM531nkUFz56LuyLMDnGe0lKi+qC87vPoAwBGqLQp3k5XKlUfMwtqk
        fd0FbgLOFVTB0/bQYrRF/GjYHfEinsBOzg==
X-Google-Smtp-Source: ABdhPJxAYSngxxAksyB+vc/nTlMLwXTToT29novZ9PebuWBhrwfpN8fee14VyMKUkrqEqqDe9gAn+g==
X-Received: by 2002:a37:8345:: with SMTP id f66mr19165442qkd.396.1623723236367;
        Mon, 14 Jun 2021 19:13:56 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9a1:5f1d:df88:4f3c])
        by smtp.gmail.com with ESMTPSA id t15sm10774497qtr.35.2021.06.14.19.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:13:55 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH RESEND bpf v3 1/8] skmsg: improve udp_bpf_recvmsg() accuracy
Date:   Mon, 14 Jun 2021 19:13:35 -0700
Message-Id: <20210615021342.7416-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
References: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

I tried to reuse sk_msg_wait_data() for different protocols,
but it turns out it can not be simply reused. For example,
UDP actually uses two queues to receive skb:
udp_sk(sk)->reader_queue and sk->sk_receive_queue. So we have
to check both of them to know whether we have received any
packet.

Also, UDP does not lock the sock during BH Rx path, it makes
no sense for its ->recvmsg() to lock the sock. It is always
possible for ->recvmsg() to be called before packets actually
arrive in the receive queue, we just use best effort to make
it accurate here.

Fixes: 1f5be6b3b063 ("udp: Implement udp_bpf_recvmsg() for sockmap")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  2 --
 net/core/skmsg.c      | 23 ---------------------
 net/ipv4/tcp_bpf.c    | 24 +++++++++++++++++++++-
 net/ipv4/udp_bpf.c    | 47 ++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index aba0f0f429be..e3d080c299f6 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -126,8 +126,6 @@ int sk_msg_zerocopy_from_iter(struct sock *sk, struct iov_iter *from,
 			      struct sk_msg *msg, u32 bytes);
 int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 			     struct sk_msg *msg, u32 bytes);
-int sk_msg_wait_data(struct sock *sk, struct sk_psock *psock, int flags,
-		     long timeo, int *err);
 int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		   int len, int flags);
 
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 43ce17a6a585..f9a81b314e4c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -399,29 +399,6 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 }
 EXPORT_SYMBOL_GPL(sk_msg_memcopy_from_iter);
 
-int sk_msg_wait_data(struct sock *sk, struct sk_psock *psock, int flags,
-		     long timeo, int *err)
-{
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	int ret = 0;
-
-	if (sk->sk_shutdown & RCV_SHUTDOWN)
-		return 1;
-
-	if (!timeo)
-		return ret;
-
-	add_wait_queue(sk_sleep(sk), &wait);
-	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-	ret = sk_wait_event(sk, &timeo,
-			    !list_empty(&psock->ingress_msg) ||
-			    !skb_queue_empty(&sk->sk_receive_queue), &wait);
-	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-	remove_wait_queue(sk_sleep(sk), &wait);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(sk_msg_wait_data);
-
 /* Receive sk_msg from psock->ingress_msg to @msg. */
 int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		   int len, int flags)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ad9d17923fc5..bb49b52d7be8 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -163,6 +163,28 @@ static bool tcp_bpf_stream_read(const struct sock *sk)
 	return !empty;
 }
 
+static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock, int flags,
+			     long timeo, int *err)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	int ret = 0;
+
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		return 1;
+
+	if (!timeo)
+		return ret;
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	ret = sk_wait_event(sk, &timeo,
+			    !list_empty(&psock->ingress_msg) ||
+			    !skb_queue_empty(&sk->sk_receive_queue), &wait);
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	remove_wait_queue(sk_sleep(sk), &wait);
+	return ret;
+}
+
 static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		    int nonblock, int flags, int *addr_len)
 {
@@ -188,7 +210,7 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		long timeo;
 
 		timeo = sock_rcvtimeo(sk, nonblock);
-		data = sk_msg_wait_data(sk, psock, flags, timeo, &err);
+		data = tcp_msg_wait_data(sk, psock, flags, timeo, &err);
 		if (data) {
 			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 954c4591a6fd..565a70040c57 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -21,6 +21,45 @@ static int sk_udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	return udp_prot.recvmsg(sk, msg, len, noblock, flags, addr_len);
 }
 
+static bool udp_sk_has_data(struct sock *sk)
+{
+	return !skb_queue_empty(&udp_sk(sk)->reader_queue) ||
+	       !skb_queue_empty(&sk->sk_receive_queue);
+}
+
+static bool psock_has_data(struct sk_psock *psock)
+{
+	return !skb_queue_empty(&psock->ingress_skb) ||
+	       !sk_psock_queue_empty(psock);
+}
+
+#define udp_msg_has_data(__sk, __psock)	\
+		({ udp_sk_has_data(__sk) || psock_has_data(__psock); })
+
+static int udp_msg_wait_data(struct sock *sk, struct sk_psock *psock, int flags,
+			     long timeo, int *err)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	int ret = 0;
+
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		return 1;
+
+	if (!timeo)
+		return ret;
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	ret = udp_msg_has_data(sk, psock);
+	if (!ret) {
+		wait_woken(&wait, TASK_INTERRUPTIBLE, timeo);
+		ret = udp_msg_has_data(sk, psock);
+	}
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	remove_wait_queue(sk_sleep(sk), &wait);
+	return ret;
+}
+
 static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			   int nonblock, int flags, int *addr_len)
 {
@@ -34,8 +73,7 @@ static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(!psock))
 		return sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 
-	lock_sock(sk);
-	if (sk_psock_queue_empty(psock)) {
+	if (!psock_has_data(psock)) {
 		ret = sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 		goto out;
 	}
@@ -47,9 +85,9 @@ static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		long timeo;
 
 		timeo = sock_rcvtimeo(sk, nonblock);
-		data = sk_msg_wait_data(sk, psock, flags, timeo, &err);
+		data = udp_msg_wait_data(sk, psock, flags, timeo, &err);
 		if (data) {
-			if (!sk_psock_queue_empty(psock))
+			if (psock_has_data(psock))
 				goto msg_bytes_ready;
 			ret = sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 			goto out;
@@ -62,7 +100,6 @@ static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	}
 	ret = copied;
 out:
-	release_sock(sk);
 	sk_psock_put(sk, psock);
 	return ret;
 }
-- 
2.25.1

