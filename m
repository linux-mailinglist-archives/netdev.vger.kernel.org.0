Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BD7692891
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 21:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbjBJUpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 15:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbjBJUpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 15:45:03 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65E070714
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:45:01 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id 38-20020a9d04a9000000b0068f24f576c5so1629506otm.11
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L2OELBHVTmIPYbUYyMRK6qAq6fpi8NqW2WegJ/4prVM=;
        b=i9yDukMRWXAmwBREZj7/JGtotgTXJieQjOyRdA3v1yCQ+cQONzuXNmdIBW8/JUqicP
         p4Svi5/Ld7Q4WfjyFG3KI97byBSDKu1KSiE9Nt7oII7n7iZ4P7wlKu6SCVHgmOQRIPJy
         uUdFXH1pAeRcUT25cRzwWe223QUKHcX5YgTob6QBvf2UdyPB13oBs84qRfBMMAln58RW
         G3ZcWpKjcMIc9yKF2QTJB7HS8apQoc2dqrR+80rPtK5jiEd3URiwZxm+447AOGfGaLbn
         7dwZAKhGKbOeExmKNoPozLZ4SjUe9YsiLhjRQqJ/MUD9JNdJMLzZR5g7J0N0KSfJ5EnM
         2IEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L2OELBHVTmIPYbUYyMRK6qAq6fpi8NqW2WegJ/4prVM=;
        b=DDTIq+QmLfMbpPTQd9h1fYFSUXryORL+R2UphPlUVRKhonaHXGhKUJb0NpywZn6pzy
         1E5mzf0vhn3q6LQUIsoqh0HF6Btebh7Dh/A0nlwDwou5o2q8njKkAkf1CPfChCREKJJt
         jnXFG/muilzusmfacUxTw0k/rkYMVmgpzXILTCQEfAolzQtahCsvWpngAUS7S+T2HVLb
         Pf3sN3/Or0M3yszPbXfNLcOPzWDWXCDMkQT2/C01KkNLfAKtYsqnmcJXYTYKNjDbXqkU
         tHQJcCDCkjAbt2Fe+wB8CGy/hSUecwsp5MSiEwVDPs30ZVEZUXHkEUrbnxJnK3T/LogI
         YAPQ==
X-Gm-Message-State: AO0yUKXBLm0sj/iZPKb8dQ6nNJ+lb1gHiJiiwhgzhvuPsOYBTtEUUIZy
        S672vMpLfC2h5ERLrveJAJYJFyJNAC6nnmvm
X-Google-Smtp-Source: AK7set8NTx18TDPv2eGWkM7kDJBQIk+m4w+1Eqq/HaY8e7i6G+wSYTRol6X9WdMXayimRkZUyidJtA==
X-Received: by 2002:a9d:4549:0:b0:68d:71d0:ed13 with SMTP id p9-20020a9d4549000000b0068d71d0ed13mr9444094oti.1.1676061901044;
        Fri, 10 Feb 2023 12:45:01 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:2ce0:9122:6880:760c])
        by smtp.gmail.com with ESMTPSA id v23-20020a9d5a17000000b0068bc8968753sm2396681oth.17.2023.02.10.12.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:45:00 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 2/3] net/sched: act_connmark: transition to percpu stats and rcu
Date:   Fri, 10 Feb 2023 17:27:25 -0300
Message-Id: <20230210202725.446422-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210202725.446422-1-pctammela@mojatatu.com>
References: <20230210202725.446422-1-pctammela@mojatatu.com>
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

The tc action act_connmark was using shared stats and taking the per
action lock in the datapath. Improve it by using percpu stats and rcu.

perf before:
- 13.55% tcf_connmark_act
   - 81.18% _raw_spin_lock
       80.46% native_queued_spin_lock_slowpath

perf after:
- 3.12% tcf_connmark_act

