Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49942CBDF1
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgLBNJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:09:03 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:39960 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgLBNIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 08:08:41 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0B2D6XmX015624
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 2 Dec 2020 14:06:36 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v4 5/8] seg6: add support for the SRv6 End.DT4 behavior
Date:   Wed,  2 Dec 2020 14:05:14 +0100
Message-Id: <20201202130517.4967-6-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201202130517.4967-1-andrea.mayer@uniroma2.it>
References: <20201202130517.4967-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SRv6 End.DT4 is defined in the SRv6 Network Programming [1].

The SRv6 End.DT4 is used to implement IPv4 L3VPN use-cases in
multi-tenants environments. It decapsulates the received packets and it
performs IPv4 routing lookup in the routing table of the tenant.

The SRv6 End.DT4 Linux implementation leverages a VRF device in order to
force the routing lookup into the associated routing table.

To make the End.DT4 work properly, it must be guaranteed that the routing
table used for routing lookup operations is bound to one and only one
VRF during the tunnel creation. Such constraint has to be enforced by
enabling the VRF strict_mode sysctl parameter, i.e:
 $ sysctl -wq net.vrf.strict_mode=1.

At JANOG44, LINE corporation presented their multi-tenant DC architecture
using SRv6 [2]. In the slides, they reported that the Linux kernel is
missing the support of SRv6 End.DT4 behavior.

The SRv6 End.DT4 behavior can be instantiated using a command similar to
the following:

 $ ip route add 2001:db8::1 encap seg6local action End.DT4 vrftable 100 dev eth0

We introduce the "vrftable" extension in iproute2 in a following patch.

[1] https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming
[2] https://speakerdeck.com/line_developers/line-data-center-networking-with-srv6

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 include/uapi/linux/seg6_local.h |   1 +
 net/ipv6/seg6_local.c           | 287 ++++++++++++++++++++++++++++++++
 2 files changed, 288 insertions(+)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index edc138bdc56d..3b39ef1dbb46 100644
--- a/include/uapi/linux/seg6_local.h
+++ b/include/uapi/linux/seg6_local.h
@@ -26,6 +26,7 @@ enum {
 	SEG6_LOCAL_IIF,
 	SEG6_LOCAL_OIF,
 	SEG6_LOCAL_BPF,
+	SEG6_LOCAL_VRFTABLE,
 	__SEG6_LOCAL_MAX,
 };
 #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index da5bf4167a52..24c2616c8c11 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -69,6 +69,28 @@ struct bpf_lwt_prog {
 	char *name;
 };
 
