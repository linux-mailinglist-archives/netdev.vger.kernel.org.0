Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD2650BBEF
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449593AbiDVPqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449543AbiDVPpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:45:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988C45D67A
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pxd/i0KUK7DOtkkvmBm3c1BstTXH9qolGaKYQxizxow=; b=5TymPEcugeyz5zWORHjOIEF4vd
        CDMAGZWeqcvZhLZUYRVI0ev+YWoO/xidba3HxXerlKPAUph+7nOLFAvITh9TmVzsrVIRlDMKTAYh0
        j0YQX2asIHpkxmrbNDL7GA05JnCWtBlpty2b0hRR+lyJ+5ZRd4FmKbK1NKtHxGnVoYNo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhvQg-00H07P-JY; Fri, 22 Apr 2022 17:42:42 +0200
Date:   Fri, 22 Apr 2022 17:42:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lasse Johnsen <lasse@timebeat.app>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2] net: phy: broadcom: 1588 support on
 bcm54210pe
Message-ID: <YmLM8pFMVifHj7GG@lunn.ch>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <20220421144825.GA11810@hoboy.vegasvil.org>
 <208820C3-E4C8-4B75-B926-15BCD844CE96@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <208820C3-E4C8-4B75-B926-15BCD844CE96@timebeat.app>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 04:08:18PM +0100, Lasse Johnsen wrote:

Hi Lasse

Don't attach a patch to the end of a discussion. What you email is
what comes out of git-format patch. Nothing added.

If you want to discuss review comments, just reply to the email with
the comments. 

> From 3fcbbac9fe85909877f15d95f7a1e64dd6d06ab7 Mon Sep 17 00:00:00 2001
> From: Lasse Johnsen <l@ssejohnsen.me>
> Date: Sat, 5 Feb 2022 09:34:19 -0500
> Subject: [PATCH] Added support for IEEE1588 timestamping for the BCM54210PE
>  PHY using the kernel mii_timestamper interface
> 
> ---
>  arch/arm/configs/bcm2711_defconfig            |    1 +
>  arch/arm64/configs/bcm2711_defconfig          |    1 +
>  .../net/ethernet/broadcom/genet/bcmgenet.c    |    8 +-
>  drivers/net/phy/Makefile                      |    1 +
>  drivers/net/phy/bcm54210pe_ptp.c              | 1382 +++++++++++++++++
>  drivers/net/phy/bcm54210pe_ptp.h              |   85 +
>  drivers/net/phy/broadcom.c                    |   21 +-
>  drivers/ptp/Kconfig                           |   17 +

You need to break this up into a patch series. You probably want the
following patches:

defconfig changes
The core ptp code, in library form
Extensions to drivers/net/phy/broadcom.c to use the new code
bcmgenet.c change.


> +static u64 four_u16_to_ns(u16 *four_u16)
> +{
> +	u32 seconds;
> +	u32 nanoseconds;
> +	struct timespec64 ts;
> +	u16 *ptr;

Now it has been through checkpatch, it is starting to look like Linux
code :-)

Network drivers have a few extra code style hoops to jump
through. Variables should be sorted longest to shortest. So you want:

> +	struct timespec64 ts;
> +	u32 nanoseconds;
> +	u32 seconds;
> +	u16 *ptr;

This is known as reverse Christmas tree.

> +static int bcm54210pe_interrupts_enable(struct phy_device *phydev, bool fsync_en, bool sop_en)

Although Linux as a whole allows 100 character lines, networking
mostly stays with 80. I'm not sure it is strictly enforced, but it is
a good idea to try to keep with it.

