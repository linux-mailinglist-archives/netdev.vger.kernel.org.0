Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA391DBC88
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgETSS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:18:29 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55552 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbgETSS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:18:29 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 98619600CC;
        Wed, 20 May 2020 18:18:28 +0000 (UTC)
Received: from us4-mdac16-10.ut7.mdlocal (unknown [10.7.65.180])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 96DC22009A;
        Wed, 20 May 2020 18:18:28 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.197])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 11DA21C0067;
        Wed, 20 May 2020 18:18:28 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8A3CAA4007A;
        Wed, 20 May 2020 18:18:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 20 May
 2020 19:18:20 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v4 net-next] net: flow_offload: simplify hw stats check
 handling
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jiri@resnulli.us>, <kuba@kernel.org>, <pablo@netfilter.org>
Message-ID: <0f0e052c-fa79-2ac7-8cec-98d4908845d0@solarflare.com>
Date:   Wed, 20 May 2020 19:18:10 +0100
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
X-TM-AS-Result: No-7.983600-8.000000-10
X-TMASE-MatchedRID: ZRt6D9EtTriwwAVMmrrBx6iUivh0j2PvBGvINcfHqhcLt1T6w2Ze0tPL
        nr6G+Iy7T/dBt9e2zw/ZqLKPYsZqBi7VJbT1Ye1WiVJZi91I9JjLRD51bz5RZFJqwYCQ1BisMH1
        xx17eFtR5Jh2towPBxAcx7gmMStFRM3oKwbTaeSjVNj9wuvGJUD+k5IvvZ1N/B2QWi8BF5ShpRe
        zoWC5XLVfPTTHpxXo/i0bASc0W+xfgrUsg8stDY9I0pcl7Mi9mUNr9nJzA3WSnMb4m7aAqt81qk
        z3j5LNs52GJaSw2Rj7dh/V3Nluv1RN+JiqkEYnptKR5FXfbysz54F/2i/DwjX5eO573Sn4u4nPT
        8jZv1NHi8zVgXoAltkWL4rBlm20vjaPj0W1qn0Q7AFczfjr/7MHGI8vkgHICrl5UFq5ISwlGTeA
        CYYkGV0+hGbVrXljeMtm3IEMUzIM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.983600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25430.003
X-MDID: 1589998708-0p206nZf5v7k
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
 drivers and __flow_action_hw_stats_check can use simple bitwise checks.

Pre-fill all actions with DONT_CARE in flow_rule_alloc(), rather than
 relying on implicit semantics of zero from kzalloc, so that callers which
 don't configure action stats themselves (i.e. netfilter) get the correct
 behaviour by default.

Only the kernel's internal API semantics change; the TC uAPI is unaffected.

v4: move DONT_CARE setting to flow_rule_alloc() for robustness and simplicity.

v3: set DONT_CARE in nft and ct offload.

v2: rebased on net-next, removed RFC tags.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
Again, I've tested that conntrack entry actions have hw_stats=7, but can't
 test other netfilter offloads.

 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |  8 ++++----
 include/net/flow_offload.h                            | 11 +++++++----
 net/core/flow_offload.c                               |  6 ++++++
 3 files changed, 17 insertions(+), 8 deletions(-)

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
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index e951b743bed3..e64941c526b1 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -8,6 +8,7 @@
 struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 {
 	struct flow_rule *rule;
+	int i;
 
 	rule = kzalloc(struct_size(rule, action.entries, num_actions),
 		       GFP_KERNEL);
@@ -15,6 +16,11 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 		return NULL;
 
 	rule->action.num_entries = num_actions;
+	/* Pre-fill each action hw_stats with DONT_CARE.
+	 * Caller can override this if it wants stats for a given action.
+	 */
+	for (i = 0; i < num_actions; i++)
+		rule->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
 
 	return rule;
 }
