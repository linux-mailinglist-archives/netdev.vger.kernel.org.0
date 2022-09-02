Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171D55AABEE
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 11:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbiIBJ5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 05:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiIBJ5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 05:57:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19171CE4B6
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 02:57:18 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oU3QC-0006vm-Ff; Fri, 02 Sep 2022 11:57:08 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oU3QB-0005Eq-97; Fri, 02 Sep 2022 11:57:07 +0200
Date:   Fri, 2 Sep 2022 11:57:07 +0200
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
Message-ID: <20220902095707.GA15827@pengutronix.de>
References: <20220830065533.GA18106@pengutronix.de>
 <67690ec6367c9dc6d2df720dcf98e6e332d2105b.camel@microchip.com>
 <20220830095830.flxd3fw4sqyn425m@skbuf>
 <20220830160546.GB16715@pengutronix.de>
 <20220831074324.GD16715@pengutronix.de>
 <20220831151859.ubpkt5aljrp3hiph@skbuf>
 <20220831161055.GA2479@pengutronix.de>
 <6c4666fd48ce41f84dbdad63a5cd6f4d3be25f4a.camel@microchip.com>
 <20220901112721.GB2479@pengutronix.de>
 <20220901124737.mrfo3fefjsn4scuy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220901124737.mrfo3fefjsn4scuy@skbuf>
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

Hi Vladimir,

On Thu, Sep 01, 2022 at 03:47:37PM +0300, Vladimir Oltean wrote:
> On Thu, Sep 01, 2022 at 01:27:21PM +0200, Oleksij Rempel wrote:
> > > The global register 0x06 responsibilities are bit 4 for 10/100mbps
> > > speed selection, bit 5 for flow control and bit 6  for duplex
> > > operation. Since these three are new features added during refactoring
> > > I overlooked it. 
> > > To fix this, either I need to return from the ksz_set_100_10mbit &
> > > ksz_duplex_flowctrl function if the chip_id is ksz87xx or add
> > > dev->dev_ops for this alone.  Kindly suggest on how to proceed.
> > 
> > I would prefer to got ops way, to clean things up.
> 
> I can't say that that one approach is better or worse than the other.
> Indirect function calls are going to be more expensive than conditionals
> on dev->chip_id, but we aren't in a fast path here, so it doesn't matter
> too much.
> 
> Having indirect function calls will in theory help simplify the logic of
> the main function, but will require good forethought for what constitutes
> an atom of functionality, in a high enough level such as to abstract
> switch differences. Whereas conditionals don't require thinking that far,
> you put them where you need them.
> 
> Also, indirect function calls will move the bloat somewhere else. I have
> seen complaints in the past about the mv88e6xxx driver's layered structure,
> making it difficult to see exactly what gets done for a certain chip.
> 
> It is probable that we don't want to mix these styles too much within a
> single driver, so if work has already started towards dev_ops for
> everything, then dev_ops be it, I guess.
> 
> Oleksij, are you going to submit patches with your proposal?

I have send one simple patch for net to make it work. After this
one will pop-up in then net-next i'll send other patches depending on
this patch.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
