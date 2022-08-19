Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1D05993EF
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344830AbiHSEQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbiHSEQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:16:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C415BDA3D2;
        Thu, 18 Aug 2022 21:16:00 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M87dc1ND8zlVyK;
        Fri, 19 Aug 2022 12:12:52 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 19 Aug
 2022 12:15:58 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2] net: sched: remove duplicate check of user rights in qdisc
Date:   Fri, 19 Aug 2022 12:18:54 +0800
Message-ID: <20220819041854.83372-1-shaozhengchao@huawei.com>
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

In rtnetlink_rcv_msg function, the permission for all user operations
is checked except the GET operation, which is the same as the checking
in qdisc. Therefore, remove the user rights check in qdisc.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v1: incorrectly delete checking right in action
---
 net/sched/cls_api.c | 10 ----------
 net/sched/sch_api.c | 11 -----------
 2 files changed, 21 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 790d6809be81..1ebab4b11262 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1977,9 +1977,6 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	bool rtnl_held = false;
 	u32 flags;
 
-	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
 replay:
 	tp_created = 0;
 
@@ -2208,9 +2205,6 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	int err;
 	bool rtnl_held = false;
 
-	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
 	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
 				     rtm_tca_policy, extack);
 	if (err < 0)
@@ -2826,10 +2820,6 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 	unsigned long cl;
 	int err;
 
-	if (n->nlmsg_type != RTM_GETCHAIN &&
-	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
 replay:
 	q = NULL;
 	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index bf87b50837a8..6c687e77d68b 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1424,10 +1424,6 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 	struct Qdisc *p = NULL;
 	int err;
 
-	if ((n->nlmsg_type != RTM_GETQDISC) &&
-	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
 	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
 				     rtm_tca_policy, extack);
 	if (err < 0)
@@ -1508,9 +1504,6 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 	struct Qdisc *q, *p;
 	int err;
 
-	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
 replay:
 	/* Reinit, just in case something touches this. */
 	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
@@ -1992,10 +1985,6 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 	u32 qid;
 	int err;
 
-	if ((n->nlmsg_type != RTM_GETTCLASS) &&
-	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
 	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
 				     rtm_tca_policy, extack);
 	if (err < 0)
-- 
2.17.1

