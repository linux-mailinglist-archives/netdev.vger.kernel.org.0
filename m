Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63615A82BC
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 18:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiHaQLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 12:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiHaQLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 12:11:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB547AC2C
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 09:11:05 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oTQIr-0005ZB-EO; Wed, 31 Aug 2022 18:10:57 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oTQIp-0003g0-Ev; Wed, 31 Aug 2022 18:10:55 +0200
Date:   Wed, 31 Aug 2022 18:10:55 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Arun.Ramadoss@microchip.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, san@skov.dk, linux@armlinux.org.uk,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Message-ID: <20220831161055.GA2479@pengutronix.de>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
 <20220830065533.GA18106@pengutronix.de>
 <67690ec6367c9dc6d2df720dcf98e6e332d2105b.camel@microchip.com>
 <20220830095830.flxd3fw4sqyn425m@skbuf>
 <20220830160546.GB16715@pengutronix.de>
 <20220831074324.GD16715@pengutronix.de>
 <20220831151859.ubpkt5aljrp3hiph@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220831151859.ubpkt5aljrp3hiph@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 06:18:59PM +0300, Vladimir Oltean wrote:
> On Wed, Aug 31, 2022 at 09:43:24AM +0200, Oleksij Rempel wrote:
> > > > Should we point them to ksz8795_xmii_ctrl0 and ksz8795_xmii_ctrl1? I don't know.
> > > > Could you find out what these should be set to?
> > > 
> > > xmii_ctrl0/1 are missing and it make no sense to add it.
> > > KSZ8873 switch is controlling CPU port MII configuration over global,
> > > not port based register.
> > > 
> > > I'll better define separate ops for this chip.
> > 
> > Hm, not only KSZ8830/KSZ8863/KSZ8873 are affected. ksz8795 compatible
> > series with defined .xmii_ctrl0/.xmii_ctrl1 are broken too. Because it
> > is writing to the global config register over ksz_pwrite8 function. It
> > means, we are writing to 0xa6 instead of 0x06. And to 0xf6 instead of
> > 0x56.
> 
> What do you mean by "global config register"? The Is_1Gbps bit is still
> part of a port register, it's just that this particular register is only
> defined for the 5th port (port #4, the only xMII port on KSZ7895 AFAIU).
> That doesn't necessarily make it a "global" register.
> 
> Datasheet says:
> 
> Register 22 (0x16): Reserved
> Register 38 (0x26): Reserved
> Register 54 (0x36): Reserved
> Register 70 (0x46): Reserved
> Register 86 (0x56): Port 5 Interface Control 6
> 
> I wonder if it's ok to modify the regs table like this, because we
> should then only touch P_XMII_CTRL_1 using port 4:
> 
>  static const u16 ksz8795_regs[] = {
>  	[REG_IND_CTRL_0]		= 0x6E,
>  	[REG_IND_DATA_8]		= 0x70,
>  	[REG_IND_DATA_CHECK]		= 0x72,
>  	[REG_IND_DATA_HI]		= 0x71,
>  	[REG_IND_DATA_LO]		= 0x75,
>  	[REG_IND_MIB_CHECK]		= 0x74,
>  	[REG_IND_BYTE]			= 0xA0,
>  	[P_FORCE_CTRL]			= 0x0C,
>  	[P_LINK_STATUS]			= 0x0E,
>  	[P_LOCAL_CTRL]			= 0x07,
>  	[P_NEG_RESTART_CTRL]		= 0x0D,
>  	[P_REMOTE_STATUS]		= 0x08,
>  	[P_SPEED_STATUS]		= 0x09,
>  	[S_TAIL_TAG_CTRL]		= 0x0C,
>  	[P_STP_CTRL]			= 0x02,
>  	[S_START_CTRL]			= 0x01,
>  	[S_BROADCAST_CTRL]		= 0x06,
>  	[S_MULTICAST_CTRL]		= 0x04,
>  	[P_XMII_CTRL_0]			= 0x06,
> -	[P_XMII_CTRL_1]			= 0x56,
> +	[P_XMII_CTRL_1]			= 0x06,
>  };
> 

Speed configuration on ksz8795 is done over two registers:
Register 86 (0x56): Port 5 Interface Control 6: Is_1Gbps - BIT(6)
and
Register 6 (0x06): Global Control 4: Switch SW5-MII/RMII Speed -BIT(4)

both are accessed on wrong offsets.

I would prefer to do following steps:
- remove everything from ksz_phylink_mac_link_up() except of
  dev->dev_ops->phylink_mac_link_up
- move ksz_duplex_flowctrl(), ksz_port_set_xmii_speed()... to ksz9477.c
  and rename them. Assign ksz9477_phylink_mac_link_up()
  dev->dev_ops->phylink_mac_link_up
- create separate function ksz8795_phylink_mac_link_up()
- use documented, not generic register names.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
