Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D0D54E620
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377965AbiFPPeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376918AbiFPPeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:34:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62DC2DD5B
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:34:05 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o1rVN-0003f5-5R; Thu, 16 Jun 2022 17:33:57 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o1rVM-0006BN-HX; Thu, 16 Jun 2022 17:33:56 +0200
Date:   Thu, 16 Jun 2022 17:33:56 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: at803x: fix NULL pointer
 dereference on AR9331 PHY
Message-ID: <20220616153356.GC28995@pengutronix.de>
References: <20220616113105.890373-1-o.rempel@pengutronix.de>
 <YqsyRxNsG3AYrfnX@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YqsyRxNsG3AYrfnX@lunn.ch>
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

On Thu, Jun 16, 2022 at 03:38:15PM +0200, Andrew Lunn wrote:
> On Thu, Jun 16, 2022 at 01:31:05PM +0200, Oleksij Rempel wrote:
> > Latest kernel will explode on the PHY interrupt config, since it depends
> > now on allocated priv. So, run probe to allocate priv to fix it.
> > 
> > Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/phy/at803x.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > index 6a467e7817a6..b72a807f2e03 100644
> > --- a/drivers/net/phy/at803x.c
> > +++ b/drivers/net/phy/at803x.c
> > @@ -2072,6 +2072,8 @@ static struct phy_driver at803x_driver[] = {
> >  	/* ATHEROS AR9331 */
> >  	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
> >  	.name			= "Qualcomm Atheros AR9331 built-in PHY",
> > +	.probe			= at803x_probe,
> > +	.remove			= at803x_remove,
> >  	.suspend		= at803x_suspend,
> >  	.resume			= at803x_resume,
> >  	.flags			= PHY_POLL_CABLE_TEST,
> 
> Is the same change needed for some of the other PHYs? QCA8081?
> QCA9561?

Yes, good point.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
