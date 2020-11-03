Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B3D2A57A3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgKCVof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731261AbgKCVoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 16:44:24 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C7822384;
        Tue,  3 Nov 2020 21:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604439863;
        bh=kCiqbrIpwpn+oC3iCGU6eE2bfo+kdByMFbDLLV6gnMM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bHVqwCu6RVBQnhUjouxlWImYD/Fcbol1XJRVMLohBsNt94BGOlzjr1dFvk484ROWr
         9R6cQ2piym48KQDXKM9K9KdX4TOYFvG4CbcS1Zu4seHjD0e96mIbfor7ZnWf/dQEko
         UWG0/81tFjXYg2eEGs1hTXPBWgr17yQsv94aOpx4=
Date:   Tue, 3 Nov 2020 13:44:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net 1/1] ptp: idt82p33: add adjphase support
Message-ID: <20201103134421.7f940b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604330848-25567-1-git-send-email-min.li.xe@renesas.com>
References: <1604330848-25567-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 10:27:28 -0500 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add idt82p33_adjwritephase() to support PHC write phase mode.
> 
> Changes since v1:
> - Fix broken build on 32 bit machine due to 64 bit division.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_idt82p33.c | 317 ++++++++++++++++++++++++++++++++++-----------
>  drivers/ptp/ptp_idt82p33.h |   3 +
>  2 files changed, 244 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
> index 179f6c4..ed1659e 100644
> --- a/drivers/ptp/ptp_idt82p33.c
> +++ b/drivers/ptp/ptp_idt82p33.c
> @@ -33,6 +33,9 @@ module_param(phase_snap_threshold, uint, 0);
>  MODULE_PARM_DESC(phase_snap_threshold,
>  "threshold (150000ns by default) below which adjtime would ignore");
>  
> +static char *firmware;
> +module_param(firmware, charp, 0);

The commit message does not explain the need for FW. Please at least
mention it. Also please avoid the module parameter. Decide on a
standard name for the FW and use MODULE_FIRMWARE() to mark the
dependency.

