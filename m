Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9786BE881
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCQLrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCQLrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:47:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE7136FEE
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 04:47:10 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pd8Xp-00086B-4K; Fri, 17 Mar 2023 12:46:49 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pd8Xm-0002eX-PY; Fri, 17 Mar 2023 12:46:46 +0100
Date:   Fri, 17 Mar 2023 12:46:46 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH net-next 2/4] net: dsa: microchip: partial
 conversion to regfields API for KSZ8795 (WIP)
Message-ID: <20230317114646.GA15269@pengutronix.de>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
 <20230316161250.3286055-3-vladimir.oltean@nxp.com>
 <20230317094629.nryf6qkuxp4nisul@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230317094629.nryf6qkuxp4nisul@skbuf>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 11:46:29AM +0200, Vladimir Oltean wrote:
> > +++ b/drivers/net/dsa/microchip/ksz8863_smi.c
> > @@ -136,11 +136,16 @@ static const struct regmap_config ksz8863_regmap_config[] = {
> >  
> >  static int ksz8863_smi_probe(struct mdio_device *mdiodev)
> >  {
> > +	const struct ksz_chip_data *chip;
> >  	struct regmap_config rc;
> >  	struct ksz_device *dev;
> >  	int ret;
> >  	int i;
> >  
> > +	chip = device_get_match_data(ddev);
> 
> s/ddev/&mdiodev->dev/

It fails on ksz8873 switch with following trace:

[    2.490822] 8<--- cut here ---
[    2.493907] Unable to handle kernel NULL pointer dereference at virtual address 00000004 when read
[    2.502924] [00000004] *pgd=00000000
[    2.506536] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    2.511864] Modules linked in:
[    2.514935] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.3.0-rc1-00519-gd11a10757686-dirty #263
[    2.523562] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    2.530100] PC is at ksz_regfields_init+0x44/0xa0
[    2.534833] LR is at _raw_spin_unlock_irqrestore+0x44/0x68
[    2.540336] pc : [<8075384c>]    lr : [<80ca2ca0>]    psr: a0000013
[    2.546614] sp : a0835c30  ip : a0835bd0  fp : a0835c5c
[    2.551848] r10: 80dacf48  r9 : 80dacdc0  r8 : 821d82ac
[    2.557083] r7 : 80dad00c  r6 : 00000000  r5 : 821d8240  r4 : 00000000
[    2.563622] r3 : 00000000  r2 : 00000000  r1 : 1ed17000  r0 : 821dac40
...
[    2.936367] Backtrace:                                                                    
[    2.938826]  ksz_regfields_init from ksz8863_smi_probe+0xfc/0x134
[    2.944962]  r6:00000003 r5:820bc800 r4:821d8240
[    2.949588]  ksz8863_smi_probe from mdio_probe+0x38/0x5c
[    2.954948]  r10:811495b8 r9:821da338 r8:00000000 r7:814dbbb8 r6:81468944 r5:820bc800
[    2.962786]  r4:81468944
[    2.965327]  mdio_probe from really_probe+0x1ac/0x3c8
[    2.970414]  r5:00000000 r4:820bc800                                                      
[    2.973997]  really_probe from __driver_probe_device+0x1d0/0x204
[    2.980036]  r8:814cc580 r7:814dbbb8 r6:820bc800 r5:81468944 r4:820bc800
[    2.986744]  __driver_probe_device from driver_probe_device+0x4c/0xc8
[    2.993217]  r9:821da338 r8:814cc580 r7:00000000 r6:820bc800 r5:81468944 r4:8154f4d4
[    3.000967]  driver_probe_device from __driver_attach+0x158/0x17c
[    3.007092]  r7:8067f830 r6:81468944 r5:81468944 r4:820bc800
[    3.012758]  __driver_attach from bus_for_each_dev+0x88/0xc8
[    3.018449]  r7:8067f830 r6:81468944 r5:81b25400 r4:821d0634
[    3.024116]  bus_for_each_dev from driver_attach+0x28/0x30
[    3.029631]  r7:00000000 r6:81b25400 r5:821da300 r4:81468944
[    3.035296]  driver_attach from bus_add_driver+0xdc/0x1f8
[    3.040719]  bus_add_driver from driver_register+0xc8/0x110
[    3.046326]  r9:814cc580 r8:814cc580 r7:00000000 r6:00000006 r5:81235290 r4:81468944
[    3.054076]  driver_register from mdio_driver_register+0x60/0xa0
[    3.060117]  r5:81235290 r4:81468944
[    3.063699]  mdio_driver_register from mdio_module_init+0x1c/0x24
[    3.069827]  r5:81235290 r4:81968940
[    3.073409]  mdio_module_init from do_one_initcall+0xac/0x214
[    3.079183]  do_one_initcall from kernel_init_freeable+0x1f8/0x244
[    3.085399]  r8:8124b858 r7:8124b834 r6:00000006 r5:00000075 r4:8199d580
[    3.092108]  kernel_init_freeable from kernel_init+0x24/0x140
[    3.097888]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:80c9d3a8
[    3.105726]  r4:81304f00
[    3.108268]  kernel_init from ret_from_fork+0x14/0x2c
[    3.113344] Exception stack(0xa0835fb0 to 0xa0835ff8)
...

There reason is that ksz8795_regfields[] is assigned only to KSZ8795.
KSZ8794, KSZ8765 and KSZ8830 (KSZ8863/KSZ8873) do not have needed regfields.

Please note, ksz8795_regfields[] is not compatible with KSZ8830 (KSZ8863/KSZ8873)
series.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
