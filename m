Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4E05BB659
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 07:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiIQFA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 01:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiIQFAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 01:00:55 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE2977570;
        Fri, 16 Sep 2022 22:00:53 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MTzHB3lBnzBsPh;
        Sat, 17 Sep 2022 12:58:46 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 17 Sep
 2022 13:00:50 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <cake@lists.bufferbloat.net>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <toke@toke.dk>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 02/18] net/sched: use tc_qdisc_stats_dump() in qdisc
Date:   Sat, 17 Sep 2022 13:02:34 +0800
Message-ID: <20220917050234.127492-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use tc_qdisc_stats_dump() in qdisc.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_atm.c      |  6 +-----
 net/sched/sch_cake.c     |  9 +++------
 net/sched/sch_cbq.c      |  9 +--------
 net/sched/sch_cbs.c      |  8 +-------
 net/sched/sch_drr.c      |  9 +--------
 net/sched/sch_dsmark.c   | 14 +++++---------
 net/sched/sch_ets.c      |  9 +--------
 net/sched/sch_fq_codel.c |  8 ++------
 net/sched/sch_hfsc.c     |  9 +--------
 net/sched/sch_htb.c      |  9 +--------
 net/sched/sch_mq.c       |  5 +----
 net/sched/sch_mqprio.c   |  5 +----
 net/sched/sch_multiq.c   |  9 +--------
 net/sched/sch_netem.c    |  8 ++------
 net/sched/sch_prio.c     |  9 +--------
 net/sched/sch_qfq.c      |  9 +--------
 net/sched/sch_red.c      |  7 +------
 net/sched/sch_sfb.c      |  7 +------
 net/sched/sch_sfq.c      |  8 ++------
 net/sched/sch_skbprio.c  |  9 +--------
 net/sched/sch_taprio.c   |  5 +----
 net/sched/sch_tbf.c      |  7 +------
 22 files changed, 31 insertions(+), 147 deletions(-)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 816fd0d7ba38..b6c45ca60e78 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -354,12 +354,8 @@ static void atm_tc_walk(struct Qdisc *sch, struct qdisc_walker *walker)
 	if (walker->stop)
 		return;
 	list_for_each_entry(flow, &p->flows, list) {
-		if (walker->count >= walker->skip &&
-		    walker->fn(sch, (unsigned long)flow, walker) < 0) {
-			walker->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, walker, (unsigned long)flow))
 			break;
-		}
-		walker->count++;
 	}
 }
 
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 36acc95d611e..cab9ff213d92 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -3061,16 +3061,13 @@ static void cake_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 		struct cake_tin_data *b = &q->tins[q->tin_order[i]];
 
 		for (j = 0; j < CAKE_QUEUES; j++) {
-			if (list_empty(&b->flows[j].flowchain) ||
-			    arg->count < arg->skip) {
+			if (list_empty(&b->flows[j].flowchain)) {
 				arg->count++;
 				continue;
 			}
-			if (arg->fn(sch, i * CAKE_QUEUES + j + 1, arg) < 0) {
-				arg->stop = 1;
+			if (!tc_qdisc_stats_dump(sch, arg,
+						 i * CAKE_QUEUES + j + 1))
 				break;
-			}
-			arg->count++;
 		}
 	}
 }
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index ba99ce05cd52..4897329f9412 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1676,15 +1676,8 @@ static void cbq_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 
 	for (h = 0; h < q->clhash.hashsize; h++) {
 		hlist_for_each_entry(cl, &q->clhash.hash[h], common.hnode) {
-			if (arg->count < arg->skip) {
-				arg->count++;
-				continue;
-			}
-			if (arg->fn(sch, (unsigned long)cl, arg) < 0) {
-				arg->stop = 1;
+			if (!tc_qdisc_stats_dump(sch, arg, (unsigned long)cl))
 				return;
-			}
-			arg->count++;
 		}
 	}
 }
diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 459cc240eda9..270d517e492d 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -520,13 +520,7 @@ static unsigned long cbs_find(struct Qdisc *sch, u32 classid)
 static void cbs_walk(struct Qdisc *sch, struct qdisc_walker *walker)
 {
 	if (!walker->stop) {
-		if (walker->count >= walker->skip) {
-			if (walker->fn(sch, 1, walker) < 0) {
-				walker->stop = 1;
-				return;
-			}
-		}
-		walker->count++;
+		tc_qdisc_stats_dump(sch, walker, 1);
 	}
 }
 
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 4e5b1cf11b85..d75ea3e35fcc 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -284,15 +284,8 @@ static void drr_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
-			if (arg->count < arg->skip) {
-				arg->count++;
-				continue;
-			}
-			if (arg->fn(sch, (unsigned long)cl, arg) < 0) {
-				arg->stop = 1;
+			if (!tc_qdisc_stats_dump(sch, arg, (unsigned long)cl))
 				return;
-			}
-			arg->count++;
 		}
 	}
 }
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 7da6dc38a382..5cf944ab20b6 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -176,16 +176,12 @@ static void dsmark_walk(struct Qdisc *sch, struct qdisc_walker *walker)
 		return;
 
 	for (i = 0; i < p->indices; i++) {
-		if (p->mv[i].mask == 0xff && !p->mv[i].value)
-			goto ignore;
-		if (walker->count >= walker->skip) {
-			if (walker->fn(sch, i + 1, walker) < 0) {
-				walker->stop = 1;
-				break;
-			}
+		if (p->mv[i].mask == 0xff && !p->mv[i].value) {
+			walker->count++;
+			continue;
 		}
-ignore:
-		walker->count++;
+		if (!tc_qdisc_stats_dump(sch, walker, i + 1))
+			break;
 	}
 }
 
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index a3aea22ef09d..7e3b16c342d2 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -341,15 +341,8 @@ static void ets_qdisc_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 		return;
 
 	for (i = 0; i < q->nbands; i++) {
-		if (arg->count < arg->skip) {
-			arg->count++;
-			continue;
-		}
-		if (arg->fn(sch, i + 1, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, arg, i + 1))
 			break;
-		}
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index eeea8c6d54e2..59a60ce5b7ef 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -673,16 +673,12 @@ static void fq_codel_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 		return;
 
 	for (i = 0; i < q->flows_cnt; i++) {
-		if (list_empty(&q->flows[i].flowchain) ||
-		    arg->count < arg->skip) {
+		if (list_empty(&q->flows[i].flowchain)) {
 			arg->count++;
 			continue;
 		}
-		if (arg->fn(sch, i + 1, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, arg, i + 1))
 			break;
-		}
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index c8bef923c79c..815599f94ad9 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1349,15 +1349,8 @@ hfsc_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(cl, &q->clhash.hash[i],
 				     cl_common.hnode) {
-			if (arg->count < arg->skip) {
-				arg->count++;
-				continue;
-			}
-			if (arg->fn(sch, (unsigned long)cl, arg) < 0) {
-				arg->stop = 1;
+			if (!tc_qdisc_stats_dump(sch, arg, (unsigned long)cl))
 				return;
-			}
-			arg->count++;
 		}
 	}
 }
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 78d0c7549c74..e9fee0b5706f 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -2119,15 +2119,8 @@ static void htb_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
-			if (arg->count < arg->skip) {
-				arg->count++;
-				continue;
-			}
-			if (arg->fn(sch, (unsigned long)cl, arg) < 0) {
-				arg->stop = 1;
+			if (!tc_qdisc_stats_dump(sch, arg, (unsigned long)cl))
 				return;
-			}
-			arg->count++;
 		}
 	}
 }
diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index 83d2e54bf303..c544e9d8e79e 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -247,11 +247,8 @@ static void mq_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 
 	arg->count = arg->skip;
 	for (ntx = arg->skip; ntx < dev->num_tx_queues; ntx++) {
-		if (arg->fn(sch, ntx + 1, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, arg, ntx + 1))
 			break;
-		}
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index b29f3453c6ea..55b965dbf3bc 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -558,11 +558,8 @@ static void mqprio_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 	/* Walk hierarchy with a virtual class per tc */
 	arg->count = arg->skip;
 	for (ntx = arg->skip; ntx < netdev_get_num_tc(dev); ntx++) {
-		if (arg->fn(sch, ntx + TC_H_MIN_PRIORITY, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, arg, ntx + TC_H_MIN_PRIORITY))
 			return;
-		}
-		arg->count++;
 	}
 
 	/* Pad the values and skip over unused traffic classes */
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index f28050c7f12d..c8a649a24696 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -353,15 +353,8 @@ static void multiq_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 		return;
 
 	for (band = 0; band < q->bands; band++) {
-		if (arg->count < arg->skip) {
-			arg->count++;
-			continue;
-		}
-		if (arg->fn(sch, band + 1, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, arg, band + 1))
 			break;
-		}
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index b70ac04110dd..5a7f41a61fe2 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1251,12 +1251,8 @@ static unsigned long netem_find(struct Qdisc *sch, u32 classid)
 static void netem_walk(struct Qdisc *sch, struct qdisc_walker *walker)
 {
 	if (!walker->stop) {
-		if (walker->count >= walker->skip)
-			if (walker->fn(sch, 1, walker) < 0) {
-				walker->stop = 1;
-				return;
-			}
-		walker->count++;
+		if (!tc_qdisc_stats_dump(sch, walker, 1))
+			return;
 	}
 }
 
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 298794c04836..6bfabc4ba4b5 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -376,15 +376,8 @@ static void prio_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 		return;
 
 	for (prio = 0; prio < q->bands; prio++) {
-		if (arg->count < arg->skip) {
-			arg->count++;
-			continue;
-		}
-		if (arg->fn(sch, prio + 1, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, arg, prio + 1))
 			break;
-		}
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 13246a9dc5c1..35bb772abbee 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -659,15 +659,8 @@ static void qfq_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
-			if (arg->count < arg->skip) {
-				arg->count++;
-				continue;
-			}
-			if (arg->fn(sch, (unsigned long)cl, arg) < 0) {
-				arg->stop = 1;
+			if (!tc_qdisc_stats_dump(sch, arg, (unsigned long)cl))
 				return;
-			}
-			arg->count++;
 		}
 	}
 }
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 4952406f70b9..99c30542823c 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -516,12 +516,7 @@ static unsigned long red_find(struct Qdisc *sch, u32 classid)
 static void red_walk(struct Qdisc *sch, struct qdisc_walker *walker)
 {
 	if (!walker->stop) {
-		if (walker->count >= walker->skip)
-			if (walker->fn(sch, 1, walker) < 0) {
-				walker->stop = 1;
-				return;
-			}
-		walker->count++;
+		tc_qdisc_stats_dump(sch, walker, 1);
 	}
 }
 
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 1be8d04d69dc..001927b31eab 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -659,12 +659,7 @@ static int sfb_delete(struct Qdisc *sch, unsigned long cl,
 static void sfb_walk(struct Qdisc *sch, struct qdisc_walker *walker)
 {
 	if (!walker->stop) {
-		if (walker->count >= walker->skip)
-			if (walker->fn(sch, 1, walker) < 0) {
-				walker->stop = 1;
-				return;
-			}
-		walker->count++;
+		tc_qdisc_stats_dump(sch, walker, 1);
 	}
 }
 
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index f8e569f79f13..a82d844b02d0 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -888,16 +888,12 @@ static void sfq_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 		return;
 
 	for (i = 0; i < q->divisor; i++) {
-		if (q->ht[i] == SFQ_EMPTY_SLOT ||
-		    arg->count < arg->skip) {
+		if (q->ht[i] == SFQ_EMPTY_SLOT) {
 			arg->count++;
 			continue;
 		}
-		if (arg->fn(sch, i + 1, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, arg, i + 1))
 			break;
-		}
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index df72fb83d9c7..3b2cdd0fa66a 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -265,15 +265,8 @@ static void skbprio_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 		return;
 
 	for (i = 0; i < SKBPRIO_MAX_PRIORITY; i++) {
-		if (arg->count < arg->skip) {
-			arg->count++;
-			continue;
-		}
-		if (arg->fn(sch, i + 1, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, arg, i + 1))
 			break;
-		}
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index db88a692ef81..d98d6a8b271a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2000,11 +2000,8 @@ static void taprio_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 
 	arg->count = arg->skip;
 	for (ntx = arg->skip; ntx < dev->num_tx_queues; ntx++) {
-		if (arg->fn(sch, ntx + 1, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_qdisc_stats_dump(sch, arg, ntx + 1))
 			break;
-		}
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index e031c1a41ea6..e852db4079c4 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -580,12 +580,7 @@ static unsigned long tbf_find(struct Qdisc *sch, u32 classid)
 static void tbf_walk(struct Qdisc *sch, struct qdisc_walker *walker)
 {
 	if (!walker->stop) {
-		if (walker->count >= walker->skip)
-			if (walker->fn(sch, 1, walker) < 0) {
-				walker->stop = 1;
-				return;
-			}
-		walker->count++;
+		tc_qdisc_stats_dump(sch, walker, 1);
 	}
 }
 
-- 
2.17.1

