Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317233A1F41
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFIVrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60500 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhFIVra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:30 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 49FC064233;
        Wed,  9 Jun 2021 23:44:21 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/13] netfilter: conntrack: Introduce udp offload timeout configuration
Date:   Wed,  9 Jun 2021 23:45:16 +0200
Message-Id: <20210609214523.1678-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

UDP connections may be offloaded from nf conntrack to nf flow table.
Offloaded connections are aged after 30 seconds of inactivity.
Once aged, ownership is returned to conntrack with a hard coded pickup
time of 30 seconds, after which the connection may be deleted.
eted. The current aging intervals may be too aggressive for some users.

Provide users with the ability to control the nf flow table offload
aging and pickup time intervals via sysctl parameter as a pre-step for
configuring the nf flow table GC timeout intervals.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/conntrack.h           |  4 ++++
 net/netfilter/nf_conntrack_proto_udp.c  |  5 +++++
 net/netfilter/nf_conntrack_standalone.c | 22 ++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 3a391e27ec60..c3094b83a525 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -41,6 +41,10 @@ enum udp_conntrack {
 
 struct nf_udp_net {
 	unsigned int timeouts[UDP_CT_MAX];
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	unsigned int offload_timeout;
+	unsigned int offload_pickup;
+#endif
 };
 
 struct nf_icmp_net {
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index af402f458ee0..68911fcaa0f1 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -270,6 +270,11 @@ void nf_conntrack_udp_init_net(struct net *net)
 
 	for (i = 0; i < UDP_CT_MAX; i++)
 		un->timeouts[i] = udp_timeouts[i];
+
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	un->offload_timeout = 30 * HZ;
+	un->offload_pickup = 30 * HZ;
+#endif
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp =
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 67b0fcd1a787..f57a951c9b5e 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -582,6 +582,10 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM,
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP,
+#endif
 	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6,
 #ifdef CONFIG_NF_CT_PROTO_SCTP
@@ -812,6 +816,20 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
+#if IS_ENABLED(CONFIG_NFT_FLOW_OFFLOAD)
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD] = {
+		.procname	= "nf_flowtable_udp_timeout",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP] = {
+		.procname	= "nf_flowtable_udp_pickup",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+#endif
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP] = {
 		.procname	= "nf_conntrack_icmp_timeout",
 		.maxlen		= sizeof(unsigned int),
@@ -1081,6 +1099,10 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6].data = &nf_icmpv6_pernet(net)->timeout;
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP].data = &un->timeouts[UDP_CT_UNREPLIED];
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM].data = &un->timeouts[UDP_CT_REPLIED];
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP].data = &un->offload_pickup;
+#endif
 
 	nf_conntrack_standalone_init_tcp_sysctl(net, table);
 	nf_conntrack_standalone_init_sctp_sysctl(net, table);
-- 
2.30.2

