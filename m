Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293553B7C50
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 05:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhF3D7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 23:59:43 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:52057 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbhF3D7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 23:59:42 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jun 2021 23:59:42 EDT
Received: (qmail 68920 invoked by uid 89); 30 Jun 2021 03:50:33 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 30 Jun 2021 03:50:33 -0000
Date:   Tue, 29 Jun 2021 20:50:31 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
 <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
 <20210630000933.GA21533@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630000933.GA21533@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 05:09:33PM -0700, Richard Cochran wrote:
> On Mon, Jun 28, 2021 at 05:19:28PM -0700, Jonathan Lemon wrote:
> > This fits in nicely with the extts event model.  I really
> > don't want to have to re-invent another ptp_chardev device
> > that does the same thing - nor recreate a extended PTP.
> 
> If you have two clocks, then you should expose two PHC devices.
> 
> If you want to compare two PHC in hardware, then we can have a new
> syscall for that, like clock_compare(clock_t a, clock_t b);

This isn't what I'm doing - there is only one clock.

The PHC should be sync'd to the PPS coming from the GPS signal.
However, the GPS may be in holdover, so the actual counter comes
from an atomic oscillator.  As the oscillator may be ever so 
slightly out of sync with the GPS (or drifts with temperature),
so we need to measure the phase difference between the two and
steer the oscillator slightly.

The phase comparision between the two signals is done in HW 
with a phasemeter, for precise comparisons.  The actual phase
steering/adjustment is done through adjphase().

What's missing is the ability to report the phase difference
to user space so the adjustment can be performed.

Signal reporting to user space is already in place by 
doing a read(/dev/ptp), which returns:

struct ptp_extts_event {
        struct ptp_clock_time t; /* Time event occured. */
        unsigned int index;      /* Which channel produced the event. */
        unsigned int flags;      /* Reserved for future use. */
        unsigned int rsv[2];     /* Reserved for future use. */
}

This is exactly what I want, with the additional feature
of returning the phase difference in a one of the rsv[] words,
and perhaps also using the flags word to indicate usage of the 
reserved field.

Since these events are channel specific, I don't see why
this is problematic.  The code blocks in question from my
upcoming patch (dependent on this) is:

    static irqreturn_t
    ptp_ocp_phase_irq(int irq, void *priv)
    {
            struct ptp_ocp_ext_src *ext = priv;
            struct ocp_phase_reg __iomem *reg = ext->mem;
            struct ptp_clock_event ev;
            u32 phase_error;

            phase_error = ioread32(&reg->phase_error);

            ev.type = PTP_CLOCK_EXTTSUSR;
            ev.index = ext->info->index;
            ev.data = phase_error;
            pps_get_ts(&ev.pps_times);

            ptp_clock_event(ext->bp->ptp, &ev);

            iowrite32(0, &reg->intr);

            return IRQ_HANDLED;
    }

and

    static irqreturn_t
    ptp_ocp_ts_irq(int irq, void *priv)
    {
            struct ptp_ocp_ext_src *ext = priv;
            struct ts_reg __iomem *reg = ext->mem;
            struct ptp_clock_event ev;

            ev.type = PTP_CLOCK_EXTTSUSR;
            ev.index = ext->info->index;
            ev.pps_times.ts_real.tv_sec = ioread32(&reg->time_sec);
            ev.pps_times.ts_real.tv_nsec = ioread32(&reg->time_ns);
            ev.data = ioread32(&reg->ts_count);

            ptp_clock_event(ext->bp->ptp, &ev);

            iowrite32(1, &reg->intr);       /* write 1 to ack */

            return IRQ_HANDLED;
    }


I'm not seeing why this is controversial.
-- 
Jonathan
