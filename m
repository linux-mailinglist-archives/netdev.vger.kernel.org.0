Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563782C2F6B
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404004AbgKXR6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403966AbgKXR6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 12:58:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F119E206B5;
        Tue, 24 Nov 2020 17:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606240693;
        bh=OpON11OTYtw3Gj2Go6/CNZMridVMk6ZFje6DvMSp3f4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FNvYrs+XZX6OH5f9dQoh1mZz7MCtgPWIfzG1O8w7I8a/vQaP2YFUAhTU3C1VhSIqD
         r2fTGcz2zvtql6quR79dm6NohFqOQmWUa0dCqbo49jBp9UvX9GX8Ype56/PxO2SQBH
         qVVwRNV7aNNfDPqERKVJVNTJRlXJJS+zuR7/vHNI=
Date:   Tue, 24 Nov 2020 09:58:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH net] enetc: Advance the taprio base time in the future
Message-ID: <20201124095812.539b9d1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VE1PR04MB64967D95BBDB594A286C139A92FB0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20201124012005.2442293-1-vladimir.oltean@nxp.com>
        <VE1PR04MB64967D95BBDB594A286C139A92FB0@VE1PR04MB6496.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 02:40:29 +0000 Po Liu wrote:
> > The tc-taprio base time indicates the beginning of the tc-taprio schedule,
> > which is cyclic by definition (where the length of the cycle in nanoseconds
> > is called the cycle time). The base time is a 64-bit PTP time in the TAI
> > domain.
> > 
> > Logically, the base-time should be a future time. But that imposes some
> > restrictions to user space, which has to retrieve the current PTP time first
> > from the NIC first, then calculate a base time that will still be larger than

Says first twice.

> > the base time by the time the kernel driver programs this value into the
> > hardware. Actually ensuring that the programmed base time is in the
> > future is still a problem even if the kernel alone deals with this - what the
> > proposed patch does is to "reserve" 100 ms for potential delays, but
> > otherwise this is an unsolved problem in the general case.
> > 
> > Nonetheless, what is important for tc-taprio in a LAN is not precisely the
> > base-time value, but rather the fact that the taprio schedules are
> > synchronized across all nodes in the network, or at least have a given
> > phase offset.
> > 
> > Therefore, the expectation for user space is that specifying a base-time of
> > 0 would mean that the tc-taprio schedule should start "right away", with
> > one twist: the effective base-time written into the NIC is still congruent
> > with the originally specified base-time. Otherwise stated, if the current PTP
> > time of the NIC is 2.123456789, the base-time of the schedule is
> > 0.000000000 and the cycle-time is 0.500000000, then the effective base-
> > time should be 2.500000000, since that is the first beginning of a new cycle
> > starting at base-time 0.000000000, with a cycle time of 500 ms, that is
> > larger than the current PTP time.
> > 
> > So in short, the kernel driver, or the hardware, should allow user space to
> > skip the calculation of the future base time, and transparently allow a PTP
> > time in the past. The formula for advancing the base time should be:
> > 
> > effective-base-time = base-time + N x cycle-time
> > 
> > where N is the smallest integer number of cycles such that effective-base-
> > time >= now.
> > 
> > Actually, the base-time of 0.000000000 is not special in any way.
> > Reiterating the example above, just with a base-time of 0.000500000. The
> > effective base time in this case should be 2.500500000, according to the
> > formula. There are use cases for applying phase shifts like this.
> > 
> > The enetc driver is not doing that. It special-cases the case where the
> > specified base time is zero, and it replaces that with a plain "current PTP
> > time".
> > 
> > Such an implementation is unusable for applications that expect the
> > phase to be preserved. We already have drivers in the kernel that comply
> > to the behavior described above (maybe more than just the ones listed
> > below):
> > - the software implementation of taprio does it in taprio_get_start_time:
> > 
> > 	/* Schedule the start time for the beginning of the next
> > 	 * cycle.
> > 	 */
> > 	n = div64_s64(ktime_sub_ns(now, base), cycle);
> > 	*start = ktime_add_ns(base, (n + 1) * cycle);
> >   
> 
> This is the right way for calculation. For the ENETC,  hardware also do the same calculation before send to Operation State Machine. 
> For some TSN IP, like Felix and DesignWare TSN in RT1170 and IMX8MP require the basetime limite the range not less than the current time 8 cycles, software may do calculation before setting to the hardware.
> Actually, I do suggest this calculation to sch_taprio.c, but I found same calculation only for the TXTIME by taprio_get_start_time().
> Which means: 
> If (currenttime < basetime)
>        Admin_basetime = basetime;
> Else
>        Admin_basetime =  basetime + (n+1)* cycletime;
> N is the minimal value which make Admin_basetime is larger than the currenttime.
> 
> User space never to get the current time. Just set a value as offset OR future time user want.
> For example: set basetime = 1000000ns, means he want time align to 1000000ns, and on the other device, also set the basetime = 1000000ns, then the two devices are aligned cycle.
> If user want all the devices start at 11.24.2020 11:00 then set basetime = 1606273200.0 s.
> 
> > - the sja1105 offload does it via future_base_time()
> > - the ocelot/felix offload does it via vsc9959_new_base_time()
> > 
> > As for the obvious question: doesn't the hardware just "do the right thing"
> > if passed a time in the past? I've tested and it doesn't look like it. I cannot  
> 
> So hardware already do calculation same way.

So the patch is unnecessary? Or correct? Not sure what you're saying..

> > determine what base-time it uses in that case, however traffic does not
> > have the correct phase alignment.
> > 
> > Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-
> > taprio offload")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  .../net/ethernet/freescale/enetc/enetc_qos.c  | 34 +++++++++++++------
> >  1 file changed, 23 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> > b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> > index aeb21dc48099..379deef5d9e0 100644
> > --- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> > @@ -45,6 +45,20 @@ void enetc_sched_speed_set(struct enetc_ndev_priv
> > *priv, int speed)
> >  		      | pspeed);
> >  }
> > 
> > +static inline s64 future_base_time(s64 base_time, s64 cycle_time, s64
> > +now) {

nit: no need for this inline

> > +	s64 a, b, n;
> > +
> > +	if (base_time >= now)
> > +		return base_time;
> > +
> > +	a = now - base_time;
> > +	b = cycle_time;
> > +	n = div_s64(a + b - 1, b);
> > +
> > +	return base_time + n * cycle_time;
> > +}
