Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085903FF791
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347957AbhIBXDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:03:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54282 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347855AbhIBXDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 19:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OYFToequarzac4GcuUzxdyCTeg1E65wYgDUFdHDP4Uo=; b=Brb8sRznxEqSdqZBTUb1/AgPss
        Cdfiz/moRjSVVbhoYXQ+U2mDxo4gRpMKwWEbPLPVFixvmZb4lPd73Oh1rV+zTueyJkT6cdOrL9yJ4
        wpit+vQ4qgFAwE0tZ3yXnbs2xWA/5s1pqO88QV8cFVyWJpiztsq1vTIf7klgpy3dkd0k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLvig-0053pN-8j; Fri, 03 Sep 2021 01:02:06 +0200
Date:   Fri, 3 Sep 2021 01:02:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <YTFX7n9qj2cUh0Ap@lunn.ch>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk>
 <YTErTRBnRYJpWDnH@lunn.ch>
 <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
 <20210902213303.GO22278@shell.armlinux.org.uk>
 <20210902213949.r3q5764wykqgjm4z@skbuf>
 <20210902222439.GQ22278@shell.armlinux.org.uk>
 <20210902224506.5h7bnybjbljs5uxz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902224506.5h7bnybjbljs5uxz@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Note that phylink_destroy() is documented as:
> >
> >  * Note: the rtnl lock must not be held when calling this function.
> >

...

> 
> Any other issues besides needing to take rtnl_mutex top-level when
> calling phylink_destroy?

We should try to keep phylink_create and phylink_destroy symmetrical:

/**
 * phylink_create() - create a phylink instance
 * @config: a pointer to the target &struct phylink_config
 * @fwnode: a pointer to a &struct fwnode_handle describing the network
 *      interface
 * @iface: the desired link mode defined by &typedef phy_interface_t
 * @mac_ops: a pointer to a &struct phylink_mac_ops for the MAC.
 *
 * Create a new phylink instance, and parse the link parameters found in @np.
 * This will parse in-band modes, fixed-link or SFP configuration.
 *
 * Note: the rtnl lock must not be held when calling this function.

Having different locking requirements will catch people out.

Interestingly, there is no ASSERT_NO_RTNL(). Maybe we should add such
a macro.

    Andrew
