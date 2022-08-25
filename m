Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719A85A079E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 05:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiHYD1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 23:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbiHYD1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 23:27:08 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA0F5F993;
        Wed, 24 Aug 2022 20:27:06 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MCpGF31QrzlWR7;
        Thu, 25 Aug 2022 11:23:49 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 25 Aug
 2022 11:27:04 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 1/3] net: sched: sch_choke: add statistics when calling qdisc_drop() in sch_choke
Date:   Thu, 25 Aug 2022 11:29:41 +0800
Message-ID: <20220825032943.34778-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220825032943.34778-1-shaozhengchao@huawei.com>
References: <20220825032943.34778-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

Now, the "other" member in the choke_sched_data structure is not used.
According to the description, "other" should be added when calling
qdisc_drop() to discard packets.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_choke.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 2adbd945bf15..19c25ec36d0d 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -60,7 +60,7 @@ struct choke_sched_data {
 		u32	forced_drop;	/* Forced drops, qavg > max_thresh */
 		u32	forced_mark;	/* Forced marks, qavg > max_thresh */
 		u32	pdrop;          /* Drops due to queue limits */
-		u32	other;          /* Drops due to drop() calls */
+		u32	other;          /* Drops due to qdisc_drop() calls */
 		u32	matched;	/* Drops to flow match */
 	} stats;
 
@@ -127,6 +127,7 @@ static void choke_drop_by_idx(struct Qdisc *sch, unsigned int idx,
 	qdisc_qstats_backlog_dec(sch, skb);
 	qdisc_tree_reduce_backlog(sch, 1, qdisc_pkt_len(skb));
 	qdisc_drop(skb, sch, to_free);
+	q->stats.other++;
 	--sch->q.qlen;
 }
 
@@ -274,9 +275,11 @@ static int choke_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	q->stats.pdrop++;
+	q->stats.other++;
 	return qdisc_drop(skb, sch, to_free);
 
 congestion_drop:
+	q->stats.other++;
 	qdisc_drop(skb, sch, to_free);
 	return NET_XMIT_CN;
 }
-- 
2.17.1

