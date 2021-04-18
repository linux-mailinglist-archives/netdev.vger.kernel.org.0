Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CAF3637B2
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhDRVFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:05:04 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34980 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhDRVE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:56 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 569F663E89;
        Sun, 18 Apr 2021 23:03:57 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/14] netfilter: conntrack: convert sysctls to u8
Date:   Sun, 18 Apr 2021 23:04:08 +0200
Message-Id: <20210418210415.4719-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

log_invalid sysctl allows values of 0 to 255 inclusive so we no longer
need a range check: the min/max values can be removed.

This also removes all member variables that were moved to net_generic
data in previous patches.

This reduces size of netns_ct struct by one cache line.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/conntrack.h           | 23 ++++++--------
 net/netfilter/nf_conntrack_proto_tcp.c  | 34 ++++++++++----------
 net/netfilter/nf_conntrack_standalone.c | 42 +++++++++++--------------
 3 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index e5f664d69ead..ad0a95c2335e 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -24,9 +24,9 @@ struct nf_generic_net {
 
 struct nf_tcp_net {
 	unsigned int timeouts[TCP_CONNTRACK_TIMEOUT_MAX];
-	int tcp_loose;
-	int tcp_be_liberal;
-	int tcp_max_retrans;
+	u8 tcp_loose;
+	u8 tcp_be_liberal;
+	u8 tcp_max_retrans;
 };
 
 enum udp_conntrack {
@@ -45,7 +45,7 @@ struct nf_icmp_net {
 
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 struct nf_dccp_net {
-	int dccp_loose;
+	u8 dccp_loose;
 	unsigned int dccp_timeout[CT_DCCP_MAX + 1];
 };
 #endif
@@ -93,18 +93,15 @@ struct ct_pcpu {
 };
 
 struct netns_ct {
-	atomic_t		count;
-	unsigned int		expect_count;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	bool ecache_dwork_pending;
 #endif
-	bool			auto_assign_helper_warned;
-	unsigned int		sysctl_log_invalid; /* Log invalid packets */
-	int			sysctl_events;
-	int			sysctl_acct;
-	int			sysctl_auto_assign_helper;
-	int			sysctl_tstamp;
-	int			sysctl_checksum;
+	u8			sysctl_log_invalid; /* Log invalid packets */
+	u8			sysctl_events;
+	u8			sysctl_acct;
+	u8			sysctl_auto_assign_helper;
+	u8			sysctl_tstamp;
+	u8			sysctl_checksum;
 
 	struct ct_pcpu __percpu *pcpu_lists;
 	struct ip_conntrack_stat __percpu *stat;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ec23330687a5..318b8f723349 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -31,20 +31,6 @@
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
-/* "Be conservative in what you do,
-    be liberal in what you accept from others."
-    If it's non-zero, we mark only out of window RST segments as INVALID. */
-static int nf_ct_tcp_be_liberal __read_mostly = 0;
-
-/* If it is set to zero, we disable picking up already established
-   connections. */
-static int nf_ct_tcp_loose __read_mostly = 1;
-
-/* Max number of the retransmitted packets without receiving an (acceptable)
-   ACK from the destination. If this number is reached, a shorter timer
-   will be started. */
-static int nf_ct_tcp_max_retrans __read_mostly = 3;
-
   /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
      closely.  They're more complex. --RR */
 
@@ -1436,9 +1422,23 @@ void nf_conntrack_tcp_init_net(struct net *net)
 	 * ->timeouts[0] contains 'new' timeout, like udp or icmp.
 	 */
 	tn->timeouts[0] = tcp_timeouts[TCP_CONNTRACK_SYN_SENT];
-	tn->tcp_loose = nf_ct_tcp_loose;
-	tn->tcp_be_liberal = nf_ct_tcp_be_liberal;
-	tn->tcp_max_retrans = nf_ct_tcp_max_retrans;
+
+	/* If it is set to zero, we disable picking up already established
+	 * connections.
+	 */
+	tn->tcp_loose = 1;
+
+	/* "Be conservative in what you do,
+	 *  be liberal in what you accept from others."
+	 * If it's non-zero, we mark only out of window RST segments as INVALID.
+	 */
+	tn->tcp_be_liberal = 0;
+
+	/* Max number of the retransmitted packets without receiving an (acceptable)
+	 * ACK from the destination. If this number is reached, a shorter timer
+	 * will be started.
+	 */
+	tn->tcp_max_retrans = 3;
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp =
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index fb89f6e5c8bc..fe99605444be 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -522,10 +522,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_count);
 /* Sysctl support */
 
 #ifdef CONFIG_SYSCTL
-/* Log invalid packets of a given protocol */
-static int log_invalid_proto_min __read_mostly;
-static int log_invalid_proto_max __read_mostly = 255;
-
 /* size the user *wants to set */
 static unsigned int nf_conntrack_htable_size_user __read_mostly;
 
@@ -640,20 +636,18 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_CHECKSUM] = {
 		.procname	= "nf_conntrack_checksum",
 		.data		= &init_net.ct.sysctl_checksum,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_LOG_INVALID] = {
 		.procname	= "nf_conntrack_log_invalid",
 		.data		= &init_net.ct.sysctl_log_invalid,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &log_invalid_proto_min,
-		.extra2		= &log_invalid_proto_max,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	[NF_SYSCTL_CT_EXPECT_MAX] = {
 		.procname	= "nf_conntrack_expect_max",
@@ -665,9 +659,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_ACCT] = {
 		.procname	= "nf_conntrack_acct",
 		.data		= &init_net.ct.sysctl_acct,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
@@ -683,9 +677,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_EVENTS] = {
 		.procname	= "nf_conntrack_events",
 		.data		= &init_net.ct.sysctl_events,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
@@ -694,9 +688,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_TIMESTAMP] = {
 		.procname	= "nf_conntrack_timestamp",
 		.data		= &init_net.ct.sysctl_tstamp,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
@@ -769,25 +763,25 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LOOSE] = {
 		.procname	= "nf_conntrack_tcp_loose",
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LIBERAL] = {
 		.procname       = "nf_conntrack_tcp_be_liberal",
-		.maxlen         = sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode           = 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
 		.procname	= "nf_conntrack_tcp_max_retrans",
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP] = {
 		.procname	= "nf_conntrack_udp_timeout",
@@ -914,9 +908,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_PROTO_DCCP_LOOSE] = {
 		.procname	= "nf_conntrack_dccp_loose",
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
-- 
2.30.2

