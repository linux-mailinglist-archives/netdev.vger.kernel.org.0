Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5517DB53B1
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfIQRKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 13:10:30 -0400
Received: from foss.arm.com ([217.140.110.172]:59086 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfIQRKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 13:10:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8468328;
        Tue, 17 Sep 2019 10:10:29 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D136B3F575;
        Tue, 17 Sep 2019 10:10:27 -0700 (PDT)
Subject: Re: [PATCH 3/6] Timer: expose monotonic clock and counter value
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, Steve.Capper@arm.com,
        Kaly.Xin@arm.com, justin.he@arm.com, nd@arm.com,
        linux-arm-kernel@lists.infradead.org
References: <20190917112430.45680-1-jianyong.wu@arm.com>
 <20190917112430.45680-4-jianyong.wu@arm.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <ad38f692-a7c4-34e0-8236-ebd2d237bd93@kernel.org>
Date:   Tue, 17 Sep 2019 18:10:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190917112430.45680-4-jianyong.wu@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/09/2019 12:24, Jianyong Wu wrote:
> A number of PTP drivers (such as ptp-kvm) are assuming what the
> current clock source is, which could lead to interesting effects on
> systems where the clocksource can change depending on external events.
> 
> For this purpose, add a new API that retrives both the current
> monotonic clock as well as its counter value.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>

There must be something wrong with the way you've taken this patch in
your tree. My authorship is gone (not that I deeply care about it, but
it is good practice to keep attributions), and the subject line has been
rewritten.

I'd appreciate it if you could fix this in a future revision of this
series. For reference, the original patch is here[1].

> ---
>  include/linux/timekeeping.h |  3 +++
>  kernel/time/timekeeping.c   | 13 +++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index a8ab0f143ac4..a5389adaa8bc 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -247,6 +247,9 @@ extern int get_device_system_crosststamp(
>  			struct system_time_snapshot *history,
>  			struct system_device_crosststamp *xtstamp);
>  
> +/* Obtain current monotonic clock and its counter value  */
> +extern void get_current_counterval(struct system_counterval_t *sc);
> +
>  /*
>   * Simultaneously snapshot realtime and monotonic raw clocks
>   */
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 44b726bab4bd..07a0969625b1 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1098,6 +1098,19 @@ static bool cycle_between(u64 before, u64 test, u64 after)
>  	return false;
>  }
>  
> +/**
> + * get_current_counterval - Snapshot the current clocksource and counter value
> + * @sc:	Pointer to a struct containing the current clocksource and its value
> + */
> +void get_current_counterval(struct system_counterval_t *sc)
> +{
> +	struct timekeeper *tk = &tk_core.timekeeper;
> +
> +	sc->cs = READ_ONCE(tk->tkr_mono.clock);
> +	sc->cycles = sc->cs->read(sc->cs);
> +}
> +EXPORT_SYMBOL_GPL(get_current_counterval);

This export wasn't in my original patch. I guess you need it because
your ptp driver builds as a module? It'd be good to mention it in the
commit log.

> +
>  /**
>   * get_device_system_crosststamp - Synchronously capture system/device timestamp
>   * @get_time_fn:	Callback to get simultaneous device time and
> 

Thanks,

	M.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=timer/counterval&id=a6e8abce025691b6a55e1c195878d7f76bfeb9d1
-- 
Jazz is not dead, it just smells funny...
