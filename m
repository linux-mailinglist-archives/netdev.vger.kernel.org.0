Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F32214D1B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgGEO2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 10:28:41 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:54053 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgGEO2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 10:28:41 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 6C43841168;
        Sun,  5 Jul 2020 22:28:35 +0800 (CST)
From:   wenxu@ucloud.cn
To:     davem@davemloft.net, pablo@netfilter.org
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next 2/3] netfilter: nf_conntrack_reasm: make nf_ct_frag6_gather elide the CB clear
Date:   Sun,  5 Jul 2020 22:28:31 +0800
Message-Id: <1593959312-6135-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
References: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0JPQkJCQktCT0tLQk9ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXMjULOBw*FSkRDi9PDD0dTTMrMjocVlZVTktJQkkoSVlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NE06CTo5PT5PCk0WETkILTEp
        KgwwCQhVSlVKTkJIQk5CSEpOTk1OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpLTEpKNwY+
X-HM-Tid: 0a731f60f8012086kuqy6c43841168
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Make nf_ct_frag6_gather elide the CB clear when packets are defragmented
by connection tracking. This can make each subsystem such as br_netfilter
, openvswitch, act_ct do defrag without restore the CB. And avoid
serious crashes and problems in ct subsystem. Because Some packet
schedulers store pointers in the qdisc CB private area and Parallel
accesses to the SKB.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/linux/netfilter_ipv6.h              |  9 +++++----
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |  3 ++-
 net/bridge/netfilter/nf_conntrack_bridge.c  |  7 ++-----
 net/ipv6/netfilter/nf_conntrack_reasm.c     | 19 ++++++++++++-------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |  3 ++-
 net/openvswitch/conntrack.c                 |  8 +++-----
 net/sched/act_ct.c                          |  3 +--
 7 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index aac42c2..ef9fa28 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -58,7 +58,8 @@ struct nf_ipv6_ops {
 			int (*output)(struct net *, struct sock *, struct sk_buff *));
 	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
 #if IS_MODULE(CONFIG_IPV6)
-	int (*br_defrag)(struct net *net, struct sk_buff *skb, u32 user);
+	int (*br_defrag)(struct net *net, struct sk_buff *skb, u32 user,
+			 u16 *frag_max_size);
 	int (*br_fragment)(struct net *net, struct sock *sk,
 			   struct sk_buff *skb,
 			   struct nf_bridge_frag_data *data,
@@ -118,7 +119,7 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 
 static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
-				    u32 user)
+				    u32 user, u16 *frag_max_size)
 {
 #if IS_MODULE(CONFIG_IPV6)
 	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
@@ -126,9 +127,9 @@ static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
 	if (!v6_ops)
 		return 1;
 
-	return v6_ops->br_defrag(net, skb, user);
+	return v6_ops->br_defrag(net, skb, user, frag_max_size);
 #elif IS_BUILTIN(CONFIG_IPV6)
-	return nf_ct_frag6_gather(net, skb, user);
+	return nf_ct_frag6_gather(net, skb, user, frag_max_size);
 #else
 	return 1;
 #endif
diff --git a/include/net/netfilter/ipv6/nf_defrag_ipv6.h b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
index 6d31cd0..d83add2 100644
--- a/include/net/netfilter/ipv6/nf_defrag_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
@@ -9,7 +9,8 @@
 
 int nf_ct_frag6_init(void);
 void nf_ct_frag6_cleanup(void);
-int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user);
+int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb,
+		       u32 user, u16 *frag_max_size);
 
 struct inet_frags_ctl;
 
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8096732..a11927b 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -170,7 +170,6 @@ static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
 {
 	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
 	enum ip_conntrack_info ctinfo;
-	struct br_input_skb_cb cb;
 	const struct nf_conn *ct;
 	int err;
 
@@ -178,15 +177,13 @@ static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
 	if (ct)
 		zone_id = nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo));
 
-	br_skb_cb_save(skb, &cb, sizeof(struct inet6_skb_parm));
-
 	err = nf_ipv6_br_defrag(state->net, skb,
-				IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
+				IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id,
+				&BR_INPUT_SKB_CB(skb)->frag_max_size);
 	/* queued */
 	if (err == -EINPROGRESS)
 		return NF_STOLEN;
 
-	br_skb_cb_restore(skb, &cb, IP6CB(skb)->frag_max_size);
 	return err == 0 ? NF_ACCEPT : NF_DROP;
 }
 
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index fed9666..ab28390 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -128,7 +128,8 @@ static void __net_exit nf_ct_frags6_sysctl_unregister(struct net *net)
 #endif
 
 static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
