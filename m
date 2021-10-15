Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13FF42EACB
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbhJOIAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 04:00:42 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:25137 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhJOIAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 04:00:41 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HVzBD485lz1DHcx;
        Fri, 15 Oct 2021 15:56:52 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Fri, 15 Oct 2021 15:58:32 +0800
Received: from huawei.com (10.175.101.6) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Fri, 15
 Oct 2021 15:58:31 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <edumazet@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH] bpf, sockmap: Do not read sk_receive_queue in tcp_bpf_recvmsg if strparser enabled
Date:   Fri, 15 Oct 2021 16:01:42 +0800
Message-ID: <20211015080142.43424-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the strparser function of sk is turned on, all received data needs to
be processed by strparser first.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 include/linux/skmsg.h | 6 ++++++
 net/core/skmsg.c      | 5 +++++
 net/ipv4/tcp_bpf.c    | 9 ++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 94e2a1f6e58d..25e92dff04aa 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -390,6 +390,7 @@ void sk_psock_stop(struct sk_psock *psock, bool wait);
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
 void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock);
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock);
+bool sk_psock_strparser_started(struct sock *sk);
 #else
 static inline int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
 {
@@ -403,6 +404,11 @@ static inline void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
 static inline void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 {
 }
+
+static inline bool sk_psock_strparser_started(struct sock *sk)
+{
+	return false;
+}
 #endif
 
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index e85b7f8491b9..dd64ef854f3e 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1105,6 +1105,11 @@ void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
 	sk->sk_write_space = sk_psock_write_space;
 }
 
+bool sk_psock_strparser_started(struct sock *sk)
+{
+	return sk->sk_data_ready == sk_psock_strp_data_ready;
+}
+
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 {
 	if (!psock->saved_data_ready)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 9d068153c316..17129b343966 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -198,6 +198,7 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 	if (!skb_queue_empty(&sk->sk_receive_queue) &&
+	    !sk_psock_strparser_started(sk) &&
 	    sk_psock_queue_empty(psock)) {
 		sk_psock_put(sk, psock);
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
@@ -214,9 +215,11 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		if (data) {
 			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
-			release_sock(sk);
-			sk_psock_put(sk, psock);
-			return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+			if (!sk_psock_strparser_started(sk)) {
+				release_sock(sk);
+				sk_psock_put(sk, psock);
+				return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+			}
 		}
 		copied = -EAGAIN;
 	}
-- 
2.17.1

