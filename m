Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD7F39F464
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhFHK5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:57:53 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:48259 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231773AbhFHK5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 06:57:50 -0400
X-Greylist: delayed 873 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2021 06:57:46 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 158Aeloq017313
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 8 Jun 2021 12:40:48 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC net-next 1/2] seg6: add support for SRv6 End.DT46 Behavior
Date:   Tue,  8 Jun 2021 12:40:16 +0200
Message-Id: <20210608104017.21181-2-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608104017.21181-1-andrea.mayer@uniroma2.it>
References: <20210608104017.21181-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IETF RFC 8986 [1] includes the definition of SRv6 End.DT4, End.DT6, and
End.DT46 Behaviors.

The current SRv6 code in the Linux kernel only implements End.DT4 and
End.DT6 which can be used respectively to support IPv4-in-IPv6 and
IPv6-in-IPv6 VPNs. With End.DT4 and End.DT6 it is not possible to create a
single SRv6 VPN tunnel to carry both IPv4 and IPv6 traffic.

The proposed End.DT46 implementation is meant to support the decapsulation
of IPv4 and IPv6 traffic coming from a single SRv6 tunnel.
The implementation of the SRv6 End.DT46 Behavior in the Linux kernel
greatly simplifies the setup and operations of SRv6 VPNs.

The SRv6 End.DT46 Behavior leverages the infrastructure of SRv6 End.DT{4,6}
Behaviors implemented so far, because it makes use of a VRF device in
order to force the routing lookup into the associated routing table.

To make the End.DT46 work properly, it must be guaranteed that the routing
table used for routing lookup operations is bound to one and only one VRF
during the tunnel creation. Such constraint has to be enforced by enabling
the VRF strict_mode sysctl parameter, i.e.:

 $ sysctl -wq net.vrf.strict_mode=1

Note that the same approach is used for the SRv6 End.DT4 Behavior and for
the End.DT6 Behavior in VRF mode.

The command used to instantiate an SRv6 End.DT46 Behavior is
straightforward, i.e.:

 $ ip -6 route add 2001:db8::1 encap seg6local action End.DT46 vrftable 100 dev vrf100.

[1] https://www.rfc-editor.org/rfc/rfc8986.html#name-enddt46-decapsulation-and-s

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Performance and impact of SRv6 End.DT46 Behavior on the SRv6 Networking
=======================================================================

This patch aims to add the SRv6 End.DT46 Behavior with minimal impact on
the performance of SRv6 End.DT4 and End.DT6 Behaviors.
In order to verify this, we tested the performance of the newly introduced
SRv6 End.DT46 Behavior and compared it with the performance of SRv6
End.DT{4,6} Behaviors, considering both the patched kernel and the kernel
before applying the End.DT46 patch (referred to as vanilla kernel).

In details, the following decapsulation scenarios were considered:

 1.a) IPv6 traffic in SRv6 End.DT46 Behavior on patched kernel;
 1.b) IPv4 traffic in SRv6 End.DT46 Behavior on patched kernel;
 2.a) SRv6 End.DT6 Behavior (VRF mode) on patched kernel;
 2.b) SRv6 End.DT4 Behavior on patched kernel;
 3.a) SRv6 End.DT6 Behavior (VRF mode) on vanilla kernel (without the
      End.DT46 patch);
 3.b) SRv6 End.DT4 Behavior on vanilla kernel (without the End.DT46 patch).

All tests were performed on a testbed deployed on the CloudLab [2]
facilities. We considered IPv{4,6} traffic handled by a single core (at 2.4
GHz on a Xeon(R) CPU E5-2630 v3) on kernel 5.13-rc1 using packets of size
~ 100 bytes.

Scenario (1.a): average 684.70 kpps; std. dev. 0.7 kpps;
Scenario (1.b): average 711.69 kpps; std. dev. 1.2 kpps;
Scenario (2.a): average 690.70 kpps; std. dev. 1.2 kpps;
Scenario (2.b): average 722.22 kpps; std. dev. 1.7 kpps;
Scenario (3.a): average 690.02 kpps; std. dev. 2.6 kpps;
Scenario (3.b): average 721.91 kpps; std. dev. 1.2 kpps;

Considering the results for the patched kernel (1.a, 1.b, 2.a, 2.b) we
observe that the performance degradation incurred in using End.DT46 rather
than End.DT6 and End.DT4 respectively for IPv6 and IPv4 traffic is minimal,
around 0.9% and 1.5%. Such very minimal performance degradation is the
price to be paid if one prefers to use a single tunnel capable of handling
both types of traffic (IPv4 and IPv6).

Comparing the results for End.DT4 and End.DT6 under the patched and the
vanilla kernel (2.a, 2.b, 3.a, 3.b) we observe that the introduction of the
End.DT46 patch has no impact on the performance of End.DT4 and End.DT6.

[2] https://www.cloudlab.us

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 include/uapi/linux/seg6_local.h |  2 +
 net/ipv6/seg6_local.c           | 94 +++++++++++++++++++++++++--------
 2 files changed, 74 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index 5ae3ace84de0..332b18f318f8 100644
