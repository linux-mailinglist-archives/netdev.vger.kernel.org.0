Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B926F682FBF
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjAaOwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbjAaOwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:52:10 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF348615
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:52:08 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id e12-20020a0568301e4c00b0068bc93e7e34so2443075otj.4
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17Y7VIgfpgjvYJ6scm5QTk59s1FgooIcj/9lSemWNHs=;
        b=vwGnIKXOApt2FjcCjD66BO6O5MEPTTslyjvClyxgZFsk1mMTr1lUpft0TRMCLlZBOk
         kGSARvMmO2PFSS2iV132vXnOc1+m1FnijFRIQl4WoySeGiJ9sBCX6irc5uZN6r833hg2
         RzPBmlHWxln0Z+4tqrC87v48nE9nowbkClQJRHOCHEHZb/6REhMuWXazapThn5sNyXs0
         +64DoBLS6qAhomzDwKZDHKJy+KAtkDQ3s9sL6k/AOnQDLDsteE+HNdQdFrSI3gL+wixx
         LpNaXJMGebKXMVS5A/hr5N9LFVfa447rNX9gBQJKeCxjijiCOeaRNd44MA92tCfBm1l9
         B/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17Y7VIgfpgjvYJ6scm5QTk59s1FgooIcj/9lSemWNHs=;
        b=vZQm6YjPe+ddxcHvQUlKKL1ZA5vYLS/B05e10e3fjFSzMZBT61BoHnQuNcTQu0m1SE
         Tpj6wMjtvhYSLTBXZs6fU5Z8b6ERVKkX400l20Jf3AndKDlFBM9n1Yt5ihLZ4oZy5Knh
         Gc6Y5tLJCCQagnrTIZUnzYYAjkYbYPOOHsoZBpDCvaC/RTgPZ1AfoZqsyMmiDxQWANPt
         Fj3f+ogwngfyAI6jKOhx70cV5+Tm/W2F6webrMje/3Fsnxgem9xWy7l7RzFbV7WxGqtZ
         QOXA+diVgb2zNgHLaOUKniDaG4HsqjawGunW4zsBtV/s2CAiU/+zBgD8STT0m3X+2nET
         sqag==
X-Gm-Message-State: AO0yUKXP25RKxiq6LZzEQ4TroWgt7xoeHH3LA9YtQCPufQqvRhuB3Ad1
        lN66m1lrzuRSgHUkBdyFVkId/1U2TPqYb4Vr
X-Google-Smtp-Source: AK7set91hrPdFMaO/l1aogE+mGL/mvgtWHLrLRQQTE0Y+DnA/KwZXu2XbzWNq2YlVkh+niYfAJ6HUg==
X-Received: by 2002:a05:6830:3155:b0:68b:ca75:d6a7 with SMTP id c21-20020a056830315500b0068bca75d6a7mr6571590ots.11.1675176727924;
        Tue, 31 Jan 2023 06:52:07 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:1d86:b62f:e05b:126b])
        by smtp.gmail.com with ESMTPSA id e4-20020a0568301e4400b00670461b8be4sm6639371otj.33.2023.01.31.06.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:52:07 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 1/2] net/sched: transition act_pedit to rcu and percpu stats
Date:   Tue, 31 Jan 2023 11:51:48 -0300
Message-Id: <20230131145149.3776656-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131145149.3776656-1-pctammela@mojatatu.com>
References: <20230131145149.3776656-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The software pedit action didn't get the same love as some of the
other actions and it's still using spinlocks and shared stats in the
datapath.
Transition the action to rcu and percpu stats as this improves the
action's performance dramatically on multiple cpu deployments.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/net/tc_act/tc_pedit.h |  81 +++++++++++++++----
 net/sched/act_pedit.c         | 144 ++++++++++++++++++++--------------
 2 files changed, 150 insertions(+), 75 deletions(-)

diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
index 3e02709a1df6..83fe39931781 100644
--- a/include/net/tc_act/tc_pedit.h
+++ b/include/net/tc_act/tc_pedit.h
@@ -4,22 +4,29 @@
 
 #include <net/act_api.h>
 #include <linux/tc_act/tc_pedit.h>
+#include <linux/types.h>
 
 struct tcf_pedit_key_ex {
 	enum pedit_header_type htype;
 	enum pedit_cmd cmd;
 };
 
