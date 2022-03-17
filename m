Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBE34DCF51
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 21:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiCQU06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 16:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiCQU04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 16:26:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2CD0156784;
        Thu, 17 Mar 2022 13:25:39 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3C93D63004;
        Thu, 17 Mar 2022 21:23:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/3] netfilter: flowtable: Fix QinQ and pppoe support for inet table
Date:   Thu, 17 Mar 2022 21:25:32 +0100
Message-Id: <20220317202534.41530-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220317202534.41530-1-pablo@netfilter.org>
References: <20220317202534.41530-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nf_flow_offload_inet_hook() does not check for 802.1q and PPPoE.
Fetch inner ethertype from these encapsulation protocols.

Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 18 ++++++++++++++++++
 net/netfilter/nf_flow_table_inet.c    | 17 +++++++++++++++++
 net/netfilter/nf_flow_table_ip.c      | 18 ------------------
 3 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index bd59e950f4d6..64daafd1fc41 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -10,6 +10,8 @@
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <net/flow_offload.h>
 #include <net/dst.h>
+#include <linux/if_pppox.h>
+#include <linux/ppp_defs.h>
 
 struct nf_flowtable;
 struct nf_flow_rule;
@@ -317,4 +319,20 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 int nf_flow_table_offload_init(void);
 void nf_flow_table_offload_exit(void);
 
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
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 5c57ade6bd05..0ccabf3fa6aa 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -6,12 +6,29 @@
 #include <linux/rhashtable.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_tables.h>
+#include <linux/if_vlan.h>
 
 static unsigned int
 nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)
 {
+	struct vlan_ethhdr *veth;
+	__be16 proto;
+
 	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
+		proto = veth->h_vlan_encapsulated_proto;
+		break;
+	case htons(ETH_P_PPP_SES):
+		proto = nf_flow_pppoe_proto(skb);
+		break;
+	default:
+		proto = skb->protocol;
+		break;
+	}
+
+	switch (proto) {
 	case htons(ETH_P_IP):
 		return nf_flow_offload_ip_hook(priv, skb, state);
 	case htons(ETH_P_IPV6):
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 889cf88d3dba..6257d87c3a56 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -8,8 +8,6 @@
 #include <linux/ipv6.h>
 #include <linux/netdevice.h>
 #include <linux/if_ether.h>
-#include <linux/if_pppox.h>
-#include <linux/ppp_defs.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
@@ -239,22 +237,6 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
-{
-	__be16 proto;
-
-	proto = *((__be16 *)(skb_mac_header(skb) + ETH_HLEN +
-			     sizeof(struct pppoe_hdr)));
-	switch (proto) {
-	case htons(PPP_IP):
-		return htons(ETH_P_IP);
-	case htons(PPP_IPV6):
-		return htons(ETH_P_IPV6);
-	}
-
-	return 0;
-}
-
 static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
 				       u32 *offset)
 {
-- 
2.30.2

