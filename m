Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19FA92E5FF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfE2UXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:23:25 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45626 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2UXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:23:25 -0400
Received: by mail-ed1-f66.google.com with SMTP id f20so5559504edt.12;
        Wed, 29 May 2019 13:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gj4vz0BGKXUgHJIxFFhu0LjPh9MmI0i8cM1MVMHpNXU=;
        b=pb/HkhkNK9dn/jM5IxeXqJl+j0jRBb+Nn98t0z9L0oMjEduFBL/zlhPaGLiB8AUI3Q
         0t5x+Yh2MOpB62mO/xj2m/eVYFHfW5hX10n6oLh+DtoIBRV3XBq8EU7FdVWTGDAwodHt
         HuG7NzenFCvPZ5rpAcoQmuumbt7kEGWrfgqf3C7Jw2ee0mHXo0hW6G1nuSicWDVQ3rm7
         KEltz5eWpQ3cU0Mljjo1yXP9Ts98PF8KQZZzbt4j98Vc15OpkVul4xslUBV5Mc6URt5s
         9mmv11fwO22QS7TpHlKsZTb8HdOUq/fwAUprwLIW1lyqFtnmdHA+T7pIyZdQJPhBXoFg
         hDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gj4vz0BGKXUgHJIxFFhu0LjPh9MmI0i8cM1MVMHpNXU=;
        b=Hq136Cg7E4NrJeX9fFTgW/JmykQkUBQw7ATKd4M9OMILl5uODaqvYj9D/qlEuKrLMp
         fsGkdjlrZs065QVEuYyzuBkaB2vTF3sxWaELqXXNKLjCI4WCvQ2ufDFtky8EG2OADn0a
         0yGhpBj8HH9eNm9lVFMlQ1FN03MlBYSh1O6YUeYOfGlc2jCG9hJXW58FpZiP6oTk8gaj
         0w39bcERjIfSH4E46SuzLRImd2UuI9ljUC2GSv7EfwyPEP86ODr0x6Ey4jpqABORcvzG
         GP1eIf+kRO9gAmPeA1v4EPPA3tYGVZ+D2dnAcxpteJK0ERlvaKSMUtZGvxB7uc1uQKfA
         J+KQ==
X-Gm-Message-State: APjAAAWEjHAMoID06HxLF1sycMe2fT/V5ffQxujJSWpw1x4iqRLCoY3b
        b9zWWQA00nueOyh4jqoul0C5vx8p2A2tq7oB08U=
X-Google-Smtp-Source: APXvYqzpgPq4A6VzBKdh+gPHSU3+JZoMyepYWUYiLS9a2Dw2j1Q+wH5/Kl9CUek8B/idodVdai5RsjMIlcY0h4D7FEA=
X-Received: by 2002:a50:92a3:: with SMTP id k32mr165996eda.123.1559161403202;
 Wed, 29 May 2019 13:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190528235627.1315-1-olteanv@gmail.com> <20190528235627.1315-2-olteanv@gmail.com>
 <CALAqxLWjT0ZJerFa+BVCKW+-ws6DYFy7kqEfNVK8ioGdY=VQeQ@mail.gmail.com>
In-Reply-To: <CALAqxLWjT0ZJerFa+BVCKW+-ws6DYFy7kqEfNVK8ioGdY=VQeQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 29 May 2019 23:23:12 +0300
Message-ID: <CA+h21hqV_YzunTa3BqXr76HYfFCUj2S+1tzqDotyh3rYd8HK2Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] timecounter: Add helper for reconstructing
 partial timestamps
