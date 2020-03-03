Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F311176A44
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 02:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCCB4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 20:56:31 -0500
Received: from mga17.intel.com ([192.55.52.151]:44974 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCCB4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 20:56:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 17:56:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="233598677"
Received: from wtczc53028gn.jf.intel.com (HELO skl-build) ([10.54.87.17])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 17:56:30 -0800
Date:   Mon, 2 Mar 2020 17:56:15 -0800
From:   "Christopher S. Hall" <christopher.s.hall@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, x86@kernel.org,
        jacob.e.keller@intel.com, richardcochran@gmail.com,
        davem@davemloft.net, sean.v.kelley@intel.com,
        linus.walleij@linaro.org
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO
 Driver with PHC interface changes to support additional H/W Features
Message-ID: <20200303015615.GA15531@skl-build>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <87eevf4hnq.fsf@nanos.tec.linutronix.de>
 <20200224224059.GC1508@skl-build>
 <87mu95ne3q.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mu95ne3q.fsf@nanos.tec.linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

Thank you for your suggestions.

On Thu, Feb 27, 2020 at 12:06:01AM +0100, Thomas Gleixner wrote:
> Christopher,
> 
> "Christopher S. Hall" <christopher.s.hall@intel.com> writes:
> > On Fri, Jan 31, 2020 at 07:14:49PM +0100, Thomas Gleixner wrote:
> >> christopher.s.hall@intel.com writes:
> >> >
> >> > The TGPIO hardware doesn't implement interrupts. For TGPIO input, the
> >> > output edge-timestamp API is re-used to implement a user-space polling
> >> > interface. For periodic input (e.g. PPS) this is fairly efficient,
> >> > requiring only a marginally faster poll rate than the input event
> >> > frequency.
> >> 
> >> I really have a hard time to understand why this is implemented as part
> >> of PTP while you talk about PPS at the same time.
> >
> > We primarily need support for periodic input and output uses cases.
> > Apologies for omitting the periodic output use case from the cover
> > letter. While TGPIO isn't associated with a PTP timestamp clock, the PHC
> > pin/clock interface fits the usage otherwise.
> 
> Which usage? PTP like usage? I really have a hard time to make the
> connection. PTP is as the name says a protocol to synchronize time
> across a network.
> 
> What you're having is a GPIO which has some magic timestamp clock which
> can be correlated back to ART/TSC, right?

Right.

> > The customer requested usages are 1 kHz and 1 Hz for both input and
> > output. Some higher level use cases are:
> > - using a GPS PPS signal to sync the system clock
> 
> That makes at least some sense. See below.
> 
> > - auditing timesync precision for financial services, especially high
> > 	frequency trading (e.g. MiFID).
> 
> A good reason to not support it at all. Aside of that I have no idea how
> that auditing is supposed to work. Just throwing a few buzzwords around
> is not giving much technical context.
> 
> > Apart from clock import/export applications, timestamping single I/O
> > events are potentially valuable for industrial control applications
> > (e.g. motor position sensing vs. time). As time sync precision
> > requirements for these applications are tightened, standard GPIO
> > timing precision will not be good enough.
> 
> Well, coming from that industry I really doubt that you can do anything
> useful with it, but hey it's been 25 years since I stopped working on
> motor and motion controllers :)
> 
> Anyway, the device we are talking about is a GPIO device with inputs and
> outputs plus bells and whistels attached to it.
> 
> On the input side this provides a timestamp taken by the hardware when
> the input level changes, i.e. hardware based time stamping instead of
> software based interrupt arrival timestamping. Looks like an obvious
> extension to the GPIO subsystem.
> 
> How that timestamp is processed/converted and what an application can
> actually do with it is a secondary problem:
> 
>   - PPS mode:
> 
>     This can be implemented as an actual PPS driver which consumes the
>     GPIO, does timer based polling and feeds the timestamp into the PPS
>     subsystem. Might be not the most accurate solution, so I can see why
>     you want to use the PTP interface for it, which provides the raw
>     clocksource (ART/TSC) and the correlated monotonic/realtime
>     timestamps. But then again this wants to be a PTP driver consuming
>     the GPIO and the timestamp via timer based polling.
> 
>   - GPIO sampling
>   
>     That's totally disconnected from PPS/PTP and just provides a
>     correlated clock monotonic timestamp to the application.
> 
>     That covers your motor example :)
> 
>   - Timesync validation:
> 
>     -Enocluehowthatshouldworkatall
> 
> And of course you can use the GPIO input just as input without bells and
> whistels :)
> 
> Now you have the output side which again is a GPIO in the first
> place. But then it also has a secondary function which allows to create
> a periodic output with a magic correlation to the ART and some way to
> actually adjust the frequency. Neither of those two functions are in
> anyway relatable to PTP AFAICT.
> 
> The periodic, programmable and adjustable output is pretty much a PWM of
> some form and what you want to tell it is: Output a pulse at a given
> frequency. Due to the fact that the input clock of that thing is ART you
> can do the magic transformation from ART frequency to frequency adjusted
> clock monotonic in order to tweak the parameters so they actually end up
> generating your precise output frequency.  Tell the driver which
> frequency you want and it retrieves the correlation information from the
> kernel and uses it to achieve a precise output frequency. Doesn't sound
> like rocket science and does not required new magic ioctls.

This will have a few touch points in the kernel - PWM, GPIO, PPS. I'll
work on an RFC patchset.

> I might be missing something, but you surely can fill the blanks then.
> 
> Thanks,
> 
>         tglx

Thanks,
Christopher
