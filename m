Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09A83C40A8
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhGLA6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:58:53 -0400
Received: from novek.ru ([213.148.174.62]:38574 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhGLA6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 20:58:52 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2D0D650392E;
        Mon, 12 Jul 2021 03:53:48 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2D0D650392E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626051230; bh=lbFVjwkYaMkWn6cTScKg6aRQg2X0vIMhn+NbJrY09ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sykQFRfKRF6wZNLlhh477umbYhwRBYyAq/Fy9KqI1MRdUjK08XcWeqpVOUG+Y59CF
         VmehMdQamxaBqz218GUI1HBJpEX3KxSheDY4YrqnUhm5q6aXvQu6luFo+7XbgAj9Ec
         cWAKT2aGYA584G3W7S+lQf7Hmjtd9Z4tkDmC+ns4=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net 1/3] udp: check for encap using encap_enable
Date:   Mon, 12 Jul 2021 03:55:52 +0300
Message-Id: <20210712005554.26948-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210712005554.26948-1-vfedorenko@novek.ru>
References: <20210712005554.26948-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usage of encap_type as a flag to determine encapsulation of udp
socket is not correct because there is special encap_enable field
for this check. Many network drivers use this field as a flag
instead of correctly indicate type of encapsulation. Remove such
usage and update all checks to use encap_enable field

Fixes: 60fb9567bf30 ("udp: implement complete book-keeping for encap_needed")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 1 -
 drivers/net/bareudp.c               | 1 -
 drivers/net/geneve.c                | 1 -
 drivers/net/vxlan.c                 | 1 -
 drivers/net/wireguard/socket.c      | 1 -
 net/ipv4/fou.c                      | 1 -
 net/ipv4/udp.c                      | 9 ++++-----
 net/ipv6/udp.c                      | 8 +++-----
 net/sctp/protocol.c                 | 2 --
 net/tipc/udp_media.c                | 1 -
 10 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 01662727dca0..f6515208e5af 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -212,7 +212,6 @@ static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
 		return ERR_PTR(err);
 	}
 
-	tnl_cfg.encap_type = 1;
 	tnl_cfg.encap_rcv = rxe_udp_encap_recv;
 
 	/* Setup UDP tunnel */
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index a7ee0af1af90..4c84b327bba0 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -236,7 +236,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
 	/* Mark socket as an encapsulation socket */
 	memset(&tunnel_cfg, 0, sizeof(tunnel_cfg));
 	tunnel_cfg.sk_user_data = bareudp;
-	tunnel_cfg.encap_type = 1;
 	tunnel_cfg.encap_rcv = bareudp_udp_encap_recv;
 	tunnel_cfg.encap_err_lookup = bareudp_err_lookup;
 	tunnel_cfg.encap_destroy = NULL;
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 1ab94b5f9bbf..953a9306af98 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -590,7 +590,6 @@ static struct geneve_sock *geneve_socket_create(struct net *net, __be16 port,
 	/* Mark socket as an encapsulation socket */
 	memset(&tunnel_cfg, 0, sizeof(tunnel_cfg));
 	tunnel_cfg.sk_user_data = gs;
-	tunnel_cfg.encap_type = 1;
 	tunnel_cfg.gro_receive = geneve_gro_receive;
 	tunnel_cfg.gro_complete = geneve_gro_complete;
 	tunnel_cfg.encap_rcv = geneve_udp_encap_recv;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5a8df5a195cb..4eba44b1120e 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3539,7 +3539,6 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, bool ipv6,
 	/* Mark socket as an encapsulation socket. */
 	memset(&tunnel_cfg, 0, sizeof(tunnel_cfg));
 	tunnel_cfg.sk_user_data = vs;
-	tunnel_cfg.encap_type = 1;
 	tunnel_cfg.encap_rcv = vxlan_rcv;
 	tunnel_cfg.encap_err_lookup = vxlan_err_lookup;
 	tunnel_cfg.encap_destroy = NULL;
diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index 8c496b747108..81669dd0e6cd 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -351,7 +351,6 @@ int wg_socket_init(struct wg_device *wg, u16 port)
 	int ret;
 	struct udp_tunnel_sock_cfg cfg = {
 		.sk_user_data = wg,
-		.encap_type = 1,
 		.encap_rcv = wg_receive
 	};
 	struct socket *new4 = NULL, *new6 = NULL;
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index e5f69b0bf3df..b80f56594e0a 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -590,7 +590,6 @@ static int fou_create(struct net *net, struct fou_cfg *cfg,
 	fou->sock = sock;
 
 	memset(&tunnel_cfg, 0, sizeof(tunnel_cfg));
-	tunnel_cfg.encap_type = 1;
 	tunnel_cfg.sk_user_data = fou;
 	tunnel_cfg.encap_destroy = NULL;
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 62cd4cd52e84..e5cb7fedfbcd 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -707,7 +707,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
 			       inet_sdif(skb), udptable, NULL);
-	if (!sk || udp_sk(sk)->encap_type) {
+	if (!sk || udp_sk(sk)->encap_enabled) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
@@ -2105,7 +2105,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 	nf_reset_ct(skb);
 
-	if (static_branch_unlikely(&udp_encap_needed_key) && up->encap_type) {
+	if (static_branch_unlikely(&udp_encap_needed_key) && up->encap_enabled) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
 
 		/*
@@ -2615,14 +2615,13 @@ void udp_destroy_sock(struct sock *sk)
 	udp_flush_pending_frames(sk);
 	unlock_sock_fast(sk, slow);
 	if (static_branch_unlikely(&udp_encap_needed_key)) {
-		if (up->encap_type) {
+		if (up->encap_enabled) {
 			void (*encap_destroy)(struct sock *sk);
 			encap_destroy = READ_ONCE(up->encap_destroy);
 			if (encap_destroy)
 				encap_destroy(sk);
-		}
-		if (up->encap_enabled)
 			static_branch_dec(&udp_encap_needed_key);
+		}
 	}
 }
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 0cc7ba531b34..798916d2e722 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -558,7 +558,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
-	if (!sk || udp_sk(sk)->encap_type) {
+	if (!sk || udp_sk(sk)->encap_enabled) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udpv6_encap_needed_key)) {
@@ -661,7 +661,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto drop;
 
-	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_type) {
+	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_enabled) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
 
 		/*
@@ -1605,13 +1605,11 @@ void udpv6_destroy_sock(struct sock *sk)
 	release_sock(sk);
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key)) {
-		if (up->encap_type) {
+		if (up->encap_enabled) {
 			void (*encap_destroy)(struct sock *sk);
 			encap_destroy = READ_ONCE(up->encap_destroy);
 			if (encap_destroy)
 				encap_destroy(sk);
-		}
-		if (up->encap_enabled) {
 			static_branch_dec(&udpv6_encap_needed_key);
 			udp_encap_disable();
 		}
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index ec0f52567c16..2eccb3f9122b 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -872,7 +872,6 @@ int sctp_udp_sock_start(struct net *net)
 		return err;
 	}
 
-	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
 	tuncfg.encap_err_lookup = sctp_udp_v4_err;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
@@ -894,7 +893,6 @@ int sctp_udp_sock_start(struct net *net)
 		return err;
 	}
 
-	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
 	tuncfg.encap_err_lookup = sctp_udp_v6_err;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index c2bb818704c8..da0c679dae37 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -771,7 +771,6 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 	if (err)
 		goto err;
 	tuncfg.sk_user_data = ub;
-	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = tipc_udp_recv;
 	tuncfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(net, ub->ubsock, &tuncfg);
-- 
2.18.4