+enum seg6_end_dt_mode {
+	DT_INVALID_MODE	= -EINVAL,
+	DT_LEGACY_MODE	= 0,
+	DT_VRF_MODE	= 1,
+};
+
+struct seg6_end_dt_info {
+	enum seg6_end_dt_mode mode;
+
+	struct net *net;
+	/* VRF device associated to the routing table used by the SRv6
+	 * End.DT4/DT6 behavior for routing IPv4/IPv6 packets.
+	 */
+	int vrf_ifindex;
+	int vrf_table;
+
+	/* tunneled packet proto and family (IPv4 or IPv6) */
+	__be16 proto;
+	u16 family;
+	int hdrlen;
+};
+
 struct seg6_local_lwt {
 	int action;
 	struct ipv6_sr_hdr *srh;
@@ -78,6 +100,9 @@ struct seg6_local_lwt {
 	int iif;
 	int oif;
 	struct bpf_lwt_prog bpf;
+#ifdef CONFIG_NET_L3_MASTER_DEV
+	struct seg6_end_dt_info dt_info;
+#endif
 
 	int headroom;
 	struct seg6_action_desc *desc;
@@ -429,6 +454,203 @@ static int input_action_end_dx4(struct sk_buff *skb,
 	return -EINVAL;
 }
 
+#ifdef CONFIG_NET_L3_MASTER_DEV
+static struct net *fib6_config_get_net(const struct fib6_config *fib6_cfg)
+{
+	const struct nl_info *nli = &fib6_cfg->fc_nlinfo;
+
+	return nli->nl_net;
+}
+
+static int __seg6_end_dt_vrf_build(struct seg6_local_lwt *slwt, const void *cfg,
+				   u16 family, struct netlink_ext_ack *extack)
+{
+	struct seg6_end_dt_info *info = &slwt->dt_info;
+	int vrf_ifindex;
+	struct net *net;
+
+	net = fib6_config_get_net(cfg);
+
+	/* note that vrf_table was already set by parse_nla_vrftable() */
+	vrf_ifindex = l3mdev_ifindex_lookup_by_table_id(L3MDEV_TYPE_VRF, net,
+							info->vrf_table);
+	if (vrf_ifindex < 0) {
+		if (vrf_ifindex == -EPERM) {
+			NL_SET_ERR_MSG(extack,
+				       "Strict mode for VRF is disabled");
+		} else if (vrf_ifindex == -ENODEV) {
+			NL_SET_ERR_MSG(extack,
+				       "Table has no associated VRF device");
+		} else {
+			pr_debug("seg6local: SRv6 End.DT* creation error=%d\n",
+				 vrf_ifindex);
+		}
+
+		return vrf_ifindex;
+	}
+
+	info->net = net;
+	info->vrf_ifindex = vrf_ifindex;
+
+	switch (family) {
+	case AF_INET:
+		info->proto = htons(ETH_P_IP);
+		info->hdrlen = sizeof(struct iphdr);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	info->family = family;
+	info->mode = DT_VRF_MODE;
+
+	return 0;
+}
+
+/* The SRv6 End.DT4/DT6 behavior extracts the inner (IPv4/IPv6) packet and
+ * routes the IPv4/IPv6 packet by looking at the configured routing table.
+ *
+ * In the SRv6 End.DT4/DT6 use case, we can receive traffic (IPv6+Segment
+ * Routing Header packets) from several interfaces and the outer IPv6
+ * destination address (DA) is used for retrieving the specific instance of the
+ * End.DT4/DT6 behavior that should process the packets.
+ *
+ * However, the inner IPv4/IPv6 packet is not really bound to any receiving
+ * interface and thus the End.DT4/DT6 sets the VRF (associated with the
+ * corresponding routing table) as the *receiving* interface.
+ * In other words, the End.DT4/DT6 processes a packet as if it has been received
+ * directly by the VRF (and not by one of its slave devices, if any).
+ * In this way, the VRF interface is used for routing the IPv4/IPv6 packet in
+ * according to the routing table configured by the End.DT4/DT6 instance.
+ *
+ * This design allows you to get some interesting features like:
+ *  1) the statistics on rx packets;
+ *  2) the possibility to install a packet sniffer on the receiving interface
+ *     (the VRF one) for looking at the incoming packets;
+ *  3) the possibility to leverage the netfilter prerouting hook for the inner
+ *     IPv4 packet.
+ *
+ * This function returns:
+ *  - the sk_buff* when the VRF rcv handler has processed the packet correctly;
+ *  - NULL when the skb is consumed by the VRF rcv handler;
+ *  - a pointer which encodes a negative error number in case of error.
+ *    Note that in this case, the function takes care of freeing the skb.
+ */
+static struct sk_buff *end_dt_vrf_rcv(struct sk_buff *skb, u16 family,
+				      struct net_device *dev)
+{
+	/* based on l3mdev_ip_rcv; we are only interested in the master */
+	if (unlikely(!netif_is_l3_master(dev) && !netif_has_l3_rx_handler(dev)))
+		goto drop;
+
+	if (unlikely(!dev->l3mdev_ops->l3mdev_l3_rcv))
+		goto drop;
+
+	/* the decap packet IPv4/IPv6 does not come with any mac header info.
+	 * We must unset the mac header to allow the VRF device to rebuild it,
+	 * just in case there is a sniffer attached on the device.
+	 */
+	skb_unset_mac_header(skb);
+
+	skb = dev->l3mdev_ops->l3mdev_l3_rcv(dev, skb, family);
+	if (!skb)
+		/* the skb buffer was consumed by the handler */
+		return NULL;
+
+	/* when a packet is received by a VRF or by one of its slaves, the
+	 * master device reference is set into the skb.
+	 */
+	if (unlikely(skb->dev != dev || skb->skb_iif != dev->ifindex))
+		goto drop;
+
+	return skb;
+
+drop:
+	kfree_skb(skb);
+	return ERR_PTR(-EINVAL);
+}
+
+static struct net_device *end_dt_get_vrf_rcu(struct sk_buff *skb,
+					     struct seg6_end_dt_info *info)
+{
+	int vrf_ifindex = info->vrf_ifindex;
+	struct net *net = info->net;
+
+	if (unlikely(vrf_ifindex < 0))
+		goto error;
+
+	if (unlikely(!net_eq(dev_net(skb->dev), net)))
+		goto error;
+
+	return dev_get_by_index_rcu(net, vrf_ifindex);
+
+error:
+	return NULL;
+}
+
+static struct sk_buff *end_dt_vrf_core(struct sk_buff *skb,
+				       struct seg6_local_lwt *slwt)
+{
+	struct seg6_end_dt_info *info = &slwt->dt_info;
+	struct net_device *vrf;
+
+	vrf = end_dt_get_vrf_rcu(skb, info);
+	if (unlikely(!vrf))
+		goto drop;
+
+	skb->protocol = info->proto;
+
+	skb_dst_drop(skb);
+
+	skb_set_transport_header(skb, info->hdrlen);
+
+	return end_dt_vrf_rcv(skb, info->family, vrf);
+
+drop:
+	kfree_skb(skb);
+	return ERR_PTR(-EINVAL);
+}
+
+static int input_action_end_dt4(struct sk_buff *skb,
+				struct seg6_local_lwt *slwt)
+{
+	struct iphdr *iph;
+	int err;
+
+	if (!decap_and_validate(skb, IPPROTO_IPIP))
+		goto drop;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto drop;
+
+	skb = end_dt_vrf_core(skb, slwt);
+	if (!skb)
+		/* packet has been processed and consumed by the VRF */
+		return 0;
+
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	iph = ip_hdr(skb);
+
+	err = ip_route_input(skb, iph->daddr, iph->saddr, 0, skb->dev);
+	if (unlikely(err))
+		goto drop;
+
+	return dst_input(skb);
+
+drop:
+	kfree_skb(skb);
+	return -EINVAL;
+}
+
+static int seg6_end_dt4_build(struct seg6_local_lwt *slwt, const void *cfg,
+			      struct netlink_ext_ack *extack)
+{
+	return __seg6_end_dt_vrf_build(slwt, cfg, AF_INET, extack);
+}
+#endif
+
 static int input_action_end_dt6(struct sk_buff *skb,
 				struct seg6_local_lwt *slwt)
 {
@@ -617,6 +839,16 @@ static struct seg6_action_desc seg6_action_table[] = {
 		.attrs		= (1 << SEG6_LOCAL_NH4),
 		.input		= input_action_end_dx4,
 	},
+	{
+		.action		= SEG6_LOCAL_ACTION_END_DT4,
+		.attrs		= (1 << SEG6_LOCAL_VRFTABLE),
+#ifdef CONFIG_NET_L3_MASTER_DEV
+		.input		= input_action_end_dt4,
+		.slwt_ops	= {
+					.build_state = seg6_end_dt4_build,
+				  },
+#endif
+	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DT6,
 		.attrs		= (1 << SEG6_LOCAL_TABLE),
@@ -677,6 +909,7 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_ACTION]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_SRH]	= { .type = NLA_BINARY },
 	[SEG6_LOCAL_TABLE]	= { .type = NLA_U32 },
+	[SEG6_LOCAL_VRFTABLE]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_NH4]	= { .type = NLA_BINARY,
 				    .len = sizeof(struct in_addr) },
 	[SEG6_LOCAL_NH6]	= { .type = NLA_BINARY,
@@ -766,6 +999,53 @@ static int cmp_nla_table(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 	return 0;
 }
 
+static struct
+seg6_end_dt_info *seg6_possible_end_dt_info(struct seg6_local_lwt *slwt)
+{
+#ifdef CONFIG_NET_L3_MASTER_DEV
+	return &slwt->dt_info;
+#else
+	return ERR_PTR(-EOPNOTSUPP);
+#endif
+}
+
+static int parse_nla_vrftable(struct nlattr **attrs,
+			      struct seg6_local_lwt *slwt)
+{
+	struct seg6_end_dt_info *info = seg6_possible_end_dt_info(slwt);
+
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->vrf_table = nla_get_u32(attrs[SEG6_LOCAL_VRFTABLE]);
+
+	return 0;
+}
+
+static int put_nla_vrftable(struct sk_buff *skb, struct seg6_local_lwt *slwt)
+{
+	struct seg6_end_dt_info *info = seg6_possible_end_dt_info(slwt);
+
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	if (nla_put_u32(skb, SEG6_LOCAL_VRFTABLE, info->vrf_table))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int cmp_nla_vrftable(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
+{
+	struct seg6_end_dt_info *info_a = seg6_possible_end_dt_info(a);
+	struct seg6_end_dt_info *info_b = seg6_possible_end_dt_info(b);
+
+	if (info_a->vrf_table != info_b->vrf_table)
+		return 1;
+
+	return 0;
+}
+
 static int parse_nla_nh4(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
 	memcpy(&slwt->nh4, nla_data(attrs[SEG6_LOCAL_NH4]),
@@ -984,6 +1264,10 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 				    .cmp = cmp_nla_bpf,
 				    .destroy = destroy_attr_bpf },
 
+	[SEG6_LOCAL_VRFTABLE]	= { .parse = parse_nla_vrftable,
+				    .put = put_nla_vrftable,
+				    .cmp = cmp_nla_vrftable },
+
 };
 
 /* call the destroy() callback (if available) for each set attribute in
@@ -1283,6 +1567,9 @@ static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
 		       nla_total_size(MAX_PROG_NAME) +
 		       nla_total_size(4);
 
+	if (attrs & (1 << SEG6_LOCAL_VRFTABLE))
+		nlsize += nla_total_size(4);
+
 	return nlsize;
 }
 
-- 
2.20.1

