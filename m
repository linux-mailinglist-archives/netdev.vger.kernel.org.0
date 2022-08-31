Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A445A77E0
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 09:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiHaHov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 03:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiHaHoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 03:44:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E33BD29B
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:43:38 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oTINi-0006fM-OU; Wed, 31 Aug 2022 09:43:26 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oTINg-0000cV-JU; Wed, 31 Aug 2022 09:43:24 +0200
Date:   Wed, 31 Aug 2022 09:43:24 +0200
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
Message-ID: <20220831074324.GD16715@pengutronix.de>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
 <20220830065533.GA18106@pengutronix.de>
 <67690ec6367c9dc6d2df720dcf98e6e332d2105b.camel@microchip.com>
 <20220830095830.flxd3fw4sqyn425m@skbuf>
 <20220830160546.GB16715@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220830160546.GB16715@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 06:05:46PM +0200, Oleksij Rempel wrote:
> On Tue, Aug 30, 2022 at 12:58:30PM +0300, Vladimir Oltean wrote:
> > Hello,
> > 
> > On Tue, Aug 30, 2022 at 08:15:59AM +0000, Arun.Ramadoss@microchip.com wrote:
> ...
> > > Hi Oleksij,
> > > Is this Bug related to fix in 
> > > https://lore.kernel.org/lkml/20220829105810.577903823@linuxfoundation.org/
> > > . 
> > > It is observed in ksz8794 switch. I think after applying this bug fix
> > > patch it should work. I don't have ksz8 series to test. I ran the
> > > regression only for ksz9 series switches. 
> > 
> > I find it unlikely that the cited patch will fix a NULL pointer
> > dereference in ksz_get_gbit(). But rather, some pointer to a structure
> > is NULL, and we then dereference a member located at its offset 0x5, no?
> > 
> > My eyes are on this:
> > 
> > 	const u8 *bitval = dev->info->xmii_ctrl1;
> > 
> > 		data8 |= FIELD_PREP(P_GMII_1GBIT_M, bitval[P_GMII_NOT_1GBIT]);
> > 							   ~~~~~~~~~~~~~~~~
> > 							   this is coincidentally
> > 							   also 5
> 
> ack.
> 
> > See, looking at the struct ksz_chip_data[] array element for KSZ8873
> > that Oleksij mentions as broken, I do not see xmii_ctrl1 and xmii_ctrl2
> > as being pointers to anything.
> > 
> > 	[KSZ8830] = {
> > 		.chip_id = KSZ8830_CHIP_ID,
> > 		.dev_name = "KSZ8863/KSZ8873",
> > 		.num_vlans = 16,
> > 		.num_alus = 0,
> > 		.num_statics = 8,
> > 		.cpu_ports = 0x4,	/* can be configured as cpu port */
> > 		.port_cnt = 3,
> > 		.ops = &ksz8_dev_ops,
> > 		.mib_names = ksz88xx_mib_names,
> > 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
> > 		.reg_mib_cnt = MIB_COUNTER_NUM,
> > 		.regs = ksz8863_regs,
> > 		.masks = ksz8863_masks,
> > 		.shifts = ksz8863_shifts,
> > 		.supports_mii = {false, false, true},
> > 		.supports_rmii = {false, false, true},
> > 		.internal_phy = {true, true, false},
> > 	},
> > 
> > Should we point them to ksz8795_xmii_ctrl0 and ksz8795_xmii_ctrl1? I don't know.
> > Could you find out what these should be set to?
> 
> xmii_ctrl0/1 are missing and it make no sense to add it.
> KSZ8873 switch is controlling CPU port MII configuration over global,
> not port based register.
> 
> I'll better define separate ops for this chip.

Hm, not only KSZ8830/KSZ8863/KSZ8873 are affected. ksz8795 compatible
series with defined .xmii_ctrl0/.xmii_ctrl1 are broken too. Because it
is writing to the global config register over ksz_pwrite8 function. It
means, we are writing to 0xa6 instead of 0x06. And to 0xf6 instead of
0x56.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
