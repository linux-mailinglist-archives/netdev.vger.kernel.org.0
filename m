Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D972A8C1F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 02:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732964AbgKFBaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 20:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730906AbgKFBaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 20:30:02 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64C5220759;
        Fri,  6 Nov 2020 01:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604626200;
        bh=gs8qOEwsBWJGmCYvdyusXp44ywe5fFGnAZd3qd8VLhM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iy0bhVs5gw2K9oLD3ucU885Otg3swHp1QazSqdiT378SvZTh5ykRwv1osGzVMEA9n
         ODg58roOSQtK/p0t6PwmPh4XqxH9UOhRU5fpUjCYlkzSM4dwEwF9Y7iJISXZdAAWwP
         3Qf08OvlTClSRpraSwTgrh7+q9+gfhUCObq/NHkA=
Date:   Thu, 5 Nov 2020 17:29:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 1/3] ptp: idt82p33: add adjphase support
Message-ID: <20201105172959.4d6467b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604535735-19180-1-git-send-email-min.li.xe@renesas.com>
References: <1604535735-19180-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 19:22:13 -0500 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add idt82p33_adjphase() to support PHC write phase mode.
> 
> Changes since v1:
> -Fix broken build
> 
> Changes since v2:
> -Fix trailing space
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> 

Please drop the empty line between tags.

> Acked-by: Richard Cochran <richardcochran@gmail.com>

> diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
> index 179f6c4..d52fa67 100644
> --- a/drivers/ptp/ptp_idt82p33.c
> +++ b/drivers/ptp/ptp_idt82p33.c
> @@ -21,6 +21,7 @@ MODULE_DESCRIPTION("Driver for IDT 82p33xxx clock devices");
>  MODULE_AUTHOR("IDT support-1588 <IDT-support-1588@lm.renesas.com>");
>  MODULE_VERSION("1.0");
>  MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE(FW_FILENAME);
>  
>  /* Module Parameters */
>  static u32 sync_tod_timeout = SYNC_TOD_TIMEOUT_SEC;
> @@ -129,8 +130,9 @@ static int idt82p33_page_offset(struct idt82p33 *idt82p33, unsigned char val)
>  static int idt82p33_rdwr(struct idt82p33 *idt82p33, unsigned int regaddr,
>  			 unsigned char *buf, unsigned int count, bool write)
>  {
> -	u8 offset, page;
>  	int err;
> +	u8 page;
> +	u8 offset;

Please don't make unrelated changes in your patches.

>  	page = _PAGE(regaddr);
>  	offset = _OFFSET(regaddr);
> @@ -145,13 +147,13 @@ static int idt82p33_rdwr(struct idt82p33 *idt82p33, unsigned int regaddr,
>  }
>  
>  static int idt82p33_read(struct idt82p33 *idt82p33, unsigned int regaddr,
> -			unsigned char *buf, unsigned int count)
> +			 unsigned char *buf, unsigned int count)

Unrelated change.

>  {
>  	return idt82p33_rdwr(idt82p33, regaddr, buf, count, false);
>  }
>  
>  static int idt82p33_write(struct idt82p33 *idt82p33, unsigned int regaddr,
> -			unsigned char *buf, unsigned int count)
> +			  unsigned char *buf, unsigned int count)

Unrelated change.

>  {
>  	return idt82p33_rdwr(idt82p33, regaddr, buf, count, true);
>  }

> @@ -541,20 +543,13 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
>  	if (err)
>  		return err;
>  
> -	channel->sync_tod_on = enable;
> -
> -	if (enable && sync_tod_timeout) {
> -		mod_delayed_work(system_wq, &channel->sync_tod_work,
> -				 sync_tod_timeout * HZ);
> -	}
> -
>  	return 0;

You can simplify 

	err = idt82...
	if (err)
		return err;

	return 0;

to:

	return idt82p33_write(idt82p33, channel->dpll_sync_cnfg,
	                      &sync_cnfg, sizeof(sync_cnfg));

>  }

