Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B50655032F
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 08:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiFRGUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 02:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiFRGUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 02:20:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379E42CE1C
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 23:20:50 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LQ5MT5bjdzhXZS;
        Sat, 18 Jun 2022 14:18:45 +0800 (CST)
Received: from dggpemm500011.china.huawei.com (7.185.36.110) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 18 Jun 2022 14:20:47 +0800
Received: from localhost.localdomain (10.137.16.177) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 18 Jun 2022 14:20:47 +0800
From:   chenzhen 00642392 <chenzhen126@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <rose.chen@huawei.com>
Subject: [Patch net] net_sched: cls_route: free the old filter only when it has been removed
Date:   Sat, 18 Jun 2022 14:18:40 +0800
Message-ID: <20220618061840.1012529-1-chenzhen126@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.137.16.177]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhen Chen <chenzhen126@huawei.com>

Syzbot reported a ODEBUG bug in route4_destroy(), it is actually a
use-after-free issue when route4_destroy() goes through the hashtable.

The root cause is that after route4_change() inserts a new filter into the
hashtable and finds an old filter, it will not remove the old one from the
table if fold->handle is 0, but free the fold as the final step.

Fix this by putting the free logic together with the remove action.

Reported-and-tested-by: syzbot+2e3efb5eb71cb5075ba7@syzkaller.appspotmail.com
Fixes: 1109c00547fc ("net: sched: RCU cls_route")
Signed-off-by: Zhen Chen <chenzhen126@huawei.com>
---
 net/sched/cls_route.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index a35ab8c27866..3917b84700b4 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -536,6 +536,9 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 			     fp = &pfp->next, pfp = rtnl_dereference(*fp)) {
 				if (pfp == fold) {
 					rcu_assign_pointer(*fp, fold->next);
+					tcf_unbind_filter(tp, &fold->res);
+					tcf_exts_get_net(&fold->exts);
+					tcf_queue_work(&fold->rwork, route4_delete_filter_work);
 					break;
 				}
 			}
@@ -544,11 +547,6 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 
 	route4_reset_fastmap(head);
 	*arg = f;
-	if (fold) {
-		tcf_unbind_filter(tp, &fold->res);
-		tcf_exts_get_net(&fold->exts);
-		tcf_queue_work(&fold->rwork, route4_delete_filter_work);
-	}
 	return 0;
 
 errout:
-- 
2.23.0

