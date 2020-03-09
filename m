Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DBB17DE66
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgCILNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 07:13:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41528 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCILNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 07:13:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id v4so10527707wrs.8
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 04:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WMyg7pCfXdHMLCKOerV6zy+N1MUm0AZkVXPfqbhW8o0=;
        b=uimwTk5QPDyKXZilqAMz/htCRgOuuWvkJUXn07r1/thbm7VJkAMFdm//mlax4vhQNy
         U9433wikxYHD0s5RZMzFksEGq+hvP3PHnjNVP9zpZ5FSMp8VQDR1ixL26ASxWo6InHGA
         zl+0uh109hyvlGmnw3teDVmRYdl/HAYRTQCPk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMyg7pCfXdHMLCKOerV6zy+N1MUm0AZkVXPfqbhW8o0=;
        b=RpHsyhp05Py2qyRmgu6BXggKtabps1ZNGyqcvVhDN47mbHvFoe5FsyAaunG7ecC68K
         JYvlE8dRijTR5RdVnFTLSZmM6PfzE/Cau1kpQu++UC6r6AWVF9d5UcRho7p93GUhEnSi
         VR9YfNmTbDmQ6Oe6BtyxfefEsxn78oZIf5LUkDw/02jFGWvECMOeRC0YD4fqo7hBEr6k
         c+bizV3IwfNwIvORPLJxdQB/oqzl+ywH4cjkCrap3JmIDAipxpr/mrejHRjr2CYqBUYf
         +/vfK3HKLltT/gGWGa6z7NtSVN+kxows5i4j8I4kxluTVCPkde5QlVvXYDXTDgrfAlnt
         5zfw==
X-Gm-Message-State: ANhLgQ1o5F1w8f5+bQelP4UqSFNVdo6lJDjDJ1Em8YFngM24w8Yn0L7K
        nm4l2WFmSFR5yeYuRWeykokD2A==
X-Google-Smtp-Source: ADFU+vuOokH6uFgKito0/8n00AM/5sTsRGnEBFjhTXEJ1oKGQwzc/Tpb6b4BZ2riU+yVxuPNyeHsoA==
X-Received: by 2002:a5d:6a8d:: with SMTP id s13mr17553709wru.260.1583752390276;
        Mon, 09 Mar 2020 04:13:10 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:3dcc:c1d:7f05:4873])
        by smtp.gmail.com with ESMTPSA id a5sm25732846wmb.37.2020.03.09.04.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 04:13:09 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: [PATCH bpf-next v4 01/12] bpf: sockmap: only check ULP for TCP sockets
Date:   Mon,  9 Mar 2020 11:12:32 +0000
Message-Id: <20200309111243.6982-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200309111243.6982-1-lmb@cloudflare.com>
References: <20200309111243.6982-1-lmb@cloudflare.com>
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
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
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

