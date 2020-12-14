Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D112D94C2
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437132AbgLNJNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439609AbgLNJNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:13:18 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62916C06138C
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 01:12:32 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id r5so16351709eda.12
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 01:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UvcJ/LZ7ZVgjhl8GiIurj7mRBj+nIYs+vN/MPLN/0dM=;
        b=L4x1ROOiCcrVgjzt2EK2k1fqHrtmdmgQKsPLXEnaK+nZVzCEamzXG46bDeS137CMfH
         zcofDq4nbtpbFyT9mHFn866TORvhhiEQ7Gego32qOcME22eyV2JPFkuANpVj8uhOgSS3
         32h778J2TmR5U91ZYh6Odikkr8xYNaLzmxjezVlGICWu0VmSQHZMyh9rgCEkRdea3UsH
         Nm78kpmEq4dhqlKHq9Lxek6SU6u4sp1l1B/nEAAiEKXUlK4mxqpzOistpHTJPTKwEC1M
         uQQrUnNH9tf7EcCVxWOu0RH8391rmVFzP85pf+/kKiwe89DuJwvscdOmKYtzuZduuOdW
         4+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UvcJ/LZ7ZVgjhl8GiIurj7mRBj+nIYs+vN/MPLN/0dM=;
        b=nGPN14VZHlkvs5UrxR9VjmR0Tcm8FtxtrbRLE4Jsip/rIj/WsSyPv+lueTXWGqACkm
         qhHAUwtTRKgbn6I2xGEsnGWgWdYVWdHHgkdJpi/DY1H6BnxpYnQFIYx7cuCIF9YtFqg2
         OhRQ1cZg1AN1Oz/WlxEUf6tj+bKekFrYY02OCSbk7JOOHEi9kuodbdi8H2dNustBZKIa
         5ylknuEI5MixGPs6+1DVq5cafuqvORvOj3pGe6ONAlb7tkHtKOqJNAn5k5FhB9JJ9EqC
         0SMQiYLMOXhqXijw80/T5UNiM8T4oiTqT8o7l7xVQmQF/FxhcSJtGXtY+O6eTBbQMR/g
         BM2A==
X-Gm-Message-State: AOAM5318kwXpJauGgKIUOCwA0l9kmsjoPfhEjedozwQxgWhGq/VDW1FR
        juYrDfdfdt4Nsai6wXnnwiV7e9FnMXlX5in5jyzPFw==
X-Google-Smtp-Source: ABdhPJxzGGimaYxdhkmLIADTbPTcw/eh4c6LIFlX3rb/qPo18qFlMzLU/wWeAbTPcxNP+TJBMU2jGxnEfk+FNB695Go=
X-Received: by 2002:aa7:c3d3:: with SMTP id l19mr24446309edr.366.1607937150984;
 Mon, 14 Dec 2020 01:12:30 -0800 (PST)
MIME-Version: 1.0
References: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
 <1607598951-2340-3-git-send-email-loic.poulain@linaro.org> <20201212125544.4857b1cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212125544.4857b1cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 14 Dec 2020 10:19:07 +0100
Message-ID: <CAMZdPi8JGnEn1BbsX2jP_bNAGPrSz=eL2ZJ5n_2ReqGP2jpdOg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] net: mhi: Add dedicated alloc thread
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sat, 12 Dec 2020 at 21:55, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Dec 2020 12:15:51 +0100 Loic Poulain wrote:
> > The buffer allocation for RX path is currently done by a work executed
> > in the system workqueue. The work to do is quite simple and consists
> > mostly in allocating and queueing as much as possible buffers to the MHI
> > RX channel.
> >
> > It appears that using a dedicated kthread would be more appropriate to
> > prevent
> > 1. RX allocation latency introduced by the system queue
>
> System work queue should not add much latency, you can also create your
> own workqueue. Did you intend to modify the priority of the thread you
> create?

No, and I don't, since I assume there is no reason to prioritize
network over other loads. I've considered the dedicated workqueue, but
since there is only one task to run as a while loop, I thought using a
kthread was more appropriate (and slightly lighter), but I can move to
that solution if you recommend it.

>
> > 2. Unbounded work execution, the work only returning when queue is
> > full, it can possibly monopolise the workqueue thread on slower systems.
>
> Is this something you observed in practice?

No, I've just observed that work duration is inconstant , queuing from
few buffers to several hundreeds. This unbounded behavior makes me
feel that doing that in the shared sytem workqueue is probably not the
right place. I've not tested on a slower machine though.

>
> > This patch replaces the system work with a simple kthread that loops on
> > buffer allocation and sleeps when queue is full. Moreover it gets rid
> > of the local rx_queued variable (to track buffer count), and instead,
> > relies on the new mhi_get_free_desc_count helper.
>
> Seems unrelated, should probably be a separate patch.

I can do that.

>
> > After pratical testing on a x86_64 machine, this change improves
> > - Peek throughput (slightly, by few mbps)
> > - Throughput stability when concurrent loads are running (stress)
> > - CPU usage, less CPU cycles dedicated to the task
>
> Do you have an explanation why the CPU cycles are lower?

