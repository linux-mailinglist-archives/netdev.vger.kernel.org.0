Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8C636AAD5
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhDZCvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZCvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:51:03 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A71FC061574;
        Sun, 25 Apr 2021 19:50:19 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id c6so40676308qtc.1;
        Sun, 25 Apr 2021 19:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bfekuNjnyKYKhGsJqGrH3eiIes2smtIR3feKc4k2GqE=;
        b=spVkHnLcD8VKS1J5NQIVnx3Sw+13u5iDEfeSCk+6yTWxSlhqUiIJtPB2T9J1xYVywY
         HCBTsBJJ6pL3i+MkIKGm9wgBiV8H27JNyauawAVI9guegQpPs2ovXfdWhaqSRbOpXqje
         evNhNVkzyvcZvlhUU/XoNSPjesvpxkeeDxYf6OoeIspUcZ6gDcoPSlVmsFFOtLdc/Wp/
         sUVLPFf/3gf0a0mh5E+ssty/B/w+1xAYdASiUKmPjF/T/3Bqdiyclg9NHmz5aSrchg4M
         TPqxfM9ZWYZKm9XNz6uC/0+EXrCrM9gLtRQf0KiY2L4uo+JgabO+fRiI3j+Ft20ITkbb
         chKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bfekuNjnyKYKhGsJqGrH3eiIes2smtIR3feKc4k2GqE=;
        b=pQ7m2KVBhDBfikfZU3/yXU3MEKP90uW6SJrVOZs7QFYYCDKCg9nsGwpDTJkHu9D6S2
         J9RlxjhjJNTISikz6IPYUhPTIrhhyss21wFbzexnM8KnqNrvt9U4vuDzrpFwQqb4vTBU
         njXKPU81i+sT1me6PK+2tq5JTYM5nrFH5vXtmr2gb6WMwQfFjcYQBSnKlogLOOAKwEPC
         ud/e0+I+ly0rb2ANUau5sl3/CgeKdhCa8tzUqVk4kV+gT58RicJCsYTQD+OZ9pYd0Vr/
         3aI+upG0NtxaAobcs1GLsDwEKP0M7q/8TyghYFxAdZh7FH0tMy+sT4+FpJTFU2lnlCzh
         fmzw==
X-Gm-Message-State: AOAM532jU/GYyNymwukEcSI8i4f5ri0zJgXcZfEMlN55swUm074OzhVG
        0+HyzpfyFC/8nPbrx1QBVOzyLRbAaR2Vyw==
X-Google-Smtp-Source: ABdhPJykK68o8hf2Yig1mFmnYf723vV6uVkUXyykZGkPuJfh2J30dGHndqhq386xeRxCtiP8fFW3cg==
X-Received: by 2002:ac8:7d4b:: with SMTP id h11mr14787976qtb.61.1619405418730;
        Sun, 25 Apr 2021 19:50:18 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:18 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 05/10] af_unix: implement unix_dgram_bpf_recvmsg()
Date:   Sun, 25 Apr 2021 19:49:56 -0700
Message-Id: <20210426025001.7899-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
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
index c4afc5fbe137..08458fa9f48b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2088,11 +2088,11 @@ static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
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
@@ -2195,6 +2195,21 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
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
 static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 			  sk_read_actor_t recv_actor)
 {
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index b1582a659427..b2c34aeb848f 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -6,6 +6,54 @@
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
@@ -14,6 +62,7 @@ static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base
 {
 	*prot        = *base;
 	prot->close  = sock_map_close;
+	prot->recvmsg = unix_dgram_bpf_recvmsg;
 }
 
 static void unix_bpf_check_needs_rebuild(struct proto *ops)
-- 
2.25.1

