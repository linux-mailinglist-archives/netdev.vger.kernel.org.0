Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3F959F5E5
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiHXJHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbiHXJHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:07:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBC37647E;
        Wed, 24 Aug 2022 02:07:22 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MCKs21WJ9zkWPl;
        Wed, 24 Aug 2022 17:03:50 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 24 Aug
 2022 17:07:19 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: remove unnecessary init of qidsc skb head
Date:   Wed, 24 Aug 2022 17:10:03 +0800
Message-ID: <20220824091003.15935-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

The memory allocated by using kzallloc_node and kcalloc has been cleared.
Therefore, the structure members of the new qdisc are 0. So there's no
need to explicitly assign a value of 0.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/sch_generic.h | 7 -------
 net/sched/sch_generic.c   | 1 -
 net/sched/sch_htb.c       | 2 --
 3 files changed, 10 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index ec693fe7c553..dcdb8474ed68 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -940,13 +940,6 @@ static inline void qdisc_purge_queue(struct Qdisc *sch)
 	qdisc_tree_reduce_backlog(sch, qlen, backlog);
 }
 
-static inline void qdisc_skb_head_init(struct qdisc_skb_head *qh)
-{
-	qh->head = NULL;
-	qh->tail = NULL;
-	qh->qlen = 0;
-}
-
 static inline void __qdisc_enqueue_tail(struct sk_buff *skb,
 					struct qdisc_skb_head *qh)
 {
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d47b9689eba6..0c0f20f7b9f5 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -941,7 +941,6 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 		goto errout;
 	__skb_queue_head_init(&sch->gso_skb);
 	__skb_queue_head_init(&sch->skb_bad_txq);
-	qdisc_skb_head_init(&sch->q);
 	gnet_stats_basic_sync_init(&sch->bstats);
 	spin_lock_init(&sch->q.lock);
 
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 23a9d6242429..f43414e42ad5 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1106,8 +1106,6 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		goto err_free_direct_qdiscs;
 
-	qdisc_skb_head_init(&q->direct_queue);
-
 	if (tb[TCA_HTB_DIRECT_QLEN])
 		q->direct_qlen = nla_get_u32(tb[TCA_HTB_DIRECT_QLEN]);
 	else
-- 
2.17.1

