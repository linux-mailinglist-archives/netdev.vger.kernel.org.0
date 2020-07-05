Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A74D214BA4
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 11:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgGEJwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 05:52:14 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:36543 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgGEJwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 05:52:14 -0400
Received: by mail-il1-f197.google.com with SMTP id l11so25582398ilc.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 02:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0claRtCrm0axoqAPyUKkATGZT88GntWEWTF7k/OLN+4=;
        b=HWAogsI51xTIAovP/80D5+DsDgJH+6yS0dfe4b/hKXP9mqND2biaxJwN/zufWXY6MQ
         tsJJN2osJck5ZrQSVRI4FNs3SA4N8Z5czwyuV77MBg8H/ES9y8k/Lvy8QFVLAOxPGdV9
         ZXqrTzP0nwJtpXNECKi7ZZ6j903e5mfD53Yg9cMc71JnRLeoSUyECfmy4McPORA091G/
         CPAEfJwekuPYhxI12pg/zIs8bmdYA8VtKX8r8x6DukYFNRqi5Q9uXJa09mgGCgixAIDI
         ZvzAnEiQ8gKRJavTsIvu9N/qIZSMA8PDHilBpTJl4TLFrhHLA+CYnuNbCGNKGp0P2OdO
         ATVQ==
X-Gm-Message-State: AOAM531c0c2QDpWuStGFMzFgX90N+GKlgHt+sbpfQlXhw5DiN5sZBG/8
        J7pTAILmHXrrf5iN0hzZPt+WY9penBuH7HQZLQ1qmxaN92sp
X-Google-Smtp-Source: ABdhPJzoWjT0p/GcTKtpZy98ijeOKxUtLaRgFZ8serTUevZpcUdDlmY5v35hteXSCBooqx1soYvLhbmNIz+0PzgJUzGmMna9zQWL
MIME-Version: 1.0
X-Received: by 2002:a5d:9590:: with SMTP id a16mr4780500ioo.150.1593942733541;
 Sun, 05 Jul 2020 02:52:13 -0700 (PDT)
Date:   Sun, 05 Jul 2020 02:52:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006cd5e905a9aeb60e@google.com>
Subject: memory leak in qdisc_create_dflt
From:   syzbot <syzbot+d411cff6ab29cc2c311b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9ebcfadb Linux 5.8-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1577525b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ee23b9caef4e07a
dashboard link: https://syzkaller.appspot.com/bug?extid=d411cff6ab29cc2c311b
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e579e3100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1007c45b100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d411cff6ab29cc2c311b@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888115aa8c00 (size 512):
  comm "syz-executor530", pid 6646, jiffies 4294943517 (age 13.870s)
  hex dump (first 32 bytes):
    a0 0c be 82 ff ff ff ff f0 0b be 82 ff ff ff ff  ................
    04 00 00 00 e8 03 00 00 40 c6 72 84 ff ff ff ff  ........@.r.....
  backtrace:
    [<00000000ead56edd>] kmalloc_node include/linux/slab.h:578 [inline]
    [<00000000ead56edd>] kzalloc_node include/linux/slab.h:680 [inline]
    [<00000000ead56edd>] qdisc_alloc+0x45/0x260 net/sched/sch_generic.c:818
    [<000000002852d256>] qdisc_create_dflt+0x3d/0x170 net/sched/sch_generic.c:893
    [<000000002108f663>] atm_tc_init+0x96/0x150 net/sched/sch_atm.c:551
    [<000000000988e5f0>] qdisc_create+0x1ae/0x670 net/sched/sch_api.c:1246
    [<00000000c8befd49>] tc_modify_qdisc+0x198/0xb10 net/sched/sch_api.c:1662
    [<00000000b014fe08>] rtnetlink_rcv_msg+0x17e/0x460 net/core/rtnetlink.c:5460
    [<00000000da7a0de1>] netlink_rcv_skb+0x5b/0x180 net/netlink/af_netlink.c:2469
    [<0000000069fa5fbe>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<0000000069fa5fbe>] netlink_unicast+0x2b6/0x3c0 net/netlink/af_netlink.c:1329
    [<0000000049c303c5>] netlink_sendmsg+0x2ba/0x570 net/netlink/af_netlink.c:1918
    [<0000000017755dda>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<0000000017755dda>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<00000000294b696a>] ____sys_sendmsg+0x118/0x2f0 net/socket.c:2352
    [<00000000eb7a1f59>] ___sys_sendmsg+0x81/0xc0 net/socket.c:2406
    [<00000000ba1066c9>] __sys_sendmmsg+0xda/0x230 net/socket.c:2496
    [<0000000082fdecc3>] __do_sys_sendmmsg net/socket.c:2525 [inline]
    [<0000000082fdecc3>] __se_sys_sendmmsg net/socket.c:2522 [inline]
    [<0000000082fdecc3>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2522
    [<000000009da3552a>] do_syscall_64+0x4c/0xe0 arch/x86/entry/common.c:359
    [<00000000b46d0fac>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888115aa8a00 (size 512):
  comm "syz-executor530", pid 6647, jiffies 4294944100 (age 8.040s)
  hex dump (first 32 bytes):
    a0 0c be 82 ff ff ff ff f0 0b be 82 ff ff ff ff  ................
    04 00 00 00 e8 03 00 00 40 c6 72 84 ff ff ff ff  ........@.r.....
  backtrace:
    [<00000000ead56edd>] kmalloc_node include/linux/slab.h:578 [inline]
    [<00000000ead56edd>] kzalloc_node include/linux/slab.h:680 [inline]
    [<00000000ead56edd>] qdisc_alloc+0x45/0x260 net/sched/sch_generic.c:818
    [<000000002852d256>] qdisc_create_dflt+0x3d/0x170 net/sched/sch_generic.c:893
    [<000000002108f663>] atm_tc_init+0x96/0x150 net/sched/sch_atm.c:551
    [<000000000988e5f0>] qdisc_create+0x1ae/0x670 net/sched/sch_api.c:1246
    [<00000000c8befd49>] tc_modify_qdisc+0x198/0xb10 net/sched/sch_api.c:1662
    [<00000000b014fe08>] rtnetlink_rcv_msg+0x17e/0x460 net/core/rtnetlink.c:5460
    [<00000000da7a0de1>] netlink_rcv_skb+0x5b/0x180 net/netlink/af_netlink.c:2469
    [<0000000069fa5fbe>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<0000000069fa5fbe>] netlink_unicast+0x2b6/0x3c0 net/netlink/af_netlink.c:1329
    [<0000000049c303c5>] netlink_sendmsg+0x2ba/0x570 net/netlink/af_netlink.c:1918
    [<0000000017755dda>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<0000000017755dda>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<00000000294b696a>] ____sys_sendmsg+0x118/0x2f0 net/socket.c:2352
    [<00000000eb7a1f59>] ___sys_sendmsg+0x81/0xc0 net/socket.c:2406
    [<00000000ba1066c9>] __sys_sendmmsg+0xda/0x230 net/socket.c:2496
    [<0000000082fdecc3>] __do_sys_sendmmsg net/socket.c:2525 [inline]
    [<0000000082fdecc3>] __se_sys_sendmmsg net/socket.c:2522 [inline]
    [<0000000082fdecc3>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2522
    [<000000009da3552a>] do_syscall_64+0x4c/0xe0 arch/x86/entry/common.c:359
    [<00000000b46d0fac>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
