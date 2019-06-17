Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579A8485EE
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfFQOqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:46:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbfFQOqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 10:46:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3wS85koVnsf+FY45qVuXFrrSgWtovQH4W7Vp4ZVVagU=; b=31JCs9wyec5IRucH5pKMo6UGI4
        KMQioBkvVCotd7AiuMFC9k9nN1u9co9oWvc6yNww5wtZLeCn2BYjHID2NwPxSvxG33Z1q1aFDfivv
        TIaXcXJnuIsuJXIivaBK7CPipobNJBbiMkBS9OF/Wfm0V8N7FVCLKOW+eHEVYUF/VD+c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hcste-00088w-IP; Mon, 17 Jun 2019 16:46:10 +0200
Date:   Mon, 17 Jun 2019 16:46:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH RFC 0/6] DPAA2 MAC Driver
Message-ID: <20190617144610.GE25211@lunn.ch>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <20190614094228.mg5khguayhwdu5rh@shell.armlinux.org.uk>
 <VI1PR0402MB2800BBC003EA7C572FBEF09DE0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB2800BBC003EA7C572FBEF09DE0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 03:26:50PM +0000, Ioana Ciornei wrote:
> > Subject: Re: [PATCH RFC 0/6] DPAA2 MAC Driver
> > 
> > On Fri, Jun 14, 2019 at 02:55:47AM +0300, Ioana Ciornei wrote:
> > > After today's discussion with Russell King about what phylink exposes
> > > in
> > > .mac_config(): https://marc.info/?l=linux-netdev&m=156043794316709&w=2
> > > I am submitting for initial review the dpaa2-mac driver model.
> > >
> > > At the moment, pause frame support is missing so inherently all the
> > > USXGMII modes that rely on backpressure applied by the PHY in rate
> > > adaptation between network side and system side don't work properly.
> > >
> > > As next steps, the driver will have to be integrated with the SFP bus
> > > so commands such as 'ethtool --dump-module-eeprom' will have to work
> > > through the current callpath through firmware.
> > 
> > From what I understand having read the doc patch, would it be fair to say
> > that every operation that is related to the link state has to be passed from
> > the ETH driver to the firmware, and then from the firmware back to the
> > kernel to the MAC driver?
> 
> That is correct.
> 
> > 
> > Does this mean that "ethtool --dump-module-eeprom" goes through this
> > process as well - eth driver into firmware, which then gets forwarded out of
> > the formware on the MAC side, via phylink to the SFP cage?
> > 
> > If that is true, what is the proposal - to forward a copy of the EEPROM on
> > module insertion into the firmware, so that it is stored there when anyone
> > requests it?  What about the diagnostic monitoring that is real-time?
> > 
> 
> At the moment, we do not have a proposal that could solve all these issues.
> We thought about a solution where the eth driver issues a command to the firmware that then issues an IRQ to the mac driver which could retrieve and then pass back the information.
> This doesn't seem too feasible since the ethernet driver should be waiting for the data to arrive back from the firmware while in an ethtool callback.
> 
> 
> > Or is the SFP cage entirely handled by firmware?
> 
> No, the SFP cage is not handled by firmware.

Hi Ioana

At the moment, you seem to be in a bad middle ground. The firmware
cannot do everything, so you want Linux and PHYLINK to do some
bits. But Linux expects to do everything, have full control of the
hardware. And it is not fitting together.

Maybe you need to step back and look at the overall architecture. And
then decide which way you want to go to get out of the middle
ground. There are good examples of the firmware controlling
everything, and the driver just using the high level ethtool API calls
to report state. And there are good examples of low levels of the
hardware, the MDIO bus so Linux can control the PHYs, the i2c bus and
GPIOs for the SFP cage, etc being exposed so PHYLINK can control
everything.

To have a sensible architecture and driver implementation you need to
go one way or the other. All or nothing.

   Andrew
