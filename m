Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A89D4557B9
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245058AbhKRJJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245005AbhKRJI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:08:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB09C061764;
        Thu, 18 Nov 2021 01:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IAZG9nPNqupCRoNpc1U+gt8p4+p3wpbFyNFCyUczWPg=; b=LsrKrcpcNrc3RhE67zrOee3Ylf
        twBt1vj75Be4cRjKw88LFr1r0Ug9icLCsaYSVbe5GoVCU07gso3ZPslpqGXbxQILWF/vtg1bF9oLB
        IxWGuROiFprVr+HZryP5ovLOP6hWn0EuQqsoJQJXmXxJpEOBTBmgDeBDSES2mw19DhKZ2zyclebjN
        06wyYbRTz5S4VJKQsRMhQ63aoDaCSgcN2fbiBVsMi6avELPRwVdISWd4Ws2ulT3/TW9XzJvwVY9y1
        QP9ZJOyAxbxb+JWj5+XKKWo1CuPSbtRHO6HA/uIOz6i1ttXyXOHuw1XEV4xE7t+0GyItuo47soz17
        B8GTOUqA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55698)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mndMh-0002ji-Ce; Thu, 18 Nov 2021 09:05:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mndMg-0003n7-2G; Thu, 18 Nov 2021 09:05:54 +0000
Date:   Thu, 18 Nov 2021 09:05:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net: phylink: update supported_interfaces
 with modes from fwnode
Message-ID: <YZYXctnC168PrV18@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-5-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:50:46PM +0100, Marek Behún wrote:
> Now that the 'phy-mode' property can be a string array containing more
> PHY modes (all that are supported by the board), update the bitmap of
> interfaces supported by the MAC with this property.
> 
> Normally this would be a simple intersection (of interfaces supported by
> the current implementation of the driver and interfaces supported by the
> board), but we need to keep being backwards compatible with older DTs,
> which may only define one mode, since, as Russell King says,
>   conventionally phy-mode has meant "this is the mode we want to operate
>   the PHY interface in" which was fine when PHYs didn't change their
>   mode depending on the media speed
> 
> An example is DT defining
>   phy-mode = "sgmii";
> but the board supporting also 1000base-x and 2500base-x.
> 
> Add the following logic to keep this backwards compatiblity:
> - if more PHY modes are defined, do a simple intersection
> - if one PHY mode is defined:
>   - if it is sgmii, 1000base-x or 2500base-x, add all three and then do
>     the intersection
>   - if it is 10gbase-r or usxgmii, add both, and also 5gbase-r,
>     2500base-x, 1000base-x and sgmii, and then do the intersection
> 
> This is simple enough and should work for all boards.
> 
> Nonetheless it is possible (although extremely unlikely, in my opinion)
> that a board will be found that (for example) defines
>   phy-mode = "sgmii";
> and the MAC drivers supports sgmii, 1000base-x and 2500base-x, but the
> board DOESN'T support 2500base-x, because of electrical reasons (since
> the frequency is 2.5x of sgmii).
> Our code will in this case incorrectly infer also support for
> 2500base-x. To avoid this, the board maintainer should either change DTS
> to
>   phy-mode = "sgmii", "1000base-x";
> and update device tree on all boards, or, if that is impossible, add a
> fix into the function we are introducing in this commit.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/phy/phylink.c | 63 +++++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h       |  6 ++++
>  2 files changed, 69 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index f7156b6868e7..6d7c216a5dea 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -563,6 +563,67 @@ static int phylink_parse_fixedlink(struct phylink *pl,
>  	return 0;
>  }
>  
> +static void phylink_update_phy_modes(struct phylink *pl,
> +				     struct fwnode_handle *fwnode)
> +{
> +	unsigned long *supported = pl->config->supported_interfaces;
> +	DECLARE_PHY_INTERFACE_MASK(modes);
> +
> +	if (fwnode_get_phy_modes(fwnode, modes) < 0)
> +		return;
> +
> +	if (phy_interface_empty(modes))
> +		return;
> +
> +	/* If supported is empty, just copy modes defined in fwnode. */
> +	if (phy_interface_empty(supported))
> +		return phy_interface_copy(supported, modes);

Doesn't this mean we always end up with the supported_interfaces field
filled in, even for drivers that haven't yet been converted? It will
have the effect of locking the driver to the interface mode in "modes"
where only one interface mode is mentioned in DT.

At the moment, I think the only drivers that would be affected would be
some DSA drivers, stmmac and macb as they haven't yet been converted.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
