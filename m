Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD793D035E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbhGTUJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:09:16 -0400
Received: from novek.ru ([213.148.174.62]:46646 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237724AbhGTTzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 15:55:04 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 890AA503E20;
        Tue, 20 Jul 2021 23:33:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 890AA503E20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626813198; bh=qIiL4BSdIjWhXA+pGqaRepkMkOG/a8SJoCRGajT++2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQjQtcTZ1Bf4MROeZsQFJ5GlkcDXSDs7xtLuHjtifXbvNeX8HOAaR/jJ49heNkAO4
         /qoOir4f3EdpMEOuZO7X4WDBcsxCAoao4zLA8mszPWTLefmBl1tSOhn9ISrKyVORky
         +Z/YfdMcpHeRAfUOQ+vAajof+76P7c9m4W6+RZgE=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net v3 1/2] udp: check encap socket in __udp_lib_err
Date:   Tue, 20 Jul 2021 23:35:28 +0300
Message-Id: <20210720203529.21601-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210720203529.21601-1-vfedorenko@novek.ru>
References: <20210720203529.21601-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
added checks for encapsulated sockets but it broke cases when there is
no implementation of encap_err_lookup for encapsulation, i.e. ESP in
UDP encapsulation. Fix it by calling encap_err_lookup only if socket
implements this method otherwise treat it as legal socket.

Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv4/udp.c | 25 +++++++++++++++++++------
 net/ipv6/udp.c | 25 +++++++++++++++++++------
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 62cd4cd52e84..1a742b710e54 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -645,10 +645,12 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
 					 const struct iphdr *iph,
 					 struct udphdr *uh,
 					 struct udp_table *udptable,
+					 struct sock *sk,
 					 struct sk_buff *skb, u32 info)
 {
+	int (*lookup)(struct sock *sk, struct sk_buff *skb);
 	int network_offset, transport_offset;
-	struct sock *sk;
+	struct udp_sock *up;
 
 	network_offset = skb_network_offset(skb);
 	transport_offset = skb_transport_offset(skb);
@@ -659,18 +661,28 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
 	/* Transport header needs to point to the UDP header */
 	skb_set_transport_header(skb, iph->ihl << 2);
 
+	if (sk) {
+		up = udp_sk(sk);
+
+		lookup = READ_ONCE(up->encap_err_lookup);
+		if (lookup && lookup(sk, skb))
+			sk = NULL;
+
+		goto out;
+	}
+
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->source,
 			       iph->saddr, uh->dest, skb->dev->ifindex, 0,
 			       udptable, NULL);
 	if (sk) {
-		int (*lookup)(struct sock *sk, struct sk_buff *skb);
-		struct udp_sock *up = udp_sk(sk);
+		up = udp_sk(sk);
 
 		lookup = READ_ONCE(up->encap_err_lookup);
 		if (!lookup || lookup(sk, skb))
 			sk = NULL;
 	}
 
+out:
 	if (!sk)
 		sk = ERR_PTR(__udp4_lib_err_encap_no_sk(skb, info));
 
@@ -707,15 +719,16 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
 			       inet_sdif(skb), udptable, NULL);
+
 	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
-		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
-			sk = __udp4_lib_err_encap(net, iph, uh, udptable, skb,
+			sk = __udp4_lib_err_encap(net, iph, uh, udptable, sk, skb,
 						  info);
 			if (!sk)
 				return 0;
-		}
+		} else
+			sk = ERR_PTR(-ENOENT);
 
 		if (IS_ERR(sk)) {
 			__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 0cc7ba531b34..c5e15e94bb00 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -502,12 +502,14 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 					 const struct ipv6hdr *hdr, int offset,
 					 struct udphdr *uh,
 					 struct udp_table *udptable,
+					 struct sock *sk,
 					 struct sk_buff *skb,
 					 struct inet6_skb_parm *opt,
 					 u8 type, u8 code, __be32 info)
 {
+	int (*lookup)(struct sock *sk, struct sk_buff *skb);
 	int network_offset, transport_offset;
-	struct sock *sk;
+	struct udp_sock *up;
 
 	network_offset = skb_network_offset(skb);
 	transport_offset = skb_transport_offset(skb);
@@ -518,18 +520,28 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 	/* Transport header needs to point to the UDP header */
 	skb_set_transport_header(skb, offset);
 
+	if (sk) {
+		up = udp_sk(sk);
+
+		lookup = READ_ONCE(up->encap_err_lookup);
+		if (lookup && lookup(sk, skb))
+			sk = NULL;
+
+		goto out;
+	}
+
 	sk = __udp6_lib_lookup(net, &hdr->daddr, uh->source,
 			       &hdr->saddr, uh->dest,
 			       inet6_iif(skb), 0, udptable, skb);
 	if (sk) {
-		int (*lookup)(struct sock *sk, struct sk_buff *skb);
-		struct udp_sock *up = udp_sk(sk);
+		up = udp_sk(sk);
 
 		lookup = READ_ONCE(up->encap_err_lookup);
 		if (!lookup || lookup(sk, skb))
 			sk = NULL;
 	}
 
+out:
 	if (!sk) {
 		sk = ERR_PTR(__udp6_lib_err_encap_no_sk(skb, opt, type, code,
 							offset, info));
@@ -558,16 +570,17 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
+
 	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
-		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udpv6_encap_needed_key)) {
 			sk = __udp6_lib_err_encap(net, hdr, offset, uh,
-						  udptable, skb,
+						  udptable, sk, skb,
 						  opt, type, code, info);
 			if (!sk)
 				return 0;
-		}
+		} else
+			sk = ERR_PTR(-ENOENT);
 
 		if (IS_ERR(sk)) {
 			__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev),
-- 
2.18.4

