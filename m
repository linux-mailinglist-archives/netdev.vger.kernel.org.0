Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE7669D057
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjBTPKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjBTPKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:10:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D0A86B9
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:10:15 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pU7mS-0000b1-RV; Mon, 20 Feb 2023 16:08:40 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pU7mS-0001fd-JT; Mon, 20 Feb 2023 16:08:40 +0100
Date:   Mon, 20 Feb 2023 16:08:40 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] net: phy: do not force EEE support
Message-ID: <20230220150840.GB19238@pengutronix.de>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
 <Y/OBPZRGM+viGp+8@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/OBPZRGM+viGp+8@shell.armlinux.org.uk>
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

On Mon, Feb 20, 2023 at 02:18:37PM +0000, Russell King (Oracle) wrote:
> Hi,
> 
> A couple of minor points, but not sufficient not to prevent merging
> this.
> 
> On Mon, Feb 20, 2023 at 02:56:04PM +0100, Oleksij Rempel wrote:
> > @@ -865,7 +864,12 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_eee_abilities);
> >   */
> >  int genphy_c45_an_config_eee_aneg(struct phy_device *phydev)
> >  {
> > -	return genphy_c45_write_eee_adv(phydev, phydev->supported_eee);
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
> 
> It would be nice to avoid this initialisation in the case where
> eee_enabled is true, as this takes CPU cycles. However, not too
> bothered about it as this isn't a fast path.
> 
> > +
> > +	if (!phydev->eee_enabled)
> > +		return genphy_c45_write_eee_adv(phydev, adv);
> > +
> > +	return genphy_c45_write_eee_adv(phydev, phydev->advertising_eee);
> >  }
> >  
> >  /**
> > @@ -1431,17 +1435,17 @@ EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
> >  int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
> >  			       struct ethtool_eee *data)
> >  {
> > -	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
> >  	int ret;
> >  
> >  	if (data->eee_enabled) {
> > +		phydev->eee_enabled = true;
> >  		if (data->advertised)
> > -			adv[0] = data->advertised;
> > -		else
> > -			linkmode_copy(adv, phydev->supported_eee);
> > +			phydev->advertising_eee[0] = data->advertised;
> 
> Is there a reason not to use ethtool_convert_legacy_u32_to_link_mode()?
> I'm guessing this will be more efficient.

Or at leas more readable. I'll update it.
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
