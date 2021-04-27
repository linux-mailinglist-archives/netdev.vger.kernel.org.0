Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF9336C8DA
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhD0Ppd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:45:33 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:58108 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234932AbhD0Ppd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 11:45:33 -0400
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 13RFiP2T025139
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Apr 2021 17:44:26 +0200
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
Subject: [net-next] seg6: add counters support for SRv6 Behaviors
Date:   Tue, 27 Apr 2021 17:44:04 +0200
Message-Id: <20210427154404.20546-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides counters for SRv6 Behaviors as defined in [1],
section 6. For each SRv6 Behavior instance, counters defined in [1] are:

 - the total number of packets that have been correctly processed;
 - the total amount of traffic in bytes of all packets that have been
   correctly processed;

In addition, this patch introduces a new counter that counts the number of
packets that have NOT been properly processed (i.e. errors) by an SRv6
Behavior instance.

Counters are not only interesting for network monitoring purposes (i.e.
counting the number of packets processed by a given behavior) but they also
provide a simple tool for checking whether a behavior instance is working
as we expect or not.
Counters can be useful for troubleshooting misconfigured SRv6 networks.
Indeed, an SRv6 Behavior can silently drop packets for very different
reasons (i.e. wrong SID configuration, interfaces set with SID addresses,
etc) without any notification/message to the user.

Due to the nature of SRv6 networks, diagnostic tools such as ping and
traceroute may be ineffective: paths used for reaching a given router can
be totally different from the ones followed by probe packets. In addition,
paths are often asymmetrical and this makes it even more difficult to keep
up with the journey of the packets and to understand which behaviors are
actually processing our traffic.

When counters are enabled on an SRv6 Behavior instance, it is possible to
verify if packets are actually processed by such behavior and what is the
outcome of the processing. Therefore, the counters for SRv6 Behaviors offer
an non-invasive observability point which can be leveraged for both traffic
monitoring and troubleshooting purposes.

[1] https://www.rfc-editor.org/rfc/rfc8986.html#name-counters

Troubleshooting using SRv6 Behavior counters
--------------------------------------------

Let's make a brief example to see how helpful counters can be for SRv6
networks. Let's consider a node where an SRv6 End Behavior receives an SRv6
packet whose Segment Left (SL) is equal to 0. In this case, the End
Behavior (which accepts only packets with SL >= 1) discards the packet and
increases the error counter.
This information can be leveraged by the network operator for
troubleshooting. Indeed, the error counter is telling the user that the
packet:

  (i) arrived at the node;
 (ii) the packet has been taken into account by the SRv6 End behavior;
(iii) but an error has occurred during the processing.

The error (iii) could be caused by different reasons, such as wrong route
settings on the node or due to an invalid SID List carried by the SRv6
packet. Anyway, the error counter is used to exclude that the packet did
not arrive at the node or it has not been processed by the behavior at
all.

Turning on/off counters for SRv6 Behaviors
------------------------------------------

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

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Impact of counters for SRv6 Behaviors on performance
====================================================

To determine the performance impact due to the introduction of counters in
the SRv6 Behavior subsystem, we have carried out extensive tests.

We chose to test the throughput achieved by the SRv6 End.DX2 Behavior
because, among all the other behaviors implemented so far, it reaches the
highest throughput which is around 1.5 Mpps (per core at 2.4 GHz on a
Xeon(R) CPU E5-2630 v3) on kernel 5.12-rc2 using packets of size ~ 100
bytes.

Three different tests were conducted in order to evaluate the overall
throughput of the SRv6 End.DX2 Behavior in the following scenarios:

 1) vanilla kernel (without the SRv6 Behavior counters patch) and a single
    instance of an SRv6 End.DX2 Behavior;
 2) patched kernel with SRv6 Behavior counters and a single instance of
    an SRv6 End.DX2 Behavior with counters turned off;
 3) patched kernel with SRv6 Behavior counters and a single instance of
    SRv6 End.DX2 Behavior with counters turned on.

All tests were performed on a testbed deployed on the CloudLab facilities
[2], a flexible infrastructure dedicated to scientific research on the
future of Cloud Computing.

Results of tests are shown in the following table:

Scenario (1): average 1504764,81 pps (~1504,76 kpps); std. dev 3956,82 pps
Scenario (2): average 1501469,78 pps (~1501,47 kpps); std. dev 2979,85 pps
Scenario (3): average 1501315,13 pps (~1501,32 kpps); std. dev 2956,00 pps

As can be observed, throughputs achieved in scenarios (2),(3) did not
suffer any observable degradation compared to scenario (1).

Thanks to Jakub Kicinski and David Ahern for their valuable suggestions
and comments provided during the discussion of the proposed RFCs.

