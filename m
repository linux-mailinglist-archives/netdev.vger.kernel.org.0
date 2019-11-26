Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC8F10A6AE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfKZWkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:40:00 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:44773 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfKZWkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:40:00 -0500
Received: by mail-yw1-f66.google.com with SMTP id p128so7602540ywc.11
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 14:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9koSZGkEf9iOjC/1zwUXmEbvorX6/QRVtA7SgPYRtp8=;
        b=iHMVLEJ4WhKRLTNhXTvrZAKWGqLFQuxLlTeLWpiJkHb/SrJT2cwelNdZqcl1DiS63R
         AcstCy34tk4DaxhvXKOUpLsYI4R3jofLlv8J0+gGl0M8pH8m3T/le7lZXEW8TDYRTcp7
         J/VBJmj+JEaxAM6JEq7mgvGiguehp/X9SmfrbeNFOdTIvQ4/qJLZsEDeiJP8e0fYAaJo
         4nFtDgy6v9PUCNSoqPauzUtrYbYAYFuH4i3crDzUSXG+6gW7Z7gm2j7lCdtN8QGB4wpd
         pl5Nug7Xe4+J3TH3ZD7WeohvZnmGd2uy1zeqSJ3znLJ3ImD6628UJyEMoXlYx1K5AUyS
         uK4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9koSZGkEf9iOjC/1zwUXmEbvorX6/QRVtA7SgPYRtp8=;
        b=r9b4FwEgQ20MRVyAcpGytitSHOo3aurkqcXxx5keGC+3mhcuSHcAfoRR2oM3g54Qjx
         ZUWk9Q286cGu+uALFgC1B21VhimTTaAe9t6kg2uqFoZ5wPqSCWCZfO8kwZrWTHBOMHhN
         zmwpZN6ykACiiLVQLyt/1hvyPffZrWdP7RAasBtWs7V7r6uxnZGiYqaqBJ0/VJ8oWmXE
         aUPHN2u79HqnHQmE5SIkvUB2prbnhZhRPYM/JRCRuC+zBr5JsjtBAtZnqfoWKSBcklgj
         kNByo7P2ljn2CIG7rWLBn166TNRanQIExqIsxCrkzgwpHRvxN4aghRuyyJlROOHtS8mK
         G5lg==
X-Gm-Message-State: APjAAAWQEXW6u5PsMMlPzLu11KyvzghwdhjcFUwJTvMUi8xMWIk5YIga
        zYO2KHgihoTu3V4u2Izd3/e98vqWornHmYgFgnxD/Q==
X-Google-Smtp-Source: APXvYqyr+0g24S50iGmjVOfcd40w2HwYATqzOAlH6H+WooAIHc7s7yyziVi+bCJ8NGvA4XOMs1Bcb7gRrN0uImgyrag=
X-Received: by 2002:a0d:e4c1:: with SMTP id n184mr766541ywe.174.1574807999086;
 Tue, 26 Nov 2019 14:39:59 -0800 (PST)
MIME-Version: 1.0
References: <20191126222013.1904785-1-bigeasy@linutronix.de> <20191126222013.1904785-3-bigeasy@linutronix.de>
In-Reply-To: <20191126222013.1904785-3-bigeasy@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Nov 2019 14:39:47 -0800
Message-ID: <CANn89iJtCwB=RdYnAYXU-uZvv=gHJgYD=dcfhohuLi_Qjfv6Ag@mail.gmail.com>
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

On Tue, Nov 26, 2019 at 2:20 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The timer callback (napi_watchdog()) invokes __napi_schedule_irqoff()
> with disabled interrupts. With the `threadirqs' commandline option all
> interrupt handler are threaded and using __napi_schedule_irqoff() is not
> an issue because everyone is using it in threaded context which is
> synchronised with local_bh_disable().
> The napi_watchdog() timer is still expiring in hardirq context and may
> interrupt a threaded handler which is in the middle of
> __napi_schedule_irqoff() leading to list corruption.

Sorry, I do not understand this changelog.

Where/how do you get list corruption  exactly ?

 __napi_schedule_irqoff() _has_ to be called with hard IRQ disabled.

Please post a stack trace.


>
> Let the napi_watchdog() expire in softirq context if `threadirqs' is
> used.
>
> Fixes: 3b47d30396bae ("net: gro: add a per device gro flush timer")

Are you sure this commit is the root cause of the problem you see ?



> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  net/core/dev.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 99ac84ff398f4..ec533d20931bc 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5994,6 +5994,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
>                 napi_gro_flush(n, !!timeout);
>                 if (timeout)
>                         hrtimer_start(&n->timer, ns_to_ktime(timeout),
> +                                     force_irqthreads ?

Honestly something is wrong with this patch, force_irqthreads should
not be used in net/ territory,
that is some layering problem.

> +                                     HRTIMER_MODE_REL_PINNED_SOFT :
>                                       HRTIMER_MODE_REL_PINNED);
>         }
>         if (unlikely(!list_empty(&n->poll_list))) {
> @@ -6225,7 +6227,9 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>                     int (*poll)(struct napi_struct *, int), int weight)
>  {
>         INIT_LIST_HEAD(&napi->poll_list);
> -       hrtimer_init(&napi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
> +       hrtimer_init(&napi->timer, CLOCK_MONOTONIC,
> +                    force_irqthreads ?
> +                    HRTIMER_MODE_REL_PINNED_SOFT : HRTIMER_MODE_REL_PINNED);
>         napi->timer.function = napi_watchdog;
>         init_gro_hash(napi);
>         napi->skb = NULL;
> --
> 2.24.0
>
