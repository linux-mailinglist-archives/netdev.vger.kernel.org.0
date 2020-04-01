Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5827519AD7E
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbgDAOL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:11:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732876AbgDAOL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 10:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=//y7rTWB++mIyon6G1H8Ntxa7+4WAlVqnKhGsqIfAvQ=; b=IoLPirKSmbYazMEMzq/kFwrf9q
        uU3i/jBhcEpDS63PhX/bwJkjPqvfyUy/dCL2rcQn3skbQG75H+0nt3iEnCv+MicI7Kw0Q0yfcvxxc
        Q6SboNmTaj35lrGrWJHANouCHfNY8fkhuWWcsLJbRTtFObMXPGBiP5gtSM1vZV346I4M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jJe5J-000Qte-Ev; Wed, 01 Apr 2020 16:11:13 +0200
Date:   Wed, 1 Apr 2020 16:11:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Message-ID: <20200401141113.GC62290@lunn.ch>
References: <AM0PR04MB544326757B0B510C7C3C6417FBC90@AM0PR04MB5443.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB544326757B0B510C7C3C6417FBC90@AM0PR04MB5443.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +     val = phy_read_mmd(bpphy, MDIO_MMD_AN, bp_phy-
> > >bp_dev.mdio.an_status);
> > > +     val = phy_read_mmd(bpphy, MDIO_MMD_AN,
> > > + bp_phy->bp_dev.mdio.an_status);
> > 
> > Why not just
> > 
> > val = phy_read_mmd(bpphy, MDIO_MMD_AN, MDIO_CTRL1);
> > 
> > Or is your hardware not actually conformant to the standard?
> > 
> > There has also been a lot of discussion of reading the status twice is correct or
> > not. Don't you care the link has briefly gone down and up again?
> > 
> >         Andrew
> 
> This could be changed to use directly the MDIO_STAT1 in order to read
> AN status (and use MDIO_CTRL1 for writing the control register) but this
> is more flexible and more readable

Less readale. MDIO_STAT1 is well known. What does
bp_dev.mdio.an_status mean?

In general, core code should be KISS, and assume everything follows
the standard. We don't want to scatter workarounds for non-conformant
hardware in core code. Such workarounds should be in the drivers where
they are hidden away.

> + bpkr->mdio.an_control = MDIO_CTRL1;
> + bpkr->mdio.an_status = MDIO_STAT1;
> + bpkr->mdio.an_ad_ability_0 = MDIO_PMA_EXTABLE_10GBKR;
> + bpkr->mdio.an_ad_ability_1 = MDIO_PMA_EXTABLE_10GBKR + 1;
> + bpkr->mdio.an_lp_base_page_ability_1 = MDIO_PMA_EXTABLE_10GBKR + 4;

Please drop this, and use the #defines directly.

       Andrew
