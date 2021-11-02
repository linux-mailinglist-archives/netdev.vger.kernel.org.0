Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2A94435A6
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhKBSgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:36:23 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:51550 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230230AbhKBSgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 14:36:23 -0400
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 90DCE2E12A2;
        Tue,  2 Nov 2021 21:33:46 +0300 (MSK)
Received: from sas2-d40aa8807eff.qloud-c.yandex.net (sas2-d40aa8807eff.qloud-c.yandex.net [2a02:6b8:c08:b921:0:640:d40a:a880])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id GQhn1CG6A2-XjsWCQKK;
        Tue, 02 Nov 2021 21:33:46 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635878026; bh=tZzv2C9pi1DhD5rQ50a4ZFcOsy0RmyAJEQ29kJNISjY=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=TE093K5+w15DvQAWZKFEyr8fk3X8moHenRwkaDET6aOZNsF4TpKVu2yFj7C00xWr4
         oh3rJ5SJeYT86T/kfa1fWM4AsVvr2Jdkmb9SR3VizDyvaL8+Q2u1lH/Jlf7hhZHjHm
         ZpbcHeDaks0ZyPp57we9NR7RCJAIzbRMrsgrRW9I=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas2-d40aa8807eff.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id R2hdiKfkio-XjxOlgMu;
        Tue, 02 Nov 2021 21:33:45 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     eric.dumazet@gmail.com
Cc:     brakmo@fb.com, hmukos@yandex-team.ru, mitradir@yandex-team.ru,
        ncardwell@google.com, netdev@vger.kernel.org, ycheng@google.com,
        zeil@yandex-team.ru
Subject: [PATCH v2] tcp: Use BPF timeout setting for SYN ACK RTO
Date:   Tue,  2 Nov 2021 21:32:35 +0300
Message-Id: <20211102183235.14679-1-hmukos@yandex-team.ru>
In-Reply-To: <863fdf13-b1f4-f429-d8ac-269f9ceaa747@gmail.com>
References: <863fdf13-b1f4-f429-d8ac-269f9ceaa747@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting RTO through BPF program, some SYN ACK packets were unaffected
and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
and is reassigned through BPF using tcp_timeout_init call. SYN ACK
retransmits now use newly added timeout option.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
---
 include/net/request_sock.h      | 2 ++
 net/ipv4/inet_connection_sock.c | 2 +-
 net/ipv4/tcp_input.c            | 8 +++++---
 net/ipv4/tcp_minisocks.c        | 4 ++--
 4 files changed, 10 insertions(+), 6 deletions(-)

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
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 0d477c816309..c43cc1f22092 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -870,7 +870,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 
 		if (req->num_timeout++ == 0)
 			atomic_dec(&queue->young);
-		timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
+		timeo = min(req->timeout << req->num_timeout, TCP_RTO_MAX);
 		mod_timer(&req->rsk_timer, jiffies + timeo);
 
 		if (!nreq)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3f7bd7ae7d7a..5c181dc4e96f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6706,6 +6706,7 @@ struct request_sock *inet_reqsk_alloc(const struct request_sock_ops *ops,
 		ireq->ireq_state = TCP_NEW_SYN_RECV;
 		write_pnet(&ireq->ireq_net, sock_net(sk_listener));
 		ireq->ireq_family = sk_listener->sk_family;
+		req->timeout = TCP_TIMEOUT_INIT;
 	}
 
 	return req;
@@ -6922,9 +6923,10 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
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
index 0a4f3f16140a..9724c9c6d331 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -590,7 +590,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			 * it can be estimated (approximately)
 			 * from another data.
 			 */
-			tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((TCP_TIMEOUT_INIT/HZ)<<req->num_timeout);
+			tmp_opt.ts_recent_stamp = ktime_get_seconds() - (req->timeout << req->num_timeout) / HZ;
 			paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
 		}
 	}
@@ -629,7 +629,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		    !inet_rtx_syn_ack(sk, req)) {
 			unsigned long expires = jiffies;
 
-			expires += min(TCP_TIMEOUT_INIT << req->num_timeout,
+			expires += min(req->timeout << req->num_timeout,
 				       TCP_RTO_MAX);
 			if (!fastopen)
 				mod_timer_pending(&req->rsk_timer, expires);
-- 
2.17.1

