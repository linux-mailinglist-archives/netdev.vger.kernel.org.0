Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63FD608C5E
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 13:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiJVLMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 07:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiJVLMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 07:12:31 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47F630DDF8
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 03:33:10 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mvcyy6nt7zpVdt;
        Sat, 22 Oct 2022 18:29:46 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 22 Oct
 2022 18:33:08 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <kaber@trash.net>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net] net: sched: cbq: stop timer in cbq_destroy() when cbq_init() fails
Date:   Sat, 22 Oct 2022 18:40:54 +0800
Message-ID: <20221022104054.221968-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When qdisc_create() fails to invoke the cbq_init() function for
initialization, the timer has been started. But cbq_destroy() doesn't
stop the timer. Fix it.

Fixes: 88a993540a65 ("[NET_SCHED]: sch_cbq: use hrtimer based watchdog")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_cbq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 6568e17c4c63..8fcdd74af4cc 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1371,6 +1371,7 @@ static void cbq_destroy(struct Qdisc *sch)
 #ifdef CONFIG_NET_CLS_ACT
 	q->rx_class = NULL;
 #endif
+	qdisc_watchdog_cancel(&q->watchdog);
 	/*
 	 * Filters must be destroyed first because we don't destroy the
 	 * classes from root to leafs which means that filters can still
-- 
2.17.1

