Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A473AFD4F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhFVGwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:52:44 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8290 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhFVGwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:52:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G8H2g0cjTz1BQQ9;
        Tue, 22 Jun 2021 14:45:15 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 14:50:23 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 14:50:22 +0800
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
Subject: [PATCH net-next v3 0/3] Some optimization for lockless qdisc
Date:   Tue, 22 Jun 2021 14:49:54 +0800
Message-ID: <1624344597-11806-1-git-send-email-linyunsheng@huawei.com>
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

Patch 1: remove unnecessary seqcount operation.
Patch 2: implement TCQ_F_CAN_BYPASS.
Patch 3: remove qdisc->empty.

Performance data for pktgen in queue_xmit mode + dummy netdev
with pfifo_fast:

 threads    unpatched           patched             delta
    1       2.60Mpps            3.21Mpps             +23%
    2       3.84Mpps            5.56Mpps             +44%
    4       5.52Mpps            5.58Mpps             +1%
    8       2.77Mpps            2.76Mpps             -0.3%
   16       2.24Mpps            2.23Mpps             -0.4%

Performance for IP forward testing: 1.05Mpps increases to
1.16Mpps, about 10% improvement.

V3: Add 'Acked-by' from Jakub and 'Tested-by' from Vladimir,
    and resend based on latest net-next.
V2: Adjust the comment and commit log according to discussion
    in V1.
V1: Drop RFC tag, add nolock_qdisc_is_empty() and do the qdisc
    empty checking without the protection of qdisc->seqlock to
    aviod doing unnecessary spin_trylock() for contention case.
RFC v4: Use STATE_MISSED and STATE_DRAINING to indicate non-empty
        qdisc, and add patch 1 and 3.

Yunsheng Lin (3):
  net: sched: avoid unnecessary seqcount operation for lockless qdisc
  net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
  net: sched: remove qdisc->empty for lockless qdisc

 include/net/sch_generic.h | 31 ++++++++++++++++++-------------
 net/core/dev.c            | 27 +++++++++++++++++++++++++--
 net/sched/sch_generic.c   | 23 ++++++++++++++++-------
 3 files changed, 59 insertions(+), 22 deletions(-)

-- 
2.7.4

