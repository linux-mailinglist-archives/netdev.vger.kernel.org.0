Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938AD3973C6
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhFANGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:06:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38728 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233905AbhFANGg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 09:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1nlyDUEZQwgAaoaZn/Zf38Ai9ligQ5XU00uvWa0IyRo=; b=ldePIHyiDH9JQeGLucmWsxSu58
        KAxlYi0h7zPGSssVPnhFtrG6wzD+HfzktSxy5WQSyh1DR3kCBBMEMDmMr0AdPYSJ33BprG9nXMULt
        X2RNxCDQe+LGxd7/FjJCvo1p3gb5yIJEKADV/ysWHaBjjhywmwmbroBDpVPLD7R07/w0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lo44h-007I14-HY; Tue, 01 Jun 2021 15:04:51 +0200
Date:   Tue, 1 Jun 2021 15:04:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <YLYwcx3aHXFu4n5C@lunn.ch>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
 <YKz86iMwoP3VT4uh@lunn.ch>
 <20210601104734.GA18984@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601104734.GA18984@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 06:47:34PM +0800, Wong Vee Khee wrote:
> On Tue, May 25, 2021 at 03:34:34PM +0200, Andrew Lunn wrote:
> > On Tue, May 25, 2021 at 01:58:03PM +0800, Wong Vee Khee wrote:
> > > Synopsys MAC controller is capable of pairing with external PHY devices
> > > that accessible via Clause-22 and Clause-45.
> > > 
> > > There is a problem when it is paired with Marvell 88E2110 which returns
> > > PHY ID of 0 using get_phy_c22_id(). We can add this check in that
> > > function, but this will break swphy, as swphy_reg_reg() return 0. [1]
> > 
> > Is it possible to identify it is a Marvell PHY? Do any of the other
> > C22 registers return anything unique? I'm wondering if adding
> > .match_phy_device to genphy would work to identify it is a Marvell PHY
> > and not bind to it. Or we can turn it around, make the
> > .match_phy_device specifically look for the fixed-link device by
> > putting a magic number in one of the vendor registers.
> >
> 
> I checked the Marvell and did not see any unique register values.
> Also, since get_phy_c22_id() returns a *phy_id== 0, it is not bind to
> any PHY driver, so I don't think adding the match_phy_device check in
> getphy would help.

It has a Marvell ID in C45 space. So maybe we need to special case for
ID 0. If we get that, go look in C45 space. If we find a valid ID, use
it. If we get EOPNOTSUP because the MDIO bus is not C45 capable, or we
don't find a vendor ID in C45 space, keep with id == 0 and load
genphy?

The other option is consider the PHY broken, and require that you put
the correct ID in DT as the compatible string. The correct driver will
then be loaded, based on the compatible string, rather than what is
found by probing.

      Andrew