tdc results:
1..15
ok 1 2002 - Add valid connmark action with defaults
ok 2 56a5 - Add valid connmark action with control pass
ok 3 7c66 - Add valid connmark action with control drop
ok 4 a913 - Add valid connmark action with control pipe
ok 5 bdd8 - Add valid connmark action with control reclassify
ok 6 b8be - Add valid connmark action with control continue
ok 7 d8a6 - Add valid connmark action with control jump
ok 8 aae8 - Add valid connmark action with zone argument
ok 9 2f0b - Add valid connmark action with invalid zone argument
ok 10 9305 - Add connmark action with unsupported argument
ok 11 71ca - Add valid connmark action and replace it
ok 12 5f8f - Add valid connmark action with cookie
ok 13 c506 - Replace connmark with invalid goto chain control
ok 14 6571 - Delete connmark action with valid index
ok 15 3426 - Delete connmark action with invalid index

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/net/tc_act/tc_connmark.h |   9 ++-
 net/sched/act_connmark.c         | 109 ++++++++++++++++++++-----------
 2 files changed, 77 insertions(+), 41 deletions(-)

diff --git a/include/net/tc_act/tc_connmark.h b/include/net/tc_act/tc_connmark.h
index 1f4cb477b..e8dd77a96 100644
--- a/include/net/tc_act/tc_connmark.h
+++ b/include/net/tc_act/tc_connmark.h
@@ -4,10 +4,15 @@
 
 #include <net/act_api.h>
 
-struct tcf_connmark_info {
-	struct tc_action common;
+struct tcf_connmark_parms {
 	struct net *net;
 	u16 zone;
+	struct rcu_head rcu;
+};
+
+struct tcf_connmark_info {
+	struct tc_action common;
+	struct tcf_connmark_parms __rcu *parms;
 };
 
 #define to_connmark(a) ((struct tcf_connmark_info *)a)
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 7e63ff7e3..541e1c556 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -36,13 +36,15 @@ TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff *skb,
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
 	struct tcf_connmark_info *ca = to_connmark(a);
+	struct tcf_connmark_parms *parms;
 	struct nf_conntrack_zone zone;
 	struct nf_conn *c;
 	int proto;
 
-	spin_lock(&ca->tcf_lock);
 	tcf_lastuse_update(&ca->tcf_tm);
-	bstats_update(&ca->tcf_bstats, skb);
+	tcf_action_update_bstats(&ca->common, skb);
+
+	parms = rcu_dereference_bh(ca->parms);
 
 	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
@@ -64,31 +66,31 @@ TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff *skb,
 	c = nf_ct_get(skb, &ctinfo);
 	if (c) {
 		skb->mark = READ_ONCE(c->mark);
-		/* using overlimits stats to count how many packets marked */
-		ca->tcf_qstats.overlimits++;
-		goto out;
+		goto count;
 	}
 
-	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-			       proto, ca->net, &tuple))
+	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, parms->net,
+			       &tuple))
 		goto out;
 
-	zone.id = ca->zone;
+	zone.id = parms->zone;
 	zone.dir = NF_CT_DEFAULT_ZONE_DIR;
 
-	thash = nf_conntrack_find_get(ca->net, &zone, &tuple);
+	thash = nf_conntrack_find_get(parms->net, &zone, &tuple);
 	if (!thash)
 		goto out;
 
 	c = nf_ct_tuplehash_to_ctrack(thash);
-	/* using overlimits stats to count how many packets marked */
-	ca->tcf_qstats.overlimits++;
 	skb->mark = READ_ONCE(c->mark);
 	nf_ct_put(c);
 
-out:
+count:
+	/* using overlimits stats to count how many packets marked */
+	spin_lock(&ca->tcf_lock);
+	ca->tcf_qstats.overlimits++;
 	spin_unlock(&ca->tcf_lock);
