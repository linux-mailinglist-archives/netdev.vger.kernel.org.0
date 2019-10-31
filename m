Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3000AEAFBC
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfJaL6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:58:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55247 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfJaLzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:55:04 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iQ92U-0002qN-2b; Thu, 31 Oct 2019 12:54:54 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id AB7DD1C03AD;
        Thu, 31 Oct 2019 12:54:53 +0100 (CET)
Date:   Thu, 31 Oct 2019 11:54:53 -0000
From:   "tip-bot2 for Paul E. McKenney" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: core/rcu] net/sched: Replace rcu_swap_protected() with
 rcu_replace_pointer()
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
MIME-Version: 1.0
Message-ID: <157252289338.29376.7778647573740451400.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit has been merged into the core/rcu branch of tip:

Commit-ID:     445d3749315f34229dcfc3efd82796f97fc72e92
Gitweb:        https://git.kernel.org/tip/445d3749315f34229dcfc3efd82796f97fc72e92
Author:        Paul E. McKenney <paulmck@kernel.org>
AuthorDate:    Mon, 23 Sep 2019 16:09:18 -07:00
Committer:     Paul E. McKenney <paulmck@kernel.org>
CommitterDate: Wed, 30 Oct 2019 08:45:48 -07:00

net/sched: Replace rcu_swap_protected() with rcu_replace_pointer()

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace_pointer() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
[ paulmck: From rcu_replace() to rcu_replace_pointer() per Ingo Molnar. ]
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
 net/sched/act_ct.c         | 3 ++-
 net/sched/act_ctinfo.c     | 4 ++--
 net/sched/act_ife.c        | 2 +-
 net/sched/act_mirred.c     | 4 ++--
 net/sched/act_mpls.c       | 2 +-
 net/sched/act_police.c     | 6 +++---
 net/sched/act_sample.c     | 4 ++--
 net/sched/act_skbedit.c    | 4 ++--
 net/sched/act_tunnel_key.c | 4 ++--
 net/sched/act_vlan.c       | 2 +-
 12 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2558f00..3d51573 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -88,7 +88,7 @@ struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 					 struct tcf_chain *goto_chain)
 {
 	a->tcfa_action = action;
-	rcu_swap_protected(a->goto_chain, goto_chain, 1);
+	goto_chain = rcu_replace_pointer(a->goto_chain, goto_chain, 1);
 	return goto_chain;
 }
 EXPORT_SYMBOL(tcf_action_set_ctrlact);
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index d3cfad8..87dddba 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -101,8 +101,8 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&p->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(p->params, params_new,
-			   lockdep_is_held(&p->tcf_lock));
+	params_new = rcu_replace_pointer(p->params, params_new,
+					 lockdep_is_held(&p->tcf_lock));
 	spin_unlock_bh(&p->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index fcc4602..2d5ab23 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -722,7 +722,8 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(c->params, params, lockdep_is_held(&c->tcf_lock));
+	params = rcu_replace_pointer(c->params, params,
+				     lockdep_is_held(&c->tcf_lock));
 	spin_unlock_bh(&c->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 0dbcfd1..c599818 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -257,8 +257,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&ci->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, actparm->action, goto_ch);
-	rcu_swap_protected(ci->params, cp_new,
-			   lockdep_is_held(&ci->tcf_lock));
+	cp_new = rcu_replace_pointer(ci->params, cp_new,
+				     lockdep_is_held(&ci->tcf_lock));
 	spin_unlock_bh(&ci->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 3a31e24..2ea2e16 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -594,7 +594,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 		spin_lock_bh(&ife->tcf_lock);
 	/* protected by tcf_lock when modifying existing action */
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(ife->params, p, 1);
+	p = rcu_replace_pointer(ife->params, p, 1);
 
 	if (exists)
 		spin_unlock_bh(&ife->tcf_lock);
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 9ce073a..0c2f737 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -178,8 +178,8 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 			goto put_chain;
 		}
 		mac_header_xmit = dev_is_mac_header_xmit(dev);
-		rcu_swap_protected(m->tcfm_dev, dev,
-				   lockdep_is_held(&m->tcf_lock));
+		dev = rcu_replace_pointer(m->tcfm_dev, dev,
+					  lockdep_is_held(&m->tcf_lock));
 		if (dev)
 			dev_put(dev);
 		m->tcfm_mac_header_xmit = mac_header_xmit;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index e168df0..5b3031c 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -258,7 +258,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&m->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(m->mpls_p, p, lockdep_is_held(&m->tcf_lock));
+	p = rcu_replace_pointer(m->mpls_p, p, lockdep_is_held(&m->tcf_lock));
 	spin_unlock_bh(&m->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 89c04c5..caa91cf 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -191,9 +191,9 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 		police->tcfp_ptoks = new->tcfp_mtu_ptoks;
 	spin_unlock_bh(&police->tcfp_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(police->params,
-			   new,
-			   lockdep_is_held(&police->tcf_lock));
+	new = rcu_replace_pointer(police->params,
+				  new,
+				  lockdep_is_held(&police->tcf_lock));
 	spin_unlock_bh(&police->tcf_lock);
 
 	if (goto_ch)
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 514456a..4deeaf2 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -102,8 +102,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	s->rate = rate;
 	s->psample_group_num = psample_group_num;
-	rcu_swap_protected(s->psample_group, psample_group,
-			   lockdep_is_held(&s->tcf_lock));
+	psample_group = rcu_replace_pointer(s->psample_group, psample_group,
+					    lockdep_is_held(&s->tcf_lock));
 
 	if (tb[TCA_SAMPLE_TRUNC_SIZE]) {
 		s->truncate = true;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 6a8d333..c38cc39 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -206,8 +206,8 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&d->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(d->params, params_new,
-			   lockdep_is_held(&d->tcf_lock));
+	params_new = rcu_replace_pointer(d->params, params_new,
+					 lockdep_is_held(&d->tcf_lock));
 	spin_unlock_bh(&d->tcf_lock);
 	if (params_new)
 		kfree_rcu(params_new, rcu);
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 2f83a79..20d7ca4 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -381,8 +381,8 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&t->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(t->params, params_new,
-			   lockdep_is_held(&t->tcf_lock));
+	params_new = rcu_replace_pointer(t->params, params_new,
+					 lockdep_is_held(&t->tcf_lock));
 	spin_unlock_bh(&t->tcf_lock);
 	tunnel_key_release_params(params_new);
 	if (goto_ch)
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 08aaf71..7aca1f0 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -220,7 +220,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 
 	spin_lock_bh(&v->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-	rcu_swap_protected(v->vlan_p, p, lockdep_is_held(&v->tcf_lock));
+	p = rcu_replace_pointer(v->vlan_p, p, lockdep_is_held(&v->tcf_lock));
 	spin_unlock_bh(&v->tcf_lock);
 
 	if (goto_ch)
