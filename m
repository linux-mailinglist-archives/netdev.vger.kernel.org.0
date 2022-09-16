Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BC55BA4E5
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiIPDEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIPDEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:04:07 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2BC98D21;
        Thu, 15 Sep 2022 20:04:05 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MTJkv63pczBsN3;
        Fri, 16 Sep 2022 11:01:59 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 11:04:03 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <cake@lists.bufferbloat.net>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <toke@toke.dk>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next 01/18] net/sched: sch_api: add helper for tc qdisc walker stats dump
Date:   Fri, 16 Sep 2022 11:05:27 +0800
Message-ID: <20220916030544.228274-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220916030544.228274-1-shaozhengchao@huawei.com>
References: <20220916030544.228274-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The walk implementation of most qdisc class modules is basically the
same. That is, the values of count and skip are checked first. If
count is greater than or equal to skip, the registered fn function is
executed. Otherwise, increase the value of count. So we can reconstruct
them.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/pkt_sched.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 29f65632ebc5..243e8b0cb7ea 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -222,4 +222,17 @@ static inline struct tc_skb_cb *tc_skb_cb(const struct sk_buff *skb)
 	return cb;
 }
 
+static inline bool tc_qdisc_stats_dump(struct Qdisc *sch,
+				       struct qdisc_walker *arg,
+				       unsigned long cl)
+{
+	if (arg->count >= arg->skip && arg->fn(sch, cl, arg) < 0) {
+		arg->stop = 1;
+		return false;
+	}
+
+	arg->count++;
+	return true;
+}
+
 #endif
-- 
2.17.1

