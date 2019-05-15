Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534DC1FB32
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 21:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfEOTmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 15:42:54 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:57410 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbfEOTmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 15:42:53 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id A2C0D4C0079;
        Wed, 15 May 2019 19:42:51 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 15 May
 2019 12:42:41 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH v2 net-next 2/3] flow_offload: restore ability to collect
 separate stats per action
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
Message-ID: <b4a13b86-ae18-0801-249a-2831ec08c44c@solarflare.com>
Date:   Wed, 15 May 2019 20:42:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24614.005
X-TM-AS-Result: No-2.054800-4.000000-10
X-TMASE-MatchedRID: dmb9jcw1sqCioKUtUDGXZYS/TV9k6ppA1Mc6SC5sKVbiYlKox3ryNAjy
        Lz97jpWX5DTLhXRd0cRI/O+/7DzpyFjzwc5IsIuI8KGJCiV+3/LxuhkRWK22GB3RY4pGTCyH3pL
        BUyH/dxEZa3NuuEtGCAaDI9UiuMNGrSKKfw/QqNU/ApMPW/xhXti5W7Rf+s6QEEQaSVu4yLh9aW
        vTi9VKShd8xgeE5A7cduvJHyi1ZpGqYrHJkSmu4OadXXcOleEbnKpQna4coUCzEmEA0OlbneNb0
        aTvicGvxaTHHMSbYKWDesX4Fzmi7MCrnaeSxPj4WZTeB0tqopvyCvICuK46covFa5XXUMbGUK/H
        Nleb7IurIs90C6yU3ySP/fF5dorChfUatHkEWNSJUlmL3Uj0mKLwP+jjbL9K7L2+zGEubN7wGsg
        Lw0wig+LzNWBegCW2RYvisGWbbS+5G5ZK4Ai7+N0H8LFZNFG7g+0Ra8/sXsUv+c/Gc5Gu4NzvG2
        U83D2ukxJC4DlvsaJImrKvecMFl0lMXDxzSw6K7fF5FqZMR7c599ehXbzBcBB/9sZoI0NQ3Y5nF
        uoM+DMxwqle67/WNUAzBbitj/RY7aFmrxFux0RN2fIyiQnUdHIGGEJ3Szzznqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.054800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24614.005
X-MDID: 1557949372-6IG1VB1F12sr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the TC_CLSFLOWER_STATS callback from fl_hw_update_stats(), pass an
 array of struct flow_stats_entry, one for each action in the flow rule.
Current drivers (which do not collect per-action stats, but rather per-
 rule) call flow_stats_update() in a loop with the same values for all
 actions; this is roughly what they did before 3b1903ef97c0, except that
 there is not a helper function (like tcf_exts_stats_update()) that does
 it for them, because we don't want to encourage future drivers to do
 the same thing (and there isn't a need for a preempt_disable() like in
 tcf_exts_stats_update()).

