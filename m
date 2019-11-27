Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DE310B429
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfK0RLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 12:11:54 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:44908 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfK0RLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 12:11:54 -0500
Received: by mail-yb1-f193.google.com with SMTP id g38so9249744ybe.11
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 09:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P4E0X1KTtJAqZqyxDK0VFTq4pJ9XPn+fW/DslJYc6hc=;
        b=kAHZhIakDOYyfAs6v4DHj20mNPjlKgTSNYerZVBtbG7XpHMrcIgnArZeKbxseg1Fb0
         dxsnWwtVv7Ip5gtwlUXMVseG80MGEYi0wS8DYewUD9pd2TJaR75oFQadMuIsuvro8/GR
         IOKfCIBC3ujULdUgB44Upr8IQVMxjDdvf7ibR5GABJzOPZTtTz1+UCcYkBrWNPX4oX2y
         dre9+gsum8EbvT2U8m+ilfCZUYVBpYC261G41EX3OaeL68OTW7JF89WSsXV7s9+Rw9Ey
         u+kyxZzYN/M4NyP6QWAW4b5AfUSo4WrhQKk+bbmy5+fud/R0D0SiHLoTaWy46iz3CAOC
         gX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P4E0X1KTtJAqZqyxDK0VFTq4pJ9XPn+fW/DslJYc6hc=;
        b=H9484BWfUzhOXEzNTXwda8kQoboqH09vucM3PeAbJUo+4stZkxqIFkf6R3EyVMsV15
         P8f3Q9nTDNiyDlHdmiYC6kRzy++Xlj4zioIJzOn2GyYLKrFheOpQFgNvxVs2lMPQ5c4y
         Reb9KjlPDqc3ukg7wV/m+FkgCLeVsz0w29je+GC7bE2DrKHBcob33Cvr1wxoxrQnMSAf
         iQbPSTQZOd4lnSMNcySRgZ9xQAlV4TZtbX/KOMsbm8ZLjrkuhMMv/0UxLy/fPzSbMuh8
         StySo268GSUNAmaZUxDILRnJGFr2c676lzRkhr8I0xA+JkPnEYISqBiegwWU+RKiHK0H
         qDrQ==
X-Gm-Message-State: APjAAAU/OsnpUsGe42ikGVbfX50lBx0Z7OlpKD6eipZmEsoCyxFdJXS/
        7xFZqpPVnJLzmEUAnj1XRk0wtY/NDYSxUQ9rjNd8Mw==
X-Google-Smtp-Source: APXvYqw0YzsLPWWbctzZxiEVF5Ucwi5/uTE0QliDd0JnSoXXDS/20oYQF/Merwqu0kQZDvePaOF9qqLU3VwV/pQpgiA=
X-Received: by 2002:a25:4095:: with SMTP id n143mr31109268yba.364.1574874712244;
 Wed, 27 Nov 2019 09:11:52 -0800 (PST)
MIME-Version: 1.0
References: <20191126222013.1904785-1-bigeasy@linutronix.de>
 <20191126222013.1904785-3-bigeasy@linutronix.de> <CANn89iJtCwB=RdYnAYXU-uZvv=gHJgYD=dcfhohuLi_Qjfv6Ag@mail.gmail.com>
 <20191127093521.6achiubslhv7u46c@linutronix.de> <CANn89iL=q2wwjdSj1=veBE0hDATm_K=akKhz3Dyddnk28DRJhg@mail.gmail.com>
