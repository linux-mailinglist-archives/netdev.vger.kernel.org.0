Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9243B14A49E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgA0NLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:11:11 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46435 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbgA0NLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:11:09 -0500
Received: by mail-lj1-f195.google.com with SMTP id x14so8225680ljd.13
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FNMkWCVrDwSTMxAPnYhbyJcpefMCHVAH/UCnwzz9dvU=;
        b=BHbWuVbK9x//kCkIk8U/Fom9z9ylmGlH+vRvMzu6LUOPb3hgV30ZnkmM4Ku3Nlhkf4
         1CBcEOsgTbKnKDtv4hb8svOdJtDjOYUeJwhDpTDs00un7gAWMb9y6Cxw1ZgHYd3DQUAv
         bhyiyACyqf0fp5mSeT1+nj6aj3HLW0YO4cWyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FNMkWCVrDwSTMxAPnYhbyJcpefMCHVAH/UCnwzz9dvU=;
        b=fLzwsE9gDaMJzTCwHcdSzpQhcrchxEgS/ZdDYpDYEgRz2BoNsrkUKlodzdwYMziguS
         v23izwLP0xKcAO7qPsyN9YATEVRuE0YmYuFhrQHG5yL+56vco4yk6Y9CZXlOsWfM3d0U
         I/AHbVe+ue5DYaIHQ0gJVCru5tmtTmUVXsf1WAH7Rz1C7ox3zJElhYt6QanaswIrgZGU
         EspQIB4V+CzRpIO+d0N/MPjpFfJuKcSTI+6wCyn2Nw5l1YNziFee7nRiBotwGdSsdB6L
         8JHuui20XRVsqOZg/BQTUna7USi0CyFG1yl/+tGoE0Gf505scQi+0F5Wpoapx3k4NVBk
         3Dsg==
X-Gm-Message-State: APjAAAWKPunbduM4WHXS+HrUC+cnxp+lVMJgg5bZXJDvmZgOnBWrPoeF
        12OtB7aDeNQWsUQo/wIjXcShGQ==
X-Google-Smtp-Source: APXvYqzni6Zsf/qCwHWOxixUAN//GuXYNT7ym1n3rZCaktoG7WIoK0ceJUb435xE/Je9gDg3Y125pQ==
X-Received: by 2002:a2e:8907:: with SMTP id d7mr7002397lji.71.1580130666576;
        Mon, 27 Jan 2020 05:11:06 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u25sm1385933ljj.70.2020.01.27.05.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:11:06 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v6 05/12] bpf, sockmap: Allow inserting listening TCP sockets into sockmap
Date:   Mon, 27 Jan 2020 14:10:50 +0100
Message-Id: <20200127131057.150941-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127131057.150941-1-jakub@cloudflare.com>
References: <20200127131057.150941-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for sockmap type to become a generic collection for storing TCP
sockets we need to loosen the checks during map update, while tightening
the checks in redirect helpers.

Currently sockmap requires the TCP socket to be in established state (or
transitioning out of SYN_RECV into established state when done from BPF),
which prevents inserting listening sockets.

Change the update pre-checks so the socket can also be in listening state.

Since it doesn't make sense to redirect with sockmap to listening sockets,
add appropriate socket state checks to BPF redirect helpers too.

We leave sockhash as is for the moment, with no support for holding
listening sockets. Therefore sockhash needs its own set of checks.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c                     | 62 +++++++++++++++++++------
 tools/testing/selftests/bpf/test_maps.c |  6 +--
 2 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 8998e356f423..954c4d23bc01 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -388,15 +388,44 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 }
 
 static bool sock_map_op_okay(const struct bpf_sock_ops_kern *ops)
+{
+	return ops->op == BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB ||
+	       ops->op == BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB ||
+	       ops->op == BPF_SOCK_OPS_TCP_LISTEN_CB;
+}
+
+static bool sock_hash_op_okay(const struct bpf_sock_ops_kern *ops)
 {
 	return ops->op == BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB ||
 	       ops->op == BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB;
 }
 
