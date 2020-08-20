Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5424C023
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgHTOIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731160AbgHTN6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:58:06 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67667C061387
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:06 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y3so2128306wrl.4
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sAJPVYcsrbGx3N5LhQWWl+joMPHyHeZRVA3ccro29ww=;
        b=RG0Qs1uKyPy/Y0bb0vnUh1XZBm056zB9dglyI9LN82QFvqfPTNnlu6CW/nbLMsZmWx
         4rd/S9sIetCHDym92K2xsrw+KBlBLaY0B1o3RRnMZzKXbQAr83LAvDNoKYPJ5bH0JpkL
         Eyzo1jCEZNy5Uwb0xtjdn+gQgSs5CLwKXRXCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sAJPVYcsrbGx3N5LhQWWl+joMPHyHeZRVA3ccro29ww=;
        b=X3LvXoNkHInSew7f8/X/HtA6AxDM5Y/lix+qUHgbdO9Hf7EC9wGxJGKuqO5JdGFmdX
         3MomgEFFIkTThmBYkerzq7UyqvucHVNhXU38way1YUYK2ASh7EtGfdK+jzyX/8PDEEBN
         KpoZ6WNCG1z8+2xCu2ZxJ2NdTRE+M7kPguQa2jjPfOc2lFp78HYWPaJ6vFthXnRasN0I
         HoNtk8FaXYj2pHePeP36EiiN+alIsbS2mDqnTHKsGXvX9krRD0kKQlFy2gVg87txMMP+
         llccpI/LEsnEsEPtaIpckXmcmyHlUxCJaU3yirJCTRgY4nCf1PMgokEPBZiHGLI1qvmD
         /S1w==
X-Gm-Message-State: AOAM532idZr60mpJ/2YtwhIKsxCqKXT3tKasMmgujbqS2suWcUAWQecV
        G7JxIXSuERTVp7V8aLeEmhPllQ==
X-Google-Smtp-Source: ABdhPJyEvgcyItHObQ+0UiLlAX1mIWd03TQhO2Pi+WhHB9vhcd5YgdXBFjICXLZ+JraZdHeCaDa+5g==
X-Received: by 2002:a5d:4d8f:: with SMTP id b15mr3382140wru.341.1597931884974;
        Thu, 20 Aug 2020 06:58:04 -0700 (PDT)
Received: from antares.lan (d.0.f.e.b.c.7.2.d.c.3.8.4.8.d.9.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:9d84:83cd:27cb:ef0d])
        by smtp.gmail.com with ESMTPSA id l81sm4494215wmf.4.2020.08.20.06.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 06:58:04 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 1/6] net: sk_msg: simplify sk_psock initialization
Date:   Thu, 20 Aug 2020 14:57:24 +0100
Message-Id: <20200820135729.135783-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820135729.135783-1-lmb@cloudflare.com>
References: <20200820135729.135783-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initializing psock->sk_proto and other saved callbacks is only
done in sk_psock_update_proto, after sk_psock_init has returned.
The logic for this is difficult to follow, and needlessly complex.

Instead, initialize psock->sk_proto whenever we allocate a new
psock. Additionally, assert the following invariants:

* The SK has no ULP: ULP does it's own finagling of sk->sk_prot
* sk_user_data is unused: we need it to store sk_psock

Protect our access to sk_user_data with sk_callback_lock, which
is what other users like reuseport arrays, etc. do.

