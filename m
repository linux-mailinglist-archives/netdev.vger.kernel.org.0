Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CE5572B12
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiGMBuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiGMBuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:50:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7331430F5F;
        Tue, 12 Jul 2022 18:50:12 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LjL940v1GzhYp8;
        Wed, 13 Jul 2022 09:47:36 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Jul
 2022 09:50:10 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH v3,net-next] net/sched: remove return value of unregister_tcf_proto_ops
Date:   Wed, 13 Jul 2022 09:54:38 +0800
Message-ID: <20220713015438.87005-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
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

Return value of unregister_tcf_proto_ops is unused, remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/pkt_cls.h | 2 +-
 net/sched/cls_api.c   | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

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
index 9bb4d3dcc994..c7a240232b8d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -194,7 +194,7 @@ EXPORT_SYMBOL(register_tcf_proto_ops);
 
 static struct workqueue_struct *tc_filter_wq;
 
-int unregister_tcf_proto_ops(struct tcf_proto_ops *ops)
+void unregister_tcf_proto_ops(struct tcf_proto_ops *ops)
 {
 	struct tcf_proto_ops *t;
 	int rc = -ENOENT;
@@ -214,7 +214,8 @@ int unregister_tcf_proto_ops(struct tcf_proto_ops *ops)
 		}
 	}
 	write_unlock(&cls_mod_lock);
-	return rc;
+
+	WARN(rc, "unregister tc filter kind(%s) failed %d\n", ops->kind, rc);
 }
 EXPORT_SYMBOL(unregister_tcf_proto_ops);
 
-- 
2.17.1

