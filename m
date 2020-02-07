Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5C415584A
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 14:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgBGNTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 08:19:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38216 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgBGNTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 08:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OFevIfw/0daM2Uci2FQaIJ9taG0RiSZb81ht+QEVejI=; b=PTXJ1FwdjrtoD5NikpodCGwThC
        kQUmEDsAEOYk5SKz3LsKr4iCBDCEf2KgaOqLRsZW4aNobE6HJgaKpH2xu3M6GoUHB+xFhxgtEUqZa
        qlG7MRDrWomX4MHDWOCJHmCDG0cfY7A1xWsC0QVViTVtFQ/Db6ugiKyGnSiZeEKySITs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j03XR-0003l8-W3; Fri, 07 Feb 2020 14:19:18 +0100
Date:   Fri, 7 Feb 2020 14:19:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de
Subject: Re: [PATCH net v3] dpaa_eth: support all modes with rate adapting
 PHYs
Message-ID: <20200207131915.GA14393@lunn.ch>
References: <1580810938-21047-1-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580810938-21047-1-git-send-email-madalin.bucur@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 04, 2020 at 12:08:58PM +0200, Madalin Bucur wrote:
> Stop removing modes that are not supported on the system interface
> when the connected PHY is capable of rate adaptation. This addresses
> an issue with the LS1046ARDB board 10G interface no longer working
> with an 1G link partner after autonegotiation support was added
> for the Aquantia PHY on board in
> 
> commit 09c4c57f7bc4 ("net: phy: aquantia: add support for auto-negotiation configuration")
> 
> Before this commit the values advertised by the PHY were not
> influenced by the dpaa_eth driver removal of system-side unsupported
> modes as the aqr_config_aneg() was basically a no-op. After this
> commit, the modes removed by the dpaa_eth driver were no longer
> advertised thus autonegotiation with 1G link partners failed.
> 
> Reported-by: Mian Yousaf Kaukab <ykaukab@suse.de>
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
> 
> change in v3: no longer add an API for checking the capability,
>   rely on PHY vendor to determine if more modes may be available
>   through rate adaptation so stop removing them
> 
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 09dbcd819d84..fd93d542f497 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2453,6 +2453,9 @@ static void dpaa_adjust_link(struct net_device *net_dev)
>  	mac_dev->adjust_link(mac_dev);
>  }
>  
> +/* The Aquantia PHYs are capable of performing rate adaptation */
> +#define PHY_VEND_AQUANTIA	0x03a1b400
> +
>  static int dpaa_phy_init(struct net_device *net_dev)
>  {
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> @@ -2471,9 +2474,14 @@ static int dpaa_phy_init(struct net_device *net_dev)
>  		return -ENODEV;
>  	}
>  
> -	/* Remove any features not supported by the controller */
> -	ethtool_convert_legacy_u32_to_link_mode(mask, mac_dev->if_support);
> -	linkmode_and(phy_dev->supported, phy_dev->supported, mask);
> +	/* Unless the PHY is capable of rate adaptation */
> +	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
> +	    ((phy_dev->drv->phy_id & GENMASK(31, 10)) != PHY_VEND_AQUANTIA)) {
> +		/* remove any features not supported by the controller */
> +		ethtool_convert_legacy_u32_to_link_mode(mask,
> +							mac_dev->if_support);
> +		linkmode_and(phy_dev->supported, phy_dev->supported, mask);
> +	}
>  
>  	phy_support_asym_pause(phy_dev);

This is reasonable until we figure out a clean way to do this.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

