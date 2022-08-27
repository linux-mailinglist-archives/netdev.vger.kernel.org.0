Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E225A3398
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 03:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiH0Bqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 21:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiH0Bqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 21:46:37 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA86FEA8A2;
        Fri, 26 Aug 2022 18:46:35 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MDzx05Z7vz1N7QR;
        Sat, 27 Aug 2022 09:43:00 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 27 Aug
 2022 09:46:33 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <toke@toke.dk>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <stephen@networkplumber.org>
CC:     <cake@lists.bufferbloat.net>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: remove redundant NULL check in change hook function
Date:   Sat, 27 Aug 2022 09:49:10 +0800
Message-ID: <20220827014910.215062-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
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

Currently, the change function can be called by two ways. The one way is
that qdisc_change() will call it. Before calling change function,
qdisc_change() ensures tca[TCA_OPTIONS] is not empty. The other way is
that .init() will call it. The opt parameter is also checked before
calling change function in .init(). Therefore, it's no need to check the
input parameter opt in change function.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_cake.c     | 3 ---
 net/sched/sch_codel.c    | 3 ---
 net/sched/sch_ets.c      | 5 -----
 net/sched/sch_fq.c       | 3 ---
 net/sched/sch_fq_codel.c | 3 ---
 net/sched/sch_fq_pie.c   | 3 ---
 net/sched/sch_gred.c     | 3 ---
 net/sched/sch_hfsc.c     | 2 +-
 net/sched/sch_hhf.c      | 3 ---
 net/sched/sch_netem.c    | 3 ---
 net/sched/sch_pie.c      | 3 ---
 net/sched/sch_plug.c     | 3 ---
 net/sched/sch_red.c      | 3 ---
 13 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index a43a58a73d09..36acc95d611e 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2569,9 +2569,6 @@ static int cake_change(struct Qdisc *sch, struct nlattr *opt,
 	struct nlattr *tb[TCA_CAKE_MAX + 1];
 	int err;
 
-	if (!opt)
-		return -EINVAL;
-
 	err = nla_parse_nested_deprecated(tb, TCA_CAKE_MAX, opt, cake_policy,
 					  extack);
 	if (err < 0)
diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 30169b3adbbb..d7a4874543de 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -138,9 +138,6 @@ static int codel_change(struct Qdisc *sch, struct nlattr *opt,
 	unsigned int qlen, dropped = 0;
 	int err;
 
-	if (!opt)
-		return -EINVAL;
-
 	err = nla_parse_nested_deprecated(tb, TCA_CODEL_MAX, opt,
 					  codel_policy, NULL);
 	if (err < 0)
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index d73393493553..caeaa17b89bc 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -594,11 +594,6 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 	unsigned int i;
 	int err;
 
-	if (!opt) {
-		NL_SET_ERR_MSG(extack, "ETS options are required for this operation");
-		return -EINVAL;
-	}
-
 	err = nla_parse_nested(tb, TCA_ETS_MAX, opt, ets_policy, extack);
 	if (err < 0)
 		return err;
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 2fb76fc0cc31..48d14fb90ba0 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -808,9 +808,6 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
 	unsigned drop_len = 0;
 	u32 fq_log;
 
-	if (!opt)
-		return -EINVAL;
-
 	err = nla_parse_nested_deprecated(tb, TCA_FQ_MAX, opt, fq_policy,
 					  NULL);
 	if (err < 0)
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 839e1235db05..5ceb96bc8c65 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -374,9 +374,6 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 	u32 quantum = 0;
 	int err;
 
-	if (!opt)
-		return -EINVAL;
-
 	err = nla_parse_nested_deprecated(tb, TCA_FQ_CODEL_MAX, opt,
 					  fq_codel_policy, NULL);
 	if (err < 0)
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index d6aba6edd16e..b81476d63c74 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -283,9 +283,6 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
 	unsigned int num_dropped = 0;
 	int err;
 
-	if (!opt)
-		return -EINVAL;
-
 	err = nla_parse_nested(tb, TCA_FQ_PIE_MAX, opt, fq_pie_policy, extack);
 	if (err < 0)
 		return err;
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index c50a0853dcb9..e23d3dbb7272 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -413,9 +413,6 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
 	bool red_flags_changed;
 	int i;
 
-	if (!dps)
-		return -EINVAL;
-
 	sopt = nla_data(dps);
 
 	if (sopt->DPs > MAX_DPs) {
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index d3979a6000e7..05e4ba87acae 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1430,7 +1430,7 @@ hfsc_change_qdisc(struct Qdisc *sch, struct nlattr *opt,
 	struct hfsc_sched *q = qdisc_priv(sch);
 	struct tc_hfsc_qopt *qopt;
 
-	if (opt == NULL || nla_len(opt) < sizeof(*qopt))
+	if (nla_len(opt) < sizeof(*qopt))
 		return -EINVAL;
 	qopt = nla_data(opt);
 
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index 420ede875322..d26cd436cbe3 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -516,9 +516,6 @@ static int hhf_change(struct Qdisc *sch, struct nlattr *opt,
 	u32 new_quantum = q->quantum;
 	u32 new_hhf_non_hh_weight = q->hhf_non_hh_weight;
 
-	if (!opt)
-		return -EINVAL;
-
 	err = nla_parse_nested_deprecated(tb, TCA_HHF_MAX, opt, hhf_policy,
 					  NULL);
 	if (err < 0)
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 5449ed114e40..b70ac04110dd 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -961,9 +961,6 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 	int old_loss_model = CLG_RANDOM;
 	int ret;
 
-	if (opt == NULL)
-		return -EINVAL;
-
 	qopt = nla_data(opt);
 	ret = parse_attr(tb, TCA_NETEM_MAX, opt, netem_policy, sizeof(*qopt));
 	if (ret < 0)
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 5a457ff61acd..974038ba6c7b 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -143,9 +143,6 @@ static int pie_change(struct Qdisc *sch, struct nlattr *opt,
 	unsigned int qlen, dropped = 0;
 	int err;
 
-	if (!opt)
-		return -EINVAL;
-
 	err = nla_parse_nested_deprecated(tb, TCA_PIE_MAX, opt, pie_policy,
 					  NULL);
 	if (err < 0)
diff --git a/net/sched/sch_plug.c b/net/sched/sch_plug.c
index cbc2ebca4548..ea8c4a7174bb 100644
--- a/net/sched/sch_plug.c
+++ b/net/sched/sch_plug.c
@@ -161,9 +161,6 @@ static int plug_change(struct Qdisc *sch, struct nlattr *opt,
 	struct plug_sched_data *q = qdisc_priv(sch);
 	struct tc_plug_qopt *msg;
 
-	if (opt == NULL)
-		return -EINVAL;
-
 	msg = nla_data(opt);
 	if (nla_len(opt) < sizeof(*msg))
 		return -EINVAL;
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index cdf9d8611e41..cae3b80e4d9d 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -371,9 +371,6 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	struct nlattr *tb[TCA_RED_MAX + 1];
 	int err;
 
-	if (!opt)
-		return -EINVAL;
-
 	err = nla_parse_nested_deprecated(tb, TCA_RED_MAX, opt, red_policy,
 					  extack);
 	if (err < 0)
-- 
2.17.1