[2] https://www.cloudlab.us

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 include/uapi/linux/seg6_local.h |  30 +++++
 net/ipv6/seg6_local.c           | 198 +++++++++++++++++++++++++++++++-
 2 files changed, 226 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index 3b39ef1dbb46..5ae3ace84de0 100644
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
@@ -78,4 +79,33 @@ enum {
 
 #define SEG6_LOCAL_BPF_PROG_MAX (__SEG6_LOCAL_BPF_PROG_MAX - 1)
 
+/* SRv6 Behavior counters are encoded as netlink attributes guaranteeing the
+ * correct alignment.
+ * Each counter is identified by a different attribute type (i.e.
+ * SEG6_LOCAL_CNT_PACKETS).
+ *
+ * - SEG6_LOCAL_CNT_PACKETS: identifies a counter that counts the number of
+ *   packets that have been CORRECTLY processed by an SRv6 Behavior instance
+ *   (i.e., packets that generate errors or are dropped are NOT counted).
+ *
+ * - SEG6_LOCAL_CNT_BYTES: identifies a counter that counts the total amount
+ *   of traffic in bytes of all packets that have been CORRECTLY processed by
+ *   an SRv6 Behavior instance (i.e., packets that generate errors or are
+ *   dropped are NOT counted).
+ *
+ * - SEG6_LOCAL_CNT_ERRORS: identifies a counter that counts the number of
+ *   packets that have NOT been properly processed by an SRv6 Behavior instance
+ *   (i.e., packets that generate errors or are dropped).
+ */
+enum {
+	SEG6_LOCAL_CNT_UNSPEC,
+	SEG6_LOCAL_CNT_PAD,		/* pad for 64 bits values */
+	SEG6_LOCAL_CNT_PACKETS,
+	SEG6_LOCAL_CNT_BYTES,
+	SEG6_LOCAL_CNT_ERRORS,
+	__SEG6_LOCAL_CNT_MAX,
+};
+
+#define SEG6_LOCAL_CNT_MAX (__SEG6_LOCAL_CNT_MAX - 1)
+
 #endif
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index bd7140885e60..4ff38cb08f4b 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -93,6 +93,35 @@ struct seg6_end_dt_info {
 	int hdrlen;
 };
 
+struct pcpu_seg6_local_counters {
+	u64_stats_t packets;
+	u64_stats_t bytes;
+	u64_stats_t errors;
+
+	struct u64_stats_sync syncp;
+};
+
+/* This struct groups all the SRv6 Behavior counters supported so far.
+ *
+ * put_nla_counters() makes use of this data structure to collect all counter
+ * values after the per-CPU counter evaluation has been performed.
+ * Finally, each counter value (in seg6_local_counters) is stored in the
+ * corresponding netlink attribute and sent to user space.
+ *
+ * NB: we don't want to expose this structure to user space!
+ */
+struct seg6_local_counters {
+	__u64 packets;
+	__u64 bytes;
+	__u64 errors;
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
@@ -105,6 +134,7 @@ struct seg6_local_lwt {
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct seg6_end_dt_info dt_info;
 #endif
+	struct pcpu_seg6_local_counters __percpu *pcpu_counters;
 
 	int headroom;
 	struct seg6_action_desc *desc;
@@ -878,36 +908,43 @@ static struct seg6_action_desc seg6_action_table[] = {
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
@@ -919,30 +956,35 @@ static struct seg6_action_desc seg6_action_table[] = {
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
 
@@ -963,11 +1005,36 @@ static struct seg6_action_desc *__get_action_desc(int action)
 	return NULL;
 }
 
+static bool seg6_lwtunnel_counters_enabled(struct seg6_local_lwt *slwt)
+{
+	return slwt->parsed_optattrs & SEG6_F_LOCAL_COUNTERS;
+}
+
+static void seg6_local_update_counters(struct seg6_local_lwt *slwt,
+				       unsigned int len, int err)
+{
+	struct pcpu_seg6_local_counters *pcounters;
+
+	pcounters = this_cpu_ptr(slwt->pcpu_counters);
+	u64_stats_update_begin(&pcounters->syncp);
+
+	if (likely(!err)) {
+		u64_stats_inc(&pcounters->packets);
+		u64_stats_add(&pcounters->bytes, len);
+	} else {
+		u64_stats_inc(&pcounters->errors);
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
+	unsigned int len = skb->len;
+	int rc;
 
 	if (skb->protocol != htons(ETH_P_IPV6)) {
 		kfree_skb(skb);
@@ -977,7 +1044,14 @@ static int seg6_local_input(struct sk_buff *skb)
 	slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
 	desc = slwt->desc;
 
-	return desc->input(skb, slwt);
+	rc = desc->input(skb, slwt);
+
+	if (!seg6_lwtunnel_counters_enabled(slwt))
+		return rc;
+
+	seg6_local_update_counters(slwt, len, rc);
+
+	return rc;
 }
 
 static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
@@ -992,6 +1066,7 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_IIF]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_OIF]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_BPF]	= { .type = NLA_NESTED },
+	[SEG6_LOCAL_COUNTERS]	= { .type = NLA_NESTED },
 };
 
 static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt)
@@ -1296,6 +1371,112 @@ static void destroy_attr_bpf(struct seg6_local_lwt *slwt)
 		bpf_prog_put(slwt->bpf.prog);
 }
 
