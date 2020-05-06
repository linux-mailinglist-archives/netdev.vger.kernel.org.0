Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AF71C711B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgEFM4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728727AbgEFMzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:31 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B341C03C1AA
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:29 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id w7so1238865wre.13
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PJC838rCblZYwK9d/soNBjN4ZElrFcTAEZBfSJoBG5Y=;
        b=n5kqBlX4XdjP0WhEldhKATjgpFh/7LPT3eGQvcaNAH5U38S8PzK4KW/JluUt3myJOt
         rxBUE+92dUQvPHMBvFbTjE8UpGN0zhhL3R6uoIuNoje+U69L4hdrgt/BUDxqzO/GZjgf
         7fHQtmYn0I2Y/15eI3XkVFsqa0+52UMm3AaDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PJC838rCblZYwK9d/soNBjN4ZElrFcTAEZBfSJoBG5Y=;
        b=GHRktTVFtGSdYRBVn7WvEjrKQypsmP1X/hIRCozTr3cDL61SeP/BvL56bDAp71GM3s
         bYGnaKxhbMBUsYR0VM+EmjiUgYv4h1mUmRnzPd3XsxfxGugiF1FuzbxLmvw1vV/EJO3u
         sfErTT/kslwvfddHzbTEi72u7YotXF/hp2zCGbQloHDCxQmwgL0OXWXxNcunu0wurFfY
         vRFr6BfSuuD/rqnuOu4hDPWZlzT8QSVba19rklQPVu1b04WWLZCudshKbhmTglZVjU20
         G8vHqkFToCPEnp33ul5m/vtyGg+Rfcg9iAfxBPaO4V+AXF58CteY0y0wwrYebvC4L1gL
         WVHw==
X-Gm-Message-State: AGi0PuYgZqNYi4zBTzhJ+GH8REOW6YnitbZaYagdWw9WeavnHTD5E+JK
        dE1BxGseTXR6dYvqkfnrzlOzfKtTaeY=
X-Google-Smtp-Source: APiQypJ9MvbDtoSoM42nUMazGfzpLcuz8d7O3ORFvH2mwkbX/fjHxR8lg2unyim+/rAhPfpAMfq3JQ==
X-Received: by 2002:adf:c651:: with SMTP id u17mr9755070wrg.416.1588769727900;
        Wed, 06 May 2020 05:55:27 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id w83sm3061616wmb.37.2020.05.06.05.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:27 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 08/17] udp: Store layer 4 protocol in udp_table
Date:   Wed,  6 May 2020 14:55:04 +0200
Message-Id: <20200506125514.1020829-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because UDP and UDP-Lite share code, we pass the L4 protocol identifier
alongside the UDP socket table to functions which need to distinguishing
between the two protocol.

Put the protocol identifier in the UDP table itself, so that the protocol
is known to any function in the call chain that operates on socket table.

Subsequent patches make use the new udp_table field at the socket lookup
time to ensure that BPF program selects only sockets with matching
protocol.

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/udp.h   | 10 ++++++----
 net/ipv4/udp.c      | 15 +++++++--------
 net/ipv4/udp_impl.h |  2 +-
 net/ipv4/udplite.c  |  4 ++--
 net/ipv6/udp.c      | 12 ++++++------
 net/ipv6/udp_impl.h |  2 +-
 net/ipv6/udplite.c  |  2 +-
 7 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index a8fa6c0c6ded..f81c46c71fee 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -63,16 +63,18 @@ struct udp_hslot {
 /**
  *	struct udp_table - UDP table
  *
- *	@hash:	hash table, sockets are hashed on (local port)
- *	@hash2:	hash table, sockets are hashed on (local port, local address)
- *	@mask:	number of slots in hash tables, minus 1
- *	@log:	log2(number of slots in hash table)
+ *	@hash:		hash table, sockets are hashed on (local port)
+ *	@hash2:		hash table, sockets are hashed on local (port, address)
+ *	@mask:		number of slots in hash tables, minus 1
+ *	@log:		log2(number of slots in hash table)
+ *	@protocol:	layer 4 protocol of the stored sockets
  */
 struct udp_table {
 	struct udp_hslot	*hash;
 	struct udp_hslot	*hash2;
 	unsigned int		mask;
 	unsigned int		log;
+	int			protocol;
 };
 extern struct udp_table udp_table;
 void udp_table_init(struct udp_table *, const char *);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 32564b350823..ce96b1746ddf 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -113,7 +113,7 @@
 #include <net/addrconf.h>
 #include <net/udp_tunnel.h>
 
-struct udp_table udp_table __read_mostly;
+struct udp_table udp_table __read_mostly = { .protocol = IPPROTO_UDP };
 EXPORT_SYMBOL(udp_table);
 
 long sysctl_udp_mem[3] __read_mostly;
@@ -2145,8 +2145,7 @@ EXPORT_SYMBOL(udp_sk_rx_dst_set);
 static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 				    struct udphdr  *uh,
 				    __be32 saddr, __be32 daddr,
-				    struct udp_table *udptable,
-				    int proto)
+				    struct udp_table *udptable)
 {
 	struct sock *sk, *first = NULL;
 	unsigned short hnum = ntohs(uh->dest);
@@ -2202,7 +2201,7 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 	} else {
 		kfree_skb(skb);
 		__UDP_INC_STATS(net, UDP_MIB_IGNOREDMULTI,
-				proto == IPPROTO_UDPLITE);
+				udptable->protocol == IPPROTO_UDPLITE);
 	}
 	return 0;
 }
