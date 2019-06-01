Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95EC53204F
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfFASYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:05 -0400
Received: from mail.us.es ([193.147.175.20]:39998 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfFASYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65214B60E1
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39E22DA710
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 074D1DA713; Sat,  1 Jun 2019 20:23:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4824FB7FEA;
        Sat,  1 Jun 2019 20:23:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DAB594265A32;
        Sat,  1 Jun 2019 20:23:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/15] ipvs: add function to find tunnels
Date:   Sat,  1 Jun 2019 20:23:27 +0200
Message-Id: <20190601182340.2662-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Add ip_vs_find_tunnel() to match tunnel headers
by family, address and optional port. Use it to
properly find the tunnel real server used in
received ICMP errors.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |  3 +++
 net/netfilter/ipvs/ip_vs_core.c |  8 ++++++++
 net/netfilter/ipvs/ip_vs_ctl.c  | 29 +++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 9a8ac8997e34..b01a94ebfc0e 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1404,6 +1404,9 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
 struct ip_vs_dest *
 ip_vs_find_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
 			const union nf_inet_addr *daddr, __be16 dport);
+struct ip_vs_dest *ip_vs_find_tunnel(struct netns_ipvs *ipvs, int af,
+				     const union nf_inet_addr *daddr,
+				     __be16 tun_port);
 
 int ip_vs_use_count_inc(void);
 void ip_vs_use_count_dec(void);
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 14457551bcb4..4447ee512b88 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1598,6 +1598,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	struct ip_vs_proto_data *pd;
 	unsigned int offset, offset2, ihl, verdict;
 	bool ipip, new_cp = false;
+	union nf_inet_addr *raddr;
 
 	*related = 1;
 
@@ -1636,15 +1637,22 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
 	if (cih == NULL)
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
+	raddr = (union nf_inet_addr *)&cih->daddr;
 
 	/* Special case for errors for IPIP packets */
 	ipip = false;
 	if (cih->protocol == IPPROTO_IPIP) {
+		struct ip_vs_dest *dest;
+
 		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
 			return NF_ACCEPT;
 		/* Error for our IPIP must arrive at LOCAL_IN */
 		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL))
 			return NF_ACCEPT;
+		dest = ip_vs_find_tunnel(ipvs, AF_INET, raddr, 0);
+		/* Only for known tunnel */
+		if (!dest || dest->tun_type != IP_VS_CONN_F_TUNNEL_TYPE_IPIP)
+			return NF_ACCEPT;
 		offset += cih->ihl * 4;
 		cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
 		if (cih == NULL)
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 30b1a9f9c2e3..d5847e06350f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -617,6 +617,35 @@ struct ip_vs_dest *ip_vs_find_real_service(struct netns_ipvs *ipvs, int af,
 	return NULL;
 }
 
+/* Find real service record by <af,addr,tun_port>.
+ * In case of multiple records with the same <af,addr,tun_port>, only
+ * the first found record is returned.
+ *
+ * To be called under RCU lock.
+ */
+struct ip_vs_dest *ip_vs_find_tunnel(struct netns_ipvs *ipvs, int af,
+				     const union nf_inet_addr *daddr,
+				     __be16 tun_port)
+{
+	struct ip_vs_dest *dest;
+	unsigned int hash;
+
+	/* Check for "full" addressed entries */
+	hash = ip_vs_rs_hashkey(af, daddr, tun_port);
+
+	hlist_for_each_entry_rcu(dest, &ipvs->rs_table[hash], d_list) {
+		if (dest->tun_port == tun_port &&
+		    dest->af == af &&
+		    ip_vs_addr_equal(af, &dest->addr, daddr) &&
+		    IP_VS_DFWD_METHOD(dest) == IP_VS_CONN_F_TUNNEL) {
+			/* HIT */
+			return dest;
+		}
+	}
+
+	return NULL;
+}
+
 /* Lookup destination by {addr,port} in the given service
  * Called under RCU lock.
  */
-- 
2.11.0

