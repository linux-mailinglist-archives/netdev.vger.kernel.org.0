Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553E873412
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387519AbfGXQjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:39:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387474AbfGXQjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 12:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wArjT2MpImAqGdQUdIABnoJnGCq4fg+a4RGyelO4sI0=; b=1nfk9Ah7W9jraNjNJyLYk5qygW
        c9Is3PaSspG/UF2r8LD3z1th+dBaZFXBAS8ftFOF9l0fbKVOPLzk2ihr9UuPdG3XhlVck4uPxHxkL
        4EfXWn/h2ZoD9K6g5WQiAB4HTbsDrPvyERusX4xONbN/aKjx+fwRzVl/EkQhsO3z805I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqKIE-0000gj-4j; Wed, 24 Jul 2019 18:39:06 +0200
Date:   Wed, 24 Jul 2019 18:39:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v1 1/4] enetc: Clean up local mdio bus allocation
Message-ID: <20190724163906.GT25635@lunn.ch>
References: <1563979301-596-1-git-send-email-claudiu.manoil@nxp.com>
 <1563979301-596-2-git-send-email-claudiu.manoil@nxp.com>
 <20190724151803.GR25635@lunn.ch>
 <VI1PR04MB4880CD977A5D58DA0A7EE56696C60@VI1PR04MB4880.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB4880CD977A5D58DA0A7EE56696C60@VI1PR04MB4880.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >All the horrible casts go away, the driver is structured like every
> >other driver, sparse is probably happy, etc.
> >
> 
> This looks more like a matter cosmetic preferences.  I mean, I didn't
> notice anything "horrible" in the code so far.

#define bus_to_enetc_regs(bus)  (struct enetc_mdio_regs __iomem *)((bus)->priv)

You should not need a cast here, bus->priv is a void *. But bus->priv
is being abused to hold a __iomem pointer.

enetc_wr_reg(&regs->mdio_cfg, mdio_cfg);

This is also rather odd, passing the address of something to an IO
operator? I also don't know the C standard well enough to know if it
is guaranteed that:

struct enetc_mdio_regs {
        u32     mdio_cfg;       /* MDIO configuration and status */
        u32     mdio_ctl;       /* MDIO control */
        u32     mdio_data;      /* MDIO data */
        u32     mdio_addr;      /* MDIO address */
};

actually works. On a 64bit system is the compiler allowed to put in
padding to keep the u32 64 bit aligned?

> I actually find it more
> ugly to define a new structure with only one element inside, like:
> struct enetc_mdio_priv {
>        struct enetc_hw *hw;
> }

One advantage of this is that struct enetc_hw correctly has all the
__iomem attributes. All the casts to __iomem go away, and sparse is
happy.

> Anyway, if others already did this in the kernel, what can I do?

Clean it up. Make the code more readable and easy to maintain.

      Andrew
