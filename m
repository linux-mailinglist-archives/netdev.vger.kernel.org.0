Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFD414AA71
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 20:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgA0T1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 14:27:09 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:45979 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0T1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 14:27:09 -0500
Received: by mail-io1-f70.google.com with SMTP id t12so6781084iog.12
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 11:27:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ht06EFTCAqiZgMddO3KkSOA8HJxQ0XCFgZ86CB8ciyI=;
        b=romqdKdE2WpzVK9sA1aQQObr5P98zppTVeUN2ClbjLoUhzIIJpx+efOLZXy2YpgZWO
         oC0VAQ+v/x6WuaN2Cbi9/h2KDpnQnMHa+YPKNsSd5Q74LHUYRfjjk0OGf74U/ypq5bMn
         5WS0r/OoUD14QJDLg+I3ZogmEPQsJJfyb9PrOeKY42bklFtP3z3Z6Ma7vkHuTVZ8ZSGd
         SPkhq8NXuwPdGLyYBIX228X1yoRjEOZVufhBMP8jXsHWZbAi0FtGPM7KRohcK7h4kD6P
         gUzHidl2AxNpYA+ZIUIumOzGHXw84DghgzFrISGorkCSWlgq+Vfuet78SwghLwW1ZL0g
         RfcA==
X-Gm-Message-State: APjAAAUXxZY6kCHw4e3FA3TJDkQT1D7ZD6UmaPZJY4Bxv4r7OuAwiZpt
        m5KYtOoUaT8sx0RHpblEMrZm+Tqzsg25dO57C7H9/CIgo+OH
X-Google-Smtp-Source: APXvYqyvvyEfcV6G/0Ud00/pVELKfYR0HIbxKlWKGloKVNLcYJDxFp3Pb9UNq7ptNUdNJkeHBpUUQc2UP70WZ5RMBvbCkErRCdFC
MIME-Version: 1.0
X-Received: by 2002:a6b:6e18:: with SMTP id d24mr14110973ioh.301.1580153228897;
 Mon, 27 Jan 2020 11:27:08 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:27:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e63046059d2417e8@google.com>
Subject: memory leak in garp_request_join
From:   syzbot <syzbot+13ad608e190b5f8ad8a8@syzkaller.appspotmail.com>
To:     allison@lohutok.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, info@metux.net,
        kstewart@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d5226fa6 Linux 5.5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=176b440de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=698d5ad38dda6cb6
dashboard link: https://syzkaller.appspot.com/bug?extid=13ad608e190b5f8ad8a8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d86b35e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1043d769e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+13ad608e190b5f8ad8a8@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888114008dc0 (size 64):
  comm "syz-executor967", pid 7318, jiffies 4294943348 (age 13.580s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 08 00 00 00 01 02 00 08  ................
  backtrace:
    [<0000000067139221>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<0000000067139221>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<0000000067139221>] slab_alloc mm/slab.c:3320 [inline]
    [<0000000067139221>] __do_kmalloc mm/slab.c:3654 [inline]
    [<0000000067139221>] __kmalloc+0x169/0x300 mm/slab.c:3665
    [<0000000093813bfa>] kmalloc include/linux/slab.h:561 [inline]
    [<0000000093813bfa>] garp_attr_create net/802/garp.c:187 [inline]
    [<0000000093813bfa>] garp_request_join+0x132/0x1f0 net/802/garp.c:350
    [<0000000078a2be7e>] vlan_gvrp_request_join+0x86/0x90 net/8021q/vlan_gvrp.c:34
    [<0000000092861d25>] vlan_dev_open+0x173/0x290 net/8021q/vlan_dev.c:290
    [<00000000451be632>] __dev_open+0x109/0x1b0 net/core/dev.c:1431
    [<00000000fa297b7f>] __dev_change_flags+0x246/0x2c0 net/core/dev.c:8105
    [<0000000065bc5439>] rtnl_configure_link+0x57/0x100 net/core/rtnetlink.c:2996
    [<000000005ed66308>] __rtnl_newlink+0x8b9/0xb80 net/core/rtnetlink.c:3332
    [<00000000d6be140e>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3372
    [<0000000030786841>] rtnetlink_rcv_msg+0x178/0x4b0 net/core/rtnetlink.c:5433
    [<00000000cb252134>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<000000002c0f0d61>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5451
    [<00000000e09dee2f>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000e09dee2f>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<0000000036f4d1c5>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<0000000064dc927c>] sock_sendmsg_nosec net/socket.c:639 [inline]
    [<0000000064dc927c>] sock_sendmsg+0x54/0x70 net/socket.c:659
    [<00000000cd57f12f>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
