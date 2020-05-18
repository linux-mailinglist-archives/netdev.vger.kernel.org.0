Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E107A1D8968
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgERUka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:40:30 -0400
Received: from novek.ru ([213.148.174.62]:49112 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbgERUk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 16:40:27 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2CC755028C6;
        Mon, 18 May 2020 23:33:54 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2CC755028C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589834039; bh=JQrwwNpRCOO3HdHhc1wc8aZkx8bpq+/eg7ywlyK25TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ewz25w+xc6VQoIBvkvzBXa4ESVu461zay68Mni8OKXuACaxz2c9759MPOSTCzyc9Y
         5/1ZHQlzcFzZHC23a+/PVn6ttXo2BCl/NFJIkNzMGn9HvHpku+QTW1w/jUzsPqAb6g
         B03KEfCNwAvzVOEvISCjqmm+RFOGRg/e32bpvukQ=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net-next 1/5] ip6_tunnel: simplify transmit path
Date:   Mon, 18 May 2020 23:33:44 +0300
Message-Id: <1589834028-9929-2-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
References: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge ip{4,6}ip6_tnl_xmit functions into one universal
ipxip6_tnl_xmit in preparation for adding MPLS support.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv6/ip6_tunnel.c | 182 ++++++++++++++++++++++----------------------------
 1 file changed, 79 insertions(+), 103 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 4703b09..dae6f71 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1253,22 +1253,22 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 EXPORT_SYMBOL(ip6_tnl_xmit);
 
 static inline int
-ip4ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev)
+ipxip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev,
+		u8 protocol)
 {
 	struct ip6_tnl *t = netdev_priv(dev);
+	struct ipv6hdr *ipv6h;
 	const struct iphdr  *iph;
 	int encap_limit = -1;
+	__u16 offset;
 	struct flowi6 fl6;
-	__u8 dsfield;
+	__u8 dsfield, orig_dsfield;
 	__u32 mtu;
 	u8 tproto;
 	int err;
 
-	iph = ip_hdr(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
-
 	tproto = READ_ONCE(t->parms.proto);
-	if (tproto != IPPROTO_IPIP && tproto != 0)
+	if (tproto != protocol && tproto != 0)
 		return -1;
 
 	if (t->parms.collect_md) {
@@ -1281,129 +1281,101 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 			return -1;
 		key = &tun_info->key;
 		memset(&fl6, 0, sizeof(fl6));
-		fl6.flowi6_proto = IPPROTO_IPIP;
+		fl6.flowi6_proto = protocol;
 		fl6.saddr = key->u.ipv6.src;
 		fl6.daddr = key->u.ipv6.dst;
 		fl6.flowlabel = key->label;
 		dsfield =  key->tos;
+		switch (protocol) {
+		case IPPROTO_IPIP:
+			iph = ip_hdr(skb);
+			orig_dsfield = ipv4_get_dsfield(iph);
+			break;
+		case IPPROTO_IPV6:
+			ipv6h = ipv6_hdr(skb);
+			orig_dsfield = ipv6_get_dsfield(ipv6h);
+			break;
+		default:
+			orig_dsfield = dsfield;
+			break;
+		}
 	} else {
 		if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 			encap_limit = t->parms.encap_limit;
+		if (protocol == IPPROTO_IPV6) {
+			offset = ip6_tnl_parse_tlv_enc_lim(skb,
+						skb_network_header(skb));
+			/* ip6_tnl_parse_tlv_enc_lim() might have
+			 * reallocated skb->head
+			 */
+			if (offset > 0) {
+				struct ipv6_tlv_tnl_enc_lim *tel;
 
-		memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
-		fl6.flowi6_proto = IPPROTO_IPIP;
-
-		if (t->parms.flags & IP6_TNL_F_USE_ORIG_TCLASS)
-			dsfield = ipv4_get_dsfield(iph);
-		else
-			dsfield = ip6_tclass(t->parms.flowinfo);
-		if (t->parms.flags & IP6_TNL_F_USE_ORIG_FWMARK)
-			fl6.flowi6_mark = skb->mark;
-		else
-			fl6.flowi6_mark = t->parms.fwmark;
-	}
-
-	fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
-	dsfield = INET_ECN_encapsulate(dsfield, ipv4_get_dsfield(iph));
-
-	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
-		return -1;
-
-	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
-
-	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
-			   IPPROTO_IPIP);
-	if (err != 0) {
-		/* XXX: send ICMP error even if DF is not set. */
-		if (err == -EMSGSIZE)
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-				  htonl(mtu));
-		return -1;
-	}
-
-	return 0;
-}
-
-static inline int
-ip6ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	struct ip6_tnl *t = netdev_priv(dev);
-	struct ipv6hdr *ipv6h;
-	int encap_limit = -1;
-	__u16 offset;
-	struct flowi6 fl6;
-	__u8 dsfield;
-	__u32 mtu;
-	u8 tproto;
-	int err;
-
-	ipv6h = ipv6_hdr(skb);
-	tproto = READ_ONCE(t->parms.proto);
-	if ((tproto != IPPROTO_IPV6 && tproto != 0) ||
-	    ip6_tnl_addr_conflict(t, ipv6h))
-		return -1;
-
-	if (t->parms.collect_md) {
-		struct ip_tunnel_info *tun_info;
-		const struct ip_tunnel_key *key;
-
-		tun_info = skb_tunnel_info(skb);
-		if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
-			     ip_tunnel_info_af(tun_info) != AF_INET6))
-			return -1;
-		key = &tun_info->key;
-		memset(&fl6, 0, sizeof(fl6));
-		fl6.flowi6_proto = IPPROTO_IPV6;
-		fl6.saddr = key->u.ipv6.src;
-		fl6.daddr = key->u.ipv6.dst;
-		fl6.flowlabel = key->label;
-		dsfield = key->tos;
-	} else {
-		offset = ip6_tnl_parse_tlv_enc_lim(skb, skb_network_header(skb));
-		/* ip6_tnl_parse_tlv_enc_lim() might have reallocated skb->head */
-		ipv6h = ipv6_hdr(skb);
-		if (offset > 0) {
-			struct ipv6_tlv_tnl_enc_lim *tel;
-
-			tel = (void *)&skb_network_header(skb)[offset];
-			if (tel->encap_limit == 0) {
-				icmpv6_send(skb, ICMPV6_PARAMPROB,
-					    ICMPV6_HDR_FIELD, offset + 2);
-				return -1;
+				tel = (void *)&skb_network_header(skb)[offset];
+				if (tel->encap_limit == 0) {
+					icmpv6_send(skb, ICMPV6_PARAMPROB,
+						ICMPV6_HDR_FIELD, offset + 2);
+					return -1;
+				}
+				encap_limit = tel->encap_limit - 1;
 			}
-			encap_limit = tel->encap_limit - 1;
-		} else if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT)) {
-			encap_limit = t->parms.encap_limit;
 		}
 
 		memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