-struct tcf_pedit {
-	struct tc_action	common;
-	unsigned char		tcfp_nkeys;
-	unsigned char		tcfp_flags;
-	u32			tcfp_off_max_hint;
+struct tcf_pedit_parms {
 	struct tc_pedit_key	*tcfp_keys;
 	struct tcf_pedit_key_ex	*tcfp_keys_ex;
+	u32 tcfp_off_max_hint;
+	unsigned char tcfp_nkeys;
+	unsigned char tcfp_flags;
+	struct rcu_head rcu;
+};
+
+struct tcf_pedit {
+	struct tc_action common;
+	struct tcf_pedit_parms __rcu *parms;
 };
 
 #define to_pedit(a) ((struct tcf_pedit *)a)
+#define to_pedit_parms(a) (rcu_dereference(to_pedit(a)->parms))
 
 static inline bool is_tcf_pedit(const struct tc_action *a)
 {
@@ -32,37 +39,81 @@ static inline bool is_tcf_pedit(const struct tc_action *a)
 
 static inline int tcf_pedit_nkeys(const struct tc_action *a)
 {
-	return to_pedit(a)->tcfp_nkeys;
+	struct tcf_pedit_parms *parms;
+	int nkeys;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	nkeys = parms->tcfp_nkeys;
+	rcu_read_unlock();
+
+	return nkeys;
 }
 
 static inline u32 tcf_pedit_htype(const struct tc_action *a, int index)
 {
-	if (to_pedit(a)->tcfp_keys_ex)
-		return to_pedit(a)->tcfp_keys_ex[index].htype;
+	u32 htype = TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
+	struct tcf_pedit_parms *parms;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	if (parms->tcfp_keys_ex)
+		htype = parms->tcfp_keys_ex[index].htype;
+	rcu_read_unlock();
 
-	return TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
+	return htype;
 }
 
 static inline u32 tcf_pedit_cmd(const struct tc_action *a, int index)
 {
-	if (to_pedit(a)->tcfp_keys_ex)
-		return to_pedit(a)->tcfp_keys_ex[index].cmd;
+	struct tcf_pedit_parms *parms;
+	u32 cmd = __PEDIT_CMD_MAX;
 
-	return __PEDIT_CMD_MAX;
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	if (parms->tcfp_keys_ex)
+		cmd = parms->tcfp_keys_ex[index].cmd;
+	rcu_read_unlock();
+
+	return cmd;
 }
 
 static inline u32 tcf_pedit_mask(const struct tc_action *a, int index)
 {
-	return to_pedit(a)->tcfp_keys[index].mask;
+	struct tcf_pedit_parms *parms;
+	u32 mask;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	mask = parms->tcfp_keys[index].mask;
+	rcu_read_unlock();
+
+	return mask;
 }
 
 static inline u32 tcf_pedit_val(const struct tc_action *a, int index)
 {
-	return to_pedit(a)->tcfp_keys[index].val;
+	struct tcf_pedit_parms *parms;
+	u32 val;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	val = parms->tcfp_keys[index].val;
+	rcu_read_unlock();
+
+	return val;
 }
 
 static inline u32 tcf_pedit_offset(const struct tc_action *a, int index)
 {
-	return to_pedit(a)->tcfp_keys[index].off;
+	struct tcf_pedit_parms *parms;
+	u32 off;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	off = parms->tcfp_keys[index].off;
+	rcu_read_unlock();
+
+	return off;
 }
 #endif /* __NET_TC_PED_H */
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index a0378e9f0121..674b534be46e 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -134,6 +134,17 @@ static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
 	return -EINVAL;
 }
 
+static void tcf_pedit_cleanup_rcu(struct rcu_head *head)
+{
+	struct tcf_pedit_parms *parms =
+		container_of(head, struct tcf_pedit_parms, rcu);
+
+	kfree(parms->tcfp_keys_ex);
+	kfree(parms->tcfp_keys);
+
+	kfree(parms);
+}
+
 static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 			  struct nlattr *est, struct tc_action **a,
 			  struct tcf_proto *tp, u32 flags,
@@ -143,8 +154,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_PEDIT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
-	struct tc_pedit_key *keys = NULL;
-	struct tcf_pedit_key_ex *keys_ex;
+	struct tcf_pedit_parms *oparms, *nparms;
 	struct tc_pedit *parm;
 	struct nlattr *pattr;
 	struct tcf_pedit *p;
@@ -181,20 +191,26 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 
-	keys_ex = tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
-	if (IS_ERR(keys_ex))
-		return PTR_ERR(keys_ex);
+	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
+	if (!nparms)
+		return -ENOMEM;
+
+	nparms->tcfp_keys_ex =
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+	if (IS_ERR(nparms->tcfp_keys_ex)) {
+		ret = PTR_ERR(nparms->tcfp_keys_ex);
+		goto out_free;
+	}
 
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_pedit_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_pedit_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
-			goto out_free;
+			goto out_free_ex;
 		}
