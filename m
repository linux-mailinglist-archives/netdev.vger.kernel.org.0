Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAC25927F8
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 05:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiHODF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 23:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHODF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 23:05:57 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C44EE07;
        Sun, 14 Aug 2022 20:05:55 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M5fG71fP1z1M8xs;
        Mon, 15 Aug 2022 11:02:23 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 15 Aug
 2022 11:05:40 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <bigeasy@linutronix.de>, <a.darwish@linutronix.de>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: fix misuse of qcpu->backlog in gnet_stats_add_queue_cpu
Date:   Mon, 15 Aug 2022 11:08:48 +0800
Message-ID: <20220815030848.276746-1-shaozhengchao@huawei.com>
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

In the gnet_stats_add_queue_cpu function, the qstats->qlen statistics
are incorrectly set to qcpu->backlog.

Fixes: 448e163f8b9b("gen_stats: Add gnet_stats_add_queue()")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/core/gen_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index a10335b4ba2d..c8d137ef5980 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -345,7 +345,7 @@ static void gnet_stats_add_queue_cpu(struct gnet_stats_queue *qstats,
 	for_each_possible_cpu(i) {
 		const struct gnet_stats_queue *qcpu = per_cpu_ptr(q, i);
 
-		qstats->qlen += qcpu->backlog;
+		qstats->qlen += qcpu->qlen;
 		qstats->backlog += qcpu->backlog;
 		qstats->drops += qcpu->drops;
 		qstats->requeues += qcpu->requeues;
-- 
2.17.1

