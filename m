Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B2A3B218F
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFWUIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWUIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 16:08:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DA3C061574;
        Wed, 23 Jun 2021 13:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IG70MoZoSqiFPenmXjBN2WpuGpkp6Lvmd3cBwqO3yfU=; b=A6xFJgCylu/fj4hOTR91ki5aV
        BWDasOfgOz8YW+o1jP05PuEWXYrn7xO0JzwSeX7AT/RhzYidVxsB9zFr3b7SaLxLWireB+nq+Tsv5
        2illYDiuMIPXTiZSmfM3PaY2YUlg8lKBHJwr23gGT9Ii5fU9ydp8xzSF/jdIfY6TDuw2MgDvz1xCD
        BBWljt6TNPxMqJS0gpajWFndOBASjWkTA3U0oUtJquJKVzPkmceGiGKs1p4qfoB9JUigBUpw6F0Zx
        8VVYYNf7Vw9YKFDoxjHpY+471wmUZ+KS9/vh2XVHiDKIFm6hfe8+1/1vPsIqWBt6mAxmBgE/jGU57
        kNKEGQ2eg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45280)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lw98f-0006lr-Cf; Wed, 23 Jun 2021 21:06:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lw98c-00050g-9k; Wed, 23 Jun 2021 21:06:18 +0100
Date:   Wed, 23 Jun 2021 21:06:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ling Pei Lee <pei.lee.ling@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Behun <marek.behun@nic.cz>,
        weifeng.voon@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com
Subject: Re: [PATCH net-next] net: phy: marvell10g: enable WoL for mv2110
Message-ID: <20210623200618.GO22278@shell.armlinux.org.uk>
References: <20210623130929.805559-1-pei.lee.ling@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623130929.805559-1-pei.lee.ling@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 09:09:29PM +0800, Ling Pei Lee wrote:
> +static void mv2110_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
> +{
> +	int ret = 0;

This initialiser doesn't do anything.

> +
> +	wol->supported = WAKE_MAGIC;
> +	wol->wolopts = 0;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_WOL_CTRL);
> +
> +	if (ret & MV_V2_WOL_MAGIC_PKT_EN)
> +		wol->wolopts |= WAKE_MAGIC;

You need to check whether "ret" is a negative number - if phy_read_mmd()
returns an error, this test could be true or false. It would be better
to have well defined behaviour (e.g. reporting that WOL is disabled?)

> +		/* Reset the clear WOL status bit as it does not self-clear */
> +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
> +					 MV_V2_WOL_CTRL,
> +					 MV_V2_WOL_CLEAR_STS);
> +
> +		if (ret < 0)
> +			return ret;
> +	} else {
> +		/* Disable magic packet matching & reset WOL status bit */
> +		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
> +				     MV_V2_WOL_CTRL,
> +				     MV_V2_WOL_MAGIC_PKT_EN,
> +				     MV_V2_WOL_CLEAR_STS);
> +
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
> +					 MV_V2_WOL_CTRL,
> +					 MV_V2_WOL_CLEAR_STS);
> +
> +		if (ret < 0)
> +			return ret;

This phy_clear_bits_mmd() is the same as the tail end of the other part
of the if() clause. Consider moving it after the if () { } else { }
statement...

> +	}
> +
> +	return ret;

and as all paths return "ret" just do:

	return phy_clear_bits_mmd(...

I will also need to check whether this is the same as the 88x3310, but
I'm afraid I don't have the energy this evening - please email me a
remind to look at this tomorrow. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
