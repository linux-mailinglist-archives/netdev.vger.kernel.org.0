Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25E24D73A2
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 08:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiCMHgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 03:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiCMHgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 03:36:24 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BCE8300E
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 23:35:16 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id a2-20020a056e020e0200b002c6344a01c9so7351471ilk.13
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 23:35:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4Dqq0/WpjlQyZBrDSLqAVmKyOSqEUWgYv7yZtITMZJk=;
        b=K4YZ/aNSQ0pE7/sICKy/W9jzlAR3e0NLdKg79UslWsUjGVEnTpfBFbthpTg6cR5huY
         VxS84fJON98q7tid56MjqTU8/73RQGSthO3oruNAdtH43qXpDzAju1/lSwZfmAFf0EaI
         KoU1Itw6FocNtDICd65m1xXJoE5/pGMuGFPP8kJjJkFY6oUv0Axs2oLz6k1OqHOeNcLW
         XJLlVXTUPnmS+Au9l1m5G7d/5iqrA11F4UFqplh6M/StfwisVyls+oChtp6ywP8hYDPM
         YDd6y4fbbab4g07x5/0w2GDItFA1oTkHJnNkLYTD7a6etc8foyunSLOlVyjW8ILLk4pe
         O0yA==
X-Gm-Message-State: AOAM530kZRtcWDZTddy5aw1LkV61P4CejBpXDLjJr2Xtlcn4JOWdFUqz
        V1FCmKwoCQp+oXGBtjLrJe3yAhJ7UuwvW2FOkDIpUSAj/NdL
X-Google-Smtp-Source: ABdhPJxcjIzZ8oheB+VnXeJwhlI7M+OrxqC2lMUii6fgoNO7yrJLUKm+s4UBGV+1g2U7U1gTXp/w1l15k1hu9YwLjaBjyou+NCxS
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164f:b0:2c6:1b85:b985 with SMTP id
 v15-20020a056e02164f00b002c61b85b985mr15358280ilu.4.1647156915691; Sat, 12
 Mar 2022 23:35:15 -0800 (PST)
Date:   Sat, 12 Mar 2022 23:35:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9660d05da149ac1@google.com>
Subject: [syzbot] KMSAN: uninit-value in asix_mdio_read (3)
From:   syzbot <syzbot+9ed16c369e0f40e366b2@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    724946410067 x86: kmsan: enable KMSAN builds for x86
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=158dd1f6700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28718f555f258365
dashboard link: https://syzkaller.appspot.com/bug?extid=9ed16c369e0f40e366b2
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b31281700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e8c4ee700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9ed16c369e0f40e366b2@syzkaller.appspotmail.com

asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
=====================================================
BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:84 [inline]
BUG: KMSAN: uninit-value in asix_mdio_read+0x537/0xa40 drivers/net/usb/asix_common.c:499
 asix_check_host_enable drivers/net/usb/asix_common.c:84 [inline]
 asix_mdio_read+0x537/0xa40 drivers/net/usb/asix_common.c:499
 asix_mdio_bus_read+0xba/0xe0 drivers/net/usb/asix_common.c:558
 __mdiobus_read+0xbf/0x4f0 drivers/net/phy/mdio_bus.c:762
 mdiobus_read+0xaa/0xf0 drivers/net/phy/mdio_bus.c:869
 get_phy_c22_id drivers/net/phy/phy_device.c:813 [inline]
 get_phy_device+0x218/0x8b0 drivers/net/phy/phy_device.c:890
 mdiobus_scan+0x1c7/0x940
 __mdiobus_register+0xe6c/0x11a0 drivers/net/phy/mdio_bus.c:589
 __devm_mdiobus_register+0x18f/0x2f0 drivers/net/phy/mdio_devres.c:87
 ax88772_init_mdio drivers/net/usb/asix_devices.c:676 [inline]
 ax88772_bind+0x10b1/0x1770 drivers/net/usb/asix_devices.c:786
 usbnet_probe+0x1251/0x4160 drivers/net/usb/usbnet.c:1747
 usb_probe_interface+0xf19/0x1600 drivers/usb/core/driver.c:396
 really_probe+0x653/0x14b0 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:752
 driver_probe_device drivers/base/dd.c:782 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:899
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:970
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1017
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1fff/0x26e0 drivers/base/core.c:3405
 usb_set_configuration+0x37e9/0x3ed0 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x13c/0x300 drivers/usb/core/generic.c:238
 usb_probe_device+0x309/0x570 drivers/usb/core/driver.c:293
 really_probe+0x653/0x14b0 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:752
 driver_probe_device drivers/base/dd.c:782 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:899
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:970
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1017
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1fff/0x26e0 drivers/base/core.c:3405
 usb_new_device+0x1b8e/0x2950 drivers/usb/core/hub.c:2566
 hub_port_connect drivers/usb/core/hub.c:5358 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5502 [inline]
 port_event drivers/usb/core/hub.c:5660 [inline]
 hub_event+0x58e3/0x89e0 drivers/usb/core/hub.c:5742
 process_one_work+0xdb6/0x1820 kernel/workqueue.c:2307
 worker_thread+0x10b3/0x21e0 kernel/workqueue.c:2454
 kthread+0x3c7/0x500 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

Local variable smsr.i created at:
 asix_mdio_read+0xaf/0xa40 drivers/net/usb/asix_common.c:499
 asix_mdio_bus_read+0xba/0xe0 drivers/net/usb/asix_common.c:558

CPU: 0 PID: 7 Comm: kworker/0:1 Not tainted 5.17.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
