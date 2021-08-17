Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB723EE0B9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhHQAPF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Aug 2021 20:15:05 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:46988 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbhHQAPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:15:04 -0400
Received: by mail-lj1-f176.google.com with SMTP id h17so29929267ljh.13;
        Mon, 16 Aug 2021 17:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aUYJNvXMeoYhVbpAo6wV69kLNEFTWUFAE8fwHbR6xAM=;
        b=a2kveHiCKAxjgj4czWGqAUx+dhQEdnORiEVnKgUAe4dN0VE+S6yog4nrlC/qoAoKGW
         rSLfcPTuSBxtcJOXIsb+C0Zp7Q9TYmHmTPEsqkyj8VNAMnfpATwvO7GT0X4BdPpBGGwU
         A/ArOo4CGyU5p1xXrua1Q6z0kEht1fazo+3i0o1Pti+hSMgpwzIvGeDgIQKYaRjP9Gte
         qBh8cSYdfMHqXaibCm+4G03vkKi1Kcmp85N+L+Dic+jC4AvKs7iB/xC9Jcs9QR2MXb4g
         VXThcZYsW3CQkvzvuZYWxZfPgJAUCcjKz4n4vVBShF7+zKM3rEBWw17SY/d2Q/Cm+9AI
         hNEg==
X-Gm-Message-State: AOAM5313pTfS+vLPjcAdeEwnLvjSM+2QYL5GfhAhhYGpKz86NdFbtcPV
        HtibTG0fwEHO4G0Uv+l6OFHba+rOumRa+Kfkgow=
X-Google-Smtp-Source: ABdhPJxqZMxnMzRffBPsA6F+5jVGKCfmIPI878mZhfF/sMUUj9VQR2ltV6Iijyvkzx7dFlDaVCWkIZTsSs/hIwYj6wg=
X-Received: by 2002:a2e:9999:: with SMTP id w25mr661622lji.359.1629159271413;
 Mon, 16 Aug 2021 17:14:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210730173805.3926-1-Stefan.Maetje@esd.eu> <20210730173805.3926-2-Stefan.Maetje@esd.eu>
 <20210806133125.k7yiz4zood3gvrdc@pengutronix.de> <0a3e198ab0a1d03d0c482c1792fd0c3377477bca.camel@esd.eu>
In-Reply-To: <0a3e198ab0a1d03d0c482c1792fd0c3377477bca.camel@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 Aug 2021 09:14:20 +0900
Message-ID: <CAMZ6Rq+O=0oKxqVTiZbX=Nua9CgF=ssi2zUgAm7Q=hZ2hXgX8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] can: esd: add support for esd GmbH PCIe/402 CAN
 interface family
To:     =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>
Cc:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On Tue. 17 Aug 2021 at 07:04, Stefan Mätje <Stefan.Maetje@esd.eu> wrote:
> Am Freitag, den 06.08.2021, 15:31 +0200 schrieb Marc Kleine-Budde:
> > On 30.07.2021 19:38:05, Stefan Mätje wrote:
...
> > This device supports HW timestamping. Please don't roll your own
> > conversion functions. Please make use of the timecounter/cyclecounter
> > API, have a look at the mcp251xfd driver for example:
> >
> > https://elixir.bootlin.com/linux/v5.13/source/drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c#L52
> >
> > The idea is that there is a counter of a certain with (here 32 bit) that
> > has a certain frequency (here: priv->can.clock.freq).
> >
> > >     cc->read = mcp251xfd_timestamp_read;
> > >     cc->mask = CYCLECOUNTER_MASK(32);
> > >     cc->shift = 1;
> > >     cc->mult = clocksource_hz2mult(priv->can.clock.freq, cc->shift);
> >
> > The conversion from the register value to ns in done with:
> > > ns = ((reg & mask) * mult) >> shift;
> > In the above example I'm using a shift of "1" as 1ns is an integer
> > multiple of the used frequency (which is 20 or 40 MHz).
> >
> > To cope with overflows of the cycle counter, read the current timestamp
> > with timecounter_read() with at least the double frequency of the
> > overflows happening (plus some slack). The mcp251xfd driver sets up a
> > worker for this. The mcp251xfd drive does this every 45 seconds, with an
> > overflow happening every 107s.
>
> At the moment I can't see the real benefit of this API. This is because the
> device delivers the HW timestamp as a 64-bit value with a certain frequency
> (atm. 80MHz). This timestamp will wrap after(!) the the result in ns of
> ktime_t.
>
> The other devices with 64-bit native timestamps (like etas_58x, peak_canfd.c
> and kvaser_pciefd.c) also do simple multiplication / division operations on
> the 64-bit HW timestamp
>
> Using the struct cyclecounter to hold the multiplier and divisor in the
> struct acc_ov (instead of the members ts2ns_numerator and ts2ns_denominator)
> would result in such an initialization for a struct cyclecounter cc:
>
> struct cyclecounter cc = {
>         .read = NULL,
>         .mask = CYCLECOUNTER_MASK(64),
>         .shift = 1,
>         .mult = clocksource_hz2mult(ov->timestamp_frequency, cc->shift),/* 25 */
> }
>
> Then in acc_ts2ktime() the function cyclecounter_cyc2ns() could be used like this:
>
> static ktime_t acc_ts2ktime(struct acc_ov *ov, u64 ts)
> {
>         u64 unused_frac;
>         u64 ns;
>
>         ns = cyclecounter_cyc2ns(ov->cc, ts, 0, &unused_frac);
>
>         return ns_to_ktime(ns);
> }
>
> One concluding question. Need the HW timestamps be only in ns (since powerup) or should they also be in relation to the kernel time
> of the startup like it is done in Vincent's etas_58x driver?

In a nutshell, I converted the hardware timestamps to kernel
time (UNIX format) because I like to be able to derive the date
and time from my timestamps. I explained it in more details in
below message:

https://lore.kernel.org/linux-can/CAMZ6RqL+n4tRy-B-W+fzW5B3QV6Bedrko57pU_0TE023Oxw_5w@mail.gmail.com/

Yours sincerely,
Vincent
