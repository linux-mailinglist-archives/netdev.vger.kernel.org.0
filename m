Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465822CE57E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgLDCB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:01:27 -0500
Received: from smtp8.emailarray.com ([65.39.216.67]:26137 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgLDCB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 21:01:26 -0500
Received: (qmail 18810 invoked by uid 89); 4 Dec 2020 02:00:39 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 4 Dec 2020 02:00:39 -0000
Date:   Thu, 3 Dec 2020 18:00:37 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 net-next] ptp: Add clock driver for the OpenCompute
 TimeCard.
Message-ID: <20201204020037.jeyzulaqp4kd4pnv@bsd-mbp.dhcp.thefacebook.com>
References: <20201203182925.4059875-1-jonathan.lemon@gmail.com>
 <20201204005624.GC18560@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204005624.GC18560@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 04:56:24PM -0800, Richard Cochran wrote:
> On Thu, Dec 03, 2020 at 10:29:25AM -0800, Jonathan Lemon wrote:
> > The OpenCompute time card is an atomic clock along with
> > a GPS receiver that provides a Grandmaster clock source
> > for a PTP enabled network.
> > 
> > More information is available at http://www.timingcard.com/
> > 
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> What changed in v2?
> 
> (please include a change log for future patches)

test robot complained because it wasn't dependent on CONFIG_PCI.
Will add a cover letter for the next v3.

 
> > +static int
> > +ptp_ocp_gettimex(struct ptp_clock_info *ptp_info, struct timespec64 *ts,
> > +		 struct ptp_system_timestamp *sts)
> > +{
> 
> The name here is a bit confusing since "timex" has a special meaning
> in the NTP/PTP API.

The .gettimex64 call is used here so the time returned from the
clock can be correlated to the system time.


> > +static int
> > +ptp_ocp_settime(struct ptp_clock_info *ptp_info, const struct timespec64 *ts)
> > +{
> > +	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
> > +	unsigned long flags;
> > +
> > +	if (ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC)
> > +		return 0;
> > +
> > +	dev_info(&bp->pdev->dev, "settime to: %lld.%ld\n",
> > +		 ts->tv_sec, ts->tv_nsec);
> 
> No need for this dmesg spam.   Change to _debug if you really want to
> keep it.

Will remove.


> > +	spin_lock_irqsave(&bp->lock, flags);
> > +	__ptp_ocp_settime_locked(bp, ts);
> > +	spin_unlock_irqrestore(&bp->lock, flags);
> > +
> > +	return 0;
> > +}
> 
> > +static int
> > +ptp_ocp_null_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
> > +{
> > +	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
> > +
> > +	if (scaled_ppm == 0)
> > +		return 0;
> > +
> > +	dev_info(&bp->pdev->dev, "adjfine, scaled by: %ld\n", scaled_ppm);
> 
> No need for this either.

Ditto.

 
> This driver looks fine, but I'm curious how you will use it.  Can it
> provide time stamping for network frames or other IO?

The card does have a PPS pulse output, so it can be wired to a network
card which takes an external PPS signal.

Right now, the current model (which certainly can be improved on) is using
phc2sys to discipline the system and NIC clocks.

I'll send a v3.  I also need to open a discussion on how this should
return the leap second changes to the user - there doesn't seem to be
anything in the current API for this.
-- 
Jonathan
