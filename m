Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB08565594
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbiGDMig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbiGDMic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:38:32 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84991115B;
        Mon,  4 Jul 2022 05:38:31 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lc4zz10SJzkWpq;
        Mon,  4 Jul 2022 20:36:31 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 4 Jul
 2022 20:38:29 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net/sched: remove return value of unregister_tcf_proto_ops
Date:   Mon, 4 Jul 2022 20:43:22 +0800
Message-ID: <20220704124322.355211-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
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

Return value of unregister_tcf_proto_ops is useless, remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/pkt_cls.h | 2 +-
 net/sched/cls_api.c   | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 8cf001aed858..d9d90e6925e1 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -23,7 +23,7 @@ struct tcf_walker {
 };
 
 int register_tcf_proto_ops(struct tcf_proto_ops *ops);
-int unregister_tcf_proto_ops(struct tcf_proto_ops *ops);
+void unregister_tcf_proto_ops(struct tcf_proto_ops *ops);
 
 struct tcf_block_ext_info {
 	enum flow_block_binder_type binder_type;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9bb4d3dcc994..fdc9acbd56df 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -194,10 +194,9 @@ EXPORT_SYMBOL(register_tcf_proto_ops);
 
 static struct workqueue_struct *tc_filter_wq;
 
-int unregister_tcf_proto_ops(struct tcf_proto_ops *ops)
+void unregister_tcf_proto_ops(struct tcf_proto_ops *ops)
 {
 	struct tcf_proto_ops *t;
-	int rc = -ENOENT;
 
 	/* Wait for outstanding call_rcu()s, if any, from a
 	 * tcf_proto_ops's destroy() handler.
@@ -209,12 +208,11 @@ int unregister_tcf_proto_ops(struct tcf_proto_ops *ops)
 	list_for_each_entry(t, &tcf_proto_base, head) {
 		if (t == ops) {
 			list_del(&t->head);
-			rc = 0;
 			break;
 		}
 	}
 	write_unlock(&cls_mod_lock);
-	return rc;
+	return;
 }
 EXPORT_SYMBOL(unregister_tcf_proto_ops);
 
-- 
2.17.1

