Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6991C6FB4
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgEFLzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:55:47 -0400
Received: from correo.us.es ([193.147.175.20]:55596 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgEFLzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 07:55:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9EE354FFE13
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 13:55:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FEA24F0CB
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 13:55:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7B3BD1158E7; Wed,  6 May 2020 13:55:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44C5820C5C;
        Wed,  6 May 2020 13:55:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 May 2020 13:55:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0763F42EE38E;
        Wed,  6 May 2020 13:55:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ecree@solarflare.com,
        kuba@kernel.org, jiri@resnulli.us
Subject: [PATCH net,v3] net: flow_offload: skip hw stats check for FLOW_ACTION_HW_STATS_DONT_CARE
Date:   Wed,  6 May 2020 13:55:39 +0200
Message-Id: <20200506115539.21018-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
that the frontend does not need counters, this hw stats type request
never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
the driver to disable the stats, however, if the driver cannot disable
counters, it bails out.

TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
(this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.

Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: update mlxsw to handle _DONT_CARE.

 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  2 +-
 include/net/flow_offload.h                         |  9 ++++++++-
 net/sched/cls_api.c                                | 14 ++++++++++++--
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 51117a5a6bbf..81d0b3481479 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -36,7 +36,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
 		if (err)
 			return err;
-	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED) {
+	} else if (act->hw_stats == FLOW_ACTION_HW_STATS_DELAYED) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3619c6acf60f..efc8350b42fb 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -166,15 +166,18 @@ enum flow_action_mangle_base {
 enum flow_action_hw_stats_bit {
 	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
 	FLOW_ACTION_HW_STATS_DELAYED_BIT,
+	FLOW_ACTION_HW_STATS_DISABLED_BIT,
 };
 
 enum flow_action_hw_stats {
-	FLOW_ACTION_HW_STATS_DISABLED = 0,
+	FLOW_ACTION_HW_STATS_DONT_CARE = 0,
 	FLOW_ACTION_HW_STATS_IMMEDIATE =
 		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
 	FLOW_ACTION_HW_STATS_DELAYED = BIT(FLOW_ACTION_HW_STATS_DELAYED_BIT),
 	FLOW_ACTION_HW_STATS_ANY = FLOW_ACTION_HW_STATS_IMMEDIATE |
 				   FLOW_ACTION_HW_STATS_DELAYED,
+	FLOW_ACTION_HW_STATS_DISABLED =
+		BIT(FLOW_ACTION_HW_STATS_DISABLED_BIT),
 };
 
 typedef void (*action_destr)(void *priv);
@@ -325,7 +328,11 @@ __flow_action_hw_stats_check(const struct flow_action *action,
 		return true;
 	if (!flow_action_mixed_hw_stats_check(action, extack))
 		return false;
+
 	action_entry = flow_action_first_entry_get(action);
+	if (action_entry->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
+		return true;
+
 	if (!check_allow_bit &&
 	    action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 55bd1429678f..56cf1b9e1e24 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3523,6 +3523,16 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
 #endif
 }
 
+static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
+{
+	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
+		return FLOW_ACTION_HW_STATS_DONT_CARE;
+	else if (!hw_stats)
+		return FLOW_ACTION_HW_STATS_DISABLED;
+
+	return hw_stats;
+}
+
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts)
 {
@@ -3546,7 +3556,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		if (err)
 			goto err_out_locked;
 
-		entry->hw_stats = act->hw_stats;
+		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
 
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
@@ -3614,7 +3624,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mangle.mask = tcf_pedit_mask(act, k);
 				entry->mangle.val = tcf_pedit_val(act, k);
 				entry->mangle.offset = tcf_pedit_offset(act, k);
-				entry->hw_stats = act->hw_stats;
+				entry->hw_stats = tc_act_hw_stats(act->hw_stats);
 				entry = &flow_action->entries[++j];
 			}
 		} else if (is_tcf_csum(act)) {
-- 
2.20.1