-	return ca->tcf_action;
+out:
+	return READ_ONCE(ca->tcf_action);
 }
 
 static const struct nla_policy connmark_policy[TCA_CONNMARK_MAX + 1] = {
@@ -104,6 +106,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	struct nlattr *tb[TCA_CONNMARK_MAX + 1];
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct tcf_chain *goto_ch = NULL;
+	struct tcf_connmark_parms *nparms, *oparms;
 	struct tcf_connmark_info *ci;
 	struct tc_connmark *parm;
 	int ret = 0, err;
@@ -120,52 +123,66 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	if (!tb[TCA_CONNMARK_PARMS])
 		return -EINVAL;
 
+	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
+	if (!nparms)
+		return -ENOMEM;
+
 	parm = nla_data(tb[TCA_CONNMARK_PARMS]);
 	index = parm->index;
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_connmark_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_connmark_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
-			return ret;
+			err = ret;
+			goto out_free;
 		}
 
 		ci = to_connmark(*a);
-		err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch,
-					       extack);
-		if (err < 0)
-			goto release_idr;
-		tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-		ci->net = net;
-		ci->zone = parm->zone;
+
+		nparms->net = net;
+		nparms->zone = parm->zone;
 
 		ret = ACT_P_CREATED;
 	} else if (ret > 0) {
 		ci = to_connmark(*a);
-		if (bind)
-			return 0;
-		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
-			tcf_idr_release(*a, bind);
-			return -EEXIST;
+		if (bind) {
+			err = 0;
+			goto out_free;
 		}
-		err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch,
-					       extack);
-		if (err < 0)
+		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
+			err = -EEXIST;
 			goto release_idr;
-		/* replacing action and zone */
-		spin_lock_bh(&ci->tcf_lock);
-		goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-		ci->zone = parm->zone;
-		spin_unlock_bh(&ci->tcf_lock);
-		if (goto_ch)
-			tcf_chain_put_by_act(goto_ch);
+		}
+
+		nparms->net = rtnl_dereference(ci->parms)->net;
+		nparms->zone = parm->zone;
+
 		ret = 0;
 	}
 
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	spin_lock_bh(&ci->tcf_lock);
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	oparms = rcu_replace_pointer(ci->parms, nparms, lockdep_is_held(&ci->tcf_lock));
+	spin_unlock_bh(&ci->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+
+	if (oparms)
+		kfree_rcu(oparms, rcu);
+
 	return ret;
+
 release_idr:
 	tcf_idr_release(*a, bind);
+out_free:
+	kfree(nparms);
 	return err;
 }
 
@@ -179,11 +196,14 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
 		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
 	};
+	struct tcf_connmark_parms *parms;
 	struct tcf_t t;
 
 	spin_lock_bh(&ci->tcf_lock);
+	parms = rcu_dereference_protected(ci->parms, lockdep_is_held(&ci->tcf_lock));
+
 	opt.action = ci->tcf_action;
-	opt.zone = ci->zone;
+	opt.zone = parms->zone;
 	if (nla_put(skb, TCA_CONNMARK_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
@@ -201,6 +221,16 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
+static void tcf_connmark_cleanup(struct tc_action *a)
+{
+	struct tcf_connmark_parms *parms;
+	struct tcf_connmark_info *ci = to_connmark(a);
+
+	parms = rcu_dereference_protected(ci->parms, 1);
+	if (parms)
+		kfree_rcu(parms, rcu);
+}
+
 static struct tc_action_ops act_connmark_ops = {
 	.kind		=	"connmark",
 	.id		=	TCA_ID_CONNMARK,
@@ -208,6 +238,7 @@ static struct tc_action_ops act_connmark_ops = {
 	.act		=	tcf_connmark_act,
 	.dump		=	tcf_connmark_dump,
 	.init		=	tcf_connmark_init,
+	.cleanup	=	tcf_connmark_cleanup,
 	.size		=	sizeof(struct tcf_connmark_info),
 };
 
-- 
2.34.1

