Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E32324F44
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbhBYLcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbhBYLai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 06:30:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE56C061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 03:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=E8kdrcFuE70KTta8/UVdFgN748u0sZifKEewLQsCgUU=; b=v/jf/hvtXHhCNK9s7gStqVAA7
        Y1yD1nOVstyI6/ioK9BPY1yFCkki4Ydkpb2B6kiqo65ZvJjsu3mtjDmiPebkEuuXPpFK6tugM3h7j
        8m/7XkB7EpiqlGrG3Se0SHzhmT47TUrxAiGHSNqL6+yGK82MtJgBBuqMdDsIlzk5pOYq0Fv+9Gmds
        e6FGrfrftfUME/HomYXXg1aIk5O+l09zQEscbwVkWB6RCiyHAG75a9/g+ZNj2q/GQc7E7GiJ5fmLg
        In0h2JIJ2iZFDZs3tBfCqkq6UDC4P6NwBvPQCQwG003VYmBHC4ucc3q3mPKh8/J5LYnL042AXGi5y
        21KB2U6KA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47008)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lFEq4-0000mV-18; Thu, 25 Feb 2021 11:29:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lFEpy-0004xM-NI; Thu, 25 Feb 2021 11:29:42 +0000
Date:   Thu, 25 Feb 2021 11:29:42 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net 6/6] net: enetc: force the RGMII speed and duplex
 instead of operating in inband mode
Message-ID: <20210225112942.GT1463@shell.armlinux.org.uk>
References: <20210225112357.3785911-1-olteanv@gmail.com>
 <20210225112357.3785911-7-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225112357.3785911-7-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 01:23:57PM +0200, Vladimir Oltean wrote:
>  static void enetc_pl_mac_link_up(struct phylink_config *config,
>  				 struct phy_device *phy, unsigned int mode,
>  				 phy_interface_t interface, int speed,
> @@ -945,6 +981,10 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
>  		enetc_sched_speed_set(priv, speed);
>  
>  	enetc_mac_enable(&pf->si->hw, true);
> +
> +	if (!phylink_autoneg_inband(mode) &&
> +	    phy_interface_mode_is_rgmii(interface))
> +		enetc_force_rgmii_mac(&pf->si->hw, speed, duplex);

Does it matter that you're forcing the RGMII setup after having enabled
the MAC?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
