Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F21D549A1F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbiFMRfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241337AbiFMReM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:34:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B622AE0C3
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:56:05 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o0jbm-00029k-GG; Mon, 13 Jun 2022 14:55:54 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o0jbk-0001fo-7K; Mon, 13 Jun 2022 14:55:52 +0200
Date:   Mon, 13 Jun 2022 14:55:52 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <20220613125552.GA4536@pengutronix.de>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
 <YqS+zYHf6eHMWJlD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YqS+zYHf6eHMWJlD@lunn.ch>
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

On Sat, Jun 11, 2022 at 06:11:57PM +0200, Andrew Lunn wrote:
> > diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> > index c67bf3060173..6c55c7f9b680 100644
> > --- a/drivers/net/phy/phy-c45.c
> > +++ b/drivers/net/phy/phy-c45.c
> > @@ -205,7 +205,7 @@ static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
> >  		break;
> >  	case MASTER_SLAVE_CFG_UNKNOWN:
> >  	case MASTER_SLAVE_CFG_UNSUPPORTED:
> > -		return 0;
> > +		break;
> >  	default:
> >  		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> >  		return -EOPNOTSUPP;
> > @@ -223,11 +223,16 @@ static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
> >  		break;
> >  	}
> >  
> > +	if (phydev->remote_fault_set >= REMOTE_FAULT_CFG_ERROR)
> > +		adv_l |= MDIO_AN_T1_ADV_L_REMOTE_FAULT;
> > +
> >  	adv_l |= linkmode_adv_to_mii_t1_adv_l_t(phydev->advertising);
> >  
> >  	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L,
> > -				     (MDIO_AN_T1_ADV_L_FORCE_MS | MDIO_AN_T1_ADV_L_PAUSE_CAP
> > -				     | MDIO_AN_T1_ADV_L_PAUSE_ASYM), adv_l);
> > +				     (MDIO_AN_T1_ADV_L_FORCE_MS |
> > +				      MDIO_AN_T1_ADV_L_PAUSE_CAP |
> > +				      MDIO_AN_T1_ADV_L_PAUSE_ASYM |
> > +				      MDIO_AN_T1_ADV_L_REMOTE_FAULT), adv_l);
> 
> Since this is part of config_aneg, i assume you have to trigger an
> renegotiation, which will put the link down for a while. Is that
> actually required? Can the fault indicator be set at runtime without a
> full auto-neg? I suppose for a fault indicator, it probably does not
> matter, there is a fault... 
According to IEEE 802.3-2018:
"28.2.3.5 Remote fault sensing function

The Remote Fault function may indicate to the Link Partner that a fault
condition has occurred using the Remote Fault bit and, optionally, the Next
Page function
...
A Local Device may indicate it has sensed a fault to its Link Partner by
setting the Remote Fault bit in the Auto-Negotiation advertisement register and
renegotiating.

If the Local Device sets the Remote Fault bit to logic one, it may also use the
Next Page function to specify information about the fault that has occurred.
Remote Fault Message Page Codes have been specified for this purpose.
..."

If I see it correctly, there is no way to notify about remote fault when
the link is up. The remote fault bit is transferred withing Link Code
Word as part of FLP burst. At least in this part of specification.

> But i'm wondering about future extensions which might want to send values
> when the link is up. I've seen some PHYs indicate their make/model, etc.
> What sort of API would be needed for that?

We understand the spec that the Base Link Code Word and the optional (extended)
next pages are only send during autoneg. The local PHY capabilities (link
speed, duplex, remote fault...) are communicated via the Base Link Code Word.
So from our point of view it seems local to put the next pages next to the
local PHY capabilities. If the user space wants to set a next page, the
interface could be similar to remote fault, but we need to transfer more a
whole page, not just a single bit :) via netlink.

> It might also be useful if we could send an event to userspace when
> the receive state changes, so there is no need to poll. I thought
> something link a linkstate message was broadcast under some
> conditions? That again my suggest ksetting is maybe not the best place
> for this?

So receiving remote fault information via linkstate and send remote fault via
ksetting?

The next logical question is, if a remote fault is RX'ed (potentially with a
reason) who will react on this. There might be different policies on how to
react on same reason.

> I see no problem in exposing this information, but i would like to be
> sure we get the API correct.

ACK!

Regards,
Oleksij & Marc
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
