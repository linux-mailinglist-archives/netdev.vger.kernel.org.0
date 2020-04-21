Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92811B2B9B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgDUPuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:50:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDUPug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 11:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5qIVm+VEhaAZXfrUTN1Hcg+z9YeHBWm2Ws5qZHcGi48=; b=H+/EcYID4Kt7aTdTdWNZXw/C2w
        3e9L6+TpNonbGI6S4KyaBIrnK5INPL0mko38WwpWJM8BcpFH1nvcnqs+PfwTSSeSfmghWRgkEuZIS
        Ar+4hFzTwu++n2Li5qwcFAPFJ15sqjlNaAnbNiTBfWg24ot7/LCCiAMxspu1KQR3XOgU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQvAN-00433J-BF; Tue, 21 Apr 2020 17:50:31 +0200
Date:   Tue, 21 Apr 2020 17:50:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: add concept of shared storage
 for PHYs
Message-ID: <20200421155031.GE933345@lunn.ch>
References: <20200420232624.9127-1-michael@walle.cc>
 <7bcd7a65740a6f85637ef17ed6b6a1e3@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bcd7a65740a6f85637ef17ed6b6a1e3@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 05:25:19PM +0200, Michael Walle wrote:
> Am 2020-04-21 01:26, schrieb Michael Walle:
> > +
> > +/* Represents a shared structure between different phydev's in the same
> > + * package, for example a quad PHY. See phy_package_join() and
> > + * phy_package_leave().
> > + */
> > +struct phy_package_shared {
> > +	int addr;
> > +	refcount_t refcnt;
> > +	unsigned long flags;
> > +
> > +	/* private data pointer */
> > +	/* note that this pointer is shared between different phydevs and
> > +	 * the user has to take care of appropriate locking.
> > +	 */
> > +	void *priv;
> 
> btw. how should a driver actually use this? I mean, it can allocate
> memory if its still NULL but when will it be freed again. Do we need
> a callback? Is there something better than a callback?

Good point. phy_package_join() should take a size_t and do the
allocation. phy_package_leave() would then free it.

But since we don't have a user at the moment, maybe leave it out.

    Andrew
