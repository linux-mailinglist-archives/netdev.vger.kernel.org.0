Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C9E29EB42
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgJ2MIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgJ2MIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 08:08:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81536C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 05:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OzII732qr1hZWEXjut7B9sPopkt5x8MtErYT7xFdR0I=; b=h/t5L9/G8TGJRgF82RIiDJMg2
        5DWkJTu/IyD7/xgbluoFqnJSMMIJ6v2/fSkOVcBvREudTcXKzSW8cO/1BA/EdUZJ6H5OYJSL1g9hv
        SU0+6xG6jlm3efY6Y85wQEncatpWaT2zAuFaPP2+wcEp7/iQx2As3UO2SEHxLZ4deQG9MzqcfzytI
        rNUAgsXLAa0wB7OlzaLOXi1ig9HIvoQe9rzqoxm18F3gIfLEvw6EtF0GR4oWs1IgQthGmfidpoSW6
        bPiU3fyYeh6lfzsBcS+1Sd6nwAIrBgYs5oUyycYiHonXvKBOK4mFA2BkHx8ZfsYE/wfd2zkULnw1E
        hdyCl1z1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52436)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kY6j0-0004IX-5x; Thu, 29 Oct 2020 12:08:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kY6ix-00064o-0V; Thu, 29 Oct 2020 12:08:11 +0000
Date:   Thu, 29 Oct 2020 12:08:10 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 2/5] net: phylink: allow attaching phy for SFP
 modules on 802.3z mode
Message-ID: <20201029120810.GP1551@shell.armlinux.org.uk>
References: <20201028221427.22968-1-kabel@kernel.org>
 <20201028221427.22968-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201028221427.22968-3-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:14:24PM +0100, Marek Behún wrote:
> Some SFPs may contain an internal PHY which may in some cases want to
> connect with the host interface in 1000base-x/2500base-x mode.
> Do not fail if such PHY is being attached in one of these PHY interface
> modes.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 5d8c015bc9f2..52954f12ca5e 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1018,7 +1018,7 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
>  {
>  	if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
>  		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> -		     phy_interface_mode_is_8023z(interface))))
> +		     phy_interface_mode_is_8023z(interface) && !pl->sfp_bus)))
>  		return -EINVAL;
>  
>  	if (pl->phydev)

I think also changing phylink_sfp_config() too since that check is no
longer relevent - although it doesn't actually end up being effective
today. So, might as well be removed along with the above change.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
