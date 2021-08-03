Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B69A3DEB61
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhHCK7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:59:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16036 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbhHCK73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 06:59:29 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GfBcH4gy2zZwbC;
        Tue,  3 Aug 2021 18:55:43 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 3 Aug 2021 18:59:16 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 3 Aug 2021 18:59:16 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <pabeni@redhat.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH net] net: sched: fix lockdep_set_class() typo error for sch->seqlock
Date:   Tue, 3 Aug 2021 18:58:21 +0800
Message-ID: <1627988301-55801-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to comment in qdisc_alloc(), sch->seqlock's lockdep
class key should be set to qdisc_tx_busylock, due to possible
type error, sch->busylock's lockdep class key is set to
qdisc_tx_busylock, which is duplicated because sch->busylock's
lockdep class key is already set in qdisc_alloc().

So fix it by replacing sch->busylock with sch->seqlock.

Fixes: 96009c7d500e ("sched: replace __QDISC_STATE_RUNNING bit with a spin lock")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
commit ab92d68fc22f ("net: core: add generic lockdep keys")
seems to fix the above error without mentioning that, and then
it is reverted by commit 1a33e10e4a95 ("net: partially revert
dynamic lockdep key changes"), but the blamed commit still be
96009c7d500e ("sched: replace __QDISC_STATE_RUNNING bit with
a spin lock").
---
 net/sched/sch_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d9ac60f..a8dd06c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -913,7 +913,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 
 	/* seqlock has the same scope of busylock, for NOLOCK qdisc */
 	spin_lock_init(&sch->seqlock);
-	lockdep_set_class(&sch->busylock,
+	lockdep_set_class(&sch->seqlock,
 			  dev->qdisc_tx_busylock ?: &qdisc_tx_busylock);
 
 	seqcount_init(&sch->running);
-- 
2.7.4

