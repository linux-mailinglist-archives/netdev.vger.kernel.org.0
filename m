Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A5E1413C3
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 22:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgAQV4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 16:56:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:18602 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgAQV4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 16:56:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 13:56:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="426141905"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jan 2020 13:56:45 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org
Subject: [RFC net-next PATCH] ipv6: New define for reoccurring code
Date:   Fri, 17 Jan 2020 13:56:42 -0800
Message-Id: <20200117215642.2029945-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Through out the kernel, sizeof() is used to determine the size of the IPv6
address structure, so create a define for the commonly used code.

s/sizeof(struct in6_addr)/ipv6_addr_size/g

This is just a portion of the instances in the kernel and before cleaning
up all the occurrences, wanted to make sure that this was a desired change
or if this obfuscates the code.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/uapi/linux/in6.h                       |  1 +
 net/core/filter.c                              |  2 +-
 net/core/pktgen.c                              |  2 +-
 net/ipv6/addrconf.c                            | 14 +++++++-------
 net/ipv6/addrlabel.c                           |  2 +-
 net/ipv6/exthdrs.c                             |  4 ++--
 net/ipv6/fib6_rules.c                          |  6 +++---
 net/ipv6/ila/ila_lwt.c                         |  2 +-
 net/ipv6/ip6_gre.c                             | 18 +++++++++---------
 net/ipv6/ip6_output.c                          |  2 +-
 net/ipv6/ip6_tunnel.c                          | 14 +++++++-------
 net/ipv6/ip6_vti.c                             | 14 +++++++-------
 net/ipv6/ip6mr.c                               | 10 +++++-----
 net/ipv6/ipcomp6.c                             |  4 ++--
 net/ipv6/ndisc.c                               |  4 ++--
 net/ipv6/netfilter/ip6t_rpfilter.c             |  2 +-
 net/ipv6/netfilter/ip6t_srh.c                  |  4 ++--
 net/ipv6/netfilter/nft_dup_ipv6.c              |  2 +-
 net/ipv6/seg6.c                                |  4 ++--
 net/ipv6/seg6_iptunnel.c                       |  4 ++--
 net/ipv6/seg6_local.c                          | 12 ++++++------
 net/ipv6/sit.c                                 |  4 ++--
 net/openvswitch/conntrack.c                    |  4 ++--
 net/openvswitch/flow_netlink.c                 |  4 ++--
 net/sched/cls_flower.c                         | 16 ++++++++--------
 net/socket.c                                   |  2 +-
 security/selinux/netnode.c                     |  2 +-
 tools/lib/traceevent/event-parse.c             |  2 +-
 tools/testing/selftests/bpf/test_sock_addr.c   |  2 +-
 .../networking/timestamping/txtimestamp.c      |  2 +-
 30 files changed, 83 insertions(+), 82 deletions(-)

diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 9f2273a08356..24547a51e715 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -44,6 +44,7 @@ struct in6_addr {
 #define s6_addr32		in6_u.u6_addr32
 #endif
 };
+#define ipv6_addr_size		sizeof(struct in6_addr)
 #endif /* __UAPI_DEF_IN6_ADDR */
 
 #if __UAPI_DEF_SOCKADDR_IN6
diff --git a/net/core/filter.c b/net/core/filter.c
index ef01c5599501..eabf42893b60 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5053,7 +5053,7 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 	case SEG6_LOCAL_ACTION_END_X:
 		if (!seg6_bpf_has_valid_srh(skb))
 			return -EBADMSG;
-		if (param_len != sizeof(struct in6_addr))
+		if (param_len != ipv6_addr_size)
 			return -EINVAL;
 		return seg6_lookup_nexthop(skb, (struct in6_addr *)param, 0);
 	case SEG6_LOCAL_ACTION_END_T:
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 890be1b4877e..9d009ce2c19f 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2124,7 +2124,7 @@ static void pktgen_setup_inject(struct pktgen_dev *pkt_dev)
 						+ pkt_dev->pkt_overhead;
 		}
 
