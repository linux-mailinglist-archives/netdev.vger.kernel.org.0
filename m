Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10E2162BAB
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgBRRKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:10:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37472 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbgBRRKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:10:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so24890979wru.4
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGTSehJ5TwYB7pauEmablAq42Bhbe81QdImSWqamCt4=;
        b=W2k/njCwiHKqF0PKF+7scxNf4HDUM1hnyp2lvQTTPtcOfcFQfddFv73jcSgkT8N4Kr
         ea19vCDTD6JXAsxSbnsAuFWl5ZrL4CxQF6kd0PQl9PX8ECVhD2a9lDCHIcGfFe2+bYbA
         VSVhi402FDHKxkg5Hacc1u6L8T6mbgKTiukKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGTSehJ5TwYB7pauEmablAq42Bhbe81QdImSWqamCt4=;
        b=ENIg1MfJhbzJnrGNICdeA2jZkyMoKvQwtvJ7VWywjG6fPzCzNIOcpVcQhUNMEO26Ki
         hn99KYUFpFidBI6AQcoErgDrCHu9XZq+vODo4Dx0vTqcS7cqR8XH1yw0OmhT4IPYEUqO
         AwPfSiUXjhjX2DSfZ5O7vxxFW7m0RDiAEho6mlvYuik2AgyECkxbv1/YHANz7Q0fOXD1
         kQVxj6GAtYA5EPhZQ8MCjFD56b/T2e9TcOq+g2jp4fqccA/ub1vn/j/gd4xq1n7pQkEl
         AAVJSnea4eRVzN0tI4PK0TZ8zfWK0ooPdXAOBv+0ExmzJ/xB76WIq+K4tEA+DPY0h9+T
         qQVw==
X-Gm-Message-State: APjAAAXwtqc0oMToqIHqP+YwaKM2Go1TDa2pEXNA6k4uzl6E66QH6kvw
        ivi3z+ZFfwh/WSKs2yUZTrIVuw==
X-Google-Smtp-Source: APXvYqx/qsTHcJCA7ZKM2gxcfxgqHtlWx0OZL9EgGEHyUWNHNV3nIfQ/OhEsN+kBjUWnHxpb9rC/IQ==
X-Received: by 2002:a5d:4d04:: with SMTP id z4mr32379611wrt.157.1582045832049;
        Tue, 18 Feb 2020 09:10:32 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id 16sm4312144wmi.0.2020.02.18.09.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:10:31 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v7 04/11] bpf, sockmap: Allow inserting listening TCP sockets into sockmap
Date:   Tue, 18 Feb 2020 17:10:16 +0000
Message-Id: <20200218171023.844439-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218171023.844439-1-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for sockmap/sockhash types to become generic collections for
storing TCP sockets we need to loosen the checks during map update, while
tightening the checks in redirect helpers.

Currently sock{map,hash} require the TCP socket to be in established state,
which prevents inserting listening sockets.

Change the update pre-checks so the socket can also be in listening state.

Since it doesn't make sense to redirect with sock{map,hash} to listening
sockets, add appropriate socket state checks to BPF redirect helpers too.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c                     | 59 ++++++++++++++++++-------
 tools/testing/selftests/bpf/test_maps.c |  6 +--
 2 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 3a7a96ab088a..dd92a3556d73 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -391,7 +391,8 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 static bool sock_map_op_okay(const struct bpf_sock_ops_kern *ops)
 {
 	return ops->op == BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB ||
-	       ops->op == BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB;
+	       ops->op == BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB ||
+	       ops->op == BPF_SOCK_OPS_TCP_LISTEN_CB;
 }
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
@@ -400,6 +401,16 @@ static bool sock_map_sk_is_suitable(const struct sock *sk)
 	       sk->sk_protocol == IPPROTO_TCP;
 }
 
+static bool sock_map_sk_state_allowed(const struct sock *sk)
+{
+	return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
+}
+
+static bool sock_map_redirect_allowed(const struct sock *sk)
+{
+	return sk->sk_state != TCP_LISTEN;
+}
+
 static int sock_map_update_elem(struct bpf_map *map, void *key,
 				void *value, u64 flags)
 {
@@ -423,7 +434,7 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
 	}
 
 	sock_map_sk_acquire(sk);
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (!sock_map_sk_state_allowed(sk))
 		ret = -EOPNOTSUPP;
 	else
 		ret = sock_map_update_common(map, idx, sk, flags);
@@ -460,13 +471,17 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
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
+	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+
+	tcb->bpf.flags = flags;
+	tcb->bpf.sk_redir = sk;
 	return SK_PASS;
 }
 
@@ -483,12 +498,17 @@ const struct bpf_func_proto bpf_sk_redirect_map_proto = {
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
+	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+
+	msg->flags = flags;
+	msg->sk_redir = sk;
 	return SK_PASS;
 }
 
@@ -748,7 +768,7 @@ static int sock_hash_update_elem(struct bpf_map *map, void *key,
 	}
 
 	sock_map_sk_acquire(sk);
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (!sock_map_sk_state_allowed(sk))
 		ret = -EOPNOTSUPP;
 	else
 		ret = sock_hash_update_common(map, key, sk, flags);
@@ -916,13 +936,17 @@ BPF_CALL_4(bpf_sk_redirect_hash, struct sk_buff *, skb,
 	   struct bpf_map *, map, void *, key, u64, flags)
 {
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
+	struct sock *sk;
 
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
 		return SK_DROP;
-	tcb->bpf.flags = flags;
-	tcb->bpf.sk_redir = __sock_hash_lookup_elem(map, key);
-	if (!tcb->bpf.sk_redir)
+
+	sk = __sock_hash_lookup_elem(map, key);
+	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+
+	tcb->bpf.flags = flags;
+	tcb->bpf.sk_redir = sk;
 	return SK_PASS;
 }
 
@@ -939,12 +963,17 @@ const struct bpf_func_proto bpf_sk_redirect_hash_proto = {
 BPF_CALL_4(bpf_msg_redirect_hash, struct sk_msg *, msg,
 	   struct bpf_map *, map, void *, key, u64, flags)
 {
+	struct sock *sk;
+
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
 		return SK_DROP;
-	msg->flags = flags;
-	msg->sk_redir = __sock_hash_lookup_elem(map, key);
-	if (!msg->sk_redir)
+
+	sk = __sock_hash_lookup_elem(map, key);
+	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+
+	msg->flags = flags;
+	msg->sk_redir = sk;
 	return SK_PASS;
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

