Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12545A07A1
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 05:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiHYD1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 23:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbiHYD1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 23:27:08 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAD05F997;
        Wed, 24 Aug 2022 20:27:06 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MCpGG0ZvwzlWCq;
        Thu, 25 Aug 2022 11:23:50 +0800 (CST)
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
Subject: [PATCH net-next 2/3] net: sched: sch_gred: add statistics when calling qdisc_drop() in sch_gred
Date:   Thu, 25 Aug 2022 11:29:42 +0800
Message-ID: <20220825032943.34778-3-shaozhengchao@huawei.com>
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

Now, the "other" member in the gred_sched_data structure is not used.
According to the description, "other" should be added when calling
qdisc_drop() to discard packets.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/red.h    | 2 +-
 net/sched/sch_gred.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/red.h b/include/net/red.h
index 30c6a23ab8cc..dad41eff8c62 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -122,7 +122,7 @@ struct red_stats {
 	u32		forced_drop;	/* Forced drops, qavg > max_thresh */
 	u32		forced_mark;	/* Forced marks, qavg > max_thresh */
 	u32		pdrop;          /* Drops due to queue limits */
-	u32		other;          /* Drops due to drop() calls */
+	u32		other;          /* Drops due to qdisc_drop() calls */
 };
 
 struct red_parms {
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 1073c76d05c4..c50a0853dcb9 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -251,9 +251,11 @@ static int gred_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	q->stats.pdrop++;
 drop:
+	q->stats.other++;
 	return qdisc_drop(skb, sch, to_free);
 
 congestion_drop:
+	q->stats.other++;
 	qdisc_drop(skb, sch, to_free);
 	return NET_XMIT_CN;
 }
-- 
2.17.1

