Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB165A44BA
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiH2IOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiH2IOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:14:36 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8D754CA7;
        Mon, 29 Aug 2022 01:14:35 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MGNS05x7QzlWXK;
        Mon, 29 Aug 2022 16:11:12 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 29 Aug
 2022 16:14:33 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 1/3] net: sched: choke: remove unused variables in struct choke_sched_data
Date:   Mon, 29 Aug 2022 16:17:02 +0800
Message-ID: <20220829081704.255235-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220829081704.255235-1-shaozhengchao@huawei.com>
References: <20220829081704.255235-1-shaozhengchao@huawei.com>
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

The variable "other" in the struct choke_sched_data is not used. Remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v1: qdisc_drop() already counts drops, unnecessary to use "other" to duplicate the same information.
---
 include/uapi/linux/pkt_sched.h | 1 -
 net/sched/sch_choke.c          | 2 --
 2 files changed, 3 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index f292b467b27f..32d49447cc7a 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -396,7 +396,6 @@ struct tc_choke_qopt {
 struct tc_choke_xstats {
 	__u32		early;          /* Early drops */
 	__u32		pdrop;          /* Drops due to queue limits */
-	__u32		other;          /* Drops due to drop() calls */
 	__u32		marked;         /* Marked packets */
 	__u32		matched;	/* Drops due to flow match */
 };
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 25d2daaa8122..3ac3e5c80b6f 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -60,7 +60,6 @@ struct choke_sched_data {
 		u32	forced_drop;	/* Forced drops, qavg > max_thresh */
 		u32	forced_mark;	/* Forced marks, qavg > max_thresh */
 		u32	pdrop;          /* Drops due to queue limits */
-		u32	other;          /* Drops due to drop() calls */
 		u32	matched;	/* Drops to flow match */
 	} stats;
 
@@ -464,7 +463,6 @@ static int choke_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 		.early	= q->stats.prob_drop + q->stats.forced_drop,
 		.marked	= q->stats.prob_mark + q->stats.forced_mark,
 		.pdrop	= q->stats.pdrop,
-		.other	= q->stats.other,
 		.matched = q->stats.matched,
 	};
 
-- 
2.17.1

