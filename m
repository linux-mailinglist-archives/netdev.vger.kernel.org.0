Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECF13DE0FF
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhHBUrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:47:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhHBUrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2c8Ena5R3BasIbqSY8iZVBqPVlAVm8oJ3q3YTA5edsU=; b=VCAYf0Twr8zxnPjdGby6VjDJ5p
        ujPHig79n8hDrURXQjWNa9UyrnAJbcWjvWwJtaXtrq6jogOFC5kqKGFGDQRxfhRocbeinRQL8tlC2
        agTfH9S/X7KvrNCM/LHRGV6zmbhP8qgOzkFo/nhQLRPOTssbb0fOyMTe557QHgMAf2KI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAeqC-00FsKE-Rb; Mon, 02 Aug 2021 22:47:16 +0200
Date:   Mon, 2 Aug 2021 22:47:16 +0200
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
Message-ID: <YQhZ1FOofUNCO53P@lunn.ch>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802135911.inpu6khavvwsfjsp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 04:59:11PM +0300, Vladimir Oltean wrote:
> On Mon, Aug 02, 2021 at 03:13:01PM +0200, Andrew Lunn wrote:
> > In general, the MAC does nothing, and passes the value to the PHY. The
> > PHY inserts delays as requested. To address Vladimir point,
> > PHY_INTERFACE_MODE_RGMII_TXID would mean the PHY adds delay in the TX
> > direction, and assumes the RX delay comes from somewhere else,
> > probably the PCB.
> 
> For the PHY, that is the only portion where things are clear.
> 
> > I only recommend the MAC adds delays when the PHY cannot, or there is
> > no PHY, e.g. SoC to switch, or switch to switch link. There are a few
> > MAC drivers that do add delays, mostly because that is how the vendor
> > crap tree does it.
> > 
> > So as i said, what you propose is O.K, it follows this general rule of
> > thumb.
> 
> The "rule of thumb" for a MAC driver is actually applied in reverse by
> most MAC drivers compared to what Russell described should be happening.
> For example, mv88e6xxx_port_set_rgmii_delay():
> 
> 	switch (mode) {
> 	case PHY_INTERFACE_MODE_RGMII_RXID:
> 		reg |= MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_RXCLK;
> 
> The mv88e6xxx is a MAC, so when it has a phy-mode = "rgmii-rxid", it
> should assume it is connected to a link partner (PHY or otherwise) that
> has applied the RXCLK delay already. So it should only be concerned with
> the TXCLK delay. That is my point. I am just trying to lay out the
> points to Prasanna that would make a sane system going forward. I am not
> sure that we actually have an in-tree driver that is sane in that
> regard.

It is a can or worms. For the used use case for the mv88e6xxx, it is a
DSA link, so there isn't really one side MAC and the other side
PHY. And if i remember correctly, both sides use rgmii-rxid.

     Andrew
