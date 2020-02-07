Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426A41559FA
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 15:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgBGOry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 09:47:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43294 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGOry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 09:47:54 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8159E15AD852B;
        Fri,  7 Feb 2020 06:47:52 -0800 (PST)
Date:   Fri, 07 Feb 2020 15:47:50 +0100 (CET)
Message-Id: <20200207.154750.2170520195543672211.davem@davemloft.net>
To:     min.li.xe@renesas.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ptp: Add a ptp clock driver for IDT 82P33
 SMU.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1580934291-15468-1-git-send-email-min.li.xe@renesas.com>
References: <1580934291-15468-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 06:47:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: min.li.xe@renesas.com
Date: Wed,  5 Feb 2020 15:24:51 -0500

> +/* Initializer */
> +#define CHANNEL_INIT(chan, index) do { \
> +	chan->dpll_tod_cnfg = DPLL##index##_TOD_CNFG; \
> +	chan->dpll_tod_trigger = DPLL##index##_TOD_TRIGGER; \
> +	chan->dpll_tod_sts = DPLL##index##_TOD_STS; \
> +	chan->dpll_mode_cnfg = DPLL##index##_OPERATING_MODE_CNFG; \
> +	chan->dpll_freq_cnfg = DPLL##index##_HOLDOVER_FREQ_CNFG; \
> +	chan->dpll_phase_cnfg = DPLL##index##_PHASE_OFFSET_CNFG; \
> +	chan->dpll_sync_cnfg = DPLL##index##_SYNC_EDGE_CNFG; \
> +	chan->dpll_input_mode_cnfg = DPLL##index##_INPUT_MODE_CNFG; \
> +	INIT_DELAYED_WORK(&chan->sync_tod_work, \
> +			idt82p33_sync_tod_work_handler); \
> +	chan->sync_tod_on = false; \
> +	chan->current_freq_ppb = 0; \
> +} while (0)

This is messy and really belongs in a helper function.

The only thing the index does is decide the register offsets
which are conveniently exactly 0x80 bytes apart.  And you can
use this knowledge to implement a real C function instead of
using CPP expansion magic.

> +static void idt82p33_caps_init(struct ptp_clock_info	*caps)
> +{
> +	(caps)->owner = THIS_MODULE;

The parenthesis around caps is unnecessary.  I suspect this code
was also originally coded in a CPP macro. :-)

> +static void idt82p33_byte_array_to_timespec(struct timespec64 *ts,
> +				u8 buf[TOD_BYTE_COUNT])
> +{
> +	u8 i;
> +	s32 nsec;
> +	time64_t sec;

Please us reverse christmas tree ordering for local variables.

> +static void idt82p33_timespec_to_byte_array(struct timespec64 const *ts,
> +				  u8 buf[TOD_BYTE_COUNT])
> +{
> +	u8 i;
> +	s32 nsec = ts->tv_nsec;
> +	time64_t sec = ts->tv_sec;

Likewise.

> +static int idt82p33_rdwr(struct idt82p33 *idt82p33, unsigned int regaddr,
> +			unsigned char *buf, unsigned int count, bool write)
> +{
> +	int err;
> +	u8 page;
> +	u8 offset;

Likewise.

> +static int idt82p33_dpll_set_mode(struct idt82p33_channel *channel,
> +				enum pll_mode mode)
> +{
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	int err;
> +	u8 dpll_mode;

Likewise.

> +static int _idt82p33_gettime(struct idt82p33_channel *channel,
> +			struct timespec64 *ts)
> +{
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	int err;
> +	u8 buf[TOD_BYTE_COUNT];
> +	u8 trigger;

Likewise.

> +
> +	trigger = TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
> +						HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);

This is indented improperly.  The second line should be indented
exactly to the first column after the openning parenthesis of the
first line.  You should use the appropriate number of TAB then SPACE
characters necessary to achieve this.

You should audit this entire file for this problem as I see it in
many places.

> +static int _idt82p33_settime(struct idt82p33_channel *channel,
> +			struct timespec64 const *ts)
> +{
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	int err;
> +	u8 i;
> +	unsigned char trigger;
> +	struct timespec64 local_ts = *ts;
> +	char buf[TOD_BYTE_COUNT];
> +	s64 dynamic_overhead_ns;

Reverse christmas tree please.

> +static int _idt82p33_adjtime(struct idt82p33_channel *channel, s64 delta_ns)
> +{
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	s64 now_ns;
> +	int err;
> +	struct timespec64 ts;

Likewise.

> +static int _idt82p33_adjfreq(struct idt82p33_channel *channel, s32 ppb)
> +{
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	int err;
> +	int i;
> +	int neg_adj = 0;
> +	unsigned char buf[5] = {0};
> +	s64 fcw;

Likewise.

> +static int idt82p33_measure_one_byte_write_overhead(
> +			struct idt82p33_channel *channel, s64 *overhead_ns)
> +{
> +	int err;
> +	u8 i;
> +	ktime_t start;
> +	ktime_t stop;
> +	u8 trigger;
> +	s64 total_ns;
> +	struct idt82p33 *idt82p33 = channel->idt82p33;

Likewise, and combine same type variables into a single line such as:

	ktime_t start, stop;

to save vertical space.

> +static int idt82p33_measure_tod_write_9_byte_overhead(
> +					struct idt82p33_channel *channel)
> +{
> +	int err = 0;
> +	u8 i;
> +	u8 j;
> +	ktime_t start;
> +	ktime_t stop;
> +	u8 buf[TOD_BYTE_COUNT];
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	s64 total_ns;

Likewise.

> +static int idt82p33_measure_settime_gettime_gap_overhead(
> +					struct idt82p33_channel *channel,
> +					s64 *overhead_ns)
> +{
> +	int err;
> +	struct timespec64 ts1 = {0, 0};
> +	struct timespec64 ts2;

Likewise.

> +static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel *channel)
> +{
> +	int err;
> +	s64 gap_ns;
> +	s64 one_byte_write_ns;
> +	s64 trailing_overhead_ns;
> +	struct idt82p33 *idt82p33 = channel->idt82p33;

Likewise.

> +static void idt82p33_display_masks(struct idt82p33 *idt82p33)
> +{
> +	u8 i;
> +	u8 mask;

Likewise.

> +static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
> +{
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	int err;
> +	u8 sync_cnfg;

Likewise.

> +static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enable)
> +{
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	u8 val;
> +	int err;
> +	u8 mask;
> +	u8 outn;

Likewise.

> +static int idt82p33_enable_tod(struct idt82p33_channel *channel)
> +{
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	int err;
> +	struct timespec64 ts = {0, 0};
> +	u8 val;

Likewise.

And so on and so forth for the rest of the driver.

Thank you.
