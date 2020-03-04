Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23898178E3C
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387787AbgCDKNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:13:44 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38674 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387730AbgCDKNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:13:43 -0500
Received: by mail-lf1-f68.google.com with SMTP id x22so1019391lff.5
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EQzxMqnkSVUd1PGurjRWf9he+aR/h2xv8xkMvWw9R2w=;
        b=DG1uYPSe689KGlwB5IYDAXUBHjcn4mGrpArmItsmqYg2rzEoIzw3wiRa2odDOOKmBC
         fVD51JPyx+bJcpzEhIJtXDKw/j14WCQqmVyNEPEfbvLUyG1WQF6oYEO2Q3TrqMuSfID1
         LMmyObbGrov4h/SLLB4OFVvJAHFFFRwI/VTgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EQzxMqnkSVUd1PGurjRWf9he+aR/h2xv8xkMvWw9R2w=;
        b=FUUkrrseoGKUp00htvM2yaCz5P3l1v5EZm7m1TsrLizWMTbZnzW2Qa0QkQNIcenG4k
         2KGW71gDTkWWF9NHG7D/2ftYnT0gGP5HrXSKpwSnJfBUG9s4/wmQF/SoBK2/dMP6EpiX
         KczKnM/8qTcjNEp5LmwzGG90KOl5R6DFLUxLckm+zgIV9JL2MvXE538IcRjKMu8alLqq
         9098SQjonCf70NfyoETKVyOz21UQ0P/UlMkK3noj5gQvtDp07vYk/eWfHoNSXQH00ZP3
         0/dyhjATagT8o2KclUliE3BB/QF3Sdxbfg00zDw1e3gwFREpE2P2xUxWqZcYrKQ0cSXj
         ivsA==
X-Gm-Message-State: ANhLgQ11PlT+AbHKoxrtrLHHcJ1vONMfnyNdeoTCRttfu+0yzYmHvC9Q
        wLalqMQCS+ahpi3nc/g2xMZmIw==
X-Google-Smtp-Source: ADFU+vtP0Wg67pFU1/jCRJqBdcLWQvzQyRrkm7e/FzcdEHLzf1Y98rCcWZjt6+vePUHOMtkkxR5NMQ==
X-Received: by 2002:ac2:54a3:: with SMTP id w3mr1562653lfk.61.1583316821236;
        Wed, 04 Mar 2020 02:13:41 -0800 (PST)
Received: from localhost.localdomain ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id l7sm341777lfk.65.2020.03.04.02.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 02:13:40 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 03/12] bpf: tcp: move assertions into tcp_bpf_get_proto
Date:   Wed,  4 Mar 2020 11:13:08 +0100
Message-Id: <20200304101318.5225-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304101318.5225-1-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to ensure that sk->sk_prot uses certain callbacks, so that
code that directly calls e.g. tcp_sendmsg in certain corner cases
works. To avoid spurious asserts, we must to do this only if
sk_psock_update_proto has not yet been called. The same invariants
apply for tcp_bpf_check_v6_needs_rebuild, so move the call as well.

Doing so allows us to merge tcp_bpf_init and tcp_bpf_reinit.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/net/tcp.h   |  1 -
 net/core/sock_map.c | 21 +++++++--------------
 net/ipv4/tcp_bpf.c  | 42 ++++++++++++++++++++++--------------------
 3 files changed, 29 insertions(+), 35 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 07f947cc80e6..ccf39d80b695 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2196,7 +2196,6 @@ struct sk_msg;
 struct sk_psock;
 
 int tcp_bpf_init(struct sock *sk);
-void tcp_bpf_reinit(struct sock *sk);
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
 			  int flags);
 int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index cb8f740f7949..bca560a79b5b 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -145,8 +145,8 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 			 struct sock *sk)
 {
 	struct bpf_prog *msg_parser, *skb_parser, *skb_verdict;
-	bool skb_progs, sk_psock_is_new = false;
 	struct sk_psock *psock;
+	bool skb_progs;
 	int ret;
 
 	skb_verdict = READ_ONCE(progs->skb_verdict);
@@ -191,18 +191,14 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 			ret = -ENOMEM;
 			goto out_progs;
 		}
-		sk_psock_is_new = true;
 	}
 
 	if (msg_parser)
 		psock_set_prog(&psock->progs.msg_parser, msg_parser);
-	if (sk_psock_is_new) {
-		ret = tcp_bpf_init(sk);
-		if (ret < 0)
-			goto out_drop;
-	} else {
-		tcp_bpf_reinit(sk);
-	}
+
+	ret = tcp_bpf_init(sk);
+	if (ret < 0)
+		goto out_drop;
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (skb_progs && !psock->parser.enabled) {
@@ -239,12 +235,9 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
 	if (IS_ERR(psock))
 		return PTR_ERR(psock);
 
-	if (psock) {
-		tcp_bpf_reinit(sk);
-		return 0;
-	}
+	if (!psock)
+		psock = sk_psock_init(sk, map->numa_node);
 
-	psock = sk_psock_init(sk, map->numa_node);
 	if (!psock)
 		return -ENOMEM;
 
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 3327afa05c3d..ed8a8f3c9afe 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -629,14 +629,6 @@ static int __init tcp_bpf_v4_build_proto(void)
 }
 core_initcall(tcp_bpf_v4_build_proto);
 
-static void tcp_bpf_update_sk_prot(struct sock *sk, struct sk_psock *psock)
-{
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
-	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
-
-	sk_psock_update_proto(sk, psock, &tcp_bpf_prots[family][config]);
-}
-
 static int tcp_bpf_assert_proto_ops(struct proto *ops)
 {
 	/* In order to avoid retpoline, we make assumptions when we call
@@ -648,34 +640,44 @@ static int tcp_bpf_assert_proto_ops(struct proto *ops)
 	       ops->sendpage == tcp_sendpage ? 0 : -ENOTSUPP;
 }
 
-void tcp_bpf_reinit(struct sock *sk)
+static struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock *psock;
+	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
+	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
 
-	sock_owned_by_me(sk);
+	if (!psock->sk_proto) {
+		struct proto *ops = READ_ONCE(sk->sk_prot);
 
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	tcp_bpf_update_sk_prot(sk, psock);
-	rcu_read_unlock();
+		if (tcp_bpf_assert_proto_ops(ops))
+			return ERR_PTR(-EINVAL);
+
+		tcp_bpf_check_v6_needs_rebuild(sk, ops);
+	}
+
+	return &tcp_bpf_prots[family][config];
 }
 
 int tcp_bpf_init(struct sock *sk)
 {
-	struct proto *ops = READ_ONCE(sk->sk_prot);
 	struct sk_psock *psock;
+	struct proto *prot;
 
 	sock_owned_by_me(sk);
 
 	rcu_read_lock();
 	psock = sk_psock(sk);
-	if (unlikely(!psock || psock->sk_proto ||
-		     tcp_bpf_assert_proto_ops(ops))) {
+	if (unlikely(!psock)) {
 		rcu_read_unlock();
 		return -EINVAL;
 	}
-	tcp_bpf_check_v6_needs_rebuild(sk, ops);
-	tcp_bpf_update_sk_prot(sk, psock);
+
+	prot = tcp_bpf_get_proto(sk, psock);
+	if (IS_ERR(prot)) {
+		rcu_read_unlock();
+		return PTR_ERR(prot);
+	}
+
+	sk_psock_update_proto(sk, psock, prot);
 	rcu_read_unlock();
 	return 0;
 }
-- 
2.20.1

