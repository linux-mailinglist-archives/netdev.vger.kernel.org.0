Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A50137F0D3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 03:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239321AbhEMBMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 21:12:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2573 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbhEMBMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 21:12:23 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FgYSc17k0zsRN8;
        Thu, 13 May 2021 09:08:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 09:10:57 +0800
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
Subject: [PATCH net v7 0/3] fix packet stuck problem for lockless qdisc
Date:   Thu, 13 May 2021 09:10:57 +0800
Message-ID: <1620868260-32984-1-git-send-email-linyunsheng@huawei.com>
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

V7: Fix netif_tx_wake_queue() data race noted by Jakub.
V6: Some performance optimization in patch 1 suggested by Jakub
    and drop NET_XMIT_DROP checking in patch 3.
V5: add patch 3 to fix the problem reported by Michal Kubecek.
V4: Change STATE_NEED_RESCHEDULE to STATE_MISSED and add patch 2.

[1]. https://lkml.org/lkml/2019/10/9/42

Yunsheng Lin (3):
  net: sched: fix packet stuck problem for lockless qdisc
  net: sched: fix endless tx action reschedule during deactivation
  net: sched: fix tx action reschedule issue with stopped queue

 include/net/pkt_sched.h   |  7 +------
 include/net/sch_generic.h | 35 ++++++++++++++++++++++++++++++++-
 net/core/dev.c            | 29 ++++++++++++++++++++++-----
 net/sched/sch_generic.c   | 50 +++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 107 insertions(+), 14 deletions(-)

-- 
2.7.4

