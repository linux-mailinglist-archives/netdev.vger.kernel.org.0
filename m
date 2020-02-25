Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0819A16C2ED
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgBYN4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:56:46 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51123 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729287AbgBYN4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:56:42 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so3104406wmb.0
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p/IkxmE2XQKvvaJ3+jizWlUITUqYZdNJGm8v0gfliUM=;
        b=cTWhodGJPh3JS/kke4UU4bdd2oU+0z1lMqE8gGZz1xxDYClfUD119d5whmo+rfsK8m
         u1WlcdFsUkQcSo3ZXtYt7Zl+Il8epgBbAsrbKUIk/6+D7mortM5qdCsUFYftnXAh6oIQ
         oT1RpuLOVjeBSHPKcb9GFj5aN9G22eDTGsgMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p/IkxmE2XQKvvaJ3+jizWlUITUqYZdNJGm8v0gfliUM=;
        b=UHmcNX0vod2quivpWML3v0PCv8BXz/X/hB1+Hq2neg2LUyfxzqZjYqTYY9PnCwMx2P
         a0HmPAulLQRAyfo7CkP7X/WOqp+T2kzeU3LVGGCOkMPem5AWh0UifiNzkGx67jtH2CEp
         UrlHVte/O0jCuvmZnpM3uSIcAtHwvLjIEP2khw18TKv3lZTToZW8hv2nOugIMieCMhaC
         2mvdA4f/j4S+kRfRjHO17Y5/bmDV2yQ2hwOiqhmVdJs9D611RagIem3oNJCncGHvPFD7
         93CK3QOkJRImwnrudj2OdahuW+ayg14oXP25IaHA98PAiVf10/K1O1E52B+wRfdS66Vh
         e4ww==
X-Gm-Message-State: APjAAAUYoxT2R9sYysQRIBwGncOHhRAbkeDpUj0AdDmi8QGf/yaPEqfn
        Pd+qzrtBEbSYPbZfWA3aWsuIFg==
X-Google-Smtp-Source: APXvYqyYeqYl/GpMwckv9yHpES5fKL/iEnsM03HXewDNyYnWWDYNSS129uIzzAwlsBDIc04rrUcIAQ==
X-Received: by 2002:a1c:4c5:: with SMTP id 188mr5403025wme.82.1582639000922;
        Tue, 25 Feb 2020 05:56:40 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8800:3dea:15ba:1870:8e94])
        by smtp.gmail.com with ESMTPSA id t128sm4463580wmf.28.2020.02.25.05.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:56:40 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 1/7] bpf: sockmap: only check ULP for TCP sockets
Date:   Tue, 25 Feb 2020 13:56:30 +0000
Message-Id: <20200225135636.5768-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225135636.5768-1-lmb@cloudflare.com>
References: <20200225135636.5768-1-lmb@cloudflare.com>
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

