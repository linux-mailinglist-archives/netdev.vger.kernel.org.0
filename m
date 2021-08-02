Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF683DD6B3
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhHBNNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:13:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233646AbhHBNNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 09:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=T2IAzdUQovydbbmh506kT2JFY/1lImBNxuW1tWg0QTk=; b=tC
        rpN3yfQsRPLJ8Ta6LfwE+sz7d6YV4AMopZ/L2AxHoPl5dKf0FRXzqLq6q0PzD/9fq+dqxFDIHjCOT
        tQQiFQoX5YL/krL8hFoLB2QROPnroxW3MQMFzNC9NwlYImEY2Twpqqx5khpBAVhE1BhR9NAwuWK3r
        QhVD9IWohkc/Dgc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAXkb-00Fp0B-VY; Mon, 02 Aug 2021 15:13:01 +0200
Date:   Mon, 2 Aug 2021 15:13:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <YQfvXTEbyYFMLH5u@lunn.ch>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210802121550.gqgbipqdvp5x76ii@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 03:15:50PM +0300, Vladimir Oltean wrote:
> On Mon, Aug 02, 2021 at 04:15:08PM +0530, Prasanna Vengateshan wrote:
> > On Sat, 2021-07-31 at 18:04 +0300, Vladimir Oltean wrote:
> > > > +void lan937x_mac_config(struct ksz_device *dev, int port,
> > > > +                     phy_interface_t interface)
> > > > +{
> > > > +     u8 data8;
> > > > +
> > > > +     lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> > > > +
> > > > +     /* clear MII selection & set it based on interface later */
> > > > +     data8 &= ~PORT_MII_SEL_M;
> > > > +
> > > > +     /* configure MAC based on interface */
> > > > +     switch (interface) {
> > > > +     case PHY_INTERFACE_MODE_MII:
> > > > +             lan937x_config_gbit(dev, false, &data8);
> > > > +             data8 |= PORT_MII_SEL;
> > > > +             break;
> > > > +     case PHY_INTERFACE_MODE_RMII:
> > > > +             lan937x_config_gbit(dev, false, &data8);
> > > > +             data8 |= PORT_RMII_SEL;
> > > > +             break;
> > > > +     case PHY_INTERFACE_MODE_RGMII:
> > > > +     case PHY_INTERFACE_MODE_RGMII_ID:
> > > > +     case PHY_INTERFACE_MODE_RGMII_TXID:
> > > > +     case PHY_INTERFACE_MODE_RGMII_RXID:
> > > > +             lan937x_config_gbit(dev, true, &data8);
> > > > +             data8 |= PORT_RGMII_SEL;
> > > > +
> > > > +             /* Add RGMII internal delay for cpu port*/
> > > > +             if (dsa_is_cpu_port(dev->ds, port)) {
> > >
> > > Why only for the CPU port? I would like Andrew/Florian to have a look
> > > here, I guess the assumption is that if the port has a phy-handle, the
> > > RGMII delays should be dealt with by the PHY, but the logic seems to be
> > > "is a CPU port <=> has a phy-handle / isn't a CPU port <=> doesn't have
> > > a phy-handle"? What if it's a fixed-link port connected to a downstream
> > > switch, for which this one is a DSA master?
> >
> > Thanks for reviewing the patches. My earlier proposal here was to check if there
> > is no phydev (dp->slave->phydev) or if PHY is genphy, then apply RGMII delays
> > assuming delays should be dealt with the phy driver if available. What do you
> > think of that?
> 
> I don't know what to suggest, this is a bit of a minefield.

In general, the MAC does nothing, and passes the value to the PHY. The
PHY inserts delays as requested. To address Vladimir point,
PHY_INTERFACE_MODE_RGMII_TXID would mean the PHY adds delay in the TX
direction, and assumes the RX delay comes from somewhere else,
probably the PCB.

I only recommend the MAC adds delays when the PHY cannot, or there is
no PHY, e.g. SoC to switch, or switch to switch link. There are a few
MAC drivers that do add delays, mostly because that is how the vendor
crap tree does it.

So as i said, what you propose is O.K, it follows this general rule of
thumb.

	Andrew
