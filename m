Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D86B7FC3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCMRvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjCMRvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:51:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2316478CBB
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 10:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678729831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQfnh657D32/PySRFapfQm8PLpff+pIlFGu8Qrio3t8=;
        b=NX6mv+ba3GZRSI5aXbvAz5sNQjY5+f2q/dooRboMw0Eh+UzK9P0GOPu9SVJpyN1K7nLAaL
        vXidyQHm4u+ONRsMZ1gVySjgt+/RRAGXQqoujESunCILXEy9W4yJ8YevaU5pT635bBMHpK
        gtTCcRdkR4EmJ5GYcMEJ6rkQNj42vq8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-qbYKTthVPXeD5r-dOZ5_-A-1; Mon, 13 Mar 2023 13:50:29 -0400
X-MC-Unique: qbYKTthVPXeD5r-dOZ5_-A-1
Received: by mail-qv1-f72.google.com with SMTP id s13-20020ad44b2d000000b00570ccb820abso7373648qvw.5
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 10:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678729829;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RQfnh657D32/PySRFapfQm8PLpff+pIlFGu8Qrio3t8=;
        b=scch/DkJ6xyYMdzipmx9QhHcutJUghqMyhYiUCBliuM0de7LfoWIC4UB8rqMEy6dso
         juDzLqk46FT3zyG3uhKQ1kf4gvXio+AFACj4tXG8u0QzBzvlt9NE206FJKEgUR/kjbLL
         oQNUs8SLLYvD4rCw4sYMZONx/eMlYAPoaDO3mMKMQtZNQbwRtJv6H26pa3AHVUlEYCSx
         /1+JWa2lQzgahTAn5ADm2dPU1sEEQz9GaUC/w4Wxc9Bx9KVW+V6Kp6LWwofukGH+IuVv
         mATtz/hIb5kERkOL+f7CkMLMgeq7/hcHZiIu+Nu/MQQhaYLkJLe2sQa3lujlSlxSLqmv
         bK7A==
X-Gm-Message-State: AO0yUKWP8r2ukXn3e6YwZ82gn+R/Vo1FpOcPUc5cm8eBb+Y5ZirYn7fN
        7dEmr+hGuIhUWxzX9MSRfSc+0dN8HEpq/k/pXT429bXj9Kp0EIQKAYHjN25h6N+oLimRAzspWmA
        tJJaWx3z4B42ggw0=
X-Received: by 2002:ac8:58cd:0:b0:3b9:a42b:7099 with SMTP id u13-20020ac858cd000000b003b9a42b7099mr58605470qta.30.1678729828766;
        Mon, 13 Mar 2023 10:50:28 -0700 (PDT)
X-Google-Smtp-Source: AK7set/ycQCtAC0mx84Gne4Dmw3Buk+pAqJh2r792zrHcf4C952gvkKjFG03WP8zf5XScy2IWXGoXA==
X-Received: by 2002:ac8:58cd:0:b0:3b9:a42b:7099 with SMTP id u13-20020ac858cd000000b003b9a42b7099mr58605438qta.30.1678729828410;
        Mon, 13 Mar 2023 10:50:28 -0700 (PDT)
Received: from [192.168.9.16] (net-2-34-29-20.cust.vodafonedsl.it. [2.34.29.20])
        by smtp.gmail.com with ESMTPSA id i4-20020a05620a248400b00745ba217187sm175211qkn.3.2023.03.13.10.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 10:50:27 -0700 (PDT)
