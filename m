Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9ECA34EFA
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfFDRee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:34:34 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33734 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbfFDRee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:34:34 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E0E139C0076;
        Tue,  4 Jun 2019 17:34:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 4 Jun
 2019 10:34:24 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH v4 net-next 2/4] net/sched: add callback to get stats on
 an action from clsflower offload
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com>
Message-ID: <90148989-67c2-32f5-2dff-52e65bceac56@solarflare.com>
Date:   Tue, 4 Jun 2019 18:34:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24656.005
X-TM-AS-Result: No-4.246100-4.000000-10
X-TMASE-MatchedRID: fASjJbTnm+Hd2kK37TYfrBwu4QM/6CpysKi4EXb8AIoL9Tj77wy87NwZ
        JVPYeiexA0Ia1yOwDZsfhLGyUXA5963lYtxgmvzn1TY/cLrxiVA/pOSL72dTf1jBUeMsjed6QBz
        oPKhLasiN/ziTW5bneGRg+Czv7wwMaKq8Xvex6Ur805SSvoAPNwgY7KPzv1XIYq4PLSQobHQvr7
        iJcUnmgenowGL4wfWVjohvSxwpLyBq6Si22m8VZqIBnfMCFBiCNV9S7O+u3KZsMPuLZB/IRwGLn
        +VnTbSVulTF7UnPKnfuFC9g00HQc0fr6WG4Th9alchF+IvkllO6SpEJ2hepWpsoi2XrUn/JyeMt
        MD9QOgBJeFvFlVDkf46HM5rqDwqt4Wg+LnqPlKSXywYh61h9fepmi3viKaSWaltmmdgdMrNOYt5
        /FTEEaYXM0+JuQ7RSVLH+9xNMEq5qaZk4s8JYz0oq2CaP/vIlF8WOpmrvCxtyCYeHQXFONn+IaU
        6aARfSasRgksxQ/TKwzFr1189Za5RMZUCEHkRt
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.246100-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24656.005
X-MDID: 1559669673-pYAwMnO0K_rp
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When handling RTM_GETACTION (e.g. tc actions get/list), make a callback to
 blocks with hardware offload of the action to update stats from hardware.
In order to support this, track each action/block binding by allocating a
 struct tc_action_block_binding and adding it to a list on the action.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/linux/netdevice.h |  1 +
 include/net/act_api.h     |  2 +-
 include/net/pkt_cls.h     | 18 ++++++++++++++
 net/sched/act_api.c       | 50 +++++++++++++++++++++++++++++++++++++++
 net/sched/cls_flower.c    |  7 ++++++
 5 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 44b47e9df94a..dee84954a1c7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -849,6 +849,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_ETF,
 	TC_SETUP_ROOT_QDISC,
 	TC_SETUP_QDISC_GRED,
+	TC_SETUP_ACTION,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/act_api.h b/include/net/act_api.h
index c61a1bf4e3de..38d1769f279b 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -40,6 +40,7 @@ struct tc_action {
 	struct gnet_stats_queue __percpu *cpu_qstats;
 	struct tc_cookie	__rcu *act_cookie;
 	struct tcf_chain	__rcu *goto_chain;
+	struct list_head		hw_blocks;
 };
 #define tcf_index	common.tcfa_index
 #define tcf_refcnt	common.tcfa_refcnt
@@ -199,5 +200,4 @@ static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
 #endif
 }
 
-
 #endif
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 514e3c80ecc1..880048879904 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -342,6 +342,14 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (; 0; (void)(i), (void)(a), (void)(exts))
 #endif
 
+struct tc_action_block_binding {
+	struct list_head list;
+	struct tcf_block *block;
+};
+
+void tc_bind_action_blocks(struct tcf_exts *exts, struct tcf_block *block);
+void tc_unbind_action_blocks(struct tcf_exts *exts, struct tcf_block *block);
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 lastuse)
@@ -953,4 +961,14 @@ struct tc_root_qopt_offload {
 	bool ingress;
 };
 
