Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E20E6A2013
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBXQwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjBXQwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:52:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2EC6B16F
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:52:21 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pVbIu-00046d-TP; Fri, 24 Feb 2023 17:52:16 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pVbIr-0004Cj-QD; Fri, 24 Feb 2023 17:52:13 +0100
Date:   Fri, 24 Feb 2023 17:52:13 +0100
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
Message-ID: <20230224165213.GO19238@pengutronix.de>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-7-o.rempel@pengutronix.de>
 <20230224035553.GA1089605@roeck-us.net>
 <20230224041604.GA1353778@roeck-us.net>
 <20230224045340.GN19238@pengutronix.de>
 <363517fc-d16e-5bcd-763d-fc0e32c2301a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <363517fc-d16e-5bcd-763d-fc0e32c2301a@roeck-us.net>
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

On Fri, Feb 24, 2023 at 08:00:57AM -0800, Guenter Roeck wrote:
> On 2/23/23 20:53, Oleksij Rempel wrote:
> > Hallo Guenter,
> > 
> > On Thu, Feb 23, 2023 at 08:16:04PM -0800, Guenter Roeck wrote:
> > > On Thu, Feb 23, 2023 at 07:55:55PM -0800, Guenter Roeck wrote:
> > > > On Sat, Feb 11, 2023 at 08:41:10AM +0100, Oleksij Rempel wrote:
> > > > > Migrate from genphy_config_eee_advert() to genphy_c45_write_eee_adv().
> > > > > 
> > > > > It should work as before except write operation to the EEE adv registers
> > > > > will be done only if some EEE abilities was detected.
> > > > > 
> > > > > If some driver will have a regression, related driver should provide own
> > > > > .get_features callback. See micrel.c:ksz9477_get_features() as example.
> > > > > 
> > > > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > > 
> > > > This patch causes network interface failures with all my xtensa qemu
> > > > emulations. Reverting it fixes the problem. Bisect log is attached
> > > > for reference.
> > > > 
> > > 
> > > Also affected are arm:cubieboard emulations, with same symptom.
> > > arm:bletchley-bmc emulations crash. In both cases, reverting this patch
> > > fixes the problem.
> > 
> > Please test this fixes:
> > https://lore.kernel.org/all/167715661799.11159.2057121677394149658.git-patchwork-notify@kernel.org/
> > 
> 
> Applied and tested
> 
> 77c39beb5efa (HEAD -> master) net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
> 068a35a8d62c net: phy: do not force EEE support
> 66d358a5fac6 net: phy: c45: add genphy_c45_an_config_eee_aneg() function
> ecea1bf8b04c net: phy: c45: use "supported_eee" instead of supported for access validation
> 
> on top of
> 
> d2980d8d8265 (upstream/master, origin/master, origin/HEAD, local/master) Merge tag 'mm-nonmm-stable-2023-02-20-15-29' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> No change for xtensa and arm:cubieboard; network interfaces still fail.

Huh, interesting.

can you please send me the kernel logs.

> On the plus side, the failures with arm:bletchley-bmc (warnings, crash)
> are longer seen.

s/longer/no longer/ ?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
