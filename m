Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E86A95E92
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 14:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbfHTMbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 08:31:04 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39350 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728283AbfHTMbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 08:31:04 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Aug 2019 15:30:57 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7KCUvVN017040;
        Tue, 20 Aug 2019 15:30:57 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: [PATCH net-next v2] net: openvswitch: Set OvS recirc_id from tc chain index
Date:   Tue, 20 Aug 2019 15:30:51 +0300
Message-Id: <1566304251-15795-1-git-send-email-paulb@mellanox.com>
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
V2:
	Changed user_features to return not supported for requested user_features that aren't supported
	Added static key per pravin request, it is enabled on user_features request (And will be used by userspace to probe actual kernel support)

 include/linux/skbuff.h           | 13 +++++++++++++
 include/net/sch_generic.h        |  5 ++++-
 include/uapi/linux/openvswitch.h |  3 +++
 net/core/skbuff.c                |  6 ++++++
 net/openvswitch/datapath.c       | 38 +++++++++++++++++++++++++++++++++-----
 net/openvswitch/datapath.h       |  2 ++
 net/openvswitch/flow.c           | 13 +++++++++++++
 net/sched/Kconfig                | 13 +++++++++++++
 net/sched/act_api.c              |  1 +
 net/sched/cls_api.c              | 12 ++++++++++++
 10 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7eb28b7..29d7c5a 100644
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
index d9f359a..e896e95 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -272,7 +272,10 @@ struct tcf_result {
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
diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index f271f1e..1887a45 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -123,6 +123,9 @@ struct ovs_vport_stats {
 /* Allow datapath to associate multiple Netlink PIDs to each vport */
 #define OVS_DP_F_VPORT_PIDS	(1 << 1)
 
+/* Allow tc offload recirc sharing */
+#define OVS_DP_F_TC_RECIRC_SHARING	(1 << 2)
+
 /* Fixed logical ports. */
 #define OVSP_LOCAL      ((__u32)0)
 
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
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 65122bb..dde9d76 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1545,10 +1545,34 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb, struct genl_info *in
 	dp->user_features = 0;
 }
 
-static void ovs_dp_change(struct datapath *dp, struct nlattr *a[])
+DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
+
+static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 {
-	if (a[OVS_DP_ATTR_USER_FEATURES])
-		dp->user_features = nla_get_u32(a[OVS_DP_ATTR_USER_FEATURES]);
+	u32 user_features = 0;
+
+	if (a[OVS_DP_ATTR_USER_FEATURES]) {
+		user_features = nla_get_u32(a[OVS_DP_ATTR_USER_FEATURES]);
+
+		if (user_features & ~(OVS_DP_F_VPORT_PIDS |
+				      OVS_DP_F_UNALIGNED |
+				      OVS_DP_F_TC_RECIRC_SHARING))
+			return -EOPNOTSUPP;
+
+#if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+		if (user_features & OVS_DP_F_TC_RECIRC_SHARING)
+			return -EOPNOTSUPP;
+#endif
+	}
+
+	dp->user_features = user_features;
+
+	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
+		static_branch_enable(&tc_recirc_sharing_support);
+	else
+		static_branch_disable(&tc_recirc_sharing_support);
+
+	return 0;
 }
 
 static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
@@ -1610,7 +1634,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	parms.port_no = OVSP_LOCAL;
 	parms.upcall_portids = a[OVS_DP_ATTR_UPCALL_PID];
 
-	ovs_dp_change(dp, a);
+	err = ovs_dp_change(dp, a);
+	if (err)
+		goto err_destroy_meters;
 
 	/* So far only local changes have been made, now need the lock. */
 	ovs_lock();
@@ -1736,7 +1762,9 @@ static int ovs_dp_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	if (IS_ERR(dp))
 		goto err_unlock_free;
 
-	ovs_dp_change(dp, info->attrs);
+	err = ovs_dp_change(dp, info->attrs);
+	if (err)
+		goto err_unlock_free;
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
 				   info->snd_seq, 0, OVS_DP_CMD_SET);
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 751d34a..81e85dd 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -218,6 +218,8 @@ static inline struct datapath *get_dp(struct net *net, int dp_ifindex)
 extern struct notifier_block ovs_dp_device_notifier;
 extern struct genl_family dp_vport_genl_family;
 
+DECLARE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
+
 void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key);
 void ovs_dp_detach_port(struct vport *);
 int ovs_dp_upcall(struct datapath *, struct sk_buff *,
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index bc89e16..b84929f 100644
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
@@ -848,7 +851,17 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 	if (res < 0)
 		return res;
 	key->mac_proto = res;
+
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	if (static_branch_unlikely(&tc_recirc_sharing_support)) {
+		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
+		key->recirc_id = tc_ext ? tc_ext->chain : 0;
+	} else {
+		key->recirc_id = 0;
+	}
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
index e0d8b45..82245cf 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1488,6 +1488,18 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
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

