Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D1B3BEBF6
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhGGQVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:21:43 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55154 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhGGQVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:21:35 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 764AD62441;
        Wed,  7 Jul 2021 18:18:42 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 07/11] netfilter: conntrack: add new sysctl to disable RST check
Date:   Wed,  7 Jul 2021 18:18:40 +0200
Message-Id: <20210707161844.20827-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210707161844.20827-1-pablo@netfilter.org>
References: <20210707161844.20827-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ali Abdallah <ali.abdallah@suse.com>

This patch adds a new sysctl tcp_ignore_invalid_rst to disable marking
out of segments RSTs as INVALID.

Signed-off-by: Ali Abdallah <aabdallah@suse.de>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_conntrack-sysctl.rst |  6 ++++++
 include/net/netns/conntrack.h                    |  1 +
 net/netfilter/nf_conntrack_proto_tcp.c           |  6 +++++-
 net/netfilter/nf_conntrack_standalone.c          | 10 ++++++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 0467b30e4abe..d31ed6c1cb0d 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -110,6 +110,12 @@ nf_conntrack_tcp_be_liberal - BOOLEAN
 	Be conservative in what you do, be liberal in what you accept from others.
 	If it's non-zero, we mark only out of window RST segments as INVALID.
 
+nf_conntrack_tcp_ignore_invalid_rst - BOOLEAN
+	- 0 - disabled (default)
+	- 1 - enabled
+
+	If it's 1, we don't mark out of window RST segments as INVALID.
+
 nf_conntrack_tcp_loose - BOOLEAN
 	- 0 - disabled
 	- not 0 - enabled (default)
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index c3094b83a525..37e5300c7e5a 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -27,6 +27,7 @@ struct nf_tcp_net {
 	u8 tcp_loose;
 	u8 tcp_be_liberal;
 	u8 tcp_max_retrans;
+	u8 tcp_ignore_invalid_rst;
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	unsigned int offload_timeout;
 	unsigned int offload_pickup;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b8ff67671e93..3259416f2ea4 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1068,7 +1068,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			if (seq == 0 && !nf_conntrack_tcp_established(ct))
 				break;
 
-			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack)) {
+			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack) &&
+			    !tn->tcp_ignore_invalid_rst) {
 				/* Invalid RST  */
 				spin_unlock_bh(&ct->lock);
 				nf_ct_l4proto_log_invalid(skb, ct, state, "invalid rst");
@@ -1466,6 +1467,9 @@ void nf_conntrack_tcp_init_net(struct net *net)
 	 */
 	tn->tcp_be_liberal = 0;
 
+	/* If it's non-zero, we turn off RST sequence number check */
+	tn->tcp_ignore_invalid_rst = 0;
+
 	/* Max number of the retransmitted packets without receiving an (acceptable)
 	 * ACK from the destination. If this number is reached, a shorter timer
 	 * will be started.
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f57a951c9b5e..214d9f9e499b 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -579,6 +579,7 @@ enum nf_ct_sysctl_index {
 #endif
 	NF_SYSCTL_CT_PROTO_TCP_LOOSE,
 	NF_SYSCTL_CT_PROTO_TCP_LIBERAL,
+	NF_SYSCTL_CT_PROTO_TCP_IGNORE_INVALID_RST,
 	NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM,
@@ -798,6 +799,14 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
+	[NF_SYSCTL_CT_PROTO_TCP_IGNORE_INVALID_RST] = {
+		.procname	= "nf_conntrack_tcp_ignore_invalid_rst",
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
 		.procname	= "nf_conntrack_tcp_max_retrans",
 		.maxlen		= sizeof(u8),
@@ -1004,6 +1013,7 @@ static void nf_conntrack_standalone_init_tcp_sysctl(struct net *net,
 	XASSIGN(LOOSE, &tn->tcp_loose);
 	XASSIGN(LIBERAL, &tn->tcp_be_liberal);
 	XASSIGN(MAX_RETRANS, &tn->tcp_max_retrans);
+	XASSIGN(IGNORE_INVALID_RST, &tn->tcp_ignore_invalid_rst);
 #undef XASSIGN
 
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
-- 
2.20.1

