Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A47E11E1A3
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 11:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfLMKIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 05:08:05 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:29416 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfLMKIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 05:08:05 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id xBDA7lh4002195;
        Fri, 13 Dec 2019 11:07:47 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "William J. Tolley" <william@breakpointingbad.com>,
        "Jason A. Donenfeld" <zx2c4@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC] tcp: implement new per-interface sysctl "auto_dev_bind"
Date:   Fri, 13 Dec 2019 11:07:30 +0100
Message-Id: <20191213100730.2153-1-w@1wt.eu>
X-Mailer: git-send-email 2.9.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This sysctl, when set, makes sure that any TCP socket connecting through
that interface or accepted from this interface will automatically be
bound to this device so that the socket cannot migrate by accident to
another interface if the current one goes down, and that incoming traffic
from other interfaces may never reach the socket regardless of rp_filter.
This can be useful for example, in order to protect connections made over
a VPN interface, such as the attack described here:

   https://seclists.org/oss-sec/2019/q4/122.

It might possibly have other use cases such as preventing traffic from
leaking to the default route interface during a temporary outage of a
tunnel interface, or sending traffic out of the host when a local
address is removed.

Only TCPv4 and TCPv6 are covered by this patch.

Reported-by: "William J. Tolley" <william@breakpointingbad.com>
Cc: "Jason A. Donenfeld" <zx2c4@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---

This issue was recently brought on the security list by William and was
discussed with Eric and Jason. This patch is just a proposal to open
the discussion around a clean solution to address the issue. It currently
covers TCPv4 and TCPv6 (both tested). I have no idea whether this is
the best way to proceed; I'm not sure whether we want to address other
connected protocols (e.g. UDP can be "connected" but do we care?); and
very likely the patch will need to be split in two for IPv4/IPv6 but
I found it was more convenient for a review to have both parts together.

--- test reports below

IPv4: simple test over an ipip tunnel

  left (.236):
    ip tunnel add t4 mode ipip remote 192.168.0.176
    ip li set t4 up && ip a a 192.0.2.1/30 dev t4

  right (.176):
    ip tunnel add t4 mode ipip remote 192.168.0.236
    ip li set t4 up && ip a a 192.0.2.2/30 dev t4

  left:~# echo 0 > /proc/sys/net/ipv4/conf/t4/auto_dev_bind
  right:~# nc -lp4000
  left:~# telnet 192.0.2.2 4000 &
  left:~# netstat -atn|grep :4000
  tcp        0      0 192.0.2.1:19536          192.0.2.2:4000          ESTABLISHED

  attacker:~# nping --tcp --flags SA --source-ip 192.0.2.2 -g 4000 --dest-ip 192.0.2.1 -p 19536 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87

  left:~# tcpdump -Sni t4
  16:20:13.289142 IP 192.0.2.1.19536 > 192.0.2.2.4000: . ack 2220548823 win 507
  16:20:13.955344 IP 192.0.2.1.19536 > 192.0.2.2.4000: . ack 2220548823 win 507

  left:~# echo 1 > /proc/sys/net/ipv4/conf/t4/auto_dev_bind
  left:~# telnet 192.0.2.2 4000 &
  left:~# netstat -atn|grep :4000
  tcp        0      0 192.0.2.1:19540          192.0.2.2:4000          ESTABLISHED

  attacker:~# nping --tcp --flags SA --source-ip 192.0.2.2 -g 4000 --dest-ip 192.0.2.1 -p 19540 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87

  left:~# tcpdump -Sni t4
  16:22:41.933842 IP 192.0.2.1.19540 > 192.0.2.2.4000: R 2405575235:2405575235(0) win 0
  16:22:42.266897 IP 192.0.2.1.19540 > 192.0.2.2.4000: R 2405575235:2405575235(0) win 0
  16:22:42.599940 IP 192.0.2.1.19540 > 192.0.2.2.4000: R 2405575235:2405575235(0) win 0