Message-ID: <ee610a3a-4941-f754-b94d-04dd34ec92f6@redhat.com>
Date:   Mon, 13 Mar 2023 18:50:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
To:     Tianfei Zhang <tianfei.zhang@intel.com>
Cc:     ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        russell.h.weight@intel.com, matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>,
        netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        richardcochran@gmail.com
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
Content-Language: en-US
From:   Marco Pagani <marpagan@redhat.com>
In-Reply-To: <20230313030239.886816-1-tianfei.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023-03-13 04:02, Tianfei Zhang wrote:
> Adding a DFL (Device Feature List) device driver of ToD device for
> Intel FPGA cards.
> 
> The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
> as PTP Hardware clock(PHC) device to the Linux PTP stack to synchronize
> the system clock to its ToD information using phc2sys utility of the
> Linux PTP stack. The DFL is a hardware List within FPGA, which defines
> a linked list of feature headers within the device MMIO space to provide
> an extensible way of adding subdevice features.
> 
> Signed-off-by: Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
> Signed-off-by: Tianfei Zhang <tianfei.zhang@intel.com>
> ---
>  MAINTAINERS               |   7 +
>  drivers/ptp/Kconfig       |  13 ++
>  drivers/ptp/Makefile      |   1 +
>  drivers/ptp/ptp_dfl_tod.c | 334 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 355 insertions(+)
>  create mode 100644 drivers/ptp/ptp_dfl_tod.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ec57c42ed544..584979abbd92 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15623,6 +15623,13 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/ptp/ptp_ocp.c
>  
> +INTEL PTP DFL ToD DRIVER
> +M:	Tianfei Zhang <tianfei.zhang@intel.com>
> +L:	linux-fpga@vger.kernel.org
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/ptp/ptp_dfl_tod.c
> +
>  OPENCORES I2C BUS DRIVER
>  M:	Peter Korsgaard <peter@korsgaard.com>
>  M:	Andrew Lunn <andrew@lunn.ch>
> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> index fe4971b65c64..e0d6f136ee46 100644
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -186,4 +186,17 @@ config PTP_1588_CLOCK_OCP
>  
>  	  More information is available at http://www.timingcard.com/
>  
> +config PTP_DFL_TOD
> +	tristate "FPGA DFL ToD Driver"
> +	depends on FPGA_DFL
> +	help
> +	  The DFL (Device Feature List) device driver for the Intel ToD
> +	  (Time-of-Day) device in FPGA card. The ToD IP within the FPGA
> +	  is exposed as PTP Hardware Clock (PHC) device to the Linux PTP
> +	  stack to synchronize the system clock to its ToD information
> +	  using phc2sys utility of the Linux PTP stack.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called ptp_dfl_tod.
> +
>  endmenu
> diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
> index 28a6fe342d3e..553f18bf3c83 100644
> --- a/drivers/ptp/Makefile
> +++ b/drivers/ptp/Makefile
> @@ -18,3 +18,4 @@ obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
>  obj-$(CONFIG_PTP_1588_CLOCK_IDT82P33)	+= ptp_idt82p33.o
>  obj-$(CONFIG_PTP_1588_CLOCK_VMW)	+= ptp_vmw.o
>  obj-$(CONFIG_PTP_1588_CLOCK_OCP)	+= ptp_ocp.o
> +obj-$(CONFIG_PTP_DFL_TOD)		+= ptp_dfl_tod.o
> diff --git a/drivers/ptp/ptp_dfl_tod.c b/drivers/ptp/ptp_dfl_tod.c
> new file mode 100644
> index 000000000000..d9fbdfc53bd8
> --- /dev/null
> +++ b/drivers/ptp/ptp_dfl_tod.c
> @@ -0,0 +1,334 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * DFL device driver for Time-of-Day (ToD) private feature
> + *
> + * Copyright (C) 2023 Intel Corporation
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/delay.h>
> +#include <linux/dfl.h>
> +#include <linux/gcd.h>
> +#include <linux/iopoll.h>
> +#include <linux/module.h>
> +#include <linux/ptp_clock_kernel.h>
> +#include <linux/spinlock.h>
> +#include <linux/units.h>
> +
> +#define FME_FEATURE_ID_TOD		0x22
> +
> +/* ToD clock register space. */
> +#define TOD_CLK_FREQ			0x038
> +
> +/*
> + * The read sequence of ToD timestamp registers: TOD_NANOSEC, TOD_SECONDSL and
> + * TOD_SECONDSH, because there is a hardware snapshot whenever the TOD_NANOSEC
> + * register is read.
> + *
> + * The ToD IP requires writing registers in the reverse order to the read sequence.
> + * The timestamp is corrected when the TOD_NANOSEC register is written, so the
> + * sequence of write TOD registers: TOD_SECONDSH, TOD_SECONDSL and TOD_NANOSEC.
> + */
> +#define TOD_SECONDSH			0x100
> +#define TOD_SECONDSL			0x104
> +#define TOD_NANOSEC			0x108
> +#define TOD_PERIOD			0x110
> +#define TOD_ADJUST_PERIOD		0x114
> +#define TOD_ADJUST_COUNT		0x118
> +#define TOD_DRIFT_ADJUST		0x11c
> +#define TOD_DRIFT_ADJUST_RATE		0x120
> +#define PERIOD_FRAC_OFFSET		16
> +#define SECONDS_MSB			GENMASK_ULL(47, 32)
> +#define SECONDS_LSB			GENMASK_ULL(31, 0)
> +#define TOD_SECONDSH_SEC_MSB		GENMASK_ULL(15, 0)
> +
> +#define CAL_SECONDS(m, l)		((FIELD_GET(TOD_SECONDSH_SEC_MSB, (m)) << 32) | (l))
> +
> +#define TOD_PERIOD_MASK		GENMASK_ULL(19, 0)
> +#define TOD_PERIOD_MAX			FIELD_MAX(TOD_PERIOD_MASK)
> +#define TOD_PERIOD_MIN			0
> +#define TOD_DRIFT_ADJUST_MASK		GENMASK_ULL(15, 0)
> +#define TOD_DRIFT_ADJUST_FNS_MAX	FIELD_MAX(TOD_DRIFT_ADJUST_MASK)
> +#define TOD_DRIFT_ADJUST_RATE_MAX	TOD_DRIFT_ADJUST_FNS_MAX
> +#define TOD_ADJUST_COUNT_MASK		GENMASK_ULL(19, 0)
> +#define TOD_ADJUST_COUNT_MAX		FIELD_MAX(TOD_ADJUST_COUNT_MASK)
> +#define TOD_ADJUST_INTERVAL_US		1000
> +#define TOD_ADJUST_MS			\
> +		(((TOD_PERIOD_MAX >> 16) + 1) * (TOD_ADJUST_COUNT_MAX + 1))
> +#define TOD_ADJUST_MS_MAX		(TOD_ADJUST_MS / MICRO)
> +#define TOD_ADJUST_MAX_US		(TOD_ADJUST_MS_MAX * USEC_PER_MSEC)
> +#define TOD_MAX_ADJ			(500 * MEGA)
> +
> +struct dfl_tod {
> +	struct ptp_clock_info ptp_clock_ops;
> +	struct device *dev;
> +	struct ptp_clock *ptp_clock;
> +
> +	/* ToD Clock address space */
> +	void __iomem *tod_ctrl;
> +
> +	/* ToD clock registers protection */
> +	spinlock_t tod_lock;
> +};
> +
> +/*
> + * A fine ToD HW clock offset adjustment. To perform the fine offset adjustment, the
> + * adjust_period and adjust_count argument are used to update the TOD_ADJUST_PERIOD
> + * and TOD_ADJUST_COUNT register for in hardware. The dt->tod_lock spinlock must be
> + * held when calling this function.
> + */

