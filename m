Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C702D3A1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfE2COg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:14:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51287 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfE2COf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 22:14:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id f10so434617wmb.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 19:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PgN9lZYSW6MUtr26KWEiWvJfTzaEUZF1csnSpUPQerE=;
        b=lZLRd7AY1yFOgFozQ18TnhvB00PzlNJpD55vnKrhDjOMnW7ajh1Ok4sEbMRnEoBVaX
         B/aGZaf8y14SOTxFdYiEm6YiJHsAP9F4sI00qMWR53fBqkcZQMOnxYZGxBtZ9ZNayNnx
         yiByKnKWAbYSuHhVxXc1cJzAuVmJeDuVpsAyQMZjdQatNjbqggdOcxpJVrvZv4FkcHHw
         F4CZte41m0l+hJqTWmpLJnb1Kquc1o3xCUZC2mja8SY3yHKiy8kgcci1FcLHGxV3d8AT
         XUON3TtXabGyL2duGSLLvsHjm0iRg/xasGElpEVOzIJxBKenfCLehopRhrQuq3UTw9Be
         2X3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PgN9lZYSW6MUtr26KWEiWvJfTzaEUZF1csnSpUPQerE=;
        b=HARh9jam/Y7fKUGBiroM/5aJi97mQV6K0hEXC5e9IORDo/LkaoJzUbrRhf4ajzbzV7
         gYqIsZWLVDqfRXSWq1cJpnLkDBCbxBqmOyWZQS++9O0ups/4K5zH5XWvKz5ZSJ0slh9B
         4gBS4o44JEbqPQuLKXjG3GktDUbSk78caq6YTtFpg6Fu48U5UYjJ7NIeEQ95xBowF5Z0
         4FEO0vHuLbO2eGSMEUwRnGB33cttVT1pbObuS6K0k+quv1vNUl/t3uqF2dAnsWrYJBqu
         KOsif+8DAEG+ofVkhtbEgEmm1kXWM3I5Ottcic61/R3Q4su93TgSE4erRIiJ0BD+Q4fw
         bPSA==
X-Gm-Message-State: APjAAAWjDrRRRcVUiv0lZ/VW/aoys9f+ADh2qHsxmNfvgRDYbNGwu0ir
        4opkfMLMgvfotv1Ju3Rb6CUU8OErlJa1q/ph0UHkgg==
X-Google-Smtp-Source: APXvYqwV5Z/Yh3VSHZzh2tY/Yfn0Vg2NBiPtNn1HworED7jgWcefE36Pti2Ya0dkyOrfzoNvX0CONroxn1ejKSEkF94=
X-Received: by 2002:a7b:c8c1:: with SMTP id f1mr5349103wml.164.1559096074170;
 Tue, 28 May 2019 19:14:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190528235627.1315-1-olteanv@gmail.com> <20190528235627.1315-2-olteanv@gmail.com>
In-Reply-To: <20190528235627.1315-2-olteanv@gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 28 May 2019 19:14:22 -0700
Message-ID: <CALAqxLWjT0ZJerFa+BVCKW+-ws6DYFy7kqEfNVK8ioGdY=VQeQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] timecounter: Add helper for reconstructing
 partial timestamps
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, "David S. Miller" <davem@davemloft.net>,
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

