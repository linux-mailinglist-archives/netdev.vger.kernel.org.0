Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6A5433F14
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhJSTSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230432AbhJSTSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 15:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12F156135E;
        Tue, 19 Oct 2021 19:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634670949;
        bh=saeUwL+UJoT1ITyT6b5D5yFqwkea6DBOyq/MVsrSG5g=;
        h=From:To:Cc:Subject:Date:From;
        b=HZ6qYBbCj1dG16Ui6YZdMQcE7UnEj6Ut6GcJcvx20cwv5ohy/wAEqmBbAirm4R20r
         SBm0zh2t5mYcTCzuhxtpXgJxsq5SiLHzLvZJpETsRivtQrhUGlMnXtBfstmg7USMpK
         uFIrOITmwHGMjbBJKy817/JIfuX4cjreHdjmB2xIAgC/G10ihfeRoORDt2TlloxIfb
         68dji29NV6UTrh0rlNMrzUC2vW9QnuPygwcizAbgbQKezQocIviQLpLU1z9xbWU92F
         hu0D1fCXaUH8pz+/7JpEv+lYlp7w51v0k+rn3drmjnS9O9cb4IQbGdx6728XaRlx+d
         xthVCnYBAllWw==
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
        Eric Dumazet <edumazet@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] net: sched: gred: dynamically allocate tc_gred_qopt_offload
Date:   Tue, 19 Oct 2021 21:15:29 +0200
Message-Id: <20211019191544.3063872-1-arnd@kernel.org>
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

Use dynamic allocation per qdisc to avoid this.

Fixes: 50dc9a8572aa ("net: sched: Merge Qdisc::bstats and Qdisc::cpu_bstats data types")
Fixes: 67c9e6270f30 ("net: sched: Protect Qdisc::bstats with u64_stats")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Hi Jakub,

Not sure if this is what you had in mind, if not it might be easier
if you do it yourself. In particular, adding tc_gred_qopt_offload
to gred_sched directly rather than as a pointer may be easier here,
but that may have other downsides.

Changes in v2:
- allocate structure at init time rather than inside of
  gred_offload()
---
 net/sched/sch_gred.c | 50 ++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 72de08ef8335..d44958f3411a 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -56,6 +56,7 @@ struct gred_sched {
 	u32 		DPs;
 	u32 		def;
 	struct red_vars wred_set;
+	struct tc_gred_qopt_offload *opt;
 };
 
 static inline int gred_wred_mode(struct gred_sched *table)
@@ -311,42 +312,45 @@ static void gred_offload(struct Qdisc *sch, enum tc_gred_command command)
 {
 	struct gred_sched *table = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	struct tc_gred_qopt_offload opt = {
-		.command	= command,
-		.handle		= sch->handle,
-		.parent		= sch->parent,
-	};
+	struct tc_gred_qopt_offload *opt = table->opt;
 
 	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
 		return;
 
+	memset(opt, 0, sizeof(*opt));
+	opt->command = command;
+	opt->handle = sch->handle;
+	opt->parent = sch->parent;
+
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
+
+	return;
 }
 
 static int gred_offload_dump_stats(struct Qdisc *sch)
@@ -731,6 +735,7 @@ static int gred_change(struct Qdisc *sch, struct nlattr *opt,
 static int gred_init(struct Qdisc *sch, struct nlattr *opt,
 		     struct netlink_ext_ack *extack)
 {
+	struct gred_sched *table = qdisc_priv(sch);
 	struct nlattr *tb[TCA_GRED_MAX + 1];
 	int err;
 
@@ -754,6 +759,10 @@ static int gred_init(struct Qdisc *sch, struct nlattr *opt,
 		sch->limit = qdisc_dev(sch)->tx_queue_len
 		             * psched_mtu(qdisc_dev(sch));
 
+	table->opt = kzalloc(sizeof(table->opt), GFP_KERNEL);
+	if (!table->opt)
+		return -ENOMEM;
+
 	return gred_change_table_def(sch, tb[TCA_GRED_DPS], extack);
 }
 
@@ -910,6 +919,7 @@ static void gred_destroy(struct Qdisc *sch)
 			gred_destroy_vq(table->tab[i]);
 	}
 	gred_offload(sch, TC_GRED_DESTROY);
+	kfree(table->opt);
 }
 
 static struct Qdisc_ops gred_qdisc_ops __read_mostly = {
-- 
2.29.2

