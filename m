Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A997622C5C
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 14:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiKIN1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 08:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKIN1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 08:27:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860FC2F028
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 05:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xEC3hFWXfcAG9SDgAjlGS8hSuUjS8O2GqLTgfGFZWx0=; b=3RmtY77hQSCA72t/2arJPipUjX
        6heKnrJaGiKU4jwtZoWX9sfklJPKTaN2I4PUTZcjSVUj+rgWEaWQfULsfx9KtnMCrfRZIhlJ0B9GX
        VE5drpyxl5BRwXoaZZf8D456lp/zSr7sfFg3LGM19gkPhuvCLoM6+q2whp+LULNluzAA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osl6J-001uyh-7e; Wed, 09 Nov 2022 14:26:43 +0100
Date:   Wed, 9 Nov 2022 14:26:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     'Mengyuan Lou' <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: txgbe: Identify PHY and SFP module
Message-ID: <Y2uqk9BwVjPcEtPP@lunn.ch>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
 <20221108111907.48599-2-mengyuanlou@net-swift.com>
 <Y2rBo3KI2LmjS55y@lunn.ch>
 <02a901d8f405$1c21a350$5464e9f0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02a901d8f405$1c21a350$5464e9f0$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > So it looks like you have Linux driving the SFP, not firmware. In that case, please throw all this
> code away.
> > Implement a standard Linux I2C bus master driver, and make use of driver/net/phy/sfp*.[ch].
> > 
> >     Andrew
> > 
> 
> I don't quite understand how to use driver/net/phy/sfp* files. In txgbe driver, I2C infos are read
> from CAB registers, then SFP type identified.
> Perhaps implement 'struct sfp_upstream_ops' ? And could you please guide me an example driver of
> some docs?

The SFP driver is currently device tree only, but it should be easy to
add support for a platform device and platform data. That driver needs
to be told about a standard Linux i2c master device, and optionally a
collection of GPIO which connect to the SFP socket.

So you need to implement a standard Linux I2C bus master. Which
basically means being able to send and receive an I2C message. Take a
look at for example drivers/net/ethernet/mellanox/mlxsw/i2c.c . This
driver however does not use it with the SFP driver, since the Mellanox
devices have firmware controlling the SFP. But it will give you the
idea how you can embed an I2C bus driver inside another driver.

For the GPIOs to the SFP socket, TX Enable, LOS, MODDEF etc, you want
a standard Linux GPIO driver. For an example, look at
drivers/net/dsa/vitesse-vsc73xx-core.c.

https://github.com/lunn/linux/blob/v5.0.7-rap/drivers/platform/x86/zii-rap.c
contains an example of registering a bit-bang MDIO
controller. zii_rap_mdio_gpiod_table would become a list of SFP
GPIOs. zii_rap_mdio_init() registers a platform devices which
instantiaces an MDIO bus. You would register a platform device which
instantiates an SFP device.

Once you have an SFP devices you need to extend phylink with a
platform data binding. So you can pass it your SFP device.

This should all be reasonably simple code.

     Andrew
