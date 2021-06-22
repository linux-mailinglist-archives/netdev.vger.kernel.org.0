Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26D43AFD56
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFVGwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:52:46 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8291 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhFVGwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:52:42 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G8H2h1Qddz1BQRW;
        Tue, 22 Jun 2021 14:45:16 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 14:50:24 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 14:50:23 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <olteanv@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andriin@fb.com>, <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: [PATCH net-next v3 3/3] net: sched: remove qdisc->empty for lockless qdisc
Date:   Tue, 22 Jun 2021 14:49:57 +0800
Message-ID: <1624344597-11806-4-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624344597-11806-1-git-send-email-linyunsheng@huawei.com>
References: <1624344597-11806-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As MISSED and DRAINING state are used to indicate a non-empty
qdisc, qdisc->empty is not longer needed, so remove it.

Acked-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com> # flexcan
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/sch_generic.h | 13 +++----------
 net/sched/sch_generic.c   |  3 ---
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 177f240..c99ffe9 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -117,8 +117,6 @@ struct Qdisc {
 	spinlock_t		busylock ____cacheline_aligned_in_smp;
 	spinlock_t		seqlock;
 
-	/* for NOLOCK qdisc, true if there are no enqueued skbs */
-	bool			empty;
 	struct rcu_head		rcu;
 
 	/* private data */
@@ -165,7 +163,7 @@ static inline bool qdisc_is_percpu_stats(const struct Qdisc *q)
 static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
 {
 	if (qdisc_is_percpu_stats(qdisc))
-		return READ_ONCE(qdisc->empty);
+		return nolock_qdisc_is_empty(qdisc);
 	return !READ_ONCE(qdisc->q.qlen);
 }
 
@@ -173,7 +171,7 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 {
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		if (spin_trylock(&qdisc->seqlock))
-			goto nolock_empty;
+			return true;
 
 		/* If the MISSED flag is set, it means other thread has
 		 * set the MISSED flag before second spin_trylock(), so
@@ -195,12 +193,7 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		/* Retry again in case other CPU may not see the new flag
 		 * after it releases the lock at the end of qdisc_run_end().
 		 */
-		if (!spin_trylock(&qdisc->seqlock))
-			return false;
-
-nolock_empty:
-		WRITE_ONCE(qdisc->empty, false);
-		return true;
+		return spin_trylock(&qdisc->seqlock);
 	} else if (qdisc_is_running(qdisc)) {
 		return false;
 	}
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 9984ccc..d9ac60f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -725,8 +725,6 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
 		need_retry = false;
 
 		goto retry;
-	} else {
-		WRITE_ONCE(qdisc->empty, true);
 	}
 
 	return skb;
@@ -927,7 +925,6 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	sch->enqueue = ops->enqueue;
 	sch->dequeue = ops->dequeue;
 	sch->dev_queue = dev_queue;
-	sch->empty = true;
 	dev_hold(dev);
 	refcount_set(&sch->refcnt, 1);
 
-- 
2.7.4

