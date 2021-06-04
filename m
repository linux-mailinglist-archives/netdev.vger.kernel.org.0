Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A86539B776
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 13:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhFDLFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 07:05:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4474 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhFDLFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 07:05:15 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxKYj2hcTzZc9k;
        Fri,  4 Jun 2021 19:00:41 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 19:03:27 +0800
Received: from localhost (10.174.243.60) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 4 Jun 2021
 19:03:25 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <maximmi@nvidia.com>,
        <tariqt@nvidia.com>, <xiyou.wangcong@gmail.com>,
        <jhs@mojatatu.com>, <dingxiaoxiong@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] sch_htb: fix refcount leak in htb_parent_to_leaf_offload
Date:   Fri, 4 Jun 2021 19:03:18 +0800
Message-ID: <1622804598-11164-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.60]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500008.china.huawei.com (7.185.36.136)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The commit ae81feb7338c ("sch_htb: fix null pointer dereference
on a null new_q") fixes a NULL pointer dereference bug, but it
is not correct.

Because htb_graft_helper properly handles the case when new_q
is NULL, and after the previous patch by skipping this call
which creates an inconsistency : dev_queue->qdisc will still
point to the old qdisc, but cl->parent->leaf.q will point to
the new one (which will be noop_qdisc, because new_q was NULL).
The code is based on an assumption that these two pointers are
the same, so it can lead to refcount leaks.

The correct fix is to add a NULL pointer check to protect
qdisc_refcount_inc inside htb_parent_to_leaf_offload.

Fixes: ae81feb7338c ("sch_htb: fix null pointer dereference on a null new_q")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Suggested-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 net/sched/sch_htb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 4f9304567dcc..469301a18ff8 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1491,7 +1491,8 @@ static void htb_parent_to_leaf_offload(struct Qdisc *sch,
 	struct Qdisc *old_q;
 
 	/* One ref for cl->leaf.q, the other for dev_queue->qdisc. */
-	qdisc_refcount_inc(new_q);
+	if (new_q)
+		qdisc_refcount_inc(new_q);
 	old_q = htb_graft_helper(dev_queue, new_q);
 	WARN_ON(!(old_q->flags & TCQ_F_BUILTIN));
 }
@@ -1678,10 +1679,9 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg,
 					  cl->parent->common.classid,
 					  NULL);
 		if (q->offload) {
-			if (new_q) {
+			if (new_q)
 				htb_set_lockdep_class_child(new_q);
-				htb_parent_to_leaf_offload(sch, dev_queue, new_q);
-			}
+			htb_parent_to_leaf_offload(sch, dev_queue, new_q);
 		}
 	}
 
-- 
2.23.0

