Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E08759F06B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 02:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiHXAtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 20:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiHXAtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 20:49:51 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F96B73916;
        Tue, 23 Aug 2022 17:49:50 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MC6s450rDzGpkf;
        Wed, 24 Aug 2022 08:48:08 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 24 Aug
 2022 08:49:47 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <vinicius.gomes@intel.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2] net: sched: delete duplicate cleanup of backlog and qlen
Date:   Wed, 24 Aug 2022 08:52:31 +0800
Message-ID: <20220824005231.345727-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qdisc_reset() is clearing qdisc->q.qlen and qdisc->qstats.backlog
_after_ calling qdisc->ops->reset. There is no need to clear them
again in the specific reset function.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v1: changelog is slightly inaccurate.
---
 include/net/sch_generic.h | 1 -
 net/sched/sch_atm.c       | 1 -
 net/sched/sch_cbq.c       | 1 -
 net/sched/sch_choke.c     | 2 --
 net/sched/sch_drr.c       | 2 --
 net/sched/sch_dsmark.c    | 2 --
 net/sched/sch_etf.c       | 3 ---
 net/sched/sch_ets.c       | 2 --
 net/sched/sch_fq_codel.c  | 2 --
 net/sched/sch_fq_pie.c    | 3 ---
 net/sched/sch_hfsc.c      | 2 --
 net/sched/sch_htb.c       | 2 --
 net/sched/sch_multiq.c    | 1 -
 net/sched/sch_prio.c      | 2 --
 net/sched/sch_qfq.c       | 2 --
 net/sched/sch_red.c       | 2 --
 net/sched/sch_sfb.c       | 2 --
 net/sched/sch_skbprio.c   | 3 ---
 net/sched/sch_taprio.c    | 2 --
 net/sched/sch_tbf.c       | 2 --
 net/sched/sch_teql.c      | 1 -
 21 files changed, 40 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index ec693fe7c553..f2958fb5ae08 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1137,7 +1137,6 @@ static inline void __qdisc_reset_queue(struct qdisc_skb_head *qh)
 static inline void qdisc_reset_queue(struct Qdisc *sch)
 {
 	__qdisc_reset_queue(&sch->q);
-	sch->qstats.backlog = 0;
 }
 
 static inline struct Qdisc *qdisc_replace(struct Qdisc *sch, struct Qdisc *new,
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 4c8e994cf0a5..816fd0d7ba38 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -577,7 +577,6 @@ static void atm_tc_reset(struct Qdisc *sch)
 	pr_debug("atm_tc_reset(sch %p,[qdisc %p])\n", sch, p);
 	list_for_each_entry(flow, &p->flows, list)
 		qdisc_reset(flow->q);
-	sch->q.qlen = 0;
 }
 
 static void atm_tc_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 91a0dc463c48..ba99ce05cd52 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -975,7 +975,6 @@ cbq_reset(struct Qdisc *sch)
 			cl->cpriority = cl->priority;
 		}
 	}
-	sch->q.qlen = 0;
 }
 
 
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 2adbd945bf15..25d2daaa8122 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -315,8 +315,6 @@ static void choke_reset(struct Qdisc *sch)
 		rtnl_qdisc_drop(skb, sch);
 	}
 
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	if (q->tab)
 		memset(q->tab, 0, (q->tab_mask + 1) * sizeof(struct sk_buff *));
 	q->head = q->tail = 0;
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 18e4f7a0b291..4e5b1cf11b85 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -441,8 +441,6 @@ static void drr_reset_qdisc(struct Qdisc *sch)
 			qdisc_reset(cl->qdisc);
 		}
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void drr_destroy_qdisc(struct Qdisc *sch)
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 4c100d105269..7da6dc38a382 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -409,8 +409,6 @@ static void dsmark_reset(struct Qdisc *sch)
 	pr_debug("%s(sch %p,[qdisc %p])\n", __func__, sch, p);
 	if (p->q)
 		qdisc_reset(p->q);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void dsmark_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index c48f91075b5c..d96103b0e2bf 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -445,9 +445,6 @@ static void etf_reset(struct Qdisc *sch)
 	timesortedlist_clear(sch);
 	__qdisc_reset_queue(&sch->q);
 
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
-
 	q->last = 0;
 }
 
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index d73393493553..8de4365886e8 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -727,8 +727,6 @@ static void ets_qdisc_reset(struct Qdisc *sch)
 	}
 	for (band = 0; band < q->nbands; band++)
 		qdisc_reset(q->classes[band].qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void ets_qdisc_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 839e1235db05..23a042adb74d 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -347,8 +347,6 @@ static void fq_codel_reset(struct Qdisc *sch)
 		codel_vars_init(&flow->cvars);
 	}
 	memset(q->backlogs, 0, q->flows_cnt * sizeof(u32));
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	q->memory_usage = 0;
 }
 
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index d6aba6edd16e..35c35465226b 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -521,9 +521,6 @@ static void fq_pie_reset(struct Qdisc *sch)
 		INIT_LIST_HEAD(&flow->flowchain);
 		pie_vars_init(&flow->vars);
 	}
