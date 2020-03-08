Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E5E17D5CC
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 20:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgCHTOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 15:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbgCHTOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Mar 2020 15:14:47 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9029B206D5;
        Sun,  8 Mar 2020 19:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583694886;
        bh=9qdy5RIOWebOniyIfKswarc6hNqqoEAjbTJFvBPRDGA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KybbOW2yu4lzLxdriSYezxxCBz0EqEKTL3kseV827LvPmiJ5nwUwFZCFTJRQGq8Px
         LvSox0dvlkW4utxfuXjg5IFU/S4qdj4chiD4gteFzVEPhSc9uOZSQe3dlC9j4v8Jle
         1ai+BgShmOlsT1kZY2WW0UPvDlKGbdyBYQbeZFhs=
Date:   Sun, 8 Mar 2020 19:14:41 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "Christopher S. Hall" <christopher.s.hall@intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer\:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
        jacob.e.keller@intel.com,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sean V Kelley <sean.v.kelley@intel.com>
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time
 GPIO Driver with PHC interface changes to support additional H/W Features
Message-ID: <20200308191441.1eed786e@archlinux>
In-Reply-To: <87wo81cvho.fsf@nanos.tec.linutronix.de>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
        <87eevf4hnq.fsf@nanos.tec.linutronix.de>
        <20200224224059.GC1508@skl-build>
        <87mu95ne3q.fsf@nanos.tec.linutronix.de>
        <CACRpkdadbWvsnyrH_+sRha2C0fJU0EFEO9UyO7wHybZT-R1jzA@mail.gmail.com>
        <87wo81cvho.fsf@nanos.tec.linutronix.de>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Mar 2020 16:24:03 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> Linus Walleij <linus.walleij@linaro.org> writes:
> > On Thu, Feb 27, 2020 at 12:06 AM Thomas Gleixner <tglx@linutronix.de> wrote:  
> >> "Christopher S. Hall" <christopher.s.hall@intel.com> writes:  
> > IIO has a config file in sysfs that lets them select the source of the
> > timestamp like so (drivers/iio/industrialio-core.c):
> >
> > s64 iio_get_time_ns(const struct iio_dev *indio_dev)
> > {
> >         struct timespec64 tp;
> >
> >         switch (iio_device_get_clock(indio_dev)) {
> >         case CLOCK_REALTIME:
> >                 return ktime_get_real_ns();
> >         case CLOCK_MONOTONIC:
> >                 return ktime_get_ns();
> >         case CLOCK_MONOTONIC_RAW:
> >                 return ktime_get_raw_ns();
> >         case CLOCK_REALTIME_COARSE:
> >                 return ktime_to_ns(ktime_get_coarse_real());
> >         case CLOCK_MONOTONIC_COARSE:
> >                 ktime_get_coarse_ts64(&tp);
> >                 return timespec64_to_ns(&tp);
> >         case CLOCK_BOOTTIME:
> >                 return ktime_get_boottime_ns();
> >         case CLOCK_TAI:
> >                 return ktime_get_clocktai_ns();
> >         default:
> >                 BUG();
> >         }
> > }  
> 
> That's a nice example of overengineering :)

Yeah.  There was some ugly history behind that including some 'ancient'
stupidity from me :(  I certainly don't recommend anyone copies it.

We may have overcompensated for having an odd default by allowing
lots of other odd choices.

> 
> > After discussion with Arnd we concluded the only timestamp that
> > makes sense is ktime_get_ns(). So in GPIO we just use that, all the
> > userspace I can think of certainly prefers monotonic time.
> > (If tglx does not agree with that I stand corrected to whatever
> > he says, I suppose.)  
> 
> In general, CLOCK_MONOTONIC is what makes most sense.
> 
> The only other interesting clock which makes sense from an application
> POV is CLOCK_TAI which is becoming more popular in terms of network wide
> time coordination and TSN.
> 
> CLOCK_REALTIME is a pain to deal with due to leap seconds, daylight
> savings etc.
> 
> > Anyway in GPIO we could also make it configurable for users who
> > know what they are doing.
> >
> > HW timestamps would be something more elaborate and
> > nice CLOCK_HW_SPECIFIC or so. Some of the IIO sensors also
> > have that, we just don't expose it as of now.  
> 
> HW timestamps are just more accurate than the software timestamps which
> we have now and from a portability and interface POV they should just be
> converted converted / mapped to clock MONOTONIC or clock TAI. So your
> existing interface (maybe extended to TAI in the future) is just
> working, but more accurate.
> 
> Exposing the HW timestamp itself based on some random and potentially
> unknown clock might still be useful for some specialized applications,
> but that want's to be through a distinct interface so there is no chance
> to confuse it with something generally useful.

Agreed, though it would be nice to actually have some hardware
that supports sane synchronization between a hardware timestamp and
sensible clocks in the system.   In IIO we have some nasty filtering in
some drivers to attempt to align hardware timestamps and deal with
jitter in interrupt handling.

Good luck (or maybe you do have a rare sane system!)

Jonathan

> 
> Thanks,
> 
>         tglx

