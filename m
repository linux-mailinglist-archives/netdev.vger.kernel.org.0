Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB6134EA6A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhC3O2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:28:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14966 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbhC3O2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:28:10 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F8sF81rmyzwQr2;
        Tue, 30 Mar 2021 22:26:04 +0800 (CST)
Received: from localhost (10.174.242.151) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Tue, 30 Mar 2021
 22:27:58 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <xiyou.wangcong@gmail.com>, <jhs@mojatatu.com>,
        <jiri@resnulli.us>, <chenchanghu@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] sch_htb: fix null pointer dereference on a null new_q
Date:   Tue, 30 Mar 2021 22:27:48 +0800
Message-ID: <1617114468-2928-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.151]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

sch_htb: fix null pointer dereference on a null new_q

Currently if new_q is null, the null new_q pointer will be
dereference when 'q->offload' is true. Fix this by adding
a braces around htb_parent_to_leaf_offload() to avoid it.

Addresses-Coverity: ("Dereference after null check")
Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 net/sched/sch_htb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 62e12cb41a3e..081c11d5717c 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1675,9 +1675,10 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg,
 					  cl->parent->common.classid,
 					  NULL);
 		if (q->offload) {
-			if (new_q)
+			if (new_q) {
 				htb_set_lockdep_class_child(new_q);
-			htb_parent_to_leaf_offload(sch, dev_queue, new_q);
+				htb_parent_to_leaf_offload(sch, dev_queue, new_q);
+			}
 		}
 	}
 
-- 
2.23.0

