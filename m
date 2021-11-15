Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE124527AB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 03:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbhKPC37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 21:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbhKORQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:16:37 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1421C079789
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:12:01 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 200so15151915pga.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WO8dTR6SDc0ydvzmoCXtSF00V+odJLso1OiEVZFx7X0=;
        b=JSAgaJlf+SMDXLQdCZo+F0xtasZDpsrhHm8LXq2HUiX2CLTxfCtzSRjk3OPQieQqxe
         h+zBsx2N0U/0lNCNtcrStON236apACp0Hu4AK4c7lGjuMs3m6KKK/ZDE+w9YhFkq3Xcb
         medX4laKaLcXujZ1+FQ+7Csp8rsCQPSy3UdbogqCHr/Pq5s+O12e+0hQUkZwiHZHrGAU
         5AWlWKnnK49Rw5dIx/kHtK79E75SBjWJuKujsVYVlC3FJBFF7jFKSm3O5KxbAidACvla
         QaKgUOOn7VoaMuzuyuuCl+MinXsal02h+owpsV1Ab6oFz6jQXFiAIYAGodl0M7toMUqh
         zIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WO8dTR6SDc0ydvzmoCXtSF00V+odJLso1OiEVZFx7X0=;
        b=PdCVnFw5aW1d1v8Im+1z9p3F4frh4yuCH9vtYLRJgw4HSaAl5OGUyBx4KxOP52baxF
         BttH7eB5vOKTg46fGJucMSSu/arZCIvld5GJozFgcdcX/JoE/V9hNuKyixazYymbDDOP
         rs3F89o4I9iPBcD3j3n8XMcwWhYVuurTAkf82xgTxgqr0HEdzl+TErrucXGzSFiBpEBN
         pTPmoSTEW8BxWY+ZXkbLt0RqM5/YMfcKMCaZnSgUuy0fw67FdIPxbvWf5hKSWKJe+GXw
         QAP6fCYentS5kraZcLvUwvbY1w9K+0vq5MUdZrW0i00VKDk7su45nItZxofP0CpOPzl4
         Mg4Q==
X-Gm-Message-State: AOAM533BjphHgypGwWjsy1v7rHga68ehudGf1UNy5UvDFYnUadQrhKju
        ueqRYWQ+gaOud6M7o6ko78ob3WPlSks=
X-Google-Smtp-Source: ABdhPJxZcyVG2df96ixqIX1kIkmwVLhgn6348GI/AvZhCpYW7lfXhUHvdZjaIKWk8Ch684jfwiQhDw==
X-Received: by 2002:a05:6a00:2351:b0:47b:d092:d2e4 with SMTP id j17-20020a056a00235100b0047bd092d2e4mr33514168pfj.76.1636996321315;
        Mon, 15 Nov 2021 09:12:01 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id j127sm16466632pfg.14.2021.11.15.09.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:12:01 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/4] net: drop nopreempt requirement on sock_prot_inuse_add()
Date:   Mon, 15 Nov 2021 09:11:50 -0800
Message-Id: <20211115171150.3646016-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115171150.3646016-1-eric.dumazet@gmail.com>
References: <20211115171150.3646016-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This is distracting really, let's make this simpler,
because many callers had to take care of this
by themselves, even if on x86 this adds more
code than really needed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h       | 4 ++--
 net/ieee802154/socket.c  | 4 ++--
 net/ipv4/raw.c           | 2 +-
 net/ipv6/ipv6_sockglue.c | 8 ++++----
 net/netlink/af_netlink.c | 4 ----
 net/packet/af_packet.c   | 4 ----
 net/sctp/socket.c        | 5 -----
 net/smc/af_smc.c         | 2 +-
 net/unix/af_unix.c       | 4 ----
 net/xdp/xsk.c            | 4 ----
 10 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index fefffeb1cc3d5a11615afbc34e5cd7521bd6f502..7e8330599f633c5029e15e9c5e859d183ae87127 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1424,11 +1424,11 @@ struct prot_inuse {
 	int all;
 	int val[PROTO_INUSE_NR];
 };
-/* Called with local bh disabled */
+
 static inline void sock_prot_inuse_add(const struct net *net,
 				       const struct proto *prot, int val)
 {
-	__this_cpu_add(net->core.prot_inuse->val[prot->inuse_idx], val);
+	this_cpu_add(net->core.prot_inuse->val[prot->inuse_idx], val);
 }
 
 static inline void sock_inuse_add(const struct net *net, int val)
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 7bb9ef35c57076252c700617dad4cc6cf275987a..3b2366a88c3ccbae787669c58a2827048aa4552c 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -174,8 +174,8 @@ static int raw_hash(struct sock *sk)
 {
 	write_lock_bh(&raw_lock);
 	sk_add_node(sk, &raw_head);
-	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 	write_unlock_bh(&raw_lock);
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
 	return 0;
 }
@@ -453,8 +453,8 @@ static int dgram_hash(struct sock *sk)
 {
 	write_lock_bh(&dgram_lock);
 	sk_add_node(sk, &dgram_head);
-	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 	write_unlock_bh(&dgram_lock);
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
 	return 0;
 }
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index bb446e60cf58057b448f094b4d6f48d6e91d113c..3910bb08a986f37984ad1a5eebca14c706deb315 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -99,8 +99,8 @@ int raw_hash_sk(struct sock *sk)
 
 	write_lock_bh(&h->lock);
 	sk_add_node(sk, head);
