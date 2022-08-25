Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E729E5A079F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 05:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiHYD1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 23:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiHYD1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 23:27:09 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C875FAC3;
        Wed, 24 Aug 2022 20:27:07 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MCpFy5RffzkWKT;
        Thu, 25 Aug 2022 11:23:34 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 25 Aug
 2022 11:27:05 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 3/3] net: sched: sch_red: add statistics when calling qdisc_drop() in sch_red
Date:   Thu, 25 Aug 2022 11:29:43 +0800
Message-ID: <20220825032943.34778-4-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220825032943.34778-1-shaozhengchao@huawei.com>
References: <20220825032943.34778-1-shaozhengchao@huawei.com>
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

Now, the "other" member in the red_sched_data structure is not used.
According to the description, "other" should be added when calling
qdisc_drop() to discard packets.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_red.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 40adf1f07a82..cdf9d8611e41 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -141,6 +141,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (!skb)
 		return NET_XMIT_CN | ret;
 
+	q->stats.other++;
 	qdisc_drop(skb, sch, to_free);
 	return NET_XMIT_CN;
 }
-- 
2.17.1

