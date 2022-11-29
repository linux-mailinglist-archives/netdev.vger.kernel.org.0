Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFA863BE29
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiK2Klq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiK2Klf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:41:35 -0500
Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id EAF9B5E9E6;
        Tue, 29 Nov 2022 02:41:32 -0800 (PST)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltAAH+Ay44YVjAYkAAA--.821S4;
        Tue, 29 Nov 2022 18:41:16 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH bpf v3 2/4] bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
Date:   Tue, 29 Nov 2022 18:40:39 +0800
Message-Id: <1669718441-2654-3-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669718441-2654-1-git-send-email-yangpc@wangsu.com>
References: <1669718441-2654-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: SyJltAAH+Ay44YVjAYkAAA--.821S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw4xGr43Wr1xWw4DWFW8tFb_yoW7Ww17pF
        s8Aa18CF4jkFW7Wr4ftFWkuF4a934rtFWjkr1UAw1ft3s7KF18JF95GF1jvF1Fgr4xCa1S
        qrs2grW5GFnrZaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When redirecting, we use sk_msg_to_ingress() to get the BPF_F_INGRESS
flag from the msg->flags. If apply_bytes is used and it is larger than
the current data being processed, sk_psock_msg_verdict() will not be
called when sendmsg() is called again. At this time, the msg->flags is 0,
and we lost the BPF_F_INGRESS flag.

So we need to save the BPF_F_INGRESS flag in sk_psock and use it when
redirection.

Fixes: 8934ce2fd081 ("bpf: sockmap redirect ingress support")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/skmsg.h |  1 +
 include/net/tcp.h     |  4 ++--
 net/core/skmsg.c      |  9 ++++++---
 net/ipv4/tcp_bpf.c    | 11 ++++++-----
 net/tls/tls_sw.c      |  6 ++++--
 5 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 48f4b64..d0cb985 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -82,6 +82,7 @@ struct sk_psock {
 	u32				apply_bytes;
 	u32				cork_bytes;
 	u32				eval;
+	bool				redir_ingress; /* undefined if sk_redir is null */
 	struct sk_msg			*cork;
 	struct sk_psock_progs		progs;
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index d10962b..ef555d2 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2281,8 +2281,8 @@ void tcp_update_ulp(struct sock *sk, struct proto *p,
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #endif /* CONFIG_BPF_SYSCALL */
 
-int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
-			  int flags);
+int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
+			  struct sk_msg *msg, u32 bytes, int flags);
 #endif /* CONFIG_NET_SOCK_MSG */
 
 #if !defined(CONFIG_BPF_SYSCALL) || !defined(CONFIG_NET_SOCK_MSG)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 188f855..679a2d2 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -885,13 +885,16 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 	ret = sk_psock_map_verd(ret, msg->sk_redir);
 	psock->apply_bytes = msg->apply_bytes;
 	if (ret == __SK_REDIRECT) {
-		if (psock->sk_redir)
+		if (psock->sk_redir) {
 			sock_put(psock->sk_redir);
-		psock->sk_redir = msg->sk_redir;
-		if (!psock->sk_redir) {
+			psock->sk_redir = NULL;
+		}
+		if (!msg->sk_redir) {
 			ret = __SK_DROP;
 			goto out;
 		}
+		psock->redir_ingress = sk_msg_to_ingress(msg);
+		psock->sk_redir = msg->sk_redir;
 		sock_hold(psock->sk_redir);
 	}
 out:
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ef5de4f..b3d9023 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -131,10 +131,9 @@ static int tcp_bpf_push_locked(struct sock *sk, struct sk_msg *msg,
 	return ret;
 }
 
-int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
-			  u32 bytes, int flags)
+int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
+			  struct sk_msg *msg, u32 bytes, int flags)
 {
-	bool ingress = sk_msg_to_ingress(msg);
 	struct sk_psock *psock = sk_psock_get(sk);
 	int ret;
 
@@ -276,7 +275,7 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 				struct sk_msg *msg, int *copied, int flags)
 {
-	bool cork = false, enospc = sk_msg_full(msg);
+	bool cork = false, enospc = sk_msg_full(msg), redir_ingress;
 	struct sock *sk_redir;
 	u32 tosend, origsize, sent, delta = 0;
 	u32 eval;
@@ -322,6 +321,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		sk_msg_apply_bytes(psock, tosend);
 		break;
 	case __SK_REDIRECT:
+		redir_ingress = psock->redir_ingress;
 		sk_redir = psock->sk_redir;
 		sk_msg_apply_bytes(psock, tosend);
 		if (!psock->apply_bytes) {
@@ -338,7 +338,8 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		release_sock(sk);
 
 		origsize = msg->sg.size;
-		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
+		ret = tcp_bpf_sendmsg_redir(sk_redir, redir_ingress,
+					    msg, tosend, flags);
 		sent = origsize - msg->sg.size;
 
 		if (eval == __SK_REDIRECT)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fe27241..0ee1df1 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -792,7 +792,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	struct sk_psock *psock;
 	struct sock *sk_redir;
 	struct tls_rec *rec;
-	bool enospc, policy;
+	bool enospc, policy, redir_ingress;
 	int err = 0, send;
 	u32 delta = 0;
 
@@ -837,6 +837,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		}
 		break;
 	case __SK_REDIRECT:
+		redir_ingress = psock->redir_ingress;
 		sk_redir = psock->sk_redir;
 		memcpy(&msg_redir, msg, sizeof(*msg));
 		if (msg->apply_bytes < send)
@@ -846,7 +847,8 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		sk_msg_return_zero(sk, msg, send);
 		msg->sg.size -= send;
 		release_sock(sk);
-		err = tcp_bpf_sendmsg_redir(sk_redir, &msg_redir, send, flags);
+		err = tcp_bpf_sendmsg_redir(sk_redir, redir_ingress,
+					    &msg_redir, send, flags);
 		lock_sock(sk);
 		if (err < 0) {
 			*copied -= sk_msg_free_nocharge(sk, &msg_redir);
-- 
1.8.3.1

