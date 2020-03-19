Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68FF18C398
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 00:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgCSXZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 19:25:55 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37834 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgCSXZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 19:25:55 -0400
Received: by mail-lf1-f65.google.com with SMTP id j11so3090599lfg.4;
        Thu, 19 Mar 2020 16:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xryJO8lkXqRCZQK2yjx1cRHjWBLO8IFysYsWxEoA3uE=;
        b=W4p7IqK840U96gHxPUFDwKRKl0DeyM62Cf4hK4MVxDeZLz/NuJnzVzNLCXHzzJPXw3
         cuO7UoACnyau5ntSIeAtexp74bDciO1/5FPGcp4uN5dfZOgTP1gdGS6uEx07EyMxxSuW
         UTG41vXaINQUcorBOvlljqNGUuDzQ/Gzdti5RddYiwIqkyU/TcLQoyujB40JItwp4I44
         aLE8124W9EF1NiPA2u/s7EaM8iAp9jTolVsVbLF6auvhBLnXqNVx2On8kwVpvS0Al6yh
         3ce8EGJVdi1kbQEQX8KtoqT37e1mM0eGUDk1WEofyR/5anu3exltpzmPFnsw6CUMrPmR
         10SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xryJO8lkXqRCZQK2yjx1cRHjWBLO8IFysYsWxEoA3uE=;
        b=MKcr+XdNyQCVdcT89qLObnS3T9lVEzJOuviZO3j+W/r3Zv8IaVhcZzet+GN3J8LP/E
         Yybjn6SmXRUwp9gYrh9i0i6MxqxVUu3Algmc5sdmjXT+fQdJmQF9C5xNGhLWRbWVjYyy
         w9wCTx8+ls84XsFk+6SBdGXg2fgr1yEqy20FBXp/0QF8H0RtIG77ny9HxEx8uEyKSugz
         bKwm7aUhBWNP6757hq7L1WkTEVG6EBzD48IrXtJcxRShetf1NkVF5gwdfb1zxSvh/6DE
         fkFqGhz9UhrWoRZ+E2cFXDmG92VHD9Mp8YgQpC+sHdcBRH7GRfnmMFib90IxMzgykkn8
         qDxw==
X-Gm-Message-State: ANhLgQ2Gj6xWISZgAGHPVfwZjf+u3YPECEtKCTvFyioTJGydiJHlVz3W
        nNsUSXGvaPyMHp9Tl3w0K7gZvu3gxjf68AIPgy4=
X-Google-Smtp-Source: ADFU+vutZe3vAn9jxlvO0kvX2a2rYQyzTHs+93M3VoF6k7ot+b480wfjbV128JnurPO8vWCARFUaoAdJ1D285cdVDEc=
X-Received: by 2002:a19:5504:: with SMTP id n4mr3537070lfe.149.1584660352957;
 Thu, 19 Mar 2020 16:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200318204302.693307984@linutronix.de> <20200318204408.521507446@linutronix.de>
In-Reply-To: <20200318204408.521507446@linutronix.de>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Fri, 20 Mar 2020 10:25:41 +1100
Message-ID: <CAGRGNgXAW14=8ntTiB_hJ_nLq7WC_oFR3N9BNjqVEZM=ze85tQ@mail.gmail.com>
Subject: Re: [patch V2 11/15] completion: Use simple wait queues
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On Thu, Mar 19, 2020 at 7:48 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> From: Thomas Gleixner <tglx@linutronix.de>
>
> completion uses a wait_queue_head_t to enqueue waiters.
>
> wait_queue_head_t contains a spinlock_t to protect the list of waiters
> which excludes it from being used in truly atomic context on a PREEMPT_RT
> enabled kernel.
>
> The spinlock in the wait queue head cannot be replaced by a raw_spinlock
> because:
>
>   - wait queues can have custom wakeup callbacks, which acquire other
>     spinlock_t locks and have potentially long execution times
>
>   - wake_up() walks an unbounded number of list entries during the wake up
>     and may wake an unbounded number of waiters.
>
> For simplicity and performance reasons complete() should be usable on
> PREEMPT_RT enabled kernels.
>
> completions do not use custom wakeup callbacks and are usually single
> waiter, except for a few corner cases.
>
> Replace the wait queue in the completion with a simple wait queue (swait),
> which uses a raw_spinlock_t for protecting the waiter list and therefore is
> safe to use inside truly atomic regions on PREEMPT_RT.
>
> There is no semantical or functional change:
>
>   - completions use the exclusive wait mode which is what swait provides
>
>   - complete() wakes one exclusive waiter
>
>   - complete_all() wakes all waiters while holding the lock which protects
>     the wait queue against newly incoming waiters. The conversion to swait
>     preserves this behaviour.
>
> complete_all() might cause unbound latencies with a large number of waiters
> being woken at once, but most complete_all() usage sites are either in
> testing or initialization code or have only a really small number of
> concurrent waiters which for now does not cause a latency problem. Keep it
> simple for now.
>
> The fixup of the warning check in the USB gadget driver is just a straight
> forward conversion of the lockless waiter check from one waitqueue type to
> the other.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
> V2: Split out the orinoco and usb gadget parts and amended change log
> ---
>  drivers/usb/gadget/function/f_fs.c |    2 +-
>  include/linux/completion.h         |    8 ++++----
>  kernel/sched/completion.c          |   36 +++++++++++++++++++-----------------
>  3 files changed, 24 insertions(+), 22 deletions(-)
>
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -1703,7 +1703,7 @@ static void ffs_data_put(struct ffs_data
>                 pr_info("%s(): freeing\n", __func__);
>                 ffs_data_clear(ffs);
>                 BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
> -                      waitqueue_active(&ffs->ep0req_completion.wait) ||
> +                      swait_active(&ffs->ep0req_completion.wait) ||

This looks like some code is reaching deep into the dirty dark corners
of the completion implementation, should there be some wrapper around
this to hide that?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
