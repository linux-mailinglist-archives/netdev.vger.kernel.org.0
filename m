Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F4E3952D8
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 22:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhE3UW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 16:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229756AbhE3UWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 16:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 861BB60FEF;
        Sun, 30 May 2021 20:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622406073;
        bh=a5s0B4kTibJT87biby4WJ9zqPOAuKMT+j3OvPglsW/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ACU+a5n63+X+nCHb+gW3k1DBDtb5IT4z8C+Ui8bKAmCbxMh3/8q5xpNOM9t4aLGEO
         c7IVgdzpoXuZHJp1Pn+gAtl5ekkeMxwBB4fcU4hjPguAqSA8XgbdeR5W0UBZARjNaL
         UJTMc2D610vYK91fidA2i99kKLyVvhHSt22LLo8NFW15/kauWvEYbQFGyqZXrLnvh/
         se5nxY96MR/clIH+31NhA9QT0zmrPT8Sw2rfoNyTgHLKJHJeHOhm6GUseLqv3CaltZ
         LDedHbbZVQoL/n5fBg+seK7iZs43VRH75nSTtfM7odofWqES0VlZLB3rdfbvLtUNaL
         O6Gmi1YIUjsWA==
Date:   Sun, 30 May 2021 13:21:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <yunshenglin0825@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        olteanv@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, edumazet@google.com, weiwan@google.com,
        cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, hdanton@sina.com, jgross@suse.com,
        JKosina@suse.com, mkubecek@suse.cz, bjorn@kernel.org,
        alobakin@pm.me
Subject: Re: [PATCH net-next 2/3] net: sched: implement TCQ_F_CAN_BYPASS for
 lockless qdisc
Message-ID: <20210530132111.3a974275@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <9cc9f513-7655-07df-3c74-5abe07ae8321@gmail.com>
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
        <1622170197-27370-3-git-send-email-linyunsheng@huawei.com>
        <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
        <20210528213218.2b90864c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <ee1a62da-9758-70db-abd3-c5ca2e8e0ce0@huawei.com>
        <20210529114919.4f8b1980@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <9cc9f513-7655-07df-3c74-5abe07ae8321@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 May 2021 09:37:09 +0800 Yunsheng Lin wrote:
> On 2021/5/30 2:49, Jakub Kicinski wrote:
> > The fact that MISSED is only cleared under q->seqlock does not matter,
> > because setting it and ->enqueue() are not under any lock. If the thread
> > gets interrupted between:
> > 
> > 	if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(q) &&
> > 	    qdisc_run_begin(q)) {
> > 
> > and ->enqueue() we can't guarantee that something else won't come in,
> > take q->seqlock and clear MISSED.
> > 
> > thread1                thread2             thread3
> > # holds seqlock
> >                        qdisc_run_begin(q)
> >                        set(MISSED)
> > pfifo_fast_dequeue
> >   clear(MISSED)
> >   # recheck the queue
> > qdisc_run_end()  
> >                        ->enqueue()  
> >                                             q->flags & TCQ_F_CAN_BYPASS..
> >                                             qdisc_run_begin() # true
> >                                             sch_direct_xmit()
> >                        qdisc_run_begin()
> >                        set(MISSED)
> > 
> > Or am I missing something?
> > 
> > Re-checking nolock_qdisc_is_empty() may or may not help.
> > But it doesn't really matter because there is no ordering
> > requirement between thread2 and thread3 here.  
> 
> I were more focued on explaining that using MISSED is reliable
> as sch_may_need_requeuing() checking in RFCv3 [1] to indicate a
> empty qdisc, and forgot to mention the data race described in
> RFCv3, which is kind of like the one described above:
> 
> "There is a data race as below:
> 
>       CPU1                                   CPU2
> qdisc_run_begin(q)                            .
>         .                                q->enqueue()
> sch_may_need_requeuing()                      .
>     return true                               .
>         .                                     .
>         .                                     .
>     q->enqueue()                              .
> 
> When above happen, the skb enqueued by CPU1 is dequeued after the
> skb enqueued by CPU2 because sch_may_need_requeuing() return true.
> If there is not qdisc bypass, the CPU1 has better chance to queue
> the skb quicker than CPU2.
> 
> This patch does not take care of the above data race, because I
> view this as similar as below:
> 
> Even at the same time CPU1 and CPU2 write the skb to two socket
> which both heading to the same qdisc, there is no guarantee that
> which skb will hit the qdisc first, becuase there is a lot of
> factor like interrupt/softirq/cache miss/scheduling afffecting
> that."
> 
> Does above make sense? Or any idea to avoid it?
> 
> 1. https://patchwork.kernel.org/project/netdevbpf/patch/1616404156-11772-1-git-send-email-linyunsheng@huawei.com/

We agree on this one.

Could you draw a sequence diagram of different CPUs (like the one
above) for the case where removing re-checking nolock_qdisc_is_empty()
under q->seqlock leads to incorrect behavior? 

If there is no such case would you be willing to repeat the benchmark
with and without this test?

Sorry for dragging the review out..