>  static void idt82p33_byte_array_to_timespec(struct timespec64 *ts,
>  					    u8 buf[TOD_BYTE_COUNT])
>  {
> @@ -77,15 +80,15 @@ static void idt82p33_timespec_to_byte_array(struct timespec64 const *ts,
>  	}
>  }
>  
> -static int idt82p33_xfer(struct idt82p33 *idt82p33,
> -			 unsigned char regaddr,
> -			 unsigned char *buf,
> -			 unsigned int count,
> -			 int write)
> +static int idt82p33_xfer_read(struct idt82p33 *idt82p33,
> +			      unsigned char regaddr,
> +			      unsigned char *buf,
> +			      unsigned int count)
>  {
>  	struct i2c_client *client = idt82p33->client;
>  	struct i2c_msg msg[2];
>  	int cnt;
> +	char *fmt = "i2c_transfer failed at %d in %s, at addr: %04X!\n";

Why are you moving the formats out? This is the first time I've seen
this done.

>  	msg[0].addr = client->addr;
>  	msg[0].flags = 0;
> @@ -93,13 +96,17 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
>  	msg[0].buf = &regaddr;
>  
>  	msg[1].addr = client->addr;
> -	msg[1].flags = write ? 0 : I2C_M_RD;
> +	msg[1].flags = I2C_M_RD;
>  	msg[1].len = count;
>  	msg[1].buf = buf;
>  
>  	cnt = i2c_transfer(client->adapter, msg, 2);
>  	if (cnt < 0) {
> -		dev_err(&client->dev, "i2c_transfer returned %d\n", cnt);
> +		dev_err(&client->dev,
> +			fmt,
> +			__LINE__,
> +			__func__,

Do you really need those line references?

Please use meaningful messages instead.

> +			(u8) regaddr);

Why the cast, it's already unsigned char.

>  		return cnt;
>  	} else if (cnt != 2) {
>  		dev_err(&client->dev,
> @@ -109,6 +116,37 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
>  	return 0;
>  }
>  
> +static int idt82p33_xfer_write(struct idt82p33 *idt82p33,
> +			       u8 regaddr,
> +			       u8 *buf,
> +			       u16 count)
> +{
> +	struct i2c_client *client = idt82p33->client;
> +	/* we add 1 byte for device register */
> +	u8 msg[IDT82P33_MAX_WRITE_COUNT + 1];
> +	int cnt;
> +	char *fmt = "i2c_master_send failed at %d in %s, at addr: %04X!\n";
> +
> +	if (count > IDT82P33_MAX_WRITE_COUNT)
> +		return -EINVAL;
> +
> +	msg[0] = regaddr;
> +	memcpy(&msg[1], buf, count);
> +
> +	cnt = i2c_master_send(client, msg, count + 1);
> +
> +	if (cnt < 0) {

Please don't put empty lines between a function call and its error checking.

Also looks like cnt should really be called 'err' or 'ret' here.

> +		dev_err(&client->dev,
> +			fmt,
> +			__LINE__,
> +			__func__,
> +			regaddr);
> +		return cnt;
> +	}
> +
> +	return 0;
> +}
> +
>  static int idt82p33_page_offset(struct idt82p33 *idt82p33, unsigned char val)
>  {
>  	int err;
> @@ -116,7 +154,7 @@ static int idt82p33_page_offset(struct idt82p33 *idt82p33, unsigned char val)
>  	if (idt82p33->page_offset == val)
>  		return 0;
>  
> -	err = idt82p33_xfer(idt82p33, PAGE_ADDR, &val, sizeof(val), 1);
> +	err = idt82p33_xfer_write(idt82p33, PAGE_ADDR, &val, sizeof(val));

This refactoring for xfer() -> xfer_read()/xfer_write() should be a
separate patch, forming a series.

>  	if (err)
>  		dev_err(&idt82p33->client->dev,
>  			"failed to set page offset %d\n", val);

> @@ -314,16 +352,9 @@ static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
>  	 * FCW = -------------
>  	 *         168 * 2^4
>  	 */
> -	if (scaled_ppm < 0) {
> -		neg_adj = 1;
> -		scaled_ppm = -scaled_ppm;
> -	}
>  
>  	fcw = scaled_ppm * 244140625ULL;
> -	fcw = div_u64(fcw, 2688);
> -
> -	if (neg_adj)
> -		fcw = -fcw;
> +	fcw = div_s64(fcw, 2688);

Looks unrelated to adjphase support, make it a separate patch.

>  	for (i = 0; i < 5; i++) {
>  		buf[i] = fcw & 0xff;

> @@ -518,12 +554,10 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
>  	u8 sync_cnfg;
>  	int err;
>  
> -	if (enable == channel->sync_tod_on) {
> -		if (enable && sync_tod_timeout) {
> -			mod_delayed_work(system_wq, &channel->sync_tod_work,
> -					 sync_tod_timeout * HZ);
> -		}
> -		return 0;
> +	/* Turn it off after sync_tod_timeout seconds */
> +	if (enable && sync_tod_timeout) {
> +		ptp_schedule_worker(channel->ptp_clock,
> +				    sync_tod_timeout * HZ);

Parenthesis are not necessary around single line statements.

>  	}
>  
>  	err = idt82p33_read(idt82p33, channel->dpll_sync_cnfg,

> +static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32 offsetNs)
> +{
> +	struct idt82p33_channel *channel =
> +		container_of(ptp, struct idt82p33_channel, caps);
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	s64 offsetInFs;
> +	s64 offsetRegVal;
> +	u8 val[4] = {0};

Please order variable declaration lines longest to shortest.

> +	int err;
> +
> +	offsetInFs = (s64)(-offsetNs) * 1000000;
> +
> +	if (offsetInFs > WRITE_PHASE_OFFSET_LIMIT)
> +		offsetInFs = WRITE_PHASE_OFFSET_LIMIT;
> +	else if (offsetInFs < -WRITE_PHASE_OFFSET_LIMIT)
> +		offsetInFs = -WRITE_PHASE_OFFSET_LIMIT;
> +
> +	/* Convert from phaseOffsetInFs to register value */
> +	offsetRegVal = div_s64(offsetInFs * 1000, IDT_T0DPLL_PHASE_RESOL);