> +{
> +	u16 interrupt_mask;
> +
> +	interrupt_mask = 0;

You can combine these into one line.

> +static int bcm54210pe_get80bittime(struct bcm54210pe_private *private,
> +				   struct timespec64 *ts,
> +				   struct ptp_system_timestamp *sts)
> +{
> +	struct phy_device *phydev;
> +	u16 nco_6_register_value;
> +	int i;
> +	u64 time_stamp_48, time_stamp_80, control_ts;
> +
> +	phydev = private->phydev;
> +
> +	// Capture timestamp on next framesync
> +	nco_6_register_value = 0x2000;

You should not have magic numbers. Please add a #define. If the
#define has a sensible name, it should then be obvious you are
capturing a timestamp on the next frame sync and so you don't need the
comment.

> +
> +	// Lock
> +	mutex_lock(&private->clock_lock);

Comments like this don't add any value. I can see it is a lock because
you are calling mutex_lock.

> +static int bcm54210pe_perout_enable(struct bcm54210pe_private *private, s64 period,
> +				    s64 pulsewidth, int enable)
> +{
> +	struct phy_device *phydev;
> +	u16 nco_6_register_value, frequency_hi, frequency_lo,
> +		pulsewidth_reg, pulse_start_hi, pulse_start_lo;
> +	int err;
> +
> +	phydev = private->phydev;
> +
> +	if (enable) {
> +		frequency_hi = 0;
> +		frequency_lo = 0;
> +		pulsewidth_reg = 0;
> +		pulse_start_hi = 0;
> +		pulse_start_lo = 0;
> +
> +		// Convert interval pulse spacing (period) and pulsewidth to 8 ns units
> +		period /= 8;
> +		pulsewidth /= 8;
> +
> +		// Mode 2 only: If pulsewidth is not explicitly set with PTP_PEROUT_DUTY_CYCLE
> +		if (pulsewidth == 0) {
> +			if (period < 2500) {
> +				// At a frequency at less than 20us (2500 x 8ns) set
> +				// pulse length to 1/10th of the interval pulse spacing
> +				pulsewidth = period / 10;
> +
> +				// Where the interval pulse spacing is short,
> +				// ensure we set a pulse length of 8ns
> +				if (pulsewidth == 0)
> +					pulsewidth = 1;
> +
> +			} else {
> +				// Otherwise set pulse with to 4us (8ns x 500 = 4us)
> +				pulsewidth = 500;
> +			}
> +		}
> +
> +		if (private->perout_mode == SYNC_OUT_MODE_1) {
> +			// Set period
> +			private->perout_period = period;
> +
> +			if (!private->perout_en) {
> +				// Set enable per_out
> +				private->perout_en = true;
> +				schedule_delayed_work(&private->perout_ws, msecs_to_jiffies(1));
> +			}
> +
> +			err = 0;
> +
> +		} else if (private->perout_mode == SYNC_OUT_MODE_2) {
> +			// Set enable per_out
> +			private->perout_en = true;
> +
> +			// Calculate registers
> +
> +			// Lowest 16 bits of 8ns interval pulse spacing [15:0]
> +			frequency_lo	= (u16)period;
> +
> +			// Highest 14 bits of 8ns interval pulse spacing [29:16]
> +			frequency_hi	= (u16)(0x3FFF & (period >> 16));
> +
> +			// 2 lowest bits of 8ns pulse length [1:0]
> +			frequency_hi   |= (u16)pulsewidth << 14;
> +
> +			// 7 highest bit  of 8 ns pulse length [8:2]
> +			pulsewidth_reg	= (u16)(0x7F & (pulsewidth >> 2));
> +
> +			// Get base value
> +			nco_6_register_value = bcm54210pe_get_base_nco6_reg(private,
> +									    nco_6_register_value,
> +									    true);
> +
> +			mutex_lock(&private->clock_lock);
> +
> +			// Write to register
> +			err = bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG,
> +						nco_6_register_value);
> +
> +			// Set sync out pulse interval spacing and pulse length
> +			err |= bcm_phy_write_exp(phydev, NSE_DPPL_NCO_3_0_REG, frequency_lo);
> +			err |= bcm_phy_write_exp(phydev, NSE_DPPL_NCO_3_1_REG, frequency_hi);
> +			err |= bcm_phy_write_exp(phydev, NSE_DPPL_NCO_3_2_REG, pulsewidth_reg);
> +
> +			// On next framesync load sync out frequency
> +			err |= bcm_phy_write_exp(phydev, SHADOW_REG_LOAD, 0x0200);
> +
> +			// Trigger immediate framesync
> +			err |= bcm_phy_modify_exp(phydev, NSE_DPPL_NCO_6_REG, 0x003C, 0x0020);
> +
> +			mutex_unlock(&private->clock_lock);
> +		}
> +	} else {
> +		// Set disable pps
> +		private->perout_en = false;
> +
> +		// Get base value
> +		nco_6_register_value = bcm54210pe_get_base_nco6_reg(private,
> +								    nco_6_register_value,
> +								    false);
> +
> +		mutex_lock(&private->clock_lock);
> +
> +		// Write to register
> +		err = bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG, nco_6_register_value);
> +
> +		mutex_unlock(&private->clock_lock);
> +	}
> +
> +	return err;

This is a pretty big function, and its indentation gets pretty deep. The coding style:

https://www.kernel.org/doc/html/latest/process/coding-style.html#functions

says:

Functions should be short and sweet, and do just one thing. They
should fit on one or two screenfuls of text (the ISO/ANSI screen size
is 80x24, as we all know), and do one thing and do that well.

Maybe you can break this up into helpers.

> +void bcm54210pe_txtstamp(struct mii_timestamper *mii_ts, struct sk_buff *skb, int type)
> +{
> +	struct bcm54210pe_private *private = container_of(mii_ts, struct bcm54210pe_private,
> +							  mii_ts);
> +
> +	switch (private->hwts_tx_en) {
> +	case HWTSTAMP_TX_ON:
> +	{
> +		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +		skb_queue_tail(&private->tx_skb_queue, skb);
> +		schedule_work(&private->txts_work);
> +		break;
> +	}
> +
> +	case HWTSTAMP_TX_OFF:
> +	{
> +	}

That just looks odd.

Should there be a break? Do you want to fall through? If you do want
to fall through, you need to mark it so. But since it is empty, i
guess you don't want to fall through?

> +
> +	default:
> +	{
> +		kfree_skb(skb);
> +		break;
> +	}
> +	}
> +}
