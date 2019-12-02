Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5765610EDC9
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 18:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfLBRFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 12:05:16 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:41856 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfLBRFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 12:05:13 -0500
Received: by mail-io1-f72.google.com with SMTP id p2so57907ioh.8
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 09:05:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/F3uYH/byikiR4pmME4NQXaB6rRlktnnY/q/Qtr+i/s=;
        b=UiygTgCKHvEfpaNQCyDqpGvtvGzNBlf0DoyjJQL/Q968ZsKAaW2i9zw/uOyNHpMeIS
         dlgypRTtTtkaWPNzsds9p71l9W0HxNkNcejsvKwrxL8dTDVK+1UbTShCND5hNdMMb/wB
         z31PHCQlqrO9I7MyY9emS90pSRWOPfkVZapYg1mo4lBB0XrnkOgEG/XHNtwWjvhEqeHe
         ycouN36JhE54l1kU0FNGzYKCGwv0nN2Y0XwebDo02XrzuMEcSkpcQwLdxF2/hMnJKnTk
         lm0aY6iMK2r/P3Ldj9CMVrOhtgDSUMhigGQXsPnKL8X2+y/3RSFoT0qxtVkrE+q2Axf/
         LmDQ==
X-Gm-Message-State: APjAAAXH7udVZ/E7Qh20ymsPVpyPgcMiRn6mWh+W3NRucyA6g9qF+sol
        eCeFfHA0f0pad23N2sgKS0zcIpyK0phwU2/0tBWIejMnggRF
X-Google-Smtp-Source: APXvYqzH3vRxxo/e5Rnqon9juvNsa0peNh8SNnU9SFGGATkjF0W0EzwyjVm/9zbzPbmVcjQdCrHlvcQtR9q+hG+UgogP+UAoGXjl
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:68a:: with SMTP id o10mr17451276ils.202.1575306311244;
 Mon, 02 Dec 2019 09:05:11 -0800 (PST)
Date:   Mon, 02 Dec 2019 09:05:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001821bf0598bb955c@google.com>
Subject: memory leak in fdb_create (2)
From:   syzbot <syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ceb30747 Merge tag 'y2038-cleanups-5.5' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=142b3e7ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26f873e40f2b4134
dashboard link: https://syzkaller.appspot.com/bug?extid=2add91c08eb181fea1bf
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12976feee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10604feee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888124fa7080 (size 128):
   comm "syz-executor163", pid 7170, jiffies 4294954254 (age 12.500s)
   hex dump (first 32 bytes):
     d1 16 b6 1f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
     aa aa aa aa aa 0c 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000001bbce457>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000001bbce457>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000001bbce457>] slab_alloc mm/slab.c:3319 [inline]
     [<000000001bbce457>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
     [<000000005e78ed69>] fdb_create+0x37/0x530 net/bridge/br_fdb.c:498
     [<000000009cc867aa>] fdb_insert+0xb2/0xf0 net/bridge/br_fdb.c:537
     [<00000000a443c9ff>] br_fdb_change_mac_address+0x80/0x1f0  
net/bridge/br_fdb.c:316
     [<00000000370e41a8>] br_stp_change_bridge_id+0x4c/0x190  
net/bridge/br_stp_if.c:223
     [<00000000db15c550>] br_set_mac_address+0xa2/0xb0  
net/bridge/br_device.c:251
     [<00000000547a827c>] dev_set_mac_address+0xdd/0x150 net/core/dev.c:8350
     [<0000000068a207bd>] __bond_release_one.cold+0x319/0x4ac  
drivers/net/bonding/bond_main.c:2055
     [<00000000189411c7>] bond_slave_netdev_event  
drivers/net/bonding/bond_main.c:3169 [inline]
     [<00000000189411c7>] bond_netdev_event+0x2ac/0x2c0  
drivers/net/bonding/bond_main.c:3280
     [<000000002bd5677b>] notifier_call_chain+0x66/0xb0 kernel/notifier.c:95
     [<0000000044f0058c>] __raw_notifier_call_chain kernel/notifier.c:396  
[inline]
     [<0000000044f0058c>] raw_notifier_call_chain+0x2e/0x40  
kernel/notifier.c:403
     [<000000009782bbd6>] call_netdevice_notifiers_info net/core/dev.c:1893  
[inline]
     [<000000009782bbd6>] call_netdevice_notifiers_info+0x60/0xb0  
net/core/dev.c:1878
     [<000000005904fef6>] call_netdevice_notifiers_extack  
net/core/dev.c:1905 [inline]
     [<000000005904fef6>] call_netdevice_notifiers net/core/dev.c:1919  
[inline]
     [<000000005904fef6>] rollback_registered_many+0x373/0x640  
net/core/dev.c:8743
     [<00000000806944eb>] unregister_netdevice_many.part.0+0x17/0x90  
net/core/dev.c:9906
     [<00000000c0997ee2>] unregister_netdevice_many+0x24/0x30  
net/core/dev.c:9905
     [<0000000042445981>] rtnl_delete_link+0x63/0xa0  
net/core/rtnetlink.c:2926



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
