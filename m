Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6924A3E2A25
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343515AbhHFLwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:52:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33260 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343494AbhHFLwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 07:52:39 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id BDBD160060;
        Fri,  6 Aug 2021 13:51:43 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 8/9] netfilter: conntrack: remove offload_pickup sysctl again
Date:   Fri,  6 Aug 2021 13:52:06 +0200
Message-Id: <20210806115207.2976-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806115207.2976-1-pablo@netfilter.org>
References: <20210806115207.2976-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

These two sysctls were added because the hardcoded defaults (2 minutes,
tcp, 30 seconds, udp) turned out to be too low for some setups.

They appeared in 5.14-rc1 so it should be fine to remove it again.

Marcelo convinced me that there should be no difference between a flow
that was offloaded vs. a flow that was not wrt. timeout handling.
Thus the default is changed to those for TCP established and UDP stream,
5 days and 120 seconds, respectively.

Marcelo also suggested to account for the timeout value used for the
offloading, this avoids increase beyond the value in the conntrack-sysctl
and will also instantly expire the conntrack entry with altered sysctls.

Example:
   nf_conntrack_udp_timeout_stream=60
   nf_flowtable_udp_timeout=60

This will remove offloaded udp flows after one minute, rather than two.

An earlier version of this patch also cleared the ASSURED bit to
allow nf_conntrack to evict the entry via early_drop (i.e., table full).
However, it looks like we can safely assume that connection timed out
via HW is still in established state, so this isn't needed.

Quoting Oz:
 [..] the hardware sends all packets with a set FIN flags to sw.
 [..] Connections that are aged in hardware are expected to be in the
 established state.

In case it turns out that back-to-sw-path transition can occur for
'dodgy' connections too (e.g., one side disappeared while software-path
would have been in RETRANS timeout), we can adjust this later.

Cc: Oz Shlomo <ozsh@nvidia.com>
Cc: Paul Blakey <paulb@nvidia.com>
Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 10 ----------
 include/net/netns/conntrack.h                    |  2 --
 net/netfilter/nf_conntrack_proto_tcp.c           |  1 -
 net/netfilter/nf_conntrack_proto_udp.c           |  1 -
 net/netfilter/nf_conntrack_standalone.c          | 16 ----------------
 net/netfilter/nf_flow_table_core.c               | 11 ++++++++---
 6 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index d31ed6c1cb0d..024d784157c8 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -191,19 +191,9 @@ nf_flowtable_tcp_timeout - INTEGER (seconds)
         TCP connections may be offloaded from nf conntrack to nf flow table.
         Once aged, the connection is returned to nf conntrack with tcp pickup timeout.
 
-nf_flowtable_tcp_pickup - INTEGER (seconds)
-        default 120
-
-        TCP connection timeout after being aged from nf flow table offload.
-
 nf_flowtable_udp_timeout - INTEGER (seconds)
         default 30
 
         Control offload timeout for udp connections.
         UDP connections may be offloaded from nf conntrack to nf flow table.
         Once aged, the connection is returned to nf conntrack with udp pickup timeout.
-
-nf_flowtable_udp_pickup - INTEGER (seconds)
-        default 30
-
-        UDP connection timeout after being aged from nf flow table offload.
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 37e5300c7e5a..fefd38db95b3 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -30,7 +30,6 @@ struct nf_tcp_net {
 	u8 tcp_ignore_invalid_rst;
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	unsigned int offload_timeout;
-	unsigned int offload_pickup;
 #endif
 };
 
@@ -44,7 +43,6 @@ struct nf_udp_net {
 	unsigned int timeouts[UDP_CT_MAX];
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	unsigned int offload_timeout;
-	unsigned int offload_pickup;
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3259416f2ea4..af5115e127cf 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1478,7 +1478,6 @@ void nf_conntrack_tcp_init_net(struct net *net)
 
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	tn->offload_timeout = 30 * HZ;
-	tn->offload_pickup = 120 * HZ;
 #endif
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 698fee49e732..f8e3c0d2602f 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -271,7 +271,6 @@ void nf_conntrack_udp_init_net(struct net *net)
 
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	un->offload_timeout = 30 * HZ;
-	un->offload_pickup = 30 * HZ;
 #endif
 }
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 214d9f9e499b..e84b499b7bfa 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -575,7 +575,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_UNACK,
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP,
 #endif
 	NF_SYSCTL_CT_PROTO_TCP_LOOSE,
 	NF_SYSCTL_CT_PROTO_TCP_LIBERAL,
@@ -585,7 +584,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM,
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP,
 #endif
 	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6,
@@ -776,12 +774,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP] = {
-		.procname	= "nf_flowtable_tcp_pickup",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
 #endif
 	[NF_SYSCTL_CT_PROTO_TCP_LOOSE] = {
 		.procname	= "nf_conntrack_tcp_loose",
@@ -832,12 +824,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP] = {
-		.procname	= "nf_flowtable_udp_pickup",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
 #endif
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP] = {
 		.procname	= "nf_conntrack_icmp_timeout",
@@ -1018,7 +1004,6 @@ static void nf_conntrack_standalone_init_tcp_sysctl(struct net *net,
 
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD].data = &tn->offload_timeout;
-	table[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP].data = &tn->offload_pickup;
 #endif
 
 }
@@ -1111,7 +1096,6 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM].data = &un->timeouts[UDP_CT_REPLIED];
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
-	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP].data = &un->offload_pickup;
 #endif
 
 	nf_conntrack_standalone_init_tcp_sysctl(net, table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 551976e4284c..8788b519255e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -183,7 +183,7 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 	const struct nf_conntrack_l4proto *l4proto;
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
-	unsigned int timeout;
+	s32 timeout;
 
 	l4proto = nf_ct_l4proto_find(l4num);
 	if (!l4proto)
@@ -192,15 +192,20 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
 
-		timeout = tn->offload_pickup;
+		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
+		timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
 
-		timeout = tn->offload_pickup;
+		timeout = tn->timeouts[UDP_CT_REPLIED];
+		timeout -= tn->offload_timeout;
 	} else {
 		return;
 	}
 
+	if (timeout < 0)
+		timeout = 0;
+
 	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
 		ct->timeout = nfct_time_stamp + timeout;
 }
-- 
2.20.1