+/* Only TCP sockets can be inserted into the map. They must be either
+ * in established or listening state. SYN_RECV is also allowed because
+ * BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB happens just before socket
+ * enters established state.
+ */
 static bool sock_map_sk_is_suitable(const struct sock *sk)
 {
 	return sk->sk_type == SOCK_STREAM &&
-	       sk->sk_protocol == IPPROTO_TCP;
+	       sk->sk_protocol == IPPROTO_TCP &&
+	       (1 << sk->sk_state) & (TCPF_ESTABLISHED |
+				      TCPF_SYN_RECV |
+				      TCPF_LISTEN);
+}
+
+static bool sock_hash_sk_is_suitable(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_STREAM &&
+	       sk->sk_protocol == IPPROTO_TCP &&
+	       (1 << sk->sk_state) & (TCPF_ESTABLISHED |
+				      TCPF_SYN_RECV);
+}
+
+/* Is sock in a state that allows redirecting into it? */
+static bool sock_map_redirect_okay(const struct sock *sk)
+{
+	return sk->sk_state != TCP_LISTEN;
 }
 
 static int sock_map_update_elem(struct bpf_map *map, void *key,
@@ -416,8 +445,7 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk) ||
-	    sk->sk_state != TCP_ESTABLISHED) {
+	if (!sock_map_sk_is_suitable(sk)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -457,13 +485,17 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
 	   struct bpf_map *, map, u32, key, u64, flags)
 {
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
+	struct sock *sk;
 
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
 		return SK_DROP;
-	tcb->bpf.flags = flags;
-	tcb->bpf.sk_redir = __sock_map_lookup_elem(map, key);
-	if (!tcb->bpf.sk_redir)
+
+	sk = __sock_map_lookup_elem(map, key);
+	if (unlikely(!sk || !sock_map_redirect_okay(sk)))
 		return SK_DROP;
+
+	tcb->bpf.flags = flags;
+	tcb->bpf.sk_redir = sk;
 	return SK_PASS;
 }
 
@@ -480,12 +512,17 @@ const struct bpf_func_proto bpf_sk_redirect_map_proto = {
 BPF_CALL_4(bpf_msg_redirect_map, struct sk_msg *, msg,
 	   struct bpf_map *, map, u32, key, u64, flags)
 {
+	struct sock *sk;
+
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
 		return SK_DROP;
-	msg->flags = flags;
-	msg->sk_redir = __sock_map_lookup_elem(map, key);
-	if (!msg->sk_redir)
+
+	sk = __sock_map_lookup_elem(map, key);
+	if (unlikely(!sk || !sock_map_redirect_okay(sk)))
 		return SK_DROP;
+
+	msg->flags = flags;
+	msg->sk_redir = sk;
 	return SK_PASS;
 }
 
@@ -739,8 +776,7 @@ static int sock_hash_update_elem(struct bpf_map *map, void *key,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk) ||
-	    sk->sk_state != TCP_ESTABLISHED) {
+	if (!sock_hash_sk_is_suitable(sk)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -887,8 +923,8 @@ BPF_CALL_4(bpf_sock_hash_update, struct bpf_sock_ops_kern *, sops,
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	if (likely(sock_map_sk_is_suitable(sops->sk) &&
-		   sock_map_op_okay(sops)))
+	if (likely(sock_hash_sk_is_suitable(sops->sk) &&
+		   sock_hash_op_okay(sops)))
 		return sock_hash_update_common(map, key, sops->sk, flags);
 	return -EOPNOTSUPP;
 }
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 02eae1e864c2..c6766b2cff85 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -756,11 +756,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 	/* Test update without programs */
 	for (i = 0; i < 6; i++) {
 		err = bpf_map_update_elem(fd, &i, &sfd[i], BPF_ANY);
-		if (i < 2 && !err) {
-			printf("Allowed update sockmap '%i:%i' not in ESTABLISHED\n",
-			       i, sfd[i]);
-			goto out_sockmap;
-		} else if (i >= 2 && err) {
+		if (err) {
 			printf("Failed noprog update sockmap '%i:%i'\n",
 			       i, sfd[i]);
 			goto out_sockmap;
-- 
2.24.1