+enum tc_action_command {
+	TC_ACTION_STATS,
+};
+
+struct tc_action_offload {
+	enum tc_action_command command;
+	unsigned long cookie;
+	struct flow_stats stats;
+};
+
 #endif
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index c42ecf4b3c10..239fc28456d9 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -427,6 +427,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 			goto err3;
 	}
 	spin_lock_init(&p->tcfa_lock);
+	INIT_LIST_HEAD(&p->hw_blocks);
 	p->tcfa_index = index;
 	p->tcfa_tm.install = jiffies;
 	p->tcfa_tm.lastuse = jiffies;
@@ -753,6 +754,20 @@ tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	return a->ops->dump(skb, a, bind, ref);
 }
 
+static void tcf_action_update_stats(struct tc_action *a)
+{
+	struct tc_action_block_binding *bind;
+	struct tc_action_offload offl = {};
+
+	offl.command = TC_ACTION_STATS;
+	offl.cookie = (unsigned long)a;
+	ASSERT_RTNL();
+	list_for_each_entry(bind, &a->hw_blocks, list)
+		tc_setup_cb_call(bind->block, TC_SETUP_ACTION, &offl, false);
+	tcf_action_stats_update(a, offl.stats.bytes, offl.stats.pkts,
+				offl.stats.lastused, true);
+}
+
 int
 tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 {
@@ -763,6 +778,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 
 	if (nla_put_string(skb, TCA_KIND, a->ops->kind))
 		goto nla_put_failure;
+	tcf_action_update_stats(a);
 	if (tcf_action_copy_stats(skb, a, 0))
 		goto nla_put_failure;
 
@@ -1538,6 +1554,40 @@ static int tc_dump_action(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+/** Add a binding for %block to hw_blocks list of each action in %exts */
+void tc_bind_action_blocks(struct tcf_exts *exts, struct tcf_block *block)
+{
+	struct tc_action_block_binding *bind;
+	struct tc_action *act;
+	int i;
+
+	tcf_exts_for_each_action(i, act, exts) {
+		bind = kzalloc(sizeof(*bind), GFP_KERNEL);
+		if (WARN_ON_ONCE(!bind))
+			continue; /* just skip it, stats won't update timely */
+		bind->block = block;
+		list_add_tail(&bind->list, &act->hw_blocks);
+	}
+}
+EXPORT_SYMBOL(tc_bind_action_blocks);
+
+/** Remove one instance of %block from binding list of each action in %exts */
+void tc_unbind_action_blocks(struct tcf_exts *exts, struct tcf_block *block)
+{
+	struct tc_action_block_binding *bind;
+	struct tc_action *act;
+	int i;
+
+	tcf_exts_for_each_action(i, act, exts)
+		list_for_each_entry(bind, &act->hw_blocks, list)
+			if (bind->block == block) {
+				list_del(&bind->list);
+				kfree(bind);
+				break;
+			}
+}
+EXPORT_SYMBOL(tc_unbind_action_blocks);
+
 static int __init tc_action_init(void)
 {
 	rtnl_register(PF_UNSPEC, RTM_NEWACTION, tc_ctl_action, NULL, 0);
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f6685fc53119..252d102702bb 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -394,6 +394,8 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
 	cls_flower.cookie = (unsigned long) f;
 
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
+	if (f->in_hw_count)
+		tc_unbind_action_blocks(&f->exts, block);
 	spin_lock(&tp->lock);
 	list_del_init(&f->hw_list);
 	tcf_block_offload_dec(block, &f->flags);
@@ -448,6 +450,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 		goto errout;
 	} else if (err > 0) {
 		f->in_hw_count = err;
+		tc_bind_action_blocks(&f->exts, block);
 		err = 0;
 		spin_lock(&tp->lock);
 		tcf_block_offload_inc(block, &f->flags);
@@ -1789,10 +1792,14 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 			goto next_flow;
 		}
 
+		if (add && !f->in_hw_count)
+			tc_bind_action_blocks(&f->exts, block);
 		spin_lock(&tp->lock);
 		tc_cls_offload_cnt_update(block, &f->in_hw_count, &f->flags,
 					  add);
 		spin_unlock(&tp->lock);
+		if (!add && !f->in_hw_count)
+			tc_unbind_action_blocks(&f->exts, block);
 next_flow:
 		__fl_put(f);
 	}

