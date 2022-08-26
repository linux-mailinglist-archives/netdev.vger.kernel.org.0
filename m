Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248A05A1DF8
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243971AbiHZBKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243864AbiHZBKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:10:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEDC65839;
        Thu, 25 Aug 2022 18:10:12 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MDMBs5skcznTjS;
        Fri, 26 Aug 2022 09:07:49 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 26 Aug
 2022 09:10:10 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <vladbu@mellanox.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: tbf: don't call qdisc_put() while holding tree lock
Date:   Fri, 26 Aug 2022 09:12:48 +0800
Message-ID: <20220826011248.323922-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

The issue is the same to commit c2999f7fb05b ("net: sched: multiq: don't
call qdisc_put() while holding tree lock"). Qdiscs call qdisc_put() while
holding sch tree spinlock, which results sleeping-while-atomic BUG.

Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_tbf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 72102277449e..36079fdde2cb 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -356,6 +356,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	struct nlattr *tb[TCA_TBF_MAX + 1];
 	struct tc_tbf_qopt *qopt;
 	struct Qdisc *child = NULL;
+	struct Qdisc *old = NULL;
 	struct psched_ratecfg rate;
 	struct psched_ratecfg peak;
 	u64 max_size;
@@ -447,7 +448,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	sch_tree_lock(sch);
 	if (child) {
 		qdisc_tree_flush_backlog(q->qdisc);
-		qdisc_put(q->qdisc);
+		old = q->qdisc;
 		q->qdisc = child;
 	}
 	q->limit = qopt->limit;
@@ -467,6 +468,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	memcpy(&q->peak, &peak, sizeof(struct psched_ratecfg));
 
 	sch_tree_unlock(sch);
+	qdisc_put(old);
 	err = 0;
 
 	tbf_offload_change(sch);
-- 
2.17.1

