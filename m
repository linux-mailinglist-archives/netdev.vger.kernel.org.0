Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08991653218
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 14:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiLUNz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 08:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiLUNz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 08:55:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8712711
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 05:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zH/5iECGTqyXtn1/AmhM7YUbUSscYrtHYxLDWQQ/iL0=; b=YwYr24zV4k9zuzdJHBxyiMmpa1
        562hWbe6r8oiUbdEXeqCOhUlnwNU29w897VoJuW7OYV6S5rXTS7BN53PbL+M5c71//5iDUQr1B0Fx
        xgQLOnJVzLV6gYH7kKwWhLPo3Ne6c4fKbvVqwObTowwP+KrKAc4GXwjSuSDWgv2QvzcU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7zZY-000BX8-M1; Wed, 21 Dec 2022 14:55:52 +0100
Date:   Wed, 21 Dec 2022 14:55:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net v2 2/5] net: ngbe: Remove structure ngbe_hw
Message-ID: <Y6MQaAP8OMtmRD3u@lunn.ch>
References: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
 <20221214064133.2424570-3-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214064133.2424570-3-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 02:41:30PM +0800, Jiawen Wu wrote:
> Remove useless structure ngbe_hw to make the codes clear.

Thanks for splitting this up. It makes it a lot easier to review.

> -static int ngbe_reset_misc(struct ngbe_hw *hw)
> +static int ngbe_reset_misc(struct ngbe_adapter *adapter)
>  {
> -	struct wx_hw *wxhw = &hw->wxhw;
> +	struct wx_hw *wxhw = &adapter->wxhw;
>  
>  	wx_reset_misc(wxhw);
> -	if (hw->mac_type == ngbe_mac_type_rgmii)
> +	if (adapter->mac_type == ngbe_mac_type_rgmii)
>  		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
> -	if (hw->gpio_ctrl) {
> +	if (adapter->gpio_ctrl) {
>  		/* gpio0 is used to power on/off control*/
>  		wr32(wxhw, NGBE_GPIO_DDR, 0x1);
>  		wr32(wxhw, NGBE_GPIO_DR, NGBE_GPIO_DR_0);

> -static void txgbe_reset_misc(struct txgbe_hw *hw)
> +static void txgbe_reset_misc(struct wx_hw *wxhw)
>  {
> -	struct wx_hw *wxhw = &hw->wxhw;
> -
> 	wx_reset_misc(wxhw);
> -	txgbe_init_thermal_sensor_thresh(hw);
> +	txgbe_init_thermal_sensor_thresh(wxhw);
> }

The names suggest these two functions do the same thing. So it would
be nice if the parameter naming and structure names where
similar. Maybe consider renaming struct wx_hw to txgbe_adaptor? And
wxhw to adaptor? Then the two drivers would look more like each
other. When they look like each other it then becomes easier to see
identical code and move it into the library.

You can do this as a follow up series. Please submit these patches
once net-dev reopens.

	  Andrew
