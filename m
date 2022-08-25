Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5A15A1208
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242590AbiHYN1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241363AbiHYN1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:27:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDC1AB430;
        Thu, 25 Aug 2022 06:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LNDa6K477WrjL/9qZ6CeDxttXWTu9Hc41m/817r5XA8=; b=3d3bVga53ZEwYBPWZSj5Pkldyk
        juCaqxxtiWJz9MDemuh3wekoODc0dvLe+XEt2Sf8igh9l2suQ7/uG+D8HQX3LI6/gJwNylWXtn2M2
        D2YnN51lR54bVKrPm3EN1ZkwfJwmTjROCJ/WCxPaD0Z4wU5S6AAIhh1tR6F/B7JjZQII=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRCsr-00EZbv-Ke; Thu, 25 Aug 2022 15:26:57 +0200
Date:   Thu, 25 Aug 2022 15:26:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tee.min.tan@intel.com,
        muhammad.husaini.zulkifli@intel.com
Subject: Re: [PATCH net 1/1] net: phy: marvell: add link status check before
 enabling phy loopback
Message-ID: <Ywd4oUPEssQ+/OBE@lunn.ch>
References: <20220825082238.11056-1-aminuddin.jamaluddin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825082238.11056-1-aminuddin.jamaluddin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -2015,14 +2016,23 @@ static int m88e1510_loopback(struct phy_device *phydev, bool enable)
>  		if (err < 0)
>  			return err;
>  
> -		/* FIXME: Based on trial and error test, it seem 1G need to have
> -		 * delay between soft reset and loopback enablement.
> -		 */
> -		if (phydev->speed == SPEED_1000)
> -			msleep(1000);
> +		if (phydev->speed == SPEED_1000) {
> +			err = phy_read_poll_timeout(phydev, MII_BMSR, val, val & BMSR_LSTATUS,
> +						    PHY_LOOP_BACK_SLEEP,
> +						    PHY_LOOP_BACK_TIMEOUT, true);

Is this link with itself?

Have you tested this with the cable unplugged?

> +			if (err)
> +				return err;

I'm just trying to ensure we don't end up here with -ETIMEDOUT.

>  
> +#define PHY_LOOP_BACK_SLEEP	1000000
> +#define PHY_LOOP_BACK_TIMEOUT	8000000

The kernel seems to be pretty consistent in having loopback as one
word.

	Andrew
