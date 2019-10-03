Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3BBC9666
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 03:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfJCBnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 21:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbfJCBnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 21:43:16 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9F3222CC;
        Thu,  3 Oct 2019 01:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570066995;
        bh=cJ0IjaA90csRKxjxaCP3JNF49foRVRi6wMQidNae72o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MR6P6MZ7Ui1QVG/sPS1nuHSiYrC0YOOVUENvdG29pRHTxeezBDgSfmeo9qnPOVJ0f
         oxi+MbEONZfsiet+0vayRYbwuyXh+2IogavkdUsB97obRxr8gticH3A02iypEomI1T
         UhXhE8ALBWwmWUTu74nlpSko6btoRakpbbw+Flx4=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH tip/core/rcu 9/9] net/sched: Replace rcu_swap_protected() with rcu_replace()
Date:   Wed,  2 Oct 2019 18:43:10 -0700
Message-Id: <20191003014310.13262-9-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20191003014153.GA13156@paulmck-ThinkPad-P72>
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
---
 net/sched/act_api.c        | 2 +-
 net/sched/act_csum.c       | 4 ++--
 net/sched/act_ct.c         | 2 +-
 net/sched/act_ctinfo.c     | 4 ++--
 net/sched/act_ife.c        | 2 +-
 net/sched/act_mirred.c     | 4 ++--
 net/sched/act_mpls.c       | 2 +-
 net/sched/act_police.c     | 6 +++---
 net/sched/act_skbedit.c    | 4 ++--
 net/sched/act_tunnel_key.c | 4 ++--
 net/sched/act_vlan.c       | 2 +-
 11 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2558f00..1ab810c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -88,7 +88,7 @@ struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 					 struct tcf_chain *goto_chain)
 {
 	a->tcfa_action = action;
-	rcu_swap_protected(a->goto_chain, goto_chain, 1);
+	goto_chain = rcu_replace(a->goto_chain, goto_chain, 1);
 	return goto_chain;
 }
 EXPORT_SYMBOL(tcf_action_set_ctrlact);
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index d3cfad8..ced5fe6 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -101,8 +101,8 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&p->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(p->params, params_new,
-			   lockdep_is_held(&p->tcf_lock));
+	params_new = rcu_replace(p->params, params_new,
+				 lockdep_is_held(&p->tcf_lock));
 	spin_unlock_bh(&p->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index fcc4602..500e874 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -722,7 +722,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(c->params, params, lockdep_is_held(&c->tcf_lock));
+	params = rcu_replace(c->params, params, lockdep_is_held(&c->tcf_lock));
 	spin_unlock_bh(&c->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 0dbcfd1..e6ea270 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -257,8 +257,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&ci->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, actparm->action, goto_ch);
-	rcu_swap_protected(ci->params, cp_new,
-			   lockdep_is_held(&ci->tcf_lock));
+	cp_new = rcu_replace(ci->params, cp_new,
+			     lockdep_is_held(&ci->tcf_lock));
 	spin_unlock_bh(&ci->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 3a31e24..a6a60b8 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -594,7 +594,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 		spin_lock_bh(&ife->tcf_lock);
 	/* protected by tcf_lock when modifying existing action */
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(ife->params, p, 1);
+	p = rcu_replace(ife->params, p, 1);
 
 	if (exists)
 		spin_unlock_bh(&ife->tcf_lock);
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 9ce073a..1ed5d7e 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -178,8 +178,8 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 			goto put_chain;
 		}
 		mac_header_xmit = dev_is_mac_header_xmit(dev);
-		rcu_swap_protected(m->tcfm_dev, dev,
-				   lockdep_is_held(&m->tcf_lock));
+		dev = rcu_replace(m->tcfm_dev, dev,
+				  lockdep_is_held(&m->tcf_lock));
 		if (dev)
 			dev_put(dev);
 		m->tcfm_mac_header_xmit = mac_header_xmit;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index e168df0..cea8771 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -258,7 +258,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&m->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(m->mpls_p, p, lockdep_is_held(&m->tcf_lock));
+	p = rcu_replace(m->mpls_p, p, lockdep_is_held(&m->tcf_lock));
 	spin_unlock_bh(&m->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 89c04c5..02a4bc9c 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -191,9 +191,9 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 		police->tcfp_ptoks = new->tcfp_mtu_ptoks;
 	spin_unlock_bh(&police->tcfp_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(police->params,
-			   new,
-			   lockdep_is_held(&police->tcf_lock));
+	new = rcu_replace(police->params,
+			  new,
+			  lockdep_is_held(&police->tcf_lock));
 	spin_unlock_bh(&police->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 6a8d333..6c4bd47 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -206,8 +206,8 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&d->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(d->params, params_new,
-			   lockdep_is_held(&d->tcf_lock));
+	params_new = rcu_replace(d->params, params_new,
+				 lockdep_is_held(&d->tcf_lock));
 	spin_unlock_bh(&d->tcf_lock);
 	if (params_new)
 		kfree_rcu(params_new, rcu);
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 2f83a79..7130da8 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -381,8 +381,8 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&t->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(t->params, params_new,
-			   lockdep_is_held(&t->tcf_lock));
+	params_new = rcu_replace(t->params, params_new,
+				 lockdep_is_held(&t->tcf_lock));
 	spin_unlock_bh(&t->tcf_lock);
 	tunnel_key_release_params(params_new);
 	if (goto_ch)
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 08aaf71..402c9ea 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -220,7 +220,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&v->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(v->vlan_p, p, lockdep_is_held(&v->tcf_lock));
+	p = rcu_replace(v->vlan_p, p, lockdep_is_held(&v->tcf_lock));
 	spin_unlock_bh(&v->tcf_lock);
 
 	if (goto_ch)
-- 
2.9.5

