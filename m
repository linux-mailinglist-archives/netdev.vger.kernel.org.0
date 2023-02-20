Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F45569D053
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjBTPJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbjBTPJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:09:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFF0BB8B
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:08:50 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pU7lC-0000R5-93; Mon, 20 Feb 2023 16:07:22 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pU7lA-0001el-IU; Mon, 20 Feb 2023 16:07:20 +0100
Date:   Mon, 20 Feb 2023 16:07:20 +0100
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
Message-ID: <20230220150720.GA19238@pengutronix.de>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
 <Y/OB9oeEn98y0u4o@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/OB9oeEn98y0u4o@shell.armlinux.org.uk>
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

On Mon, Feb 20, 2023 at 02:21:42PM +0000, Russell King (Oracle) wrote:
> On Mon, Feb 20, 2023 at 02:56:04PM +0100, Oleksij Rempel wrote:
> >  	if (data->eee_enabled) {
> > +		phydev->eee_enabled = true;
> >  		if (data->advertised)
> > -			adv[0] = data->advertised;
> > -		else
> > -			linkmode_copy(adv, phydev->supported_eee);
> > +			phydev->advertising_eee[0] = data->advertised;
> 
> There is a behavioural change here that isn't mentioned in the patch
> description - if data->advertised was zero, you were setting the
> link modes to the full EEE supported set. After this patch, you
> appear to leave advertising_eee untouched (so whatever it was.)
> 
> Which is the correct behaviour for this interface?

Hm.. ethtool do not provide enough information about expected behavior.
Here is my expectation:
- "ethtool --set-eee lan1 eee on" should enable EEE if it is disabled.
- "ethtool --set-eee lan1 advertise 0x10" should change set of
  advertised modes.
- a sequence of "..advertise 0x10", "..eee on", "eee off" should restore
  preconfigured advertise modes. advertising_eee instead of
  supported_eee.

Seems like there is still one missing use case: if advertising_eee is
zero, we should use supported_eee value for "...eee on" case.

Other ideas?
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
