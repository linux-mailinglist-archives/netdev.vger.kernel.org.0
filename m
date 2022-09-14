Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589AF5B85C9
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiINKAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiINKAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:00:41 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A9C659D6;
        Wed, 14 Sep 2022 03:00:41 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MSG2K69Csz14QNB;
        Wed, 14 Sep 2022 17:56:41 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 18:00:38 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 1/9] net/sched: cls_api: add helper for tc cls walker stats updating
Date:   Wed, 14 Sep 2022 18:02:13 +0800
Message-ID: <20220914100221.386855-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220914100221.386855-1-shaozhengchao@huawei.com>
References: <20220914100221.386855-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

The walk implementation of most tc cls modules is basically the same.
That is, the values of count and skip are checked first. If count is
greater than or equal to skip, the registered fn function is executed.
Otherwise, increase the value of count. So we can reconstruct them.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/pkt_cls.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d9d90e6925e1..d3cbbabf7592 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -81,6 +81,19 @@ int tcf_classify(struct sk_buff *skb,
 		 const struct tcf_proto *tp, struct tcf_result *res,
 		 bool compat_mode);
 
+static inline bool tc_cls_stats_update(struct tcf_proto *tp,
+				       struct tcf_walker *arg,
+				       void *filter)
+{
+	if (arg->count >= arg->skip && arg->fn(tp, filter, arg) < 0) {
+		arg->stop = 1;
+		return false;
+	}
+
+	arg->count++;
+	return true;
+}
+
 #else
 static inline bool tcf_block_shared(struct tcf_block *block)
 {
-- 
2.17.1

