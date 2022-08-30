Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BE85A5892
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 02:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiH3AyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 20:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH3AyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 20:54:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8184981B2D;
        Mon, 29 Aug 2022 17:54:12 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MGpfT6JDVznTnY;
        Tue, 30 Aug 2022 08:51:45 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 30 Aug
 2022 08:54:10 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 2/2] net: sched: htb: remove redundant resource cleanup in htb_init()
Date:   Tue, 30 Aug 2022 08:56:38 +0800
Message-ID: <20220830005638.276584-3-shaozhengchao@huawei.com>
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

If htb_init() fails, qdisc_create() invokes htb_destroy() to clear
resources. Therefore, remove redundant resource cleanup in htb_init().

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_htb.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index cb5872d22ecf..da75885bbffd 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1102,7 +1102,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 
 	err = qdisc_class_hash_init(&q->clhash);
 	if (err < 0)
-		goto err_free_direct_qdiscs;
+		return err;
 
 	qdisc_skb_head_init(&q->direct_queue);
 
@@ -1125,8 +1125,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 		qdisc = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
 					  TC_H_MAKE(sch->handle, 0), extack);
 		if (!qdisc) {
-			err = -ENOMEM;
-			goto err_free_qdiscs;
+			return -ENOMEM;
 		}
 
 		htb_set_lockdep_class_child(qdisc);
@@ -1144,7 +1143,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	};
 	err = htb_offload(dev, &offload_opt);
 	if (err)
-		goto err_free_qdiscs;
+		return err;
 
 	/* Defer this assignment, so that htb_destroy skips offload-related
 	 * parts (especially calling ndo_setup_tc) on errors.
@@ -1152,22 +1151,6 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	q->offload = true;
 
 	return 0;
-
-err_free_qdiscs:
-	for (ntx = 0; ntx < q->num_direct_qdiscs && q->direct_qdiscs[ntx];
-	     ntx++)
-		qdisc_put(q->direct_qdiscs[ntx]);
-
-	qdisc_class_hash_destroy(&q->clhash);
-	/* Prevent use-after-free and double-free when htb_destroy gets called.
-	 */
-	q->clhash.hash = NULL;
-	q->clhash.hashsize = 0;
-
-err_free_direct_qdiscs:
-	kfree(q->direct_qdiscs);
-	q->direct_qdiscs = NULL;
-	return err;
 }
 
 static void htb_attach_offload(struct Qdisc *sch)
@@ -1690,13 +1673,12 @@ static void htb_destroy(struct Qdisc *sch)
 	qdisc_class_hash_destroy(&q->clhash);
 	__qdisc_reset_queue(&q->direct_queue);
 
-	if (!q->offload)
-		return;
-
-	offload_opt = (struct tc_htb_qopt_offload) {
-		.command = TC_HTB_DESTROY,
-	};
-	htb_offload(dev, &offload_opt);
+	if (q->offload) {
+		offload_opt = (struct tc_htb_qopt_offload) {
+			.command = TC_HTB_DESTROY,
+		};
+		htb_offload(dev, &offload_opt);
+	}
 
 	if (!q->direct_qdiscs)
 		return;
-- 
2.17.1