> -static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enable)
> +static int idt82p33_output_enable(struct idt82p33_channel *channel,
> +				  bool enable, unsigned int outn)
>  {
>  	struct idt82p33 *idt82p33 = channel->idt82p33;
> -	u8 mask, outn, val;
>  	int err;
> +	u8 val;
> +
> +	err = idt82p33_read(idt82p33, OUT_MUX_CNFG(outn), &val, sizeof(val));
> +

unnecessary empty line

> +	if (err)
> +		return err;
> +
> +	if (enable)
> +		val &= ~SQUELCH_ENABLE;
> +	else
> +		val |= SQUELCH_ENABLE;
> +
> +	return idt82p33_write(idt82p33, OUT_MUX_CNFG(outn), &val, sizeof(val));
> +}
> +
> +static int idt82p33_output_mask_enable(struct idt82p33_channel *channel,
> +				       bool enable)
> +{
> +	u16 mask;
> +	int err;
> +	u8 outn;
>  
>  	mask = channel->output_mask;
>  	outn = 0;
>  
>  	while (mask) {
> -		if (mask & 0x1) {
> -			err = idt82p33_read(idt82p33, OUT_MUX_CNFG(outn),
> -					    &val, sizeof(val));
> -			if (err)
> -				return err;
>  

unnecessary empty line

> -			if (enable)
> -				val &= ~SQUELCH_ENABLE;
> -			else
> -				val |= SQUELCH_ENABLE;
> +		if (mask & 0x1) {
>  

unnecessary empty line

> -			err = idt82p33_write(idt82p33, OUT_MUX_CNFG(outn),
> -					     &val, sizeof(val));
> +			err = idt82p33_output_enable(channel, enable, outn);
>  

unnecessary empty line

>  			if (err)
>  				return err;
>  		}
> +
>  		mask >>= 0x1;
>  		outn++;
>  	}

> @@ -659,14 +680,16 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
>  
>  	if (rq->type == PTP_CLK_REQ_PEROUT) {
>  		if (!on)
> -			err = idt82p33_pps_enable(channel, false);
> +			err = idt82p33_perout_enable(channel, false,
> +						     &rq->perout);
>  

unnecessary empty line

>  		/* Only accept a 1-PPS aligned to the second. */
>  		else if (rq->perout.start.nsec || rq->perout.period.sec != 1 ||
>  		    rq->perout.period.nsec) {
>  			err = -ERANGE;
>  		} else
> -			err = idt82p33_pps_enable(channel, true);
> +			err = idt82p33_perout_enable(channel, true,
> +						     &rq->perout);
>  	}
>  
>  	mutex_unlock(&idt82p33->reg_lock);
> @@ -674,6 +697,49 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
>  	return err;
>  }
>  
> +static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32 offsetNs)
> +{
> +	struct idt82p33_channel *channel =
> +		container_of(ptp, struct idt82p33_channel, caps);
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	s64 offsetInFs;
> +	s64 offsetRegVal;

please don't use cammelCase, I think checkpatch tries to warn about
this.

Also please try to order the variable declaration lines longest to
shortest (where possible, the channel declaration here should stay
first).

> +	u8 val[4] = {0};
> +	int err;

> @@ -839,19 +930,22 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
>  
>  static int idt82p33_load_firmware(struct idt82p33 *idt82p33)
>  {
> +	char fname[128] = FW_FILENAME;

This variable seems unnecessary.

>  	const struct firmware *fw;
>  	struct idt82p33_fwrc *rec;
>  	u8 loaddr, page, val;
>  	int err;
>  	s32 len;
>  
> -	dev_dbg(&idt82p33->client->dev,
> -		"requesting firmware '%s'\n", FW_FILENAME);
> +	dev_dbg(&idt82p33->client->dev, "requesting firmware '%s'\n", fname);
>  
> -	err = request_firmware(&fw, FW_FILENAME, &idt82p33->client->dev);
> +	err = request_firmware(&fw, fname, &idt82p33->client->dev);
>  
> -	if (err)
> +	if (err) {
> +		dev_err(&idt82p33->client->dev,
> +			"Failed in %s with err %d!\n", __func__, err);
>  		return err;
> +	}
>  
>  	dev_dbg(&idt82p33->client->dev, "firmware size %zu bytes\n", fw->size);
>  