For CPU cycles, TBH, not really, this is just observational. Regarding
throughput stability, it's certainly because the work can consume all
its dedicated kthread time.

>
> > Below is the powertop output for RX allocation task before and after
> > this change, when performing UDP download at 6Gbps. Mostly to highlight
> > the improvement in term of CPU usage.
> >
> > older (system workqueue):
> > Usage       Events/s    Category       Description
> > 63,2 ms/s     134,0        kWork          mhi_net_rx_refill_work
> > 62,8 ms/s     134,3        kWork          mhi_net_rx_refill_work
> > 60,8 ms/s     141,4        kWork          mhi_net_rx_refill_work
> >
> > newer (dedicated kthread):
> > Usage       Events/s    Category       Description
> > 20,7 ms/s     155,6        Process        [PID 3360] [mhi-net-rx]
> > 22,2 ms/s     169,6        Process        [PID 3360] [mhi-net-rx]
> > 22,3 ms/s     150,2        Process        [PID 3360] [mhi-net-rx]
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  v2: add module parameter for changing RX refill level
>
> > @@ -16,6 +17,11 @@
> >  #define MHI_NET_MAX_MTU              0xffff
> >  #define MHI_NET_DEFAULT_MTU  0x4000
> >
> > +static unsigned int rx_refill_level = 70;
> > +module_param(rx_refill_level, uint, 0600);
> > +MODULE_PARM_DESC(rx_refill_level,
> > +              "The minimal RX queue level percentage (0 to 100) under which the RX queue must be refilled");
>
> Sorry you got bad advice in v1 and I didn't catch it. Please avoid
> adding module parameters. Many drivers do bulk refill, and don't need
> and extra parametrization, I don't see why this one would be special -
> if it is please explain.

Ok, going to revert that.

>
> >  struct mhi_net_stats {
> >       u64_stats_t rx_packets;
> >       u64_stats_t rx_bytes;
> > @@ -25,7 +31,6 @@ struct mhi_net_stats {
> >       u64_stats_t tx_bytes;
> >       u64_stats_t tx_errors;
> >       u64_stats_t tx_dropped;
> > -     atomic_t rx_queued;
> >       struct u64_stats_sync tx_syncp;
> >       struct u64_stats_sync rx_syncp;
> >  };
> > @@ -33,17 +38,66 @@ struct mhi_net_stats {
> >  struct mhi_net_dev {
> >       struct mhi_device *mdev;
> >       struct net_device *ndev;
> > -     struct delayed_work rx_refill;
> > +     struct task_struct *refill_task;
> > +     wait_queue_head_t refill_wq;
> >       struct mhi_net_stats stats;
> >       u32 rx_queue_sz;
> > +     u32 rx_refill_level;
> >  };
> >
> > +static int mhi_net_refill_thread(void *data)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = data;
> > +     struct net_device *ndev = mhi_netdev->ndev;
> > +     struct mhi_device *mdev = mhi_netdev->mdev;
> > +     int size = READ_ONCE(ndev->mtu);
> > +     struct sk_buff *skb;
> > +     int err;
> > +
> > +     while (1) {
> > +             err = wait_event_interruptible(mhi_netdev->refill_wq,
> > +                                            !mhi_queue_is_full(mdev, DMA_FROM_DEVICE)
> > +                                            || kthread_should_stop());
> > +             if (err || kthread_should_stop())
> > +                     break;
> > +
> > +             skb = netdev_alloc_skb(ndev, size);
> > +             if (unlikely(!skb)) {
> > +                     /* No memory, retry later */
> > +                     schedule_timeout_interruptible(msecs_to_jiffies(250));
>
> You should have a counter for this, at least for your testing. If this
> condition is hit it'll probably have a large impact on the performance.

Indeed, going to do that, what about a ratelimited error? I assume if
it's happen, system is really in bad shape.

>
> > +                     continue;
> > +             }
> > +
> > +             err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
> > +             if (unlikely(err)) {
> > +                     net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> > +                                         ndev->name, err);
> > +                     kfree_skb(skb);
> > +                     break;
> > +             }
> > +
> > +             /* Do not hog the CPU */
> > +             cond_resched();
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  static int mhi_ndo_open(struct net_device *ndev)
> >  {
> >       struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> > +     unsigned int qsz = mhi_netdev->rx_queue_sz;
> >
> > -     /* Feed the rx buffer pool */
> > -     schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> > +     if (rx_refill_level >= 100)
> > +             mhi_netdev->rx_refill_level = 1;
> > +     else
> > +             mhi_netdev->rx_refill_level = qsz - qsz * rx_refill_level / 100;
>
> So you're switching from 50% fill level to 70%. Are you sure that's not
> the reason the performance gets better? Did you experiments with higher
> fill levels?

No, I've tested both levels with the two solutions, It's just that
after experiment, high throughput is a bit more stable with 70%. So I
can revert back to 50% to avoid confusion and keep that for a
subsequent change.

Thanks,
Loic
