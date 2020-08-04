Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D3423B226
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgHDBQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgHDBQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:16:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0C0C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 18:16:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FFC91278B044;
        Mon,  3 Aug 2020 17:59:43 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:16:27 -0700 (PDT)
Message-Id: <20200803.181627.1393757416221748639.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: poll for extts events from
 a timer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803175158.579532-1-olteanv@gmail.com>
References: <20200803175158.579532-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 17:59:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  3 Aug 2020 20:51:58 +0300

> The current poll interval is enough to ensure that rising and falling
> edge events are not lost for a 1 PPS signal with 50% duty cycle.
> 
> But when we deliver the events to user space, it will try to infer if
> they were corresponding to a rising or to a falling edge (the kernel
> driver doesn't know that either). User space will try to make that
> inference based on the time at which the PPS master had emitted the
> pulse (i.e. if it's a .0 time, it's rising edge, if it's .5 time, it's
> falling edge).
> 
> But there is no in-kernel API for retrieving the precise timestamp
> corresponding to a PPS master (aka perout) pulse. So user space has to
> guess even that. It will read the PTP time on the PPS master right after
> we've delivered the extts event, and declare that the PPS master time
> was just the closest integer second, based on 2 thresholds (lower than
> .25, or higher than .75, and ignore anything else).
> 
> Except that, if we poll for extts events (and our hardware doesn't
> really help us, by not providing an interrupt), then there is a risk
> that the poll period (and therefore the time at which the event is
> delivered) might confuse user space.
> 
> Because we are always scheduling the next extts poll at
> SJA1105_EXTTS_INTERVAL "from now" (that's the only thing that the
> schedule_delayed_work() API gives us), it means that the start time of
> the next delayed workqueue will always be shifted to the right a little
> bit (shifted with the SPI access duration of this workqueue run).
> In turn, because user space sees extts events that are non-periodic
> compared to the PPS master's time, this means that it might start making
> wrong guesses about rising/falling edge.
> 
> To understand the effect, here is the output of ts2phc currently. Notice
> the 'src' timestamps of the 'SKIP extts' events, and how they have a
> large wander. They keep increasing until the upper limit for the ignore
> threshold (.75 seconds), after which the application starts ignoring the
> _other_ edge.
 ...
> Fix that by taking the following measures:
> - Schedule the poll from a timer. Because we are really scheduling the
>   timer periodically, the extts events delivered to user space are
>   periodic too, and don't suffer from the "shift-to-the-right" effect.
> - Increase the poll period to 6 times a second. This imposes a smaller
>   upper bound to the shift that can occur to the delivery time of extts
>   events, and makes user space (ts2phc) to always interpret correctly
>   which events should be skipped and which shouldn't.
> - Move the SPI readout itself to the main PTP kernel thread, instead of
>   the generic workqueue. This is because the timer runs in atomic
>   context, but is also better than before, because if needed, we can
>   chrt & taskset this kernel thread, to ensure it gets enough priority
>   under load.

Applied, thank you.