+static const struct
+nla_policy seg6_local_counters_policy[SEG6_LOCAL_CNT_MAX + 1] = {
+	[SEG6_LOCAL_CNT_PACKETS]	= { .type = NLA_U64 },
+	[SEG6_LOCAL_CNT_BYTES]		= { .type = NLA_U64 },
+	[SEG6_LOCAL_CNT_ERRORS]		= { .type = NLA_U64 },
+};
+
+static int parse_nla_counters(struct nlattr **attrs,
+			      struct seg6_local_lwt *slwt)
+{
+	struct pcpu_seg6_local_counters __percpu *pcounters;
+	struct nlattr *tb[SEG6_LOCAL_CNT_MAX + 1];
+	int ret;
+
+	ret = nla_parse_nested_deprecated(tb, SEG6_LOCAL_CNT_MAX,
+					  attrs[SEG6_LOCAL_COUNTERS],
+					  seg6_local_counters_policy, NULL);
+	if (ret < 0)
+		return ret;
+
+	/* basic support for SRv6 Behavior counters requires at least:
+	 * packets, bytes and errors.
+	 */
+	if (!tb[SEG6_LOCAL_CNT_PACKETS] || !tb[SEG6_LOCAL_CNT_BYTES] ||
+	    !tb[SEG6_LOCAL_CNT_ERRORS])
+		return -EINVAL;
+
+	/* counters are always zero initialized */
+	pcounters = seg6_local_alloc_pcpu_counters(GFP_KERNEL);
+	if (!pcounters)
+		return -ENOMEM;
+
+	slwt->pcpu_counters = pcounters;
+
+	return 0;
+}
+
+static int seg6_local_fill_nla_counters(struct sk_buff *skb,
+					struct seg6_local_counters *counters)
+{
+	if (nla_put_u64_64bit(skb, SEG6_LOCAL_CNT_PACKETS, counters->packets,
+			      SEG6_LOCAL_CNT_PAD))
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(skb, SEG6_LOCAL_CNT_BYTES, counters->bytes,
+			      SEG6_LOCAL_CNT_PAD))
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(skb, SEG6_LOCAL_CNT_ERRORS, counters->errors,
+			      SEG6_LOCAL_CNT_PAD))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int put_nla_counters(struct sk_buff *skb, struct seg6_local_lwt *slwt)
+{
+	struct seg6_local_counters counters = { 0, 0, 0 };
+	struct nlattr *nest;
+	int rc, i;
+
+	nest = nla_nest_start(skb, SEG6_LOCAL_COUNTERS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	for_each_possible_cpu(i) {
+		struct pcpu_seg6_local_counters *pcounters;
+		u64 packets, bytes, errors;
+		unsigned int start;
+
+		pcounters = per_cpu_ptr(slwt->pcpu_counters, i);
+		do {
+			start = u64_stats_fetch_begin_irq(&pcounters->syncp);
+
+			packets = u64_stats_read(&pcounters->packets);
+			bytes = u64_stats_read(&pcounters->bytes);
+			errors = u64_stats_read(&pcounters->errors);
+
+		} while (u64_stats_fetch_retry_irq(&pcounters->syncp, start));
+
+		counters.packets += packets;
+		counters.bytes += bytes;
+		counters.errors += errors;
+	}
+
+	rc = seg6_local_fill_nla_counters(skb, &counters);
+	if (rc < 0) {
+		nla_nest_cancel(skb, nest);
+		return rc;
+	}
+
+	return nla_nest_end(skb, nest);
+}
+
+static int cmp_nla_counters(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
+{
+	/* a and b are equal if both have pcpu_counters set or not */
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
@@ -1343,6 +1524,10 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 				    .put = put_nla_vrftable,
 				    .cmp = cmp_nla_vrftable },
 
+	[SEG6_LOCAL_COUNTERS]	= { .parse = parse_nla_counters,
+				    .put = put_nla_counters,
+				    .cmp = cmp_nla_counters,
+				    .destroy = destroy_attr_counters },
 };
 
 /* call the destroy() callback (if available) for each set attribute in
@@ -1645,6 +1830,15 @@ static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
 	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE))
 		nlsize += nla_total_size(4);
 
+	if (attrs & SEG6_F_LOCAL_COUNTERS)
+		nlsize += nla_total_size(0) + /* nest SEG6_LOCAL_COUNTERS */
+			  /* SEG6_LOCAL_CNT_PACKETS */
+			  nla_total_size_64bit(sizeof(__u64)) +
+			  /* SEG6_LOCAL_CNT_BYTES */
+			  nla_total_size_64bit(sizeof(__u64)) +
+			  /* SEG6_LOCAL_CNT_ERRORS */
+			  nla_total_size_64bit(sizeof(__u64));
+
 	return nlsize;
 }
 
-- 
2.20.1

