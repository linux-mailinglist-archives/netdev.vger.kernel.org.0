Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B761E08C0
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387668AbgEYIZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgEYIZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:25:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB68C061A0E;
        Mon, 25 May 2020 01:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Fgl1LUanRCvQTQW6eIED/H7/O1/NZzmuC8878hJnzF0=; b=lVIonNHNM18QiAzU0CCgTAjHy
        O7vwnc3er81LAMP8FzNmuhSgE9pLd3LF5TtBKYtNS5kL9nccusJYLwQ4llvYgXAfvw/Mxxidtq9U7
        wNCJsUAv/oQ2qhGLRBvTvwObkqoaJH2WRZFtDVIS8ukXQdE3GwW/YZ6BFaTxC0MvRNpX8frJCvZBy
        8Zr2U3+W4lK4bsZ9fgLaSw3X7Yx2QCpteoZFYjFRNIb1rxEHgaNKFdPJzyWUbC+3fS/oIkZCPWrro
        7c9TxUw4rOUse4tMrGsa00tQL9x3dr/bK5GPq9ftDIgNXmEkUJ+zHZP0tYKJjrQ/6t5Qa6EM4BP55
        jEl3hAvtQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34256)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jd8Q4-0004he-0l; Mon, 25 May 2020 09:25:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jd8Q2-0004CV-Ox; Mon, 25 May 2020 09:25:10 +0100
Date:   Mon, 25 May 2020 09:25:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/11] net: phy: Allow mdio buses to auto-probe c45 devices
Message-ID: <20200525082510.GH1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-9-jeremy.linton@arm.com>
 <20200524144449.GP610998@lunn.ch>
 <ec63b0d4-2abc-0d32-69c0-ed1a822162cf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec63b0d4-2abc-0d32-69c0-ed1a822162cf@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 11:28:52PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/24/20 9:44 AM, Andrew Lunn wrote:
> > > +++ b/include/linux/phy.h
> > > @@ -275,6 +275,11 @@ struct mii_bus {
> > >   	int reset_delay_us;
> > >   	/* RESET GPIO descriptor pointer */
> > >   	struct gpio_desc *reset_gpiod;
> > > +	/* bus capabilities, used for probing */
> > > +	enum {
> > > +		MDIOBUS_C22_ONLY = 0,
> > > +		MDIOBUS_C45_FIRST,
> > > +	} probe_capabilities;
> > >   };
> > 
> > 
> > I'm not so keen on _FIRST. It suggest _LAST would also be valid.  But
> > that then suggests this is not a bus property, but a PHY property, and
> > some PHYs might need _FIRST and other phys need _LAST, and then you
> > have a bus which has both sorts of PHY on it, and you have a problem.
> > 
> > So i think it would be better to have
> > 
> > 	enum {
> > 		MDIOBUS_UNKNOWN = 0,
> > 		MDIOBUS_C22,
> > 		MDIOBUS_C45,
> > 		MDIOBUS_C45_C22,
> > 	} bus_capabilities;
> > 
> > Describe just what the bus master can support.
> 
> Yes, the naming is reasonable and I will update it in the next patch. I went
> around a bit myself with this naming early on, and the problem I saw was
> that a C45 capable master, can have C45 electrical phy's that only respond
> to c22 requests (AFAIK).

If you have a master that can only generate clause 45 cycles, and
someone is daft enough to connect a clause 22 only PHY to it, the
result is hardware that doesn't work - there's no getting around
that.  The MDIO interface can't generate the appropriate cycles to
access the clause 22 PHY.  So, this is not something we need care
about.

> So the MDIOBUS_C45 (I think I was calling it
> C45_ONLY) is an invalid selection. Not, that it wouldn't be helpful to have
> a C45_ONLY case, but that the assumption is that you wouldn't try and probe
> c22 registers, which I thought was a mistake.

MDIOBUS_C45 means "I can generate clause 45 cycles".
MDIOBUS_C22 means "I can generate clause 22 cycles".
MDIOBUS_C45_C22 means "I can generate both clause 45 and clause 22
cycles."

Notice carefully the values these end up with - MDIOBUS_C22 = BIT(0),
MDIOBUS_C45 = BIT(1), MDIOBUS_C45_C22 = BIT(0) | BIT(1).  I suspect
that was no coincidence in Andrew's suggestion.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
