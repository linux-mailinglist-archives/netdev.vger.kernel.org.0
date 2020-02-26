Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A457170C41
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgBZXGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:06:14 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:60769 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgBZXGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 18:06:14 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j75kf-0008Pg-Lx; Thu, 27 Feb 2020 00:06:01 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 0D450100EA1; Thu, 27 Feb 2020 00:06:01 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Christopher S. Hall" <christopher.s.hall@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, x86@kernel.org,
        jacob.e.keller@intel.com, richardcochran@gmail.com,
        davem@davemloft.net, sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO Driver with PHC interface changes to support additional H/W Features
In-Reply-To: <20200224224059.GC1508@skl-build>
References: <20191211214852.26317-1-christopher.s.hall@intel.com> <87eevf4hnq.fsf@nanos.tec.linutronix.de> <20200224224059.GC1508@skl-build>
Date:   Thu, 27 Feb 2020 00:06:01 +0100
Message-ID: <87mu95ne3q.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christopher,

"Christopher S. Hall" <christopher.s.hall@intel.com> writes:
> On Fri, Jan 31, 2020 at 07:14:49PM +0100, Thomas Gleixner wrote:
>> christopher.s.hall@intel.com writes:
>> >
>> > The TGPIO hardware doesn't implement interrupts. For TGPIO input, the
>> > output edge-timestamp API is re-used to implement a user-space polling
>> > interface. For periodic input (e.g. PPS) this is fairly efficient,
>> > requiring only a marginally faster poll rate than the input event
>> > frequency.
>> 
>> I really have a hard time to understand why this is implemented as part
>> of PTP while you talk about PPS at the same time.
>
> We primarily need support for periodic input and output uses cases.
> Apologies for omitting the periodic output use case from the cover
> letter. While TGPIO isn't associated with a PTP timestamp clock, the PHC
> pin/clock interface fits the usage otherwise.

Which usage? PTP like usage? I really have a hard time to make the
connection. PTP is as the name says a protocol to synchronize time
across a network.

What you're having is a GPIO which has some magic timestamp clock which
can be correlated back to ART/TSC, right?

So squeezing this into PTP makes as much sense as squeezing a
camera/video/audio interface which provides or consumes timestamps into
it.

> The PHC periodic output API is the closest fit for periodic output without
> creating a new API.

Well, you avoid creating a new API or extending one which makes sense by
abusing the PTP interface for something which is not even remotely
connected to PTP.

> The PHC interface can also register as a PPS source. I am, however,
> concerned in general about implementing PPS input in the driver
> because the hardware doesn't implement interrupts - requiring polling.

Really useful.

>> Proper information about why this approach was chosen and what that
>> magic device is used for would be really helpful.
>
> The customer requested usages are 1 kHz and 1 Hz for both input and
> output. Some higher level use cases are:
> - using a GPS PPS signal to sync the system clock

That makes at least some sense. See below.

> - auditing timesync precision for financial services, especially high
> 	frequency trading (e.g. MiFID).

A good reason to not support it at all. Aside of that I have no idea how
that auditing is supposed to work. Just throwing a few buzzwords around
is not giving much technical context.

> Apart from clock import/export applications, timestamping single I/O
> events are potentially valuable for industrial control applications
> (e.g. motor position sensing vs. time). As time sync precision
> requirements for these applications are tightened, standard GPIO
> timing precision will not be good enough.

Well, coming from that industry I really doubt that you can do anything
useful with it, but hey it's been 25 years since I stopped working on
motor and motion controllers :)

Anyway, the device we are talking about is a GPIO device with inputs and
outputs plus bells and whistels attached to it.

On the input side this provides a timestamp taken by the hardware when
the input level changes, i.e. hardware based time stamping instead of
software based interrupt arrival timestamping. Looks like an obvious
extension to the GPIO subsystem.

How that timestamp is processed/converted and what an application can
actually do with it is a secondary problem:

  - PPS mode:

    This can be implemented as an actual PPS driver which consumes the
    GPIO, does timer based polling and feeds the timestamp into the PPS
    subsystem. Might be not the most accurate solution, so I can see why
    you want to use the PTP interface for it, which provides the raw
    clocksource (ART/TSC) and the correlated monotonic/realtime
    timestamps. But then again this wants to be a PTP driver consuming
    the GPIO and the timestamp via timer based polling.

  - GPIO sampling
  
    That's totally disconnected from PPS/PTP and just provides a
    correlated clock monotonic timestamp to the application.

    That covers your motor example :)

  - Timesync validation:

    -Enocluehowthatshouldworkatall

And of course you can use the GPIO input just as input without bells and
whistels :)

Now you have the output side which again is a GPIO in the first
place. But then it also has a secondary function which allows to create
a periodic output with a magic correlation to the ART and some way to
actually adjust the frequency. Neither of those two functions are in
anyway relatable to PTP AFAICT.

The periodic, programmable and adjustable output is pretty much a PWM of
some form and what you want to tell it is: Output a pulse at a given
frequency. Due to the fact that the input clock of that thing is ART you
can do the magic transformation from ART frequency to frequency adjusted
clock monotonic in order to tweak the parameters so they actually end up
generating your precise output frequency.  Tell the driver which
frequency you want and it retrieves the correlation information from the
kernel and uses it to achieve a precise output frequency. Doesn't sound
like rocket science and does not required new magic ioctls.

I might be missing something, but you surely can fill the blanks then.

Thanks,

        tglx



