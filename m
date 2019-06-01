Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A77132056
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfFASYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:12 -0400
Received: from mail.us.es ([193.147.175.20]:40080 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbfFASYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D2BCEFF2C6
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEF57DA70B
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D6069DA702; Sat,  1 Jun 2019 20:24:01 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8B3EFF2D8;
        Sat,  1 Jun 2019 20:23:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4A5C84265A31;
        Sat,  1 Jun 2019 20:23:58 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/15] ipvs: add checksum support for gue encapsulation
Date:   Sat,  1 Jun 2019 20:23:40 +0200
Message-Id: <20190601182340.2662-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacky Hu <hengqing.hu@gmail.com>

Add checksum support for gue encapsulation with the tun_flags parameter,
which could be one of the values below:
IP_VS_TUNNEL_ENCAP_FLAG_NOCSUM
IP_VS_TUNNEL_ENCAP_FLAG_CSUM
IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM

Signed-off-by: Jacky Hu <hengqing.hu@gmail.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |   2 +
 include/uapi/linux/ip_vs.h      |   7 ++
 net/netfilter/ipvs/ip_vs_ctl.c  |  11 +++-
 net/netfilter/ipvs/ip_vs_xmit.c | 143 +++++++++++++++++++++++++++++++++++-----
 4 files changed, 146 insertions(+), 17 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index b01a94ebfc0e..cb1ad0cc5c7b 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -603,6 +603,7 @@ struct ip_vs_dest_user_kern {
 
 	u16			tun_type;	/* tunnel type */
 	__be16			tun_port;	/* tunnel port */
+	u16			tun_flags;	/* tunnel flags */
 };
 
 
@@ -665,6 +666,7 @@ struct ip_vs_dest {
 	atomic_t		last_weight;	/* server latest weight */
 	__u16			tun_type;	/* tunnel type */
 	__be16			tun_port;	/* tunnel port */
+	__u16			tun_flags;	/* tunnel flags */
 
 	refcount_t		refcnt;		/* reference counter */
 	struct ip_vs_stats      stats;          /* statistics */
diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index e34f436fc79d..e4f18061a4fd 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -131,6 +131,11 @@ enum {
 	IP_VS_CONN_F_TUNNEL_TYPE_MAX,
 };
 
+/* Tunnel encapsulation flags */
+#define IP_VS_TUNNEL_ENCAP_FLAG_NOCSUM		(0)
+#define IP_VS_TUNNEL_ENCAP_FLAG_CSUM		(1 << 0)
+#define IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM		(1 << 1)
+
 /*
  *	The struct ip_vs_service_user and struct ip_vs_dest_user are
  *	used to set IPVS rules through setsockopt.
@@ -403,6 +408,8 @@ enum {
 
 	IPVS_DEST_ATTR_TUN_PORT,	/* tunnel port */
 
+	IPVS_DEST_ATTR_TUN_FLAGS,	/* tunnel flags */
+
 	__IPVS_DEST_ATTR_MAX,
 };
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index d5847e06350f..ad19ac08622f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -893,6 +893,7 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 	/* set the tunnel info */
 	dest->tun_type = udest->tun_type;
 	dest->tun_port = udest->tun_port;
