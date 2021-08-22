Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80883F41C7
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 23:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhHVVlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 17:41:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhHVVlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 17:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=WjHgg2RoVpjMaNdEtPWxt1gfEbjLkGTCJql1tYv9138=; b=k1
        ouKxQ/NcaV6l2WRqLE/XMZc5syUMG78Jd5K/ifYD7UUvVeBL+hAaMqrhviqwVu6IZZSV/MNJ20dD9
        eujAxUTrEHmbHBnt88u4LiU9dw4zNmy13iIcMAHj+wTUZYpb/GZ7aZ7q7dC/rvPawEWYx/Mr0x7/M
        M3FX9ti1u6ZPNjQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mHvD4-003Nb2-78; Sun, 22 Aug 2021 23:40:54 +0200
Date:   Sun, 22 Aug 2021 23:40:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, mir@bang-olufsen.dk,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free
 bug on module unload
Message-ID: <YSLEZmuWlD5kUOlx@lunn.ch>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-2-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210822193145.1312668-2-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 09:31:39PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> realtek-smi-core fails to unregister the slave MII bus on module unload,
> raising the following BUG warning:
> 
>     mdio_bus.c:650: BUG_ON(bus->state != MDIOBUS_UNREGISTERED);
> 
>     kernel BUG at drivers/net/phy/mdio_bus.c:650!
>     Internal error: Oops - BUG: 0 [#1] PREEMPT_RT SMP
>     Call trace:
>      mdiobus_free+0x4c/0x50
>      devm_mdiobus_free+0x18/0x20
>      release_nodes.isra.0+0x1c0/0x2b0
>      devres_release_all+0x38/0x58
>      device_release_driver_internal+0x124/0x1e8
>      driver_detach+0x54/0xe0
>      bus_remove_driver+0x60/0xd8
>      driver_unregister+0x34/0x60
>      platform_driver_unregister+0x18/0x20
>      realtek_smi_driver_exit+0x14/0x1c [realtek_smi]
> 
> Fix this by duly unregistering the slave MII bus with
> mdiobus_unregister. We do this in the DSA teardown path, since
> registration is performed in the DSA setup path.

Looking at the setup code, is there anything undoing what
rtl8366rb_setup_cascaded_irq() does?

This patch however loos O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
