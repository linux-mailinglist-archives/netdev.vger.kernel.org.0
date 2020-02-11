Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3261E158BB2
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 10:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgBKJTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 04:19:39 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35599 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727582AbgBKJTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 04:19:39 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Feb 2020 11:19:37 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01B9Jbgu031153;
        Tue, 11 Feb 2020 11:19:37 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 1/4] net: sched: lock action when translating it to flow_action infra
Date:   Tue, 11 Feb 2020 11:19:15 +0200
Message-Id: <20200211091918.20974-2-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200211091918.20974-1-vladbu@mellanox.com>
References: <20200211091918.20974-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to remove dependency on rtnl lock, take action's tcfa_lock when
constructing its representation as flow_action_entry structure.

Refactor tcf_sample_get_group() to assume that caller holds tcf_lock and
don't take it manually. This callback is only called from flow_action infra
representation translator which now calls it with tcf_lock held, so this
refactoring is necessary to prevent deadlock.

Allocate memory with GFP_ATOMIC flag for ip_tunnel_info copy because
tcf_tunnel_info_copy() is only called from flow_action representation infra
code with tcf_lock spinlock taken.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/tc_act/tc_tunnel_key.h |  2 +-
 net/sched/act_sample.c             |  2 --
 net/sched/cls_api.c                | 17 +++++++++++------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/net/tc_act/tc_tunnel_key.h b/include/net/tc_act/tc_tunnel_key.h
index 0689d9bcdf84..2b3df076e5b6 100644
--- a/include/net/tc_act/tc_tunnel_key.h
+++ b/include/net/tc_act/tc_tunnel_key.h
@@ -69,7 +69,7 @@ tcf_tunnel_info_copy(const struct tc_action *a)
 	if (tun) {
 		size_t tun_size = sizeof(*tun) + tun->options_len;
 		struct ip_tunnel_info *tun_copy = kmemdup(tun, tun_size,
-							  GFP_KERNEL);
+							  GFP_ATOMIC);
 
 		return tun_copy;
 	}
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index ce948c1e24dc..5e2df590bb58 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -267,14 +267,12 @@ tcf_sample_get_group(const struct tc_action *a,
 	struct tcf_sample *s = to_sample(a);
 	struct psample_group *group;
 
-	spin_lock_bh(&s->tcf_lock);
 	group = rcu_dereference_protected(s->psample_group,
 					  lockdep_is_held(&s->tcf_lock));
 	if (group) {
 		psample_group_take(group);
 		*destructor = tcf_psample_group_put;
 	}
-	spin_unlock_bh(&s->tcf_lock);
 
 	return group;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c2cdd0fc2e70..610505117780 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3435,7 +3435,7 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts, bool rtnl_held)
 {
-	const struct tc_action *act;
+	struct tc_action *act;
 	int i, j, k, err = 0;
 
 	if (!exts)
@@ -3449,6 +3449,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
+		spin_lock_bh(&act->tcfa_lock);
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
 		} else if (is_tcf_gact_shot(act)) {
@@ -3489,13 +3490,13 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				break;
 			default:
 				err = -EOPNOTSUPP;
-				goto err_out;
+				goto err_out_locked;
 			}
 		} else if (is_tcf_tunnel_set(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
 			err = tcf_tunnel_encap_get_tunnel(entry, act);
 			if (err)
-				goto err_out;
+				goto err_out_locked;
 		} else if (is_tcf_tunnel_release(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_DECAP;
 		} else if (is_tcf_pedit(act)) {
@@ -3509,7 +3510,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 					break;
 				default:
 					err = -EOPNOTSUPP;
-					goto err_out;
+					goto err_out_locked;
 				}
 				entry->mangle.htype = tcf_pedit_htype(act, k);
 				entry->mangle.mask = tcf_pedit_mask(act, k);
@@ -3560,15 +3561,16 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
 				break;
 			default:
-				goto err_out;
+				goto err_out_locked;
 			}
 		} else if (is_tcf_skbedit_ptype(act)) {
 			entry->id = FLOW_ACTION_PTYPE;
 			entry->ptype = tcf_skbedit_ptype(act);
 		} else {
 			err = -EOPNOTSUPP;
-			goto err_out;
+			goto err_out_locked;
 		}
+		spin_unlock_bh(&act->tcfa_lock);
 
 		if (!is_tcf_pedit(act))
 			j++;
@@ -3582,6 +3584,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		tc_cleanup_flow_action(flow_action);
 
 	return err;
+err_out_locked:
+	spin_unlock_bh(&act->tcfa_lock);
+	goto err_out;
 }
 EXPORT_SYMBOL(tc_setup_flow_action);
 
-- 
2.21.0

