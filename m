Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37C4364955
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbhDSR5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240295AbhDSR5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:57:14 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3272C061763;
        Mon, 19 Apr 2021 10:56:42 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w8so20241027pfn.9;
        Mon, 19 Apr 2021 10:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9iR6ZItzpdN83qAvxZislpVnk6+5Sbzg48c1AiMXRc4=;
        b=eEEKzCTOjvguck7SUeqE1bZ6mjwhWhzmIfjbPJPmQd2yG73URPd/IDZbSjJ7LtYPXE
         jY2qpJwWWmJSSWsLyjNeGNEJLUbSlTiCmStqAWd3m5+ySvqJomr2eWzX87bAVLhkYrKF
         OFXlJniKMX5M1fk7aYhSfG4u5dqabflnZAOz5Xqke80dVcptfUciHM3OnTDqA5Nc8Nz5
         Ltg8NajHs+z6DpWq0rHGwC1NyAJ+tD59TKGL6Zl7QgRVvIgjV6AwgDq+EICyobrtPucr
         mg1VstUv8PLL4TcqM1Se4iO/VrYWL/dOqgjc6j7f6MLb9sQyxFMqZfHQxSJlqhlQQb3h
         R+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9iR6ZItzpdN83qAvxZislpVnk6+5Sbzg48c1AiMXRc4=;
        b=SJmjoFpHjlGl4uTnp2s5H4wCHL8/yXzhRTTJ5mGUSZnXxDv8CHSBXnSCMxP1Xm+Pye
         NxbMwdttJ6ns2jiei1aT3Bo9bk6ips8XQX0Xmf8NqLh3edwe7bfStS+WsyF9485ijN9v
         thu4LR1XR+PPBa82Lpp18F7mS5HrmBAnmtwQF5mufR+49p6QppMVotz8lZ4016lDNVSd
         L+sqXWO7GOxNedLaxkjWqlK2cd8AHkWOYdOx0SsPFlV4TvFUr1c8lgAZuL1c1QoJdugi
         TSy01W4/oKcLV8J+QUlwmIXum1BS+7tSPDQ3w+jrpL1NsnJS86k3ssfAC85ChZD5ucRX
         f4Hw==
X-Gm-Message-State: AOAM532Nd+9x1ybipd4PJNzWCmLUtCGaMNtGS/EBaBztp74N76KzyteK
        ZI0+SYGRZ9yX5aQGlvGBI07Y/qjBBnXyMg==
X-Google-Smtp-Source: ABdhPJyJLqfpfaz1dTAW2zHRGZ4w5cAmsuGsatbUeSXMwSfWWc4qPgCIsVqeeS44P+hzXHeSxYZPUA==
X-Received: by 2002:a65:48c7:: with SMTP id o7mr13316801pgs.90.1618855002469;
        Mon, 19 Apr 2021 10:56:42 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9c9:f92c:88fa:755e])
        by smtp.gmail.com with ESMTPSA id g2sm119660pju.18.2021.04.19.10.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:56:42 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 4/9] af_unix: implement unix_dgram_bpf_recvmsg()
Date:   Mon, 19 Apr 2021 10:55:58 -0700
Message-Id: <20210419175603.19378-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
References: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
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
 include/net/af_unix.h |  3 +++
 net/unix/af_unix.c    | 21 ++++++++++++++++---
 net/unix/unix_bpf.c   | 49 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index cca645846af1..e524c82794c9 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -82,6 +82,9 @@ static inline struct unix_sock *unix_sk(const struct sock *sk)
 long unix_inq_len(struct sock *sk);
 long unix_outq_len(struct sock *sk);
 
+int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			 int nonblock, int flags, int *addr_len);
+
 #ifdef CONFIG_SYSCTL
 int unix_sysctl_register(struct net *net);
 void unix_sysctl_unregister(struct net *net);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 183d132e363a..1fb118a8caa9 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2087,11 +2087,11 @@ static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
 	}
 }
 
-static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
-			      size_t size, int flags)
+int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			 int nonblock, int flags, int *addr_len)
 {
 	struct scm_cookie scm;
-	struct sock *sk = sock->sk;
+	struct socket *sock = sk->sk_socket;
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_buff *skb, *last;
 	long timeo;
@@ -2194,6 +2194,21 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
+static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
+			      int flags)
+{
+	struct sock *sk = sock->sk;
+	int addr_len = 0;
+
+#ifdef CONFIG_BPF_SYSCALL
+	if (sk->sk_prot != &unix_proto)
+		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+					    flags & ~MSG_DONTWAIT, &addr_len);
+#endif
+	return __unix_dgram_recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+				    flags, &addr_len);
+}
+
 int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 		   sk_read_actor_t recv_actor)
 {
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 8ce7651893f3..83e905e1cec9 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -5,6 +5,54 @@
 #include <net/sock.h>
 #include <net/af_unix.h>
 
+static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
+				  size_t len, int nonblock, int flags,
+				  int *addr_len)
+{
+	struct sk_psock *psock;
+	int copied, ret;
+
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock))
+		return __unix_dgram_recvmsg(sk, msg, len, nonblock, flags,
+					    addr_len);
+
+	lock_sock(sk);
+	if (!skb_queue_empty(&sk->sk_receive_queue) &&
+	    sk_psock_queue_empty(psock)) {
+		ret = __unix_dgram_recvmsg(sk, msg, len, nonblock, flags,
+					   addr_len);
+		goto out;
+	}
+
+msg_bytes_ready:
+	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	if (!copied) {
+		int data, err = 0;
+		long timeo;
+
+		timeo = sock_rcvtimeo(sk, nonblock);
+		data = sk_msg_wait_data(sk, psock, flags, timeo, &err);
+		if (data) {
+			if (!sk_psock_queue_empty(psock))
+				goto msg_bytes_ready;
+			ret = __unix_dgram_recvmsg(sk, msg, len, nonblock,
+						   flags, addr_len);
+			goto out;
+		}
+		if (err) {
+			ret = err;
+			goto out;
+		}
+		copied = -EAGAIN;
+	}
+	ret = copied;
+out:
+	release_sock(sk);
+	sk_psock_put(sk, psock);
+	return ret;
+}
+
 static struct proto *unix_prot_saved __read_mostly;
 static DEFINE_SPINLOCK(unix_prot_lock);
 static struct proto unix_bpf_prot;
@@ -13,6 +61,7 @@ static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base
 {
 	*prot        = *base;
 	prot->close  = sock_map_close;
+	prot->recvmsg = unix_dgram_bpf_recvmsg;
 }
 
 static void unix_bpf_check_needs_rebuild(struct proto *ops)
-- 
2.25.1