-		fl6.flowi6_proto = IPPROTO_IPV6;
+		fl6.flowi6_proto = protocol;
 
-		if (t->parms.flags & IP6_TNL_F_USE_ORIG_TCLASS)
-			dsfield = ipv6_get_dsfield(ipv6h);
-		else
-			dsfield = ip6_tclass(t->parms.flowinfo);
-		if (t->parms.flags & IP6_TNL_F_USE_ORIG_FLOWLABEL)
-			fl6.flowlabel |= ip6_flowlabel(ipv6h);
 		if (t->parms.flags & IP6_TNL_F_USE_ORIG_FWMARK)
 			fl6.flowi6_mark = skb->mark;
 		else
 			fl6.flowi6_mark = t->parms.fwmark;
+		switch (protocol) {
+		case IPPROTO_IPIP:
+			iph = ip_hdr(skb);
+			orig_dsfield = ipv4_get_dsfield(iph);
+			if (t->parms.flags & IP6_TNL_F_USE_ORIG_TCLASS)
+				dsfield = orig_dsfield;
+			else
+				dsfield = ip6_tclass(t->parms.flowinfo);
+			break;
+		case IPPROTO_IPV6:
+			ipv6h = ipv6_hdr(skb);
+			orig_dsfield = ipv6_get_dsfield(ipv6h);
+			if (t->parms.flags & IP6_TNL_F_USE_ORIG_TCLASS)
+				dsfield = orig_dsfield;
+			else
+				dsfield = ip6_tclass(t->parms.flowinfo);
+			if (t->parms.flags & IP6_TNL_F_USE_ORIG_FLOWLABEL)
+				fl6.flowlabel |= ip6_flowlabel(ipv6h);
+			break;
+		default:
+			break;
+		}
 	}
 
 	fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
-	dsfield = INET_ECN_encapsulate(dsfield, ipv6_get_dsfield(ipv6h));
+	dsfield = INET_ECN_encapsulate(dsfield, orig_dsfield);
 
 	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
 		return -1;
 
-	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
+	skb_set_inner_ipproto(skb, protocol);
 
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
-			   IPPROTO_IPV6);
+			   protocol);
 	if (err != 0) {
+		/* XXX: send ICMP error even if DF is not set. */
 		if (err == -EMSGSIZE)
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			switch (protocol) {
+			case IPPROTO_IPIP:
+				icmp_send(skb, ICMP_DEST_UNREACH,
+					  ICMP_FRAG_NEEDED, htonl(mtu));
+				break;
+			case IPPROTO_IPV6:
+				icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+				break;
+			default:
+				break;
+			}
 		return -1;
 	}
 
@@ -1415,6 +1387,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 {
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct net_device_stats *stats = &t->dev->stats;
+	u8 ipproto;
 	int ret;
 
 	if (!pskb_inet_may_pull(skb))
@@ -1422,15 +1395,18 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		ret = ip4ip6_tnl_xmit(skb, dev);
+		ipproto = IPPROTO_IPIP;
 		break;
 	case htons(ETH_P_IPV6):
-		ret = ip6ip6_tnl_xmit(skb, dev);
+		if (ip6_tnl_addr_conflict(t, ipv6_hdr(skb)))
+			goto tx_err;
+		ipproto = IPPROTO_IPV6;
 		break;
 	default:
 		goto tx_err;
 	}
 
+	ret = ipxip6_tnl_xmit(skb, dev, ipproto);
 	if (ret < 0)
 		goto tx_err;
 
-- 
1.8.3.1