-		for (i = 0; i < sizeof(struct in6_addr); i++)
+		for (i = 0; i < ipv6_addr_size; i++)
 			if (pkt_dev->cur_in6_saddr.s6_addr[i]) {
 				set = 1;
 				break;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 39d861d00377..a6f9d5f64373 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3104,7 +3104,7 @@ static void sit_add_v4_addrs(struct inet6_dev *idev)
 
 	ASSERT_RTNL();
 
-	memset(&addr, 0, sizeof(struct in6_addr));
+	memset(&addr, 0, ipv6_addr_size);
 	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr, 4);
 
 	if (idev->dev->flags&IFF_POINTOPOINT) {
@@ -4547,8 +4547,8 @@ static struct in6_addr *extract_addr(struct nlattr *addr, struct nlattr *local,
 }
 
 static const struct nla_policy ifa_ipv6_policy[IFA_MAX+1] = {
-	[IFA_ADDRESS]		= { .len = sizeof(struct in6_addr) },
-	[IFA_LOCAL]		= { .len = sizeof(struct in6_addr) },
+	[IFA_ADDRESS]		= { .len = ipv6_addr_size },
+	[IFA_LOCAL]		= { .len = ipv6_addr_size },
 	[IFA_CACHEINFO]		= { .len = sizeof(struct ifa_cacheinfo) },
 	[IFA_FLAGS]		= { .len = sizeof(u32) },
 	[IFA_RT_PRIORITY]	= { .len = sizeof(u32) },
@@ -5449,7 +5449,7 @@ static inline size_t inet6_ifla6_size(void)
 	     + nla_total_size(DEVCONF_MAX * 4) /* IFLA_INET6_CONF */
 	     + nla_total_size(IPSTATS_MIB_MAX * 8) /* IFLA_INET6_STATS */
 	     + nla_total_size(ICMP6_MIB_MAX * 8) /* IFLA_INET6_ICMP6STATS */
-	     + nla_total_size(sizeof(struct in6_addr)) /* IFLA_INET6_TOKEN */
+	     + nla_total_size(ipv6_addr_size) /* IFLA_INET6_TOKEN */
 	     + nla_total_size(1) /* IFLA_INET6_ADDR_GEN_MODE */
 	     + 0;
 }
@@ -5549,7 +5549,7 @@ static int inet6_fill_ifla6_attrs(struct sk_buff *skb, struct inet6_dev *idev,
 		goto nla_put_failure;
 	snmp6_fill_stats(nla_data(nla), idev, IFLA_INET6_ICMP6STATS, nla_len(nla));
 
-	nla = nla_reserve(skb, IFLA_INET6_TOKEN, sizeof(struct in6_addr));
+	nla = nla_reserve(skb, IFLA_INET6_TOKEN, ipv6_addr_size);
 	if (!nla)
 		goto nla_put_failure;
 	read_lock_bh(&idev->lock);
@@ -5656,7 +5656,7 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
 
 static const struct nla_policy inet6_af_policy[IFLA_INET6_MAX + 1] = {
 	[IFLA_INET6_ADDR_GEN_MODE]	= { .type = NLA_U8 },
-	[IFLA_INET6_TOKEN]		= { .len = sizeof(struct in6_addr) },
+	[IFLA_INET6_TOKEN]		= { .len = ipv6_addr_size },
 };
 
 static int check_addr_gen_mode(int mode)
@@ -5882,7 +5882,7 @@ void inet6_ifinfo_notify(int event, struct inet6_dev *idev)
 static inline size_t inet6_prefix_nlmsg_size(void)
 {
 	return NLMSG_ALIGN(sizeof(struct prefixmsg))
-	       + nla_total_size(sizeof(struct in6_addr))
+	       + nla_total_size(ipv6_addr_size)
 	       + nla_total_size(sizeof(struct prefix_cacheinfo));
 }
 
diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index 642fc6ac13d2..c44b257bd5d9 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -357,7 +357,7 @@ void ipv6_addr_label_cleanup(void)
 }
 
 static const struct nla_policy ifal_policy[IFAL_MAX+1] = {
-	[IFAL_ADDRESS]		= { .len = sizeof(struct in6_addr), },
+	[IFAL_ADDRESS]		= { .len = ipv6_addr_size, },
 	[IFAL_LABEL]		= { .len = sizeof(u32), },
 };
 
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index ab5add0fe6b4..e04b741aa90d 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -879,7 +879,7 @@ static void ipv6_push_rthdr0(struct sk_buff *skb, u8 *proto,
 
 	if (hops > 1)
 		memcpy(phdr->addr, ihdr->addr + 1,
-		       (hops - 1) * sizeof(struct in6_addr));
+		       (hops - 1) * ipv6_addr_size);
 
 	phdr->addr[hops - 1] = **addr_p;
 	*addr_p = ihdr->addr;
@@ -903,7 +903,7 @@ static void ipv6_push_rthdr4(struct sk_buff *skb, u8 *proto,
 
 	hops = sr_ihdr->first_segment + 1;
 	memcpy(sr_phdr->segments + 1, sr_ihdr->segments + 1,
-	       (hops - 1) * sizeof(struct in6_addr));
+	       (hops - 1) * ipv6_addr_size);
 
 	sr_phdr->segments[0] = **addr_p;
 	*addr_p = &sr_ihdr->segments[sr_ihdr->segments_left];
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index fafe556d21e0..1f9a0b8ea818 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -403,11 +403,11 @@ static int fib6_rule_compare(struct fib_rule *rule, struct fib_rule_hdr *frh,
 		return 0;
 
 	if (frh->src_len &&
-	    nla_memcmp(tb[FRA_SRC], &rule6->src.addr, sizeof(struct in6_addr)))
+	    nla_memcmp(tb[FRA_SRC], &rule6->src.addr, ipv6_addr_size))
 		return 0;
 
 	if (frh->dst_len &&
-	    nla_memcmp(tb[FRA_DST], &rule6->dst.addr, sizeof(struct in6_addr)))
+	    nla_memcmp(tb[FRA_DST], &rule6->dst.addr, ipv6_addr_size))
 		return 0;
 
 	return 1;