-		ret = ACT_P_CREATED;
 	} else if (err > 0) {
 		if (bind)
 			goto out_free;
@@ -204,7 +220,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		}
 	} else {
 		ret = err;
-		goto out_free;
+		goto out_free_ex;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
@@ -212,48 +228,51 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		ret = err;
 		goto out_release;
 	}
-	p = to_pedit(*a);
-	spin_lock_bh(&p->tcf_lock);
 
-	if (ret == ACT_P_CREATED ||
-	    (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys)) {
-		keys = kmalloc(ksize, GFP_ATOMIC);
-		if (!keys) {
-			spin_unlock_bh(&p->tcf_lock);
-			ret = -ENOMEM;
-			goto put_chain;
-		}
-		kfree(p->tcfp_keys);
-		p->tcfp_keys = keys;
-		p->tcfp_nkeys = parm->nkeys;
+	nparms->tcfp_off_max_hint = 0;
+	nparms->tcfp_flags = parm->flags;
+	nparms->tcfp_nkeys = parm->nkeys;
+
+	nparms->tcfp_keys = kmalloc(ksize, GFP_KERNEL);
+	if (!nparms->tcfp_keys) {
+		ret = -ENOMEM;
+		goto put_chain;
 	}
-	memcpy(p->tcfp_keys, parm->keys, ksize);
-	p->tcfp_off_max_hint = 0;
-	for (i = 0; i < p->tcfp_nkeys; ++i) {
-		u32 cur = p->tcfp_keys[i].off;
+
+	memcpy(nparms->tcfp_keys, parm->keys, ksize);
+
+	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
+		u32 cur = nparms->tcfp_keys[i].off;
 
 		/* sanitize the shift value for any later use */
-		p->tcfp_keys[i].shift = min_t(size_t, BITS_PER_TYPE(int) - 1,
-					      p->tcfp_keys[i].shift);
+		nparms->tcfp_keys[i].shift = min_t(size_t,
+						   BITS_PER_TYPE(int) - 1,
+						   nparms->tcfp_keys[i].shift);
 
 		/* The AT option can read a single byte, we can bound the actual
 		 * value with uchar max.
 		 */
-		cur += (0xff & p->tcfp_keys[i].offmask) >> p->tcfp_keys[i].shift;
+		cur += (0xff & nparms->tcfp_keys[i].offmask) >> nparms->tcfp_keys[i].shift;
 
 		/* Each key touches 4 bytes starting from the computed offset */
-		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
+		nparms->tcfp_off_max_hint =
+			max(nparms->tcfp_off_max_hint, cur + 4);
 	}
 
-	p->tcfp_flags = parm->flags;
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 
-	kfree(p->tcfp_keys_ex);
-	p->tcfp_keys_ex = keys_ex;
+	p = to_pedit(*a);
 
+	spin_lock_bh(&p->tcf_lock);
+	oparms = rcu_replace_pointer(p->parms, nparms, 1);
 	spin_unlock_bh(&p->tcf_lock);
+
+	if (oparms)
+		call_rcu(&oparms->rcu, tcf_pedit_cleanup_rcu);
+
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
+
 	return ret;
 
 put_chain:
@@ -261,19 +280,20 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		tcf_chain_put_by_act(goto_ch);
 out_release:
 	tcf_idr_release(*a, bind);
+out_free_ex:
+	kfree(nparms->tcfp_keys_ex);
 out_free:
-	kfree(keys_ex);
+	kfree(nparms);
 	return ret;
-
 }
 
 static void tcf_pedit_cleanup(struct tc_action *a)
 {
 	struct tcf_pedit *p = to_pedit(a);
-	struct tc_pedit_key *keys = p->tcfp_keys;
+	struct tcf_pedit_parms *parms;
 
-	kfree(keys);
-	kfree(p->tcfp_keys_ex);
+	parms = rcu_dereference_protected(p->parms, 1);
+	call_rcu(&parms->rcu, tcf_pedit_cleanup_rcu);
 }
 
 static bool offset_valid(struct sk_buff *skb, int offset)
