Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15FE3A1F3E
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhFIVrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60498 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhFIVra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:30 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A391564230;
        Wed,  9 Jun 2021 23:44:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/13] netfilter: conntrack: Introduce tcp offload timeout configuration
Date:   Wed,  9 Jun 2021 23:45:15 +0200
Message-Id: <20210609214523.1678-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

TCP connections may be offloaded from nf conntrack to nf flow table.
Offloaded connections are aged after 30 seconds of inactivity.
Once aged, ownership is returned to conntrack with a hard coded pickup
time of 120 seconds, after which the connection may be deleted.
eted. The current aging intervals may be too aggressive for some users.

Provide users with the ability to control the nf flow table offload
aging and pickup time intervals via sysctl parameter as a pre-step for
configuring the nf flow table GC timeout intervals.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/conntrack.h           |  4 ++++
 net/netfilter/nf_conntrack_proto_tcp.c  |  5 +++++
 net/netfilter/nf_conntrack_standalone.c | 24 ++++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index ad0a95c2335e..3a391e27ec60 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -27,6 +27,10 @@ struct nf_tcp_net {
 	u8 tcp_loose;
 	u8 tcp_be_liberal;
 	u8 tcp_max_retrans;
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	unsigned int offload_timeout;
+	unsigned int offload_pickup;
+#endif
 };
 
 enum udp_conntrack {
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 34e22416a721..de840fc41a2e 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1441,6 +1441,11 @@ void nf_conntrack_tcp_init_net(struct net *net)
 	 * will be started.
 	 */
 	tn->tcp_max_retrans = 3;
+
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	tn->offload_timeout = 30 * HZ;
+	tn->offload_pickup = 120 * HZ;
+#endif
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp =
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index bce93656fad9..67b0fcd1a787 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -573,6 +573,10 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_CLOSE,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_RETRANS,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_UNACK,
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP,
+#endif
 	NF_SYSCTL_CT_PROTO_TCP_LOOSE,
 	NF_SYSCTL_CT_PROTO_TCP_LIBERAL,
 	NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS,
@@ -760,6 +764,20 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD] = {
+		.procname	= "nf_flowtable_tcp_timeout",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP] = {
+		.procname	= "nf_flowtable_tcp_pickup",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+#endif
 	[NF_SYSCTL_CT_PROTO_TCP_LOOSE] = {
 		.procname	= "nf_conntrack_tcp_loose",
 		.maxlen		= sizeof(u8),
@@ -969,6 +987,12 @@ static void nf_conntrack_standalone_init_tcp_sysctl(struct net *net,
 	XASSIGN(LIBERAL, &tn->tcp_be_liberal);
 	XASSIGN(MAX_RETRANS, &tn->tcp_max_retrans);
 #undef XASSIGN
+
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD].data = &tn->offload_timeout;
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP].data = &tn->offload_pickup;
+#endif
+
 }
 
 static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
-- 
2.30.2