The result is that an sk_psock is always fully initialized, and
that psock->sk_proto is always the "original" struct proto.
The latter allows us to use psock->sk_proto when initializing
IPv6 TCP / UDP callbacks for sockmap.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/skmsg.h | 17 -----------------
 net/core/skmsg.c      | 34 ++++++++++++++++++++++++++++------
 net/core/sock_map.c   | 14 ++++----------
 net/ipv4/tcp_bpf.c    | 13 +++++--------
 net/ipv4/udp_bpf.c    |  9 ++++-----
 5 files changed, 41 insertions(+), 46 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 1e9ed840b9fc..3119928fc103 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -340,23 +340,6 @@ static inline void sk_psock_update_proto(struct sock *sk,
 					 struct sk_psock *psock,
 					 struct proto *ops)
 {
-	/* Initialize saved callbacks and original proto only once, since this
-	 * function may be called multiple times for a psock, e.g. when
-	 * psock->progs.msg_parser is updated.
-	 *
-	 * Since we've not installed the new proto, psock is not yet in use and
-	 * we can initialize it without synchronization.
-	 */
-	if (!psock->sk_proto) {
-		struct proto *orig = READ_ONCE(sk->sk_prot);
-
-		psock->saved_unhash = orig->unhash;
-		psock->saved_close = orig->close;
-		psock->saved_write_space = sk->sk_write_space;
-
-		psock->sk_proto = orig;
-	}
-
 	/* Pairs with lockless read in sk_clone_lock() */
 	WRITE_ONCE(sk->sk_prot, ops);
 }
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 6a32a1fd34f8..1c81caf9630f 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -494,14 +494,34 @@ static void sk_psock_backlog(struct work_struct *work)
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node)
 {
-	struct sk_psock *psock = kzalloc_node(sizeof(*psock),
-					      GFP_ATOMIC | __GFP_NOWARN,
-					      node);
-	if (!psock)
-		return NULL;
+	struct sk_psock *psock;
+	struct proto *prot;
 
+	write_lock_bh(&sk->sk_callback_lock);
+
+	if (inet_csk_has_ulp(sk)) {
+		psock = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	if (sk->sk_user_data) {
+		psock = ERR_PTR(-EBUSY);
+		goto out;
+	}
+
+	psock = kzalloc_node(sizeof(*psock), GFP_ATOMIC | __GFP_NOWARN, node);
+	if (!psock) {
+		psock = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	prot = READ_ONCE(sk->sk_prot);
 	psock->sk = sk;
-	psock->eval =  __SK_NONE;
+	psock->eval = __SK_NONE;
+	psock->sk_proto = prot;
+	psock->saved_unhash = prot->unhash;
+	psock->saved_close = prot->close;
+	psock->saved_write_space = sk->sk_write_space;
 
 	INIT_LIST_HEAD(&psock->link);
 	spin_lock_init(&psock->link_lock);
@@ -516,6 +536,8 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	rcu_assign_sk_user_data_nocopy(sk, psock);
 	sock_hold(sk);
 
+out:
+	write_unlock_bh(&sk->sk_callback_lock);
 	return psock;
 }
 EXPORT_SYMBOL_GPL(sk_psock_init);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 119f52a99dc1..abe4bac40db9 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -184,8 +184,6 @@ static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
 {
 	struct proto *prot;
 
-	sock_owned_by_me(sk);
-
 	switch (sk->sk_type) {
 	case SOCK_STREAM:
 		prot = tcp_bpf_get_proto(sk, psock);
@@ -272,8 +270,8 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		}
 	} else {
 		psock = sk_psock_init(sk, map->numa_node);
-		if (!psock) {
-			ret = -ENOMEM;
+		if (IS_ERR(psock)) {
+			ret = PTR_ERR(psock);
 			goto out_progs;
 		}
 	}
@@ -322,8 +320,8 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
 
 	if (!psock) {
 		psock = sk_psock_init(sk, map->numa_node);
-		if (!psock)
-			return -ENOMEM;
+		if (IS_ERR(psock))
+			return PTR_ERR(psock);
 	}
 
 	ret = sock_map_init_proto(sk, psock);
@@ -478,8 +476,6 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 		return -EINVAL;
 	if (unlikely(idx >= map->max_entries))
 		return -E2BIG;
-	if (inet_csk_has_ulp(sk))
-		return -EINVAL;
 
 	link = sk_psock_init_link();
 	if (!link)
@@ -855,8 +851,6 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	if (unlikely(flags > BPF_EXIST))
 		return -EINVAL;
-	if (inet_csk_has_ulp(sk))
-		return -EINVAL;
 
 	link = sk_psock_init_link();
 	if (!link)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 7aa68f4aae6c..37f4cb2bba5c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -567,10 +567,9 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 	prot[TCP_BPF_TX].sendpage		= tcp_bpf_sendpage;
 }
 
-static void tcp_bpf_check_v6_needs_rebuild(struct sock *sk, struct proto *ops)
+static void tcp_bpf_check_v6_needs_rebuild(struct proto *ops)
 {
-	if (sk->sk_family == AF_INET6 &&
-	    unlikely(ops != smp_load_acquire(&tcpv6_prot_saved))) {
+	if (unlikely(ops != smp_load_acquire(&tcpv6_prot_saved))) {
 		spin_lock_bh(&tcpv6_prot_lock);
 		if (likely(ops != tcpv6_prot_saved)) {
 			tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV6], ops);
@@ -603,13 +602,11 @@ struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
 	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
 
-	if (!psock->sk_proto) {
-		struct proto *ops = READ_ONCE(sk->sk_prot);
-
-		if (tcp_bpf_assert_proto_ops(ops))
+	if (sk->sk_family == AF_INET6) {
+		if (tcp_bpf_assert_proto_ops(psock->sk_proto))
 			return ERR_PTR(-EINVAL);
 
-		tcp_bpf_check_v6_needs_rebuild(sk, ops);
+		tcp_bpf_check_v6_needs_rebuild(psock->sk_proto);
 	}
 
 	return &tcp_bpf_prots[family][config];
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index eddd973e6575..7a94791efc1a 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -22,10 +22,9 @@ static void udp_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 	prot->close  = sock_map_close;
 }
 
-static void udp_bpf_check_v6_needs_rebuild(struct sock *sk, struct proto *ops)
+static void udp_bpf_check_v6_needs_rebuild(struct proto *ops)
 {
-	if (sk->sk_family == AF_INET6 &&
-	    unlikely(ops != smp_load_acquire(&udpv6_prot_saved))) {
+	if (unlikely(ops != smp_load_acquire(&udpv6_prot_saved))) {
 		spin_lock_bh(&udpv6_prot_lock);
 		if (likely(ops != udpv6_prot_saved)) {
 			udp_bpf_rebuild_protos(&udp_bpf_prots[UDP_BPF_IPV6], ops);
@@ -46,8 +45,8 @@ struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
 {
 	int family = sk->sk_family == AF_INET ? UDP_BPF_IPV4 : UDP_BPF_IPV6;
 
-	if (!psock->sk_proto)
-		udp_bpf_check_v6_needs_rebuild(sk, READ_ONCE(sk->sk_prot));
+	if (sk->sk_family == AF_INET6)
+		udp_bpf_check_v6_needs_rebuild(psock->sk_proto);
 
 	return &udp_bpf_prots[family];
 }
-- 
2.25.1

