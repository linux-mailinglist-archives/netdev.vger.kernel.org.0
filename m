Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052051398E8
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 19:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgAMS3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 13:29:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35076 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbgAMS3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 13:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k0IAJpagMBUGdKxmx+KUKE83rGMLlu0VL7Kzi8GGMgI=; b=fPEt1IBW3wyg39jdDUMctfq575
        wkW5rzJLEqWNQ6bmJ/X+IoY47PG7NUxR9NJq55xweYwPPY3PTa0N33HRvX2BtJbkXRIlr8P6hX8Ew
        +M3b+edWLo0OzrS+IwAfCEGC6B6rhKJm4Oq4I3C7akx4xSavYPo/TsAIJtwZ5rFnoByg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ir4SX-00078j-Cr; Mon, 13 Jan 2020 19:29:05 +0100
Date:   Mon, 13 Jan 2020 19:29:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, cphealy@gmail.com,
        rmk+kernel@armlinux.org.uk, kuba@kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: Maintain MDIO device and bus
 statistics
Message-ID: <20200113182905.GB26448@lunn.ch>
References: <20200113045325.13470-1-f.fainelli@gmail.com>
 <20200113132152.GB11788@lunn.ch>
 <ebeb2bb2-c816-6cb8-acaa-cfd86878678d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebeb2bb2-c816-6cb8-acaa-cfd86878678d@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> For MDIO switches you would usually have the mdio_device claim the
> pseudo PHY address and all other MDIO addresses should correspond to
> built-in PHYs, for which we also have mdio_device instances, is there a
> case that I am missing?

Marvell switches don't work like this. It varies from family to
family. The 6390 family for example has address 0x0-0xa representing
registers for ports 0 to 10, 32 registers per port. address 0x1b and
0x1c contain registers for global configuration. 0x1e is used to
communication with the internal MCU, and 0x1f is the TCAM. The
internal PHYs are not in this MDIO address space at all, there is
another MDIO bus, implemented by a couple of the global registers.

The 6352 has a different layout. 0x0-0x4 represent the internal
PHYs. 0xf is the SERDES for SGMII, 0x10-x016 are the port registers,
0x1b 0x1c are global.

There is one family, i don't remember which, which uses 16
addresses. And you can put two of them on one MDIO bus.

In each of these cases, we have one mdiodev, per switch, claiming a
single address, generally 0.

Other vendors switches are similar, using multiple addresses on one
bus.

> If the answer to my question above is that we still have reads to
> addresses for which we do not have mdio_device (which we might very well
> have), then we could either:
> 
> - create <mdio_bus>:<address>/statistics/ folders even for non-existent
> devices, but just to track the per-address statistics
> - create <mdio_bus>/<address>/statistics and when a mdio_device instance
> exists we symbolic link <mdio_bus>:<address>/statistics ->
> ../<mdio_bus>/<addr>/statistics
> 
> Would that work?

Keeping the statistics for all 32 addresses in the struct mii_bus
would be good. Then directories 0-31. And symlinks. Yes, that is good.

      Andrew
