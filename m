Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618D34C10BE
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239568AbiBWK4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239285AbiBWK4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:56:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84487DE04
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 02:56:12 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nMpJb-0004Mc-6v; Wed, 23 Feb 2022 11:56:11 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nMpJa-0005an-0j; Wed, 23 Feb 2022 11:56:10 +0100
Date:   Wed, 23 Feb 2022 11:56:09 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH] net: fec: ethtool: fix unbalanced IRQ wake disable
Message-ID: <20220223105609.GL9136@pengutronix.de>
References: <20220223080918.3751233-1-s.hauer@pengutronix.de>
 <DB8PR04MB6795F51CEFF0DE50E57C9FFBE63C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB6795F51CEFF0DE50E57C9FFBE63C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:44:45 up 74 days, 19:30, 91 users,  load average: 0.17, 0.19,
 0.22
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
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

On Wed, Feb 23, 2022 at 10:28:34AM +0000, Joakim Zhang wrote:
> 
> Hi Sascha,
> 
> > -----Original Message-----
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > Sent: 2022年2月23日 16:09
> > To: netdev@vger.kernel.org
> > Cc: Joakim Zhang <qiangqing.zhang@nxp.com>; David S . Miller
> > <davem@davemloft.net>; kernel@pengutronix.de; Ahmad Fatoum
> > <a.fatoum@pengutronix.de>; Sascha Hauer <s.hauer@pengutronix.de>
> > Subject: [PATCH] net: fec: ethtool: fix unbalanced IRQ wake disable
> > 
> > From: Ahmad Fatoum <a.fatoum@pengutronix.de>
> > 
> > Userspace can trigger a kernel warning by using the ethtool ioctls to disable
> > WoL, when it was not enabled before:
> > 
> >   $ ethtool -s eth0 wol d ; ethtool -s eth0 wol d
> >   Unbalanced IRQ 54 wake disable
> >   WARNING: CPU: 2 PID: 17532 at kernel/irq/manage.c:900
> > irq_set_irq_wake+0x108/0x148
> > 
> > This is because fec_enet_set_wol happily calls disable_irq_wake, even if the
> > wake IRQ is already disabled.
> 
> I have not found disable_irq_wake in fec_enet_set_wol.
> https://elixir.bootlin.com/linux/v5.17-rc5/source/drivers/net/ethernet/freescale/fec_main.c#L2882
> 
> > Looking at other drivers, like lpc_eth, suggests the way to go is to do wake
> > IRQ enabling/disabling in the suspend/resume callbacks.
> > Doing so avoids the warning at no loss of functionality.
> 
> FEC done as this way:
> https://elixir.bootlin.com/linux/v5.17-rc5/source/drivers/net/ethernet/freescale/fec_main.c#L4075
> https://elixir.bootlin.com/linux/v5.17-rc5/source/drivers/net/ethernet/freescale/fec_main.c#L4119
> 
> > This only affects userspace with older ethtool versions. Newer ones use
> > netlink and disabling before enabling will be refused before reaching the
> > driver.
> 
> Ahh, what I misunderstand? All the description makes me confusion. Please use the latest kernel.

This patch was forward ported from v5.16. I should have had a closer
look before posting, then I maybe would have realized that 0b6f65c707e5
("net: fec: fix system hang during suspend/resume") already fixes the
issue.

Sorry for the noise.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
