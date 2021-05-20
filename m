Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86D238A177
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 11:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhETJbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 05:31:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4698 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbhETJ3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 05:29:20 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fm48Q1zFyz16Q7J;
        Thu, 20 May 2021 17:25:10 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 17:27:57 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 17:27:56 +0800
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
Subject: [PATCH RFC v4 1/3] net: sched: avoid unnecessary seqcount operation for lockless qdisc
Date:   Thu, 20 May 2021 17:27:51 +0800
Message-ID: <1621502873-62720-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621502873-62720-1-git-send-email-linyunsheng@huawei.com>
References: <1621502873-62720-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qdisc->running seqcount operation is mainly used to do heuristic
locking on q->busylock for locked qdisc, see qdisc_is_running()
and __dev_xmit_skb().

So avoid doing seqcount operation for qdisc with TCQ_F_NOLOCK
flag.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/sch_generic.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 1e62551..3ed6bcc 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -188,6 +188,7 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 
 nolock_empty:
 		WRITE_ONCE(qdisc->empty, false);
+		return true;
 	} else if (qdisc_is_running(qdisc)) {
 		return false;
 	}
@@ -201,7 +202,6 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 
 static inline void qdisc_run_end(struct Qdisc *qdisc)
 {
-	write_seqcount_end(&qdisc->running);
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);
 
@@ -210,6 +210,8 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
 			clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
 			__netif_schedule(qdisc);
 		}
+	} else {
+		write_seqcount_end(&qdisc->running);
 	}
 }
 
-- 
2.7.4

