Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A342DA0CE
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502763AbgLNTrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:47:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502754AbgLNTrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 14:47:52 -0500
Date:   Mon, 14 Dec 2020 11:47:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607975231;
        bh=S459hkWleAJvt7zyXH3/BGXamsw5bJJlY20Jm8OwliM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yn8kRC9AmBtfcv70kwu6SwyeciVG/vxAaK5dfTnZCd+t5LtofWGhr3NcU2RoQ7NSa
         7cQFn44/OBIZyB+bvmeAt7GypQWFQi/ocrOQ+h/2gqa5LD/23ARl5IqDYIwh72h2F5
         4WuGZ0onzHGufJGpz37bPwgQKA243wJXpLOVXMbxJAkusDUe+KrPJuM5hjA+I59uca
         bf/GA2anMPC2JaybpavI5OSrWVpxXPaKjBRKldgl7UEMcE13gcaxQVq22ZcOyoreXQ
         q7gbg+KhYZc7CyfR+BIbJqI7tOzr78UWJ+wGvAnglSFgn9regX8dzpgRgeI9Qbijqk
         kPCl0qVm31+OQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>
Subject: Re: [PATCH v2 3/3] net: mhi: Add dedicated alloc thread
Message-ID: <20201214114710.08346744@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMZdPi8JGnEn1BbsX2jP_bNAGPrSz=eL2ZJ5n_2ReqGP2jpdOg@mail.gmail.com>
References: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
        <1607598951-2340-3-git-send-email-loic.poulain@linaro.org>
        <20201212125544.4857b1cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi8JGnEn1BbsX2jP_bNAGPrSz=eL2ZJ5n_2ReqGP2jpdOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 10:19:07 +0100 Loic Poulain wrote:
> On Sat, 12 Dec 2020 at 21:55, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 10 Dec 2020 12:15:51 +0100 Loic Poulain wrote:  
> > > The buffer allocation for RX path is currently done by a work executed
> > > in the system workqueue. The work to do is quite simple and consists
> > > mostly in allocating and queueing as much as possible buffers to the MHI
> > > RX channel.
> > >
> > > It appears that using a dedicated kthread would be more appropriate to
> > > prevent
> > > 1. RX allocation latency introduced by the system queue  
> >
> > System work queue should not add much latency, you can also create your
> > own workqueue. Did you intend to modify the priority of the thread you
> > create?  
> 
> No, and I don't, since I assume there is no reason to prioritize
> network over other loads. I've considered the dedicated workqueue, but
> since there is only one task to run as a while loop, I thought using a
> kthread was more appropriate (and slightly lighter), but I can move to
> that solution if you recommend it.

Not sure what to recommend TBH, if thread works better for you that's
fine. I don't understand why the thread would work better, tho. I was
just checking if there is any extra tuning that happens.

> > > 2. Unbounded work execution, the work only returning when queue is
> > > full, it can possibly monopolise the workqueue thread on slower systems.  
> >
> > Is this something you observed in practice?  
> 
> No, I've just observed that work duration is inconstant , queuing from
> few buffers to several hundreeds. This unbounded behavior makes me
> feel that doing that in the shared sytem workqueue is probably not the
> right place. I've not tested on a slower machine though.

I think long running work should not be an issue for the cmwq
implementation we have in the kernel.

Several hundred buffers means it's running concurrently with RX, right?
Since the NIC queue is 128 buffers.

> > > This patch replaces the system work with a simple kthread that loops on
> > > buffer allocation and sleeps when queue is full. Moreover it gets rid
> > > of the local rx_queued variable (to track buffer count), and instead,
> > > relies on the new mhi_get_free_desc_count helper.  
> >
> > Seems unrelated, should probably be a separate patch.  
> 
> I can do that.
> 
> >  
> > > After pratical testing on a x86_64 machine, this change improves
> > > - Peek throughput (slightly, by few mbps)
> > > - Throughput stability when concurrent loads are running (stress)
> > > - CPU usage, less CPU cycles dedicated to the task  
> >
> > Do you have an explanation why the CPU cycles are lower?  
> 
> For CPU cycles, TBH, not really, this is just observational.

Is the IRQ pinned? I wonder how often work runs on the same CPU as IRQ
processing and how often does the thread do.

> Regarding throughput stability, it's certainly because the work can
> consume all its dedicated kthread time.

Meaning workqueue implementation doesn't get enough CPU? Strange.

> > > Below is the powertop output for RX allocation task before and
> > > after this change, when performing UDP download at 6Gbps. Mostly
> > > to highlight the improvement in term of CPU usage.
> > >
> > > older (system workqueue):
> > > Usage       Events/s    Category       Description
> > > 63,2 ms/s     134,0        kWork          mhi_net_rx_refill_work
> > > 62,8 ms/s     134,3        kWork          mhi_net_rx_refill_work
> > > 60,8 ms/s     141,4        kWork          mhi_net_rx_refill_work
> > >
> > > newer (dedicated kthread):
> > > Usage       Events/s    Category       Description
> > > 20,7 ms/s     155,6        Process        [PID 3360] [mhi-net-rx]
> > > 22,2 ms/s     169,6        Process        [PID 3360] [mhi-net-rx]
> > > 22,3 ms/s     150,2        Process        [PID 3360] [mhi-net-rx]
> > >
> > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

> > > +             skb = netdev_alloc_skb(ndev, size);
> > > +             if (unlikely(!skb)) {
> > > +                     /* No memory, retry later */
> > > +
> > > schedule_timeout_interruptible(msecs_to_jiffies(250));  
> >
> > You should have a counter for this, at least for your testing. If
> > this condition is hit it'll probably have a large impact on the
> > performance.  
> 
> Indeed, going to do that, what about a ratelimited error? I assume if
> it's happen, system is really in bad shape.

It's not that uncommon to run out of memory for a 2k allocation in an
atomic context (note that netdev_alloc_skb() uses GFP_ATOMIC).
You can add a rate-limited print if you want, tho.

> > > +                     continue;
> > > +             }
> > > +
> > > +             err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb,
> > > size, MHI_EOT);
> > > +             if (unlikely(err)) {
> > > +                     net_err_ratelimited("%s: Failed to queue RX
> > > buf (%d)\n",
> > > +                                         ndev->name, err);
> > > +                     kfree_skb(skb);
> > > +                     break;
> > > +             }
> > > +
> > > +             /* Do not hog the CPU */
> > > +             cond_resched();
> > > +     }
> > > +
> > > +     return 0;
> > > +}
> > > +
> > >  static int mhi_ndo_open(struct net_device *ndev)
> > >  {
> > >       struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> > > +     unsigned int qsz = mhi_netdev->rx_queue_sz;
> > >
> > > -     /* Feed the rx buffer pool */
> > > -     schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> > > +     if (rx_refill_level >= 100)
> > > +             mhi_netdev->rx_refill_level = 1;
> > > +     else
> > > +             mhi_netdev->rx_refill_level = qsz - qsz *
> > > rx_refill_level / 100;  
> >
> > So you're switching from 50% fill level to 70%. Are you sure that's
> > not the reason the performance gets better? Did you experiments
> > with higher fill levels?  
> 
> No, I've tested both levels with the two solutions, It's just that
> after experiment, high throughput is a bit more stable with 70%. So I
> can revert back to 50% to avoid confusion and keep that for a
> subsequent change.

I'm not fussed about that - it would be good tho to have the numbers in
comparisons for the same fill levels. Otherwise comparing workq at 50%
vs thread at 70% is changing two variables at the same time.
