Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B94737B291
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhEKXcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKXb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:31:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 505FE6162A;
        Tue, 11 May 2021 23:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620775851;
        bh=vkyZkRo8XZF1l9dNhg4dKa+k+Q//WBXTlsGnQgWLcIw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hb1QUOfP4nf8yBZuUH1Chzg6CHXTDU3/sJyMgLPeNUHTmmuKFHLXcVcfYjMk/6E9c
         C1EdEgayThIJixVOz3cQ06NR++1YqndnQNByvLKK6nclSoJyVcc9nOSGxpu8srVXUi
         GKBYY9KPHkDKNbt2l4hVmNQsPHvzdDa10ROxNPQQlrZlTK4kA0mytjrDZTTz9Eyzjl
         RdOfrkGGDcJQB1rtzgbRZd5OlCy0//+7nyVEUFUzaVY8KdrrfsGEM0Lzaa81WmvZHC
         10rL4XQ+3/b/QHzDUhCITdFKVpLUbWjaRmt3JsSsrpIukAVwEliQgug+tmLXhhEvtJ
         TZ3uE1CSmPKrg==
Date:   Tue, 11 May 2021 16:30:49 -0700
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
Subject: Re: [PATCH net v6 3/3] net: sched: fix tx action reschedule issue
 with stopped queue
Message-ID: <20210511163049.37d2cba0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8db8e594-9606-2c93-7274-1c180afaadb2@huawei.com>
References: <1620610956-56306-1-git-send-email-linyunsheng@huawei.com>
        <1620610956-56306-4-git-send-email-linyunsheng@huawei.com>
        <20210510212232.3386c5b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c676404c-f210-b0cb-ced3-5449676055a8@huawei.com>
        <8db8e594-9606-2c93-7274-1c180afaadb2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 May 2021 20:13:56 +0800 Yunsheng Lin wrote:
> On 2021/5/11 17:04, Yunsheng Lin wrote:
> > On 2021/5/11 12:22, Jakub Kicinski wrote:  
> >> The queues are woken asynchronously without holding any locks via
> >> netif_tx_wake_queue(). Theoretically we can have a situation where:
> >>
> >> CPU 0                            CPU 1   
> >>   .                                .
> >> dequeue_skb()                      .
> >>   netif_xmit_frozen..() # true     .
> >>   .                              [IRQ]
> >>   .                              netif_tx_wake_queue()
> >>   .                              <end of IRQ>
> >>   .                              netif_tx_action()
> >>   .                              set MISSED
> >>   clear MISSED
> >>   return NULL
> >> ret from qdisc_restart()
> >> ret from __qdisc_run()
> >> qdisc_run_end()  
>  [...]  
> > 
> > Yes, the above does seems to have the above data race.
> > 
> > As my understanding, there is two ways to fix the above data race:
> > 1. do not clear the STATE_MISSED for netif_xmit_frozen_or_stopped()
> >    case, just check the netif_xmit_frozen_or_stopped() before
> >    calling __netif_schedule() at the end of qdisc_run_end(). This seems
> >    to only work with qdisc with TCQ_F_ONETXQUEUE flag because it seems
> >    we can only check the netif_xmit_frozen_or_stopped() with q->dev_queue,
> >    I am not sure q->dev_queue is pointint to which netdev queue when qdisc
> >    is not set with TCQ_F_ONETXQUEUE flag.

Isn't the case where we have a NOLOCK qdisc without TCQ_F_ONETXQUEUE
rather unexpected? It'd have to be a single pfifo on multi-queue
netdev, right? Sounds not worth optimizing for. How about:

 static inline void qdisc_run_end(struct Qdisc *qdisc)
 {
 	write_seqcount_end(&qdisc->running);
	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);

		if (unlikely(test_bit(__QDISC_STATE_MISSED,
				      &qdisc->state))) {
			clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
			if (!(q->flags & TCQ_F_ONETXQUEUE) ||
			    !netif_xmit_frozen_or_stopped(q->dev_queue))
				__netif_schedule(qdisc);
		}
	}
 }

For the strange non-ONETXQUEUE case we'd have an occasional unnecessary
net_tx_action, but no infinite loop possible.

> > 2. clearing the STATE_MISSED for netif_xmit_frozen_or_stopped() case
> >    as this patch does, and protect the __netif_schedule() with q->seqlock
> >    for netif_tx_wake_queue(), which might bring unnecessary overhead for
> >    non-stopped queue case
> > 
> > Any better idea?  
> 
> 3. Or check the netif_xmit_frozen_or_stopped() again after clearing
>    STATE_MISSED, like below:
> 
>    if (netif_xmit_frozen_or_stopped(txq)) {
> 	  clear_bit(__QDISC_STATE_MISSED, &q->state);
> 
> 	  /* Make sure the below netif_xmit_frozen_or_stopped()
> 	   * checking happens after clearing STATE_MISSED.
> 	   */
> 	  smp_mb__after_atomic();
> 
> 	  /* Checking netif_xmit_frozen_or_stopped() again to
> 	   * make sure __QDISC_STATE_MISSED is set if the
> 	   * __QDISC_STATE_MISSED set by netif_tx_wake_queue()'s
> 	   * rescheduling of net_tx_action() is cleared by the
> 	   * above clear_bit().
> 	   */
> 	  if (!netif_xmit_frozen_or_stopped(txq))
> 	  	set_bit(__QDISC_STATE_MISSED, &q->state);
>   }
> 
>   It is kind of ugly, but it does seem to fix the above data race too.
>   And it seems like a common pattern to deal with the concurrency between
>   xmit and NAPI polling, as below:
> 
> https://elixir.bootlin.com/linux/v5.12-rc2/source/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c#L1409

This is indeed the idiomatic way of dealing with Tx queue stopping race,
but it's a bit of code to sprinkle around. My vote would be option 1.