+	dest->tun_flags = udest->tun_flags;
 
 	/* set the IP_VS_CONN_F_NOOUTPUT flag if not masquerading/NAT */
 	if ((conn_flags & IP_VS_CONN_F_FWD_MASK) != IP_VS_CONN_F_MASQ) {
@@ -2967,6 +2968,7 @@ static const struct nla_policy ip_vs_dest_policy[IPVS_DEST_ATTR_MAX + 1] = {
 	[IPVS_DEST_ATTR_ADDR_FAMILY]	= { .type = NLA_U16 },
 	[IPVS_DEST_ATTR_TUN_TYPE]	= { .type = NLA_U8 },
 	[IPVS_DEST_ATTR_TUN_PORT]	= { .type = NLA_U16 },
+	[IPVS_DEST_ATTR_TUN_FLAGS]	= { .type = NLA_U16 },
 };
 
 static int ip_vs_genl_fill_stats(struct sk_buff *skb, int container_type,
@@ -3273,6 +3275,8 @@ static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
 		       dest->tun_type) ||
 	    nla_put_be16(skb, IPVS_DEST_ATTR_TUN_PORT,
 			 dest->tun_port) ||
+	    nla_put_u16(skb, IPVS_DEST_ATTR_TUN_FLAGS,
+			dest->tun_flags) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_U_THRESH, dest->u_threshold) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_L_THRESH, dest->l_threshold) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_ACTIVE_CONNS,
@@ -3393,7 +3397,8 @@ static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
 	/* If a full entry was requested, check for the additional fields */
 	if (full_entry) {
 		struct nlattr *nla_fwd, *nla_weight, *nla_u_thresh,
-			      *nla_l_thresh, *nla_tun_type, *nla_tun_port;
+			      *nla_l_thresh, *nla_tun_type, *nla_tun_port,
+			      *nla_tun_flags;
 
 		nla_fwd		= attrs[IPVS_DEST_ATTR_FWD_METHOD];
 		nla_weight	= attrs[IPVS_DEST_ATTR_WEIGHT];
@@ -3401,6 +3406,7 @@ static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
 		nla_l_thresh	= attrs[IPVS_DEST_ATTR_L_THRESH];
 		nla_tun_type	= attrs[IPVS_DEST_ATTR_TUN_TYPE];
 		nla_tun_port	= attrs[IPVS_DEST_ATTR_TUN_PORT];
+		nla_tun_flags	= attrs[IPVS_DEST_ATTR_TUN_FLAGS];
 
 		if (!(nla_fwd && nla_weight && nla_u_thresh && nla_l_thresh))
 			return -EINVAL;
@@ -3416,6 +3422,9 @@ static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
 
 		if (nla_tun_port)
 			udest->tun_port = nla_get_be16(nla_tun_port);
+
+		if (nla_tun_flags)
+			udest->tun_flags = nla_get_u16(nla_tun_flags);
 	}
 
 	return 0;
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 0b41d0504429..af3379d5e5bc 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -40,6 +40,7 @@
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
 #include <net/ip_tunnels.h>
+#include <net/ip6_checksum.h>
 #include <net/addrconf.h>
 #include <linux/icmpv6.h>
 #include <linux/netfilter.h>
@@ -385,8 +386,13 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		mtu = dst_mtu(&rt->dst) - sizeof(struct iphdr);
 		if (!dest)
 			goto err_put;
-		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
+		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 			mtu -= sizeof(struct udphdr) + sizeof(struct guehdr);
+			if ((dest->tun_flags &
+			     IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+			    skb->ip_summed == CHECKSUM_PARTIAL)
+				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		}
 		if (mtu < 68) {
 			IP_VS_DBG_RL("%s(): mtu less than 68\n", __func__);
 			goto err_put;
@@ -540,8 +546,13 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		mtu = dst_mtu(&rt->dst) - sizeof(struct ipv6hdr);
 		if (!dest)
 			goto err_put;
-		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
+		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 			mtu -= sizeof(struct udphdr) + sizeof(struct guehdr);
+			if ((dest->tun_flags &
+			     IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+			    skb->ip_summed == CHECKSUM_PARTIAL)
+				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		}
 		if (mtu < IPV6_MIN_MTU) {
 			IP_VS_DBG_RL("%s(): mtu less than %d\n", __func__,
 				     IPV6_MIN_MTU);
@@ -1006,17 +1017,56 @@ ipvs_gue_encap(struct net *net, struct sk_buff *skb,
 	__be16 sport = udp_flow_src_port(net, skb, 0, 0, false);
 	struct udphdr  *udph;	/* Our new UDP header */
 	struct guehdr  *gueh;	/* Our new GUE header */
+	size_t hdrlen, optlen = 0;
+	void *data;
+	bool need_priv = false;
+
+	if ((cp->dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+	    skb->ip_summed == CHECKSUM_PARTIAL) {
+		optlen += GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		need_priv = true;
+	}
 
-	skb_push(skb, sizeof(struct guehdr));
+	hdrlen = sizeof(struct guehdr) + optlen;
+
+	skb_push(skb, hdrlen);
 
 	gueh = (struct guehdr *)skb->data;
 
 	gueh->control = 0;
 	gueh->version = 0;
-	gueh->hlen = 0;
+	gueh->hlen = optlen >> 2;
 	gueh->flags = 0;
 	gueh->proto_ctype = *next_protocol;
 
+	data = &gueh[1];
+
+	if (need_priv) {
+		__be32 *flags = data;
+		u16 csum_start = skb_checksum_start_offset(skb);
+		__be16 *pd;
+
+		gueh->flags |= GUE_FLAG_PRIV;
+		*flags = 0;
+		data += GUE_LEN_PRIV;
+
+		if (csum_start < hdrlen)
+			return -EINVAL;
+
+		csum_start -= hdrlen;
+		pd = data;
+		pd[0] = htons(csum_start);
+		pd[1] = htons(csum_start + skb->csum_offset);
+
+		if (!skb_is_gso(skb)) {
+			skb->ip_summed = CHECKSUM_NONE;
+			skb->encapsulation = 0;
+		}
+
+		*flags |= GUE_PFLAG_REMCSUM;
+		data += GUE_PLEN_REMCSUM;
+	}
+
 	skb_push(skb, sizeof(struct udphdr));
 	skb_reset_transport_header(skb);
 
@@ -1070,6 +1120,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	unsigned int max_headroom;		/* The extra header space needed */
 	int ret, local;
 	int tun_type, gso_type;
+	int tun_flags;
 
 	EnterFunction(10);
 
@@ -1092,9 +1143,19 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	max_headroom = LL_RESERVED_SPACE(tdev) + sizeof(struct iphdr);
 
 	tun_type = cp->dest->tun_type;
+	tun_flags = cp->dest->tun_flags;
 
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		max_headroom += sizeof(struct udphdr) + sizeof(struct guehdr);
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		size_t gue_hdrlen, gue_optlen = 0;
+
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+		    skb->ip_summed == CHECKSUM_PARTIAL) {
+			gue_optlen += GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		}
+		gue_hdrlen = sizeof(struct guehdr) + gue_optlen;
+
+		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
+	}
 
 	/* We only care about the df field if sysctl_pmtu_disc(ipvs) is set */
 	dfp = sysctl_pmtu_disc(ipvs) ? &df : NULL;
@@ -1105,8 +1166,17 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		goto tx_error;
 
 	gso_type = __tun_gso_type_mask(AF_INET, cp->af);
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		gso_type |= SKB_GSO_UDP_TUNNEL;
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM) ||
+		    (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM))
+			gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+		else
+			gso_type |= SKB_GSO_UDP_TUNNEL;
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+		    skb->ip_summed == CHECKSUM_PARTIAL) {
+			gso_type |= SKB_GSO_TUNNEL_REMCSUM;
+		}
+	}
 
 	if (iptunnel_handle_offloads(skb, gso_type))
 		goto tx_error;
