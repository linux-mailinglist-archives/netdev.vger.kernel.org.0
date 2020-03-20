Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB46818C55F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCTCil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:38:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39086 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbgCTCik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 22:38:40 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 41D6693372D32ECF8ABA;
        Fri, 20 Mar 2020 10:38:37 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 10:38:29 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <lmb@cloudflare.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <john.fastabend@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrii.nakryiko@gmail.com>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH bpf-next 2/2] bpf: tcp: Make tcp_bpf_recvmsg static
Date:   Fri, 20 Mar 2020 10:34:26 +0800
Message-ID: <20200320023426.60684-3-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200320023426.60684-1-yuehaibing@huawei.com>
References: <20200319124631.58432-1-yuehaibing@huawei.com>
 <20200320023426.60684-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit f747632b608f ("bpf: sockmap: Move generic sockmap
hooks from BPF TCP"), tcp_bpf_recvmsg() is not used out of
tcp_bpf.c, so make it static and remove it from tcp.h. Also move
it to BPF_STREAM_PARSER #ifdef to fix unused function warnings.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/net/tcp.h  |   2 -
 net/ipv4/tcp_bpf.c | 124 ++++++++++++++++++++++-----------------------
 2 files changed, 62 insertions(+), 64 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 43fa07a36fa6..5fa9eacd965a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2207,8 +2207,6 @@ static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 #ifdef CONFIG_NET_SOCK_MSG
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
 			  int flags);
-int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		    int nonblock, int flags, int *addr_len);
 int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		      struct msghdr *msg, int len, int flags);
 #endif /* CONFIG_NET_SOCK_MSG */
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 37c91f25cae3..5a05327f97c1 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -10,25 +10,6 @@
 #include <net/inet_common.h>
 #include <net/tls.h>
 
-static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
-			     int flags, long timeo, int *err)
-{
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	int ret = 0;
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
-
 int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		      struct msghdr *msg, int len, int flags)
 {
@@ -102,49 +83,6 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 }
 EXPORT_SYMBOL_GPL(__tcp_bpf_recvmsg);
 
-int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		    int nonblock, int flags, int *addr_len)
-{
-	struct sk_psock *psock;
-	int copied, ret;
-
-	psock = sk_psock_get(sk);
-	if (unlikely(!psock))
-		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
-	if (unlikely(flags & MSG_ERRQUEUE))
-		return inet_recv_error(sk, msg, len, addr_len);
-	if (!skb_queue_empty(&sk->sk_receive_queue) &&
-	    sk_psock_queue_empty(psock))
-		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
-	lock_sock(sk);
-msg_bytes_ready:
-	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
-	if (!copied) {
-		int data, err = 0;
-		long timeo;
-
-		timeo = sock_rcvtimeo(sk, nonblock);
-		data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
-		if (data) {
-			if (!sk_psock_queue_empty(psock))
-				goto msg_bytes_ready;
-			release_sock(sk);
-			sk_psock_put(sk, psock);
-			return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
-		}
-		if (err) {
-			ret = err;
-			goto out;
-		}
-		copied = -EAGAIN;
-	}
-	ret = copied;
-out:
-	release_sock(sk);
-	sk_psock_put(sk, psock);
-	return ret;
-}
-
 static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 			   struct sk_msg *msg, u32 apply_bytes, int flags)
 {
@@ -299,6 +237,68 @@ static bool tcp_bpf_stream_read(const struct sock *sk)
 	return !empty;
 }
 
+static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
+			     int flags, long timeo, int *err)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	int ret = 0;
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
+static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
+		    int nonblock, int flags, int *addr_len)
+{
+	struct sk_psock *psock;
+	int copied, ret;
+
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock))
+		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+	if (!skb_queue_empty(&sk->sk_receive_queue) &&
+	    sk_psock_queue_empty(psock))
+		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+	lock_sock(sk);
+msg_bytes_ready:
+	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
+	if (!copied) {
+		int data, err = 0;
+		long timeo;
+
+		timeo = sock_rcvtimeo(sk, nonblock);
+		data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
+		if (data) {
+			if (!sk_psock_queue_empty(psock))
+				goto msg_bytes_ready;
+			release_sock(sk);
+			sk_psock_put(sk, psock);
+			return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
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
 static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 				struct sk_msg *msg, int *copied, int flags)
 {
-- 
2.17.1


