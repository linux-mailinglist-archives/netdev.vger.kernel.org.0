Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83FF198422
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgC3TWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:22:14 -0400
Received: from correo.us.es ([193.147.175.20]:48510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbgC3TWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B55031022A7
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87233100A50
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80DC8100A45; Mon, 30 Mar 2020 21:21:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79687FF6F2;
        Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5530442EF4E1;
        Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/28] ipvs: optimize tunnel dumps for icmp errors
Date:   Mon, 30 Mar 2020 21:21:17 +0200
Message-Id: <20200330192136.230459-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

After strip GRE/UDP tunnel header for icmp errors, it's better to show
"GRE/UDP" instead of "IPIP" in debug message.

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 46 +++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 512259f579d7..d2ac530a9501 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1661,8 +1661,9 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	struct ip_vs_protocol *pp;
 	struct ip_vs_proto_data *pd;
 	unsigned int offset, offset2, ihl, verdict;
-	bool ipip, new_cp = false;
+	bool tunnel, new_cp = false;
 	union nf_inet_addr *raddr;
+	char *outer_proto;
 
 	*related = 1;
 
@@ -1703,8 +1704,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
 	raddr = (union nf_inet_addr *)&cih->daddr;
 
-	/* Special case for errors for IPIP packets */
-	ipip = false;
+	/* Special case for errors for IPIP/UDP/GRE tunnel packets */
+	tunnel = false;
 	if (cih->protocol == IPPROTO_IPIP) {
 		struct ip_vs_dest *dest;
 
@@ -1721,7 +1722,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
 		if (cih == NULL)
 			return NF_ACCEPT; /* The packet looks wrong, ignore */
-		ipip = true;
+		tunnel = true;
+		outer_proto = "IPIP";
 	} else if ((cih->protocol == IPPROTO_UDP ||	/* Can be UDP encap */
 		    cih->protocol == IPPROTO_GRE) &&	/* Can be GRE encap */
 		   /* Error for our tunnel must arrive at LOCAL_IN */
@@ -1729,16 +1731,19 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		__u8 iproto;
 		int ulen;
 
-		/* Non-first fragment has no UDP header */
+		/* Non-first fragment has no UDP/GRE header */
 		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
 			return NF_ACCEPT;
 		offset2 = offset + cih->ihl * 4;
-		if (cih->protocol == IPPROTO_UDP)
+		if (cih->protocol == IPPROTO_UDP) {
 			ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET,
 					      raddr, &iproto);
-		else
+			outer_proto = "UDP";
+		} else {
 			ulen = ipvs_gre_decap(ipvs, skb, offset2, AF_INET,
 					      raddr, &iproto);
+			outer_proto = "GRE";
+		}
 		if (ulen > 0) {
 			/* Skip IP and UDP/GRE tunnel headers */
 			offset = offset2 + ulen;
@@ -1747,7 +1752,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 						 &_ciph);
 			if (cih && cih->version == 4 && cih->ihl >= 5 &&
 			    iproto == IPPROTO_IPIP)
-				ipip = true;
+				tunnel = true;
 			else
 				return NF_ACCEPT;
 		}
@@ -1767,11 +1772,11 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		      "Checking incoming ICMP for");
 
 	offset2 = offset;
-	ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, !ipip, &ciph);
+	ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, !tunnel, &ciph);
 	offset = ciph.len;
 
 	/* The embedded headers contain source and dest in reverse order.
-	 * For IPIP this is error for request, not for reply.
+	 * For IPIP/UDP/GRE tunnel this is error for request, not for reply.
 	 */
 	cp = INDIRECT_CALL_1(pp->conn_in_get, ip_vs_conn_in_get_proto,
 			     ipvs, AF_INET, skb, &ciph);
@@ -1779,7 +1784,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	if (!cp) {
 		int v;
 
-		if (ipip || !sysctl_schedule_icmp(ipvs))
+		if (tunnel || !sysctl_schedule_icmp(ipvs))
 			return NF_ACCEPT;
 
 		if (!ip_vs_try_to_schedule(ipvs, AF_INET, skb, pd, &v, &cp, &ciph))
@@ -1797,7 +1802,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		goto out;
 	}
 
-	if (ipip) {
+	if (tunnel) {
 		__be32 info = ic->un.gateway;
 		__u8 type = ic->type;
 		__u8 code = ic->code;
@@ -1809,17 +1814,18 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 			u32 mtu = ntohs(ic->un.frag.mtu);
 			__be16 frag_off = cih->frag_off;
 
-			/* Strip outer IP and ICMP, go to IPIP header */
+			/* Strip outer IP and ICMP, go to IPIP/UDP/GRE header */
 			if (pskb_pull(skb, ihl + sizeof(_icmph)) == NULL)
-				goto ignore_ipip;
+				goto ignore_tunnel;
 			offset2 -= ihl + sizeof(_icmph);
 			skb_reset_network_header(skb);
-			IP_VS_DBG(12, "ICMP for IPIP %pI4->%pI4: mtu=%u\n",
-				&ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr, mtu);
+			IP_VS_DBG(12, "ICMP for %s %pI4->%pI4: mtu=%u\n",
+				  outer_proto, &ip_hdr(skb)->saddr,
+				  &ip_hdr(skb)->daddr, mtu);
 			ipv4_update_pmtu(skb, ipvs->net, mtu, 0, 0);
 			/* Client uses PMTUD? */
 			if (!(frag_off & htons(IP_DF)))
-				goto ignore_ipip;
+				goto ignore_tunnel;
 			/* Prefer the resulting PMTU */
 			if (dest) {
 				struct ip_vs_dest_dst *dest_dst;
@@ -1832,11 +1838,11 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 				mtu -= sizeof(struct iphdr);
 			info = htonl(mtu);
 		}
-		/* Strip outer IP, ICMP and IPIP, go to IP header of
+		/* Strip outer IP, ICMP and IPIP/UDP/GRE, go to IP header of
 		 * original request.
 		 */
 		if (pskb_pull(skb, offset2) == NULL)
-			goto ignore_ipip;
+			goto ignore_tunnel;
 		skb_reset_network_header(skb);
 		IP_VS_DBG(12, "Sending ICMP for %pI4->%pI4: t=%u, c=%u, i=%u\n",
 			&ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr,
@@ -1845,7 +1851,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		/* ICMP can be shorter but anyways, account it */
 		ip_vs_out_stats(cp, skb);
 
-ignore_ipip:
+ignore_tunnel:
 		consume_skb(skb);
 		verdict = NF_STOLEN;
 		goto out;
-- 
2.11.0

