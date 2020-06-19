Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4612D200A6B
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732997AbgFSNkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:40:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48906 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgFSNkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 09:40:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmHFR-001HN0-TZ; Fri, 19 Jun 2020 15:40:01 +0200
Date:   Fri, 19 Jun 2020 15:40:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 3/9] net: dsa: hellcreek: Add PTP clock support
Message-ID: <20200619134001.GC304147@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-4-kurt@linutronix.de>
 <20200618172304.GG240559@lunn.ch>
 <878sgjqx4r.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sgjqx4r.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 10:26:44AM +0200, Kurt Kanzenbach wrote:
> Hi Andrew,
> 
> On Thu Jun 18 2020, Andrew Lunn wrote:
> >> +static u64 __hellcreek_ptp_clock_read(struct hellcreek *hellcreek)
> >> +{
> >> +	u16 nsl, nsh, secl, secm, sech;
> >> +
> >> +	/* Take a snapshot */
> >> +	hellcreek_ptp_write(hellcreek, PR_COMMAND_C_SS, PR_COMMAND_C);
> >> +
> >> +	/* The time of the day is saved as 96 bits. However, due to hardware
> >> +	 * limitations the seconds are not or only partly kept in the PTP
> >> +	 * core. That's why only the nanoseconds are used and the seconds are
> >> +	 * tracked in software. Anyway due to internal locking all five
> >> +	 * registers should be read.
> >> +	 */
> >> +	sech = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> >> +	secm = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> >> +	secl = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> >> +	nsh  = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> >> +	nsl  = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> >> +
> >> +	return (u64)nsl | ((u64)nsh << 16);
> >
> > Hi Kurt
> >
> > What are the hardware limitations? There seems to be 48 bits for
> > seconds? That allows for 8925104 years?
> 
> In theory, yes. Due to hardware hardware considerations only a few or
> none of these bits are used for the seconds. The rest is zero. Meaning
> that the wraparound is not 8925104 years, but at e.g. 8 seconds when
> using 3 bits for the seconds.

Please add this to the comment.

> >> +static u64 __hellcreek_ptp_gettime(struct hellcreek *hellcreek)
> >> +{
> >> +	u64 ns;
> >> +
> >> +	ns = __hellcreek_ptp_clock_read(hellcreek);
> >> +	if (ns < hellcreek->last_ts)
> >> +		hellcreek->seconds++;
> >> +	hellcreek->last_ts = ns;
> >> +	ns += hellcreek->seconds * NSEC_PER_SEC;
> >
> > So the assumption is, this gets called at least once per second. And
> > if that does not happen, there is no recovery. The second is lost.
> 
> Yes, exactly. If a single overflow is missed, then the time is wrong.
> 
> >
> > I'm just wondering if there is something more robust using what the
> > hardware does provide, even if the hardware is not perfect.
> 
> I don't think there's a more robust way to do this. The overflow period
> is a second which should be enough time to catch the overflow even if
> the system is loaded. We did long running tests for days and the
> mechanism worked fine. We could also consider to move the delayed work
> to a dedicated thread which could be run with real time (SCHED_FIFO)
> priority. But, I didn't see the need for it.

If the hardware does give you 3 working bits for the seconds, you
could make use of that for a consistency check. If nothing else, you
could do a

dev_err(dev, 'PTP time is FUBAR');

	     Andrew


