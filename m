Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8313D393B9B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 04:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhE1Cvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 22:51:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5125 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhE1Cvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 22:51:42 -0400
Received: from dggeml713-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Frpxn3yMSzYnqQ;
        Fri, 28 May 2021 10:47:25 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml713-chm.china.huawei.com (10.3.17.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 10:50:05 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 10:50:05 +0800
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
Subject: [PATCH net-next 1/3] net: sched: avoid unnecessary seqcount operation for lockless qdisc
Date:   Fri, 28 May 2021 10:49:55 +0800
Message-ID: <1622170197-27370-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

