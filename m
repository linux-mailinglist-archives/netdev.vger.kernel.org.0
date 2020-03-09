Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A45D17DE51
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCILNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 07:13:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45449 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgCILNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 07:13:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id m9so1516418wro.12
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 04:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l0ktpDWRQDpySqc55O3ycjYmqR9R3A/TAGAj92uhxn4=;
        b=lsDFCtzXoGyzp8BojMVT0mpbNB9e5AzYEbZF7+Vflwqw/Yu6HaPKpfJFS9jfR4DUrx
         s3AkLVbeMXqYviEixKJlNtUkFGZM5yHLT8Kd1JBBB6bUoEzRvqGHLAKzSlNRxq0hiN3C
         RdVOYhNPXTEh3G0Qe0Y4eiC61rnfsrHOsYpyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l0ktpDWRQDpySqc55O3ycjYmqR9R3A/TAGAj92uhxn4=;
        b=SN1cKyGQwHNhG0bS7T+OxU8/pU9cHTPsnoNclbZKXxTd2//EGnybzBMckQ42QCTV2g
         KlC2ju12mGQXglCvj6zcjjCnVtpLKQgIOs215EDflgZAr17/HabP4gpMFx6xfbTjj+mG
         YxkTCsbf0cvgC2JDJuHUn0kEiUy1lq8C8gbZnjz0NGW2iqz6fqR/kZ3zP0M2f3xzl3+v
         0M85MehsvU833gTR9BRBgLlrtgweBjceaH8VXJBcouilwYfGKIY7QVPRmlxxsheTDJXS
         +0s2sDaNg3BqHwmIWWb7WGMKkTJCP63M0lumG9X/kTGdbp0Nx2+RAb0lUaCMUmN77fHS
         REvg==
X-Gm-Message-State: ANhLgQ1BJpkgZ83apUn7EUCCxyLRVq99g5Zya1Bb3nbBdtQBRH08HK2Q
        XsLbXNUXvttA2yi1p+BtPYP3Jw==
X-Google-Smtp-Source: ADFU+vuZLy9l5fDEExjlVjYsQqqtTJX6BELy9Vyk7fsm0xfvThaVLXjqvV3FD10xTBBoJsm1XPY6hA==
X-Received: by 2002:a5d:550f:: with SMTP id b15mr20607372wrv.19.1583752394074;
        Mon, 09 Mar 2020 04:13:14 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:3dcc:c1d:7f05:4873])
        by smtp.gmail.com with ESMTPSA id a5sm25732846wmb.37.2020.03.09.04.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 04:13:13 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 03/12] bpf: tcp: move assertions into tcp_bpf_get_proto
Date:   Mon,  9 Mar 2020 11:12:34 +0000
Message-Id: <20200309111243.6982-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200309111243.6982-1-lmb@cloudflare.com>
References: <20200309111243.6982-1-lmb@cloudflare.com>
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
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/tcp.h   |  1 -
 net/core/sock_map.c | 25 +++++++++----------------
 net/ipv4/tcp_bpf.c  | 42 ++++++++++++++++++++++--------------------
 3 files changed, 31 insertions(+), 37 deletions(-)

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
index cb8f740f7949..fafcbd22ecba 100644
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
@@ -239,15 +235,12 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
 	if (IS_ERR(psock))
 		return PTR_ERR(psock);
 
-	if (psock) {
-		tcp_bpf_reinit(sk);
-		return 0;
+	if (!psock) {
+		psock = sk_psock_init(sk, map->numa_node);
+		if (!psock)
+			return -ENOMEM;
 	}
 
-	psock = sk_psock_init(sk, map->numa_node);
-	if (!psock)
-		return -ENOMEM;
-
 	ret = tcp_bpf_init(sk);
 	if (ret < 0)
 		sk_psock_put(sk, psock);
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

