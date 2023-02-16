Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D148F698F66
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjBPJL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjBPJL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:11:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CFC38651
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 01:11:57 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pSaIr-00079B-RU; Thu, 16 Feb 2023 10:11:45 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pSaIo-0007sN-8F; Thu, 16 Feb 2023 10:11:42 +0100
Date:   Thu, 16 Feb 2023 10:11:42 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Larysa Zaremba <larysa.zaremba@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH net-next v1 7/7] net: fec: add support for PHYs with
 SmartEEE support
Message-ID: <20230216091142.GA1974@pengutronix.de>
References: <20230214090314.2026067-1-o.rempel@pengutronix.de>
 <20230214090314.2026067-8-o.rempel@pengutronix.de>
 <Y+uMDEyWW15gerN0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y+uMDEyWW15gerN0@lunn.ch>
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

Hi Andrew,

On Tue, Feb 14, 2023 at 02:26:36PM +0100, Andrew Lunn wrote:
> On Tue, Feb 14, 2023 at 10:03:14AM +0100, Oleksij Rempel wrote:
> I can see two different ways we do this. As you have here, we modify
> every MAC driver which is paired to a SmartEEE PHY and have it call
> into phylib. Or we modify the ethtool core, if it gets -EOPNOTSUPP,
> and there is an ndev->phydev call directly into phylib. That should
> make all boards with SmartEEE supported. We do this for a few calls,
> TS Info, and SFP module info.

ACK. I'm working on this.

> Either way, i don't think we need phy_has_smarteee() exposed outside
> of phylib. SmartEEE is supposed to be transparent to the MAC, so it
> should not need to care. Same as WOL, the MAC does not care if the PHY
> supports WoL, it should just call the APIs to get and set WoL and
> assume they do the right thing.
> 
> What is also unclear to me is how we negotiate between EEE and
> SmartEEE. I assume if the MAC is EEE capable, we prefer that over
> SmartEEE. But i don't think i've seen anything in these patches which
> addresses this. Maybe we want phy_init_eee() to disable SmartEEE?
> 
> 	  Andrew
> 

I would prefer to not touch phy_init_eee(). At least not in this patch
set. With this function we have following situation:
drivers/net/dsa/b53/b53_common.c:2173:

This driver will enable EEE if link partners agreed to do so. But never
disable it, if link partner decided to turn off EEE or other link partner
without EEE support was attached.

drivers/net/dsa/mt7530.c:2862:

Seems to be ok.

drivers/net/ethernet/broadcom/genet/bcmgenet.c:1353:

EEE is not enabled link up. It will work only with ethtool and only if
link was already active.

drivers/net/ethernet/freescale/fec_main.c:3078:

EEE is not enabled link up. It will work only with ethtool and only if
link was already active.

drivers/net/ethernet/marvell/mvneta.c:4225:

Seems to be ok.

drivers/net/ethernet/microchip/lan743x_ethtool.c:1115:

EEE is not enabled link up. It will work only with ethtool and only if
link was already active.

drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:130:

EEE will be enabled on open, but only if PHY was fast enough to detect
the link.

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:1084:

May partially work, by driver has many reason to not enable EEE, even if
PHY will continue to advertise it.

In all broken or partially broken cases, the PHY will continue to advertise
EEE support. And the link partner will even potentially try to make use of it.
No Idea if this works good.

Hm.. I need to admit, EEE should not be advertised by default. Only
if MAC driver calls something like phy_support_eee(), we should start doing it.

In case some Intel Ethernet drivers developer read this. There are some issue
too. For example:
net/ethernet/intel/igb/igb_ethtool.c
  igb_get_eee()
	if (adapter->link_duplex == HALF_DUPLEX) {
		edata->eee_enabled = false;
		edata->eee_active = false;
		edata->tx_lpi_enabled = false;
		edata->advertised &= ~edata->advertised;
	}

This part of code will make EEE permanently disabled if link partner switched
to HALF duplex and then back to full duplex.

It can be reproduce with following steps:
system B:
ethtool -s end0 advertise 0x008
system A:
ethtool --show-eee enp1s0f1
	EEE status: enabled - active
system B:
ethtool -s end0 advertise 0x004
system A:
ethtool --show-eee enp1s0f1
	EEE status: disabled
system B:
ethtool -s end0 advertise 0x008
ethtool --show-eee enp1s0f1
	EEE status: disabled

drivers/net/ethernet/intel/igc/igc_ethtool.c is affected as well.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
