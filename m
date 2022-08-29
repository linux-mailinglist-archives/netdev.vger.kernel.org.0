Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057D95A44BF
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiH2IOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiH2IOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:14:37 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AA351A0B;
        Mon, 29 Aug 2022 01:14:36 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MGNS12zmMzlWWL;
        Mon, 29 Aug 2022 16:11:13 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 29 Aug
 2022 16:14:34 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 2/3] net: sched: gred/red: remove unused variables in struct red_stats
Date:   Mon, 29 Aug 2022 16:17:03 +0800
Message-ID: <20220829081704.255235-3-shaozhengchao@huawei.com>
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

The variable "other" in the struct red_stats is not used. Remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v1: qdisc_drop() already counts drops, unnecessary to use "other" to duplicate the same information.
---
 include/net/red.h              | 1 -
 include/uapi/linux/pkt_sched.h | 2 --
 net/sched/sch_gred.c           | 3 ---
 net/sched/sch_red.c            | 1 -
 4 files changed, 7 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index be11dbd26492..454ac2b65d8c 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -122,7 +122,6 @@ struct red_stats {
 	u32		forced_drop;	/* Forced drops, qavg > max_thresh */
 	u32		forced_mark;	/* Forced marks, qavg > max_thresh */
 	u32		pdrop;          /* Drops due to queue limits */
-	u32		other;          /* Drops due to drop() calls */
 };
 
 struct red_parms {
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 32d49447cc7a..55fadb3ace17 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -296,7 +296,6 @@ struct tc_red_qopt {
 struct tc_red_xstats {
 	__u32           early;          /* Early drops */
 	__u32           pdrop;          /* Drops due to queue limits */
-	__u32           other;          /* Drops due to drop() calls */
 	__u32           marked;         /* Marked packets */
 };
 
@@ -352,7 +351,6 @@ struct tc_gred_qopt {
 	__u32		qave;
 	__u32		forced;
 	__u32		early;
-	__u32		other;
 	__u32		pdrop;
 	__u8		Wlog;         /* log(W)               */
 	__u8		Plog;         /* log(P_max/(qth_max-qth_min)) */
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 1073c76d05c4..e7af53f607bb 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -829,7 +829,6 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 		opt.Wlog	= q->parms.Wlog;
 		opt.Plog	= q->parms.Plog;
 		opt.Scell_log	= q->parms.Scell_log;
-		opt.other	= q->stats.other;
 		opt.early	= q->stats.prob_drop;
 		opt.forced	= q->stats.forced_drop;
 		opt.pdrop	= q->stats.pdrop;
@@ -895,8 +894,6 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 			goto nla_put_failure;
 		if (nla_put_u32(skb, TCA_GRED_VQ_STAT_PDROP, q->stats.pdrop))
 			goto nla_put_failure;
-		if (nla_put_u32(skb, TCA_GRED_VQ_STAT_OTHER, q->stats.other))
-			goto nla_put_failure;
 
 		nla_nest_end(skb, vq);
 	}
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index f1e013e3f04a..f7ac40c0335e 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -461,7 +461,6 @@ static int red_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	}
 	st.early = q->stats.prob_drop + q->stats.forced_drop;
 	st.pdrop = q->stats.pdrop;
-	st.other = q->stats.other;
 	st.marked = q->stats.prob_mark + q->stats.forced_mark;
 
 	return gnet_stats_copy_app(d, &st, sizeof(st));
-- 
2.17.1

