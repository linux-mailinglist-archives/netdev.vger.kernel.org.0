Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1919468BAC6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjBFKuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjBFKuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:50:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696455BB2
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:50:08 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pOz4P-0004HP-Jh; Mon, 06 Feb 2023 11:49:57 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pOz4N-0006lC-3o; Mon, 06 Feb 2023 11:49:55 +0100
Date:   Mon, 6 Feb 2023 11:49:55 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 02/23] net: phy: add
 genphy_c45_read_eee_abilities() function
Message-ID: <20230206104955.GE12366@pengutronix.de>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-3-o.rempel@pengutronix.de>
 <20230204005418.7ryb4ihuzxlbs2nl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230204005418.7ryb4ihuzxlbs2nl@skbuf>
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

Hi Vladimir,

On Sat, Feb 04, 2023 at 02:54:18AM +0200, Vladimir Oltean wrote:
> On Wed, Feb 01, 2023 at 03:58:24PM +0100, Oleksij Rempel wrote:

[....]

> > +static const int phy_eee_100_10000_features_array[6] = {
> 
> Don't need array length unless the array is sparse, which isn't the case here.
> 
> > +	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> > +	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
> > +	ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
> > +	ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
> > +	ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
> > +	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> 
> Why stop at 10GBase-KR? Register 3.20 defines EEE abilities up to 100G
> (for speeds >10G, there seem to be 2 modes, "deep sleep" or "fast wake",
> with "deep sleep" being essentially equivalent to the only mode
> available for <=10G modes).

Hm,

If i take only deep sleep, missing modes are:
3.20.13 100GBASE-R deep sleep
       family of Physical Layer devices using 100GBASE-R encoding:
       100000baseCR4_Full
       100000baseKR4_Full
       100000baseCR10_Full (missing)
       100000baseSR4_Full
       100000baseSR10_Full (missing)
       100000baseLR4_ER4_Full

3.20.11 25GBASE-R deep sleep
       family of Physical Layer devices using 25GBASE-R encoding:
       25000baseCR_Full
       25000baseER_Full (missing)
       25000baseKR_Full
       25000baseLR_Full (missing)
       25000baseSR_Full

3.20.9 40GBASE-R deep sleep
       family of Physical Layer devices using 40GBASE-R encoding:
       40000baseKR4_Full
       40000baseCR4_Full
       40000baseSR4_Full
       40000baseLR4_Full

3.20.7 40GBASE-T
       40000baseT_Full (missing)

I have no experience with modes > 1Gbit. Do all of them correct? What
should we do with missing modes? Or may be it make sense to implement >
10G modes separately?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
