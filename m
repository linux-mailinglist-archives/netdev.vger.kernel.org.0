Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7889E2FB8FD
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395173AbhASOKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 09:10:14 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40514 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393785AbhASNJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 08:09:16 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maximmi@mellanox.com)
        with SMTP; 19 Jan 2021 14:08:15 +0200
Received: from dev-l-vrt-208.mtl.labs.mlnx (dev-l-vrt-208.mtl.labs.mlnx [10.234.208.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10JC8FR5021916;
        Tue, 19 Jan 2021 14:08:15 +0200
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 4/5] sch_htb: Stats for offloaded HTB
Date:   Tue, 19 Jan 2021 14:08:14 +0200
Message-Id: <20210119120815.463334-5-maximmi@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119120815.463334-1-maximmi@mellanox.com>
References: <20210119120815.463334-1-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for statistics of offloaded HTB. Bytes and
packets counters for leaf and inner nodes are supported, the values are
taken from per-queue qdiscs, and the numbers that the user sees should
have the same behavior as the software (non-offloaded) HTB.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/sched/sch_htb.c | 53 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index d1b60fe3d311..dff3adf5a915 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -114,6 +114,7 @@ struct htb_class {
 	 * Written often fields
 	 */
 	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_packed bstats_bias;
 	struct tc_htb_xstats	xstats;	/* our special stats */
 
 	/* token bucket parameters */
@@ -1220,6 +1221,7 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 			  struct sk_buff *skb, struct tcmsg *tcm)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
+	struct htb_sched *q = qdisc_priv(sch);
 	struct nlattr *nest;
 	struct tc_htb_opt opt;
 
@@ -1246,6 +1248,8 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 	opt.level = cl->level;
 	if (nla_put(skb, TCA_HTB_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
+	if (q->offload && nla_put_flag(skb, TCA_HTB_OFFLOAD))
+		goto nla_put_failure;
 	if ((cl->rate.rate_bytes_ps >= (1ULL << 32)) &&
 	    nla_put_u64_64bit(skb, TCA_HTB_RATE64, cl->rate.rate_bytes_ps,
 			      TCA_HTB_PAD))
@@ -1262,10 +1266,39 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 	return -1;
 }
 
+static void htb_offload_aggregate_stats(struct htb_sched *q,
+					struct htb_class *cl)
+{
+	struct htb_class *c;
+	unsigned int i;
+
+	memset(&cl->bstats, 0, sizeof(cl->bstats));
+
+	for (i = 0; i < q->clhash.hashsize; i++) {
+		hlist_for_each_entry(c, &q->clhash.hash[i], common.hnode) {
+			struct htb_class *p = c;
+
+			while (p && p->level < cl->level)
+				p = p->parent;
+
+			if (p != cl)
+				continue;
+
+			cl->bstats.bytes += c->bstats_bias.bytes;
+			cl->bstats.packets += c->bstats_bias.packets;
+			if (c->level == 0) {
+				cl->bstats.bytes += c->leaf.q->bstats.bytes;
+				cl->bstats.packets += c->leaf.q->bstats.packets;
+			}
+		}
+	}
+}
+
 static int
 htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
+	struct htb_sched *q = qdisc_priv(sch);
 	struct gnet_stats_queue qs = {
 		.drops = cl->drops,
 		.overlimits = cl->overlimits,
@@ -1280,6 +1313,19 @@ htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
 	cl->xstats.ctokens = clamp_t(s64, PSCHED_NS2TICKS(cl->ctokens),
 				     INT_MIN, INT_MAX);
 
+	if (q->offload) {
+		if (!cl->level) {
+			if (cl->leaf.q)
+				cl->bstats = cl->leaf.q->bstats;
+			else
+				memset(&cl->bstats, 0, sizeof(cl->bstats));
+			cl->bstats.bytes += cl->bstats_bias.bytes;
+			cl->bstats.packets += cl->bstats_bias.packets;
+		} else {
+			htb_offload_aggregate_stats(q, cl);
+		}
+	}
+
 	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
 				  d, NULL, &cl->bstats) < 0 ||
 	    gnet_stats_copy_rate_est(d, &cl->rate_est) < 0 ||
@@ -1464,6 +1510,11 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 		WARN_ON(old != q);
 	}
 
+	if (cl->parent) {
+		cl->parent->bstats_bias.bytes += q->bstats.bytes;
+		cl->parent->bstats_bias.packets += q->bstats.packets;
+	}
+
 	offload_opt = (struct tc_htb_qopt_offload) {
 		.command = !last_child ? TC_HTB_LEAF_DEL :
 			   destroying ? TC_HTB_LEAF_DEL_LAST_FORCE :
@@ -1803,6 +1854,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 				htb_graft_helper(dev_queue, old_q);
 				goto err_kill_estimator;
 			}
+			parent->bstats_bias.bytes += old_q->bstats.bytes;
+			parent->bstats_bias.packets += old_q->bstats.packets;
 			qdisc_put(old_q);
 		}
 		new_q = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
-- 
2.25.1

