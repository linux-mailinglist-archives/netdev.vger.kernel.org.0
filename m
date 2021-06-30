Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3D03B8AA9
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 00:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbhF3XAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 19:00:12 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:27288 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhF3XAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 19:00:08 -0400
Received: (qmail 51969 invoked by uid 89); 30 Jun 2021 22:57:35 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 30 Jun 2021 22:57:35 -0000
Date:   Wed, 30 Jun 2021 15:57:34 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210630225734.ymgdtzpwvyvj7gfa@bsd-mbp.dhcp.thefacebook.com>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
 <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
 <20210630000933.GA21533@hoboy.vegasvil.org>
 <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
 <20210630144257.GA30627@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630144257.GA30627@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 07:42:57AM -0700, Richard Cochran wrote:
> On Tue, Jun 29, 2021 at 08:50:31PM -0700, Jonathan Lemon wrote:
> > The PHC should be sync'd to the PPS coming from the GPS signal.
> > However, the GPS may be in holdover, so the actual counter comes
> > from an atomic oscillator.  As the oscillator may be ever so 
> > slightly out of sync with the GPS (or drifts with temperature),
> > so we need to measure the phase difference between the two and
> > steer the oscillator slightly.
> > 
> > The phase comparision between the two signals is done in HW 
> > with a phasemeter, for precise comparisons.  The actual phase
> > steering/adjustment is done through adjphase().
> 
> So you don't need the time stamp itself, just the phase offset, right?
> 
> > What's missing is the ability to report the phase difference
> > to user space so the adjustment can be performed.
> 
> So let's create an interface for that reporting.

The current 'struct ptp_extts_event' returns 32 bytes to userspace
for every event.  Of these, 16 bytes (50%) are unused, as the structure
only returns a timestamp + index, without any event information.

It seems logical that these unused bytes (which are event specific)
could be used to convey more information about the event itself.


> It is about getting the right interface.  The external time stamp
> interface is generic and all-purpose, and so I question whether your
> extension makes sense.

I question whether the definition of "all-purpose" really applies
here.  All it tells me is that "an event happened on this channel 
at this time".

If the user doesn't care about additional data, it can just be 
ignored, right?


In the meantime, let's see what the HW guys say about doing the 
comparision in SW.  Other vendors have PPS input to their MAC,
so the disciplining is done in HW, bypassing adjphase() completely.
-- 
Jonathan
