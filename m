Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2862529527B
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504486AbgJUSvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:51:38 -0400
Received: from smtp.uniroma2.it ([160.80.6.22]:47214 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411450AbgJUSvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 14:51:38 -0400
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 09LIga9i005673
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Oct 2020 20:42:38 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC,net-next, 3/4] seg6: add support for the SRv6 End.DT4 behavior
Date:   Wed, 21 Oct 2020 20:41:15 +0200
Message-Id: <20201021184116.2722-4-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201021184116.2722-1-andrea.mayer@uniroma2.it>
References: <20201021184116.2722-1-andrea.mayer@uniroma2.it>
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

The iproute2 counterpart required for configuring the SRv6 End.DT4
behavior is already implemented along with the other supported SRv6
behaviors [3].

[1] https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming
[2] https://speakerdeck.com/line_developers/line-data-center-networking-with-srv6
[3] https://patchwork.ozlabs.org/patch/799837/

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 204 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 204 insertions(+)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index f70687e1b8a9..d47b76581dfa 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -57,6 +57,12 @@ struct bpf_lwt_prog {
 	char *name;
 };
 
+struct seg6_end_dt4_info {
+	struct net *net;
+	/* VRF device to which the End.DT4 is associated to */
+	int vrf_ifindex;
+};
+
 struct seg6_local_lwt {
 	int action;
 	struct ipv6_sr_hdr *srh;
@@ -66,6 +72,7 @@ struct seg6_local_lwt {
 	int iif;
 	int oif;
 	struct bpf_lwt_prog bpf;
+	struct seg6_end_dt4_info dt4_info;
 
 	int headroom;
 	struct seg6_action_desc *desc;
@@ -413,6 +420,195 @@ static int input_action_end_dx4(struct sk_buff *skb,
 	return -EINVAL;
 }
 
+#ifdef CONFIG_NET_L3_MASTER_DEV
+
+static inline struct net *
+fib6_config_get_net(const struct fib6_config *fib6_cfg)
+{
+	const struct nl_info *nli = &fib6_cfg->fc_nlinfo;
+
+	return nli->nl_net;
+}
+
+static int srv6_end_dt4_build(struct seg6_local_lwt *slwt, const void *cfg,
+			      struct netlink_ext_ack *extack)
+{
+	struct seg6_end_dt4_info *info = &slwt->dt4_info;
+	int vrf_ifindex;
+	struct net *net;
+
+	net = fib6_config_get_net(cfg);
+
+	vrf_ifindex = l3mdev_ifindex_lookup_by_table_id(L3MDEV_TYPE_VRF, net,
+							slwt->table);
+	if (vrf_ifindex < 0) {
+		if (vrf_ifindex == -EPERM) {
+			NL_SET_ERR_MSG(extack, "Strict Mode is disabled");
+		} else if (vrf_ifindex == -ENODEV) {
+			NL_SET_ERR_MSG(extack, "No such device");
+		} else {
+			NL_SET_ERR_MSG(extack, "Unknown error");
+
+			pr_debug("SRv6 End.DT4 creation error=%d\n",
+				 vrf_ifindex);
+		}
+
+		return vrf_ifindex;
+	}
+
+	info->net = net;
+	info->vrf_ifindex = vrf_ifindex;
+
+	return 0;
+}
+
+/* In the SRv6 End.DT4 use case, we can receive traffic (IPv6+Segment Routing
+ * Header packets) from several interfaces and the IPv6 destination address (DA)
+ * is used for retrieving the specific instance of the End.DT4 behavior that
+ * should process the packets.
+ *
+ * The End.DT4 behavior extracts the inner (IPv4) packet and, on the basis of
+ * the associated VRF, it routes and forwards the IPv4 packet by looking at the
+ * specific table.
+ *
+ * However, the inner IPv4 packet is not really bound to any receiving interface
+ * and thus the End.DT4 sets the VRF as the *receiving* interface. In other
+ * words, the End.DT4 processes a packet as if it has been received directly
+ * by the VRF (and not by one of its slave devices, if any).
+ * In this way, the VRF interface is used for routing the IPv4 packet in
+ * according to the specific routing table.
+ *
+ * This design has allowed us to get some interesting features like:
+ *  1) the statistics on rx packets;
+ *  2) the possibility to install a packet sniffer on the receiving interface
+ *     (the VRF one) to see the incoming packets;
+ *  3) the possibility to leverage the netfilter prerouting hook for the inner
+ *     IPv4 packet.
+ *
+ * This function returns:
+ *  - the skb buffer when the VRF rcv handler has processed correctly the
+ *    packet;
+ *  - NULL when the skb is consumed by the VRF rcv handler;
+ *  - a pointer which encodes a negative error number in case of error.
+ *    Note that in this case, the function takes care of freeing the skb.
+ */
+static struct sk_buff *end_dt4_vrf_rcv(struct sk_buff *skb,
+				       struct net_device *dev)
+{
+	/* based on l3mdev_ip_rcv; we are only interested in the master */
+	if (unlikely(!netif_is_l3_master(dev) && !netif_has_l3_rx_handler(dev)))
+		goto drop;
+
+	if (unlikely(!dev->l3mdev_ops->l3mdev_l3_rcv))
+		goto drop;
+
+	/* the decap packet (IPv4) does not come with any mac header info.
+	 * We must unset the mac header to allow the VRF device to rebuild it,
+	 * just in case there is a sniffer attached on the device.
+	 */
+	skb_unset_mac_header(skb);
+
+	skb = dev->l3mdev_ops->l3mdev_l3_rcv(dev, skb, AF_INET);
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
+static struct net_device *end_dt4_get_vrf_rcu(struct sk_buff *skb,
+					      struct seg6_end_dt4_info *info)
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
+static int input_action_end_dt4(struct sk_buff *skb,
+				struct seg6_local_lwt *slwt)
+{
+	struct net_device *vrf;
+	struct iphdr *iph;
+	int err;
+
+	if (!decap_and_validate(skb, IPPROTO_IPIP))
+		goto drop;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto drop;
+
+	vrf = end_dt4_get_vrf_rcu(skb, &slwt->dt4_info);
+	if (unlikely(!vrf))
+		goto drop;
+
+	skb->protocol = htons(ETH_P_IP);
+
+	skb_dst_drop(skb);
+
+	skb_set_transport_header(skb, sizeof(struct iphdr));
+
+	skb = end_dt4_vrf_rcv(skb, vrf);
+	if (!skb)
+		/* packet has been processed and consumed by the VRF */
+		return 0;
+
+	if (IS_ERR(skb)) {
+		err = PTR_ERR(skb);
+		return err;
+	}
+
+	iph = ip_hdr(skb);
+
+	err = ip_route_input(skb, iph->daddr, iph->saddr, 0, skb->dev);
+	if (err)
+		goto drop;
+
+	return dst_input(skb);
+
+drop:
+	kfree_skb(skb);
+	return -EINVAL;
+}
+
+#else
+
+static int srv6_end_dt4_build(struct seg6_local_lwt *slwt, const void *cfg,
+			      struct netlink_ext_ack *extack)
+{
+	NL_SET_ERR_MSG(extack, "Operation is not supported");
+
+	return -EOPNOTSUPP;
+}
+
+static int input_action_end_dt4(struct sk_buff *skb,
+				struct seg6_local_lwt *slwt)
+{
+	kfree_skb(skb);
+	return -EOPNOTSUPP;
+}
+
+#endif
+
 static int input_action_end_dt6(struct sk_buff *skb,
 				struct seg6_local_lwt *slwt)
 {
@@ -601,6 +797,14 @@ static struct seg6_action_desc seg6_action_table[] = {
 		.attrs		= (1 << SEG6_LOCAL_NH4),
 		.input		= input_action_end_dx4,
 	},
+	{
+		.action		= SEG6_LOCAL_ACTION_END_DT4,
+		.attrs		= (1 << SEG6_LOCAL_TABLE),
+		.input		= input_action_end_dt4,
+		.slwt_ops	= {
+					.build_state = srv6_end_dt4_build,
+				  },
+	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DT6,
 		.attrs		= (1 << SEG6_LOCAL_TABLE),
-- 
2.20.1

