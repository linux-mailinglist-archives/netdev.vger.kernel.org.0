Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905B52F48D2
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbhAMKjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbhAMKjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 05:39:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 570882339F;
        Wed, 13 Jan 2021 10:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610534324;
        bh=rz8hafgF1Bf7DVSuG2Pk8tX71WVmcWwibS8OWdwDZ44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FxkvPVCdT865qtHsqVkBq/fJ6AQtESy/jfMhVgj0FxTtxywSpSgL9/aj620AlGsoH
         dWJg89L026k0hiy6FJ4pCE4zHQjwr7mJVoMbenYd19XX3MpTufnBOer8WUivoLDJdR
         T/oLDqcZyRqJtDrnyBA6t2Crx3XIQryObK3Bev+r+cSkxSaxY81zzT4yQBfrVVKREd
         YSDDDcXJUvIJtXJvakCWXqmRJP62KkTKBM3YdksRoabHYV9eNpXCIBnmkTwd7eO6wC
         EURL2WLXKvdyqCmwIHa0sNNrYUrq+FbE19JvFqmCiEsf6TdSAXW+ygi7TIBoljVUP2
         L3UuQpAL2+q4w==
Received: by pali.im (Postfix)
        id CCA6D76D; Wed, 13 Jan 2021 11:38:41 +0100 (CET)
Date:   Wed, 13 Jan 2021 11:38:41 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net
Subject: Re: [PATCH net-next v4 2/4] net: phylink: allow attaching phy for
 SFP modules on 802.3z mode
Message-ID: <20210113103841.hq2cjzf22ytgcwd7@pali>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111050044.22002-3-kabel@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 11 January 2021 06:00:42 Marek Behún wrote:
> Some SFPs may contain an internal PHY which may in some cases want to
> connect with the host interface in 1000base-x/2500base-x mode.
> Do not fail if such PHY is being attached in one of these PHY interface
> modes.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Pali Rohár <pali@kernel.org>

> ---
>  drivers/net/phy/phylink.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 84f6e197f965..f97d041f82f4 100644
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
> @@ -2069,9 +2069,6 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
>  		    phylink_an_mode_str(mode), phy_modes(config.interface),
>  		    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
>  
> -	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
> -		return -EINVAL;
> -
>  	changed = !linkmode_equal(pl->supported, support);
>  	if (changed) {
>  		linkmode_copy(pl->supported, support);
> -- 
> 2.26.2
> 
