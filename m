Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06FE6A276F
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 07:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBYGI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 01:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBYGIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 01:08:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470EC12F18
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 22:08:23 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pVnjF-0004Xf-D3; Sat, 25 Feb 2023 07:08:17 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pVnjA-0007Vf-9X; Sat, 25 Feb 2023 07:08:12 +0100
Date:   Sat, 25 Feb 2023 07:08:12 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        kernel@pengutronix.de, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
Message-ID: <20230225060812.GB8437@pengutronix.de>
References: <20230224035553.GA1089605@roeck-us.net>
 <20230224041604.GA1353778@roeck-us.net>
 <20230224045340.GN19238@pengutronix.de>
 <363517fc-d16e-5bcd-763d-fc0e32c2301a@roeck-us.net>
 <20230224165213.GO19238@pengutronix.de>
 <20230224174132.GA1224969@roeck-us.net>
 <20230224183646.GA26307@pengutronix.de>
 <b0af4518-3c07-726e-79a0-19c53f799204@roeck-us.net>
 <20230224200207.GA8437@pengutronix.de>
 <52f8bb78-0913-6e9a-7816-f32cdad688f2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52f8bb78-0913-6e9a-7816-f32cdad688f2@roeck-us.net>
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

On Fri, Feb 24, 2023 at 04:09:40PM -0800, Guenter Roeck wrote:
> On 2/24/23 12:02, Oleksij Rempel wrote:
> [ ... ]
> > > 
> > > For cubieboard:
> > > 
> > > MDIO_PCS_EEE_ABLE = 0x0000
> > > 
> > > qemu reports attempts to access unsupported registers.
> > > 
> > > I had a look at the Allwinner mdio driver. There is no indication suggesting
> > > what the real hardware would return when trying to access unsupported registers,
> > > and the Ethernet controller datasheet is not public.
> > 
> > These are PHY accesses over MDIO bus. Ethernet controller should not
> > care about content of this operations. But on qemu side, it is implemented as
> > part of Ethernet controller emulation...
> > 
> > Since MDIO_PCS_EEE_ABLE == 0x0000, phydev->supported_eee should prevent
> > other EEE related operations. But may be actual phy_read_mmd() went
> > wrong. It is a combination of simple phy_read/write to different
> > registers.
> > 
> 
> Adding MDD read/write support in qemu doesn't help. Something else in your patch
> prevents the PHY from coming up. After reverting your patch, I see
> 
> sun4i-emac 1c0b000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
> IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> 
> in the log. This is missing with your patch in place.
> 
> Anyway, the key difference is not really the qemu emulation, but the added
> unconditional call to genphy_c45_write_eee_adv() in your patch. If you look
> closely into that function, you may notice that the 'changed' variable is
> never set to 0.
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index 3813b86689d0..fee514b96ab1 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -672,7 +672,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);
>   */
>  int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv)
>  {
> -       int val, changed;
> +       int val, changed = 0;
> 
>         if (linkmode_intersects(phydev->supported_eee, PHY_EEE_CAP1_FEATURES)) {
>                 val = linkmode_to_mii_eee_cap1_t(adv);
> 
> fixes the problem, both for cubieboard and xtensa.

Good point! Thx for finding it!

Do you wont to send the fix against net?
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
