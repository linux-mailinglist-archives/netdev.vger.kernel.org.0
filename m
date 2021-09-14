Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7323A40B0BF
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhINOez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:34:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40660 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233776AbhINOex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 10:34:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dZ/cFYIXkzWrizcxyNBXtpLSQbEflTCzb5tRuZNc66Y=; b=ug2UeG9zaaiVqqrkguGGsgp1hZ
        VNHPJQCCiguzJu6rQLaBZR223BFSPl43F8xwMtYGTWUR3WZIsxvLdoXsjI0L8ZP/l2n8DhwUk96c7
        Kef44QSK8NoZM1GwPcYilBlrZ+7wRTIjm5BshsuYBbHz/Q0kbRVVT0AhnL9vKWwszUfs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQ9Uz-006bdI-LL; Tue, 14 Sep 2021 16:33:25 +0200
Date:   Tue, 14 Sep 2021 16:33:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Message-ID: <YUCytc0+ChhcdOo+@lunn.ch>
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
 <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
 <20210912213855.kxoyfqdyxktax6d3@skbuf>
 <YT+dL1R/DTVBWQ7D@lunn.ch>
 <20210914120617.iaqaukal3riridew@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914120617.iaqaukal3riridew@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 12:06:18PM +0000, Vladimir Oltean wrote:
> On Mon, Sep 13, 2021 at 08:49:19PM +0200, Andrew Lunn wrote:
> > > I am not sure why "to_phy_driver" needs cleanup. Au contraire, I think
> > > the PHY library's usage of struct phy_device :: drv is what is strange
> > > and potentially buggy, it is the only subsystem I know of that keeps its
> > > own driver pointer rather than looking at struct device :: driver.
> > 
> > There is one odd driver in the mix. Take a look at xilinx_gmii2rgmii.c.
> > 
> > It probably could be done a better way, but that is what we have.
> 
> Interesting, to say the least. Also, is there any connection between
> that and the revert I'm proposing?

If i remember correctly, Gerhard Engleder is actually using this, and
ran into a problem because the wrong driver structure was used.

> So compared to other vendors, where the RGMII gasket is part of the MAC
> device, with Xilinx Zynq it is accessible via MDIO?

Yes. Its control plane sits on the MDIO bus. Unfortunately, it does
not have any ID registers, so it does not directly appear as a PHY. So
it does interesting things it put itself in the control path to the
real PHY.

> It looks like it is said that this GMII2RGMII converter can be placed in
> front of any GMII MAC. Nice that there are zero in-tree users of
> "xlnx,gmii-to-rgmii-1.0" so that I could figure out exactly how that
> plays out in practice.

If you look back at the thread for that patch, i think Gerhard posted
a DT fragment he is using. Hopefully it will get submitted as a full
board description at some point.

> Note that the usage of priv->phy_dev, priv->phy_drv, priv->conv_phy_drv
> beats me. Why is "phy_dev" kept inside "priv" even though it is accessed
> only inside xgmiitorgmii_probe? Why does xgmiitorgmii_configure() need to
> be called from xgmiitorgmii_read_status() which in turn hooks into the
> attached PHY driver's phy_read_status()? Why does xgmiitorgmii_configure
> not get exported and called from an .adjust_link method or the phylink
> equivalent, like any other MAC-side hardware linked with the PHY library
> in the kernel?

I was never happy with this driver. It got submitted before i went on
vacation, i had a few rounds trying to get the submitter to refactor
it and was mostly ignored. I left on vacation with lots of open review
points, and when i got back it had been merged. And the original
submitters never responded to my requests for improvements.

	Andrew
