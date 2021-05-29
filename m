Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3012394DC5
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 20:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhE2Su7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 14:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229762AbhE2Su6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 14:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0420601FC;
        Sat, 29 May 2021 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622314161;
        bh=UO9f9X1zD1LdxDjt5bxqXA/KKesiTsKKlLQIX0Nd88g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p4euv65Erksx0Dcx7ynJzUssdAk3q2Z9iDq9yv74gmL7j1JZjqWqFYoPvOK79kA82
         qdOmHtBSLQwAKIcy6zZRWhIE0K3v+oiqsDie2Ig4uYP3mfKp6fXRNERE46f8apwWZP
         jTQdr4uec8HPEQITs+sAdoP4TNbGwc61tTqi4IiI/kztEaQA8UbRsautovFIS4cPiY
         w29ewfj0FO0AlN1JaD9Hr2ExPc8EE/0FBTh9Ce+QzqhCkBtilX+lxa7od9ZCJivmGE
         +sMf7YGtIJMNJvXQo7zV9H3ALbdhUmzon4LeNq7Dm/NAjrcJUM30JPumvt1pPbcBem
         DbaP09V5HAB5Q==
Date:   Sat, 29 May 2021 11:49:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: Re: [PATCH net-next 2/3] net: sched: implement TCQ_F_CAN_BYPASS for
 lockless qdisc
Message-ID: <20210529114919.4f8b1980@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <ee1a62da-9758-70db-abd3-c5ca2e8e0ce0@huawei.com>
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
        <1622170197-27370-3-git-send-email-linyunsheng@huawei.com>
        <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
        <20210528213218.2b90864c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <ee1a62da-9758-70db-abd3-c5ca2e8e0ce0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 May 2021 15:03:09 +0800 Yunsheng Lin wrote:
> On 2021/5/29 12:32, Jakub Kicinski wrote:
> > On Sat, 29 May 2021 09:44:57 +0800 Yunsheng Lin wrote:  
> >> MISSED is only set when there is lock contention, which means it
> >> is better not to do the qdisc bypass to avoid out of order packet
> >> problem,   
> > 
> > Avoid as in make less likely? Nothing guarantees other thread is not
> > interrupted after ->enqueue and before qdisc_run_begin().
> > 
> > TBH I'm not sure what out-of-order situation you're referring to,
> > there is no ordering guarantee between separate threads trying to
> > transmit AFAIU.  
> A thread need to do the bypass checking before doing enqueuing, so
> it means MISSED is set or the trylock fails for the bypass transmiting(
> which will set the MISSED after the first trylock), so the MISSED will
> always be set before a thread doing a enqueuing, and we ensure MISSED
> only be cleared during the protection of q->seqlock, after clearing
> MISSED, we do anther round of dequeuing within the protection of
> q->seqlock.

The fact that MISSED is only cleared under q->seqlock does not matter,
because setting it and ->enqueue() are not under any lock. If the thread
gets interrupted between:

	if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(q) &&
	    qdisc_run_begin(q)) {

and ->enqueue() we can't guarantee that something else won't come in,
take q->seqlock and clear MISSED.

thread1                thread2             thread3
# holds seqlock
                       qdisc_run_begin(q)
                       set(MISSED)
pfifo_fast_dequeue
  clear(MISSED)
  # recheck the queue
qdisc_run_end()
                       ->enqueue()
                                            q->flags & TCQ_F_CAN_BYPASS..
                                            qdisc_run_begin() # true
                                            sch_direct_xmit()
                       qdisc_run_begin()
                       set(MISSED)

Or am I missing something?

Re-checking nolock_qdisc_is_empty() may or may not help.
But it doesn't really matter because there is no ordering
requirement between thread2 and thread3 here.

> So if a thread has taken the q->seqlock and the MISSED is not set yet,
> it is allowed to send the packet directly without going through the
> qdisc enqueuing and dequeuing process.
> 
> > IOW this check is not required for correctness, right?  
> 
> if a thread has taken the q->seqlock and the MISSED is not set, it means
> other thread has not set MISSED after the first trylock and before the
> second trylock, which means the enqueuing is not done yet.
> So I assume the this check is required for correctness if I understand
> your question correctly.
>
> >> another good thing is that we could also do the batch
> >> dequeuing and transmiting of packets when there is lock contention.  
> > 
> > No doubt, but did you see the flag get set significantly often here 
> > to warrant the double-checking?  
> 
> No, that is just my guess:)

