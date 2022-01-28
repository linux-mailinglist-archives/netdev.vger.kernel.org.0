Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0424A00D2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 20:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350917AbiA1T0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 14:26:48 -0500
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:34564 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229968AbiA1T0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 14:26:47 -0500
X-Greylist: delayed 14985 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2022 14:26:47 EST
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 871402E1A69;
        Fri, 28 Jan 2022 22:26:45 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id xw08lESJKd-QhHqL2sR;
        Fri, 28 Jan 2022 22:26:45 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643398005; bh=zeM4VT7DV7f9sUY5z9F/v8LoRXDZgO5Qn3SOuNsrgp8=;
        h=Date:Subject:To:From:Message-Id:Cc;
        b=wB9pHj8GYuLYTsT/l/McYf17CTCgiw3SCkhWa7EznlXLXZLmGW3MkUKEndWngkFvb
         DlEDLF34A539xRHz3mrOAmJy48DoVTWZuQ/C/wYiyKaDLXFrxj/DureTwjEBHKN7m5
         gCmmXLC5PLNtG4+zL4uGI7B094E0a6rArli127ww=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 6iZmY7zNav-QhICoCRs;
        Fri, 28 Jan 2022 22:26:43 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, kafai@fb.com, ncardwell@google.com,
        ycheng@google.com, brakmo@fb.com, hmukos@yandex-team.ru,
        zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v4] tcp: Use BPF timeout setting for SYN ACK RTO
Date:   Fri, 28 Jan 2022 22:26:21 +0300
Message-Id: <20220128192621.29642-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting RTO through BPF program, some SYN ACK packets were unaffected
and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
and is reassigned through BPF using tcp_timeout_init call. SYN ACK
retransmits now use newly added timeout option.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
Acked-by: Martin KaFai Lau <kafai@fb.com>

v2:
	- Add timeout option to struct request_sock. Do not call
	  tcp_timeout_init on every syn ack retransmit.

v3:
	- Use unsigned long for min. Bound tcp_timeout_init to TCP_RTO_MAX.

v4:
	- Refactor duplicate code by adding reqsk_timeout function.
---
 include/net/inet_connection_sock.h | 8 ++++++++
 include/net/request_sock.h         | 2 ++
 include/net/tcp.h                  | 2 +-
 net/ipv4/inet_connection_sock.c    | 5 +----
 net/ipv4/tcp_input.c               | 8 +++++---
 net/ipv4/tcp_minisocks.c           | 5 ++---
 6 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 4ad47d9f9d27..3908296d103f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -285,6 +285,14 @@ static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
 void inet_csk_reqsk_queue_drop_and_put(struct sock *sk, struct request_sock *req);
 
+static inline unsigned long
+reqsk_timeout(struct request_sock *req, unsigned long max_timeout)
+{
+	u64 timeout = (u64)req->timeout << req->num_timeout;
+
+	return (unsigned long)min_t(u64, timeout, max_timeout);
+}
+
 static inline void inet_csk_prepare_for_destroy_sock(struct sock *sk)
 {
 	/* The below has to be done to allow calling inet_csk_destroy_sock */
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 29e41ff3ec93..144c39db9898 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -70,6 +70,7 @@ struct request_sock {
 	struct saved_syn		*saved_syn;
 	u32				secid;
 	u32				peer_secid;
+	u32				timeout;
 };
 
 static inline struct request_sock *inet_reqsk(const struct sock *sk)
@@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
 	sk_node_init(&req_to_sk(req)->sk_node);
 	sk_tx_queue_clear(req_to_sk(req));
 	req->saved_syn = NULL;
+	req->timeout = 0;
 	req->num_timeout = 0;
 	req->num_retrans = 0;
 	req->sk = NULL;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index b9fc978fb2ca..eff2487d972d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2358,7 +2358,7 @@ static inline u32 tcp_timeout_init(struct sock *sk)
 
 	if (timeout <= 0)
 		timeout = TCP_TIMEOUT_INIT;
-	return timeout;
+	return min_t(int, timeout, TCP_RTO_MAX);
 }
 
 static inline u32 tcp_rwnd_init_bpf(struct sock *sk)
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fc2a985f6064..1b92662664c6 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -866,12 +866,9 @@ static void reqsk_timer_handler(struct timer_list *t)
 	    (!resend ||
 	     !inet_rtx_syn_ack(sk_listener, req) ||
 	     inet_rsk(req)->acked)) {
-		unsigned long timeo;
-
 		if (req->num_timeout++ == 0)
 			atomic_dec(&queue->young);
-		timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
-		mod_timer(&req->rsk_timer, jiffies + timeo);
+		mod_timer(&req->rsk_timer, jiffies + reqsk_timeout(req, TCP_RTO_MAX));
 
 		if (!nreq)
 			return;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index dc49a3d551eb..302744bec59e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6723,6 +6723,7 @@ struct request_sock *inet_reqsk_alloc(const struct request_sock_ops *ops,
 		ireq->ireq_state = TCP_NEW_SYN_RECV;
 		write_pnet(&ireq->ireq_net, sock_net(sk_listener));
 		ireq->ireq_family = sk_listener->sk_family;
+		req->timeout = TCP_TIMEOUT_INIT;
 	}
 
 	return req;
@@ -6939,9 +6940,10 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		sock_put(fastopen_sk);
 	} else {
 		tcp_rsk(req)->tfo_listener = false;
-		if (!want_cookie)
-			inet_csk_reqsk_queue_hash_add(sk, req,
-				tcp_timeout_init((struct sock *)req));
+		if (!want_cookie) {
+			req->timeout = tcp_timeout_init((struct sock *)req);
+			inet_csk_reqsk_queue_hash_add(sk, req, req->timeout);
+		}
 		af_ops->send_synack(sk, dst, &fl, req, &foc,
 				    !want_cookie ? TCP_SYNACK_NORMAL :
 						   TCP_SYNACK_COOKIE,
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 3977257f80d9..6366df7aaf2a 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -583,7 +583,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			 * it can be estimated (approximately)
 			 * from another data.
 			 */
-			tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((TCP_TIMEOUT_INIT/HZ)<<req->num_timeout);
+			tmp_opt.ts_recent_stamp = ktime_get_seconds() - reqsk_timeout(req, TCP_RTO_MAX) / HZ;
 			paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
 		}
 	}
@@ -622,8 +622,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		    !inet_rtx_syn_ack(sk, req)) {
 			unsigned long expires = jiffies;
 
-			expires += min(TCP_TIMEOUT_INIT << req->num_timeout,
-				       TCP_RTO_MAX);
+			expires += reqsk_timeout(req, TCP_RTO_MAX);
 			if (!fastopen)
 				mod_timer_pending(&req->rsk_timer, expires);
 			else
-- 
2.17.1

