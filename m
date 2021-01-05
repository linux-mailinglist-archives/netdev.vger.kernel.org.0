Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8552EB0FD
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbhAERFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729893AbhAERFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 12:05:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D28C061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 09:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k1nxmP3rFE5rm3Sqk9czeLCq00ArYAcROA+PR9N0Fms=; b=r2f5VvoXhhdw28zCpaggFRj7D
        w4A5wQYm6Qf1ZjF9kq2nyPJiMoE3+JisuS/smq3WKztq7aQZs1EUv2n8sy0TVzfGb7doFBdOGLLlv
        PmvOVPfS/8h2fHO9rVsIITRhRdp6KcVDGeM+h5euemUhYVB47+kEteDbW3wNMIixOsNUdPf5pUT2H
        z348SS1ylkr0DC3xJmgulkRk83fuNqwTEWwiRXcgHigLNscRq/2pAHwVA2j4Je40eRKqqDXG1pKqJ
        fuCz6ob4aFSwoKz5qhdfBbYzZH1vYBHlpeAcI1dTddklp9XXDerhaX6bZdKyboCl4eqLhBtYI6iV4
        J+FATVqxg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45138)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kwplX-0000yU-9m; Tue, 05 Jan 2021 17:05:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kwplV-0007sh-Qy; Tue, 05 Jan 2021 17:05:01 +0000
Date:   Tue, 5 Jan 2021 17:05:01 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: phy: Trigger link_change_notify on PHY_HALTED
Message-ID: <20210105170501.GE1551@shell.armlinux.org.uk>
References: <20210105161136.250631-1-marex@denx.de>
 <06732cde-8614-baa1-891a-b80a35cabcbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06732cde-8614-baa1-891a-b80a35cabcbc@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 05:58:21PM +0100, Heiner Kallweit wrote:
> On 05.01.2021 17:11, Marek Vasut wrote:
> > @@ -1021,8 +1022,17 @@ void phy_stop(struct phy_device *phydev)
> >  	if (phydev->sfp_bus)
> >  		sfp_upstream_stop(phydev->sfp_bus);
> >  
> > +	old_state = phydev->state;
> >  	phydev->state = PHY_HALTED;
> >  
> > +	if (old_state != phydev->state) {
> 
> This check shouldn't be needed because it shouldn't happen that
> phy_stop() is called from status PHY_HALTED. In this case the
> WARN() a few lines above would have fired already.

That is incorrect. If an error happens with the phy, phy_error() will
be called, which sets phydev->state = PHY_HALTED. If you then
subsequently take the interface down, phy_stop() will be called, but
phydev->state will be set to PHY_HALTED.

This is a long standing bug since you changed the code, and I think is
something I've reported previously, since I've definitely encountered
it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
