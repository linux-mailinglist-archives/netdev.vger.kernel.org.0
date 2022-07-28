Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762A958400D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiG1NeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiG1NeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:34:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEE452FCE
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:33:59 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oH3dx-0006iN-5a; Thu, 28 Jul 2022 15:33:37 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oH3dw-0006O5-D1; Thu, 28 Jul 2022 15:33:36 +0200
Date:   Thu, 28 Jul 2022 15:33:36 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v1 1/1] net: dsa: microchip: don't try do read Gbit
 registers on non Gbit chips
Message-ID: <20220728133336.GA30201@pengutronix.de>
References: <20220728131725.40492-1-o.rempel@pengutronix.de>
 <YuKOTzS89D2+O8Ye@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YuKOTzS89D2+O8Ye@lunn.ch>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 03:25:35PM +0200, Andrew Lunn wrote:
> On Thu, Jul 28, 2022 at 03:17:25PM +0200, Oleksij Rempel wrote:
> > Do not try to read not existing or wrong register on chips without
> > GBIT_SUPPORT.
> > 
> > Fixes: c2e866911e25 ("net: dsa: microchip: break KSZ9477 DSA driver into two files")
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz9477.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> > index c73bb6d383ad..f6bbd9646c85 100644
> > --- a/drivers/net/dsa/microchip/ksz9477.c
> > +++ b/drivers/net/dsa/microchip/ksz9477.c
> > @@ -316,7 +316,13 @@ void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
> >  			break;
> >  		}
> >  	} else {
> > -		ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
> > +		/* No gigabit support.  Do not read wrong registers. */
> > +		if (!(dev->features & GBIT_SUPPORT) &&
> > +		    (reg == MII_CTRL1000 || reg == MII_ESTATUS ||
> > +		     reg == MII_STAT1000))
> 
> Does this actually happen?

Yes. I just discovered it after adding regmap ranges validation for
KSZ9893 chip.
> 
> If i remember this code correctly, it tries to make the oddly looking
> PHY look like a normal PHY. phylib is then used to drive the PHY?
> 
> If i have that correct, why is phylib trying to read these registers?
> It should know there is no 1G support, and should skip them.

I didn't investigated it so far. Will try to look deeper tomorrow.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