Calling this function while holding the dt->tod_lock spinlock might cause an error
since read_poll_timeout() can sleep. If it is required to use a spinlock, there is
the readl_poll_timeout_atomic() function, which can be called from atomic context.
However, in this case, it is probably better to use a mutex instead of a spinlock
since the delay appears to be 1 ms.

> +static int fine_adjust_tod_clock(struct dfl_tod *dt, u32 adjust_period,
> +				 u32 adjust_count)
> +{
> +	void __iomem *base = dt->tod_ctrl;
> +	u32 val;
> +
> +	writel(adjust_period, base + TOD_ADJUST_PERIOD);
> +	writel(adjust_count, base + TOD_ADJUST_COUNT);
> +
> +	/* Wait for present offset adjustment update to complete */
> +	return readl_poll_timeout(base + TOD_ADJUST_COUNT, val, !val, TOD_ADJUST_INTERVAL_US,
> +				  TOD_ADJUST_MAX_US);
> +}
> +
> +/*
> + * A coarse ToD HW clock offset adjustment.
> + * The coarse time adjustment performs by adding or subtracting the delta value
> + * from the current ToD HW clock time.
> + */
> +static int coarse_adjust_tod_clock(struct dfl_tod *dt, s64 delta)
> +{
> +	u32 seconds_msb, seconds_lsb, nanosec;
> +	void __iomem *base = dt->tod_ctrl;
> +	u64 seconds, now;
> +
> +	if (delta == 0)
> +		return 0;
> +
> +	nanosec = readl(base + TOD_NANOSEC);
> +	seconds_lsb = readl(base + TOD_SECONDSL);
> +	seconds_msb = readl(base + TOD_SECONDSH);
> +
> +	/* Calculate new time */
> +	seconds = CAL_SECONDS(seconds_msb, seconds_lsb);
> +	now = seconds * NSEC_PER_SEC + nanosec + delta;
> +
> +	seconds = div_u64_rem(now, NSEC_PER_SEC, &nanosec);
> +	seconds_msb = FIELD_GET(SECONDS_MSB, seconds);
> +	seconds_lsb = FIELD_GET(SECONDS_LSB, seconds);
> +
> +	writel(seconds_msb, base + TOD_SECONDSH);
> +	writel(seconds_lsb, base + TOD_SECONDSL);
> +	writel(nanosec, base + TOD_NANOSEC);
> +
> +	return 0;
> +}
> +
> +static int dfl_tod_adjust_fine(struct ptp_clock_info *ptp, long scaled_ppm)
> +{
> +	struct dfl_tod *dt = container_of(ptp, struct dfl_tod, ptp_clock_ops);
> +	u32 tod_period, tod_rem, tod_drift_adjust_fns, tod_drift_adjust_rate;
> +	void __iomem *base = dt->tod_ctrl;
> +	unsigned long flags, rate;
> +	u64 ppb;
> +
> +	/* Get the clock rate from clock frequency register offset */
> +	rate = readl(base + TOD_CLK_FREQ);
> +
> +	/* add GIGA as nominal ppb */
> +	ppb = scaled_ppm_to_ppb(scaled_ppm) + GIGA;
> +
> +	tod_period = div_u64_rem(ppb << PERIOD_FRAC_OFFSET, rate, &tod_rem);
> +	if (tod_period > TOD_PERIOD_MAX)
> +		return -ERANGE;
> +
> +	/*
> +	 * The drift of ToD adjusted periodically by adding a drift_adjust_fns
> +	 * correction value every drift_adjust_rate count of clock cycles.
> +	 */
> +	tod_drift_adjust_fns = tod_rem / gcd(tod_rem, rate);
> +	tod_drift_adjust_rate = rate / gcd(tod_rem, rate);
> +
> +	while ((tod_drift_adjust_fns > TOD_DRIFT_ADJUST_FNS_MAX) ||
> +	       (tod_drift_adjust_rate > TOD_DRIFT_ADJUST_RATE_MAX)) {
> +		tod_drift_adjust_fns >>= 1;
> +		tod_drift_adjust_rate >>= 1;
> +	}

Why both tod_drift_adjust_fns and tod_drift_adjust_rate are iteratively divided
if one of the two exceeds the maximum value? Wouldn't it be more accurate to set
each of them to the max if they exceeded their respective maximum value?

> +
> +	if (tod_drift_adjust_fns == 0)
> +		tod_drift_adjust_rate = 0;
> +
> +	spin_lock_irqsave(&dt->tod_lock, flags);
> +	writel(tod_period, base + TOD_PERIOD);
> +	writel(0, base + TOD_ADJUST_PERIOD);
> +	writel(0, base + TOD_ADJUST_COUNT);
> +	writel(tod_drift_adjust_fns, base + TOD_DRIFT_ADJUST);
> +	writel(tod_drift_adjust_rate, base + TOD_DRIFT_ADJUST_RATE);
> +	spin_unlock_irqrestore(&dt->tod_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int dfl_tod_adjust_time(struct ptp_clock_info *ptp, s64 delta)
> +{
> +	struct dfl_tod *dt = container_of(ptp, struct dfl_tod, ptp_clock_ops);
> +	u32 period, diff, rem, rem_period, adj_period;
> +	void __iomem *base = dt->tod_ctrl;
> +	unsigned long flags;
> +	bool neg_adj;
> +	u64 count;
> +	int ret;
> +
> +	neg_adj = delta < 0;
> +	if (neg_adj)
> +		delta = -delta;
> +
> +	spin_lock_irqsave(&dt->tod_lock, flags);
> +
> +	/*
> +	 * Get the maximum possible value of the Period register offset
> +	 * adjustment in nanoseconds scale. This depends on the current
> +	 * Period register setting and the maximum and minimum possible
> +	 * values of the Period register.
> +	 */
> +	period = readl(base + TOD_PERIOD);
> +
> +	if (neg_adj) {
> +		diff = (period - TOD_PERIOD_MIN) >> PERIOD_FRAC_OFFSET;
> +		adj_period = period - (diff << PERIOD_FRAC_OFFSET);
> +		rem_period = period - (rem << PERIOD_FRAC_OFFSET);

rem seems to be uninitialized here.

> +	} else {
> +		diff = (TOD_PERIOD_MAX - period) >> PERIOD_FRAC_OFFSET;
> +		adj_period = period + (diff << PERIOD_FRAC_OFFSET);
> +		rem_period = period + (rem << PERIOD_FRAC_OFFSET);
> +	}
> +
> +	ret = 0;
> +
> +	/* Find the number of cycles required for the time adjustment */
> +	count = div_u64_rem(delta, diff, &rem);
> +
> +	if (count > TOD_ADJUST_COUNT_MAX) {
> +		ret = coarse_adjust_tod_clock(dt, delta);
> +	} else {
> +		/* Adjust the period by count cycles to adjust the time */
> +		if (count)
> +			ret = fine_adjust_tod_clock(dt, adj_period, count);
> +
> +		/* If there is a remainder, adjust the period for an additional cycle */
> +		if (rem)
> +			ret = fine_adjust_tod_clock(dt, rem_period, 1);
> +	}
> +
> +	spin_unlock_irqrestore(&dt->tod_lock, flags);
> +
> +	return ret;
> +}
> +
> +static int dfl_tod_get_timex(struct ptp_clock_info *ptp, struct timespec64 *ts,
> +			     struct ptp_system_timestamp *sts)
> +{
> +	struct dfl_tod *dt = container_of(ptp, struct dfl_tod, ptp_clock_ops);
> +	u32 seconds_msb, seconds_lsb, nanosec;
> +	void __iomem *base = dt->tod_ctrl;
> +	unsigned long flags;
> +	u64 seconds;
> +
> +	spin_lock_irqsave(&dt->tod_lock, flags);
> +	ptp_read_system_prets(sts);
> +	nanosec = readl(base + TOD_NANOSEC);
> +	seconds_lsb = readl(base + TOD_SECONDSL);
> +	seconds_msb = readl(base + TOD_SECONDSH);
> +	ptp_read_system_postts(sts);
> +	spin_unlock_irqrestore(&dt->tod_lock, flags);
> +
> +	seconds = CAL_SECONDS(seconds_msb, seconds_lsb);
> +
> +	ts->tv_nsec = nanosec;
> +	ts->tv_sec = seconds;
> +
> +	return 0;
> +}
> +
> +static int dfl_tod_set_time(struct ptp_clock_info *ptp,
> +			    const struct timespec64 *ts)
> +{
> +	struct dfl_tod *dt = container_of(ptp, struct dfl_tod, ptp_clock_ops);
> +	u32 seconds_msb = FIELD_GET(SECONDS_MSB, ts->tv_sec);
> +	u32 seconds_lsb = FIELD_GET(SECONDS_LSB, ts->tv_sec);
> +	u32 nanosec = FIELD_GET(SECONDS_LSB, ts->tv_nsec);
> +	void __iomem *base = dt->tod_ctrl;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dt->tod_lock, flags);
> +	writel(seconds_msb, base + TOD_SECONDSH);
> +	writel(seconds_lsb, base + TOD_SECONDSL);
> +	writel(nanosec, base + TOD_NANOSEC);
> +	spin_unlock_irqrestore(&dt->tod_lock, flags);
> +
> +	return 0;
> +}
> +
> +static struct ptp_clock_info dfl_tod_clock_ops = {
> +	.owner = THIS_MODULE,
> +	.name = "dfl_tod",
> +	.max_adj = TOD_MAX_ADJ,
> +	.adjfine = dfl_tod_adjust_fine,
> +	.adjtime = dfl_tod_adjust_time,
> +	.gettimex64 = dfl_tod_get_timex,
> +	.settime64 = dfl_tod_set_time,
> +};
> +
> +static int dfl_tod_probe(struct dfl_device *ddev)
> +{
> +	struct device *dev = &ddev->dev;
> +	struct dfl_tod *dt;
> +
> +	dt = devm_kzalloc(dev, sizeof(*dt), GFP_KERNEL);
> +	if (!dt)
> +		return -ENOMEM;
> +
> +	dt->tod_ctrl = devm_ioremap_resource(dev, &ddev->mmio_res);
> +	if (IS_ERR(dt->tod_ctrl))
> +		return PTR_ERR(dt->tod_ctrl);
> +
> +	dt->dev = dev;
> +	spin_lock_init(&dt->tod_lock);
> +	dev_set_drvdata(dev, dt);
> +
> +	dt->ptp_clock_ops = dfl_tod_clock_ops;
> +
> +	dt->ptp_clock = ptp_clock_register(&dt->ptp_clock_ops, dev);
> +	if (IS_ERR(dt->ptp_clock))
> +		return dev_err_probe(dt->dev, PTR_ERR(dt->ptp_clock),
> +				     "Unable to register PTP clock\n");
> +
> +	return 0;
> +}
> +
> +static void dfl_tod_remove(struct dfl_device *ddev)
> +{
> +	struct dfl_tod *dt = dev_get_drvdata(&ddev->dev);
> +
> +	ptp_clock_unregister(dt->ptp_clock);
> +}
> +
> +static const struct dfl_device_id dfl_tod_ids[] = {
> +	{ FME_ID, FME_FEATURE_ID_TOD },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(dfl, dfl_tod_ids);
> +
> +static struct dfl_driver dfl_tod_driver = {
> +	.drv = {
> +		.name = "dfl-tod",
> +	},
> +	.id_table = dfl_tod_ids,
> +	.probe = dfl_tod_probe,
> +	.remove = dfl_tod_remove,
> +};
> +module_dfl_driver(dfl_tod_driver);
> +
> +MODULE_DESCRIPTION("FPGA DFL ToD driver");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_LICENSE("GPL");
> 
> base-commit: eeac8ede17557680855031c6f305ece2378af326

Thanks,
Marco