On Tue, May 28, 2019 at 4:58 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Some PTP hardware offers a 64-bit free-running counter whose snapshots
> are used for timestamping, but only makes part of that snapshot
> available as timestamps (low-order bits).
>
> In that case, timecounter/cyclecounter users must bring the cyclecounter
> and timestamps to the same bit width, and they currently have two
> options of doing so:
>
> - Trim the higher bits of the timecounter itself to the number of bits
>   of the timestamps.  This might work for some setups, but if the
>   wraparound of the timecounter in this case becomes high (~10 times per
>   second) then this causes additional strain on the system, which must
>   read the clock that often just to avoid missing the wraparounds.
>
> - Reconstruct the timestamp by racing to read the PTP time within one
>   wraparound cycle since the timestamp was generated.  This is
>   preferable when the wraparound time is small (do a time-critical
>   readout once vs doing it periodically), and it has no drawback even
>   when the wraparound is comfortably sized.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  include/linux/timecounter.h |  7 +++++++
>  kernel/time/timecounter.c   | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+)
>
> diff --git a/include/linux/timecounter.h b/include/linux/timecounter.h
> index 2496ad4cfc99..03eab1f3bb9c 100644
> --- a/include/linux/timecounter.h
> +++ b/include/linux/timecounter.h
> @@ -30,6 +30,9 @@
>   *     by the implementor and user of specific instances of this API.
>   *
>   * @read:              returns the current cycle value
> + * @partial_tstamp_mask:bitmask in case the hardware emits timestamps
> + *                     which only capture low-order bits of the full
> + *                     counter, and should be reconstructed.
>   * @mask:              bitmask for two's complement
>   *                     subtraction of non 64 bit counters,
>   *                     see CYCLECOUNTER_MASK() helper macro
> @@ -38,6 +41,7 @@
>   */
>  struct cyclecounter {
>         u64 (*read)(const struct cyclecounter *cc);
> +       u64 partial_tstamp_mask;
>         u64 mask;
>         u32 mult;
>         u32 shift;
> @@ -136,4 +140,7 @@ extern u64 timecounter_read(struct timecounter *tc);
>  extern u64 timecounter_cyc2time(struct timecounter *tc,
>                                 u64 cycle_tstamp);
>
> +extern u64 cyclecounter_reconstruct(const struct cyclecounter *cc,
> +                                   u64 ts_partial);
> +
>  #endif
> diff --git a/kernel/time/timecounter.c b/kernel/time/timecounter.c
> index 85b98e727306..d4657d64e38d 100644
> --- a/kernel/time/timecounter.c
> +++ b/kernel/time/timecounter.c
> @@ -97,3 +97,36 @@ u64 timecounter_cyc2time(struct timecounter *tc,
>         return nsec;
>  }
>  EXPORT_SYMBOL_GPL(timecounter_cyc2time);
> +
> +/**
> + * cyclecounter_reconstruct - reconstructs @ts_partial
> + * @cc:                Pointer to cycle counter.
> + * @ts_partial:        Typically RX or TX NIC timestamp, provided by hardware as
> + *             the lower @partial_tstamp_mask bits of the cycle counter,
> + *             sampled at the time the timestamp was collected.
> + *             To reconstruct into a full @mask bit-wide timestamp, the
> + *             cycle counter is read and the high-order bits (up to @mask) are
> + *             filled in.
> + *             Must be called within one wraparound of @partial_tstamp_mask
> + *             bits of the cycle counter.
> + */
> +u64 cyclecounter_reconstruct(const struct cyclecounter *cc, u64 ts_partial)
> +{
> +       u64 ts_reconstructed;
> +       u64 cycle_now;
> +
> +       cycle_now = cc->read(cc);
> +
> +       ts_reconstructed = (cycle_now & ~cc->partial_tstamp_mask) |
> +                           ts_partial;
> +
> +       /* Check lower bits of current cycle counter against the timestamp.
> +        * If the current cycle counter is lower than the partial timestamp,
> +        * then wraparound surely occurred and must be accounted for.
> +        */
> +       if ((cycle_now & cc->partial_tstamp_mask) <= ts_partial)
> +               ts_reconstructed -= (cc->partial_tstamp_mask + 1);
> +
> +       return ts_reconstructed;
> +}
> +EXPORT_SYMBOL_GPL(cyclecounter_reconstruct);

Hrm. Is this actually generic? Would it make more sense to have the
specific implementations with this quirk implement this in their
read() handler? If not, why?

thanks
-john
