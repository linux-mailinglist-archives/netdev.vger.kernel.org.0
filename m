Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F7861CFD
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbfGHKcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:32:52 -0400
Received: from mail.us.es ([193.147.175.20]:34264 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728957AbfGHKcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DF31EBAE8A
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFCD8DA708
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C55096DA85; Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C6D56E7AC;
        Mon,  8 Jul 2019 12:32:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1D0B74265A31;
        Mon,  8 Jul 2019 12:32:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/15] ipvs: allow tunneling with gre encapsulation
Date:   Mon,  8 Jul 2019 12:32:26 +0200
Message-Id: <20190708103237.28061-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@yandex-team.ru>

windows real servers can handle gre tunnels, this patch allows
gre encapsulation with the tunneling method, thereby letting ipvs
be load balancer for windows-based services

Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/ip_vs.h      |  1 +
 net/netfilter/ipvs/ip_vs_ctl.c  |  1 +
 net/netfilter/ipvs/ip_vs_xmit.c | 66 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index e4f18061a4fd..4102ddcb4e14 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -128,6 +128,7 @@
 enum {
 	IP_VS_CONN_F_TUNNEL_TYPE_IPIP = 0,	/* IPIP */
 	IP_VS_CONN_F_TUNNEL_TYPE_GUE,		/* GUE */
+	IP_VS_CONN_F_TUNNEL_TYPE_GRE,		/* GRE */
 	IP_VS_CONN_F_TUNNEL_TYPE_MAX,
 };
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 84384d896e29..998353bec74f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -525,6 +525,7 @@ static void ip_vs_rs_hash(struct netns_ipvs *ipvs, struct ip_vs_dest *dest)
 			port = dest->tun_port;
 			break;
 		case IP_VS_CONN_F_TUNNEL_TYPE_IPIP:
+		case IP_VS_CONN_F_TUNNEL_TYPE_GRE:
 			port = 0;
 			break;
 		default:
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 71fc6d63a67f..9c464d24beec 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -29,6 +29,7 @@
 #include <linux/tcp.h>                  /* for tcphdr */
 #include <net/ip.h>
 #include <net/gue.h>
+#include <net/gre.h>
 #include <net/tcp.h>                    /* for csum_tcpudp_magic */
 #include <net/udp.h>
 #include <net/icmp.h>                   /* for icmp_send */
@@ -388,6 +389,12 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 			     IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
 			    skb->ip_summed == CHECKSUM_PARTIAL)
 				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		} else if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+			__be16 tflags = 0;
+
+			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+				tflags |= TUNNEL_CSUM;
+			mtu -= gre_calc_hlen(tflags);
 		}
 		if (mtu < 68) {
 			IP_VS_DBG_RL("%s(): mtu less than 68\n", __func__);
@@ -548,6 +555,12 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 			     IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
 			    skb->ip_summed == CHECKSUM_PARTIAL)
 				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		} else if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+			__be16 tflags = 0;
+
+			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+				tflags |= TUNNEL_CSUM;
+			mtu -= gre_calc_hlen(tflags);
 		}
 		if (mtu < IPV6_MIN_MTU) {
 			IP_VS_DBG_RL("%s(): mtu less than %d\n", __func__,
@@ -1079,6 +1092,24 @@ ipvs_gue_encap(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
+static void
+ipvs_gre_encap(struct net *net, struct sk_buff *skb,
+	       struct ip_vs_conn *cp, __u8 *next_protocol)
+{
+	__be16 proto = *next_protocol == IPPROTO_IPIP ?
+				htons(ETH_P_IP) : htons(ETH_P_IPV6);
+	__be16 tflags = 0;
+	size_t hdrlen;
+
+	if (cp->dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+		tflags |= TUNNEL_CSUM;
+
+	hdrlen = gre_calc_hlen(tflags);
+	gre_build_header(skb, hdrlen, tflags, proto, 0, 0);
+
+	*next_protocol = IPPROTO_GRE;
+}
+
 /*
  *   IP Tunneling transmitter
  *
@@ -1151,6 +1182,15 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		gue_hdrlen = sizeof(struct guehdr) + gue_optlen;
 
 		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
+	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		size_t gre_hdrlen;
+		__be16 tflags = 0;
+
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			tflags |= TUNNEL_CSUM;
+		gre_hdrlen = gre_calc_hlen(tflags);
+
+		max_headroom += gre_hdrlen;
 	}
 
 	/* We only care about the df field if sysctl_pmtu_disc(ipvs) is set */
@@ -1172,6 +1212,11 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		    skb->ip_summed == CHECKSUM_PARTIAL) {
 			gso_type |= SKB_GSO_TUNNEL_REMCSUM;
 		}
+	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			gso_type |= SKB_GSO_GRE_CSUM;
+		else
+			gso_type |= SKB_GSO_GRE;
 	}
 
 	if (iptunnel_handle_offloads(skb, gso_type))
@@ -1192,8 +1237,8 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 			check = true;
 
 		udp_set_csum(!check, skb, saddr, cp->daddr.ip, skb->len);
-	}
-
+	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE)
+		ipvs_gre_encap(net, skb, cp, &next_protocol);
 
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
@@ -1287,6 +1332,15 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		gue_hdrlen = sizeof(struct guehdr) + gue_optlen;
 
 		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
+	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		size_t gre_hdrlen;
+		__be16 tflags = 0;
+
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			tflags |= TUNNEL_CSUM;
+		gre_hdrlen = gre_calc_hlen(tflags);
+
+		max_headroom += gre_hdrlen;
 	}
 
 	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
@@ -1306,6 +1360,11 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		    skb->ip_summed == CHECKSUM_PARTIAL) {
 			gso_type |= SKB_GSO_TUNNEL_REMCSUM;
 		}
+	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			gso_type |= SKB_GSO_GRE_CSUM;
+		else
+			gso_type |= SKB_GSO_GRE;
 	}
 
 	if (iptunnel_handle_offloads(skb, gso_type))
@@ -1326,7 +1385,8 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 			check = true;
 
 		udp6_set_csum(!check, skb, &saddr, &cp->daddr.in6, skb->len);
-	}
+	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE)
+		ipvs_gre_encap(net, skb, cp, &next_protocol);
 
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
-- 
2.11.0

