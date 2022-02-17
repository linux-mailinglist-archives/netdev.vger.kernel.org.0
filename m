Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6004BA150
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 14:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbiBQNcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 08:32:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240936AbiBQNcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 08:32:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F281D4213;
        Thu, 17 Feb 2022 05:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=z1q+PPoygA80lRFmhMSW1T+Gpqj/0Q4oQCOQD+/QCAU=; b=eBIPu7ab4R1QeKCzhqgGZ4ej2u
        h6iTruoEzP+w8PDWKwK4B3mmk+YQ/I0Ca56oKB5SYYV37uxAlPc5Ots068mt2dqUcjSAv9mXO55Hf
        2Nf9rVdQoVIRNZj7y0OsuAILrfheAwEDCq7HXR2EIlA4FXqkxWK9bRTP0DlH/ggKle/Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nKgtH-006MoH-1V; Thu, 17 Feb 2022 14:32:11 +0100
Date:   Thu, 17 Feb 2022 14:32:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Message-ID: <Yg5OW03cPFTMhcmw@lunn.ch>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
 <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>
 <87k0dusmar.fsf@bang-olufsen.dk>
 <Yg1MfpK5PwiAbGfU@lunn.ch>
 <878ruasjd8.fsf@bang-olufsen.dk>
 <Yg47o5619InYrs9x@lunn.ch>
 <877d9tr66o.fsf@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d9tr66o.fsf@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If you have the patience to answer a few more questions:
> 
> 1. You mentioned in an earlier mail that the mdio_lock is used mostly by
> PHY drivers to synchronize their access to the MDIO bus, for a single
> read or write. You also mentioned that for switches which have a more
> involved access pattern (for instance to access switch management
> registers), a higher lock is required. In realtek-mdio this is the case:
> we do a couple of reads and writes over the MDIO bus to access the
> switch registers. Moreover, the mdio_lock is held for the duration of
> these MDIO bus reads/writes. Do you mean to say that one should rather
> take a higher-level lock and only lock/unlock the mdio_lock on a
> per-read or per-write basis? Put another way, should this:
> 
> static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
> {
> 	/* ... */
>         
> 	mutex_lock(&bus->mdio_lock);
> 
> 	bus->write(bus, priv->mdio_addr, ...);

It would be better to use __mdiobus_write()

> 	bus->write(bus, priv->mdio_addr, ...);
> 	bus->write(bus, priv->mdio_addr, ...);
> 	bus->read(bus, priv->mdio_addr, ...);

__mdiobus_read()

> 	/* ... */
> 
> 	mutex_unlock(&bus->mdio_lock);
> 
> 	return ret;
> }

You can do this.


> rather look like this?:
> 
> static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
> {
> 	/* ... */
>         
> 	mutex_lock(&my_realtek_driver_lock); /* synchronize concurrent realtek_mdio_{read,write} */
> 
> 	mdiobus_write(bus, priv->mdio_addr, ...); /* mdio_lock locked/unlocked here */
> 	mdiobus_write(bus, priv->mdio_addr, ...); /* ditto */
> 	mdiobus_write(bus, priv->mdio_addr, ...); /* ditto */
> 	mdiobus_read(bus, priv->mdio_addr, ...);  /* ditto */
> 
> 	/* ... */
> 
> 	mutex_unlock(&my_realtek_driver_lock);
> 
> 	return ret;
> }

This would also work. The advantage of this is when you have multiple
switches on one MDIO bus, you can allow parallel operations on those
switches. Also, if there are PHYs on the MDIO bus as well as the
switch, the PHYs can be accessed as well. If you are only doing 3
writes and read, it probably does not matter. If you are going to do a
lot of accesses, maybe read all the MIB values, allowing access to the
PHYs at the same time would be nice.

> 2. Is the nested locking only relevant for DSA switches which offer
> another MDIO bus? Or should all switch drivers do this, on the basis
> that, feasibly, one could connect my Realtek switch to the MDIO bus of a
> mv88e6xxx switch? In that case, and assuming the latter form of
> raeltek_mdio_read above, should one use the mdiobus_{read,write}_nested
> functions instead?

I would suggest you start with plain mdiobus_{read,write}. Using the
_nested could potentially hide a deadlock. If somebody does build
hardware with this sort of chaining, we can change to the _nested
calls.

	Andrew
