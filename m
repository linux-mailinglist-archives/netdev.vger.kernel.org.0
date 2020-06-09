Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805FA1F2CC3
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbgFIA1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbgFHXQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D24CF20774;
        Mon,  8 Jun 2020 23:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658194;
        bh=u5NxD93tNMR+Uf0sSapJqUPBUUPQUR3kyYU+THAHAO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbuQ5ubnJBlBxuIZJBs0IL5MUpZgYev3wAiGP8wO56JxoWY0TzV19ZN1oetKjTW9C
         eVSbQC/A/XN/cdypiqpvkVYH5B1VlNx038xh1VfkjIFlgeWBDvNoRr895bdj3ojrOv
         7nRkFHmxDKdJ7RTKNVtZFY3uFStXCjX88GG7y75w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Josef Bacik <jbacik@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 215/606] net: inet_csk: Fix so_reuseport bind-address cache in tb->fast*
Date:   Mon,  8 Jun 2020 19:05:40 -0400
Message-Id: <20200608231211.3363633-215-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 88d7fcfa3b1fe670f0412b95be785aafca63352b ]

The commit 637bc8bbe6c0 ("inet: reset tb->fastreuseport when adding a reuseport sk")
added a bind-address cache in tb->fast*.  The tb->fast* caches the address
of a sk which has successfully been binded with SO_REUSEPORT ON.  The idea
is to avoid the expensive conflict search in inet_csk_bind_conflict().

There is an issue with wildcard matching where sk_reuseport_match() should
have returned false but it is currently returning true.  It ends up
hiding bind conflict.  For example,

bind("[::1]:443"); /* without SO_REUSEPORT. Succeed. */
bind("[::2]:443"); /* with    SO_REUSEPORT. Succeed. */
bind("[::]:443");  /* with    SO_REUSEPORT. Still Succeed where it shouldn't */

The last bind("[::]:443") with SO_REUSEPORT on should have failed because
it should have a conflict with the very first bind("[::1]:443") which
has SO_REUSEPORT off.  However, the address "[::2]" is cached in
tb->fast* in the second bind. In the last bind, the sk_reuseport_match()
returns true because the binding sk's wildcard addr "[::]" matches with
the "[::2]" cached in tb->fast*.

The correct bind conflict is reported by removing the second
bind such that tb->fast* cache is not involved and forces the
bind("[::]:443") to go through the inet_csk_bind_conflict():

bind("[::1]:443"); /* without SO_REUSEPORT. Succeed. */
bind("[::]:443");  /* with    SO_REUSEPORT. -EADDRINUSE */

The expected behavior for sk_reuseport_match() is, it should only allow
the "cached" tb->fast* address to be used as a wildcard match but not
the address of the binding sk.  To do that, the current
"bool match_wildcard" arg is split into
"bool match_sk1_wildcard" and "bool match_sk2_wildcard".

This change only affects the sk_reuseport_match() which is only
used by inet_csk (e.g. TCP).
The other use cases are calling inet_rcv_saddr_equal() and
this patch makes it pass the same "match_wildcard" arg twice to
the "ipv[46]_rcv_saddr_equal(..., match_wildcard, match_wildcard)".

Cc: Josef Bacik <jbacik@fb.com>
Fixes: 637bc8bbe6c0 ("inet: reset tb->fastreuseport when adding a reuseport sk")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c | 43 ++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index d545fb99a8a1..76afe93904d5 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -24,17 +24,19 @@
 #include <net/addrconf.h>
 
 #if IS_ENABLED(CONFIG_IPV6)
