Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D501E0FB3
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390837AbgEYNoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 09:44:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388794AbgEYNoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 09:44:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PtR/dH41IdZFMrM9InEe2c8NiLO+/7TaFVVfFphYl9o=; b=5hrh4SOk9bO+X9UiZF0HjY22rm
        /zyNhffA9uT5pewe1vxrfZCr7Vz3bx8tPtHRXHC6r+AIpe9eDlMYYuIx3P5PApz65/fQuW5vclUS+
        2oWZafxIkoKBbYf8B4W8+hCy6BCMHK6mnJrVo+81gvudQqqgRz58+3kvBdwFZ2nyJp+U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdDON-003C1w-CI; Mon, 25 May 2020 15:43:47 +0200
Date:   Mon, 25 May 2020 15:43:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/11] net: phy: Allow mdio buses to auto-probe c45 devices
Message-ID: <20200525134347.GA752669@lunn.ch>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-9-jeremy.linton@arm.com>
 <20200524144449.GP610998@lunn.ch>
 <ec63b0d4-2abc-0d32-69c0-ed1a822162cf@arm.com>
 <20200525082510.GH1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525082510.GH1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > So i think it would be better to have
> > > 
> > > 	enum {
> > > 		MDIOBUS_UNKNOWN = 0,
> > > 		MDIOBUS_C22,
> > > 		MDIOBUS_C45,
> > > 		MDIOBUS_C45_C22,
> > > 	} bus_capabilities;
> > > 
> > > Describe just what the bus master can support.
> > 
> > Yes, the naming is reasonable and I will update it in the next patch. I went
> > around a bit myself with this naming early on, and the problem I saw was
> > that a C45 capable master, can have C45 electrical phy's that only respond
> > to c22 requests (AFAIK).
> 
> If you have a master that can only generate clause 45 cycles, and
> someone is daft enough to connect a clause 22 only PHY to it, the
> result is hardware that doesn't work - there's no getting around
> that.  The MDIO interface can't generate the appropriate cycles to
> access the clause 22 PHY.  So, this is not something we need care
> about.
> 
> > So the MDIOBUS_C45 (I think I was calling it
> > C45_ONLY) is an invalid selection. Not, that it wouldn't be helpful to have
> > a C45_ONLY case, but that the assumption is that you wouldn't try and probe
> > c22 registers, which I thought was a mistake.
> 
> MDIOBUS_C45 means "I can generate clause 45 cycles".
> MDIOBUS_C22 means "I can generate clause 22 cycles".
> MDIOBUS_C45_C22 means "I can generate both clause 45 and clause 22
> cycles."
> 
> Notice carefully the values these end up with - MDIOBUS_C22 = BIT(0),
> MDIOBUS_C45 = BIT(1), MDIOBUS_C45_C22 = BIT(0) | BIT(1).  I suspect
> that was no coincidence in Andrew's suggestion.

Hi Russell

What was a nice side affect. Since i doubt Jeremy is going to go
through every MDIO driver and set the capabilities correctly, i wanted
0 to have a safe meaning. In the code we should treat MDIOBUS_UNKNOWN
and MDIOBUS_C22 identically. But maybe some time in the distant
future, we can make 0 issue a warning.

  Andrew
