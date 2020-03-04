Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6451F178E40
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbgCDKOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:14:37 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45810 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgCDKNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:13:40 -0500
Received: by mail-lj1-f194.google.com with SMTP id e18so1324701ljn.12
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EenU9yZK2/jzwrr5oZBiAsnp6ceFzB9DFtCmR6XHR5w=;
        b=o+x7eRDaPnSYB5uyZOTod1lA3V77j5gT8Oon7I90S2mFrTseRPpo2vrINK1AiJX2wK
         vhCUF+Y7tREuAYlJFlFjqtQu0Tgk+Fn7H8tjnF7n6GofVCqRaBNkCqfbQwFP0/H0H57b
         FFOrcuL42EgJ0YQt9PwWhEgBSTAzEyufhZl2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EenU9yZK2/jzwrr5oZBiAsnp6ceFzB9DFtCmR6XHR5w=;
        b=XumQkl7IJ89VQgDSMIH1W+Si7qyQRQZya9r/YQbxy6tBwEmWFRiZbcYXBhYv0A2Edw
         XWzYUt5mC3Id6FvPfpYrXeQXulNfDHY3Vw1Ein/qDG4uUzZbJvSAyfFOFGZtV87UyAwg
         yelDpfVgE+J/mXApalpYwjPtl1mK1W3UZ/38cePxwu2MnRbdQxyif+8y0FKY6PFq0afO
         WquWGV0Rzp2MF1/JLuTFeV7aE0p5MfxRB07cQga1Rx1EQOxN17iRomYjuNpTDEM8oDqC
         emzaADhh7KUJo8boD0dVQiJo3+E8gUNq5ErZG7LkU4w7FxjUjr1QeNFXFDgox34//aI8
         DbEw==
X-Gm-Message-State: ANhLgQ33HAZJ2A8MjLOqOcfr6qs0THDnrpOrcg5oY1iggi9fmcIhtJec
        GaK1sRUTK72la5vd13m9+3De7Q==
X-Google-Smtp-Source: ADFU+vvTnugkfb0qBFW6Inl/wZ9KMYoLND9O6UD4p+XZkWt/xVg5dcPjQIOaqbj4c6W07j/ZxG2qfw==
X-Received: by 2002:a05:651c:102c:: with SMTP id w12mr1480586ljm.74.1583316817792;
        Wed, 04 Mar 2020 02:13:37 -0800 (PST)
Received: from localhost.localdomain ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id l7sm341777lfk.65.2020.03.04.02.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 02:13:37 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 01/12] bpf: sockmap: only check ULP for TCP sockets
Date:   Wed,  4 Mar 2020 11:13:06 +0100
Message-Id: <20200304101318.5225-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304101318.5225-1-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
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
 include/linux/skmsg.h              | 8 +++++++-
 include/net/inet_connection_sock.h | 6 ++++++
 net/core/sock_map.c                | 6 ++----
 net/ipv4/tcp_ulp.c                 | 7 -------
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 112765bd146d..4d3d75d63066 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -360,7 +360,13 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
 	sk->sk_prot->unhash = psock->saved_unhash;
-	tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
+	if (inet_csk_has_ulp(sk)) {
+		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
+	} else {
+		sk->sk_write_space = psock->saved_write_space;
+		/* Pairs with lockless read in sk_clone_lock() */
+		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+	}
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 895546058a20..a3f076befa4f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -335,4 +335,10 @@ static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
 	if (icsk->icsk_ack.pingpong < U8_MAX)
 		icsk->icsk_ack.pingpong++;
 }
+
+static inline bool inet_csk_has_ulp(struct sock *sk)
+{
+	return inet_sk(sk)->is_icsk && !!inet_csk(sk)->icsk_ulp_ops;
+}
+
 #endif /* _INET_CONNECTION_SOCK_H */
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2e0f465295c3..cb8f740f7949 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -384,7 +384,6 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
 {
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
-	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct sk_psock_link *link;
 	struct sk_psock *psock;
 	struct sock *osk;
@@ -395,7 +394,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 		return -EINVAL;
 	if (unlikely(idx >= map->max_entries))
 		return -E2BIG;
-	if (unlikely(rcu_access_pointer(icsk->icsk_ulp_data)))
+	if (inet_csk_has_ulp(sk))
 		return -EINVAL;
 
 	link = sk_psock_init_link();
@@ -738,7 +737,6 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 				   struct sock *sk, u64 flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 key_size = map->key_size, hash;
 	struct bpf_htab_elem *elem, *elem_new;
 	struct bpf_htab_bucket *bucket;
@@ -749,7 +747,7 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	if (unlikely(flags > BPF_EXIST))
 		return -EINVAL;
-	if (unlikely(icsk->icsk_ulp_data))
+	if (inet_csk_has_ulp(sk))
 		return -EINVAL;
 
 	link = sk_psock_init_link();
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 2703f24c5d1a..7c27aa629af1 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -105,13 +105,6 @@ void tcp_update_ulp(struct sock *sk, struct proto *proto,
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
-	if (!icsk->icsk_ulp_ops) {
-		sk->sk_write_space = write_space;
-		/* Pairs with lockless read in sk_clone_lock() */
-		WRITE_ONCE(sk->sk_prot, proto);
-		return;
-	}
-
 	if (icsk->icsk_ulp_ops->update)
 		icsk->icsk_ulp_ops->update(sk, proto, write_space);
 }
-- 
2.20.1

