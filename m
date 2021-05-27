Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B978392421
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhE0BNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbhE0BNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:13:43 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5FAC061760;
        Wed, 26 May 2021 18:12:11 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id q67so2362099pfb.4;
        Wed, 26 May 2021 18:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=utSDi74JoxgeFkn6+VzF9KRMzUGip+skVUxRXuPWjX0=;
        b=QrwWXN6leUN80am0BQp/TyvsoiCpCD1dknvxAGfy57EGG7aF9MgpmBUUm7ZtGEg04w
         7bW1jJVe8gzu7ZNeC8PulZ3e+9io57OtbHtRiEfbqYI57HTRp01Ww2hPYUL+QtROOdVO
         Wy0F+/wImGMlyn5T4I73CWPkPwFzpFmkq0LZmoUYCvki1tvWIJl0p7ysiDDT3nAZFIds
         DNlIP1ausNVtCi/vXcUy1MMp8/CdBkggC6c96+LL9UlnHjtXCGPRUgv9FLQDheBPbVst
         yHBisdm0I3hWamByb34z2zFzlv1Q5DRmIr50tuWePPqvxe2oC7D7blw7PowcrcmCUz6T
         AqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=utSDi74JoxgeFkn6+VzF9KRMzUGip+skVUxRXuPWjX0=;
        b=SiezibwN+819AalAEPjZ9k6y/xlglJRR1mhUG6JCBQPoJ8U5WAcY4SSrZ1/yz60bO2
         nybe+zvjmpTGBuB9A3+t8H6GEiydAbbS7lLVH8CJwxtGBzsKFs928jJzHqxvYnHpkJSj
         BB6l4J/bKFwY2KHLPjMdqnbxPt3o1f0qhsnStpJhhZFDZBP87YELbKppB/m1rM2JMXsq
         wfHczXXtdkWClCgAvw59jT8r8rBUzU+ZalPc0Rjx+QGMT2LXxJiG6w0g7HrjEDw9tNjR
         T2j7cIwSltGXrsT7sLi6Ho2f+3aoJ9NJbbA8GK7UFa4bFJ+Yr/PB4neotG6vrJgN37vm
         VFbg==
X-Gm-Message-State: AOAM533MZYw9BFIJGc/ml8tr6cCP1mJ8H7nM2N48M/w5uGAu1VZBHwfs
        P/xe5SMW1+L58TDIhUH6UTj3sqZQD8lozQ==
X-Google-Smtp-Source: ABdhPJzIcYbcBYOgc/+v9nf3pXY1EeZg/rwCU7LjafKkfsJWQWpRvmNSzOLEVHJrz/axPHTYQsvunQ==
X-Received: by 2002:a05:6a00:c86:b029:2e9:3041:162f with SMTP id a6-20020a056a000c86b02902e93041162fmr1220413pfv.78.1622077930251;
        Wed, 26 May 2021 18:12:10 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:991:63cd:5e03:9e3a])
        by smtp.gmail.com with ESMTPSA id n21sm360282pfu.99.2021.05.26.18.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:12:09 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 1/8] skmsg: improve udp_bpf_recvmsg() accuracy
Date:   Wed, 26 May 2021 18:11:48 -0700
Message-Id: <20210527011155.10097-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
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

