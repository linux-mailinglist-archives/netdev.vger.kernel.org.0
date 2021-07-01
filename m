Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1A03B9495
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 18:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhGAQS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 12:18:29 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:30452 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhGAQS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 12:18:29 -0400
Received: (qmail 69747 invoked by uid 89); 1 Jul 2021 16:15:56 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 1 Jul 2021 16:15:56 -0000
Date:   Thu, 1 Jul 2021 09:15:55 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210701161555.y4p6wz6l6e6ea2vg@bsd-mbp.dhcp.thefacebook.com>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
 <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
 <20210630000933.GA21533@hoboy.vegasvil.org>
 <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
 <20210701145935.GB22819@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701145935.GB22819@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 07:59:35AM -0700, Richard Cochran wrote:
> On Tue, Jun 29, 2021 at 08:50:31PM -0700, Jonathan Lemon wrote:
> 
> > Since these events are channel specific, I don't see why
> > this is problematic.
> 
> The problem is that the semantics of ptp_clock_event::data are not
> defined...
> 
> > The code blocks in question from my
> > upcoming patch (dependent on this) is:
> > 
> >     static irqreturn_t
> >     ptp_ocp_phase_irq(int irq, void *priv)
> >     {
> >             struct ptp_ocp_ext_src *ext = priv;
> >             struct ocp_phase_reg __iomem *reg = ext->mem;
> >             struct ptp_clock_event ev;
> >             u32 phase_error;
> > 
> >             phase_error = ioread32(&reg->phase_error);
> > 
> >             ev.type = PTP_CLOCK_EXTTSUSR;
> >             ev.index = ext->info->index;
> >             ev.data = phase_error;
> >             pps_get_ts(&ev.pps_times);
> 
> Here the time stamp is the system time, and the .data field is the
> mysterious "phase_error", but ...

Yes, the time here is not really relevant.


  
> >             ptp_clock_event(ext->bp->ptp, &ev);
> > 
> >             iowrite32(0, &reg->intr);
> > 
> >             return IRQ_HANDLED;
> >     }
> > 
> > and
> > 
> >     static irqreturn_t
> >     ptp_ocp_ts_irq(int irq, void *priv)
> >     {
> >             struct ptp_ocp_ext_src *ext = priv;
> >             struct ts_reg __iomem *reg = ext->mem;
> >             struct ptp_clock_event ev;
> > 
> >             ev.type = PTP_CLOCK_EXTTSUSR;
> >             ev.index = ext->info->index;
> >             ev.pps_times.ts_real.tv_sec = ioread32(&reg->time_sec);
> >             ev.pps_times.ts_real.tv_nsec = ioread32(&reg->time_ns);
> >             ev.data = ioread32(&reg->ts_count);
> 
> here the time stamp comes from the PHC device, apparently, and the
> .data field is a counter.
> 
> >             ptp_clock_event(ext->bp->ptp, &ev);
> > 
> >             iowrite32(1, &reg->intr);       /* write 1 to ack */
> > 
> >             return IRQ_HANDLED;
> >     }
> > 
> > 
> > I'm not seeing why this is controversial.
> 
> Simply put, it makes no sense to provide a new PTP_CLOCK_EXTTSUSR that
> has multiple, random meanings.  There has got to be a better way.

I agree with this.  I just talked to the HW folks, and they're willing
to change things so 2 PPS events are returned, which eliminates the need
for an internal comparator.  The returned time would come from a latched
value from a HW register (same as the ptp_ocp_ts_irq version above).

I'm still stuck with how to provide the sec/nsec from the hardware 
directly to the application, though, since the current code does:

static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
                                       struct ptp_clock_event *src)
{
        struct ptp_extts_event *dst;
        unsigned long flags;
        s64 seconds;
        u32 remainder;

        seconds = div_u64_rem(src->timestamp, 1000000000, &remainder);


It seems like there should be a way to use pps_times here instead
of needing to convert back and forth.
-- 
Jonathan
