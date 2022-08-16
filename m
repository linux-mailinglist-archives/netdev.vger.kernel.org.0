Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9431E595300
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiHPGvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiHPGum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:50:42 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E1E107AE1;
        Mon, 15 Aug 2022 19:01:26 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M6Dnp2dNfzlWDr;
        Tue, 16 Aug 2022 09:58:22 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 16 Aug
 2022 10:01:23 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,2/3] net: sched: make prio_offload() void
Date:   Tue, 16 Aug 2022 10:04:22 +0800
Message-ID: <20220816020423.323820-3-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220816020423.323820-1-shaozhengchao@huawei.com>
References: <20220816020423.323820-1-shaozhengchao@huawei.com>
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

The return value of function prio_offload is unused, make prio_offload()
void.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_prio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 3b8d7197c06b..a7124c63f700 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -139,7 +139,7 @@ prio_reset(struct Qdisc *sch)
 	sch->q.qlen = 0;
 }
 
-static int prio_offload(struct Qdisc *sch, struct tc_prio_qopt *qopt)
+static void prio_offload(struct Qdisc *sch, struct tc_prio_qopt *qopt)
 {
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_prio_qopt_offload opt = {
@@ -148,7 +148,7 @@ static int prio_offload(struct Qdisc *sch, struct tc_prio_qopt *qopt)
 	};
 
 	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
+		return;
 
 	if (qopt) {
 		opt.command = TC_PRIO_REPLACE;
@@ -160,7 +160,7 @@ static int prio_offload(struct Qdisc *sch, struct tc_prio_qopt *qopt)
 		opt.command = TC_PRIO_DESTROY;
 	}
 
-	return dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_PRIO, &opt);
+	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_PRIO, &opt);
 }
 
 static void
-- 
2.17.1

