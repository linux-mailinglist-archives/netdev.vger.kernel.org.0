Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DA91D0C8A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 11:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732493AbgEMJmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgEMJmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 05:42:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81A7C061A0C;
        Wed, 13 May 2020 02:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0TMMWMUrzS1FlukKgXCbkVesqNUS1JqKvgC56uuLBQs=; b=uUuqXjOUXbQYCT40fYfHMeKVp
        ri3MiqzeJWAY/jIK4/YpZa/oWdqYZssoObY14Hc0Yj6jPiARuTZKWL59evrC/TP+VMMP0CEIxKOrc
        FA2AWjSXfQNOhAZtOfsgRP3H3j3BIW1ZUztAVG+teCalymQ/Wp92iyHRI4lMO88zCKujCnqhHYs+a
        IDzAQmm4UfyUGHG7khAIT9TD+eMho+TTs+2RlJVDpUGRBFQK3OgGc96fU+J7U/REhOgCCP3B4DcUh
        oIYOEydCTFDGI+f7/Za2K1NV5GNmKp7mWabJnVC2UPN7NEFN3g9AARkWHiSDRaoJLkSRRloYM4dv6
        eFNBjv/CQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:57428)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jYnuS-00043G-Qa; Wed, 13 May 2020 10:42:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jYnuR-0007f7-7k; Wed, 13 May 2020 10:42:39 +0100
Date:   Wed, 13 May 2020 10:42:39 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: ethernet: introduce phy_set_pause
Message-ID: <20200513094239.GG1551@shell.armlinux.org.uk>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-4-git-send-email-opendmb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589243050-18217-4-git-send-email-opendmb@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 05:24:09PM -0700, Doug Berger wrote:
> This commit introduces the phy_set_pause function to the phylib as
> a helper to support the set_pauseparam ethtool method.
> 
> It is hoped that the new behavior introduced by this function will
> be widely embraced and the phy_set_sym_pause and phy_set_asym_pause
> functions can be deprecated. Those functions are retained for all
> existing users and for any desenting opinions on my interpretation
> of the functionality.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> ---
>  drivers/net/phy/phy_device.c | 31 +++++++++++++++++++++++++++++++
>  include/linux/phy.h          |  1 +
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 48ab9efa0166..e6dafb3c3e5f 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2614,6 +2614,37 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
>  EXPORT_SYMBOL(phy_set_asym_pause);
>  
>  /**
> + * phy_set_pause - Configure Pause and Asym Pause with autoneg
> + * @phydev: target phy_device struct
> + * @rx: Receiver Pause is supported
> + * @tx: Transmit Pause is supported
> + * @autoneg: Auto neg should be used
> + *
> + * Description: Configure advertised Pause support depending on if
> + * receiver pause and pause auto neg is supported. Generally called
> + * from the set_pauseparam ethtool_ops.
> + *
> + * Note: Since pause is really a MAC level function it should be
> + * notified via adjust_link to update its pause functions.
> + */
> +void phy_set_pause(struct phy_device *phydev, bool rx, bool tx, bool autoneg)
> +{
> +	linkmode_set_pause(phydev->advertising, tx, rx, autoneg);
> +
> +	/* Reset the state of an already running link to force a new
> +	 * link up event when advertising doesn't change or when PHY
> +	 * autoneg is disabled.
> +	 */
> +	mutex_lock(&phydev->lock);
> +	if (phydev->state == PHY_RUNNING)
> +		phydev->state = PHY_UP;
> +	mutex_unlock(&phydev->lock);

I wonder about this - will drivers cope with having two link-up events
via adjust_link without a corresponding link-down event?  What if they
touch registers that are only supposed to be touched while the link is
down?  Obviously, drivers have to opt-in to this interface, so it may
be okay provided we don't get wholesale changes.

> +
> +	phy_start_aneg(phydev);

Should we be making that conditional on something changing and autoneg
being enabled, like phy_set_asym_pause() does?  There is no point
interrupting an established link if the advertisement didn't change.

> +}
> +EXPORT_SYMBOL(phy_set_pause);
> +
> +/**
>   * phy_validate_pause - Test if the PHY/MAC support the pause configuration
>   * @phydev: phy_device struct
>   * @pp: requested pause configuration
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 5d8ff5428010..71e484424e68 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1403,6 +1403,7 @@ void phy_support_asym_pause(struct phy_device *phydev);
>  void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
>  		       bool autoneg);
>  void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
> +void phy_set_pause(struct phy_device *phydev, bool rx, bool tx, bool autoneg);
>  bool phy_validate_pause(struct phy_device *phydev,
>  			struct ethtool_pauseparam *pp);
>  void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause);
> -- 
> 2.7.4
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