@@ -442,7 +442,7 @@ static size_t fib6_rule_nlmsg_payload(struct fib_rule *rule)
 static const struct fib_rules_ops __net_initconst fib6_rules_ops_template = {
 	.family			= AF_INET6,
 	.rule_size		= sizeof(struct fib6_rule),
-	.addr_size		= sizeof(struct in6_addr),
+	.addr_size		= ipv6_addr_size,
 	.action			= fib6_rule_action,
 	.match			= fib6_rule_match,
 	.suppress		= fib6_rule_suppress,
diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index 422dcc691f71..786a1999a5be 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -246,7 +246,7 @@ static int ila_build_state(struct nlattr *nla,
 	newts->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT |
 			LWTUNNEL_STATE_INPUT_REDIRECT;
 
-	if (cfg6->fc_dst_len == 8 * sizeof(struct in6_addr))
+	if (cfg6->fc_dst_len == 8 * ipv6_addr_size)
 		ilwt->connected = 1;
 
 	*ts = newts;
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index ee968d980746..90c5016a370e 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1073,8 +1073,8 @@ static void ip6gre_tnl_link_config_common(struct ip6_tnl *t)
 	struct flowi6 *fl6 = &t->fl.u.ip6;
 
 	if (dev->type != ARPHRD_ETHER) {
-		memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
-		memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
+		memcpy(dev->dev_addr, &p->laddr, ipv6_addr_size);
+		memcpy(dev->broadcast, &p->raddr, ipv6_addr_size);
 	}
 
 	/* Set up flowi template */
@@ -1356,9 +1356,9 @@ static int ip6gre_header(struct sk_buff *skb, struct net_device *dev,
 	 */
 
 	if (saddr)
-		memcpy(&ipv6h->saddr, saddr, sizeof(struct in6_addr));
+		memcpy(&ipv6h->saddr, saddr, ipv6_addr_size);
 	if (daddr)
-		memcpy(&ipv6h->daddr, daddr, sizeof(struct in6_addr));
+		memcpy(&ipv6h->daddr, daddr, ipv6_addr_size);
 	if (!ipv6_addr_any(&ipv6h->daddr))
 		return t->hlen;
 
@@ -1397,7 +1397,7 @@ static void ip6gre_tunnel_setup(struct net_device *dev)
 	dev->type = ARPHRD_IP6GRE;
 
 	dev->flags |= IFF_NOARP;
-	dev->addr_len = sizeof(struct in6_addr);
+	dev->addr_len = ipv6_addr_size;
 	netif_keep_dst(dev);
 	/* This perm addr will be used as interface identifier by IPv6 */
 	dev->addr_assign_type = NET_ADDR_RANDOM;
@@ -1495,8 +1495,8 @@ static int ip6gre_tunnel_init(struct net_device *dev)
 	if (tunnel->parms.collect_md)
 		return 0;
 
-	memcpy(dev->dev_addr, &tunnel->parms.laddr, sizeof(struct in6_addr));
-	memcpy(dev->broadcast, &tunnel->parms.raddr, sizeof(struct in6_addr));
+	memcpy(dev->dev_addr, &tunnel->parms.laddr, ipv6_addr_size);
+	memcpy(dev->broadcast, &tunnel->parms.raddr, ipv6_addr_size);
 
 	if (ipv6_addr_any(&tunnel->parms.raddr))
 		dev->header_ops = &ip6gre_header_ops;
@@ -2075,9 +2075,9 @@ static size_t ip6gre_get_size(const struct net_device *dev)
 		/* IFLA_GRE_OKEY */
 		nla_total_size(4) +
 		/* IFLA_GRE_LOCAL */
-		nla_total_size(sizeof(struct in6_addr)) +
+		nla_total_size(ipv6_addr_size) +
 		/* IFLA_GRE_REMOTE */
-		nla_total_size(sizeof(struct in6_addr)) +
+		nla_total_size(ipv6_addr_size) +
 		/* IFLA_GRE_TTL */
 		nla_total_size(1) +
 		/* IFLA_GRE_ENCAP_LIMIT */
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 087304427bbb..acb0da52cf83 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1090,7 +1090,7 @@ static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
 			 */
 			dst_release(*dst);
 			memcpy(&fl_gw6, fl6, sizeof(struct flowi6));
-			memset(&fl_gw6.daddr, 0, sizeof(struct in6_addr));
+			memset(&fl_gw6.daddr, 0, ipv6_addr_size);
 			*dst = ip6_route_output(net, sk, &fl_gw6);
 			err = (*dst)->error;
 			if (err)
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2f376dbc37d5..26eb90f9e4b9 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1424,8 +1424,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 	struct flowi6 *fl6 = &t->fl.u.ip6;
 	int t_hlen;
 
-	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
-	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
+	memcpy(dev->dev_addr, &p->laddr, ipv6_addr_size);
+	memcpy(dev->broadcast, &p->raddr, ipv6_addr_size);
 
 	/* Set up flowi template */
 	fl6->saddr = p->laddr;
@@ -1802,7 +1802,7 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 
 	dev->type = ARPHRD_TUNNEL6;
 	dev->flags |= IFF_NOARP;
-	dev->addr_len = sizeof(struct in6_addr);
+	dev->addr_len = ipv6_addr_size;
 	dev->features |= NETIF_F_LLTX;
 	netif_keep_dst(dev);
 
@@ -2077,9 +2077,9 @@ static size_t ip6_tnl_get_size(const struct net_device *dev)
 		/* IFLA_IPTUN_LINK */
 		nla_total_size(4) +
 		/* IFLA_IPTUN_LOCAL */
-		nla_total_size(sizeof(struct in6_addr)) +
+		nla_total_size(ipv6_addr_size) +
 		/* IFLA_IPTUN_REMOTE */
-		nla_total_size(sizeof(struct in6_addr)) +
+		nla_total_size(ipv6_addr_size) +
 		/* IFLA_IPTUN_TTL */
 		nla_total_size(1) +
 		/* IFLA_IPTUN_ENCAP_LIMIT */
@@ -2147,8 +2147,8 @@ EXPORT_SYMBOL(ip6_tnl_get_link_net);
 
 static const struct nla_policy ip6_tnl_policy[IFLA_IPTUN_MAX + 1] = {
 	[IFLA_IPTUN_LINK]		= { .type = NLA_U32 },
-	[IFLA_IPTUN_LOCAL]		= { .len = sizeof(struct in6_addr) },
-	[IFLA_IPTUN_REMOTE]		= { .len = sizeof(struct in6_addr) },
+	[IFLA_IPTUN_LOCAL]		= { .len = ipv6_addr_size },
+	[IFLA_IPTUN_REMOTE]		= { .len = ipv6_addr_size },
 	[IFLA_IPTUN_TTL]		= { .type = NLA_U8 },
 	[IFLA_IPTUN_ENCAP_LIMIT]	= { .type = NLA_U8 },
 	[IFLA_IPTUN_FLOWINFO]		= { .type = NLA_U32 },
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 6f08b760c2a7..b22960bbdee3 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -622,8 +622,8 @@ static void vti6_link_config(struct ip6_tnl *t, bool keep_mtu)
 	struct net_device *tdev = NULL;
 	int mtu;
 
-	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
-	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
+	memcpy(dev->dev_addr, &p->laddr, ipv6_addr_size);
+	memcpy(dev->broadcast, &p->raddr, ipv6_addr_size);
 
 	p->flags &= ~(IP6_TNL_F_CAP_XMIT | IP6_TNL_F_CAP_RCV |
 		      IP6_TNL_F_CAP_PER_PACKET);
@@ -874,7 +874,7 @@ static void vti6_dev_setup(struct net_device *dev)
 	dev->min_mtu = IPV4_MIN_MTU;
 	dev->max_mtu = IP_MAX_MTU - sizeof(struct ipv6hdr);
 	dev->flags |= IFF_NOARP;
-	dev->addr_len = sizeof(struct in6_addr);
+	dev->addr_len = ipv6_addr_size;
 	netif_keep_dst(dev);
 	/* This perm addr will be used as interface identifier by IPv6 */
 	dev->addr_assign_type = NET_ADDR_RANDOM;
@@ -1022,9 +1022,9 @@ static size_t vti6_get_size(const struct net_device *dev)
 		/* IFLA_VTI_LINK */
 		nla_total_size(4) +
 		/* IFLA_VTI_LOCAL */
-		nla_total_size(sizeof(struct in6_addr)) +
+		nla_total_size(ipv6_addr_size) +
 		/* IFLA_VTI_REMOTE */
-		nla_total_size(sizeof(struct in6_addr)) +
+		nla_total_size(ipv6_addr_size) +
 		/* IFLA_VTI_IKEY */
 		nla_total_size(4) +
 		/* IFLA_VTI_OKEY */
@@ -1054,8 +1054,8 @@ static int vti6_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 static const struct nla_policy vti6_policy[IFLA_VTI_MAX + 1] = {
 	[IFLA_VTI_LINK]		= { .type = NLA_U32 },
-	[IFLA_VTI_LOCAL]	= { .len = sizeof(struct in6_addr) },
-	[IFLA_VTI_REMOTE]	= { .len = sizeof(struct in6_addr) },
+	[IFLA_VTI_LOCAL]	= { .len = ipv6_addr_size },
+	[IFLA_VTI_REMOTE]	= { .len = ipv6_addr_size },
 	[IFLA_VTI_IKEY]		= { .type = NLA_U32 },
 	[IFLA_VTI_OKEY]		= { .type = NLA_U32 },
 	[IFLA_VTI_FWMARK]	= { .type = NLA_U32 },
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index bfa49ff70531..571ce9d7718a 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -209,7 +209,7 @@ static int ip6mr_rule_fill(struct fib_rule *rule, struct sk_buff *skb,
 static const struct fib_rules_ops __net_initconst ip6mr_rules_ops_template = {
 	.family		= RTNL_FAMILY_IP6MR,
 	.rule_size	= sizeof(struct ip6mr_rule),
-	.addr_size	= sizeof(struct in6_addr),
+	.addr_size	= ipv6_addr_size,
 	.action		= ip6mr_rule_action,
 	.match		= ip6mr_rule_match,
 	.configure	= ip6mr_rule_configure,
@@ -2377,8 +2377,8 @@ static int mr6_msgsize(bool unresolved, int maxvif)
 	size_t len =
 		NLMSG_ALIGN(sizeof(struct rtmsg))
 		+ nla_total_size(4)	/* RTA_TABLE */
-		+ nla_total_size(sizeof(struct in6_addr))	/* RTA_SRC */
-		+ nla_total_size(sizeof(struct in6_addr))	/* RTA_DST */
+		+ nla_total_size(ipv6_addr_size)	/* RTA_SRC */
+		+ nla_total_size(ipv6_addr_size)	/* RTA_DST */
 		;
 
 	if (!unresolved)
@@ -2425,9 +2425,9 @@ static size_t mrt6msg_netlink_msgsize(size_t payloadlen)
 		+ nla_total_size(1)	/* IP6MRA_CREPORT_MSGTYPE */
 		+ nla_total_size(4)	/* IP6MRA_CREPORT_MIF_ID */
 					/* IP6MRA_CREPORT_SRC_ADDR */
-		+ nla_total_size(sizeof(struct in6_addr))
+		+ nla_total_size(ipv6_addr_size)
 					/* IP6MRA_CREPORT_DST_ADDR */
-		+ nla_total_size(sizeof(struct in6_addr))
+		+ nla_total_size(ipv6_addr_size)
 					/* IP6MRA_CREPORT_PKT */
 		+ nla_total_size(payloadlen)
 		;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 3752bd3e92ce..ac5061031112 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -85,11 +85,11 @@ static struct xfrm_state *ipcomp6_tunnel_create(struct xfrm_state *x)
 	if (!t->id.spi)
 		goto error;
 
-	memcpy(t->id.daddr.a6, x->id.daddr.a6, sizeof(struct in6_addr));
+	memcpy(t->id.daddr.a6, x->id.daddr.a6, ipv6_addr_size);
 	memcpy(&t->sel, &x->sel, sizeof(t->sel));
 	t->props.family = AF_INET6;
 	t->props.mode = x->props.mode;
-	memcpy(t->props.saddr.a6, x->props.saddr.a6, sizeof(struct in6_addr));
+	memcpy(t->props.saddr.a6, x->props.saddr.a6, ipv6_addr_size);
 	memcpy(&t->mark, &x->mark, sizeof(t->mark));
 
 	if (xfrm_init_state(t))
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 53caf59c591e..508596a9d734 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -107,7 +107,7 @@ static const struct neigh_ops ndisc_direct_ops = {
 
 struct neigh_table nd_tbl = {
 	.family =	AF_INET6,
-	.key_len =	sizeof(struct in6_addr),
+	.key_len =	ipv6_addr_size,
 	.protocol =	cpu_to_be16(ETH_P_IPV6),
 	.hash =		ndisc_hash,
 	.key_eq =	ndisc_key_eq,
@@ -1128,7 +1128,7 @@ static void ndisc_ra_useropt(struct sk_buff *ra, struct nd_opt_hdr *opt)
 	int err;
 	int base_size = NLMSG_ALIGN(sizeof(struct nduseroptmsg)
 				    + (opt->nd_opt_len << 3));
-	size_t msg_size = base_size + nla_total_size(sizeof(struct in6_addr));
+	size_t msg_size = base_size + nla_total_size(ipv6_addr_size);
 
 	skb = nlmsg_new(msg_size, GFP_ATOMIC);
 	if (!skb) {
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index d800801a5dd2..ce2a61bdccfc 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -44,7 +44,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	int lookup_flags;
 
 	if (rpfilter_addr_unicast(&iph->daddr)) {
-		memcpy(&fl6.saddr, &iph->daddr, sizeof(struct in6_addr));
+		memcpy(&fl6.saddr, &iph->daddr, ipv6_addr_size);
 		lookup_flags = RT6_LOOKUP_F_HAS_SADDR;
 	} else {
 		lookup_flags = 0;
diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index db0fd64d8986..9540d92f28fb 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -204,7 +204,7 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		if (srh->segments_left == srh->first_segment)
 			return false;
 		psidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
-			  ((srh->segments_left + 1) * sizeof(struct in6_addr));
+			  ((srh->segments_left + 1) * ipv6_addr_size);
 		psid = skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);
 		if (!psid)
 			return false;
@@ -219,7 +219,7 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		if (srh->segments_left == 0)
 			return false;
 		nsidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
-			  ((srh->segments_left - 1) * sizeof(struct in6_addr));
+			  ((srh->segments_left - 1) * ipv6_addr_size);
 		nsid = skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);
 		if (!nsid)
 			return false;
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index 2af32200507d..91ae092f27da 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -39,7 +39,7 @@ static int nft_dup_ipv6_init(const struct nft_ctx *ctx,
 		return -EINVAL;
 
 	priv->sreg_addr = nft_parse_register(tb[NFTA_DUP_SREG_ADDR]);
-	err = nft_validate_register_load(priv->sreg_addr, sizeof(struct in6_addr));
+	err = nft_validate_register_load(priv->sreg_addr, ipv6_addr_size);
 	if (err < 0)
 		return err;
 
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 75421a472d25..32872868823f 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -69,7 +69,7 @@ static struct genl_family seg6_genl_family;
 
 static const struct nla_policy seg6_genl_policy[SEG6_ATTR_MAX + 1] = {
 	[SEG6_ATTR_DST]				= { .type = NLA_BINARY,
-		.len = sizeof(struct in6_addr) },
+		.len = ipv6_addr_size },
 	[SEG6_ATTR_DSTLEN]			= { .type = NLA_S32, },
 	[SEG6_ATTR_HMACKEYID]		= { .type = NLA_U32, },
 	[SEG6_ATTR_SECRET]			= { .type = NLA_BINARY, },
@@ -210,7 +210,7 @@ static int seg6_genl_get_tunsrc(struct sk_buff *skb, struct genl_info *info)
 	rcu_read_lock();
 	tun_src = rcu_dereference(seg6_pernet(net)->tun_src);
 
-	if (nla_put(msg, SEG6_ATTR_DST, sizeof(struct in6_addr), tun_src))
+	if (nla_put(msg, SEG6_ATTR_DST, ipv6_addr_size, tun_src))
 		goto nla_put_failure;
 
 	rcu_read_unlock();
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index ab7f124ff5d7..c3853ee15cf7 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -77,7 +77,7 @@ static void set_tun_src(struct net *net, struct net_device *dev,
 	tun_src = rcu_dereference(sdata->tun_src);
 
 	if (!ipv6_addr_any(tun_src)) {
-		memcpy(saddr, tun_src, sizeof(struct in6_addr));
+		memcpy(saddr, tun_src, ipv6_addr_size);
 	} else {
 		ipv6_dev_get_saddr(net, dev, daddr, IPV6_PREFER_SRC_PUBLIC,
 				   saddr);
@@ -407,7 +407,7 @@ static int seg6_build_state(struct nlattr *nla,
 	 * the SRH and one segment
 	 */
 	min_size = sizeof(*tuninfo) + sizeof(struct ipv6_sr_hdr) +
-		   sizeof(struct in6_addr);
+		   ipv6_addr_size;
 	if (tuninfo_len < min_size)
 		return -EINVAL;
 
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 85a5447a3e8d..359d1ac957f4 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -650,7 +650,7 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_NH4]	= { .type = NLA_BINARY,
 				    .len = sizeof(struct in_addr) },
 	[SEG6_LOCAL_NH6]	= { .type = NLA_BINARY,
-				    .len = sizeof(struct in6_addr) },
+				    .len = ipv6_addr_size },
 	[SEG6_LOCAL_IIF]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_OIF]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_BPF]	= { .type = NLA_NESTED },
@@ -665,7 +665,7 @@ static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 	len = nla_len(attrs[SEG6_LOCAL_SRH]);
 
 	/* SRH must contain at least one segment */
-	if (len < sizeof(*srh) + sizeof(struct in6_addr))
+	if (len < sizeof(*srh) + ipv6_addr_size)
 		return -EINVAL;
 
 	if (!seg6_validate_srh(srh, len))
@@ -760,7 +760,7 @@ static int cmp_nla_nh4(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 static int parse_nla_nh6(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
 	memcpy(&slwt->nh6, nla_data(attrs[SEG6_LOCAL_NH6]),
-	       sizeof(struct in6_addr));
+	       ipv6_addr_size);
 
 	return 0;
 }
@@ -769,18 +769,18 @@ static int put_nla_nh6(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
 	struct nlattr *nla;
 
-	nla = nla_reserve(skb, SEG6_LOCAL_NH6, sizeof(struct in6_addr));
+	nla = nla_reserve(skb, SEG6_LOCAL_NH6, ipv6_addr_size);
 	if (!nla)
 		return -EMSGSIZE;
 
-	memcpy(nla_data(nla), &slwt->nh6, sizeof(struct in6_addr));
+	memcpy(nla_data(nla), &slwt->nh6, ipv6_addr_size);
 
 	return 0;
 }
 
 static int cmp_nla_nh6(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 {
-	return memcmp(&a->nh6, &b->nh6, sizeof(struct in6_addr));
+	return memcmp(&a->nh6, &b->nh6, ipv6_addr_size);
 }
 
 static int parse_nla_iif(struct nlattr **attrs, struct seg6_local_lwt *slwt)
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 98954830c40b..def625e97ba4 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1675,7 +1675,7 @@ static size_t ipip6_get_size(const struct net_device *dev)
 		nla_total_size(1) +
 #ifdef CONFIG_IPV6_SIT_6RD
 		/* IFLA_IPTUN_6RD_PREFIX */
-		nla_total_size(sizeof(struct in6_addr)) +
+		nla_total_size(ipv6_addr_size) +
 		/* IFLA_IPTUN_6RD_RELAY_PREFIX */
 		nla_total_size(4) +
 		/* IFLA_IPTUN_6RD_PREFIXLEN */
@@ -1751,7 +1751,7 @@ static const struct nla_policy ipip6_policy[IFLA_IPTUN_MAX + 1] = {
 	[IFLA_IPTUN_FLAGS]		= { .type = NLA_U16 },
 	[IFLA_IPTUN_PROTO]		= { .type = NLA_U8 },
 #ifdef CONFIG_IPV6_SIT_6RD
-	[IFLA_IPTUN_6RD_PREFIX]		= { .len = sizeof(struct in6_addr) },
+	[IFLA_IPTUN_6RD_PREFIX]		= { .len = ipv6_addr_size },
 	[IFLA_IPTUN_6RD_RELAY_PREFIX]	= { .type = NLA_U32 },
 	[IFLA_IPTUN_6RD_PREFIXLEN]	= { .type = NLA_U16 },
 	[IFLA_IPTUN_6RD_RELAY_PREFIXLEN] = { .type = NLA_U16 },
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e726159cfcfa..2347ba47007a 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1376,9 +1376,9 @@ static int parse_nat(const struct nlattr *attr,
 			[OVS_NAT_ATTR_SRC] = {0, 0},
 			[OVS_NAT_ATTR_DST] = {0, 0},
 			[OVS_NAT_ATTR_IP_MIN] = {sizeof(struct in_addr),
-						 sizeof(struct in6_addr)},
+						 ipv6_addr_size},
 			[OVS_NAT_ATTR_IP_MAX] = {sizeof(struct in_addr),
-						 sizeof(struct in6_addr)},
+						 ipv6_addr_size},
 			[OVS_NAT_ATTR_PROTO_MIN] = {sizeof(u16), sizeof(u16)},
 			[OVS_NAT_ATTR_PROTO_MAX] = {sizeof(u16), sizeof(u16)},
 			[OVS_NAT_ATTR_PERSISTENT] = {0, 0},
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 7da4230627f5..78ed78a8c331 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -389,8 +389,8 @@ static const struct ovs_len_tbl ovs_tunnel_key_lens[OVS_TUNNEL_KEY_ATTR_MAX + 1]
 	[OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS]   = { .len = OVS_ATTR_VARIABLE },
 	[OVS_TUNNEL_KEY_ATTR_VXLAN_OPTS]    = { .len = OVS_ATTR_NESTED,
 						.next = ovs_vxlan_ext_key_lens },
-	[OVS_TUNNEL_KEY_ATTR_IPV6_SRC]      = { .len = sizeof(struct in6_addr) },
-	[OVS_TUNNEL_KEY_ATTR_IPV6_DST]      = { .len = sizeof(struct in6_addr) },
+	[OVS_TUNNEL_KEY_ATTR_IPV6_SRC]      = { .len = ipv6_addr_size },
+	[OVS_TUNNEL_KEY_ATTR_IPV6_DST]      = { .len = ipv6_addr_size },
 	[OVS_TUNNEL_KEY_ATTR_ERSPAN_OPTS]   = { .len = OVS_ATTR_VARIABLE },
 	[OVS_TUNNEL_KEY_ATTR_IPV4_INFO_BRIDGE]   = { .len = 0 },
 };
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index b0f42e62dd76..60d5ad4110fe 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -610,10 +610,10 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_IPV4_SRC_MASK]	= { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_IPV4_DST]	= { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_IPV4_DST_MASK]	= { .type = NLA_U32 },
-	[TCA_FLOWER_KEY_IPV6_SRC]	= { .len = sizeof(struct in6_addr) },
-	[TCA_FLOWER_KEY_IPV6_SRC_MASK]	= { .len = sizeof(struct in6_addr) },
-	[TCA_FLOWER_KEY_IPV6_DST]	= { .len = sizeof(struct in6_addr) },
-	[TCA_FLOWER_KEY_IPV6_DST_MASK]	= { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_IPV6_SRC]	= { .len = ipv6_addr_size },
+	[TCA_FLOWER_KEY_IPV6_SRC_MASK]	= { .len = ipv6_addr_size },
+	[TCA_FLOWER_KEY_IPV6_DST]	= { .len = ipv6_addr_size },
+	[TCA_FLOWER_KEY_IPV6_DST_MASK]	= { .len = ipv6_addr_size },
 	[TCA_FLOWER_KEY_TCP_SRC]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_TCP_DST]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_UDP_SRC]	= { .type = NLA_U16 },
@@ -626,10 +626,10 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_ENC_IPV4_SRC_MASK] = { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_ENC_IPV4_DST]	= { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_ENC_IPV4_DST_MASK] = { .type = NLA_U32 },
-	[TCA_FLOWER_KEY_ENC_IPV6_SRC]	= { .len = sizeof(struct in6_addr) },
-	[TCA_FLOWER_KEY_ENC_IPV6_SRC_MASK] = { .len = sizeof(struct in6_addr) },
-	[TCA_FLOWER_KEY_ENC_IPV6_DST]	= { .len = sizeof(struct in6_addr) },
-	[TCA_FLOWER_KEY_ENC_IPV6_DST_MASK] = { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_ENC_IPV6_SRC]	= { .len = ipv6_addr_size },
+	[TCA_FLOWER_KEY_ENC_IPV6_SRC_MASK] = { .len = ipv6_addr_size },
+	[TCA_FLOWER_KEY_ENC_IPV6_DST]	= { .len = ipv6_addr_size },
+	[TCA_FLOWER_KEY_ENC_IPV6_DST_MASK] = { .len = ipv6_addr_size },
 	[TCA_FLOWER_KEY_TCP_SRC_MASK]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_TCP_DST_MASK]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_UDP_SRC_MASK]	= { .type = NLA_U16 },
diff --git a/net/socket.c b/net/socket.c
index b79a05de7c6e..e9e2e832b67d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3402,7 +3402,7 @@ static int routing_ioctl(struct net *net, struct socket *sock,
 	if (sock && sock->sk && sock->sk->sk_family == AF_INET6) { /* ipv6 */
 		struct in6_rtmsg32 __user *ur6 = argp;
 		ret = copy_from_user(&r6.rtmsg_dst, &(ur6->rtmsg_dst),
-			3 * sizeof(struct in6_addr));
+			3 * ipv6_addr_size);
 		ret |= get_user(r6.rtmsg_type, &(ur6->rtmsg_type));
 		ret |= get_user(r6.rtmsg_dst_len, &(ur6->rtmsg_dst_len));
 		ret |= get_user(r6.rtmsg_src_len, &(ur6->rtmsg_src_len));
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 9ab84efa46c7..24f1a7b47700 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -211,7 +211,7 @@ static int sel_netnode_sid_slow(void *addr, u16 family, u32 *sid)
 		break;
 	case PF_INET6:
 		ret = security_node_sid(&selinux_state, PF_INET6,
-					addr, sizeof(struct in6_addr), sid);
+					addr, ipv6_addr_size, sid);
 		if (new)
 			new->nsec.addr.ipv6 = *(struct in6_addr *)addr;
 		break;
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index beaa8b8c08ff..1f96c08eb02d 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4581,7 +4581,7 @@ static void print_ip6c_addr(struct trace_seq *s, unsigned char *addr)
 	bool useIPv4;
 	struct in6_addr in6;
 
-	memcpy(&in6, addr, sizeof(struct in6_addr));
+	memcpy(&in6, addr, ipv6_addr_size);
 
 	useIPv4 = ipv6_addr_v4mapped(&in6) || ipv6_addr_is_isatap(&in6);
 
diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
index 61fd95b89af8..ebc59e758326 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -1111,7 +1111,7 @@ static int cmp_addr(const struct sockaddr_storage *addr1,
 		six2 = (const struct sockaddr_in6 *)addr2;
 		return !((six1->sin6_port == six2->sin6_port || !cmp_port) &&
 			 !memcmp(&six1->sin6_addr, &six2->sin6_addr,
-				 sizeof(struct in6_addr)));
+				 ipv6_addr_size));
 	}
 
 	return -1;
diff --git a/tools/testing/selftests/networking/timestamping/txtimestamp.c b/tools/testing/selftests/networking/timestamping/txtimestamp.c
index 7e386be47120..f0435578c717 100644
--- a/tools/testing/selftests/networking/timestamping/txtimestamp.c
+++ b/tools/testing/selftests/networking/timestamping/txtimestamp.c
@@ -379,7 +379,7 @@ static void fill_header_udp(void *p, bool is_ipv4)
 	udph->check  = 0;
 
 	udph->check  = get_udp_csum(udph, is_ipv4 ? sizeof(struct in_addr) :
-						    sizeof(struct in6_addr));
+						    ipv6_addr_size);
 }
 
 static void do_test(int family, unsigned int report_opt)
-- 
2.24.1