To:     John Stultz <john.stultz@linaro.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 at 05:14, John Stultz <john.stultz@linaro.org> wrote:
>
> On Tue, May 28, 2019 at 4:58 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Some PTP hardware offers a 64-bit free-running counter whose snapshots
> > are used for timestamping, but only makes part of that snapshot
> > available as timestamps (low-order bits).
> >
> > In that case, timecounter/cyclecounter users must bring the cyclecounter
> > and timestamps to the same bit width, and they currently have two
> > options of doing so:
> >
> > - Trim the higher bits of the timecounter itself to the number of bits
> >   of the timestamps.  This might work for some setups, but if the
> >   wraparound of the timecounter in this case becomes high (~10 times per
> >   second) then this causes additional strain on the system, which must
> >   read the clock that often just to avoid missing the wraparounds.
> >
> > - Reconstruct the timestamp by racing to read the PTP time within one
> >   wraparound cycle since the timestamp was generated.  This is
> >   preferable when the wraparound time is small (do a time-critical
> >   readout once vs doing it periodically), and it has no drawback even
> >   when the wraparound is comfortably sized.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  include/linux/timecounter.h |  7 +++++++
> >  kernel/time/timecounter.c   | 33 +++++++++++++++++++++++++++++++++
> >  2 files changed, 40 insertions(+)
> >
> > diff --git a/include/linux/timecounter.h b/include/linux/timecounter.h
> > index 2496ad4cfc99..03eab1f3bb9c 100644
> > --- a/include/linux/timecounter.h
> > +++ b/include/linux/timecounter.h
> > @@ -30,6 +30,9 @@
> >   *     by the implementor and user of specific instances of this API.
> >   *
> >   * @read:              returns the current cycle value
> > + * @partial_tstamp_mask:bitmask in case the hardware emits timestamps
> > + *                     which only capture low-order bits of the full
> > + *                     counter, and should be reconstructed.
> >   * @mask:              bitmask for two's complement
> >   *                     subtraction of non 64 bit counters,
> >   *                     see CYCLECOUNTER_MASK() helper macro
> > @@ -38,6 +41,7 @@
> >   */
> >  struct cyclecounter {
> >         u64 (*read)(const struct cyclecounter *cc);
> > +       u64 partial_tstamp_mask;
> >         u64 mask;
> >         u32 mult;
> >         u32 shift;
> > @@ -136,4 +140,7 @@ extern u64 timecounter_read(struct timecounter *tc);
> >  extern u64 timecounter_cyc2time(struct timecounter *tc,
> >                                 u64 cycle_tstamp);
> >
> > +extern u64 cyclecounter_reconstruct(const struct cyclecounter *cc,
> > +                                   u64 ts_partial);
> > +
> >  #endif
> > diff --git a/kernel/time/timecounter.c b/kernel/time/timecounter.c
> > index 85b98e727306..d4657d64e38d 100644
> > --- a/kernel/time/timecounter.c
> > +++ b/kernel/time/timecounter.c
> > @@ -97,3 +97,36 @@ u64 timecounter_cyc2time(struct timecounter *tc,
> >         return nsec;
> >  }
> >  EXPORT_SYMBOL_GPL(timecounter_cyc2time);
> > +
> > +/**
> > + * cyclecounter_reconstruct - reconstructs @ts_partial
> > + * @cc:                Pointer to cycle counter.
> > + * @ts_partial:        Typically RX or TX NIC timestamp, provided by hardware as
> > + *             the lower @partial_tstamp_mask bits of the cycle counter,
> > + *             sampled at the time the timestamp was collected.
> > + *             To reconstruct into a full @mask bit-wide timestamp, the
> > + *             cycle counter is read and the high-order bits (up to @mask) are
> > + *             filled in.
> > + *             Must be called within one wraparound of @partial_tstamp_mask
> > + *             bits of the cycle counter.
> > + */
> > +u64 cyclecounter_reconstruct(const struct cyclecounter *cc, u64 ts_partial)
> > +{
> > +       u64 ts_reconstructed;
> > +       u64 cycle_now;
> > +
> > +       cycle_now = cc->read(cc);
> > +
> > +       ts_reconstructed = (cycle_now & ~cc->partial_tstamp_mask) |
> > +                           ts_partial;
> > +
> > +       /* Check lower bits of current cycle counter against the timestamp.
> > +        * If the current cycle counter is lower than the partial timestamp,
> > +        * then wraparound surely occurred and must be accounted for.
> > +        */
> > +       if ((cycle_now & cc->partial_tstamp_mask) <= ts_partial)
> > +               ts_reconstructed -= (cc->partial_tstamp_mask + 1);
> > +
> > +       return ts_reconstructed;
> > +}
> > +EXPORT_SYMBOL_GPL(cyclecounter_reconstruct);
>
> Hrm. Is this actually generic? Would it make more sense to have the
> specific implementations with this quirk implement this in their
> read() handler? If not, why?

Hi John, Richard,

It's not the cycle counter that needs reconstruction, but hardware
timestamps based on it.  Hence not possible to add a workaround in the
read() handler.
If it's not desirable to have this helper function in the cyclecounter
I'll move it to the driver in v2.

Thanks,
-Vladimir

>
> thanks
> -john
