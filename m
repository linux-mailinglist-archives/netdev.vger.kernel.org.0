Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AB24DA42C
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245528AbiCOUpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242341AbiCOUpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:45:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60371EAED
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 13:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OOXfwiHkYmzfCiBIrVTpPMOz5kixmebPfwBmMloyP8g=; b=W/wm1alCnPhuNXAgpd8mQLPM4N
        zdJXqUR2JdvOjTvYLMVkadTiWcKzerRNk6TCy5gmrwg/4XWl9UHOrrhRnjVbC6lHjuzgC6RDFFULd
        xI+7G8BHTw3JH7HYYgo6L+65zIn0DSJQVBqaCS4Ty4KcLHxJEuDi38BgMQv9kTRK23ps=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nUE1g-00B2R1-AB; Tue, 15 Mar 2022 21:44:16 +0100
Date:   Tue, 15 Mar 2022 21:44:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 3/5] net: lan743x: Add support for OTP
Message-ID: <YjD6oGrwjgCdmUDj@lunn.ch>
References: <20220315061701.3006-1-Raju.Lakkaraju@microchip.com>
 <20220315061701.3006-4-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315061701.3006-4-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int lan743x_hs_otp_cmd_cmplt_chk(struct lan743x_adapter *adapter)
> +{
> +	unsigned long start_time = jiffies;
> +	u32 val;
> +
> +	do {
> +		val = lan743x_csr_read(adapter, HS_OTP_STATUS);
> +		if (!(val & OTP_STATUS_BUSY_))
> +			break;
> +
> +		usleep_range(80, 100);
> +	} while (!time_after(jiffies, start_time + HZ));
> +
> +	if (val & OTP_STATUS_BUSY_) {
> +		netif_warn(adapter, drv, adapter->netdev,
> +			   "Timeout on HS_OTP_STATUS completion\n");
> +		return -ETIMEDOUT;
> +	}

iopoll.h

> +static int lan743x_hs_otp_read(struct lan743x_adapter *adapter, u32 offset,
> +			       u32 length, u8 *data)
> +{
> +	int ret;
> +	int i;
> +
> +	if (offset + length > MAX_OTP_SIZE)
> +		return -EINVAL;

The core does this.

> +static int lan743x_hs_otp_write(struct lan743x_adapter *adapter, u32 offset,
> +				u32 length, u8 *data)
> +{
> +	int ret;
> +	int i;
> +
> +	if (offset + length > MAX_OTP_SIZE)
> +		return -EINVAL;

The core does this.

    Andrew
