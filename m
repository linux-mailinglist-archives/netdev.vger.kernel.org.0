Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74CD2A3B09
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 04:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgKCD3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 22:29:18 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6737 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgKCD3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 22:29:18 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CQFd43f75zkdnT;
        Tue,  3 Nov 2020 11:29:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 3 Nov 2020 11:29:07 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <vpai@akamai.com>, <Joakim.Tjernlund@infinera.com>,
        <xiyou.wangcong@gmail.com>, <johunt@akamai.com>,
        <jhs@mojatatu.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.fastabend@gmail.com>, <eric.dumazet@gmail.com>,
        <dsahern@gmail.com>
Subject: [PATCH stable] net: sch_generic: fix the missing new qdisc assignment bug
Date:   Tue, 3 Nov 2020 11:25:38 +0800
Message-ID: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 2fb541c862c9 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")

When the above upstream commit is backported to stable kernel,
one assignment is missing, which causes two problems reported
by Joakim and Vishwanath, see [1] and [2].

So add the assignment back to fix it.

1. https://www.spinics.net/lists/netdev/msg693916.html
2. https://www.spinics.net/lists/netdev/msg695131.html

Fixes: 749cc0b0c7f3 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/sched/sch_generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 0e275e1..6e6147a 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1127,10 +1127,13 @@ static void dev_deactivate_queue(struct net_device *dev,
 				 void *_qdisc_default)
 {
 	struct Qdisc *qdisc = rtnl_dereference(dev_queue->qdisc);
+	struct Qdisc *qdisc_default = _qdisc_default;
 
 	if (qdisc) {
 		if (!(qdisc->flags & TCQ_F_BUILTIN))
 			set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
+
+		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
 	}
 }
 
-- 
2.7.4