-/* match_wildcard == true:  IPV6_ADDR_ANY equals to any IPv6 addresses if IPv6
- *                          only, and any IPv4 addresses if not IPv6 only
- * match_wildcard == false: addresses must be exactly the same, i.e.
- *                          IPV6_ADDR_ANY only equals to IPV6_ADDR_ANY,
- *                          and 0.0.0.0 equals to 0.0.0.0 only
+/* match_sk*_wildcard == true:  IPV6_ADDR_ANY equals to any IPv6 addresses
+ *				if IPv6 only, and any IPv4 addresses
+ *				if not IPv6 only
+ * match_sk*_wildcard == false: addresses must be exactly the same, i.e.
+ *				IPV6_ADDR_ANY only equals to IPV6_ADDR_ANY,
+ *				and 0.0.0.0 equals to 0.0.0.0 only
  */
 static bool ipv6_rcv_saddr_equal(const struct in6_addr *sk1_rcv_saddr6,
 				 const struct in6_addr *sk2_rcv_saddr6,
 				 __be32 sk1_rcv_saddr, __be32 sk2_rcv_saddr,
 				 bool sk1_ipv6only, bool sk2_ipv6only,
-				 bool match_wildcard)
+				 bool match_sk1_wildcard,
+				 bool match_sk2_wildcard)
 {
 	int addr_type = ipv6_addr_type(sk1_rcv_saddr6);
 	int addr_type2 = sk2_rcv_saddr6 ? ipv6_addr_type(sk2_rcv_saddr6) : IPV6_ADDR_MAPPED;
@@ -44,8 +46,8 @@ static bool ipv6_rcv_saddr_equal(const struct in6_addr *sk1_rcv_saddr6,
 		if (!sk2_ipv6only) {
 			if (sk1_rcv_saddr == sk2_rcv_saddr)
 				return true;
-			if (!sk1_rcv_saddr || !sk2_rcv_saddr)
-				return match_wildcard;
+			return (match_sk1_wildcard && !sk1_rcv_saddr) ||
+				(match_sk2_wildcard && !sk2_rcv_saddr);
 		}
 		return false;
 	}
@@ -53,11 +55,11 @@ static bool ipv6_rcv_saddr_equal(const struct in6_addr *sk1_rcv_saddr6,
 	if (addr_type == IPV6_ADDR_ANY && addr_type2 == IPV6_ADDR_ANY)
 		return true;
 
-	if (addr_type2 == IPV6_ADDR_ANY && match_wildcard &&
+	if (addr_type2 == IPV6_ADDR_ANY && match_sk2_wildcard &&
 	    !(sk2_ipv6only && addr_type == IPV6_ADDR_MAPPED))
 		return true;
 
-	if (addr_type == IPV6_ADDR_ANY && match_wildcard &&
+	if (addr_type == IPV6_ADDR_ANY && match_sk1_wildcard &&
 	    !(sk1_ipv6only && addr_type2 == IPV6_ADDR_MAPPED))
 		return true;
 
@@ -69,18 +71,19 @@ static bool ipv6_rcv_saddr_equal(const struct in6_addr *sk1_rcv_saddr6,
 }
 #endif
 
-/* match_wildcard == true:  0.0.0.0 equals to any IPv4 addresses
- * match_wildcard == false: addresses must be exactly the same, i.e.
- *                          0.0.0.0 only equals to 0.0.0.0
+/* match_sk*_wildcard == true:  0.0.0.0 equals to any IPv4 addresses
+ * match_sk*_wildcard == false: addresses must be exactly the same, i.e.
+ *				0.0.0.0 only equals to 0.0.0.0
  */
 static bool ipv4_rcv_saddr_equal(__be32 sk1_rcv_saddr, __be32 sk2_rcv_saddr,
-				 bool sk2_ipv6only, bool match_wildcard)
+				 bool sk2_ipv6only, bool match_sk1_wildcard,
+				 bool match_sk2_wildcard)
 {
 	if (!sk2_ipv6only) {
 		if (sk1_rcv_saddr == sk2_rcv_saddr)
 			return true;
-		if (!sk1_rcv_saddr || !sk2_rcv_saddr)
-			return match_wildcard;
+		return (match_sk1_wildcard && !sk1_rcv_saddr) ||
+			(match_sk2_wildcard && !sk2_rcv_saddr);
 	}
 	return false;
 }
@@ -96,10 +99,12 @@ bool inet_rcv_saddr_equal(const struct sock *sk, const struct sock *sk2,
 					    sk2->sk_rcv_saddr,
 					    ipv6_only_sock(sk),
 					    ipv6_only_sock(sk2),
+					    match_wildcard,
 					    match_wildcard);
 #endif
 	return ipv4_rcv_saddr_equal(sk->sk_rcv_saddr, sk2->sk_rcv_saddr,
-				    ipv6_only_sock(sk2), match_wildcard);
+				    ipv6_only_sock(sk2), match_wildcard,
+				    match_wildcard);
 }
 EXPORT_SYMBOL(inet_rcv_saddr_equal);
 
@@ -273,10 +278,10 @@ static inline int sk_reuseport_match(struct inet_bind_bucket *tb,
 					    tb->fast_rcv_saddr,
 					    sk->sk_rcv_saddr,
 					    tb->fast_ipv6_only,
-					    ipv6_only_sock(sk), true);
+					    ipv6_only_sock(sk), true, false);
 #endif
 	return ipv4_rcv_saddr_equal(tb->fast_rcv_saddr, sk->sk_rcv_saddr,
-				    ipv6_only_sock(sk), true);
+				    ipv6_only_sock(sk), true, false);
 }
 
 /* Obtain a reference to a local port for the given sock,
-- 
2.25.1