In-Reply-To: <CANn89iL=q2wwjdSj1=veBE0hDATm_K=akKhz3Dyddnk28DRJhg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Nov 2019 09:11:40 -0800
Message-ID: <CANn89i+Aje5j2iJDoq9FCU966kxC-gaD=ObxwVL49VC9L85_vA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: gro: Let the timeout timer expire in softirq
 context with `threadirqs'
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resent in non HTML mode :/

Long story short, why hrtimer are not by default using threaded mode
in threadirqs mode ?

Idea of having some (but not all of them) hard irq handlers' now being
run from BH mode,
is rather scary.

Also, hrtimers got the SOFT thing only in 4.16, while the GRO patch
went in linux-3.19

What would be the plan for stable trees ?


On Wed, Nov 27, 2019 at 8:15 AM Eric Dumazet <edumazet@google.com> wrote:
>
>
>
> On Wed, Nov 27, 2019 at 1:35 AM Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>>
>> On 2019-11-26 14:39:47 [-0800], Eric Dumazet wrote:
>> > On Tue, Nov 26, 2019 at 2:20 PM Sebastian Andrzej Siewior
>> > <bigeasy@linutronix.de> wrote:
>> > >
>> > > The timer callback (napi_watchdog()) invokes __napi_schedule_irqoff()
>> > > with disabled interrupts. With the `threadirqs' commandline option all
>> > > interrupt handler are threaded and using __napi_schedule_irqoff() is not
>> > > an issue because everyone is using it in threaded context which is
>> > > synchronised with local_bh_disable().
>> > > The napi_watchdog() timer is still expiring in hardirq context and may
>> > > interrupt a threaded handler which is in the middle of
>> > > __napi_schedule_irqoff() leading to list corruption.
>> >
>> > Sorry, I do not understand this changelog.
>> >
>> > Where/how do you get list corruption  exactly ?
>> >
>> >  __napi_schedule_irqoff() _has_ to be called with hard IRQ disabled.
>> >
>> > Please post a stack trace.
>>
>> I don't have a stack trace, this is based on review.
>> __napi_schedule_irqoff() is used in IRQ context and this is only the
>> primary IRQ handler. There is no other in-IRQ usage (like SMP-function
>> call or so (excluding the HV network driver)) but there is the hrtimer.
>>
>> With `threadirqs' you don't have the in-IRQ usage from the IRQ handler
>> anymore. The IRQ-handler for two different NICs don't interrupt/
>> preempt each other because the handler is invoked with disabled softirq
>> (which also disables preemption). This is all safe.
>> The hrtimer fires always in IRQ context no matter if `threadirqs' is
>> used or not. Which brings us to the following race condition:
>>
>> One CPU, 2 NICs:
>>
>>     threaded_IRQ of NIC1                     hard-irq context, hrtimer
>>        local_bh_disable()
>>          nic_irq_handler()
>>           if (napi_schedule_prep())
>>             __napi_schedule_irqoff()
>
>
> And _which_ driver would call this variant without being sure hard irq are disabled ?
>
> Hard irq handlers are supposed to run with hard irq being disabled.
>
> Who decided that this was no longer the case ?
> This conflicts with hrtimer being delivered from hard irq context, this is the root cause of the problem.
>
> You are telling us napi_schedule_irqoff() should never be used, because we do not know if hard irqs are masked or not.
>
> Honestly this is a nightmare, we can not trust anymore stuff that has been settled 20 years ago.
>
> If you want to get rid of hard irq completely, make all handlers being run from threaded_IRQ,
> not only a subset of them ?
>
>
>>
>>                ____napi_schedule(this_cpu_ptr(&softnet_data), n);
>> ->               list_add_tail(, &sd->poll_list);
>>
>>                                         hrtimer_interrupt()
>>                                           __hrtimer_run_queues()
>>                                              napi_watchdog()
>>                                                __napi_schedule_irqoff()
>>                                                ____napi_schedule(this_cpu_ptr(&softnet_data), n);
>> ->                                               list_add_tail(&napi->poll_list, &sd->poll_list);
>>
>> The same per-CPU list modified again.
>> If the callback is moved to softirq instead:
>>
>>     threaded_IRQ of NIC1                     hard-irq context, hrtimer
>>        local_bh_disable()
>>          nic_irq_handler()
>>           if (napi_schedule_prep())
>>             __napi_schedule_irqoff()
>>                ____napi_schedule(this_cpu_ptr(&softnet_data), n);
>> ->               list_add_tail(, &sd->poll_list);
>>
>>                                         hrtimer_interrupt()
>>                                           raise_softirq_irqoff(HRTIMER_SOFTIRQ);
>>                  list_add_tail() completes
>>        local_bh_enable()
>>           if (unlikely(!in_interrupt() && local_softirq_pending())) {
>>              do_softirq();
>>                                                napi_watchdog()
>>                                                  __napi_schedule_irqoff()
>>                                                    ____napi_schedule(this_cpu_ptr(&softnet_data), n);
>>                                                      list_add_tail(, &sd->poll_list);
>>
>> > > Let the napi_watchdog() expire in softirq context if `threadirqs' is
>> > > used.
>> > >
>> > > Fixes: 3b47d30396bae ("net: gro: add a per device gro flush timer")
>> >
>> > Are you sure this commit is the root cause of the problem you see ?
>>
>> This commit was introduced in v3.19-rc1 and threadirqs was introduced in
>> commit
>>    8d32a307e4faa ("genirq: Provide forced interrupt threading")
>>
>> which is v2.6.39-rc1. Based on my explanation above this problem exists
>> with the timer and `threadirqs'. The hrtimer always expired in hardirq
>> context.
>>
>> > > Cc: Eric Dumazet <edumazet@google.com>
>> > > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> > > ---
>> > >  net/core/dev.c | 6 +++++-
>> > >  1 file changed, 5 insertions(+), 1 deletion(-)
>> > >
>> > > diff --git a/net/core/dev.c b/net/core/dev.c
>> > > index 99ac84ff398f4..ec533d20931bc 100644
>> > > --- a/net/core/dev.c
>> > > +++ b/net/core/dev.c
>> > > @@ -5994,6 +5994,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
>> > >                 napi_gro_flush(n, !!timeout);
>> > >                 if (timeout)
>> > >                         hrtimer_start(&n->timer, ns_to_ktime(timeout),
>> > > +                                     force_irqthreads ?
>> >
>> > Honestly something is wrong with this patch, force_irqthreads should
>> > not be used in net/ territory,
>> > that is some layering problem.
>>
>> I'm not aware of an other problems of this kind.
>> Most drivers do spin_lock_irqsave() and in that case in does not matter
>> if the interrupt is threaded or not vs the hrtimer callback. Which means
>> they do not assume that the IRQ handler runs with interrupts disabled.
>
>
> Most NIC drivers simply raises a softirq.
>
>>
>> The timeout timers are usually timer_list timer which run in softirq
>> context and since the force-IRQ-thread runs also with disabled softirq
>> it is fine using just spin_lock().
>>
>> If you don't want this here maybe tglx can add some hrtimer annotation.
>
>
> I only want to understand how many other points in the stack we have to audit and ' fix' ...
>
>>
>>
>> Sebastian
