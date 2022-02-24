Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8420A4C283F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 10:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiBXJjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 04:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiBXJjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 04:39:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8527D27AFDD
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 01:38:30 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nNAZw-0007AX-SJ; Thu, 24 Feb 2022 10:38:28 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nNAZv-0005M2-72; Thu, 24 Feb 2022 10:38:27 +0100
Date:   Thu, 24 Feb 2022 10:38:27 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220224093827.GC4594@pengutronix.de>
References: <20220223084055.2719969-1-o.rempel@pengutronix.de>
 <20220223233833.mjknw5ko7hpxj3go@skbuf>
 <20220224045936.GB4594@pengutronix.de>
 <20220224093329.hssghouq7hmgxvwb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220224093329.hssghouq7hmgxvwb@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:35:47 up 75 days, 18:21, 87 users,  load average: 0.27, 0.23,
 0.26
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 11:33:29AM +0200, Vladimir Oltean wrote:
> On Thu, Feb 24, 2022 at 05:59:36AM +0100, Oleksij Rempel wrote:
> > > Are you sure the unit of measurement is ok? My KSZ9477 documentation
> > > says this about register 0x0308:
> > > 
> > > Maximum Frame Length (MTU)
> > > Specifies the maximum transmission unit (MTU), which is the maximum
> > > frame payload size. Frames which exceed this maximum are truncated. This
> > > value can be set as high as 9000 (= 0x2328) if jumbo frame support is
> > > required.
> > > 
> > > "frame payload" to me means what MTU should mean. And ETH_HLEN +
> > > VLAN_HLEN + ETH_FCS_LEN isn't part of that meaning.
> > 
> > if I set this value to anything less then 1522, it breaks the NFS boot. Since
> > my NFS server is configured with MTU 1500, i tried to guess how
> > frame size is calculated on this chip.
> 
> Sad that Microchip engineers can't decide on whether the MTU register
> holds the "Maximum Frame Length" or the "maximum frame payload size".
> They said both to have themselves covered, you understand what you will,
> of course both are not right :)

¯\_(ツ)_/¯

> > > > +	/* Now we can configure default MTU value */
> > > > +	ret = regmap_update_bits(dev->regmap[1], REG_SW_MTU__2, REG_SW_MTU_MASK,
> > > > +				 VLAN_ETH_FRAME_LEN + ETH_FCS_LEN);
> > > 
> > > Why do you need this? Doesn't DSA call dsa_slave_create() ->
> > > dsa_slave_change_mtu(ETH_DATA_LEN) on probe?
> > 
> > This was my initial assumption as well, but cadence macb driver provides
> > buggy max MTU == -18. I hardcoded bigger MTU for now[1], but was not able to
> > find proper way to fix it. To avoid this kinds of regressions I decided
> > to keep some sane default configuration.
> > 
> > [1] - my workaround.
> > commit 5f8385e9641a383478a65f96ccee8fd992201f68
> > Author: Oleksij Rempel <linux@rempel-privat.de>
> > Date:   Mon Feb 14 14:41:06 2022 +0100
> > 
> >     WIP: net: macb: fix max mtu size
> >     
> >     The gem_readl(bp, JML) will return 0, so we get max_mtu size of -18,
> >     this is breaking MTU configuration for DSA
> >     
> >     Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > 
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index a363da928e8b..454d811991bb 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -4727,7 +4727,7 @@ static int macb_probe(struct platform_device *pdev)
> >  	/* MTU range: 68 - 1500 or 10240 */
> >  	dev->min_mtu = GEM_MTU_MIN_SIZE;
> >  	if (bp->caps & MACB_CAPS_JUMBO)
> > -		dev->max_mtu = gem_readl(bp, JML) - ETH_HLEN - ETH_FCS_LEN;
> > +		dev->max_mtu = 10240 - ETH_HLEN - ETH_FCS_LEN;
> >  	else
> >  		dev->max_mtu = ETH_DATA_LEN;
> 
> Yes, but the macb driver can be a DSA master for any switch, not just
> for ksz9477. Better to fix this differently.

Yes, it should be fixed. I just need some time to understand the proper
way to do so. For now, let's proceed with the ksz patch. Should I send
new version with some changes?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
