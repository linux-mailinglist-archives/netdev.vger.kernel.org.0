Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFD531624
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfEaUbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:31:35 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37166 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfEaUbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 16:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GkAXIPpRCxRxCWX/mKgnf1fHeaQimor0jvOM4Lf6byg=; b=HPC8YwTKTxbVNw47R3jhQ4+3o
        oqOFimN6j/qT2fd77zDAJ496m8TkCQO/xMugITeO6rYeeDEu+uCYJ6Tf1DjNIKHuiX8LjwMy6Pe5M
        g30enEveURHU6HAfC0SaH9mxIHQcGZMBiaNn6JA04BIA/X6unbacSqa6mdEjZ1yqDFRcsQitv7BEH
        drh5vdh8B+Zj61B8fFqMYVJj8uacFiEnBnpr3d8VBmR3MQb0RNhzLmCqFezdG6Fo1o7Oh2YBmojOG
        iDZCIij5XRSWrW7lYv0vBkYwxjnPRj8iQ6/1jby/heDaD2/Qtr3imMkzRnV8dRyU9d7wOoEbxRaWL
        8PxJheXUw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38434)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hWoBY-0002yB-9n; Fri, 31 May 2019 21:31:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hWoBX-0006dA-Fs; Fri, 31 May 2019 21:31:31 +0100
Date:   Fri, 31 May 2019 21:31:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: phylink: support using device PHY in
 fixed or 802.3z mode
Message-ID: <20190531203131.skdlic6ub2esyw3o@shell.armlinux.org.uk>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-5-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559330285-30246-5-git-send-email-hancock@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 01:18:05PM -0600, Robert Hancock wrote:
> The Xilinx AXI Ethernet controller supports SFP modules in 1000BaseX
> mode in a somewhat unusual manner: it still exposes a PHY device which
> needs some PHY-level initialization for the PCS/PMA layer to work properly,
> and which provides some link status/control information.
> 
> In this case, we want to use the phylink layer to support proper
> communication with the SFP module, but in most other respects we want to
> use the PHY attached to the controller.
> 
> Currently the phylink driver does not initialize or use a controller PHY
> even if it exists for fixed-link or 802.3z PHY modes, and doesn't
> support SFP module attachment in those modes.

Sorry, I'm having a hard time following this description.  Please draw
an ASCII diagram of the setup you have - a picture is worth 1000 words,
and I think that is very much the case here.

We do have boards where the SFP is connected to a real PHY, where the
real PHY offers a RJ45 copper socket and a fiber interface,
automatically switching between the two.  In this case, we do not
use phylink to represent the link between the PHY and the SFP cage,
but instead the PHY binds directly to the SFP cage.

> This change allows it to
> utilize a controller PHY if it is defined, and allows SFP module
> attachment/initialization but does not connect the PHY device to the
> controller (to allow the controller PHY to be used for link state
> tracking).
> 
> Fully supporting this setup would probably require initializing and
> tracking the state of both PHYs, which is a much more complex change and
> doesn't appear to be required for this use case.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/phy/phylink.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 4fd72c2..9362aca 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -819,12 +819,6 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
>  	struct phy_device *phy_dev;
>  	int ret;
>  
> -	/* Fixed links and 802.3z are handled without needing a PHY */
> -	if (pl->link_an_mode == MLO_AN_FIXED ||
> -	    (pl->link_an_mode == MLO_AN_INBAND &&
> -	     phy_interface_mode_is_8023z(pl->link_interface)))
> -		return 0;
> -

This looks to me like it will break existing users.

>  	phy_node = of_parse_phandle(dn, "phy-handle", 0);
>  	if (!phy_node)
>  		phy_node = of_parse_phandle(dn, "phy", 0);
> @@ -1697,9 +1691,6 @@ static int phylink_sfp_module_insert(void *upstream,
>  		    phy_modes(config.interface),
>  		    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
>  
> -	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
> -		return -EINVAL;
> -
>  	changed = !bitmap_equal(pl->supported, support,
>  				__ETHTOOL_LINK_MODE_MASK_NBITS);
>  	if (changed) {
> @@ -1751,12 +1742,30 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
>  {
>  	struct phylink *pl = upstream;
>  
> +	/* In fixed mode, or in in-band mode with 802.3z PHY interface mode,
> +	 *  ignore the SFP PHY and just use the PHY attached to the MAC.
> +	 */
> +	if (pl->link_an_mode == MLO_AN_FIXED ||
> +	    (pl->link_an_mode == MLO_AN_INBAND &&
> +	      phy_interface_mode_is_8023z(pl->link_config.interface)))
> +		return 0;
> +
>  	return __phylink_connect_phy(upstream, phy, pl->link_config.interface);
>  }
>  
>  static void phylink_sfp_disconnect_phy(void *upstream)
>  {
> -	phylink_disconnect_phy(upstream);
> +	struct phylink *pl = upstream;
> +
> +	/* In fixed mode, or in in-band mode with 802.3z PHY interface mode,
> +	 * ignore the SFP PHY and just use the PHY attached to the MAC.
> +	 */
> +	if (pl->link_an_mode == MLO_AN_FIXED ||
> +	    (pl->link_an_mode == MLO_AN_INBAND &&
> +	      phy_interface_mode_is_8023z(pl->link_config.interface)))
> +		return;

Fixed link mode is mutually exclusive with there being a PHY present.
Please see Documentation/devicetree/bindings/net/fixed-link.txt

Fixed links are not used to fix a declared PHY to a specific mode.

> +
> +	phylink_disconnect_phy(pl);
>  }
>  
>  static const struct sfp_upstream_ops sfp_phylink_ops = {

Overall, I think you need to better describe what your setup is, and
what you are trying to achieve:

* Are you merely trying to support copper SFP modules where the PHY
  defaults to 1000base-X mode rather than SGMII?
* Are you trying to support a network controller that doesn't support
  SGMII mode?

If the former, then I'm pretty certain you're going about it the wrong
way - as I've said before, there is nothing in the EEPROM that
indicates definitively what format the control word is (and therefore
whether it is SGMII or 1000base-X.)

Some network controllers may be able to tell the difference, but that
is not true of all controllers.

The only way I can see to support such modules would be to have a table
of quirks to set the interface mode accordingly, and not try this "lets
pick one, try to validate it with the network controller, otherwise try
the other."

In any case, the format of the connection between the SFP module and
the network controller isn't one that should appear in the ethtool link
modes - I view what you've done there as a hack rather than proper
design.

If, on the other hand it is the latter, what you do you expect to
happen if you plug a copper SFP module that only supports SGMII into
a network controller that only supports 1000baseX ?  The PHY on some
of these modules won't pass data unless the SGMII handshake with the
network controller completes, which it may or may not do depending on
the 1000baseX implementation - but the network controller won't
interpret the bits correctly, and certainly won't be able to deal
with it when the link switches to 100M or 10M mode, which it will do
depending on the results of the copper side negotiation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
