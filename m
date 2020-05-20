Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A341DBB53
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgETRXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:23:51 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:53672 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727981AbgETRWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:22:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A480D200DF;
        Wed, 20 May 2020 17:22:03 +0000 (UTC)
Received: from us4-mdac16-69.at1.mdlocal (unknown [10.110.50.186])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A2E118009B;
        Wed, 20 May 2020 17:22:03 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3404D40072;
        Wed, 20 May 2020 17:22:03 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CB948280063;
        Wed, 20 May 2020 17:22:02 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 20 May
 2020 18:21:56 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next] net: flow_offload: simplify hw stats check
 handling
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jiri@resnulli.us>, <kuba@kernel.org>, <pablo@netfilter.org>
Message-ID: <2cf9024d-1568-4594-5763-6c4e4e8fe47b@solarflare.com>
Date:   Wed, 20 May 2020 18:21:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25430.003
X-TM-AS-Result: No-5.781900-8.000000-10
X-TMASE-MatchedRID: huLetEq/dPSwwAVMmrrBx6iUivh0j2PvBGvINcfHqhcxORZj0djJkQOr
        nVAKyYzuC75+d7CNAsqekg5BszIusyxMd3BG3hng/ccgt/EtX/1dA4rYaKGKwlJqwYCQ1BisMH1
        xx17eFtQMgdTDHmTMF7r7cyh+G7QMHVikQ9YmLLPwqDryy7bDIUj2TRK4Wlr10yA6AM98FEFLxd
        BSajtA2Hxs7qFZ9FbOAUZWrMnznJp7dpr6RvFomfUwiX15l0tvTySC+TZdy0WRDQkhZa5u72kny
        jyxlh7mqneduEAVa+rqHEp2n5BcUGKztShDQzFutKR5FXfbyszqobkz1A0A7SgCoCrh9Y4lk66/
        gtVjZsVnHQJ2jUDp75GTpe1iiCJq71zr0FZRMbALbigRnpKlKSPzRlrdFGDwknQQQGIVv41ASa6
        U3AEcWXpTFh9eJy4/zF9z8yz1+epqbamnjuWv4A==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.781900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25430.003
X-MDID: 1589995323-i9Z4x4UWyZan
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
 drivers and __flow_action_hw_stats_check can use simple bitwise checks.
Also ensure that netfilter explicitly sets its actions to DONT_CARE, rather
 than relying on implicit semantics of zero.

Only the kernel's internal API semantics change; the TC uAPI is unaffected.

v3: set DONT_CARE in nft and ct offload.  Tested the latter with an
 experimental driver; conntrack entry actions had hw_stats=7, as expected.

v2: rebased on net-next, removed RFC tags.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
I don't have hardware that does TC_SETUP_FT offload.  Could someone from
 mlx test that nft offload comes through with hw_stats=DONT_CARE?

 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  8 ++++----
 include/net/flow_offload.h                         | 11 +++++++----
 net/netfilter/nf_flow_table_offload.c              | 14 +++++++++++---
 net/sched/act_ct.c                                 |  5 +++++
 4 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index b286fe158820..51e1b3930c56 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -30,14 +30,14 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		return -EOPNOTSUPP;
 
 	act = flow_action_first_entry_get(flow_action);
-	if (act->hw_stats == FLOW_ACTION_HW_STATS_ANY ||
-	    act->hw_stats == FLOW_ACTION_HW_STATS_IMMEDIATE) {
+	if (act->hw_stats & FLOW_ACTION_HW_STATS_DISABLED) {
+		/* Nothing to do */
+	} else if (act->hw_stats & FLOW_ACTION_HW_STATS_IMMEDIATE) {
 		/* Count action is inserted first */
 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
 		if (err)
 			return err;
-	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED &&
-		   act->hw_stats != FLOW_ACTION_HW_STATS_DONT_CARE) {
+	} else {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 4001ffb04f0d..95d633785ef9 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -168,10 +168,11 @@ enum flow_action_hw_stats_bit {
 	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
 	FLOW_ACTION_HW_STATS_DELAYED_BIT,
 	FLOW_ACTION_HW_STATS_DISABLED_BIT,
+
+	FLOW_ACTION_HW_STATS_NUM_BITS
 };
 
 enum flow_action_hw_stats {
-	FLOW_ACTION_HW_STATS_DONT_CARE = 0,
 	FLOW_ACTION_HW_STATS_IMMEDIATE =
 		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
 	FLOW_ACTION_HW_STATS_DELAYED = BIT(FLOW_ACTION_HW_STATS_DELAYED_BIT),
@@ -179,6 +180,7 @@ enum flow_action_hw_stats {
 				   FLOW_ACTION_HW_STATS_DELAYED,
 	FLOW_ACTION_HW_STATS_DISABLED =
 		BIT(FLOW_ACTION_HW_STATS_DISABLED_BIT),
+	FLOW_ACTION_HW_STATS_DONT_CARE = BIT(FLOW_ACTION_HW_STATS_NUM_BITS) - 1,
 };
 
 typedef void (*action_destr)(void *priv);
@@ -340,11 +342,12 @@ __flow_action_hw_stats_check(const struct flow_action *action,
 		return false;
 
 	action_entry = flow_action_first_entry_get(action);
-	if (action_entry->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
-		return true;
+
+	/* Zero is not a legal value for hw_stats, catch anyone passing it */
+	WARN_ON_ONCE(!action_entry->hw_stats);
 
 	if (!check_allow_bit &&
-	    action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
+	    ~action_entry->hw_stats & FLOW_ACTION_HW_STATS_ANY) {
 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
 		return false;
 	} else if (check_allow_bit &&
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 2ff4087007a6..60f94a2d15cc 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -165,9 +165,17 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
 static inline struct flow_action_entry *
 flow_action_entry_next(struct nf_flow_rule *flow_rule)
 {
-	int i = flow_rule->rule->action.num_entries++;
+	struct flow_action *acts = &flow_rule->rule->action;
+	struct flow_action_entry *act;
+	int i = acts->num_entries++;
 
-	return &flow_rule->rule->action.entries[i];
+	act = acts->entries + i;
+	/* Pre-fill action hw_stats with DONT_CARE.  Caller can override this
+	 * if it wants stats for its action
+	 */
+	act->hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
+
+	return act;
 }
 
 static int flow_offload_eth_src(struct net *net,
@@ -582,7 +590,7 @@ nf_flow_offload_rule_alloc(struct net *net,
 	const struct flow_offload_tuple *tuple;
 	struct nf_flow_rule *flow_rule;
 	struct dst_entry *other_dst;
-	int err = -ENOMEM;
+	int err = -ENOMEM, i;
 
 	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
 	if (!flow_rule)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9adff83b523b..b3b68dacadd0 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -61,6 +61,11 @@ tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
 {
 	int i = flow_action->num_entries++;
 
+	/* Pre-fill action hw_stats with DONT_CARE.  Caller can override this
+	 * if it wants stats for its action
+	 */
+	flow_action->entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
+
 	return &flow_action->entries[i];
 }
 
