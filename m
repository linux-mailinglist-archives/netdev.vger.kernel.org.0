Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCE55A5890
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 02:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiH3AyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 20:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH3AyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 20:54:12 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B7980EAF;
        Mon, 29 Aug 2022 17:54:12 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MGpfT1sTzznTsk;
        Tue, 30 Aug 2022 08:51:45 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 30 Aug
 2022 08:54:09 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 1/2] net: sched: fq_codel: remove redundant resource cleanup in fq_codel_init()
Date:   Tue, 30 Aug 2022 08:56:37 +0800
Message-ID: <20220830005638.276584-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220830005638.276584-1-shaozhengchao@huawei.com>
References: <20220830005638.276584-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

If fq_codel_init() fails, qdisc_create() invokes fq_codel_destroy() to
clear resources. Therefore, remove redundant resource cleanup in
fq_codel_init().

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_fq_codel.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 23a042adb74d..90abbca5aeb0 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -481,25 +481,23 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 	if (opt) {
 		err = fq_codel_change(sch, opt, extack);
 		if (err)
-			goto init_failure;
+			return err;
 	}
 
 	err = tcf_block_get(&q->block, &q->filter_list, sch, extack);
 	if (err)
-		goto init_failure;
+		return err;
 
 	if (!q->flows) {
 		q->flows = kvcalloc(q->flows_cnt,
 				    sizeof(struct fq_codel_flow),
 				    GFP_KERNEL);
 		if (!q->flows) {
-			err = -ENOMEM;
-			goto init_failure;
+			return -ENOMEM;
 		}
 		q->backlogs = kvcalloc(q->flows_cnt, sizeof(u32), GFP_KERNEL);
 		if (!q->backlogs) {
-			err = -ENOMEM;
-			goto alloc_failure;
+			return -ENOMEM;
 		}
 		for (i = 0; i < q->flows_cnt; i++) {
 			struct fq_codel_flow *flow = q->flows + i;
@@ -513,13 +511,6 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 	else
 		sch->flags &= ~TCQ_F_CAN_BYPASS;
 	return 0;
-
-alloc_failure:
-	kvfree(q->flows);
-	q->flows = NULL;
-init_failure:
-	q->flows_cnt = 0;
-	return err;
 }
 
 static int fq_codel_dump(struct Qdisc *sch, struct sk_buff *skb)
-- 
2.17.1

