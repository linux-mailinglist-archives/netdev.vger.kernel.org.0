Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6852458C24
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 11:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbhKVKU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 05:20:26 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:45895 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbhKVKUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 05:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637576239; x=1669112239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NsXCkp4bHE/jg4oMkGMcpVU+Se7O7MjpL2tb0gvlgo4=;
  b=hpgzqX85FBbRoYXGbjHp/7kQk0/857iGSVXbtnQJ83xk05XtitNBMMWK
   Wf3kpWB/psUHLr1oi9r1cSz3NKH+u9ygeBkSXEo+UPthEZtWVgJJuoLoj
   PFlhqf0kO10bB1jwDwsDF7faULShJ3HA/T38d+H1SP6X3lYlY2+k6McSy
   c=;
X-IronPort-AV: E=Sophos;i="5.87,254,1631577600"; 
   d="scan'208";a="43282492"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 22 Nov 2021 10:17:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com (Postfix) with ESMTPS id C904BC0A00;
        Mon, 22 Nov 2021 10:17:17 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 10:17:09 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.66) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 10:17:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yafang Shao <laoar.shao@gmail.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <dccp@vger.kernel.org>
Subject: [PATCH net-next 1/2] dccp/tcp: Remove an unused argument in inet_csk_listen_start().
Date:   Mon, 22 Nov 2021 19:16:21 +0900
Message-ID: <20211122101622.50572-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122101622.50572-1-kuniyu@amazon.co.jp>
References: <20211122101622.50572-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D05UWB004.ant.amazon.com (10.43.161.208) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 1295e2cf3065 ("inet: minor optimization for backlog setting in
listen(2)") added change so that sk_max_ack_backlog is initialised earlier
in inet_dccp_listen() and inet_listen().  Since then, we no longer use
backlog in inet_csk_listen_start(), so let's remove it.

Fixes: 1295e2cf3065 ("inet: minor optimization for backlog setting in listen(2)")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/inet_connection_sock.h                          | 2 +-
 net/dccp/proto.c                                            | 6 +++---
 net/ipv4/af_inet.c                                          | 2 +-
 net/ipv4/inet_connection_sock.c                             | 2 +-
 tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index fa6a87246a7b..4ad47d9f9d27 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -304,7 +304,7 @@ static inline __poll_t inet_csk_listen_poll(const struct sock *sk)
 			(EPOLLIN | EPOLLRDNORM) : 0;
 }
 
-int inet_csk_listen_start(struct sock *sk, int backlog);
+int inet_csk_listen_start(struct sock *sk);
 void inet_csk_listen_stop(struct sock *sk);
 
 void inet_csk_addr2sockaddr(struct sock *sk, struct sockaddr *uaddr);
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index fc44dadc778b..55b8f958cdd2 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -238,7 +238,7 @@ void dccp_destroy_sock(struct sock *sk)
 
 EXPORT_SYMBOL_GPL(dccp_destroy_sock);
 
-static inline int dccp_listen_start(struct sock *sk, int backlog)
+static inline int dccp_listen_start(struct sock *sk)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
 
@@ -246,7 +246,7 @@ static inline int dccp_listen_start(struct sock *sk, int backlog)
 	/* do not start to listen if feature negotiation setup fails */
 	if (dccp_feat_finalise_settings(dp))
 		return -EPROTO;
-	return inet_csk_listen_start(sk, backlog);
+	return inet_csk_listen_start(sk);
 }
 
 static inline int dccp_need_reset(int state)
@@ -935,7 +935,7 @@ int inet_dccp_listen(struct socket *sock, int backlog)
 		 * FIXME: here it probably should be sk->sk_prot->listen_start
 		 * see tcp_listen_start
 		 */
-		err = dccp_listen_start(sk, backlog);
+		err = dccp_listen_start(sk);
 		if (err)
 			goto out;
 	}
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index c66b0563a267..aa8d15b1e2a4 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -225,7 +225,7 @@ int inet_listen(struct socket *sock, int backlog)
 			tcp_fastopen_init_key_once(sock_net(sk));
 		}
 
-		err = inet_csk_listen_start(sk, backlog);
+		err = inet_csk_listen_start(sk);
 		if (err)
 			goto out;
 		tcp_call_bpf(sk, BPF_SOCK_OPS_TCP_LISTEN_CB, 0, NULL);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f7fea3a7c5e6..23da67a3fc06 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1035,7 +1035,7 @@ void inet_csk_prepare_forced_close(struct sock *sk)
 }
 EXPORT_SYMBOL(inet_csk_prepare_forced_close);
 
-int inet_csk_listen_start(struct sock *sk, int backlog)
+int inet_csk_listen_start(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_sock *inet = inet_sk(sk);
diff --git a/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
index 8e94e5c080aa..6dc1f28fc4b6 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
@@ -68,7 +68,7 @@ static void set_task_info(struct sock *sk)
 }
 
 SEC("fentry/inet_csk_listen_start")
-int BPF_PROG(trace_inet_csk_listen_start, struct sock *sk, int backlog)
+int BPF_PROG(trace_inet_csk_listen_start, struct sock *sk)
 {
 	set_task_info(sk);
 
-- 
2.30.2

