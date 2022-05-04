Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83AF519298
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 02:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244482AbiEDAPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 20:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242307AbiEDAPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 20:15:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C800101D7;
        Tue,  3 May 2022 17:11:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4BDA6182F;
        Wed,  4 May 2022 00:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FA7C385A4;
        Wed,  4 May 2022 00:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651623102;
        bh=zXQJT9OcNxTWMgpJOONnP/VuTTgQG0f6H5ZJnf9VX3o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B29O+WfMIYjLgii+1tKPsUtOCZ0HHz+QMUJSoVrTrHMyyAKt3Ab/pK6zs7Vf6KMr1
         jKqaaMfqSmNgbJlfz35YKR0e0ulHhXRQqV2Nh3+L/GK+gzi1DLwpNF7lEVdaWKkuqH
         97kGdFbVavogJFQijC878+n1rxBkb2nj11/5+Ciatn1tdzAgmyQUs+tvDT1lkOeDCh
         gX22ugDrgeYSW8Y9q31k5GukzyCWrHT/xKCAjxXzlCQZOePuIjLixyq2r0HRFU9pgG
         OtEUjbZsCtZtkg927O2PFDMTYnoO/nCs6GInQzE1P+Koxw/U+QUIGo+qifB8xy3+hl
         56/QYeCI/yGeA==
Date:   Tue, 3 May 2022 17:11:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v3 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Message-ID: <20220503171140.27dbf8cf@kernel.org>
In-Reply-To: <1651518530-25128-1-git-send-email-min.li.xe@renesas.com>
References: <1651518530-25128-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 May 2022 15:08:49 -0400 Min Li wrote:
> Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY
> for gettime and settime exclusively
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Since this is a new feature please tag the next version as 
[PATCH net-next v4]. Bug fixes get tagged with [PATCH net]
new features, refactoring etc with [PATCH net-next].

> +	err = idtcm_write(idtcm, channel->tod_read_secondary, tod_read_cmd,
> +			  &val, sizeof(val));
> +
> +	if (err)

Please remove the empty lines between calling a function and checking
if it returned an error (only in the new code you're adding in this
patch).

> +		dev_err(idtcm->dev, "%s: err = %d", __func__, err);
>  
> -	err = idtcm_write(idtcm, channel->tod_read_primary,
> -			  tod_read_cmd, &val, sizeof(val));
>  	return err;
>  }
>  
> -static int idtcm_enable_extts(struct idtcm_channel *channel, u8 todn, u8 ref,
> -			      bool enable)
> +static bool is_single_shot(u8 mask)
>  {
> -	struct idtcm *idtcm = channel->idtcm;
> -	u8 old_mask = idtcm->extts_mask;
> -	u8 mask = 1 << todn;
> +	/* Treat single bit ToD masks as continuous trigger */
> +	if ((mask == 1) || (mask == 2) || (mask == 4) || (mask == 8))
> +		return false;
> +	else
> +		return true;

This function is better written as:

	/* Treat single bit ToD masks as continuous trigger */
	return mask <= 8 && is_power_of_2(mask);

> +}

> +static int _idtcm_gettime_triggered(struct idtcm_channel *channel,
> +				    struct timespec64 *ts)
> +{
> +	struct idtcm *idtcm = channel->idtcm;
> +	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_SECONDARY_CMD);
> +	u8 buf[TOD_BYTE_COUNT];
> +	u8 trigger;
> +	int err;
> +
> +	err = idtcm_read(idtcm, channel->tod_read_secondary,
> +			 tod_read_cmd, &trigger, sizeof(trigger));
> +	if (err)
> +		return err;
> +
> +	if (trigger & TOD_READ_TRIGGER_MASK)
> +		return -EBUSY;
> +
> +	err = idtcm_read(idtcm, channel->tod_read_secondary,
> +			 TOD_READ_SECONDARY_BASE, buf, sizeof(buf));
> +
> +	if (err)
> +		return err;
> +
> +	err = char_array_to_timespec(buf, sizeof(buf), ts);
> +
> +	return err;

Please return directly:

	return char_array_...

> +}


>  static int _idtcm_gettime_immediate(struct idtcm_channel *channel,
>  				    struct timespec64 *ts)
>  {
>  	struct idtcm *idtcm = channel->idtcm;
> -	u8 extts_mask = 0;
> +
> +	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_PRIMARY_CMD);
> +	u8 val = (SCSR_TOD_READ_TRIG_SEL_IMMEDIATE << TOD_READ_TRIGGER_SHIFT);
>  	int err;
>  
> -	/* Disable extts */
> -	if (idtcm->extts_mask) {
> -		extts_mask = idtcm_enable_extts_mask(channel, idtcm->extts_mask,
> -						     false);
> -	}
> +	err = idtcm_write(idtcm, channel->tod_read_primary,
> +			  tod_read_cmd, &val, sizeof(val));
>  
> -	err = _idtcm_set_scsr_read_trig(channel,
> -					SCSR_TOD_READ_TRIG_SEL_IMMEDIATE, 0);
> -	if (err == 0)
> -		err = _idtcm_gettime(channel, ts, 10);
> +	if (err)
> +		return err;
>  
> -	/* Re-enable extts */
> -	if (extts_mask)
> -		idtcm_enable_extts_mask(channel, extts_mask, true);
> +	err = _idtcm_gettime(channel, ts, 10);
>  
>  	return err;

Same here

	return _idtcm_gettime(...

>  }

> @@ -2420,10 +2502,11 @@ static int idtcm_remove(struct platform_device *pdev)
>  {
>  	struct idtcm *idtcm = platform_get_drvdata(pdev);
>  
> -	ptp_clock_unregister_all(idtcm);
> -
> +	idtcm->extts_mask = 0;
>  	cancel_delayed_work_sync(&idtcm->extts_work);
>  
> +	ptp_clock_unregister_all(idtcm);

Why is the order of unregistering the clock and canceling the work
changed? There is no locking around this function so seems like 
the work can get scheduled right after the call to
cancel_delayed_work_sync(), anyway.

>  	return 0;
>  }
