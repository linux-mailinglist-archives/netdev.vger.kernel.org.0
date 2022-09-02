Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032655AAA08
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbiIBIcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiIBIcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:32:14 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0DEC0E71;
        Fri,  2 Sep 2022 01:32:13 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MJrhG1my7zHncy;
        Fri,  2 Sep 2022 16:30:22 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 16:32:11 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 2/2] net: sched: htb: remove redundant resource cleanup in htb_init()
Date:   Fri, 2 Sep 2022 16:34:30 +0800
Message-ID: <20220902083430.24378-3-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220902083430.24378-1-shaozhengchao@huawei.com>
References: <20220902083430.24378-1-shaozhengchao@huawei.com>
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

If htb_init() fails, qdisc_create() invokes htb_destroy() to clear
resources. Therefore, remove redundant resource cleanup in htb_init().

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v1: rebase
---
 net/sched/sch_htb.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index dbbb276aecb3..78d0c7549c74 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1102,7 +1102,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 
 	err = qdisc_class_hash_init(&q->clhash);
 	if (err < 0)
-		goto err_free_direct_qdiscs;
+		return err;
 
 	if (tb[TCA_HTB_DIRECT_QLEN])
 		q->direct_qlen = nla_get_u32(tb[TCA_HTB_DIRECT_QLEN]);
@@ -1123,8 +1123,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 		qdisc = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
 					  TC_H_MAKE(sch->handle, 0), extack);
 		if (!qdisc) {
-			err = -ENOMEM;
-			goto err_free_qdiscs;
+			return -ENOMEM;
 		}
 
 		htb_set_lockdep_class_child(qdisc);
@@ -1142,7 +1141,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	};
 	err = htb_offload(dev, &offload_opt);
 	if (err)
-		goto err_free_qdiscs;
+		return err;
 
 	/* Defer this assignment, so that htb_destroy skips offload-related
 	 * parts (especially calling ndo_setup_tc) on errors.
@@ -1150,22 +1149,6 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1688,13 +1671,12 @@ static void htb_destroy(struct Qdisc *sch)
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

