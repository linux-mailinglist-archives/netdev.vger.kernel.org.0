Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CA9315FA
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfEaUSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:18:30 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37012 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbfEaUSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 16:18:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IHVk8lHfhdHV8HI5ibdUhORSoFUaved/s+yIc4Q/1to=; b=Vxyffvh5Ypx8VjUA8MplnOdrt
        M+ZdQIYnDlfT12LkjMjiS48oAu9uogigJp982z5GgXnVvwfr54jsdVPDp7OTqs7UjhqfNrP7syVuH
        43zuPfW/n2+Jsnazh4VieKAbOZtecEO+sWmxj+Uuhx3b9WTpmufBo0FukCFsAozBGJMUYGy9jzS+r
        Eras2+X1VIyRm7dqhyaAGXYXWu+SOT51sCunuko6hwgWIn7cxOZxX5ru8rx6A9lwv6N8ec/7TDlpW
        I24VWxLyW1GJSDiKH61H0hMW/LSO/YGMnSMerXyrYqvbOVfo4CmdydzTKS+PjCsgEXhbgLFIgA6my
        8ba3fjzpA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52776)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hWnyt-0002ua-9a; Fri, 31 May 2019 21:18:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hWnys-0006cy-ME; Fri, 31 May 2019 21:18:26 +0100
Date:   Fri, 31 May 2019 21:18:26 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: phylink: add fallback from SGMII to
 1000BaseX
Message-ID: <20190531201826.2qo57l2phommgpm2@shell.armlinux.org.uk>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-4-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559330285-30246-4-git-send-email-hancock@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 01:18:04PM -0600, Robert Hancock wrote:
> Some copper SFP modules support both SGMII and 1000BaseX,

The situation is way worse than that.  Some copper SFP modules are
programmed to support SGMII only.  Others are programmed to support
1000baseX only.  There is no way to tell from the EEPROM how they
are configured, and there is no way to auto-probe the format of the
control word (which is the difference between the two.)

> but some
> drivers/devices only support the 1000BaseX mode. Currently SGMII mode is
> always being selected as the desired mode for such modules, and this
> fails if the controller doesn't support SGMII. Add a fallback for this
> case by trying 1000BaseX instead if the controller rejects SGMII mode.

So, what happens when a controller supports both SGMII and 1000base-X
modes (such as the Marvell devices) but the module is setup for
1000base-X mode?

> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/phy/phylink.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 68d0a89..4fd72c2 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1626,6 +1626,7 @@ static int phylink_sfp_module_insert(void *upstream,
>  {
>  	struct phylink *pl = upstream;
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(orig_support) = { 0, };
>  	struct phylink_link_state config;
>  	phy_interface_t iface;
>  	int ret = 0;
> @@ -1635,6 +1636,7 @@ static int phylink_sfp_module_insert(void *upstream,
>  	ASSERT_RTNL();
>  
>  	sfp_parse_support(pl->sfp_bus, id, support);
> +	linkmode_copy(orig_support, support);
>  	port = sfp_parse_port(pl->sfp_bus, id, support);
>  
>  	memset(&config, 0, sizeof(config));
> @@ -1663,6 +1665,25 @@ static int phylink_sfp_module_insert(void *upstream,
>  
>  	config.interface = iface;
>  	ret = phylink_validate(pl, support, &config);
> +
> +	if (ret && iface == PHY_INTERFACE_MODE_SGMII &&
> +	    phylink_test(orig_support, 1000baseX_Full)) {
> +		/* Copper modules may select SGMII but the interface may not
> +		 * support that mode, try 1000BaseX if supported.
> +		 */

Here, you are talking about what the module itself supports, but this
code is determining what it should do based on what the _network
controller_ supports.

If the SFP module is programmed for SGMII, and the network controller
supports 1000base-X, then it isn't going to work very well - the
sender of the control word will be sending one format, and the
receiver will be interpreting the bits wrongly.

> +
> +		netdev_warn(pl->netdev, "validation of %s/%s with support %*pb "
> +			    "failed: %d, trying 1000BaseX\n",
> +			    phylink_an_mode_str(MLO_AN_INBAND),
> +			    phy_modes(config.interface),
> +			    __ETHTOOL_LINK_MODE_MASK_NBITS, orig_support, ret);
> +		iface = PHY_INTERFACE_MODE_1000BASEX;
> +		config.interface = iface;
> +		linkmode_copy(config.advertising, orig_support);
> +		linkmode_copy(support, orig_support);
> +		ret = phylink_validate(pl, support, &config);
> +	}
> +
>  	if (ret) {
>  		phylink_err(pl, "validation of %s/%s with support %*pb failed: %d\n",
>  			    phylink_an_mode_str(MLO_AN_INBAND),
> -- 
> 1.8.3.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