@@ -325,28 +345,30 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 				    struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
+	struct tcf_pedit_parms *parms;
 	u32 max_offset;
 	int i;
 
-	spin_lock(&p->tcf_lock);
+	parms = rcu_dereference_bh(p->parms);
 
 	max_offset = (skb_transport_header_was_set(skb) ?
 		      skb_transport_offset(skb) :
 		      skb_network_offset(skb)) +
-		     p->tcfp_off_max_hint;
+		     parms->tcfp_off_max_hint;
 	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
-		goto unlock;
+		goto done;
 
 	tcf_lastuse_update(&p->tcf_tm);
+	tcf_action_update_bstats(&p->common, skb);
 
-	if (p->tcfp_nkeys > 0) {
-		struct tc_pedit_key *tkey = p->tcfp_keys;
-		struct tcf_pedit_key_ex *tkey_ex = p->tcfp_keys_ex;
+	if (parms->tcfp_nkeys > 0) {
+		struct tc_pedit_key *tkey = parms->tcfp_keys;
+		struct tcf_pedit_key_ex *tkey_ex = parms->tcfp_keys_ex;
 		enum pedit_header_type htype =
 			TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
 		enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
 
-		for (i = p->tcfp_nkeys; i > 0; i--, tkey++) {
+		for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
 			u32 *ptr, hdata;
 			int offset = tkey->off;
 			int hoffset;
@@ -422,11 +444,10 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 	}
 
 bad:
+	spin_lock(&p->tcf_lock);
 	p->tcf_qstats.overlimits++;
-done:
-	bstats_update(&p->tcf_bstats, skb);
-unlock:
 	spin_unlock(&p->tcf_lock);
+done:
 	return p->tcf_action;
 }
 
@@ -445,30 +466,33 @@ static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_pedit *p = to_pedit(a);
+	struct tcf_pedit_parms *parms;
 	struct tc_pedit *opt;
 	struct tcf_t t;
 	int s;
 
-	s = struct_size(opt, keys, p->tcfp_nkeys);
+	spin_lock_bh(&p->tcf_lock);
+	parms = rcu_dereference_protected(p->parms, 1);
+	s = struct_size(opt, keys, parms->tcfp_nkeys);
 
-	/* netlink spinlocks held above us - must use ATOMIC */
 	opt = kzalloc(s, GFP_ATOMIC);
-	if (unlikely(!opt))
+	if (unlikely(!opt)) {
+		spin_unlock_bh(&p->tcf_lock);
 		return -ENOBUFS;
+	}
 
-	spin_lock_bh(&p->tcf_lock);
-	memcpy(opt->keys, p->tcfp_keys, flex_array_size(opt, keys, p->tcfp_nkeys));
+	memcpy(opt->keys, parms->tcfp_keys,
+	       flex_array_size(opt, keys, parms->tcfp_nkeys));
 	opt->index = p->tcf_index;
-	opt->nkeys = p->tcfp_nkeys;
-	opt->flags = p->tcfp_flags;
+	opt->nkeys = parms->tcfp_nkeys;
+	opt->flags = parms->tcfp_flags;
 	opt->action = p->tcf_action;
 	opt->refcnt = refcount_read(&p->tcf_refcnt) - ref;
 	opt->bindcnt = atomic_read(&p->tcf_bindcnt) - bind;
 
-	if (p->tcfp_keys_ex) {
-		if (tcf_pedit_key_ex_dump(skb,
-					  p->tcfp_keys_ex,
-					  p->tcfp_nkeys))
+	if (parms->tcfp_keys_ex) {
+		if (tcf_pedit_key_ex_dump(skb, parms->tcfp_keys_ex,
+					  parms->tcfp_nkeys))
 			goto nla_put_failure;
 
 		if (nla_put(skb, TCA_PEDIT_PARMS_EX, s, opt))
-- 
2.34.1

