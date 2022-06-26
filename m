Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E9355B1C8
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 14:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiFZMP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 08:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbiFZMP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 08:15:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A47DFE6
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 05:15:55 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o5RBA-0001zF-AI; Sun, 26 Jun 2022 14:15:52 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o5RB7-0001wE-II; Sun, 26 Jun 2022 14:15:49 +0200
Date:   Sun, 26 Jun 2022 14:15:49 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 1/1] net: phy: ax88772a: fix lost pause
 advertisement configuration
Message-ID: <20220626121549.GA8725@pengutronix.de>
References: <20220624075558.3141464-1-o.rempel@pengutronix.de>
 <20220625071731.GA3462@wunner.de>
 <YrgfsPq4lrYnSStk@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrgfsPq4lrYnSStk@lunn.ch>
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

On Sun, Jun 26, 2022 at 10:58:24AM +0200, Andrew Lunn wrote:
> On Sat, Jun 25, 2022 at 09:17:31AM +0200, Lukas Wunner wrote:
> > On Fri, Jun 24, 2022 at 09:55:58AM +0200, Oleksij Rempel wrote:
> > > In case of asix_ax88772a_link_change_notify() workaround, we run soft
> > > reset which will automatically clear MII_ADVERTISE configuration. The
> > > PHYlib framework do not know about changed configuration state of the
> > > PHY, so we need to save and restore all needed configuration registers.
> > [...]
> > >  static void asix_ax88772a_link_change_notify(struct phy_device *phydev)
> > >  {
> > >  	/* Reset PHY, otherwise MII_LPA will provide outdated information.
> > >  	 * This issue is reproducible only with some link partner PHYs
> > >  	 */
> > > -	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset)
> > > +	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset) {
> > > +		struct asix_context context;
> > > +
> > > +		asix_context_save(phydev, &context);
> > > +
> > >  		phydev->drv->soft_reset(phydev);
> > > +
> > > +		asix_context_restore(phydev, &context);
> > > +	}
> > >  }
> > 
> > Hm, how about just calling phy_init_hw()?  That will perform a
> > ->soft_reset() and also restore the configuration, including
> > interrupts (which the above does not, but I guess that's
> > irrelevant as long as the driver uses polling).
> > 
> > Does phy_init_hw() do too much or too little compared to the above
> > and is hence not a viable solution?
> 
> 
> at803x.c has:
> 
>         /* After changing the smart speed settings, we need to perform a
>          * software reset, use phy_init_hw() to make sure we set the
>          * reapply any values which might got lost during software reset.
>          */
>         if (ret == 1)
>                 ret = phy_init_hw(phydev);
> 

Hm, this is not enough to restore/reconfigure advertisement register.
Should I change PHY state to UP and trigger the state machine?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
