Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99673177A59
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgCCPYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:24:25 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44776 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729898AbgCCPYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:24:25 -0500
Received: from [5.158.153.55] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j99Oy-0000QR-QO; Tue, 03 Mar 2020 16:24:08 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 432AF104098; Tue,  3 Mar 2020 16:24:03 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc:     "Christopher S. Hall" <christopher.s.hall@intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer\:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
        jacob.e.keller@intel.com,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sean V Kelley <sean.v.kelley@intel.com>
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO Driver with PHC interface changes to support additional H/W Features
In-Reply-To: <CACRpkdadbWvsnyrH_+sRha2C0fJU0EFEO9UyO7wHybZT-R1jzA@mail.gmail.com>
References: <20191211214852.26317-1-christopher.s.hall@intel.com> <87eevf4hnq.fsf@nanos.tec.linutronix.de> <20200224224059.GC1508@skl-build> <87mu95ne3q.fsf@nanos.tec.linutronix.de> <CACRpkdadbWvsnyrH_+sRha2C0fJU0EFEO9UyO7wHybZT-R1jzA@mail.gmail.com>
Date:   Tue, 03 Mar 2020 16:24:03 +0100
Message-ID: <87wo81cvho.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:
> On Thu, Feb 27, 2020 at 12:06 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> "Christopher S. Hall" <christopher.s.hall@intel.com> writes:
> IIO has a config file in sysfs that lets them select the source of the
> timestamp like so (drivers/iio/industrialio-core.c):
>
> s64 iio_get_time_ns(const struct iio_dev *indio_dev)
> {
>         struct timespec64 tp;
>
>         switch (iio_device_get_clock(indio_dev)) {
>         case CLOCK_REALTIME:
>                 return ktime_get_real_ns();
>         case CLOCK_MONOTONIC:
>                 return ktime_get_ns();
>         case CLOCK_MONOTONIC_RAW:
>                 return ktime_get_raw_ns();
>         case CLOCK_REALTIME_COARSE:
>                 return ktime_to_ns(ktime_get_coarse_real());
>         case CLOCK_MONOTONIC_COARSE:
>                 ktime_get_coarse_ts64(&tp);
>                 return timespec64_to_ns(&tp);
>         case CLOCK_BOOTTIME:
>                 return ktime_get_boottime_ns();
>         case CLOCK_TAI:
>                 return ktime_get_clocktai_ns();
>         default:
>                 BUG();
>         }
> }

That's a nice example of overengineering :)

> After discussion with Arnd we concluded the only timestamp that
> makes sense is ktime_get_ns(). So in GPIO we just use that, all the
> userspace I can think of certainly prefers monotonic time.
> (If tglx does not agree with that I stand corrected to whatever
> he says, I suppose.)

In general, CLOCK_MONOTONIC is what makes most sense.

The only other interesting clock which makes sense from an application
POV is CLOCK_TAI which is becoming more popular in terms of network wide
time coordination and TSN.

CLOCK_REALTIME is a pain to deal with due to leap seconds, daylight
savings etc.

> Anyway in GPIO we could also make it configurable for users who
> know what they are doing.
>
> HW timestamps would be something more elaborate and
> nice CLOCK_HW_SPECIFIC or so. Some of the IIO sensors also
> have that, we just don't expose it as of now.

HW timestamps are just more accurate than the software timestamps which
we have now and from a portability and interface POV they should just be
converted converted / mapped to clock MONOTONIC or clock TAI. So your
existing interface (maybe extended to TAI in the future) is just
working, but more accurate.

Exposing the HW timestamp itself based on some random and potentially
unknown clock might still be useful for some specialized applications,
but that want's to be through a distinct interface so there is no chance
to confuse it with something generally useful.

Thanks,

        tglx
