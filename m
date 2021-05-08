Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B22377448
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhEHWKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhEHWKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:19 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EECC061763;
        Sat,  8 May 2021 15:09:17 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id a18so9296700qtj.10;
        Sat, 08 May 2021 15:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E+M2e+5FqfWuaO4MmVZgDT1VoAboQ/2kqTqv/TNQTvA=;
        b=T1+NQyZnJAwRjz/vV932Oo4s/cC9eaYa0XUpHqetcT+5v7H3hcptpOQNQmAqZTZ9k+
         o1QIyRV/zU2xByZkWkq8gkz0CUNXm3SP9fIK2Ua7Q+nUs5U4ZAB8KQSV/ZSNnFgn+ZHT
         3ZXwSQKTatrCRn2TcpuV+tb2dMwBypnjPZcMCFUc50fkI+BKg6M0cIHm0CtxgBluW6w6
         rrppLyKEj2fWS8ji7q0pzdJx1YxDxD9cmJnrnujqV6AWlomJRzbKm5VewCzghLsxVYqF
         MgcJ4lw+768Qc3VGv28nFlAX79VjOSqZDwppY3yn7ED0BQGNlmYNRdZzugNo1GBgSBYt
         BGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E+M2e+5FqfWuaO4MmVZgDT1VoAboQ/2kqTqv/TNQTvA=;
        b=N0Z8CviaG5kXWfL7NK1TMAsAdp/WS7HCXxYHAUAFKuKa5W6yjTjY7deQmalyUK4CHz
         +B5yylft5IieSACqMomI1wgU3jbd2/4jmImbtBewAVSeE1HDz4pymLaiVz0UNzxRb+xL
         Kwmk0eZhP6PRokR+gSrhR8BJ9Ag9OkSuJIVlyzQqwfnZPoePPO1I5cprNSTRxCyi7FOB
         rLDB1RDAQxj0U1HWJYIcRWOVbtOAj6tDyxEhqllPUOCiSrzqUE6RrAbhe8z0n1v7ebmM
         m4tfBDp2ahDDboeZE2kSo3GBjEW5SuaJhbh4PmnFm3wFpcuVHI8+ZLpbuxnfGWEEZmSH
         aeoQ==
X-Gm-Message-State: AOAM5333Q3Slfr7kBQ5NdWvibTIGMXXcp6smlJfrJKtmHJSJQacpLSOC
        eCleMEksKjS87erFxPrudNcNuuPP8WopnQ==
X-Google-Smtp-Source: ABdhPJyVoa2AvzGRkQCi0mnhs1h/ry9GyuuZIR0f5VgEvJvqDLNYMC70F1ZUPhxa/YFKZGpjAEufeg==
X-Received: by 2002:ac8:6f37:: with SMTP id i23mr80916qtv.221.1620511756371;
        Sat, 08 May 2021 15:09:16 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:16 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 07/12] af_unix: implement unix_dgram_bpf_recvmsg()
Date:   Sat,  8 May 2021 15:08:30 -0700
Message-Id: <20210508220835.53801-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
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
 net/unix/af_unix.c    | 19 ++++++++++++++---
 net/unix/unix_bpf.c   | 47 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index cca645846af1..49b13e9bffd0 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -82,6 +82,9 @@ static inline struct unix_sock *unix_sk(const struct sock *sk)
 long unix_inq_len(struct sock *sk);
 long unix_outq_len(struct sock *sk);
 
+int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			 int nonblock, int flags);
+
 #ifdef CONFIG_SYSCTL
 int unix_sysctl_register(struct net *net);
 void unix_sysctl_unregister(struct net *net);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5424e8007858..e718ca6237a7 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2100,11 +2100,11 @@ static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
 	}
 }
 
-static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
-			      size_t size, int flags)
+int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			 int nonblock, int flags)
 {
 	struct scm_cookie scm;
-	struct sock *sk = sock->sk;
+	struct socket *sock = sk->sk_socket;
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_buff *skb, *last;
 	long timeo;
@@ -2207,6 +2207,19 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
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
+	return __unix_dgram_recvmsg(sk, msg, size, flags & MSG_DONTWAIT, flags);
+}
+
 static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 			  sk_read_actor_t recv_actor)
 {
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 3ff71fb9aac8..debe82e1035d 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -6,6 +6,52 @@
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
+		return __unix_dgram_recvmsg(sk, msg, len, nonblock, flags);
+
+	lock_sock(sk);
+	if (!skb_queue_empty(&sk->sk_receive_queue) &&
+	    sk_psock_queue_empty(psock)) {
+		ret = __unix_dgram_recvmsg(sk, msg, len, nonblock, flags);
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
+						   flags);
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
@@ -15,6 +61,7 @@ static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base
 	*prot        = *base;
 	prot->unhash = sock_map_unhash;
 	prot->close  = sock_map_close;
+	prot->recvmsg = unix_dgram_bpf_recvmsg;
 }
 
 static void unix_bpf_check_needs_rebuild(struct proto *ops)
-- 
2.25.1

