Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBD88B9FF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbfHMNX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:23:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728713AbfHMNX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 09:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YCHZ3K8mmCIRGs587/Fkq0X6NLVBIcMaI9O+DVE1psw=; b=eF7GmDgMgA1p4uWVsKBK+77zei
        /20hCu8XCVXTYsIyvLQB4DFzBsGSLw6smKcwkPPLoLGtvP7og8ewHSM9gALv5Vj8dueWVOceFKtpM
        hxclsGJlT4iTIbCjon8EoDSkUDju6egUvcdVssu8Q5U5JzyeicnT5ThM9W5gRMd9aaWc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxWll-0001Js-2X; Tue, 13 Aug 2019 15:23:21 +0200
Date:   Tue, 13 Aug 2019 15:23:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harinik@xilinx.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
Subject: Re: [PATCH 2/2] net: gmii2rgmii: Switch priv field in mdio device
 structure
Message-ID: <20190813132321.GF15047@lunn.ch>
References: <1564565779-29537-1-git-send-email-harini.katakam@xilinx.com>
 <1564565779-29537-3-git-send-email-harini.katakam@xilinx.com>
 <20190801040648.GJ2713@lunn.ch>
 <CAFcVEC+DyVhLzbMdSDsadivbnZJxSEg-0kUF5_Q+mtSbBnmhSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcVEC+DyVhLzbMdSDsadivbnZJxSEg-0kUF5_Q+mtSbBnmhSA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 04:46:40PM +0530, Harini Katakam wrote:
> Hi Andrew,
> 
> On Thu, Aug 1, 2019 at 9:36 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Wed, Jul 31, 2019 at 03:06:19PM +0530, Harini Katakam wrote:
> > > Use the priv field in mdio device structure instead of the one in
> > > phy device structure. The phy device priv field may be used by the
> > > external phy driver and should not be overwritten.
> >
> > Hi Harini
> >
> > I _think_ you could use dev_set_drvdata(&mdiodev->dev) in xgmiitorgmii_probe() and
> > dev_get_drvdata(&phydev->mdiomdio.dev) in _read_status()
> 
> Thanks for the review. This works if I do:
> dev_set_drvdata(&priv->phy_dev->mdio.dev->dev) in probe
> and then
> dev_get_drvdata(&phydev->mdio.dev) in _read_status()
> 
> i.e mdiodev in gmii2rgmii probe and priv->phy_dev->mdio are not the same.
> 
> If this is acceptable, I can send a v2.

Hi Harini

I think this is better, making use of the central driver
infrastructure, rather than inventing something new.

The kernel does have a few helper, spi_get_drvdata, pci_get_drvdata,
hci_get_drvdata. So maybe had add phydev_get_drvdata(struct phy_device
*phydev)?

	Thanks
		Andrew
