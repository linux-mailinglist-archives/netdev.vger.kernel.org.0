Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DE137EFAB
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhELXV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 19:21:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54344 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349051AbhELW3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 18:29:15 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620858482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dbExWGmhAxDcnpIgmHu93oDV58dpmOJ47YHdt243Bzg=;
        b=ybSj//OuakWBcE9PFkav7BwyUiw4YIXlu6sm+YQbs5K5F9vAhiXHxGoRqsjAIIk9Z4Exdu
        iUSWgfopq4ollgGXfovb/QMhv/93JoH6KqCWKIV2R84J8+BhDv9PecLjEzoBBhyaLnXUqf
        Ksvtye4YM67a1SEyvy5lsM02RpjGcYQjJackZ7C1Pn68a+B2o8BWnme9OWEwF0WDVlhva9
        L0TgeLECnUq1VzroBmzZuMKvFIlbTlNZjUM2ihtYvUQC1g/5zgn0iQXTqPpicbflZOCJBs
        cO2hfNCxT8ts2WWiOkEZsqaBS3PBpPx0uh/Q2f63eIidLS0T0oYuaFO2So2oNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620858482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dbExWGmhAxDcnpIgmHu93oDV58dpmOJ47YHdt243Bzg=;
        b=ieszU9eoLPxYgVaGjO90h6D6agB93TQK5gB7qgQ6Dyy4ZeLzKtYjgqHC9nrgPPbzmjncfl
        86BCJ4FTEN6icrCg==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, sassmann@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable-rt@vger.kernel.org
Subject: Re: [PATCH net-next] net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT
In-Reply-To: <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
References: <YJofplWBz8dT7xiw@localhost.localdomain> <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
Date:   Thu, 13 May 2021 00:28:02 +0200
Message-ID: <87k0o360zx.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12 2021 at 23:43, Sebastian Andrzej Siewior wrote:
> __napi_schedule_irqoff() is an optimized version of __napi_schedule()
> which can be used where it is known that interrupts are disabled,
> e.g. in interrupt-handlers, spin_lock_irq() sections or hrtimer
> callbacks.
>
> On PREEMPT_RT enabled kernels this assumptions is not true. Force-
> threaded interrupt handlers and spinlocks are not disabling interrupts
> and the NAPI hrtimer callback is forced into softirq context which runs
> with interrupts enabled as well.
>
> Chasing all usage sites of __napi_schedule_irqoff() is a whack-a-mole
> game so make __napi_schedule_irqoff() invoke __napi_schedule() for
> PREEMPT_RT kernels.
>
> The callers of ____napi_schedule() in the networking core have been
> audited and are correct on PREEMPT_RT kernels as well.
>
> Reported-by: Juri Lelli <juri.lelli@redhat.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

> ---
> Alternatively __napi_schedule_irqoff() could be #ifdef'ed out on RT and
> an inline provided which invokes __napi_schedule().
>
> This was not chosen as it creates #ifdeffery all over the place and with
> the proposed solution the code reflects the documentation consistently
> and in one obvious place.

Blame me for that decision.

No matter which variant we end up with, this needs to go into all stable
RT kernels ASAP.

Thanks,

        tglx
