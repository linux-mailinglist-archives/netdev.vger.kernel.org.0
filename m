Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8C321CC08
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgGLXPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbgGLXPe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPP-P3; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net-next 07/20] net: ipv6: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:03 +0200
Message-Id: <20200712231516.1139335-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ipv6/exthdrs.c    |  1 -
 net/ipv6/ip6_output.c |  6 ++++--
 net/ipv6/ip6_tunnel.c | 10 ++++++----
 net/ipv6/udp.c        |  3 +++
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index e9b366994475..374105e4394f 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -1232,7 +1232,6 @@ static void ipv6_renew_option(int renewtype,
  * @opt: original options
  * @newtype: option type to replace in @opt
  * @newopt: new option of type @newtype to replace (user-mem)
- * @newoptlen: length of @newopt
  *
  * Returns a new set of options which is a copy of @opt with the
  * option type @newtype replaced with @newopt.
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8a8c2d0cfcc8..c78e67d7747f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1118,6 +1118,7 @@ static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
 
 /**
  *	ip6_dst_lookup - perform route lookup on flow
+ *	@net: Network namespace to perform lookup in
  *	@sk: socket which provides route info
  *	@dst: pointer to dst_entry * for result
  *	@fl6: flow to lookup
@@ -1136,6 +1137,7 @@ EXPORT_SYMBOL_GPL(ip6_dst_lookup);
 
 /**
  *	ip6_dst_lookup_flow - perform route lookup on flow with ipsec
+ *	@net: Network namespace to perform lookup in
  *	@sk: socket which provides route info
  *	@fl6: flow to lookup
  *	@final_dst: final destination address for ipsec lookup
@@ -1202,11 +1204,11 @@ EXPORT_SYMBOL_GPL(ip6_sk_dst_lookup_flow);
  *      @skb: Packet for which lookup is done
  *      @dev: Tunnel device
  *      @net: Network namespace of tunnel device
- *      @sk: Socket which provides route info
+ *      @sock: Socket which provides route info
  *      @saddr: Memory to store the src ip address
  *      @info: Tunnel information
  *      @protocol: IP protocol
- *      @use_cahce: Flag to enable cache usage
+ *      @use_cache: Flag to enable cache usage
  *      This function performs a route lookup on a tunnel
  *
  *      It returns a valid dst pointer and stores src address to be used in
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 821d96c720b9..f973344fcd85 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -124,8 +124,12 @@ static struct net_device_stats *ip6_get_stats(struct net_device *dev)
 	return &dev->stats;
 }
 
+#define for_each_ip6_tunnel_rcu(start) \
+	for (t = rcu_dereference(start); t; t = rcu_dereference(t->next))
+
 /**
  * ip6_tnl_lookup - fetch tunnel matching the end-point addresses
+ *   @net: network namespace
  *   @link: ifindex of underlying interface
  *   @remote: the address of the tunnel exit-point
  *   @local: the address of the tunnel entry-point
@@ -136,9 +140,6 @@ static struct net_device_stats *ip6_get_stats(struct net_device *dev)
  *   else %NULL
  **/
 
-#define for_each_ip6_tunnel_rcu(start) \
-	for (t = rcu_dereference(start); t; t = rcu_dereference(t->next))
-
 static struct ip6_tnl *
 ip6_tnl_lookup(struct net *net, int link,
 	       const struct in6_addr *remote, const struct in6_addr *local)
@@ -302,8 +303,8 @@ static int ip6_tnl_create2(struct net_device *dev)
 
 /**
  * ip6_tnl_create - create a new tunnel
+ *   @net: network namespace
  *   @p: tunnel parameters
- *   @pt: pointer to new tunnel
  *
  * Description:
  *   Create tunnel matching given parameters.
@@ -351,6 +352,7 @@ static struct ip6_tnl *ip6_tnl_create(struct net *net, struct __ip6_tnl_parm *p)
 
 /**
  * ip6_tnl_locate - find or create tunnel matching given parameters
+ *   @net: network namespace
  *   @p: tunnel parameters
  *   @create: != 0 if allowed to create new tunnel if no match found
  *
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7d4151747340..38c0d9350c6b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1059,6 +1059,9 @@ static int udpv6_pre_connect(struct sock *sk, struct sockaddr *uaddr,
  *	@sk:	socket we are sending on
  *	@skb:	sk_buff containing the filled-in UDP header
  *		(checksum field must be zeroed out)
+ *	@saddr: source address
+ *	@daddr: destination address
+ *	@len:	length of packet
  */
 static void udp6_hwcsum_outgoing(struct sock *sk, struct sk_buff *skb,
 				 const struct in6_addr *saddr,
-- 
2.27.0.rc2

