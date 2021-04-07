Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A113573FC
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355129AbhDGSKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:10:45 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:32878 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229876AbhDGSKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 14:10:43 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 14:10:38 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 137I49dd014753
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 7 Apr 2021 20:04:10 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC net-next 1/1] seg6: add counters support for SRv6 Behaviors
Date:   Wed,  7 Apr 2021 20:03:32 +0200
Message-Id: <20210407180332.29775-2-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210407180332.29775-1-andrea.mayer@uniroma2.it>
References: <20210407180332.29775-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides counters for SRv6 Behaviors as defined in [1], section
6. For each SRv6 Behavior instance, the counters defined in [1] are:

 - the total number of packets that have been correctly processed;
 - the total amount of traffic in bytes of all packets that have been
   correctly processed;

In addition, we introduces a new counter that counts the number of packets
that have NOT been properly processed (i.e. errors) by an SRv6 Behavior
instance.

Each SRv6 Behavior instance can be configured, at the time of its creation,
to make use of counters.
This is done through iproute2 which allows the user to create an SRv6
Behavior instance specifying the optional "count" attribute as shown in the
following example:

 $ ip -6 route add 2001:db8::1 encap seg6local action End count dev eth0

per-behavior counters can be shown by adding "-s" to the iproute2 command
line, i.e.:

 $ ip -s -6 route show 2001:db8::1
 2001:db8::1 encap seg6local action End packets 0 bytes 0 errors 0 dev eth0

[1] https://www.rfc-editor.org/rfc/rfc8986.html#name-counters

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 include/uapi/linux/seg6_local.h |   8 ++
 net/ipv6/seg6_local.c           | 133 +++++++++++++++++++++++++++++++-
 2 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index 3b39ef1dbb46..ae5e3fd12b73 100644
--- a/include/uapi/linux/seg6_local.h
+++ b/include/uapi/linux/seg6_local.h
@@ -27,6 +27,7 @@ enum {
 	SEG6_LOCAL_OIF,
 	SEG6_LOCAL_BPF,
 	SEG6_LOCAL_VRFTABLE,
+	SEG6_LOCAL_COUNTERS,
 	__SEG6_LOCAL_MAX,
 };
 #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
@@ -78,4 +79,11 @@ enum {
 
 #define SEG6_LOCAL_BPF_PROG_MAX (__SEG6_LOCAL_BPF_PROG_MAX - 1)
 
+/* SRv6 Behavior counters */
+struct seg6_local_counters {
+	__u64 rx_packets;
+	__u64 rx_bytes;
+	__u64 rx_errors;
+};
+
 #endif
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 8936f48570fc..0f905a4410bd 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -93,6 +93,20 @@ struct seg6_end_dt_info {
 	int hdrlen;
 };
 
+struct pcpu_seg6_local_counters {
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	u64_stats_t rx_errors;
+
+	struct u64_stats_sync syncp;
+};
+
+#define seg6_local_alloc_pcpu_counters(__gfp)				\
+	__netdev_alloc_pcpu_stats(struct pcpu_seg6_local_counters,	\
+				  ((__gfp) | __GFP_ZERO))
+
+#define SEG6_F_LOCAL_COUNTERS	SEG6_F_ATTR(SEG6_LOCAL_COUNTERS)
+
 struct seg6_local_lwt {
 	int action;
 	struct ipv6_sr_hdr *srh;
@@ -105,6 +119,7 @@ struct seg6_local_lwt {
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct seg6_end_dt_info dt_info;
 #endif
+	struct pcpu_seg6_local_counters __percpu *pcpu_counters;
 
 	int headroom;
 	struct seg6_action_desc *desc;
@@ -878,36 +893,43 @@ static struct seg6_action_desc seg6_action_table[] = {
 	{
 		.action		= SEG6_LOCAL_ACTION_END,
 		.attrs		= 0,
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 		.input		= input_action_end,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_X,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_NH6),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 		.input		= input_action_end_x,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_T,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_TABLE),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 		.input		= input_action_end_t,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DX2,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_OIF),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 		.input		= input_action_end_dx2,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DX6,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_NH6),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 		.input		= input_action_end_dx6,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DX4,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_NH4),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 		.input		= input_action_end_dx4,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DT4,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 #ifdef CONFIG_NET_L3_MASTER_DEV
 		.input		= input_action_end_dt4,
 		.slwt_ops	= {
@@ -919,30 +941,35 @@ static struct seg6_action_desc seg6_action_table[] = {
 		.action		= SEG6_LOCAL_ACTION_END_DT6,
 #ifdef CONFIG_NET_L3_MASTER_DEV
 		.attrs		= 0,
-		.optattrs	= SEG6_F_ATTR(SEG6_LOCAL_TABLE) |
+		.optattrs	= SEG6_F_LOCAL_COUNTERS		|
+				  SEG6_F_ATTR(SEG6_LOCAL_TABLE) |
 				  SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE),
 		.slwt_ops	= {
 					.build_state = seg6_end_dt6_build,
 				  },
 #else
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_TABLE),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 #endif
 		.input		= input_action_end_dt6,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_B6,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_SRH),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 		.input		= input_action_end_b6,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_B6_ENCAP,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_SRH),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 		.input		= input_action_end_b6_encap,
 		.static_headroom	= sizeof(struct ipv6hdr),
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_BPF,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_BPF),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
 		.input		= input_action_end_bpf,
 	},
 
