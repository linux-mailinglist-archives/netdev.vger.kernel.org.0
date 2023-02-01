Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC55868662E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjBAMpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjBAMpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:45:21 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1814367D4
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:45:19 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNCUB-0007To-8B; Wed, 01 Feb 2023 13:45:11 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNCU9-00012R-71; Wed, 01 Feb 2023 13:45:09 +0100
Date:   Wed, 1 Feb 2023 13:45:09 +0100
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v3 15/15] net: fec: add support for PHYs with
 SmartEEE support
Message-ID: <20230201124509.GA31030@pengutronix.de>
References: <20230130080714.139492-1-o.rempel@pengutronix.de>
 <20230130080714.139492-16-o.rempel@pengutronix.de>
 <20230131205231.ck3xnziejgtr64ig@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230131205231.ck3xnziejgtr64ig@skbuf>
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

On Tue, Jan 31, 2023 at 10:52:31PM +0200, Vladimir Oltean wrote:
> On Mon, Jan 30, 2023 at 09:07:14AM +0100, Oleksij Rempel wrote:
> > Ethernet controller in i.MX6*/i.MX7* series do not provide EEE support.
> > But this chips are used sometimes in combinations with SmartEEE capable
> > PHYs.
> > So, instead of aborting get/set_eee access on MACs without EEE support,
> > ask PHY if it is able to do the EEE job by using SmartEEE.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++++----
> >  1 file changed, 18 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> > index e6238e53940d..25a2a9d860de 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -3102,8 +3102,15 @@ fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
> >  	struct fec_enet_private *fep = netdev_priv(ndev);
> >  	struct ethtool_eee *p = &fep->eee;
> >  
> > -	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
> > -		return -EOPNOTSUPP;
> > +	if (!(fep->quirks & FEC_QUIRK_HAS_EEE)) {
> > +		if (!netif_running(ndev))
> > +			return -ENETDOWN;
> > +
> > +		if (!phy_has_smarteee(ndev->phydev))
> > +			return -EOPNOTSUPP;
> > +
> > +		return phy_ethtool_get_eee(ndev->phydev, edata);
> 
> I see many places in the fec driver guarding against a NULL
> ndev->phydev, and TBH I don't completely understand why.
> I guess it's because ndev->phydev is populated at fec_enet_open() time.
> 
> But then again, if the netif_running() check is sufficient to imply
> presence of ndev->phydev as you suggest, then why does fec_enet_ioctl()
> have this?
> 
> 	if (!netif_running(ndev))
> 		return -EINVAL;
> 
> 	if (!phydev)
> 		return -ENODEV;
> 
> Asking because phy_init_eee(), phy_ethtool_set_eee() and
> phy_ethtool_get_eee() don't support being called with a NULL phydev.

Hm..
phy_start() is protected against NULL phydev and it is used in
fec_enet_open().

Right now i do not know what is better way go. Any preferences?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
