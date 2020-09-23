Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D94B274FAE
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 05:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgIWD4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 23:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIWD4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 23:56:40 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB975C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 20:56:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id md22so2100369pjb.0
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 20:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lK8hiGkA628vDF6HO8/yC7Fh9/cbUJFhn2Sz9sxPzfE=;
        b=iozI9uy2N6tEwmxVjBeW4+lfrCZdXxCRbjxfXO5iu5O+UAcd4O34xFpTY0MDvrcQuM
         jLz7vZtnyXMTZG6tlEUCFsJYYI+5hyBIdkU++pvANBwWaSUw3tR5BjhkaJliNvrjBMUm
         Z1CZm8neE1hEIuI+lRR1CsvHs4deUbMcOqnj459/yCN2aee8xIHcH0/gghr17Y5ZHw22
         wuFRYudWVDP2bhHLui9jUnXtYbiUI3WSoTKCaweJoS42w6s1IRG346cTGRbNR9ScPN0y
         //m0uzLh5nSOczM6vf61/AQFXLD7/6EdWZPzvo4jZCTfPaAgWh9oea06wlRjhLL6XFNX
         9qnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lK8hiGkA628vDF6HO8/yC7Fh9/cbUJFhn2Sz9sxPzfE=;
        b=WU0uabqjUCdv5IpMV6JUL33ntIN0brqH+vSlM5Ve1I4bVe3xgOn/PA1FWOE8jDuVUj
         tjIgVVd8s74ajKeTx2YPJWV/IXb4uT/WxSUPaVfqOKFphk7FSmtSHT5+LuYJiWgxwGMr
         QzTCdXBcf83WSgdXFY6lvJzvbAObGmI7M3LLHx3E5sMjYZOZ+g2Uxu+ozgkkZWvVqkf3
         2aDDG3ZwPaGkvbjvzhaut1jQg4T8KJ/pUgSHLeJn+8t6n9576RnbRr9hTaBnS5tG82c1
         bokjazwUZgaJdjZ1DIpiqzqKNH2/ED1V7DXQ1gXLKYnkash5FKZ6leXG8TVe2+Ig+9ls
         udPg==
X-Gm-Message-State: AOAM530poTN08v3C6dCr4WlTnW+99BCwSFvlkLkFCzxgc9i43zmuceMV
        Qzxn1EOpbI9aJjJlWfQ2/inJcRCAfFzlbg==
X-Google-Smtp-Source: ABdhPJzq/MqcDxV5yJJrJuA80L1QbiRjtxg738C/yDQ5x/+dMn5YhiobT8gZhV/iKjEs2Sx0Y3hj1w==
X-Received: by 2002:a17:902:bc81:b029:d2:2988:4781 with SMTP id bb1-20020a170902bc81b02900d229884781mr7536386plb.50.1600833399150;
        Tue, 22 Sep 2020 20:56:39 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id v6sm16729045pfi.38.2020.09.22.20.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 20:56:38 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net 1/2] net_sched: defer tcf_idr_insert() in tcf_action_init_1()
Date:   Tue, 22 Sep 2020 20:56:23 -0700
Message-Id: <20200923035624.7307-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
References: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All TC actions call tcf_idr_insert() for new action at the end
of their ->init(), so we can actually move it to a central place
in tcf_action_init_1().

And once the action is inserted into the global IDR, other parallel
process could free it immediately as its refcnt is still 1, so we can
not fail after this, we need to move it after the goto action
validation to avoid handling the failure case after insertion.

This is found during code review, is not directly triggered by syzbot.
And this prepares for the next patch.

Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/net/act_api.h      |  2 --
 net/sched/act_api.c        | 38 ++++++++++++++++++++------------------
 net/sched/act_bpf.c        |  4 +---
 net/sched/act_connmark.c   |  1 -
 net/sched/act_csum.c       |  3 ---
 net/sched/act_ct.c         |  2 --
 net/sched/act_ctinfo.c     |  3 ---
 net/sched/act_gact.c       |  2 --
 net/sched/act_gate.c       |  3 ---
 net/sched/act_ife.c        |  3 ---
 net/sched/act_ipt.c        |  2 --
 net/sched/act_mirred.c     |  2 --
 net/sched/act_mpls.c       |  2 --
 net/sched/act_nat.c        |  3 ---
 net/sched/act_pedit.c      |  2 --
 net/sched/act_police.c     |  2 --
 net/sched/act_sample.c     |  2 --
 net/sched/act_simple.c     |  2 --
 net/sched/act_skbedit.c    |  2 --
 net/sched/act_skbmod.c     |  2 --
 net/sched/act_tunnel_key.c |  3 ---
 net/sched/act_vlan.c       |  2 --
 22 files changed, 21 insertions(+), 66 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index cb382a89ea58..87214927314a 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -166,8 +166,6 @@ int tcf_idr_create_from_flags(struct tc_action_net *tn, u32 index,
 			      struct nlattr *est, struct tc_action **a,
 			      const struct tc_action_ops *ops, int bind,
 			      u32 flags);
-void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a);
-
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
 int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 			struct tc_action **a, int bind);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 063d8aaf2900..0030f00234ee 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -467,17 +467,6 @@ int tcf_idr_create_from_flags(struct tc_action_net *tn, u32 index,
 }
 EXPORT_SYMBOL(tcf_idr_create_from_flags);
 