@@ -2279,8 +2278,7 @@ static int udp_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
  *	All we need to do is get the socket, and then do a checksum.
  */
 
-int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
-		   int proto)
+int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
 {
 	struct sock *sk;
 	struct udphdr *uh;
@@ -2288,6 +2286,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	struct rtable *rt = skb_rtable(skb);
 	__be32 saddr, daddr;
 	struct net *net = dev_net(skb->dev);
+	int proto = udptable->protocol;
 	bool refcounted;
 
 	/*
@@ -2330,7 +2329,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (rt->rt_flags & (RTCF_BROADCAST|RTCF_MULTICAST))
 		return __udp4_lib_mcast_deliver(net, skb, uh,
-						saddr, daddr, udptable, proto);
+						saddr, daddr, udptable);
 
 	sk = __udp4_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
 	if (sk)
@@ -2504,7 +2503,7 @@ int udp_v4_early_demux(struct sk_buff *skb)
 
 int udp_rcv(struct sk_buff *skb)
 {
-	return __udp4_lib_rcv(skb, &udp_table, IPPROTO_UDP);
+	return __udp4_lib_rcv(skb, &udp_table);
 }
 
 void udp_destroy_sock(struct sock *sk)
diff --git a/net/ipv4/udp_impl.h b/net/ipv4/udp_impl.h
index 6b2fa77eeb1c..7013535f9084 100644
--- a/net/ipv4/udp_impl.h
+++ b/net/ipv4/udp_impl.h
@@ -6,7 +6,7 @@
 #include <net/protocol.h>
 #include <net/inet_common.h>
 
-int __udp4_lib_rcv(struct sk_buff *, struct udp_table *, int);
+int __udp4_lib_rcv(struct sk_buff *, struct udp_table *);
 int __udp4_lib_err(struct sk_buff *, u32, struct udp_table *);
 
 int udp_v4_get_port(struct sock *sk, unsigned short snum);
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 5936d66d1ce2..4e4e85de95b2 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -14,12 +14,12 @@
 #include <linux/proc_fs.h>
 #include "udp_impl.h"
 
-struct udp_table 	udplite_table __read_mostly;
+struct udp_table udplite_table __read_mostly = { .protocol = IPPROTO_UDPLITE };
 EXPORT_SYMBOL(udplite_table);
 
 static int udplite_rcv(struct sk_buff *skb)
 {
-	return __udp4_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
+	return __udp4_lib_rcv(skb, &udplite_table);
 }
 
 static int udplite_err(struct sk_buff *skb, u32 info)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7d4151747340..f7866fded418 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -741,7 +741,7 @@ static void udp6_csum_zero_error(struct sk_buff *skb)
  */
 static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 		const struct in6_addr *saddr, const struct in6_addr *daddr,
-		struct udp_table *udptable, int proto)
+		struct udp_table *udptable)
 {
 	struct sock *sk, *first = NULL;
 	const struct udphdr *uh = udp_hdr(skb);
@@ -803,7 +803,7 @@ static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 	} else {
 		kfree_skb(skb);
 		__UDP6_INC_STATS(net, UDP_MIB_IGNOREDMULTI,
-				 proto == IPPROTO_UDPLITE);
+				 udptable->protocol == IPPROTO_UDPLITE);
 	}
 	return 0;
 }
@@ -836,11 +836,11 @@ static int udp6_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 	return 0;
 }
 
-int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
-		   int proto)
+int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
 {
 	const struct in6_addr *saddr, *daddr;
 	struct net *net = dev_net(skb->dev);
+	int proto = udptable->protocol;
 	struct udphdr *uh;
 	struct sock *sk;
 	bool refcounted;
@@ -905,7 +905,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 */
 	if (ipv6_addr_is_multicast(daddr))
 		return __udp6_lib_mcast_deliver(net, skb,
-				saddr, daddr, udptable, proto);
+				saddr, daddr, udptable);
 
 	/* Unicast */
 	sk = __udp6_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
@@ -1014,7 +1014,7 @@ INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
 
 INDIRECT_CALLABLE_SCOPE int udpv6_rcv(struct sk_buff *skb)
 {
-	return __udp6_lib_rcv(skb, &udp_table, IPPROTO_UDP);
+	return __udp6_lib_rcv(skb, &udp_table);
 }
 
 /*
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index 20e324b6f358..acd5a942c633 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -8,7 +8,7 @@
 #include <net/inet_common.h>
 #include <net/transp_v6.h>
 
-int __udp6_lib_rcv(struct sk_buff *, struct udp_table *, int);
+int __udp6_lib_rcv(struct sk_buff *, struct udp_table *);
 int __udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *, u8, u8, int,
 		   __be32, struct udp_table *);
 
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index bf7a7acd39b1..f442ed595e6f 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -14,7 +14,7 @@
 
 static int udplitev6_rcv(struct sk_buff *skb)
 {
-	return __udp6_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
+	return __udp6_lib_rcv(skb, &udplite_table);
 }
 
 static int udplitev6_err(struct sk_buff *skb,
-- 
2.25.3

