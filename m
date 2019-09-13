Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21019B1C4F
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388222AbfIMLbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:50 -0400
Received: from correo.us.es ([193.147.175.20]:42594 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388148AbfIMLb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ACB094FFE17
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E1E7A7E1D
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9C49DA7E2C; Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6ACB0A7E1D;
        Fri, 13 Sep 2019 13:31:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 389CA4265A5A;
        Fri, 13 Sep 2019 13:31:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 18/27] netfilter: move nf_bridge_frag_data struct definition to a more appropriate header.
Date:   Fri, 13 Sep 2019 13:30:53 +0200
Message-Id: <20190913113102.15776-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

There is a struct definition function in nf_conntrack_bridge.h which is
not specific to conntrack and is used elswhere in netfilter.  Move it
into netfilter_bridge.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge.h            |  7 +++++++
 include/linux/netfilter_ipv6.h              | 14 +++++++-------
 include/net/netfilter/nf_conntrack_bridge.h |  7 -------
 net/bridge/netfilter/nf_conntrack_bridge.c  | 14 +++++++-------
 net/ipv6/netfilter.c                        |  4 ++--
 5 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 5f2614d02e03..f980edfdd278 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -5,6 +5,13 @@
 #include <uapi/linux/netfilter_bridge.h>
 #include <linux/skbuff.h>
 
+struct nf_bridge_frag_data {
+	char    mac[ETH_HLEN];
+	bool    vlan_present;
+	u16     vlan_tci;
+	__be16  vlan_proto;
+};
+
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 
 int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index c1500209cfaf..aac42c28fe62 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -32,7 +32,7 @@ struct ip6_rt_info {
 };
 
 struct nf_queue_entry;
-struct nf_ct_bridge_frag_data;
+struct nf_bridge_frag_data;
 
 /*
  * Hook functions for ipv6 to allow xt_* modules to be built-in even
@@ -61,9 +61,9 @@ struct nf_ipv6_ops {
 	int (*br_defrag)(struct net *net, struct sk_buff *skb, u32 user);
 	int (*br_fragment)(struct net *net, struct sock *sk,
 			   struct sk_buff *skb,
-			   struct nf_ct_bridge_frag_data *data,
+			   struct nf_bridge_frag_data *data,
 			   int (*output)(struct net *, struct sock *sk,
-					 const struct nf_ct_bridge_frag_data *data,
+					 const struct nf_bridge_frag_data *data,
 					 struct sk_buff *));
 #endif
 };
@@ -135,16 +135,16 @@ static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
 }
 
 int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
-		    struct nf_ct_bridge_frag_data *data,
+		    struct nf_bridge_frag_data *data,
 		    int (*output)(struct net *, struct sock *sk,
-				  const struct nf_ct_bridge_frag_data *data,
+				  const struct nf_bridge_frag_data *data,
 				  struct sk_buff *));
 
 static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
 				     struct sk_buff *skb,
-				     struct nf_ct_bridge_frag_data *data,
+				     struct nf_bridge_frag_data *data,
 				     int (*output)(struct net *, struct sock *sk,
-						   const struct nf_ct_bridge_frag_data *data,
+						   const struct nf_bridge_frag_data *data,
 						   struct sk_buff *))
 {
 #if IS_MODULE(CONFIG_IPV6)
diff --git a/include/net/netfilter/nf_conntrack_bridge.h b/include/net/netfilter/nf_conntrack_bridge.h
index 34c28f248b18..01b62fd5efa2 100644
--- a/include/net/netfilter/nf_conntrack_bridge.h
+++ b/include/net/netfilter/nf_conntrack_bridge.h
@@ -16,11 +16,4 @@ struct nf_ct_bridge_info {
 void nf_ct_bridge_register(struct nf_ct_bridge_info *info);
 void nf_ct_bridge_unregister(struct nf_ct_bridge_info *info);
 
-struct nf_ct_bridge_frag_data {
-	char	mac[ETH_HLEN];
-	bool	vlan_present;
-	u16	vlan_tci;
-	__be16	vlan_proto;
-};
-
 #endif
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index c9ce321fcac1..8842798c29e6 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -26,9 +26,9 @@
  */
 static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 			     struct sk_buff *skb,
-			     struct nf_ct_bridge_frag_data *data,
+			     struct nf_bridge_frag_data *data,
 			     int (*output)(struct net *, struct sock *sk,
-					   const struct nf_ct_bridge_frag_data *data,
+					   const struct nf_bridge_frag_data *data,
 					   struct sk_buff *))
 {
 	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
@@ -278,7 +278,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 }
 
 static void nf_ct_bridge_frag_save(struct sk_buff *skb,
-				   struct nf_ct_bridge_frag_data *data)
+				   struct nf_bridge_frag_data *data)
 {
 	if (skb_vlan_tag_present(skb)) {
 		data->vlan_present = true;
@@ -293,10 +293,10 @@ static void nf_ct_bridge_frag_save(struct sk_buff *skb,
 static unsigned int
 nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 		    int (*output)(struct net *, struct sock *sk,
-				  const struct nf_ct_bridge_frag_data *data,
+				  const struct nf_bridge_frag_data *data,
 				  struct sk_buff *))
 {
-	struct nf_ct_bridge_frag_data data;
+	struct nf_bridge_frag_data data;
 
 	if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
 		return NF_ACCEPT;
@@ -319,7 +319,7 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 
 /* Actually only slow path refragmentation needs this. */
 static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
-				     const struct nf_ct_bridge_frag_data *data)
+				     const struct nf_bridge_frag_data *data)
 {
 	int err;
 
@@ -340,7 +340,7 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 }
 
 static int nf_ct_bridge_refrag_post(struct net *net, struct sock *sk,
-				    const struct nf_ct_bridge_frag_data *data,
+				    const struct nf_bridge_frag_data *data,
 				    struct sk_buff *skb)
 {
 	int err;
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 61819ed858b1..a9bff556d3b2 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -113,9 +113,9 @@ int __nf_ip6_route(struct net *net, struct dst_entry **dst,
 EXPORT_SYMBOL_GPL(__nf_ip6_route);
 
 int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
-		    struct nf_ct_bridge_frag_data *data,
+		    struct nf_bridge_frag_data *data,
 		    int (*output)(struct net *, struct sock *sk,
-				  const struct nf_ct_bridge_frag_data *data,
+				  const struct nf_bridge_frag_data *data,
 				  struct sk_buff *))
 {
 	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
-- 
2.11.0