+	write_unlock_bh(&h->lock);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
-	write_unlock_bh(&h->lock);
 
 	return 0;
 }
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 41efca817db4228f265235a471449a3790075ce7..04683ad6d3df83bbe8ff6c10885b3bf16483688c 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -471,10 +471,10 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 
 			if (sk->sk_protocol == IPPROTO_TCP) {
 				struct inet_connection_sock *icsk = inet_csk(sk);
-				local_bh_disable();
+
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, &tcp_prot, 1);
-				local_bh_enable();
+
 				sk->sk_prot = &tcp_prot;
 				icsk->icsk_af_ops = &ipv4_specific;
 				sk->sk_socket->ops = &inet_stream_ops;
@@ -485,10 +485,10 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 
 				if (sk->sk_protocol == IPPROTO_UDPLITE)
 					prot = &udplite_prot;
-				local_bh_disable();
+
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, prot, 1);
-				local_bh_enable();
+
 				sk->sk_prot = prot;
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4c575324a98528bec4188acf27eecc2f98ae5e0a..1a19d179e913a3cf973aebab54af71b665345e0f 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -707,9 +707,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
 	if (err < 0)
 		goto out_module;
 
-	local_bh_disable();
 	sock_prot_inuse_add(net, &netlink_proto, 1);
-	local_bh_enable();
 
 	nlk = nlk_sk(sock->sk);
 	nlk->module = module;
@@ -809,9 +807,7 @@ static int netlink_release(struct socket *sock)
 		netlink_table_ungrab();
 	}
 
-	local_bh_disable();
 	sock_prot_inuse_add(sock_net(sk), &netlink_proto, -1);
-	local_bh_enable();
 	call_rcu(&nlk->rcu, deferred_put_nlk_sk);
 	return 0;
 }
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 46943a18a10d5413db57955dbd24302af7ef1d97..a1ffdb48cc474dcf91bddfd1ab96386a89c20375 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3102,9 +3102,7 @@ static int packet_release(struct socket *sock)
 	sk_del_node_init_rcu(sk);
 	mutex_unlock(&net->packet.sklist_lock);
 
-	preempt_disable();
 	sock_prot_inuse_add(net, sk->sk_prot, -1);
-	preempt_enable();
 
 	spin_lock(&po->bind_lock);
 	unregister_prot_hook(sk, false);
@@ -3368,9 +3366,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	sk_add_node_tail_rcu(sk, &net->packet.sklist);
 	mutex_unlock(&net->packet.sklist_lock);
 
-	preempt_disable();
 	sock_prot_inuse_add(net, &packet_proto, 1);
-	preempt_enable();
 
 	return 0;
 out2:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 33391254fa82b2277551387bfcdf95259bea7e0d..055a6d3ec6e2e90e31a21c4303e912168c8afe5b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5068,12 +5068,9 @@ static int sctp_init_sock(struct sock *sk)
 
 	SCTP_DBG_OBJCNT_INC(sock);
 
-	local_bh_disable();
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
-	local_bh_enable();
-
 	return 0;
 }
 
@@ -5099,10 +5096,8 @@ static void sctp_destroy_sock(struct sock *sk)
 		list_del(&sp->auto_asconf_list);
 	}
 	sctp_endpoint_free(sp->ep);
-	local_bh_disable();
 	sk_sockets_allocated_dec(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
-	local_bh_enable();
 }
 
 /* Triggered when there are no references on the socket anymore */
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 59284da9116d787b95704be7fda6d62e351e36aa..ff5cd0c30741c0b562e66ce49a60bbc8d260f3b5 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -89,8 +89,8 @@ int smc_hash_sk(struct sock *sk)
 
 	write_lock_bh(&h->lock);
 	sk_add_node(sk, head);
+	write_unlock_bh(&h->lock);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
-	write_unlock_bh(&h->lock);
 
 	return 0;
 }
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 78e08e82c08c423ff2112fcef9e27995a6d39984..54e5553a150ec58d07b61a15f4823bc0622a0b6e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -522,9 +522,7 @@ static void unix_sock_destructor(struct sock *sk)
 		unix_release_addr(u->addr);
 
 	atomic_long_dec(&unix_nr_socks);
-	local_bh_disable();
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
-	local_bh_enable();
 #ifdef UNIX_REFCNT_DEBUG
 	pr_debug("UNIX %p is destroyed, %ld are still alive.\n", sk,
 		atomic_long_read(&unix_nr_socks));
@@ -889,9 +887,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
 	unix_insert_socket(unix_sockets_unbound(sk), sk);
 
-	local_bh_disable();
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
-	local_bh_enable();
 
 	return sk;
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f16074eb53c72a7040421d23028d5762e0c5658d..28ef3f4465ae9e63bc5326311f923260b88f0fe8 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -794,9 +794,7 @@ static int xsk_release(struct socket *sock)
 	sk_del_node_init_rcu(sk);
 	mutex_unlock(&net->xdp.lock);
 
-	local_bh_disable();
 	sock_prot_inuse_add(net, sk->sk_prot, -1);
-	local_bh_enable();
 
 	xsk_delete_from_maps(xs);
 	mutex_lock(&xs->mutex);
@@ -1396,9 +1394,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	sk_add_node_rcu(sk, &net->xdp.list);
 	mutex_unlock(&net->xdp.lock);
 
-	local_bh_disable();
 	sock_prot_inuse_add(net, &xsk_proto, 1);
-	local_bh_enable();
 
 	return 0;
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog

