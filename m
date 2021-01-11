Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6545D2F181B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388376AbhAKOYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388223AbhAKOYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 09:24:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB11C0617BB;
        Mon, 11 Jan 2021 06:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2/VIk9crXW9UNi9JKJAAW1ZeB4HVfXeS+awzGKpCxZA=; b=wgtWCy86hWACMvd5dQBjjTB85
        0LLd4XkTdU7NKwuJ72Rqhpzzug5ziiF6yBj5ztfxNgfiZ5dqvxjhk56ausfKtfsH6+8kxycmKe0gV
        6yJdG1eDb3JzyfcgM3lHnBGZWxw/M/HQvxaTYlGnVvbD0Hkv+VT0h4Jhb973geXFiSUnCQL7trDjx
        /BQuZ9HUlOAQ+oZkWnUhVdyLzCVrb1yrWSxx+uECoqazl6OiNNYOTue0obt4oNCdQkoxWOQBw65+Q
        sxLx6OLoRHYzeFbJt+Jb4mkHnKIpTyGr4XNRg/+Qav3FFfGyxSNxaqVYJ7znqfn9TjnzIQGqzS3p0
        2TjNecK4g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46626)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyy5l-00078l-FD; Mon, 11 Jan 2021 14:22:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyy5l-0005JT-7v; Mon, 11 Jan 2021 14:22:45 +0000
Date:   Mon, 11 Jan 2021 14:22:45 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 2/2] sfp: add support for 100 base-x SFPs
Message-ID: <20210111142245.GW1551@shell.armlinux.org.uk>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
 <20210111130657.10703-3-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130657.10703-3-bjarni.jonasson@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:06:57PM +0100, Bjarni Jonasson wrote:
> Add support for 100Base-FX, 100Base-LX, 100Base-PX and 100Base-BX10 modules
> This is needed for Sparx-5 switch.
> 
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> ---
>  drivers/net/phy/sfp-bus.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> index 58014feedf6c..b2a9ee3dd28e 100644
> --- a/drivers/net/phy/sfp-bus.c
> +++ b/drivers/net/phy/sfp-bus.c
> @@ -265,6 +265,12 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
>  	    br_min <= 1300 && br_max >= 1200)
>  		phylink_set(modes, 1000baseX_Full);
>  
> +	/* 100Base-FX, 100Base-LX, 100Base-PX, 100Base-BX10 */
> +	if (id->base.e100_base_fx || id->base.e100_base_lx)
> +		phylink_set(modes, 100baseFX_Full);
> +	if ((id->base.e_base_px || id->base.e_base_bx10) && br_nom == 100)
> +		phylink_set(modes, 100baseFX_Full);

Do you have any modules that identify as PX or BX10 modules? What if
their range of speeds covers 100M - you're only checking the nominal
speed here.

Note that this will likely conflict with changes I submitted over the
weekend, and it really needs to be done _before_ the comment about
"If we haven't discovered any modes", not below.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
