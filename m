Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3724449B1
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhKCUtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhKCUtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:49:22 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D868C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 13:46:45 -0700 (PDT)
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 5EEFC2E0987;
        Wed,  3 Nov 2021 23:46:42 +0300 (MSK)
Received: from sas2-d40aa8807eff.qloud-c.yandex.net (sas2-d40aa8807eff.qloud-c.yandex.net [2a02:6b8:c08:b921:0:640:d40a:a880])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id SEY8qv6D5p-kfsmQsTl;
        Wed, 03 Nov 2021 23:46:42 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635972402; bh=2saM1SLMg62oQ9h0nPX6kAAcOYxB6ipoyclbZFHpUUw=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=z0BkZkM9UvnQhtvqKiZ1GYxFyORLdk9ItzMr2uCVs531JyZoxw77Bkq7EGzYpQhEu
         rrBneIuoIMixMZ9tFMRoZVb+JDy+YYegfiQDv0HugNC9ngnLDIa4C3ZvW8jKT68NlK
         qlwSUuZxXI/1hoZNNlVHFJubK/2AncfVCdobO5eE=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas2-d40aa8807eff.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id StBunK46Sv-kfxmWHEs;
        Wed, 03 Nov 2021 23:46:41 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     kafai@fb.com
Cc:     brakmo@fb.com, eric.dumazet@gmail.com, hmukos@yandex-team.ru,
        mitradir@yandex-team.ru, ncardwell@google.com,
        netdev@vger.kernel.org, ycheng@google.com, zeil@yandex-team.ru
Subject: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
Date:   Wed,  3 Nov 2021 23:46:07 +0300
Message-Id: <20211103204607.21491-1-hmukos@yandex-team.ru>
In-Reply-To: <20211025121253.8643-1-hmukos@yandex-team.ru>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
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
 include/net/request_sock.h      |  2 ++
 include/net/tcp.h               |  2 +-
 net/ipv4/inet_connection_sock.c |  4 +++-
 net/ipv4/tcp_input.c            |  8 +++++---
 net/ipv4/tcp_minisocks.c        | 12 +++++++++---
 5 files changed, 20 insertions(+), 8 deletions(-)

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
index 3166dc15d7d6..e328d6735e38 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2323,7 +2323,7 @@ static inline u32 tcp_timeout_init(struct sock *sk)
 
 	if (timeout <= 0)
 		timeout = TCP_TIMEOUT_INIT;
-	return timeout;
+	return min_t(int, timeout, TCP_RTO_MAX);
 }
 
 static inline u32 tcp_rwnd_init_bpf(struct sock *sk)
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 0d477c816309..cdf16285e193 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -870,7 +870,9 @@ static void reqsk_timer_handler(struct timer_list *t)
 
 		if (req->num_timeout++ == 0)
 			atomic_dec(&queue->young);
-		timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
+		timeo = min_t(unsigned long,
+			      (unsigned long)req->timeout << req->num_timeout,
+			      TCP_RTO_MAX);
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
index 0a4f3f16140a..9ebcd554f601 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -583,6 +583,8 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		tcp_parse_options(sock_net(sk), skb, &tmp_opt, 0, NULL);
 
 		if (tmp_opt.saw_tstamp) {
+			unsigned long timeo;
+
 			tmp_opt.ts_recent = req->ts_recent;
 			if (tmp_opt.rcv_tsecr)
 				tmp_opt.rcv_tsecr -= tcp_rsk(req)->ts_off;
@@ -590,7 +592,10 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			 * it can be estimated (approximately)
 			 * from another data.
 			 */
-			tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((TCP_TIMEOUT_INIT/HZ)<<req->num_timeout);
+			timeo = min_t(unsigned long,
+				      (unsigned long)req->timeout << req->num_timeout,
+				      TCP_RTO_MAX);
+			tmp_opt.ts_recent_stamp = ktime_get_seconds() - timeo / HZ;
 			paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
 		}
 	}
@@ -629,8 +634,9 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		    !inet_rtx_syn_ack(sk, req)) {
 			unsigned long expires = jiffies;
 
-			expires += min(TCP_TIMEOUT_INIT << req->num_timeout,
-				       TCP_RTO_MAX);
+			expires += min_t(unsigned long,
+					 (unsigned long)req->timeout << req->num_timeout,
+					 TCP_RTO_MAX);
 			if (!fastopen)
 				mod_timer_pending(&req->rsk_timer, expires);
 			else
-- 
2.17.1

