Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD02690005
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBIFt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBIFtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:49:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502D33A850
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:49:21 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pPznn-00084N-CO; Thu, 09 Feb 2023 06:48:59 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pPznl-00039o-3u; Thu, 09 Feb 2023 06:48:57 +0100
Date:   Thu, 9 Feb 2023 06:48:57 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org, wei.fang@nxp.com, edumazet@google.com,
        pabeni@redhat.com, Woojung.Huh@microchip.com, davem@davemloft.net,
        hkallweit1@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next v6 1/9] net: dsa: microchip: enable EEE support
Message-ID: <20230209054857.GB19895@pengutronix.de>
References: <20230208103211.2521836-1-o.rempel@pengutronix.de>
 <20230208103211.2521836-2-o.rempel@pengutronix.de>
 <332df2fff4503fac256e0895e4565b68fd76dee4.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <332df2fff4503fac256e0895e4565b68fd76dee4.camel@microchip.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Thu, Feb 09, 2023 at 04:07:11AM +0000, Arun.Ramadoss@microchip.com wrote:
> Hi Oleksij,
> On Wed, 2023-02-08 at 11:32 +0100, Oleksij Rempel wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > Some of KSZ9477 family switches provides EEE support. 
> 
> nit: If you can elaborate what are the chip supports will be good. 

Do you mean list of supported chips or link speeds with EEE support?

> > To enable it, we
> > just need to register set_mac_eee/set_mac_eee handlers and validate
> > supported chip version and port.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/dsa/microchip/ksz_common.c | 65
> > ++++++++++++++++++++++++++
> >  1 file changed, 65 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz_common.c
> > b/drivers/net/dsa/microchip/ksz_common.c
> > index 46becc0382d6..0a2d78253d17 100644
> > --- a/drivers/net/dsa/microchip/ksz_common.c
> > +++ b/drivers/net/dsa/microchip/ksz_common.c
> > @@ -2673,6 +2673,69 @@ static int ksz_max_mtu(struct dsa_switch *ds,
> > int port)
> >         return -EOPNOTSUPP;
> >  }
> > 
> > +static int ksz_get_mac_eee(struct dsa_switch *ds, int port,
> > +                          struct ethtool_eee *e)
> > +{
> > +       int ret;
> > +
> > +       ret = ksz_validate_eee(ds, port);
> > +       if (ret)
> > +               return ret;
> > +
> > +       /* There is no documented control of Tx LPI configuration. */
> > +       e->tx_lpi_enabled = true;
> 
> Blank line before comment will increase readability.
> 
> > +       /* There is no documented control of Tx LPI timer. According
> > to tests
> > +        * Tx LPI timer seems to be set by default to minimal value.
> > +        */
> > +       e->tx_lpi_timer = 0;
> 
> for lpi_enabled, you have used true and for lpi_timer you have used 0.
> It can be consistent either true/false or 1/0. 

tx_lpi_enabled has only on/off states. This is why i use bool values.

tx_lpi_timer is a range in microseconds to re-enter LPI mode.

Beside, tx_lpi_timer can be used to optimize EEE for some applications.
For example do not start Low Power Idle for some usecs so latency will
be reduced. Are there some secret register to configure this value? 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
