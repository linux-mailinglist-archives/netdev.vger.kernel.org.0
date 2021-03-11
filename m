Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633463368F1
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhCKAgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:53 -0500
Received: from correo.us.es ([193.147.175.20]:50116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229875AbhCKAgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1353012E82E
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05DA4DA791
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EF672DA78C; Thu, 11 Mar 2021 01:36:22 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83DB7DA730;
        Thu, 11 Mar 2021 01:36:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4F27942DC6E2;
        Thu, 11 Mar 2021 01:36:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 12/23] netfilter: flowtable: add pppoe support
Date:   Thu, 11 Mar 2021 01:35:53 +0100
Message-Id: <20210311003604.22199-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the PPPoE protocol and session id to the flow tuple using the encap
fields to uniquely identify flows from the receive path. For the
transmit path, dev_hard_header() on the vlan device push the headers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 83 +++++++++++++++++++++++++-------
 net/netfilter/nft_flow_offload.c |  5 +-
 2 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 127e9b9ffe10..d39946118d67 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -7,6 +7,9 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/netdevice.h>
+#include <linux/if_ether.h>
+#include <linux/if_pppox.h>
+#include <linux/ppp_defs.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
@@ -162,6 +165,8 @@ static bool ip_has_options(unsigned int thoff)
 static void nf_flow_tuple_encap(struct sk_buff *skb,
 				struct flow_offload_tuple *tuple)
 {
+	struct vlan_ethhdr *veth;
+	struct pppoe_hdr *phdr;
 	int i = 0;
 
 	if (skb_vlan_tag_present(skb)) {
@@ -169,23 +174,35 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 		tuple->encap[i].proto = skb->vlan_proto;
 		i++;
 	}
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		struct vlan_ethhdr *veth = (struct vlan_ethhdr *)skb_mac_header(skb);
-
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		tuple->encap[i].id = ntohs(veth->h_vlan_TCI);
 		tuple->encap[i].proto = skb->protocol;
+		break;
+	case htons(ETH_P_PPP_SES):
+		phdr = (struct pppoe_hdr *)skb_mac_header(skb);
+		tuple->encap[i].id = ntohs(phdr->sid);
+		tuple->encap[i].proto = skb->protocol;
+		break;
 	}
 }
 
 static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
-			    struct flow_offload_tuple *tuple)
+			    struct flow_offload_tuple *tuple, u32 *nhoff)
 {
 	unsigned int thoff, hdrsize, offset = 0;
 	struct flow_ports *ports;
 	struct iphdr *iph;
 
-	if (skb->protocol == htons(ETH_P_8021Q))
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
 		offset += VLAN_HLEN;
+		break;
+	case htons(ETH_P_PPP_SES):
+		offset += PPPOE_SES_HLEN;
+		break;
+	}
 
 	if (!pskb_may_pull(skb, sizeof(*iph) + offset))
 		return -1;
@@ -226,6 +243,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	tuple->l4proto		= iph->protocol;
 	tuple->iifidx		= dev->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
+	*nhoff = offset;
 
 	return 0;
 }
@@ -270,14 +288,36 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
+static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
+{
+	__be16 proto;
+
+	proto = *((__be16 *)(skb_mac_header(skb) + ETH_HLEN +
+			     sizeof(struct pppoe_hdr)));
+	switch (proto) {
+	case htons(PPP_IP):
+		return htons(ETH_P_IP);
+	case htons(PPP_IPV6):
+		return htons(ETH_P_IPV6);
+	}
+
+	return 0;
+}
+
 static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto)
 {
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		struct vlan_ethhdr *veth;
+	struct vlan_ethhdr *veth;
 
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		if (veth->h_vlan_encapsulated_proto == proto)
 			return true;
+		break;
+	case htons(ETH_P_PPP_SES):
+		if (nf_flow_pppoe_proto(skb) == proto)
+			return true;
+		break;
 	}
 
 	return false;
@@ -294,12 +334,18 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 			__vlan_hwaccel_clear_tag(skb);
 			continue;
 		}
-		if (skb->protocol == htons(ETH_P_8021Q)) {
+		switch (skb->protocol) {
+		case htons(ETH_P_8021Q):
 			vlan_hdr = (struct vlan_hdr *)skb->data;
 			__skb_pull(skb, VLAN_HLEN);
 			vlan_set_encap_proto(skb, vlan_hdr);
 			skb_reset_network_header(skb);
 			break;
+		case htons(ETH_P_PPP_SES):
+			skb->protocol = nf_flow_pppoe_proto(skb);
+			skb_pull(skb, PPPOE_SES_HLEN);
+			skb_reset_network_header(skb);
+			break;
 		}
 	}
 }
@@ -343,7 +389,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP)))
 		return NF_ACCEPT;
 
-	if (nf_flow_tuple_ip(skb, state->in, &tuple) < 0)
+	if (nf_flow_tuple_ip(skb, state->in, &tuple, &offset) < 0)
 		return NF_ACCEPT;
 
 	tuplehash = flow_offload_lookup(flow_table, &tuple);
@@ -357,9 +403,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return NF_ACCEPT;
 
-	if (skb->protocol == htons(ETH_P_8021Q))
-		offset += VLAN_HLEN;
-
 	if (skb_try_make_writable(skb, sizeof(*iph) + offset))
 		return NF_DROP;
 
@@ -543,14 +586,20 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 }
 
 static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
-			      struct flow_offload_tuple *tuple)
+			      struct flow_offload_tuple *tuple, u32 *nhoff)
 {
 	unsigned int thoff, hdrsize, offset = 0;
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 
-	if (skb->protocol == htons(ETH_P_8021Q))
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
 		offset += VLAN_HLEN;
+		break;
+	case htons(ETH_P_PPP_SES):
+		offset += PPPOE_SES_HLEN;
+		break;
+	}
 
 	if (!pskb_may_pull(skb, sizeof(*ip6h) + offset))
 		return -1;
@@ -586,6 +635,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	tuple->l4proto		= ip6h->nexthdr;
 	tuple->iifidx		= dev->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
+	*nhoff = offset;
 
 	return 0;
 }
@@ -611,7 +661,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IPV6)))
 		return NF_ACCEPT;
 
-	if (nf_flow_tuple_ipv6(skb, state->in, &tuple) < 0)
+	if (nf_flow_tuple_ipv6(skb, state->in, &tuple, &offset) < 0)
 		return NF_ACCEPT;
 
 	tuplehash = flow_offload_lookup(flow_table, &tuple);
@@ -625,9 +675,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return NF_ACCEPT;
 
-	if (skb->protocol == htons(ETH_P_8021Q))
-		offset += VLAN_HLEN;
-
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, sizeof(*ip6h)))
 		return NF_ACCEPT;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 651364d93efd..81a5e2b6c901 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -90,6 +90,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_VLAN:
+		case DEV_PATH_PPPOE:
 			info->indev = path->dev;
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
@@ -97,7 +98,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			if (path->type == DEV_PATH_ETHERNET)
 				break;
 
-			/* DEV_PATH_VLAN */
+			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
 			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
 				info->indev = NULL;
 				break;
@@ -106,6 +107,8 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
+			if (path->type == DEV_PATH_PPPOE)
+				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
 			break;
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
-- 
2.20.1

