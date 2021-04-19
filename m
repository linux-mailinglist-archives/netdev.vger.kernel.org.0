Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9355B36472A
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241450AbhDSPaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:30:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:35170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233733AbhDSPaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 11:30:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 69FD4AF23;
        Mon, 19 Apr 2021 15:29:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C0ACB603AA; Mon, 19 Apr 2021 17:29:46 +0200 (CEST)
Date:   Mon, 19 Apr 2021 17:29:46 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, olteanv@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        mkl@pengutronix.de, linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, hdanton@sina.com, jgross@suse.com,
        JKosina@suse.com
Subject: Re: [PATCH net v4 1/2] net: sched: fix packet stuck problem for
 lockless qdisc
Message-ID: <20210419152946.3n7adsd355rfeoda@lion.mk-sys.cz>
References: <1618535809-11952-1-git-send-email-linyunsheng@huawei.com>
 <1618535809-11952-2-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618535809-11952-2-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 09:16:48AM +0800, Yunsheng Lin wrote:
> Lockless qdisc has below concurrent problem:
>     cpu0                 cpu1
>      .                     .
> q->enqueue                 .
>      .                     .
> qdisc_run_begin()          .
>      .                     .
> dequeue_skb()              .
>      .                     .
> sch_direct_xmit()          .
>      .                     .
>      .                q->enqueue
>      .             qdisc_run_begin()
>      .            return and do nothing
>      .                     .
> qdisc_run_end()            .
> 
> cpu1 enqueue a skb without calling __qdisc_run() because cpu0
> has not released the lock yet and spin_trylock() return false
> for cpu1 in qdisc_run_begin(), and cpu0 do not see the skb
> enqueued by cpu1 when calling dequeue_skb() because cpu1 may
> enqueue the skb after cpu0 calling dequeue_skb() and before
> cpu0 calling qdisc_run_end().
> 
> Lockless qdisc has below another concurrent problem when
> tx_action is involved:
> 
> cpu0(serving tx_action)     cpu1             cpu2
>           .                   .                .
>           .              q->enqueue            .
>           .            qdisc_run_begin()       .
>           .              dequeue_skb()         .
>           .                   .            q->enqueue
>           .                   .                .
>           .             sch_direct_xmit()      .
>           .                   .         qdisc_run_begin()
>           .                   .       return and do nothing
>           .                   .                .
>  clear __QDISC_STATE_SCHED    .                .
>  qdisc_run_begin()            .                .
>  return and do nothing        .                .
>           .                   .                .
>           .            qdisc_run_end()         .
> 
> This patch fixes the above data race by:
> 1. Test STATE_MISSED before doing spin_trylock().
> 2. If the first spin_trylock() return false and STATE_MISSED is
>    not set before the first spin_trylock(), Set STATE_MISSED and
>    retry another spin_trylock() in case other CPU may not see
>    STATE_MISSED after it releases the lock.
> 3. reschedule if STATE_MISSED is set after the lock is released
>    at the end of qdisc_run_end().
> 
> For tx_action case, STATE_MISSED is also set when cpu1 is at the
> end if qdisc_run_end(), so tx_action will be rescheduled again
> to dequeue the skb enqueued by cpu2.
> 
> Clear STATE_MISSED before retrying a dequeuing when dequeuing
> returns NULL in order to reduce the overhead of the above double
> spin_trylock() and __netif_schedule() calling.
> 
> The performance impact of this patch, tested using pktgen and
> dummy netdev with pfifo_fast qdisc attached:
> 
>  threads  without+this_patch   with+this_patch      delta
>     1        2.61Mpps            2.60Mpps           -0.3%
>     2        3.97Mpps            3.82Mpps           -3.7%
>     4        5.62Mpps            5.59Mpps           -0.5%
>     8        2.78Mpps            2.77Mpps           -0.3%
>    16        2.22Mpps            2.22Mpps           -0.0%
> 
> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Tested-by: Juergen Gross <jgross@suse.com>
> ---
> V4: Change STATE_NEED_RESCHEDULE to STATE_MISSED mirroring
>     NAPI's NAPIF_STATE_MISSED, and add Juergen's "Tested-by"
>     tag for there is only renaming and typo fixing between
>     V4 and V3.
> V3: Fix a compile error and a few comment typo, remove the
>     __QDISC_STATE_DEACTIVATED checking, and update the
>     performance data.
> V2: Avoid the overhead of fixing the data race as much as
>     possible.

As pointed out in the discussion on v3, this patch may result in
significantly higher CPU consumption with multiple threads competing on
a saturated outgoing device. I missed this submission so that I haven't
checked it yet but given the description of v3->v4 changes above, it's
quite likely that it suffers from the same problem.

Michal
