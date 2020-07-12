Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A5621CB42
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 22:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgGLUH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 16:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgGLUH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 16:07:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B96C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 13:07:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1juiFx-0002dC-2J; Sun, 12 Jul 2020 22:07:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     aconole@redhat.com, sbrivio@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu discovery on encap sockets
Date:   Sun, 12 Jul 2020 22:07:03 +0200
Message-Id: <20200712200705.9796-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200712200705.9796-1-fw@strlen.de>
References: <20200712200705.9796-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan and geneve take the to-be-transmitted skb, prepend the
encapsulation header and send the result.

Neither vxlan nor geneve can do anything about a lowered path mtu
except notifying the peer/upper dst entry.
In routed setups, vxlan takes the updated pmtu from the encap sockets'
dst entry and will notify/update the dst entry of the current skb.

Some setups, however, will use vxlan as a bridge port (or openvs vport).

In both cases, no upper dst entry exists.

Without this patch:

1. Client sends x bytes, where x == MTU of vxlan/geneve interface.
2. the encap header is prepended and the encap packet is passed to
   ip_output.
3. If the sk received a pmtu error in the mean time, then ip_output
   will fetch the mtu from the encap socket instead of dev->mtu.
4. ip_output emits an ICMP error to encap socket

The step #4 prevents the route exception from timing out, and setup
remains in a state where the upper layer cannot send MTU-sized packets,
even though the encapsulated packet doesn't exceed the link MTU.

It appears best to configure the encap socket to never learn about path
MTU in these setups.

Next patch will add the VXLAN config plane to use this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/ipv6.h         | 7 +++++++
 include/net/udp_tunnel.h   | 2 ++
 net/ipv4/udp_tunnel_core.c | 2 ++
 net/ipv6/ip6_udp_tunnel.c  | 7 +++++++
 4 files changed, 18 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 5e65bf2fd32d..fa8e546546e3 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1195,6 +1195,13 @@ static inline void ip6_sock_set_recverr(struct sock *sk)
 	release_sock(sk);
 }
 
+static inline void ip6_sock_set_mtu_discover(struct sock *sk, int val)
+{
+	lock_sock(sk);
+	inet6_sk(sk)->pmtudisc = val;
+	release_sock(sk);
+}
+
 static inline int __ip6_sock_set_addr_preferences(struct sock *sk, int val)
 {
 	unsigned int pref = 0;
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index dd20ce99740c..f02be73bdae1 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -34,6 +34,8 @@ struct udp_port_cfg {
 	unsigned int		use_udp_checksums:1,
 				use_udp6_tx_checksums:1,
 				use_udp6_rx_checksums:1,
+				ip_pmtudisc:1,
+				ip_pmtudiscv:3,
 				ipv6_v6only:1;
 };
 
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 3eecba0874aa..1d20bd5b72ac 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -26,6 +26,8 @@ int udp_sock_create4(struct net *net, struct udp_port_cfg *cfg,
 		if (err < 0)
 			goto error;
 	}
+	if (cfg->ip_pmtudisc)
+		ip_sock_set_mtu_discover(sock->sk, cfg->ip_pmtudiscv);
 
 	udp_addr.sin_family = AF_INET;
 	udp_addr.sin_addr = cfg->local_ip;
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index cdc4d4ee2420..63c22252a76f 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -34,6 +34,13 @@ int udp_sock_create6(struct net *net, struct udp_port_cfg *cfg,
 		if (err < 0)
 			goto error;
 	}
+	if (cfg->ip_pmtudisc) {
+		BUILD_BUG_ON(IP_PMTUDISC_DONT != IPV6_PMTUDISC_DONT);
+		BUILD_BUG_ON(IP_PMTUDISC_OMIT != IPV6_PMTUDISC_OMIT);
+
+		ip_sock_set_mtu_discover(sock->sk, cfg->ip_pmtudiscv);
+		ip6_sock_set_mtu_discover(sock->sk, cfg->ip_pmtudiscv);
+	}
 
 	udp6_addr.sin6_family = AF_INET6;
 	memcpy(&udp6_addr.sin6_addr, &cfg->local_ip6,
-- 
2.26.2

