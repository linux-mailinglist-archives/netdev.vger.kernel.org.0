Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E203801F9
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 04:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhENC2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 22:28:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3667 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbhENC2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 22:28:13 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhC5b03L7z1BMNh;
        Fri, 14 May 2021 10:24:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 10:26:56 +0800
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
Subject: [PATCH net v8 0/3] fix packet stuck problem for lockless qdisc
Date:   Fri, 14 May 2021 10:26:55 +0800
Message-ID: <1620959218-17250-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes the packet stuck problem mentioned in [1].

Patch 1: Add STATE_MISSED flag to fix packet stuck problem.
Patch 2: Fix a tx_action rescheduling problem after STATE_MISSED
         flag is added in patch 1.
Patch 3: Fix the significantly higher CPU consumption problem when
         multiple threads are competing on a saturated outgoing
         device.

V8: Change function name in patch 3 as suggested by Jakub, adjust
    commit log in patch 2, and add Acked-by from Jakub.
V7: Fix netif_tx_wake_queue() data race noted by Jakub.
V6: Some performance optimization in patch 1 suggested by Jakub
    and drop NET_XMIT_DROP checking in patch 3.
V5: add patch 3 to fix the problem reported by Michal Kubecek.
V4: Change STATE_NEED_RESCHEDULE to STATE_MISSED and add patch 2.

[1]. https://lkml.org/lkml/2019/10/9/42

Yunsheng Lin (3):
  net: sched: fix packet stuck problem for lockless qdisc
  net: sched: fix tx action rescheduling issue during deactivation
  net: sched: fix tx action reschedule issue with stopped queue

 include/net/pkt_sched.h   |  7 +------
 include/net/sch_generic.h | 35 ++++++++++++++++++++++++++++++++-
 net/core/dev.c            | 29 ++++++++++++++++++++++-----
 net/sched/sch_generic.c   | 50 +++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 107 insertions(+), 14 deletions(-)

-- 
2.7.4

