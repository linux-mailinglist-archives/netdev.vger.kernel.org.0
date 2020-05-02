Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C6C1C26A1
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 17:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgEBPlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 11:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgEBPlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 11:41:11 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC016C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 08:41:10 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id f5so341673ybo.4
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 08:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WBz1khyyRIZ26DEeS2VOm9uxpEAR3SltqhVlMoSLYoc=;
        b=J9X82UI6waS+4dW6HZUplziu4XgkSx6qrhVMLyPS/6PXA4DUERm/skrtJeN0LHCxOt
         uwHN+RYIYwH0g9VBS9EC6NuBN7SBWZyX93MgO7LylN6mAcCYolJyjOtqxCFOuBEBi8r9
         8OwLxb9b1RJj1nV7f7/9kqNLErEkQNUuwKC11pMW/bK8GpP89LfEEA32/dQ/GJJ9GwHN
         cxtVM8wDNgwF0RIhLLLPSC+frrVKJNQbv7warIbrf+sDXzSZw1L1SPH6yaBtMTiGxtJ2
         xM1GOxTC+ruIPv8886LBgL5gj3AO8gyPssLDLtHRluSecS2Rd+cs3j3PNpDFO3SbKTPJ
         iZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBz1khyyRIZ26DEeS2VOm9uxpEAR3SltqhVlMoSLYoc=;
        b=IXP41wsIPw4vUEWw7e6m7extviHB1d8c9J29gckfadqFzDFkpA2envhQZjPZu0YngC
         Lgu1Xj/Mi26aUpnGMfstrpcM1eqpZyFJcyb26Q0tKMddrKoKLX31J8m0aorBGLl9hXrp
         451S+8GLKtvc+uwhyJol+Bda76RJ2TvCjVamebsmBT16kpAJgt0dPfjB1ZJPBedU2ftk
         2Xrc26ZAxCG22ev6osuzyWxIb+8OivvN0ZrGgTcdciJ38noqJVnoZWkhQVTSxTbg/H+W
         AZ1wiEwFaNm+Y3vM6EWvefU0EZd2xBtX79WSwieM6SQwUX6qa62ruoePdho2RKttDYzM
         q4MA==
X-Gm-Message-State: AGi0Pub9Pc5GN1rxSXOCWUupc3UY2XlAIPRUJafVENDefQhRcmTjafxX
        s49UPu05s799XX270zGmamt/fEZagcnRGFshaLoH4w==
X-Google-Smtp-Source: APiQypLS7TY1rvdfWpDQLvPdkLfY6xp8o/4O56KaTMQx7xKA5RId0chrWAEvsLH5XmeGG18xOOzlzTkNFQYlWYCD1m0=
X-Received: by 2002:a25:6f86:: with SMTP id k128mr13987871ybc.520.1588434069856;
 Sat, 02 May 2020 08:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200422161329.56026-1-edumazet@google.com> <20200422161329.56026-2-edumazet@google.com>
 <a8f1fbf8-b25f-d3aa-27fe-11b1f0fdae3f@linux.ibm.com>
In-Reply-To: <a8f1fbf8-b25f-d3aa-27fe-11b1f0fdae3f@linux.ibm.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 2 May 2020 08:40:58 -0700
Message-ID: <CANn89iKid-JWYs6esRYo25NqVdLkLvn6uwiB7wLz_PXuREQQKA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: napi: add hard irqs deferral feature
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Luigi Rizzo <lrizzo@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 2, 2020 at 7:56 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>
> On 22.04.20 18:13, Eric Dumazet wrote:
> > Back in commit 3b47d30396ba ("net: gro: add a per device gro flush timer")
> > we added the ability to arm one high resolution timer, that we used
> > to keep not-complete packets in GRO engine a bit longer, hoping that further
> > frames might be added to them.
> >
> > Since then, we added the napi_complete_done() interface, and commit
> > 364b6055738b ("net: busy-poll: return busypolling status to drivers")
> > allowed drivers to avoid re-arming NIC interrupts if we made a promise
> > that their NAPI poll() handler would be called in the near future.
> >
> > This infrastructure can be leveraged, thanks to a new device parameter,
> > which allows to arm the napi hrtimer, instead of re-arming the device
> > hard IRQ.
> >
> > We have noticed that on some servers with 32 RX queues or more, the chit-chat
> > between the NIC and the host caused by IRQ delivery and re-arming could hurt
> > throughput by ~20% on 100Gbit NIC.
> >
> > In contrast, hrtimers are using local (percpu) resources and might have lower
> > cost.
> >
> > The new tunable, named napi_defer_hard_irqs, is placed in the same hierarchy
> > than gro_flush_timeout (/sys/class/net/ethX/)
> >
>
> Hi Eric,
> could you please add some Documentation for this new sysfs tunable? Thanks!
> Looks like gro_flush_timeout is missing the same :).


Yes. I was planning adding this in
Documentation/networking/scaling.rst, once our fires are extinguished.

>
>
> > By default, both gro_flush_timeout and napi_defer_hard_irqs are zero.
> >
> > This patch does not change the prior behavior of gro_flush_timeout
> > if used alone : NIC hard irqs should be rearmed as before.
> >
> > One concrete usage can be :
> >
> > echo 20000 >/sys/class/net/eth1/gro_flush_timeout
> > echo 10 >/sys/class/net/eth1/napi_defer_hard_irqs
> >
> > If at least one packet is retired, then we will reset napi counter
> > to 10 (napi_defer_hard_irqs), ensuring at least 10 periodic scans
> > of the queue.
> >
> > On busy queues, this should avoid NIC hard IRQ, while before this patch IRQ
> > avoidance was only possible if napi->poll() was exhausting its budget
> > and not call napi_complete_done().
> >
>
> I was confused here for a second, so let me just clarify how this is intended
> to look like for pure TX completion IRQs:
>
> napi->poll() calls napi_complete_done() with an accurate work_done value, but
> then still returns 0 because TX completion work doesn't consume NAPI budget.


If the napi budget was consumed, the driver does _not_ call
napi_complete() or napi_complete_done() anyway.

If the budget is consumed, then napi_complete_done(napi, X>0) allows
napi_complete_done()
to return 0 if napi_defer_hard_irqs is not 0

This means that the NIC hard irq will stay disabled for at least one more round.


>
>
> > This feature also can be used to work around some non-optimal NIC irq
> > coalescing strategies.
> >
> > Having the ability to insert XX usec delays between each napi->poll()
> > can increase cache efficiency, since we increase batch sizes.
> >
> > It also keeps serving cpus not idle too long, reducing tail latencies.
> >
> > Co-developed-by: Luigi Rizzo <lrizzo@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
