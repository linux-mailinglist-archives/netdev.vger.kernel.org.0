Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E14D173688
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgB1Lyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:54:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41206 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgB1Lyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:54:35 -0500
Received: by mail-wr1-f65.google.com with SMTP id v4so2612306wrs.8
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p/IkxmE2XQKvvaJ3+jizWlUITUqYZdNJGm8v0gfliUM=;
        b=Kfq1WCVgU73x9jff4qBeqW5es8Zs2Cx+sMSyqlg4qPOtbVipTmPiKTENK9xj11Xd23
         OXVKrbNWfAEsnY3A7a8kmphKkf7x8P5vWBvnuL4MFRoDxPAH7vAhVJjcJ0aZu9BjNqZ1
         ncnQLhC4Rj/MPzM8sCsHPUx1r1OR8ogIzo5I4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p/IkxmE2XQKvvaJ3+jizWlUITUqYZdNJGm8v0gfliUM=;
        b=AbkytKadfLU5b4s1PpxeFGqZYinEPf5OaC1M/8Kyc/LW01JecXbSA6cokk1eBWiQ11
         0+DIViRzwj90KbWT0GY1qGwzn2Y05dBzlMGeJF58jdps2dV3p+aYoh/eb6mtWUvHjHuA
         rjpjetFDQtvJKLVlJ7B8I894jjcD+IXumA1igSVQi9i7YJQsCe/+oLyw+lBt0/zI394B
         7+8x/4Io08QS51sxjmzj+dNw54PYQgZnw+skC52Qh0QY7V7fyW4aSez3RbNN8ACvMPQ0
         2OH81x8pG+x0zVSH9p8ucL7tEPi8BBxORY9ShiR14rEjGfhFQKPdlKRFVqCG1+8JbPrJ
         fDOQ==
X-Gm-Message-State: APjAAAXfd/2ax7GEEXxqer2ToR/8887p2WPBz9ot3gFdEqRUStlUCeV1
        NbmaNmqxs+rCaqIIW9G0UubWEg==
X-Google-Smtp-Source: APXvYqwUxSfb9lzvkCHJt6DbgjNm7J7iIaMQ3dHV1KlH7ju+YZAsfdnsRU0PSfwwU+3oQeDG6J0qgw==
X-Received: by 2002:a5d:674c:: with SMTP id l12mr4752283wrw.351.1582890872961;
        Fri, 28 Feb 2020 03:54:32 -0800 (PST)
Received: from antares.lan (b.2.d.a.1.b.1.b.2.c.5.e.0.3.d.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4d30:e5c2:b1b1:ad2b])
        by smtp.gmail.com with ESMTPSA id q125sm2044284wme.19.2020.02.28.03.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 03:54:32 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 1/9] bpf: sockmap: only check ULP for TCP sockets
Date:   Fri, 28 Feb 2020 11:53:36 +0000
Message-Id: <20200228115344.17742-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228115344.17742-1-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sock map code checks that a socket does not have an active upper
layer protocol before inserting it into the map. This requires casting
via inet_csk, which isn't valid for UDP sockets.

Guard checks for ULP by checking inet_sk(sk)->is_icsk first.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/skmsg.h |  8 +++++++-
 net/core/sock_map.c   | 11 +++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 112765bd146d..54a9a3e36b29 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -360,7 +360,13 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
 	sk->sk_prot->unhash = psock->saved_unhash;
-	tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
+	if (inet_sk(sk)->is_icsk) {
+		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
+	} else {
+		sk->sk_write_space = psock->saved_write_space;
+		/* Pairs with lockless read in sk_clone_lock() */
+		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+	}
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2e0f465295c3..695ecacc7afa 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -94,6 +94,11 @@ static void sock_map_sk_release(struct sock *sk)
 	release_sock(sk);
 }
 
+static bool sock_map_sk_has_ulp(struct sock *sk)
+{
+	return inet_sk(sk)->is_icsk && !!inet_csk(sk)->icsk_ulp_ops;
+}
+
 static void sock_map_add_link(struct sk_psock *psock,
 			      struct sk_psock_link *link,
 			      struct bpf_map *map, void *link_raw)
@@ -384,7 +389,6 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
 {
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
-	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct sk_psock_link *link;
 	struct sk_psock *psock;
 	struct sock *osk;
@@ -395,7 +399,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 		return -EINVAL;
 	if (unlikely(idx >= map->max_entries))
 		return -E2BIG;
-	if (unlikely(rcu_access_pointer(icsk->icsk_ulp_data)))
+	if (sock_map_sk_has_ulp(sk))
 		return -EINVAL;
 
 	link = sk_psock_init_link();
@@ -738,7 +742,6 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 				   struct sock *sk, u64 flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 key_size = map->key_size, hash;
 	struct bpf_htab_elem *elem, *elem_new;
 	struct bpf_htab_bucket *bucket;
@@ -749,7 +752,7 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	if (unlikely(flags > BPF_EXIST))
 		return -EINVAL;
-	if (unlikely(icsk->icsk_ulp_data))
+	if (sock_map_sk_has_ulp(sk))
 		return -EINVAL;
 
 	link = sk_psock_init_link();
-- 
2.20.1

