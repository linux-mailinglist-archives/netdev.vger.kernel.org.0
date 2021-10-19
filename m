Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA2C433AC1
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhJSPj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhJSPj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:39:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D554061029;
        Tue, 19 Oct 2021 15:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634657864;
        bh=Ucop47/+jBEH9oYguwlpcdXQsoSUIhDFRGU+hQHi++Y=;
        h=From:To:Cc:Subject:Date:From;
        b=IiQgXANYlBTQruB+omPn0g7v1wN9tDnFSD01Rj90lBWP5UZZXFhsUQQdyVLCtye+o
         9Qc8jQMaOeDhYZk3IjqN1wxVqptOCAvmFs81qRFqXwDJ53qvhaw8jtsBXOUo3ENNW3
         nlSyysZPNCYI0faUzGU7McjsU1v1+LdDmwUkUNnyQyf+xqTSB6e6B/l2tU6WOPxeRg
         JS1xvseKWAgaxh2m2In5sXXUibF7K3Y+tYzz51VQ/6KK62mEf0Zq24tXZneFnL8QAv
         H1Xj9Mdhw2q19QtXp0pcK0P5JyPkBLwZHXQDyl3cL/wE5+Ui9tKL6x8mcBDMx/h/B+
         U32pAYDXkpA3w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: sched: gred: dynamically allocate tc_gred_qopt_offload
Date:   Tue, 19 Oct 2021 17:37:27 +0200
Message-Id: <20211019153739.446190-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The tc_gred_qopt_offload structure has grown too big to be on the
stack for 32-bit architectures after recent changes.

net/sched/sch_gred.c:903:13: error: stack frame size (1180) exceeds limit (1024) in 'gred_destroy' [-Werror,-Wframe-larger-than]
net/sched/sch_gred.c:310:13: error: stack frame size (1212) exceeds limit (1024) in 'gred_offload' [-Werror,-Wframe-larger-than]

Use dynamic allocation to avoid this. Unfortunately, this introduces
a new problem in gred_destroy(), which cannot recover from a failure
to allocate memory, and that may be worse than the potential
stack overflow risk.

Not sure what a better approach might be.

Fixes: 50dc9a8572aa ("net: sched: Merge Qdisc::bstats and Qdisc::cpu_bstats data types")
Fixes: 67c9e6270f30 ("net: sched: Protect Qdisc::bstats with u64_stats")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/sched/sch_gred.c | 64 +++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 72de08ef8335..59c55c6cf3ea 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -307,46 +307,53 @@ static void gred_reset(struct Qdisc *sch)
 	}
 }
 
-static void gred_offload(struct Qdisc *sch, enum tc_gred_command command)
+static int gred_offload(struct Qdisc *sch, enum tc_gred_command command)
 {
 	struct gred_sched *table = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	struct tc_gred_qopt_offload opt = {
-		.command	= command,
-		.handle		= sch->handle,
-		.parent		= sch->parent,
-	};
+	struct tc_gred_qopt_offload *opt;
 
 	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
-		return;
+		return -ENXIO;
+
+	opt = kzalloc(sizeof(*opt), GFP_KERNEL);
+	if (!opt)
+		return -ENOMEM;
+
+	opt->command = command;
+	opt->handle = sch->handle;
+	opt->parent = sch->parent;
 
 	if (command == TC_GRED_REPLACE) {
 		unsigned int i;
 
-		opt.set.grio_on = gred_rio_mode(table);
-		opt.set.wred_on = gred_wred_mode(table);
-		opt.set.dp_cnt = table->DPs;
-		opt.set.dp_def = table->def;
+		opt->set.grio_on = gred_rio_mode(table);
+		opt->set.wred_on = gred_wred_mode(table);
+		opt->set.dp_cnt = table->DPs;
+		opt->set.dp_def = table->def;
 
 		for (i = 0; i < table->DPs; i++) {
 			struct gred_sched_data *q = table->tab[i];
 
 			if (!q)
 				continue;
-			opt.set.tab[i].present = true;
-			opt.set.tab[i].limit = q->limit;
-			opt.set.tab[i].prio = q->prio;
-			opt.set.tab[i].min = q->parms.qth_min >> q->parms.Wlog;
-			opt.set.tab[i].max = q->parms.qth_max >> q->parms.Wlog;
-			opt.set.tab[i].is_ecn = gred_use_ecn(q);
-			opt.set.tab[i].is_harddrop = gred_use_harddrop(q);
-			opt.set.tab[i].probability = q->parms.max_P;
-			opt.set.tab[i].backlog = &q->backlog;
+			opt->set.tab[i].present = true;
+			opt->set.tab[i].limit = q->limit;
+			opt->set.tab[i].prio = q->prio;
+			opt->set.tab[i].min = q->parms.qth_min >> q->parms.Wlog;
+			opt->set.tab[i].max = q->parms.qth_max >> q->parms.Wlog;
+			opt->set.tab[i].is_ecn = gred_use_ecn(q);
+			opt->set.tab[i].is_harddrop = gred_use_harddrop(q);
+			opt->set.tab[i].probability = q->parms.max_P;
+			opt->set.tab[i].backlog = &q->backlog;
 		}
-		opt.set.qstats = &sch->qstats;
+		opt->set.qstats = &sch->qstats;
 	}
 
-	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_GRED, &opt);
+	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_GRED, opt);
+	kfree(opt);
+
+	return 0;
 }
 
 static int gred_offload_dump_stats(struct Qdisc *sch)
@@ -470,8 +477,7 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
 		}
 	}
 
-	gred_offload(sch, TC_GRED_REPLACE);
-	return 0;
+	return gred_offload(sch, TC_GRED_REPLACE);
 }
 
 static inline int gred_change_vq(struct Qdisc *sch, int dp,
@@ -719,8 +725,7 @@ static int gred_change(struct Qdisc *sch, struct nlattr *opt,
 	sch_tree_unlock(sch);
 	kfree(prealloc);
 
-	gred_offload(sch, TC_GRED_REPLACE);
-	return 0;
+	return gred_offload(sch, TC_GRED_REPLACE);
 
 err_unlock_free:
 	sch_tree_unlock(sch);
@@ -903,13 +908,16 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 static void gred_destroy(struct Qdisc *sch)
 {
 	struct gred_sched *table = qdisc_priv(sch);
-	int i;
+	int i, ret;
 
 	for (i = 0; i < table->DPs; i++) {
 		if (table->tab[i])
 			gred_destroy_vq(table->tab[i]);
 	}
-	gred_offload(sch, TC_GRED_DESTROY);
+	ret = gred_offload(sch, TC_GRED_DESTROY);
+
+	WARN(ret, "%s: failed to disable offload: %pe\n",
+	     __func__, ERR_PTR(ret));
 }
 
 static struct Qdisc_ops gred_qdisc_ops __read_mostly = {
-- 
2.29.2

