Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF7B58AA62
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 13:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240581AbiHEL4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 07:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbiHEL4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 07:56:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F0517E0E
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 04:56:19 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oJvvw-0005JE-AQ; Fri, 05 Aug 2022 13:56:04 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oJvvt-0000dw-Ug; Fri, 05 Aug 2022 13:56:01 +0200
Date:   Fri, 5 Aug 2022 13:56:01 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 07/10] net: dsa: microchip: warn about not
 supported synclko properties on KSZ9893 chips
Message-ID: <20220805115601.GB10667@pengutronix.de>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-8-o.rempel@pengutronix.de>
 <20220802113633.73rxlb2kmihivwpx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220802113633.73rxlb2kmihivwpx@skbuf>
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

On Tue, Aug 02, 2022 at 02:36:33PM +0300, Vladimir Oltean wrote:
> On Fri, Jul 29, 2022 at 03:03:43PM +0200, Oleksij Rempel wrote:
> > KSZ9893 family of chips do not support synclko property. So warn about
> > without preventing driver from start.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz_common.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> > index 71b5349d006a..d3a9836c706f 100644
> > --- a/drivers/net/dsa/microchip/ksz_common.c
> > +++ b/drivers/net/dsa/microchip/ksz_common.c
> > @@ -1916,6 +1916,13 @@ int ksz_switch_register(struct ksz_device *dev)
> >  			dev_err(dev->dev, "inconsistent synclko settings\n");
> >  			return -EINVAL;
> >  		}
> > +
> > +		if (dev->chip_id == KSZ9893_CHIP_ID && (dev->synclko_125 ||
> > +							dev->synclko_disable)) {
> > +			dev_warn(dev->dev, "microchip,synclko-125 and microchip,synclko-disable "
> > +				 "properties are not supported on this chip. "
> > +				 "Please fix you devicetree.\n");
> 
> s/you/your/
> 
> Does KSZ8 have a REFCLK output of any sort? If it doesn't, then
> "microchip,synclko-disable" is kind of supported, right?
> 
> I wonder what there is to gain by saying that you should remove some
> device tree properties from non-ksz9477. After all, anyone can add any
> random properties to a KSZ8 switch OF node and you won't warn about
> those.

Hm, if we will have any random not support OF property in the switch
node. We won't be able to warn about it anyway. So, if it is present
but not supported, we will just ignore it.

I'll drop this patch.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