IPv6: simple test over an sit tunnel

  left (.236):
    ip tunnel add t6 mode sit  remote 192.168.0.176
    ip li set t6 up && ip -6 a a 2001:db8::1/64 dev t6

  right (.176):
    ip tunnel add t6 mode sit  remote 192.168.0.236
    ip li set t6 up && ip -6 a a 2001:db8::2/64 dev t6

  left:~# echo 0 > /proc/sys/net/ipv4/conf/t4/auto_dev_bind
  right:~# nc6 -lp4000
  left:~# telnet -6 2001:db8::2 4000 &
  left:~# netstat -atn|grep :4000
  tcp        0      0 2001:db8::1:50636       2001:db8::2:4000        ESTABLISHED
  attacker:~# nping -6 --tcp --flags SA --source-ip 2001:db8::2 -g 4000 --dest-ip 2001:db8::1 -p 50636 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87 --source-mac e8:b6:74:5d:19:ed

  left:~# tcpdump -Sni t6
  16:29:19.842821 IP6 2001:db8::1.50636 > 2001:db8::2.4000: . ack 245909702 win 511
  16:29:20.508811 IP6 2001:db8::1.50636 > 2001:db8::2.4000: . ack 245909702 win 511

  left:~# echo 1 > /proc/sys/net/ipv6/conf/t6/auto_dev_bind
  right:~# nc6 -lp4000
  left:~# telnet -6 2001:db8::2 4000 &
  left:~# netstat -atn|grep :4000
  tcp        0      0 2001:db8::1:56750       2001:db8::2:4000        ESTABLISHED

  attacker:~# nping -6 --tcp --flags SA --source-ip 2001:db8::2 -g 4000 --dest-ip 2001:db8::1 -p 56750 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87 --source-mac e8:b6:74:5d:19:ed

  left:~# tcpdump -Sni t6
  16:46:34.264607 IP6 2001:db8::1.56750 > 2001:db8::2.4000: R 3346985589:3346985589(0) win 0
  16:46:34.597653 IP6 2001:db8::1.56750 > 2001:db8::2.4000: R 3346985589:3346985589(0) win 0
  16:46:34.931292 IP6 2001:db8::1.56750 > 2001:db8::2.4000: R 3346985589:3346985589(0) win 0

Test of incoming connection:
  right~# nc 2001:db8::1 22
  left:~# netstat -atn|grep :22
  tcp        0      0 2001:db8::1:22          2001:db8::2:35990       ESTABLISHED

  attacker:~# nping -6 --tcp --flags SA --source-ip 2001:db8::2 -g 35990 --dest-ip 2001:db8::1 -p 22 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87 --source-mac e8:b6:74:5d:19:ed

  left:~# tcpdump -Sni t6
  16:53:20.810751 IP6 2001:db8::1.22 > 2001:db8::2.35990: R 1630812853:1630812853(0) win 0
  16:53:21.144036 IP6 2001:db8::1.22 > 2001:db8::2.35990: R 1630812853:1630812853(0) win 0
  16:53:21.477052 IP6 2001:db8::1.22 > 2001:db8::2.35990: R 1630812853:1630812853(0) win 0
