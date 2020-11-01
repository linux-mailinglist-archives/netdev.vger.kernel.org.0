Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19D12A2192
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 21:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgKAUi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 15:38:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgKAUiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 15:38:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZK7I-004hXh-LN; Sun, 01 Nov 2020 21:38:20 +0100
Date:   Sun, 1 Nov 2020 21:38:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     Markus Elfring <Markus.Elfring@web.de>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] lan743x: Fix for potential null pointer dereference
Message-ID: <20201101203820.GD1109407@lunn.ch>
References: <20201031143619.7086-1-sbauer@blackbox.su>
 <dabea6fc-2f2d-7864-721b-3c950265f764@web.de>
 <145853726.prPdODYtnq@metabook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <145853726.prPdODYtnq@metabook>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 10:54:38PM +0300, Sergej Bauer wrote:
> > > Signed-off-by: Sergej Bauer <sbauer@blackbox.su>
> > 
> > * I miss a change description here.
> The reason for the fix is when the device is down netdev->phydev will be NULL 
> and there is no checking for this situation. So 'ethtool ethN' leads to kernel 
> panic.

> > > @@ -809,9 +812,12 @@ static int lan743x_ethtool_set_wol(struct net_device
> > > *netdev,> 
> > >  	device_set_wakeup_enable(&adapter->pdev->dev, (bool)wol->wolopts);
> > > 
> > > -	phy_ethtool_set_wol(netdev->phydev, wol);
> > > +	if (netdev->phydev)
> > > +		ret = phy_ethtool_set_wol(netdev->phydev, wol);
> > > +	else
> > > +		ret = -EIO;

-ENETDOWN would be better, it gives a hit that WoL can be configured
when the interface is configured up.

 Andrew