-void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a)
-{
-	struct tcf_idrinfo *idrinfo = tn->idrinfo;
-
-	mutex_lock(&idrinfo->lock);
-	/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
-	WARN_ON(!IS_ERR(idr_replace(&idrinfo->action_idr, a, a->tcfa_index)));
-	mutex_unlock(&idrinfo->lock);
-}
-EXPORT_SYMBOL(tcf_idr_insert);
-
 /* Cleanup idr index that was allocated but not initialized. */
 
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index)
@@ -902,6 +891,16 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
+static void tcf_idr_insert(struct tc_action *a)
+{
+	struct tcf_idrinfo *idrinfo = a->idrinfo;
+
+	mutex_lock(&idrinfo->lock);
+	/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
+	WARN_ON(!IS_ERR(idr_replace(&idrinfo->action_idr, a, a->tcfa_index)));
+	mutex_unlock(&idrinfo->lock);
+}
+
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
@@ -989,6 +988,16 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (err < 0)
 		goto err_mod;
 
+	if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
+	    !rcu_access_pointer(a->goto_chain)) {
+		tcf_action_destroy_1(a, bind);
+		NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (err == ACT_P_CREATED)
+		tcf_idr_insert(a);
+
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 
@@ -1002,13 +1011,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (err != ACT_P_CREATED)
 		module_put(a_o->owner);
 
-	if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
-	    !rcu_access_pointer(a->goto_chain)) {
-		tcf_action_destroy_1(a, bind);
-		NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
-		return ERR_PTR(-EINVAL);
-	}
-
 	return a;
 
 err_mod:
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 54d5652cfe6c..a4c7ba35a343 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -365,9 +365,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (res == ACT_P_CREATED) {
-		tcf_idr_insert(tn, *act);
-	} else {
+	if (res != ACT_P_CREATED) {
 		/* make sure the program being replaced is no longer executing */
 		synchronize_rcu();
 		tcf_bpf_cfg_cleanup(&old);
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index f901421b0634..e19885d7fe2c 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -139,7 +139,6 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 		ci->net = net;
 		ci->zone = parm->zone;
 
-		tcf_idr_insert(tn, *a);
 		ret = ACT_P_CREATED;
 	} else if (ret > 0) {
 		ci = to_connmark(*a);
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index f5826e457679..4fa4fcb842ba 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -110,9 +110,6 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 	if (params_new)
 		kfree_rcu(params_new, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 put_chain:
 	if (goto_ch)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 2c3619165680..a780afdf570d 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1297,8 +1297,6 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 		tcf_chain_put_by_act(goto_ch);
 	if (params)
 		call_rcu(&params->rcu, tcf_ct_params_free);
-	if (res == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 
 	return res;
 
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index b5042f3ea079..6084300e51ad 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -269,9 +269,6 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	if (cp_new)
 		kfree_rcu(cp_new, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 
 put_chain:
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 410e3bbfb9ca..73c3926358a0 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -140,8 +140,6 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 release_idr:
 	tcf_idr_release(*a, bind);
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 1fb8d428d2c1..7c0771dd77a3 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -437,9 +437,6 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 
 chain_put:
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 5c568757643b..a2ddea04183a 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -627,9 +627,6 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	if (p)
 		kfree_rcu(p, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 metadata_parse_err:
 	if (goto_ch)
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 400a2cfe8452..8dc3bec0d325 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -189,8 +189,6 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 	ipt->tcfi_t     = t;
 	ipt->tcfi_hook  = hook;
 	spin_unlock_bh(&ipt->tcf_lock);
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 
 err3:
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index b2705318993b..e24b7e2331cd 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -194,8 +194,6 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 		spin_lock(&mirred_list_lock);
 		list_add(&m->tcfm_list, &mirred_list);
 		spin_unlock(&mirred_list_lock);
-
-		tcf_idr_insert(tn, *a);
 	}
 
 	return ret;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 8118e2640979..e298ec3b3c9e 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -273,8 +273,6 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 	if (p)
 		kfree_rcu(p, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 855a6fa16a62..1ebd2a86d980 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -93,9 +93,6 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 release_idr:
 	tcf_idr_release(*a, bind);
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c158bfed86d5..b45304446e13 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -238,8 +238,6 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	spin_unlock_bh(&p->tcf_lock);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 
 put_chain:
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 0b431d493768..8d8452b1cdd4 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -201,8 +201,6 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	if (new)
 		kfree_rcu(new, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 
 failure:
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 5e2df590bb58..3ebf9ede3cf1 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -116,8 +116,6 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 9813ca4006dd..a4f3d0f0daa9 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -157,8 +157,6 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 			goto release_idr;
 	}
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index d0652386c6e2..e5f3fb8b00e3 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -225,8 +225,6 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 39e6d94cfafb..81a1c67335be 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -190,8 +190,6 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 37f1e10f35e0..a229751ee8c4 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -537,9 +537,6 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 
 put_chain:
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index a5ff9f68ab02..163b0385fd4c 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -229,8 +229,6 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	if (p)
 		kfree_rcu(p, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
-- 
2.28.0

