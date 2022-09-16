Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878AA5BA8A6
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 10:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiIPIu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 04:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIPIu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 04:50:27 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF809C2FC;
        Fri, 16 Sep 2022 01:50:26 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MTSNH63wQz14QPq;
        Fri, 16 Sep 2022 16:46:23 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 16:50:23 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [RFC PATCH net-next 1/2] net: sched: act_api: add helper macro for tcf_action in module and net init/exit
Date:   Fri, 16 Sep 2022 16:51:54 +0800
Message-ID: <20220916085155.33750-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220916085155.33750-1-shaozhengchao@huawei.com>
References: <20220916085155.33750-1-shaozhengchao@huawei.com>
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

Helper macro for tcf_action that don't do anything special in module
and net init/exit. This eliminates a lot of boilerplate. Each module
may only use this macro once, and calling it replaces module/net_init()
and module/net_exit().

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/act_api.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 61f2ceb3939e..dac8c6475efc 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -292,5 +292,31 @@ static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
 #endif
 }
 
+#define module_net_tcf_action(__mod, __act_ops) \
+static __net_init int __mod##_init_net(struct net *net) \
+{ \
+	struct tc_action_net *tn = net_generic(net, __act_ops.net_id);\
+	return tc_action_net_init(net, tn, &__act_ops);\
+} \
+static void __net_exit __mod##_exit_net(struct list_head *net_list) \
+{ \
+	tc_action_net_exit(net_list, __act_ops.net_id); \
+} \
+static struct pernet_operations __mod##_net_ops = { \
+	.init = __mod##_init_net, \
+	.exit_batch = __mod##_exit_net, \
+	.id   = &__act_ops.net_id, \
+	.size = sizeof(struct tc_action_net), \
+}; \
+static int __init __mod##_init_module(void) \
+{ \
+	return tcf_register_action(&__act_ops, &(__mod##_net_ops)); \
+} \
+module_init(__mod##_init_module); \
+static void __exit __mod##_cleanup_module(void) \
+{ \
+	tcf_unregister_action(&__act_ops, &(__mod##_net_ops)); \
+} \
+module_exit(__mod##_cleanup_module)
 
 #endif
-- 
2.17.1

