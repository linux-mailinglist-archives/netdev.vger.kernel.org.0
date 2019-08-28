Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 482E99FB82
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfH1HXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:23:08 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:42515 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfH1HXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:23:04 -0400
Received: by mail-lj1-f172.google.com with SMTP id l14so1586118ljj.9
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xsPtJmsxYP/q+K+pQ7bUfVJa1MUAKbGniE3ipGc6mgk=;
        b=l+WnAGE1hfSY+7fRBLzVDFED63gfkGM5sfb0V9ZpawuqStb9bEMFdsvofGcQVBB2RH
         IK6t4XIlAHBfU8A3mn3SSss4AU707yxIpCozPae3Z/en3n5YzUvT1QC9TyKtLCkkT2Wi
         zNrggEksDfUXOksPmwxBPqolbV6w+nxXXleME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xsPtJmsxYP/q+K+pQ7bUfVJa1MUAKbGniE3ipGc6mgk=;
        b=jCbDtzqP1HA2F/K0gi/dq8yBc4b8OaOeGtfPRnn64cf30sziuS/2Yc588j9trbEQQh
         kAwluoW+R2BZYGDMDEVP7nvWTWbgQiNVEwaUVf651KMr7FYImBjc1dMEEL24+vj8h576
         CV6+BzGwMqiybUxqAygi2d3WowWChGSkHppTaZfBbvHdQeinr9RvmFS8obqCB2peXvzQ
         3dD61FzH/AsbgaOTsUZV+tJTlxcVJVemqVF0XLfoJMIXMXXgwWrVn1E2hPybYwcOEKYm
         QL6lEbDqWGZbqqiW9alY6vq9hR+c+nH0wWhDJqSVOVmqsuYnKn+CCbKmZAfWWdH62l+c
         iOQw==
X-Gm-Message-State: APjAAAVmToTwkSW1PAygaxKqktg0+Djel5Ud6QSdbDAw6kZzEAg2Tf0B
        /dPB1uATDUMuJd23poZSe2REpg==
X-Google-Smtp-Source: APXvYqxpN1OB5c5SGEUPvORJyLtQ4ib2MNukaCmr+HD+aTeoEcNF8KWfj7l2B0CrKw5AwetnUmygtw==
X-Received: by 2002:a2e:9b47:: with SMTP id o7mr1240756ljj.35.1566976981476;
        Wed, 28 Aug 2019 00:23:01 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t3sm571937lfd.92.2019.08.28.00.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:23:01 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFCv2 bpf-next 05/12] udp: Store layer 4 protocol in udp_table
Date:   Wed, 28 Aug 2019 09:22:43 +0200
Message-Id: <20190828072250.29828-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828072250.29828-1-jakub@cloudflare.com>
References: <20190828072250.29828-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because UDP and UDP-Lite share code we have to pass the L4 protocol
identifier alongside the socket table to down call sites where
distinguishing between the two is needed.

There is currently only one such call site, which by itself is not reason
enough for the change.

However, subsequent patches will also make use the new udp_table field
inside the socket lookup routine to enforce that the BPF program selects
only sockets with matching protocol.

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
index 79d141d2103b..97778976c5ec 100644
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
+ *	@hash2:		hash table, sockets are hashed on (local port, local address)
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
index d88821c794fb..9fffe9e9eec6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -113,7 +113,7 @@
 #include <net/addrconf.h>
 #include <net/udp_tunnel.h>
 
-struct udp_table udp_table __read_mostly;
+struct udp_table udp_table __read_mostly = { .protocol = IPPROTO_UDP };
 EXPORT_SYMBOL(udp_table);
 
 long sysctl_udp_mem[3] __read_mostly;
@@ -2106,8 +2106,7 @@ EXPORT_SYMBOL(udp_sk_rx_dst_set);
 static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 				    struct udphdr  *uh,
 				    __be32 saddr, __be32 daddr,
-				    struct udp_table *udptable,
-				    int proto)
+				    struct udp_table *udptable)
 {
 	struct sock *sk, *first = NULL;
 	unsigned short hnum = ntohs(uh->dest);
@@ -2163,7 +2162,7 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 	} else {
 		kfree_skb(skb);
 		__UDP_INC_STATS(net, UDP_MIB_IGNOREDMULTI,
-				proto == IPPROTO_UDPLITE);
+				udptable->protocol == IPPROTO_UDPLITE);
 	}
 	return 0;
 }
@@ -2240,8 +2239,7 @@ static int udp_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
  *	All we need to do is get the socket, and then do a checksum.
  */
 
-int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
-		   int proto)
+int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
 {
 	struct sock *sk;
 	struct udphdr *uh;
@@ -2249,6 +2247,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	struct rtable *rt = skb_rtable(skb);
 	__be32 saddr, daddr;
 	struct net *net = dev_net(skb->dev);
+	int proto = udptable->protocol;
 
 	/*
 	 *  Validate the packet.
@@ -2289,7 +2288,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (rt->rt_flags & (RTCF_BROADCAST|RTCF_MULTICAST))
 		return __udp4_lib_mcast_deliver(net, skb, uh,
-						saddr, daddr, udptable, proto);
+						saddr, daddr, udptable);
 
 	sk = __udp4_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
 	if (sk)
@@ -2463,7 +2462,7 @@ int udp_v4_early_demux(struct sk_buff *skb)
 
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
index 827fe7385078..16ef2303bd8d 100644
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
 	u32 ulen = 0;
@@ -902,7 +902,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 */
 	if (ipv6_addr_is_multicast(daddr))
 		return __udp6_lib_mcast_deliver(net, skb,
-				saddr, daddr, udptable, proto);
+				saddr, daddr, udptable);
 
 	/* Unicast */
 	sk = __udp6_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
@@ -1011,7 +1011,7 @@ INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
 
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
2.20.1

