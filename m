Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E7B45CE80
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbhKXU65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243359AbhKXU65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:58:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3509AC061574;
        Wed, 24 Nov 2021 12:55:47 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637787344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vg0CCGsRVRuZzX4n/Znj2DnEQZq5ocUTZHcTEfbNZtY=;
        b=VWpWG9LeQQ4/WqKq2HY8f99NLi/95mRKMCt4bnTK1LAQFHg0Q46g/NP8GntKu3dw7liyF3
        71ShHRSz4E0RB4Ri9wU7ixQzXkVxCUrKAxuVaY0kfQAe5trTEjzZH+M3usKAflX32Z3yXt
        E0yFsVXIxHsLHkdxNcoSqjQ6TJ/iZ5gAe0hccX8CT246yB75FNEBi4brF9MkhN5L3Zqzu1
        +5Q6QucM1+6nYZpETDRu2ZEPiNb1mWjhx1CfrJlAoXQapKhZSaDOiwoCqVZEicsUVTbQH4
        mCIJLCCGfLqTPxoJeb7DsbUZdaUyJYrCX51TrRyisQG7PV+1RrJ0XSTgGYPNkA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637787344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vg0CCGsRVRuZzX4n/Znj2DnEQZq5ocUTZHcTEfbNZtY=;
        b=24Co3XO9saqqYhLx2u6UMkBrr2fzU0Wd8aTOS8DCpMIwfPZhpolTCm+amb48nDc5qfhswp
        flKwvPMRl4vT/yDg==
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/7] timecounter: allow for non-power of two overflow
In-Reply-To: <20211109095013.27829-4-martin.kaistra@linutronix.de>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-4-martin.kaistra@linutronix.de>
Date:   Wed, 24 Nov 2021 21:55:44 +0100
Message-ID: <874k81l1db.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin,

On Tue, Nov 09 2021 at 10:50, Martin Kaistra wrote:
>   *			see CYCLECOUNTER_MASK() helper macro
>   * @mult:		cycle to nanosecond multiplier
>   * @shift:		cycle to nanosecond divisor (power of two)
> + * @overflow_point:	non-power of two overflow point (optional),
> + *			smaller than mask
>   */
>  struct cyclecounter {
>  	u64 (*read)(const struct cyclecounter *cc);
>  	u64 mask;
>  	u32 mult;
>  	u32 shift;
> +	u64 overflow_point;
>  };
>  
>  /**
> diff --git a/kernel/time/timecounter.c b/kernel/time/timecounter.c
> index e6285288d765..afd2910a9724 100644
> --- a/kernel/time/timecounter.c
> +++ b/kernel/time/timecounter.c
> @@ -39,6 +39,9 @@ static u64 timecounter_read_delta(struct timecounter *tc)
>  	/* calculate the delta since the last timecounter_read_delta(): */
>  	cycle_delta = (cycle_now - tc->cycle_last) & tc->cc->mask;
>  
> +	if (tc->cc->overflow_point && (cycle_now - tc->cycle_last) > tc->cc->mask)
> +		cycle_delta -= tc->cc->mask - tc->cc->overflow_point;

TBH, this took me more than one twisted braincell to grok.

With support for clocks which do not wrap at power of 2 boundaries we
already lose the unconditional fast path no matter what. So what's the
point of having two conditions and doing this convoluted math here?

In timecounter_init():

   	tc->ovfl = cc->ovfl ? cc->ovfl : cc->mask + 1;

which makes it a common path in timecounter_read_delta():

  	cycle_delta = cycle_now - tc->cycle_last;
        if ((s64)cycle_delta) < 0)
        	cycle_delta += tc->ovfl;

which produces way better binary code.

The conditional does not really matter for the timecounter use cases as
that calculation is noise compared to the actual cc->read() access.

Aside of that the same problem exists in timecounter_cyc2time()...

After that we probably should do a treewide sweep to get rid of cc->mask
to avoid confusion and subtle to understand errors when some code uses
cc->mask instead of cc->ovfl.

Thanks,

        tglx
