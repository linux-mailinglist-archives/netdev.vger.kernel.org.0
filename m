Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C883BAE8C
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhGDTF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhGDTFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:49 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2227CC061574;
        Sun,  4 Jul 2021 12:03:14 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id o3-20020a4a84c30000b0290251d599f19bso1301395oog.8;
        Sun, 04 Jul 2021 12:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IFh53uZ9ltd8sE8ZSPmuIfyGaOqmUz8vlgUKHq3J9OE=;
        b=RyTmZi3H78vrReEW2/pDX9x1Fr69rL2yJohkqBtry9bjKa0ys+4ttj24ZxHIAwOXKN
         HTp4Biq8EGkS0xcsvaXYQcnFDnj5vy0OuSMat1sjA54lGfytKjnxp2iLmYH7VRpAu2CU
         hgc4Y/lJYOYn/yqch8jMqJULiX3RqzzVXrKAqPBMLeP1QfY1zo6nsnx2q5ZrEw3Mtr1N
         1NHpPLn3ZsbZ06ofgFDsCPRnJco5BmG2JVdqaJZhFMjCboT5pq4ypj4KZ9L95vBJseqj
         GRBuaFTEdraIRhAfcjfRsVMdF+jOze6nscdseLqrwiI7ShmUsOfqVTqo1ADhrTPIJaCT
         5r3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IFh53uZ9ltd8sE8ZSPmuIfyGaOqmUz8vlgUKHq3J9OE=;
        b=E2To3U2o3j2CqP4iK7VyCTF3vYC9DB3S23PLyueQuJPpzaJmbeTLiinwx8lP2YElp5
         SOkeqRBZIH75EeIYu0vFlRSo0Xlr4edRPiEIUmBP3nO1YQm4KsSrPs0ytu3iNDw3YxDE
         QpSsKUb3Hp2I1zXLgOJFyU5cPGBldGyTp47IvXsQEZVubyAVD3+vgOsAZjqXHrlo9nDx
         g59njJSh7EVjvlHTCsgp22gHRDOaoQdT/ke4MRDwlD7aOxxeffEsDrkUkZ1sLEiPNbX3
         G9y025CXFtkuCbaJs0l5eT/L2C4p+VkD5DDh1XgPSrsDIPalfcsKxErePp5nufiLBNCf
         n0hA==
X-Gm-Message-State: AOAM53310lMDb2OMCeP6qhIJL94ajPcxb/3+RB6qHrhBQIYnUu2HLsVz
        00jUhBvbAk9PLNgrnw29bglHi4RnRqc=
X-Google-Smtp-Source: ABdhPJxJXm/qz07EEwRQRVkEEA3Mrzo4wy/TXTS/uyhahEDxo2eJxZZyiQM8HxaHpUgBKItA/ERVBw==
X-Received: by 2002:a4a:d1d9:: with SMTP id a25mr7710859oos.91.1625425393381;
        Sun, 04 Jul 2021 12:03:13 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 07/11] af_unix: implement unix_dgram_bpf_recvmsg()
Date:   Sun,  4 Jul 2021 12:02:48 -0700
Message-Id: <20210704190252.11866-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We have to implement unix_dgram_bpf_recvmsg() to replace the
original ->recvmsg() to retrieve skmsg from ingress_msg.

AF_UNIX is again special here because the lack of
sk_prot->recvmsg(). I simply add a special case inside
unix_dgram_recvmsg() to call sk->sk_prot->recvmsg() directly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/af_unix.h |  2 ++
 net/unix/af_unix.c    | 19 +++++++++--
 net/unix/unix_bpf.c   | 75 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index cca645846af1..435a2c3d5a6f 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -82,6 +82,8 @@ static inline struct unix_sock *unix_sk(const struct sock *sk)
 long unix_inq_len(struct sock *sk);
 long unix_outq_len(struct sock *sk);
 
+int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			 int flags);
 #ifdef CONFIG_SYSCTL
 int unix_sysctl_register(struct net *net);
 void unix_sysctl_unregister(struct net *net);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 573253c5b5c2..89927678c0dc 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2098,11 +2098,11 @@ static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
 	}
 }
 
-static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
-			      size_t size, int flags)
+int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			 int flags)
 {
 	struct scm_cookie scm;
-	struct sock *sk = sock->sk;
+	struct socket *sock = sk->sk_socket;
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_buff *skb, *last;
 	long timeo;
@@ -2205,6 +2205,19 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
+static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
+			      int flags)
+{
+	struct sock *sk = sock->sk;
+
+#ifdef CONFIG_BPF_SYSCALL
+	if (sk->sk_prot != &unix_proto)
+		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+					    flags & ~MSG_DONTWAIT, NULL);
+#endif
+	return __unix_dgram_recvmsg(sk, msg, size, flags);
+}
+
 static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 			  sk_read_actor_t recv_actor)
 {
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index b1582a659427..db0cda29fb2f 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -6,6 +6,80 @@
 #include <net/sock.h>
 #include <net/af_unix.h>
 
+#define unix_sk_has_data(__sk, __psock)					\
+		({	!skb_queue_empty(&__sk->sk_receive_queue) ||	\
+			!skb_queue_empty(&__psock->ingress_skb) ||	\
+			!list_empty(&__psock->ingress_msg);		\
+		})
+
+static int unix_msg_wait_data(struct sock *sk, struct sk_psock *psock,
+			      long timeo)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	struct unix_sock *u = unix_sk(sk);
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
+	if (!unix_sk_has_data(sk, psock)) {
+		mutex_unlock(&u->iolock);
+		wait_woken(&wait, TASK_INTERRUPTIBLE, timeo);
+		mutex_lock(&u->iolock);
+		ret = unix_sk_has_data(sk, psock);
+	}
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	remove_wait_queue(sk_sleep(sk), &wait);
+	return ret;
+}
+
+static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
+				  size_t len, int nonblock, int flags,
+				  int *addr_len)
+{
+	struct unix_sock *u = unix_sk(sk);
+	struct sk_psock *psock;
+	int copied, ret;
+
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock))
+		return __unix_dgram_recvmsg(sk, msg, len, flags);
+
+	mutex_lock(&u->iolock);
+	if (!skb_queue_empty(&sk->sk_receive_queue) &&
+	    sk_psock_queue_empty(psock)) {
+		ret = __unix_dgram_recvmsg(sk, msg, len, flags);
+		goto out;
+	}
+
+msg_bytes_ready:
+	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	if (!copied) {
+		long timeo;
+		int data;
+
+		timeo = sock_rcvtimeo(sk, nonblock);
+		data = unix_msg_wait_data(sk, psock, timeo);
+		if (data) {
+			if (!sk_psock_queue_empty(psock))
+				goto msg_bytes_ready;
+			ret = __unix_dgram_recvmsg(sk, msg, len, flags);
+			goto out;
+		}
+		copied = -EAGAIN;
+	}
+	ret = copied;
+out:
+	mutex_unlock(&u->iolock);
+	sk_psock_put(sk, psock);
+	return ret;
+}
+
 static struct proto *unix_prot_saved __read_mostly;
 static DEFINE_SPINLOCK(unix_prot_lock);
 static struct proto unix_bpf_prot;
@@ -14,6 +88,7 @@ static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base
 {
 	*prot        = *base;
 	prot->close  = sock_map_close;
+	prot->recvmsg = unix_dgram_bpf_recvmsg;
 }
 
 static void unix_bpf_check_needs_rebuild(struct proto *ops)
-- 
2.27.0

