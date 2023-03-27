Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83906CB2B0
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 01:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjC0Xzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 19:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbjC0Xzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 19:55:45 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA9A1BDA
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 16:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679961336; x=1711497336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ldfbi1BTK4HUlopd/5hBmy/Th+xkKSfT11/w4HtWuv4=;
  b=gw9a3Tw/XAZay4QlaWbStwzFcV3lSNvhi70a8RxUbfxRNN+5zJhiXYxc
   UclhFzyIhl3e83WDmSYNsbwZvgJQvC2u9g/hDe2SU5QWaW7WvXyvXcCEA
   IXSOFjI9obMhm7gbXQ71LBzH3qAttN/HiwrMpxNaluIP8A11kI878+Fkn
   E=;
X-IronPort-AV: E=Sophos;i="5.98,295,1673913600"; 
   d="scan'208";a="198063015"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 23:55:34 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id 89BF4810C3;
        Mon, 27 Mar 2023 23:55:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 27 Mar 2023 23:55:32 +0000
Received: from 88665a182662.ant.amazon.com (10.119.220.254) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 27 Mar 2023 23:55:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 1/2] ipv6: Remove in6addr_any alternatives.
Date:   Mon, 27 Mar 2023 16:54:54 -0700
Message-ID: <20230327235455.52990-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230327235455.52990-1-kuniyu@amazon.com>
References: <20230327235455.52990-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.220.254]
X-ClientProxiedBy: EX19D038UWB004.ant.amazon.com (10.13.139.177) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some code defines the IPv6 wildcard address as a local variable and
use it with memcmp() or ipv6_addr_equal().

Let's use in6addr_any and ipv6_addr_any() instead.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c |  5 ++---
 include/net/ip6_fib.h                                 |  9 +++------
 include/trace/events/fib.h                            |  5 ++---
 include/trace/events/fib6.h                           |  5 +----
 net/ethtool/ioctl.c                                   | 10 +++++-----
 net/ipv4/inet_hashtables.c                            | 11 ++++-------
 6 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index a108e73c9f66..20c2d2ecaf93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -98,7 +98,6 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 	else if (ip_version == 6) {
 		int ipv6_size = MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6);
-		struct in6_addr zerov6 = {};
 
 		daddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				     outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6);
@@ -106,8 +105,8 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
 				     outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6);
 		memcpy(&tun_attr->dst_ip.v6, daddr, ipv6_size);
 		memcpy(&tun_attr->src_ip.v6, saddr, ipv6_size);
-		if (!memcmp(&tun_attr->dst_ip.v6, &zerov6, sizeof(zerov6)) ||
-		    !memcmp(&tun_attr->src_ip.v6, &zerov6, sizeof(zerov6)))
+		if (ipv6_addr_any(&tun_attr->dst_ip.v6) ||
+		    ipv6_addr_any(&tun_attr->src_ip.v6))
 			return 0;
 	}
 #endif
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 6268963d9599..6f21d37a07c3 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -472,13 +472,10 @@ void rt6_get_prefsrc(const struct rt6_info *rt, struct in6_addr *addr)
 	rcu_read_lock();
 
 	from = rcu_dereference(rt->from);
-	if (from) {
+	if (from)
 		*addr = from->fib6_prefsrc.addr;
-	} else {
-		struct in6_addr in6_zero = {};
-
-		*addr = in6_zero;
-	}
+	else
+		*addr = in6addr_any;
 
 	rcu_read_unlock();
 }