-
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 }
 
 static void fq_pie_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index d3979a6000e7..03efc40e42fc 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1484,8 +1484,6 @@ hfsc_reset_qdisc(struct Qdisc *sch)
 	}
 	q->eligible = RB_ROOT;
 	qdisc_watchdog_cancel(&q->watchdog);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 23a9d6242429..cb5872d22ecf 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1008,8 +1008,6 @@ static void htb_reset(struct Qdisc *sch)
 	}
 	qdisc_watchdog_cancel(&q->watchdog);
 	__qdisc_reset_queue(&q->direct_queue);
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	memset(q->hlevel, 0, sizeof(q->hlevel));
 	memset(q->row_mask, 0, sizeof(q->row_mask));
 }
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index cd8ab90c4765..f28050c7f12d 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -152,7 +152,6 @@ multiq_reset(struct Qdisc *sch)
 
 	for (band = 0; band < q->bands; band++)
 		qdisc_reset(q->queues[band]);
-	sch->q.qlen = 0;
 	q->curband = 0;
 }
 
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 3b8d7197c06b..c03a11dd990f 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -135,8 +135,6 @@ prio_reset(struct Qdisc *sch)
 
 	for (prio = 0; prio < q->bands; prio++)
 		qdisc_reset(q->queues[prio]);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static int prio_offload(struct Qdisc *sch, struct tc_prio_qopt *qopt)
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index d4ce58c90f9f..13246a9dc5c1 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1458,8 +1458,6 @@ static void qfq_reset_qdisc(struct Qdisc *sch)
 			qdisc_reset(cl->qdisc);
 		}
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void qfq_destroy_qdisc(struct Qdisc *sch)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 40adf1f07a82..f1e013e3f04a 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -176,8 +176,6 @@ static void red_reset(struct Qdisc *sch)
 	struct red_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	red_restart(&q->vars);
 }
 
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 3d061a13d7ed..31717fa45a4f 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -453,8 +453,6 @@ static void sfb_reset(struct Qdisc *sch)
 	struct sfb_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	q->slot = 0;
 	q->double_buffering = false;
 	sfb_zero_all_buckets(q);
diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index 7a5e4c454715..df72fb83d9c7 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -213,9 +213,6 @@ static void skbprio_reset(struct Qdisc *sch)
 	struct skbprio_sched_data *q = qdisc_priv(sch);
 	int prio;
 
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
-
 	for (prio = 0; prio < SKBPRIO_MAX_PRIORITY; prio++)
 		__skb_queue_purge(&q->qdiscs[prio]);
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 0b941dd63d26..db88a692ef81 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1636,8 +1636,6 @@ static void taprio_reset(struct Qdisc *sch)
 			if (q->qdiscs[i])
 				qdisc_reset(q->qdiscs[i]);
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void taprio_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 72102277449e..d0288e223542 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -330,8 +330,6 @@ static void tbf_reset(struct Qdisc *sch)
 	struct tbf_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	q->t_c = ktime_get_ns();
 	q->tokens = q->buffer;
 	q->ptokens = q->mtu;
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 6af6b95bdb67..79aaab51cbf5 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -124,7 +124,6 @@ teql_reset(struct Qdisc *sch)
 	struct teql_sched_data *dat = qdisc_priv(sch);
 
 	skb_queue_purge(&dat->q);
-	sch->q.qlen = 0;
 }
 
 static void
-- 
2.17.1

