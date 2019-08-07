Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1493F84B3A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 14:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbfHGMIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 08:08:49 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43074 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729238AbfHGMIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 08:08:49 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Aug 2019 15:08:43 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x77C8hr8024370;
        Wed, 7 Aug 2019 15:08:43 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc chain index
Date:   Wed,  7 Aug 2019 15:08:42 +0300
Message-Id: <1565179722-22488-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloaded OvS datapath rules are translated one to one to tc rules,
for example the following simplified OvS rule:

recirc_id(0),in_port(dev1),eth_type(0x0800),ct_state(-trk) actions:ct(),recirc(2)

Will be translated to the following tc rule:

$ tc filter add dev dev1 ingress \
	    prio 1 chain 0 proto ip \
		flower tcp ct_state -trk \
		action ct pipe \
		action goto chain 2

Received packets will first travel though tc, and if they aren't stolen
by it, like in the above rule, they will continue to OvS datapath.
Since we already did some actions (action ct in this case) which might
modify the packets, and updated action stats, we would like to continue
the proccessing with the correct recirc_id in OvS (here recirc_id(2))
where we left off.

To support this, introduce a new skb extension for tc, which
will be used for translating tc chain to ovs recirc_id to
handle these miss cases. Last tc chain index will be set
by tc goto chain action and read by OvS datapath.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/skbuff.h    | 13 +++++++++++++
 include/net/sch_generic.h |  5 ++++-
 net/core/skbuff.c         |  6 ++++++
 net/openvswitch/flow.c    |  9 +++++++++
 net/sched/Kconfig         | 13 +++++++++++++
 net/sched/act_api.c       |  1 +
 net/sched/cls_api.c       | 12 ++++++++++++
 7 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3aef8d8..fb2a792 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -279,6 +279,16 @@ struct nf_bridge_info {
 };
 #endif
 
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+/* Chain in tc_skb_ext will be used to share the tc chain with
+ * ovs recirc_id. It will be set to the current chain by tc
+ * and read by ovs to recirc_id.
+ */
+struct tc_skb_ext {
+	__u32 chain;
+};
+#endif
+
 struct sk_buff_head {
 	/* These two members must be first. */
 	struct sk_buff	*next;
@@ -4050,6 +4060,9 @@ enum skb_ext_id {
 #ifdef CONFIG_XFRM
 	SKB_EXT_SEC_PATH,
 #endif
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	TC_SKB_EXT,
+#endif
 	SKB_EXT_NUM, /* must be last */
 };
 
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 6b6b012..871feea 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -275,7 +275,10 @@ struct tcf_result {
 			unsigned long	class;
 			u32		classid;
 		};
-		const struct tcf_proto *goto_tp;
+		struct {
+			const struct tcf_proto *goto_tp;
+			u32 goto_index;
+		};
 
 		/* used in the skb_tc_reinsert function */
 		struct {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ea8e8d3..2b40b5a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4087,6 +4087,9 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 #ifdef CONFIG_XFRM
 	[SKB_EXT_SEC_PATH] = SKB_EXT_CHUNKSIZEOF(struct sec_path),
 #endif
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	[TC_SKB_EXT] = SKB_EXT_CHUNKSIZEOF(struct tc_skb_ext),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4098,6 +4101,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #ifdef CONFIG_XFRM
 		skb_ext_type_len[SKB_EXT_SEC_PATH] +
 #endif
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+		skb_ext_type_len[TC_SKB_EXT] +
+#endif
 		0;
 }
 
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index bc89e16..0287ead 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -816,6 +816,9 @@ static int key_extract_mac_proto(struct sk_buff *skb)
 int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 			 struct sk_buff *skb, struct sw_flow_key *key)
 {
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	struct tc_skb_ext *tc_ext;
+#endif
 	int res, err;
 
 	/* Extract metadata from packet. */
@@ -848,7 +851,13 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 	if (res < 0)
 		return res;
 	key->mac_proto = res;
+
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	tc_ext = skb_ext_find(skb, TC_SKB_EXT);
+	key->recirc_id = tc_ext ? tc_ext->chain : 0;
+#else
 	key->recirc_id = 0;
+#endif
 
 	err = key_extract(skb, key);
 	if (!err)
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index afd2ba1..b3faafe 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -963,6 +963,19 @@ config NET_IFE_SKBTCINDEX
         tristate "Support to encoding decoding skb tcindex on IFE action"
         depends on NET_ACT_IFE
 
+config NET_TC_SKB_EXT
+	bool "TC recirculation support"
+	depends on NET_CLS_ACT
+	default y if NET_CLS_ACT
+	select SKB_EXTENSIONS
+
+	help
+	  Say Y here to allow tc chain misses to continue in OvS datapath in
+	  the correct recirc_id, and hardware chain misses to continue in
+	  the correct chain in tc software datapath.
+
+	  Say N here if you won't be using tc<->ovs offload or tc chains offload.
+
 endif # NET_SCHED
 
 config NET_SCH_FIFO
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 3397122..c393604 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -27,6 +27,7 @@ static void tcf_action_goto_chain_exec(const struct tc_action *a,
 {
 	const struct tcf_chain *chain = rcu_dereference_bh(a->goto_chain);
 
+	res->goto_index = chain->index;
 	res->goto_tp = rcu_dereference_bh(chain->filter_chain);
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3565d9a..b0b829a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1660,6 +1660,18 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 			goto reset;
 		} else if (unlikely(TC_ACT_EXT_CMP(err, TC_ACT_GOTO_CHAIN))) {
 			first_tp = res->goto_tp;
+
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+			{
+				struct tc_skb_ext *ext;
+
+				ext = skb_ext_add(skb, TC_SKB_EXT);
+				if (WARN_ON_ONCE(!ext))
+					return TC_ACT_SHOT;
+
+				ext->chain = res->goto_index;
+			}
+#endif
 			goto reset;
 		}
 #endif
-- 
1.8.3.1