@@ -1115,8 +1185,19 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	skb_set_inner_ipproto(skb, next_protocol);
 
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		ipvs_gue_encap(net, skb, cp, &next_protocol);
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		bool check = false;
+
+		if (ipvs_gue_encap(net, skb, cp, &next_protocol))
+			goto tx_error;
+
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM) ||
+		    (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM))
+			check = true;
+
+		udp_set_csum(!check, skb, saddr, cp->daddr.ip, skb->len);
+	}
+
 
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
@@ -1174,6 +1255,7 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	unsigned int max_headroom;	/* The extra header space needed */
 	int ret, local;
 	int tun_type, gso_type;
+	int tun_flags;
 
 	EnterFunction(10);
 
@@ -1197,9 +1279,19 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	max_headroom = LL_RESERVED_SPACE(tdev) + sizeof(struct ipv6hdr);
 
 	tun_type = cp->dest->tun_type;
+	tun_flags = cp->dest->tun_flags;
 
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		max_headroom += sizeof(struct udphdr) + sizeof(struct guehdr);
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		size_t gue_hdrlen, gue_optlen = 0;
+
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+		    skb->ip_summed == CHECKSUM_PARTIAL) {
+			gue_optlen += GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		}
+		gue_hdrlen = sizeof(struct guehdr) + gue_optlen;
+
+		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
+	}
 
 	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
 					 &next_protocol, &payload_len,
@@ -1208,8 +1300,17 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		goto tx_error;
 
 	gso_type = __tun_gso_type_mask(AF_INET6, cp->af);
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		gso_type |= SKB_GSO_UDP_TUNNEL;
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM) ||
+		    (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM))
+			gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+		else
+			gso_type |= SKB_GSO_UDP_TUNNEL;
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+		    skb->ip_summed == CHECKSUM_PARTIAL) {
+			gso_type |= SKB_GSO_TUNNEL_REMCSUM;
+		}
+	}
 
 	if (iptunnel_handle_offloads(skb, gso_type))
 		goto tx_error;
@@ -1218,8 +1319,18 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	skb_set_inner_ipproto(skb, next_protocol);
 
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		ipvs_gue_encap(net, skb, cp, &next_protocol);
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		bool check = false;
+
+		if (ipvs_gue_encap(net, skb, cp, &next_protocol))
+			goto tx_error;
+
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM) ||
+		    (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM))
+			check = true;
+
+		udp6_set_csum(!check, skb, &saddr, &cp->daddr.in6, skb->len);
+	}
 
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
-- 
2.11.0

