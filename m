Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8E5346EDA
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhCXBcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:32:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60584 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbhCXBbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:19 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2F86A63129;
        Wed, 24 Mar 2021 02:31:08 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 12/24] netfilter: flowtable: add pppoe support
Date:   Wed, 24 Mar 2021 02:30:43 +0100
Message-Id: <20210324013055.5619-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the PPPoE protocol and session id to the flow tuple using the encap
fields to uniquely identify flows from the receive path. For the
transmit path, dev_hard_header() on the vlan device push the headers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: rebase on top of net-next. Calculate offset to layer 3 header from
    nf_flow_skb_encap_protocol().

 net/netfilter/nf_flow_table_ip.c | 53 ++++++++++++++++++++++++++++----
 net/netfilter/nft_flow_offload.c |  5 ++-
 2 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index d90636295b0d..12cb0cc6958c 100644
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
@@ -139,6 +142,8 @@ static bool ip_has_options(unsigned int thoff)
 static void nf_flow_tuple_encap(struct sk_buff *skb,
 				struct flow_offload_tuple *tuple)
 {
+	struct vlan_ethhdr *veth;
+	struct pppoe_hdr *phdr;
 	int i = 0;
 
 	if (skb_vlan_tag_present(skb)) {
@@ -146,11 +151,17 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
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
 
@@ -228,17 +239,41 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
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
 static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
 				       u32 *offset)
 {
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		struct vlan_ethhdr *veth;
+	struct vlan_ethhdr *veth;
 
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		if (veth->h_vlan_encapsulated_proto == proto) {
 			*offset += VLAN_HLEN;
 			return true;
 		}
+		break;
+	case htons(ETH_P_PPP_SES):
+		if (nf_flow_pppoe_proto(skb) == proto) {
+			*offset += PPPOE_SES_HLEN;
+			return true;
+		}
+		break;
 	}
 
 	return false;
@@ -255,12 +290,18 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
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