--- a/include/uapi/linux/seg6_local.h
+++ b/include/uapi/linux/seg6_local.h
@@ -64,6 +64,8 @@ enum {
 	SEG6_LOCAL_ACTION_END_AM	= 14,
 	/* custom BPF action */
 	SEG6_LOCAL_ACTION_END_BPF	= 15,
+	/* decap and lookup of DA in v4 or v6 table */
+	SEG6_LOCAL_ACTION_END_DT46	= 16,
 
 	__SEG6_LOCAL_ACTION_MAX,
 };
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 4ff38cb08f4b..60bf3b877957 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -87,10 +87,10 @@ struct seg6_end_dt_info {
 	int vrf_ifindex;
 	int vrf_table;
 
-	/* tunneled packet proto and family (IPv4 or IPv6) */
-	__be16 proto;
+	/* tunneled packet family (IPv4 or IPv6).
+	 * Protocol and header length are inferred from family.
+	 */
 	u16 family;
-	int hdrlen;
 };
 
 struct pcpu_seg6_local_counters {
@@ -521,19 +521,6 @@ static int __seg6_end_dt_vrf_build(struct seg6_local_lwt *slwt, const void *cfg,
 	info->net = net;
 	info->vrf_ifindex = vrf_ifindex;
 
-	switch (family) {
-	case AF_INET:
-		info->proto = htons(ETH_P_IP);
-		info->hdrlen = sizeof(struct iphdr);
-		break;
-	case AF_INET6:
-		info->proto = htons(ETH_P_IPV6);
-		info->hdrlen = sizeof(struct ipv6hdr);
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	info->family = family;
 	info->mode = DT_VRF_MODE;
 
@@ -622,22 +609,44 @@ static struct net_device *end_dt_get_vrf_rcu(struct sk_buff *skb,
 }
 
 static struct sk_buff *end_dt_vrf_core(struct sk_buff *skb,
-				       struct seg6_local_lwt *slwt)
+				       struct seg6_local_lwt *slwt, u16 family)
 {
 	struct seg6_end_dt_info *info = &slwt->dt_info;
 	struct net_device *vrf;
+	__be16 protocol;
+	int hdrlen;
 
 	vrf = end_dt_get_vrf_rcu(skb, info);
 	if (unlikely(!vrf))
 		goto drop;
 
-	skb->protocol = info->proto;
+	switch (family) {
+	case AF_INET:
+		protocol = htons(ETH_P_IP);
+		hdrlen = sizeof(struct iphdr);
+		break;
+	case AF_INET6:
+		protocol = htons(ETH_P_IPV6);
+		hdrlen = sizeof(struct ipv6hdr);
+		break;
+	case AF_UNSPEC:
+		fallthrough;
+	default:
+		goto drop;
+	}
+
+	if (unlikely(info->family != AF_UNSPEC && info->family != family)) {
+		pr_warn_once("seg6local: SRv6 End.DT* family mismatch");
+		goto drop;
+	}
+
+	skb->protocol = protocol;
 
 	skb_dst_drop(skb);
 
-	skb_set_transport_header(skb, info->hdrlen);
+	skb_set_transport_header(skb, hdrlen);
 
-	return end_dt_vrf_rcv(skb, info->family, vrf);
+	return end_dt_vrf_rcv(skb, family, vrf);
 
 drop:
 	kfree_skb(skb);
@@ -656,7 +665,7 @@ static int input_action_end_dt4(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto drop;
 
-	skb = end_dt_vrf_core(skb, slwt);
+	skb = end_dt_vrf_core(skb, slwt, AF_INET);
 	if (!skb)
 		/* packet has been processed and consumed by the VRF */
 		return 0;
@@ -739,7 +748,7 @@ static int input_action_end_dt6(struct sk_buff *skb,
 		goto legacy_mode;
 
 	/* DT6_VRF_MODE */
-	skb = end_dt_vrf_core(skb, slwt);
+	skb = end_dt_vrf_core(skb, slwt, AF_INET6);
 	if (!skb)
 		/* packet has been processed and consumed by the VRF */
 		return 0;
@@ -767,6 +776,36 @@ static int input_action_end_dt6(struct sk_buff *skb,
 	return -EINVAL;
 }
 
+#ifdef CONFIG_NET_L3_MASTER_DEV
+static int seg6_end_dt46_build(struct seg6_local_lwt *slwt, const void *cfg,
+			       struct netlink_ext_ack *extack)
+{
+	return __seg6_end_dt_vrf_build(slwt, cfg, AF_UNSPEC, extack);
+}
+
+static int input_action_end_dt46(struct sk_buff *skb,
+				 struct seg6_local_lwt *slwt)
+{
+	unsigned int off = 0;
+	int nexthdr;
+
+	nexthdr = ipv6_find_hdr(skb, &off, -1, NULL, NULL);
+	if (unlikely(nexthdr < 0))
+		goto drop;
+
+	switch (nexthdr) {
+	case IPPROTO_IPIP:
+		return input_action_end_dt4(skb, slwt);
+	case IPPROTO_IPV6:
+		return input_action_end_dt6(skb, slwt);
+	}
+
+drop:
+	kfree_skb(skb);
+	return -EINVAL;
+}
+#endif
+
 /* push an SRH on top of the current one */
 static int input_action_end_b6(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
@@ -968,6 +1007,17 @@ static struct seg6_action_desc seg6_action_table[] = {
 #endif
 		.input		= input_action_end_dt6,
 	},
+	{
+		.action		= SEG6_LOCAL_ACTION_END_DT46,
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE),
+		.optattrs	= SEG6_F_LOCAL_COUNTERS,
+#ifdef CONFIG_NET_L3_MASTER_DEV
+		.input		= input_action_end_dt46,
+		.slwt_ops	= {
+					.build_state = seg6_end_dt46_build,
+				  },
+#endif
+	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_B6,
 		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_SRH),
-- 
2.20.1