Also do the same in mall_stats_hw_filter()'s TC_CLSMATCHALL_STATS
 callback, since it also uses tcf_exts_stats_update().

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c     |  6 ++++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 10 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  |  4 +++-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c    |  5 +++--
 .../net/ethernet/netronome/nfp/flower/offload.c  |  8 ++++++--
 .../net/ethernet/netronome/nfp/flower/qos_conf.c |  6 ++++--
 include/net/flow_offload.h                       | 11 +++++++++--
 include/net/pkt_cls.h                            | 13 +++++++++----
 net/core/flow_offload.c                          | 16 ++++++++++++++++
 net/sched/cls_flower.c                           |  9 ++++++---
 net/sched/cls_matchall.c                         |  7 +++++--
 11 files changed, 71 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 44d6c5743fb9..911178825daf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1370,6 +1370,7 @@ static int bnxt_tc_get_flow_stats(struct bnxt *bp,
 	struct bnxt_tc_flow_node *flow_node;
 	struct bnxt_tc_flow *flow;
 	unsigned long lastused;
+	int i;
 
 	flow_node = rhashtable_lookup_fast(&tc_info->flow_table,
 					   &tc_flow_cmd->cookie,
@@ -1388,8 +1389,9 @@ static int bnxt_tc_get_flow_stats(struct bnxt *bp,
 	lastused = flow->lastused;
 	spin_unlock(&flow->stats_lock);
 
-	flow_stats_update(&tc_flow_cmd->stats, stats.bytes, stats.packets,
-			  lastused);
+	for (i = 0; i < tc_flow_cmd->stats->num_entries; i++)
+		flow_stats_update(&tc_flow_cmd->stats->entries[i],
+				  stats.bytes, stats.packets, lastused);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 6e2d80008a79..cf19ca9f72c5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -788,8 +788,8 @@ int cxgb4_tc_flower_stats(struct net_device *dev,
 	struct ch_tc_flower_stats *ofld_stats;
 	struct ch_tc_flower_entry *ch_flower;
 	u64 packets;
+	int ret, i;
 	u64 bytes;
-	int ret;
 
 	ch_flower = ch_flower_lookup(adap, cls->cookie);
 	if (!ch_flower) {
@@ -808,9 +808,11 @@ int cxgb4_tc_flower_stats(struct net_device *dev,
 	if (ofld_stats->packet_count != packets) {
 		if (ofld_stats->prev_packet_count != packets)
 			ofld_stats->last_used = jiffies;
-		flow_stats_update(&cls->stats, bytes - ofld_stats->byte_count,
-				  packets - ofld_stats->packet_count,
-				  ofld_stats->last_used);
+		for (i = 0; i < cls->stats->num_entries; i++)
+			flow_stats_update(&cls->stats->entries[i],
+					  bytes - ofld_stats->byte_count,
+					  packets - ofld_stats->packet_count,
+					  ofld_stats->last_used);
 
 		ofld_stats->packet_count = packets;
 		ofld_stats->byte_count = bytes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 122f457091a2..fbad85d0d823 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3426,6 +3426,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	u64 lastuse = 0;
 	u64 packets = 0;
 	u64 bytes = 0;
+	int i;
 
 	flow = rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
 	if (!flow || !same_flow_direction(flow, flags))
@@ -3465,7 +3466,8 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 no_peer_counter:
 	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 out:
-	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	for (i = 0; i < f->stats->num_entries; i++)
+		flow_stats_update(&f->stats->entries[i], bytes, packets, lastuse);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 15f804453cd6..ea65b4d832b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -453,8 +453,8 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_acl_rule *rule;
 	u64 packets;
 	u64 lastuse;
+	int err, i;
 	u64 bytes;
-	int err;
 
 	ruleset = mlxsw_sp_acl_ruleset_get(mlxsw_sp, block,
 					   f->common.chain_index,
@@ -471,7 +471,8 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_rule_get_stats;
 
-	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	for (i = 0; i < f->stats->num_entries; i++)
+		flow_stats_update(&f->stats->entries[i], bytes, packets, lastuse);
 
 	mlxsw_sp_acl_ruleset_put(mlxsw_sp, ruleset);
 	return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 1fbfeb43c538..889839bc11a5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1132,6 +1132,7 @@ nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
 	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_fl_payload *nfp_flow;
 	u32 ctx_id;
+	int i;
 
 	nfp_flow = nfp_flower_search_fl_table(app, flow->cookie, netdev);
 	if (!nfp_flow)
@@ -1144,8 +1145,11 @@ nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
 	if (!list_empty(&nfp_flow->linked_flows))
 		nfp_flower_update_merge_stats(app, nfp_flow);
 
-	flow_stats_update(&flow->stats, priv->stats[ctx_id].bytes,
-			  priv->stats[ctx_id].pkts, priv->stats[ctx_id].used);
+	for (i = 0; i < flow->stats->num_entries; i++)
+		flow_stats_update(&flow->stats->entries[i],
+				  priv->stats[ctx_id].bytes,
+				  priv->stats[ctx_id].pkts,
+				  priv->stats[ctx_id].used);
 
 	priv->stats[ctx_id].pkts = 0;
 	priv->stats[ctx_id].bytes = 0;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 86e968cd5ffd..0ed202f315ee 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -297,6 +297,7 @@ nfp_flower_stats_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	struct nfp_stat_pair *prev_stats;
 	u64 diff_bytes, diff_pkts;
 	struct nfp_repr *repr;
+	int i;
 
 	if (!nfp_netdev_is_nfp_repr(netdev)) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on higher level port");
@@ -319,8 +320,9 @@ nfp_flower_stats_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	prev_stats->bytes = curr_stats->bytes;
 	spin_unlock_bh(&fl_priv->qos_stats_lock);
 
-	flow_stats_update(&flow->stats, diff_bytes, diff_pkts,
-			  repr_priv->qos_table.last_update);
+	for (i = 0; i < flow->stats->num_entries; i++)
+		flow_stats_update(&flow->stats->entries[i], diff_bytes,
+				  diff_pkts, repr_priv->qos_table.last_update);
 	return 0;
 }
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 4ee0f68f2e8d..9e2c64eb6726 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -210,13 +210,20 @@ static inline bool flow_rule_match_key(const struct flow_rule *rule,
 	return dissector_uses_key(rule->match.dissector, key);
 }
 
-struct flow_stats {
+struct flow_stats_entry {
 	u64	pkts;
 	u64	bytes;
 	u64	lastused;
 };
 
-static inline void flow_stats_update(struct flow_stats *flow_stats,
+struct flow_stats {
+	unsigned int			num_entries;
+	struct flow_stats_entry		entries[0];
+};
+
+struct flow_stats *flow_stats_alloc(unsigned int num_actions);
+
+static inline void flow_stats_update(struct flow_stats_entry *flow_stats,
 				     u64 bytes, u64 pkts, u64 lastused)
 {
 	flow_stats->pkts	+= pkts;
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 514e3c80ecc1..0e17ea8ba302 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -344,7 +344,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
-		      u64 bytes, u64 packets, u64 lastuse)
+		      const struct flow_stats *stats)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
@@ -352,9 +352,14 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
 	preempt_disable();
 
 	for (i = 0; i < exts->nr_actions; i++) {
+		const struct flow_stats_entry *stats_entry;
 		struct tc_action *a = exts->actions[i];
 
-		tcf_action_stats_update(a, bytes, packets, lastuse, true);
+		if (i > stats->num_entries)
+			break;
+		stats_entry = &stats->entries[i];
+		tcf_action_stats_update(a, stats_entry->bytes, stats_entry->pkts,
+					stats_entry->lastused, true);
 	}
 
 	preempt_enable();
@@ -752,7 +757,7 @@ struct tc_cls_flower_offload {
 	enum tc_fl_command command;
 	unsigned long cookie;
 	struct flow_rule *rule;
-	struct flow_stats stats;
+	struct flow_stats *stats;
 	u32 classid;
 };
 
@@ -772,7 +777,7 @@ struct tc_cls_matchall_offload {
 	struct tc_cls_common_offload common;
 	enum tc_matchall_command command;
 	struct flow_rule *rule;
-	struct flow_stats stats;
+	struct flow_stats *stats;
 	unsigned long cookie;
 };
 
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index c3a00eac4804..4c8aabebdb75 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -151,3 +151,19 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_OPTS, out);
 }
 EXPORT_SYMBOL(flow_rule_match_enc_opts);
+
+struct flow_stats *flow_stats_alloc(unsigned int num_actions)
+{
+	struct flow_stats *stats;
+
+	stats = kzalloc(sizeof(struct flow_stats) +
+		       sizeof(struct flow_stats_entry) * num_actions,
+		       GFP_KERNEL);
+	if (!stats)
+		return NULL;
+
+	stats->num_entries = num_actions;
+
+	return stats;
+}
+EXPORT_SYMBOL(flow_stats_alloc);
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f6685fc53119..8775657fb03b 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -482,13 +482,16 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	cls_flower.command = TC_CLSFLOWER_STATS;
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.classid = f->res.classid;
+	cls_flower.stats = flow_stats_alloc(tcf_exts_num_actions(&f->exts));
+	if (!cls_flower.stats)
+		goto out_unlock;
 
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
 
-	tcf_exts_stats_update(&f->exts, cls_flower.stats.bytes,
-			      cls_flower.stats.pkts,
-			      cls_flower.stats.lastused);
+	tcf_exts_stats_update(&f->exts, cls_flower.stats);
+	kfree(cls_flower.stats);
 
+out_unlock:
 	if (!rtnl_held)
 		rtnl_unlock();
 }
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index db42d97a2006..b6b7b041fd6a 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -335,11 +335,14 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, NULL);
 	cls_mall.command = TC_CLSMATCHALL_STATS;
 	cls_mall.cookie = cookie;
+	cls_mall.stats = flow_stats_alloc(tcf_exts_num_actions(&head->exts));
+	if (!cls_mall.stats)
+		return;
 
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false);
 
-	tcf_exts_stats_update(&head->exts, cls_mall.stats.bytes,
-			      cls_mall.stats.pkts, cls_mall.stats.lastused);
+	tcf_exts_stats_update(&head->exts, cls_mall.stats);
+	kfree(cls_mall.stats);
 }
 
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,