---
 include/linux/ipv6.h      |  1 +
 include/uapi/linux/ip.h   |  1 +
 include/uapi/linux/ipv6.h |  1 +
 net/ipv4/devinet.c        |  1 +
 net/ipv4/tcp_ipv4.c       | 11 +++++++++++
 net/ipv6/addrconf.c       | 10 ++++++++++
 net/ipv6/tcp_ipv6.c       | 13 +++++++++++++
 7 files changed, 38 insertions(+)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index ea7c7906591e..4a731ceda859 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -42,6 +42,7 @@ struct ipv6_devconf {
 	__s32		accept_ra_rt_info_max_plen;
 #endif
 #endif
+	__s32		auto_dev_bind;
 	__s32		proxy_ndp;
 	__s32		accept_source_route;
 	__s32		accept_ra_from_local;
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..7ef9d3730cf7 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -169,6 +169,7 @@ enum
 	IPV4_DEVCONF_DROP_UNICAST_IN_L2_MULTICAST,
 	IPV4_DEVCONF_DROP_GRATUITOUS_ARP,
 	IPV4_DEVCONF_BC_FORWARDING,
+	IPV4_DEVCONF_AUTO_DEV_BIND,
 	__IPV4_DEVCONF_MAX
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 9c0f4a92bcff..5b7ea50ef5a5 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -158,6 +158,7 @@ enum {
 	DEVCONF_ACCEPT_RA_RTR_PREF,
 	DEVCONF_RTR_PROBE_INTERVAL,
 	DEVCONF_ACCEPT_RA_RT_INFO_MAX_PLEN,
+	DEVCONF_AUTO_DEV_BIND,
 	DEVCONF_PROXY_NDP,
 	DEVCONF_OPTIMISTIC_DAD,
 	DEVCONF_ACCEPT_SOURCE_ROUTE,
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a4b5bd4d2c89..2c8f361834fc 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2518,6 +2518,7 @@ static struct devinet_sysctl_table {
 		DEVINET_SYSCTL_RW_ENTRY(ACCEPT_SOURCE_ROUTE,
 					"accept_source_route"),
 		DEVINET_SYSCTL_RW_ENTRY(ACCEPT_LOCAL, "accept_local"),
+		DEVINET_SYSCTL_RW_ENTRY(AUTO_DEV_BIND, "auto_dev_bind"),
 		DEVINET_SYSCTL_RW_ENTRY(SRC_VMARK, "src_valid_mark"),
 		DEVINET_SYSCTL_RW_ENTRY(PROXY_ARP, "proxy_arp"),
 		DEVINET_SYSCTL_RW_ENTRY(MEDIUM_ID, "medium_id"),
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 67b2dc7a1727..3a1e45ae7186 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -203,6 +203,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	struct tcp_sock *tp = tcp_sk(sk);
 	__be16 orig_sport, orig_dport;
 	__be32 daddr, nexthop;
+	struct in_device *in_dev;
 	struct flowi4 *fl4;
 	struct rtable *rt;
 	int err;
@@ -243,6 +244,11 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		return -ENETUNREACH;
 	}
 
+	if (!sk->sk_bound_dev_if &&
+	    (in_dev = __in_dev_get_rcu(rt->dst.dev)) != NULL &&
+	    IN_DEV_ORCONF(in_dev, AUTO_DEV_BIND))
+		sk->sk_bound_dev_if = fl4->flowi4_oif;
+
 	if (!inet_opt || !inet_opt->opt.srr)
 		daddr = fl4->daddr;
 
@@ -1418,6 +1424,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 {
 	struct inet_request_sock *ireq;
 	struct inet_sock *newinet;
+	struct in_device *in_dev;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
 #ifdef CONFIG_TCP_MD5SIG
@@ -1468,6 +1475,10 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 
 	tcp_initialize_rcv_mss(newsk);
 
+	in_dev = __in_dev_get_rcu(skb->dev);
+	if (in_dev && IN_DEV_ORCONF(in_dev, AUTO_DEV_BIND))
+		newsk->sk_bound_dev_if = skb->skb_iif;
+
 #ifdef CONFIG_TCP_MD5SIG
 	/* Copy over the MD5 key from the original socket */
 	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&newinet->inet_daddr,
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 34ccef18b40e..12e24647ab1e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -217,6 +217,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.accept_ra_rt_info_max_plen = 0,
 #endif
 #endif
+	.auto_dev_bind		= 0,
 	.proxy_ndp		= 0,
 	.accept_source_route	= 0,	/* we do not accept RH0 by default. */
 	.disable_ipv6		= 0,
@@ -271,6 +272,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.accept_ra_rt_info_max_plen = 0,
 #endif
 #endif
+	.auto_dev_bind		= 0,
 	.proxy_ndp		= 0,
 	.accept_source_route	= 0,	/* we do not accept RH0 by default. */
 	.disable_ipv6		= 0,
@@ -5410,6 +5412,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_ACCEPT_RA_RT_INFO_MAX_PLEN] = cnf->accept_ra_rt_info_max_plen;
 #endif
 #endif
+	array[DEVCONF_AUTO_DEV_BIND] = cnf->auto_dev_bind;
 	array[DEVCONF_PROXY_NDP] = cnf->proxy_ndp;
 	array[DEVCONF_ACCEPT_SOURCE_ROUTE] = cnf->accept_source_route;
 #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
@@ -6641,6 +6644,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 	},
 #endif
 #endif
+	{
+		.procname	= "auto_dev_bind",
+		.data		= &ipv6_devconf.auto_dev_bind,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "proxy_ndp",
 		.data		= &ipv6_devconf.proxy_ndp,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4804b6dc5e65..56ecbcd326a4 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -150,6 +150,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct in6_addr *saddr = NULL, *final_p, final;
+	struct inet6_dev *in6_dev;
 	struct ipv6_txoptions *opt;
 	struct flowi6 fl6;
 	struct dst_entry *dst;
@@ -286,6 +287,12 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 		sk->sk_v6_rcv_saddr = *saddr;
 	}
 
+	if (!sk->sk_bound_dev_if &&
+	    (in6_dev = __in6_dev_get(dst->dev)) != NULL &&
+	    (in6_dev->cnf.auto_dev_bind ||
+	     dev_net(dst->dev)->ipv6.devconf_all->auto_dev_bind))
+		fl6.flowi6_oif = sk->sk_bound_dev_if = dst->dev->ifindex;
+
 	/* set the source address */
 	np->saddr = *saddr;
 	inet->inet_rcv_saddr = LOOPBACK4_IPV6;
@@ -1121,6 +1128,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	struct ipv6_pinfo *newnp;
 	const struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct ipv6_txoptions *opt;
+	struct inet6_dev *in6_dev;
 	struct inet_sock *newinet;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
@@ -1193,6 +1201,11 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 			goto out;
 	}
 
+	if ((in6_dev = __in6_dev_get(dst->dev)) != NULL &&
+	    (in6_dev->cnf.auto_dev_bind ||
+	     dev_net(dst->dev)->ipv6.devconf_all->auto_dev_bind))
+		ireq->ir_iif = inet_iif(skb);
+
 	newsk = tcp_create_openreq_child(sk, req, skb);
 	if (!newsk)
 		goto out_nonewsk;
-- 
2.20.1

