Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BAE554CD6
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358003AbiFVOYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358393AbiFVOXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:23:30 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Jun 2022 07:23:25 PDT
Received: from mail.acc.umu.se (mail.acc.umu.se [130.239.18.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5CA39B96
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:23:25 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by amavisd-new (Postfix) with ESMTP id 3C4AC44B96;
        Wed, 22 Jun 2022 16:16:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=acc.umu.se; s=mail1;
        t=1655907399; bh=pouzNMFsSYJ4l7Zs9Xkl7ctIrZw/mpAZA+tAWdu6N5A=;
        h=Date:From:To:Cc:Subject:From;
        b=y4YDEBIF6tTr39cOw7TKoZnO5+eFzR6CXtYYZVQhSq+XZ3133pD+/96jTBKgz0YEZ
         tkK7Xbw2x/mrIzQua3SvIKqggJvs0qyOWHfeIW/bpFYIJxgzDo2Ko8lTCqtGAfDqHb
         4+M2bBUCriOx4j7mD7VE437UuDK2fJODic/g9zLRdtysfDW0TDbgflBkmceFPqWHXR
         ArywsQJn11srbVqC0JnL1VnLEtGkNrFYxXSntdNccD+Vqq8Mh+9RySLUN0kSl9fsEN
         A34Es53V8cOEagkdlGdhK5SYK0sHbEnvYF70oquhLF7z2CdB/jZqVKEN5HXCkaKL0T
         O3NqqnwjcDcfg==
Received: by mail.acc.umu.se (Postfix, from userid 24471)
        id CD76B44B97; Wed, 22 Jun 2022 16:16:38 +0200 (CEST)
Date:   Wed, 22 Jun 2022 16:16:38 +0200
From:   Anton Lundin <glance@acc.umu.se>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [REGRESSION] AX88772 card booted without cable can't receive
Message-ID: <20220622141638.GE930160@montezuma.acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

I've found a issue with a Dlink usb ether adapter, that can't receive
anything until it self transmits if it's plugged in while booting, and
doesn't have link.

Later when a cable is attached, link is detected but nothing is received
either by daemons listening to ip address on that interface, or seen
with tcpdump.

The dongle is a:
D-Link Corp. DUB-E100 Fast Ethernet Adapter(rev.C1) [ASIX AX88772]

And it's detected at boot as:
libphy: Asix MDIO Bus: probed
Asix Electronics AX88772C usb-003:004:10: attached PHY driver (mii_bus:phy_addr=usb-003:004:10, irq=POLL)
asix 3-10.4:1.0 eth1: register 'asix' at usb-0000:00:14.0-10.4, ASIX AX88772 USB 2.0 Ethernet, <masked-mac>
usbcore: registered new interface driver asix


While in this state, the hardware starts sending pause frames to the
network when it has recived a couple of frames, and they look like:
0000   01 80 c2 00 00 01 00 00 00 00 00 00 88 08 00 01
0010   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0030   00 00 00 00 00 00 00 00 00 00 00 00

0000   01 80 c2 00 00 01 00 00 00 00 00 00 88 08 00 01
0010   ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0030   00 00 00 00 00 00 00 00 00 00 00 00

And these two frames are repeated every couple of seconds.

The card wakes up when something triggers a transmit on that card, and
then starts receiving traffic as normal.

I've bisected this issue down to:
"net: usb: asix: ax88772: add phylib support" (e532a096be0e)


Reverting that makes the interface work as normal, even if the machine
boots without a cable plugged in.

Another issue found with exactly the same patch is that if it's loaded
as a module, then unloaded and loaded again, it fails to initialize the
card with:

sysfs: cannot create duplicate filename '/devices/virtual/mdio_bus/usb-003:004'
CPU: 0 PID: 3733 Comm: modprobe Tainted: G           O      5.15.10-core_64_preempt #3
Hardware name:  <masked-hardware-name>
Call Trace:
 <TASK>
 ? dump_stack_lvl+0x34/0x44
 ? sysfs_warn_dup.cold+0x17/0x24
 ? sysfs_create_dir_ns+0xbc/0xd0
 ? kobject_add_internal+0xa6/0x260
 ? kobject_add+0x7e/0xb0
 ? preempt_count_add+0x68/0xa0
 ? device_add+0x10f/0x8d0
 ? dev_set_name+0x53/0x70
 ? __mdiobus_register+0xc2/0x350
 ? __devm_mdiobus_register+0x64/0xb0
 ? ax88772_bind+0x22a/0x340 [asix]
 ? usbnet_probe+0x346/0x870
 ? usb_match_dynamic_id+0x8f/0xa0
 ? usb_probe_interface+0x9b/0x150
 ? really_probe.part.0+0x237/0x280
 ? __driver_probe_device+0x8c/0xd0
 ? driver_probe_device+0x1e/0xe0
 ? __driver_attach+0xa8/0x170
 ? __device_attach_driver+0xe0/0xe0
 ? bus_for_each_dev+0x77/0xc0
 ? bus_add_driver+0x10b/0x1c0
 ? driver_register+0x8b/0xe0
 ? usb_register_driver+0x84/0x120
 ? 0xffffffffc06e4000
 ? do_one_initcall+0x41/0x1f0
 ? kmem_cache_alloc_trace+0x3f/0x1b0
 ? do_init_module+0x5c/0x260
 ? __do_sys_finit_module+0xa0/0xe0
 ? do_syscall_64+0x35/0x80
 ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 </TASK>
kobject_add_internal failed for usb-003:004 with -EEXIST, don't try to register things with the same name in the same directory.
libphy: mii_bus usb-003:004 failed to register
asix: probe of 3-10.4:1.0 failed with error -22 
usbcore: registered new interface driver asix


Both these issues with "net: usb: asix: ax88772: add phylib support"
(e532a096be0e) can be reproduced all the way from when it was introduced
to linus current tree.


I'm sorry to say that I don't know enough about either libphy or asix to
figure out what cause the issues can be.



//Anton