diff --git a/include/trace/events/fib.h b/include/trace/events/fib.h
index c2300c407f58..76297ecd4935 100644
--- a/include/trace/events/fib.h
+++ b/include/trace/events/fib.h
@@ -36,7 +36,6 @@ TRACE_EVENT(fib_table_lookup,
 	),
 
 	TP_fast_assign(
-		struct in6_addr in6_zero = {};
 		struct net_device *dev;
 		struct in6_addr *in6;
 		__be32 *p32;
@@ -74,7 +73,7 @@ TRACE_EVENT(fib_table_lookup,
 				*p32 = nhc->nhc_gw.ipv4;
 
 				in6 = (struct in6_addr *)__entry->gw6;
-				*in6 = in6_zero;
+				*in6 = in6addr_any;
 			} else if (nhc->nhc_gw_family == AF_INET6) {
 				p32 = (__be32 *) __entry->gw4;
 				*p32 = 0;
@@ -87,7 +86,7 @@ TRACE_EVENT(fib_table_lookup,
 			*p32 = 0;
 
 			in6 = (struct in6_addr *)__entry->gw6;
-			*in6 = in6_zero;
+			*in6 = in6addr_any;
 		}
 	),
 
diff --git a/include/trace/events/fib6.h b/include/trace/events/fib6.h
index 6e821eb79450..4d3e607b3cde 100644
--- a/include/trace/events/fib6.h
+++ b/include/trace/events/fib6.h
@@ -68,11 +68,8 @@ TRACE_EVENT(fib6_table_lookup,
 			strcpy(__entry->name, "-");
 		}
 		if (res->f6i == net->ipv6.fib6_null_entry) {
-			struct in6_addr in6_zero = {};
-
 			in6 = (struct in6_addr *)__entry->gw;
-			*in6 = in6_zero;
-
+			*in6 = in6addr_any;
 		} else if (res->nh) {
 			in6 = (struct in6_addr *)__entry->gw;
 			*in6 = res->nh->fib_nh_gw6;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 646b3e490c71..59adc4e6e9ee 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -27,6 +27,7 @@
 #include <linux/net.h>
 #include <linux/pm_runtime.h>
 #include <net/devlink.h>
+#include <net/ipv6.h>
 #include <net/xdp_sock_drv.h>
 #include <net/flow_offload.h>
 #include <linux/ethtool_netlink.h>
@@ -3127,7 +3128,6 @@ struct ethtool_rx_flow_rule *
 ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
 {
 	const struct ethtool_rx_flow_spec *fs = input->fs;
-	static struct in6_addr zero_addr = {};
 	struct ethtool_rx_flow_match *match;
 	struct ethtool_rx_flow_rule *flow;
 	struct flow_action_entry *act;
@@ -3233,20 +3233,20 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
 
 		v6_spec = &fs->h_u.tcp_ip6_spec;
 		v6_m_spec = &fs->m_u.tcp_ip6_spec;
-		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr))) {
+		if (!ipv6_addr_any((struct in6_addr *)v6_m_spec->ip6src)) {
 			memcpy(&match->key.ipv6.src, v6_spec->ip6src,
 			       sizeof(match->key.ipv6.src));
 			memcpy(&match->mask.ipv6.src, v6_m_spec->ip6src,
 			       sizeof(match->mask.ipv6.src));
 		}
-		if (memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
+		if (!ipv6_addr_any((struct in6_addr *)v6_m_spec->ip6dst)) {
 			memcpy(&match->key.ipv6.dst, v6_spec->ip6dst,
 			       sizeof(match->key.ipv6.dst));
 			memcpy(&match->mask.ipv6.dst, v6_m_spec->ip6dst,
 			       sizeof(match->mask.ipv6.dst));
 		}
-		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr)) ||
-		    memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
+		if (!ipv6_addr_any((struct in6_addr *)v6_m_spec->ip6src) ||
+		    !ipv6_addr_any((struct in6_addr *)v6_m_spec->ip6dst)) {
 			match->dissector.used_keys |=
 				BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 			match->dissector.offset[FLOW_DISSECTOR_KEY_IPV6_ADDRS] =
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 6edae3886885..e7391bf310a7 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -826,13 +826,11 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
 				      unsigned short port, int l3mdev, const struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	struct in6_addr addr_any = {};
-
 	if (sk->sk_family != tb->family) {
 		if (sk->sk_family == AF_INET)
 			return net_eq(ib2_net(tb), net) && tb->port == port &&
 				tb->l3mdev == l3mdev &&
-				ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
+				ipv6_addr_any(&tb->v6_rcv_saddr);
 
 		return false;
 	}
@@ -840,7 +838,7 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
 	if (sk->sk_family == AF_INET6)
 		return net_eq(ib2_net(tb), net) && tb->port == port &&
 			tb->l3mdev == l3mdev &&
-			ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
+			ipv6_addr_any(&tb->v6_rcv_saddr);
 	else
 #endif
 		return net_eq(ib2_net(tb), net) && tb->port == port &&
@@ -866,11 +864,10 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
 {
 	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
 	u32 hash;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct in6_addr addr_any = {};
 
+#if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == AF_INET6)
-		hash = ipv6_portaddr_hash(net, &addr_any, port);
+		hash = ipv6_portaddr_hash(net, &in6addr_any, port);
 	else
 #endif
 		hash = ipv4_portaddr_hash(net, 0, port);
-- 
2.30.2