@@ -963,11 +990,36 @@ static struct seg6_action_desc *__get_action_desc(int action)
 	return NULL;
 }
 
+static bool seg6_lwtunnel_counters_enabled(struct seg6_local_lwt *slwt)
+{
+	return slwt->parsed_optattrs & SEG6_F_LOCAL_COUNTERS;
+}
+
+static void seg6_local_update_rx_counters(struct seg6_local_lwt *slwt,
+					  int len, int err)
+{
+	struct pcpu_seg6_local_counters *pcounters;
+
+	pcounters = this_cpu_ptr(slwt->pcpu_counters);
+	u64_stats_update_begin(&pcounters->syncp);
+
+	if (likely(!err)) {
+		u64_stats_inc(&pcounters->rx_packets);
+		u64_stats_add(&pcounters->rx_bytes, len);
+	} else {
+		u64_stats_inc(&pcounters->rx_errors);
+	}
+
+	u64_stats_update_end(&pcounters->syncp);
+}
+
 static int seg6_local_input(struct sk_buff *skb)
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct seg6_action_desc *desc;
 	struct seg6_local_lwt *slwt;
+	int len = skb->len;
+	int rc;
 
 	if (skb->protocol != htons(ETH_P_IPV6)) {
 		kfree_skb(skb);
@@ -977,7 +1029,14 @@ static int seg6_local_input(struct sk_buff *skb)
 	slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
 	desc = slwt->desc;
 
-	return desc->input(skb, slwt);
+	rc = desc->input(skb, slwt);
+
+	if (!seg6_lwtunnel_counters_enabled(slwt))
+		return rc;
+
+	seg6_local_update_rx_counters(slwt, len, rc);
+
+	return rc;
 }
 
 static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
@@ -992,6 +1051,8 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_IIF]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_OIF]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_BPF]	= { .type = NLA_NESTED },
+	[SEG6_LOCAL_COUNTERS]	= { .type = NLA_BINARY,
+				    .len = sizeof(struct seg6_local_counters) },
 };
 
 static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt)
@@ -1296,6 +1357,67 @@ static void destroy_attr_bpf(struct seg6_local_lwt *slwt)
 		bpf_prog_put(slwt->bpf.prog);
 }
 
+static int parse_nla_counters(struct nlattr **attrs,
+			      struct seg6_local_lwt *slwt)
+{
+	struct pcpu_seg6_local_counters __percpu *pcounters;
+
+	pcounters = seg6_local_alloc_pcpu_counters(GFP_KERNEL);
+	if (!pcounters)
+		return -ENOMEM;
+
+	slwt->pcpu_counters = pcounters;
+
+	return 0;
+}
+
+static int put_nla_counters(struct sk_buff *skb, struct seg6_local_lwt *slwt)
+{
+	struct seg6_local_counters counters = { 0, 0, 0 };
+	struct nlattr *nla;
+	int i;
+
+	nla = nla_reserve(skb, SEG6_LOCAL_COUNTERS, sizeof(counters));
+	if (!nla)
+		return -EMSGSIZE;
+
+	for_each_possible_cpu(i) {
+		struct pcpu_seg6_local_counters *pcounters;
+		u64 rx_packets, rx_bytes, rx_errors;
+		unsigned int start;
+
+		pcounters = per_cpu_ptr(slwt->pcpu_counters, i);
+		do {
+			start = u64_stats_fetch_begin_irq(&pcounters->syncp);
+
+			rx_packets = u64_stats_read(&pcounters->rx_packets);
+			rx_bytes = u64_stats_read(&pcounters->rx_bytes);
+			rx_errors = u64_stats_read(&pcounters->rx_errors);
+
+		} while (u64_stats_fetch_retry_irq(&pcounters->syncp, start));
+
+		counters.rx_packets += rx_packets;
+		counters.rx_bytes += rx_bytes;
+		counters.rx_errors += rx_errors;
+	}
+
+	memcpy(nla_data(nla), &counters, sizeof(counters));
+
+	return 0;
+}
+
+static int cmp_nla_counters(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
+{
+	/* a and b are equals if both have pcpu_counters set or not */
+	return (!!((unsigned long)a->pcpu_counters)) ^
+		(!!((unsigned long)b->pcpu_counters));
+}
+
+static void destroy_attr_counters(struct seg6_local_lwt *slwt)
+{
+	free_percpu(slwt->pcpu_counters);
+}
+
 struct seg6_action_param {
 	int (*parse)(struct nlattr **attrs, struct seg6_local_lwt *slwt);
 	int (*put)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
@@ -1343,6 +1465,10 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 				    .put = put_nla_vrftable,
 				    .cmp = cmp_nla_vrftable },
 
+	[SEG6_LOCAL_COUNTERS]	= { .parse = parse_nla_counters,
+				    .put = put_nla_counters,
+				    .cmp = cmp_nla_counters,
+				    .destroy = destroy_attr_counters },
 };
 
 /* call the destroy() callback (if available) for each set attribute in
@@ -1645,6 +1771,9 @@ static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
 	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE))
 		nlsize += nla_total_size(4);
 
+	if (attrs & SEG6_F_LOCAL_COUNTERS)
+		nlsize += nla_total_size(sizeof(struct seg6_local_counters));
+
 	return nlsize;
 }
 
-- 
2.20.1

