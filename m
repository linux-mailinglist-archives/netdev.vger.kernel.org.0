Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E03130E2
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfECPHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:07:12 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47372 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727970AbfECPHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:07:12 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id C34A1B00076;
        Fri,  3 May 2019 15:07:10 +0000 (UTC)
Received: from ehc-opti7040.uk.solarflarecom.com (10.17.20.203) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 3 May 2019 16:07:04 +0100
Date:   Fri, 3 May 2019 16:06:55 +0100
From:   Edward Cree <ecree@solarflare.com>
X-X-Sender: ehc@ehc-opti7040.uk.solarflarecom.com
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Or Gerlitz" <gerlitz.or@gmail.com>
Subject: [RFC PATCH net-next 2/3] flow_offload: restore ability to collect
 separate stats per action
Message-ID: <alpine.LFD.2.21.1905031603340.11823@ehc-opti7040.uk.solarflarecom.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24588.003
X-TM-AS-Result: No-7.142200-8.000000-10
X-TMASE-MatchedRID: y64C6oV0e4ded9AE62fSOfVFR4sC8dPy6J4k0JZAHPIs/uUAk6xP7PlY
        oV6p/cSxrKWVhE5vxYb+q2b8e8ILI2MAzi+7d0chyeVujmXuYYVA8JZETQujwr/A+0D1to6PxUD
        TxL3vuSDGmF+VTWRGnedWYGJrDycl7gp3lniZRi9/OBWacv+iVTacujaE3jwhmyiLZetSf8l9j2
        GwzTE3vSq2rl3dzGQ1ropAi/FV10zxGD8G3ENQB3RL5UyNJUkG7bw3Q6y1XyFjDdectxANJHaZp
        1RYI3/x
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.142200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24588.003
X-MDID: 1556896031-iRETPWV9w366
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new offload command TC_CLSFLOWER_STATS_BYINDEX, similar to
 the existing TC_CLSFLOWER_STATS but specifying an action_index (the
 tcfa_index of the action), which is called for each stats-having action
 on the rule.  Drivers should implement either, but not both, of these
 commands.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/net/pkt_cls.h  |  2 ++
 net/sched/cls_flower.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d5e7a1af346f..0e33c52c23a8 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -762,6 +762,7 @@ enum tc_fl_command {
 	TC_CLSFLOWER_REPLACE,
 	TC_CLSFLOWER_DESTROY,
 	TC_CLSFLOWER_STATS,
+	TC_CLSFLOWER_STATS_BYINDEX,
 	TC_CLSFLOWER_TMPLT_CREATE,
 	TC_CLSFLOWER_TMPLT_DESTROY,
 };
@@ -773,6 +774,7 @@ struct tc_cls_flower_offload {
 	struct flow_rule *rule;
 	struct flow_stats stats;
 	u32 classid;
+	u32 action_index; /* for TC_CLSFLOWER_STATS_BYINDEX */
 };
 
 static inline struct flow_rule *
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f6685fc53119..be339cd6a86e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -474,6 +474,10 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 {
 	struct tc_cls_flower_offload cls_flower = {};
 	struct tcf_block *block = tp->chain->block;
+#ifdef CONFIG_NET_CLS_ACT
+	struct tc_action *a;
+	int i;
+#endif
 
 	if (!rtnl_held)
 		rtnl_lock();
@@ -489,6 +493,32 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 			      cls_flower.stats.pkts,
 			      cls_flower.stats.lastused);
 
+#ifdef CONFIG_NET_CLS_ACT
+	for (i = 0; i < f->exts.nr_actions; i++) {
+		a = f->exts.actions[i];
+
+		if (!a->ops->stats_update)
+			continue;
+		memset(&cls_flower, 0, sizeof(cls_flower));
+		tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, NULL);
+		cls_flower.command = TC_CLSFLOWER_STATS_BYINDEX;
+		cls_flower.cookie = (unsigned long) f;
+		cls_flower.classid = f->res.classid;
+		cls_flower.action_index = a->tcfa_index;
+
+		tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
+
+		/* Some ->stats_update() use percpu variables and must thus be
+		 * called with preemption disabled.
+		 */
+		preempt_disable();
+		a->ops->stats_update(a, cls_flower.stats.bytes,
+				     cls_flower.stats.pkts,
+				     cls_flower.stats.lastused, true);
+		preempt_enable();
+	}
+#endif
+
 	if (!rtnl_held)
 		rtnl_unlock();
 }