-			     struct sk_buff *prev_tail, struct net_device *dev);
+			     struct sk_buff *prev_tail, struct net_device *dev,
+			     u16 *frag_max_size);
 
 static inline u8 ip6_frag_ecn(const struct ipv6hdr *ipv6h)
 {
@@ -167,7 +168,8 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 
 
 static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
-			     const struct frag_hdr *fhdr, int nhoff)
+			     const struct frag_hdr *fhdr, int nhoff,
+			     u16 *frag_max_size)
 {
 	unsigned int payload_len;
 	struct net_device *dev;
@@ -286,7 +288,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 		unsigned long orefdst = skb->_skb_refdst;
 
 		skb->_skb_refdst = 0UL;
-		err = nf_ct_frag6_reasm(fq, skb, prev, dev);
+		err = nf_ct_frag6_reasm(fq, skb, prev, dev, frag_max_size);
 		skb->_skb_refdst = orefdst;
 
 		/* After queue has assumed skb ownership, only 0 or
@@ -313,7 +315,8 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
  *	the last and the first frames arrived and all the bits are here.
  */
 static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
-			     struct sk_buff *prev_tail, struct net_device *dev)
+			     struct sk_buff *prev_tail, struct net_device *dev,
+			     u16 *frag_max_size)
 {
 	void *reasm_data;
 	int payload_len;
@@ -354,7 +357,8 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	skb->dev = dev;
 	ipv6_hdr(skb)->payload_len = htons(payload_len);
 	ipv6_change_dsfield(ipv6_hdr(skb), 0xff, ecn);
-	IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
+	if (frag_max_size)
+		*frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
 
 	/* Yes, and fold redundant checksum back. 8) */
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
@@ -436,7 +440,8 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	return 0;
 }
 
-int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
+int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb,
+		       u32 user, u16 *frag_max_size)
 {
 	u16 savethdr = skb->transport_header;
 	int fhoff, nhoff, ret;
@@ -471,7 +476,7 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 
 	spin_lock_bh(&fq->q.lock);
 
-	ret = nf_ct_frag6_queue(fq, skb, fhdr, nhoff);
+	ret = nf_ct_frag6_queue(fq, skb, fhdr, nhoff, frag_max_size);
 	if (ret == -EPROTO) {
 		skb->transport_header = savethdr;
 		ret = 0;
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 6646a87..7d532ed 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -64,7 +64,8 @@ static unsigned int ipv6_defrag(void *priv,
 #endif
 
 	err = nf_ct_frag6_gather(state->net, skb,
-				 nf_ct6_defrag_user(state->hook, skb));
+				 nf_ct6_defrag_user(state->hook, skb),
+				 &IP6CB(skb)->frag_max_size);
 	/* queued */
 	if (err == -EINPROGRESS)
 		return NF_STOLEN;
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4340f25..5984a84 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -493,11 +493,11 @@ static int ovs_ct_helper(struct sk_buff *skb, u16 proto)
 static int handle_fragments(struct net *net, struct sw_flow_key *key,
 			    u16 zone, struct sk_buff *skb)
 {
-	struct ovs_skb_cb ovs_cb = *OVS_CB(skb);
 	int err;
 
 	if (key->eth.type == htons(ETH_P_IP)) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
+		struct ovs_skb_cb ovs_cb = *OVS_CB(skb);
 
 		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 		err = ip_defrag(net, skb, user);
@@ -505,12 +505,12 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
 			return err;
 
 		ovs_cb.mru = IPCB(skb)->frag_max_size;
+		*OVS_CB(skb) = ovs_cb;
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	} else if (key->eth.type == htons(ETH_P_IPV6)) {
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
 
-		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
-		err = nf_ct_frag6_gather(net, skb, user);
+		err = nf_ct_frag6_gather(net, skb, user, &OVS_CB(skb)->mru);
 		if (err) {
 			if (err != -EINPROGRESS)
 				kfree_skb(skb);
@@ -518,7 +518,6 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
 		}
 
 		key->ip.proto = ipv6_hdr(skb)->nexthdr;
-		ovs_cb.mru = IP6CB(skb)->frag_max_size;
 #endif
 	} else {
 		kfree_skb(skb);
@@ -533,7 +532,6 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
 	key->ip.frag = OVS_FRAG_TYPE_NONE;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
-	*OVS_CB(skb) = ovs_cb;
 
 	return 0;
 }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 1b9c6d4..20f3d11 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -707,8 +707,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
 
-		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
-		err = nf_ct_frag6_gather(net, skb, user);
+		err = nf_ct_frag6_gather(net, skb, user, NULL);
 		if (err && err != -EINPROGRESS)
 			goto out_free;
 #else
-- 
1.8.3.1

