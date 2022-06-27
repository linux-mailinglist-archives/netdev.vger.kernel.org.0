Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7405F55E212
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiF0NDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 09:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiF0NDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 09:03:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1DCE0FF
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:02:35 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o5oNn-0003x3-Iq; Mon, 27 Jun 2022 15:02:27 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o5oNl-0006mA-Un; Mon, 27 Jun 2022 15:02:25 +0200
Date:   Mon, 27 Jun 2022 15:02:25 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Anton Lundin <glance@acc.umu.se>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [REGRESSION] AX88772 card booted without cable can't receive
Message-ID: <20220627130225.GA13092@pengutronix.de>
References: <20220622141638.GE930160@montezuma.acc.umu.se>
 <20220623063649.GD23685@pengutronix.de>
 <20220624081706.GB14396@pengutronix.de>
 <20220627123229.GF930160@montezuma.acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220627123229.GF930160@montezuma.acc.umu.se>
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

On Mon, Jun 27, 2022 at 02:32:29PM +0200, Anton Lundin wrote:
> On 24 June, 2022 - Oleksij Rempel wrote:
> 
> > Hi Anton,
> > 
> > On Thu, Jun 23, 2022 at 08:36:49AM +0200, Oleksij Rempel wrote:
> > > Hi Anton,
> > > 
> > > Thank you for your report! I'll take a look on it ASAP.
> > > 
> > > Regards,
> > > Oleksij
> > > 
> > > On Wed, Jun 22, 2022 at 04:16:38PM +0200, Anton Lundin wrote:
> > > > Hi.
> > > > 
> > > > I've found a issue with a Dlink usb ether adapter, that can't receive
> > > > anything until it self transmits if it's plugged in while booting, and
> > > > doesn't have link.
> > > > 
> > > > Later when a cable is attached, link is detected but nothing is received
> > > > either by daemons listening to ip address on that interface, or seen
> > > > with tcpdump.
> > > > 
> > > > The dongle is a:
> > > > D-Link Corp. DUB-E100 Fast Ethernet Adapter(rev.C1) [ASIX AX88772]
> > > > 
> > > > And it's detected at boot as:
> > > > libphy: Asix MDIO Bus: probed
> > > > Asix Electronics AX88772C usb-003:004:10: attached PHY driver (mii_bus:phy_addr=usb-003:004:10, irq=POLL)
> > > > asix 3-10.4:1.0 eth1: register 'asix' at usb-0000:00:14.0-10.4, ASIX AX88772 USB 2.0 Ethernet, <masked-mac>
> > > > usbcore: registered new interface driver asix
> > > > 
> > > > 
> > > > While in this state, the hardware starts sending pause frames to the
> > > > network when it has recived a couple of frames, and they look like:
> > > > 0000   01 80 c2 00 00 01 00 00 00 00 00 00 88 08 00 01
> > > > 0010   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > 0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > 0030   00 00 00 00 00 00 00 00 00 00 00 00
> > > > 
> > > > 0000   01 80 c2 00 00 01 00 00 00 00 00 00 88 08 00 01
> > > > 0010   ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > 0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > 0030   00 00 00 00 00 00 00 00 00 00 00 00
> > > > 
> > > > And these two frames are repeated every couple of seconds.
> > > > 
> > > > The card wakes up when something triggers a transmit on that card, and
> > > > then starts receiving traffic as normal.
> > > > 
> > > > I've bisected this issue down to:
> > > > "net: usb: asix: ax88772: add phylib support" (e532a096be0e)
> > > > 
> > > > 
> > > > Reverting that makes the interface work as normal, even if the machine
> > > > boots without a cable plugged in.
> > > > 
> > > > Another issue found with exactly the same patch is that if it's loaded
> > > > as a module, then unloaded and loaded again, it fails to initialize the
> > > > card with:
> > > > 
> > > > sysfs: cannot create duplicate filename '/devices/virtual/mdio_bus/usb-003:004'
> > > > CPU: 0 PID: 3733 Comm: modprobe Tainted: G           O      5.15.10-core_64_preempt #3
> > > > Hardware name:  <masked-hardware-name>
> > > > Call Trace:
> > > >  <TASK>
> > > >  ? dump_stack_lvl+0x34/0x44
> > > >  ? sysfs_warn_dup.cold+0x17/0x24
> > > >  ? sysfs_create_dir_ns+0xbc/0xd0
> > > >  ? kobject_add_internal+0xa6/0x260
> > > >  ? kobject_add+0x7e/0xb0
> > > >  ? preempt_count_add+0x68/0xa0
> > > >  ? device_add+0x10f/0x8d0
> > > >  ? dev_set_name+0x53/0x70
> > > >  ? __mdiobus_register+0xc2/0x350
> > > >  ? __devm_mdiobus_register+0x64/0xb0
> > > >  ? ax88772_bind+0x22a/0x340 [asix]
> > > >  ? usbnet_probe+0x346/0x870
> > > >  ? usb_match_dynamic_id+0x8f/0xa0
> > > >  ? usb_probe_interface+0x9b/0x150
> > > >  ? really_probe.part.0+0x237/0x280
> > > >  ? __driver_probe_device+0x8c/0xd0
> > > >  ? driver_probe_device+0x1e/0xe0
> > > >  ? __driver_attach+0xa8/0x170
> > > >  ? __device_attach_driver+0xe0/0xe0
> > > >  ? bus_for_each_dev+0x77/0xc0
> > > >  ? bus_add_driver+0x10b/0x1c0
> > > >  ? driver_register+0x8b/0xe0
> > > >  ? usb_register_driver+0x84/0x120
> > > >  ? 0xffffffffc06e4000
> > > >  ? do_one_initcall+0x41/0x1f0
> > > >  ? kmem_cache_alloc_trace+0x3f/0x1b0
> > > >  ? do_init_module+0x5c/0x260
> > > >  ? __do_sys_finit_module+0xa0/0xe0
> > > >  ? do_syscall_64+0x35/0x80
> > > >  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > >  </TASK>
> > > > kobject_add_internal failed for usb-003:004 with -EEXIST, don't try to register things with the same name in the same directory.
> > > > libphy: mii_bus usb-003:004 failed to register
> > > > asix: probe of 3-10.4:1.0 failed with error -22 
> > > > usbcore: registered new interface driver asix
> > > > 
> > > > 
> > > > Both these issues with "net: usb: asix: ax88772: add phylib support"
> > > > (e532a096be0e) can be reproduced all the way from when it was introduced
> > > > to linus current tree.
> > > > 
> > > > 
> > > > I'm sorry to say that I don't know enough about either libphy or asix to
> > > > figure out what cause the issues can be.
> > 
> > It looks like we have here 3 different bugs:
> > - no rx before tx
> >   addresses by this patch:
> >   https://lore.kernel.org/all/20220624075139.3139300-1-o.rempel@pengutronix.de/
> > - pause frames flood without advertising pause frames support
> >   addresses by this patch:
> >   https://lore.kernel.org/all/20220624075139.3139300-2-o.rempel@pengutronix.de/
> > 
> >   Can you please test this patches.
> 
> I've tested these and after these patches I think these two issues are
> fixed.
> 
> If you'd like you can add:
> Tested-by: Anton Lundin <glance@acc.umu.se>

Can you please add your Tested-by directly as response to the patches.
This will reduce some work for maintainers.

> > - not everything is properly cleaned after module unload.
> > 
> > The last one i as bit more complicated. Lukas Wunner spend last months to solve
> > this issues:
> > https://lore.kernel.org/all/d1c87ebe9fc502bffcd1576e238d685ad08321e4.1655987888.git.lukas@wunner.de/
> > 
> 
> Ok, no worries. If it's already known and fixed in later revisions, I'm
> fine with that.

OK,

Thank you for testing.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
