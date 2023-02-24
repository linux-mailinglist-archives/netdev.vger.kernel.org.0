Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D436F6A219A
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBXSg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjBXSgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:36:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4302B6C526
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:36:54 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pVcw4-0007fI-Up; Fri, 24 Feb 2023 19:36:48 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pVcw2-0002Aa-OS; Fri, 24 Feb 2023 19:36:46 +0100
Date:   Fri, 24 Feb 2023 19:36:46 +0100
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
Message-ID: <20230224183646.GA26307@pengutronix.de>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-7-o.rempel@pengutronix.de>
 <20230224035553.GA1089605@roeck-us.net>
 <20230224041604.GA1353778@roeck-us.net>
 <20230224045340.GN19238@pengutronix.de>
 <363517fc-d16e-5bcd-763d-fc0e32c2301a@roeck-us.net>
 <20230224165213.GO19238@pengutronix.de>
 <20230224174132.GA1224969@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230224174132.GA1224969@roeck-us.net>
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

On Fri, Feb 24, 2023 at 09:41:32AM -0800, Guenter Roeck wrote:
> On Fri, Feb 24, 2023 at 05:52:13PM +0100, Oleksij Rempel wrote:
> > On Fri, Feb 24, 2023 at 08:00:57AM -0800, Guenter Roeck wrote:
> > > On 2/23/23 20:53, Oleksij Rempel wrote:
> > > > Hallo Guenter,
> > > > 
> > > > On Thu, Feb 23, 2023 at 08:16:04PM -0800, Guenter Roeck wrote:
> > > > > On Thu, Feb 23, 2023 at 07:55:55PM -0800, Guenter Roeck wrote:
> > > > > > On Sat, Feb 11, 2023 at 08:41:10AM +0100, Oleksij Rempel wrote:
> > > > > > > Migrate from genphy_config_eee_advert() to genphy_c45_write_eee_adv().
> > > > > > > 
> > > > > > > It should work as before except write operation to the EEE adv registers
> > > > > > > will be done only if some EEE abilities was detected.
> > > > > > > 
> > > > > > > If some driver will have a regression, related driver should provide own
> > > > > > > .get_features callback. See micrel.c:ksz9477_get_features() as example.
> > > > > > > 
> > > > > > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > > > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > > > > 
> > > > > > This patch causes network interface failures with all my xtensa qemu
> > > > > > emulations. Reverting it fixes the problem. Bisect log is attached
> > > > > > for reference.
> > > > > > 
> > > > > 
> > > > > Also affected are arm:cubieboard emulations, with same symptom.
> > > > > arm:bletchley-bmc emulations crash. In both cases, reverting this patch
> > > > > fixes the problem.
> > > > 
> > > > Please test this fixes:
> > > > https://lore.kernel.org/all/167715661799.11159.2057121677394149658.git-patchwork-notify@kernel.org/
> > > > 
> > > 
> > > Applied and tested
> > > 
> > > 77c39beb5efa (HEAD -> master) net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
> > > 068a35a8d62c net: phy: do not force EEE support
> > > 66d358a5fac6 net: phy: c45: add genphy_c45_an_config_eee_aneg() function
> > > ecea1bf8b04c net: phy: c45: use "supported_eee" instead of supported for access validation
> > > 
> > > on top of
> > > 
> > > d2980d8d8265 (upstream/master, origin/master, origin/HEAD, local/master) Merge tag 'mm-nonmm-stable-2023-02-20-15-29' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > > 
> > > No change for xtensa and arm:cubieboard; network interfaces still fail.
> > 
> > Huh, interesting.
> > 
> > can you please send me the kernel logs.
> > 
> There is nothing useful there, or at least I don't see anything useful.
> The Ethernet interfaces (sun4i-emac for cubieboard and ethoc for xtensa)
> just don't come up.
> 
> Sample logs:
> 
> cubieboard:
> 
> https://kerneltests.org/builders/qemu-arm-v7-master/builds/531/steps/qemubuildcommand/logs/stdio
> 
> xtensa:
> 
> https://kerneltests.org/builders/qemu-xtensa-master/builds/2177/steps/qemubuildcommand/logs/stdio
> 
> and, for completeness, bletchley-bmc:
> 
> https://kerneltests.org/builders/qemu-arm-aspeed-master/builds/531/steps/qemubuildcommand/logs/stdio
> 
> Those logs are without the above set of patches, but I don't see a
> difference with the patches applied for cubieboard and xtensa. I
> started a complete test run (for all emulations) with the patches
> applied; that should take about an hour to complete. 
> I could also add some debug logging, but you'd have to give me
> some hints about what to add and where.

OK, interesting. These are emulated PHYs. QEMU seems to return 0 or
0xFFFF on unsupported registers. May be I'm wrong.
All EEE read/write accesses depend on initial capability read
genphy_c45_read_eee_cap1()

Can you please add this trace:

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index f595acd0a895..67dac9f0e71d 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -799,6 +799,7 @@ static int genphy_c45_read_eee_cap1(struct phy_device *phydev)
         * (Register 3.20)
         */
        val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
+       printk("MDIO_PCS_EEE_ABLE = 0x%04x", val);
        if (val < 0)
                return val;

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
