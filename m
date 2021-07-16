Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35933CB66D
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 12:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbhGPK5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 06:57:24 -0400
Received: from novek.ru ([213.148.174.62]:42390 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232654AbhGPK5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 06:57:22 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 98603503DDE;
        Fri, 16 Jul 2021 13:52:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 98603503DDE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626432728; bh=N2A+NuuKqfzsNMwRHYBzXPzMiYTSgwXZIBVLobDKeuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVtwovm5lUWDg+sg1Mr+ruA1KY+0enoSOT981KB8dAKOCCsKGgMtpRFaheGKg9p1Q
         Te2dIAsGBGENN9qtF5O5us7XXaMkG9sM4YUoxlEAicVi4aI70mZ2akU4f87K3QngPp
         Gqsj+8rocED6P6oKs5MiQxNzKSujPOaCfyoonrkc=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net v2 1/2] udp: check encap socket in __udp_lib_err_encap
Date:   Fri, 16 Jul 2021 13:54:16 +0300
Message-Id: <20210716105417.7938-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210716105417.7938-1-vfedorenko@novek.ru>
References: <20210716105417.7938-1-vfedorenko@novek.ru>
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
 net/ipv4/udp.c | 23 +++++++++++++++++------
 net/ipv6/udp.c | 23 +++++++++++++++++------
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 62cd4cd52e84..963275b94f00 100644
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
@@ -659,12 +661,19 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
 	/* Transport header needs to point to the UDP header */
 	skb_set_transport_header(skb, iph->ihl << 2);
 
+	if (sk) {
+		up = udp_sk(sk);
+
+		lookup = READ_ONCE(up->encap_err_lookup);
+		if (!lookup || !lookup(sk, skb))
+			goto out;
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
@@ -674,6 +683,7 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
 	if (!sk)
 		sk = ERR_PTR(__udp4_lib_err_encap_no_sk(skb, info));
 
+out:
 	skb_set_transport_header(skb, transport_offset);
 	skb_set_network_header(skb, network_offset);
 
@@ -707,15 +717,16 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
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
index 0cc7ba531b34..0210ec93d21d 100644
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
@@ -518,12 +520,19 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 	/* Transport header needs to point to the UDP header */
 	skb_set_transport_header(skb, offset);
 
+	if (sk) {
+		up = udp_sk(sk);
+
+		lookup = READ_ONCE(up->encap_err_lookup);
+		if (!lookup || !lookup(sk, skb))
+			goto out;
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
@@ -535,6 +544,7 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 							offset, info));
 	}
 
+out:
 	skb_set_transport_header(skb, transport_offset);
 	skb_set_network_header(skb, network_offset);
 
@@ -558,16 +568,17 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
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

