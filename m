Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E593B0B5C
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhFVR0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:26:41 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:54099 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhFVR0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:26:41 -0400
Received: by mail-il1-f198.google.com with SMTP id q4-20020a056e0220e4b02901edfa664940so13306619ilv.20
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TWUiO1YZGpvaS76ZHhe+JSwwIrerDvGwOdhWfmTH2VY=;
        b=BAeN48axBwlihlIIQWo2DJobCsunYMwzFoHRwh7xQTE4pTB4KurmdwLqPD6veGNoJC
         sKBsFX6K+rLoDDswjnDbmpJnVvze3vCV7iKArslnLT+pbXc6G4ZNOniZJT0Bwgyy8w/9
         QPNHUI18xml8ssYOrPH0k2Wry816fzglzOk3RErzIhlrDujcRusRI6+KxrWEkKLenrgT
         ykIrAXeGuh9b6y/zQCdo0fYL4YsamPzabd9Fnd1jG6moS2FCysyyXqEVCjUSVnQwXd8/
         o+Yvu5O6QAVBQRl3nVEDhYRv/RktGz/6h9QKgybzIVwh5qx/kof2b2N/VN+RJ6mgTsJs
         edaQ==
X-Gm-Message-State: AOAM530e5dJgUpQx+br4ESNDRzEmx2Erf3BdyvfREUO9wUupoxmoBrxU
        zUn5E796b693HNsVHaItxi4RIMljjsyZIqIRgtnOTYtmkdVJ
X-Google-Smtp-Source: ABdhPJwFf6BqLXzzPmMy2MUlHAhXeH9dt1YUXkmsVOD/qRbLygvTTvI14qNET7Y6ajo8lVrNpxZbJMQ71IVqr8dzTzuf9N1hKGoW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20e4:: with SMTP id q4mr3175014ilv.50.1624382664849;
 Tue, 22 Jun 2021 10:24:24 -0700 (PDT)
Date:   Tue, 22 Jun 2021 10:24:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b7bee505c55e0f20@google.com>
Subject: [syzbot] memory leak in j1939_xtp_rx_rts
From:   syzbot <syzbot+d56eaa979f1a3d6e2e2e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fd0aa1a4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=155c8d10300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6ec2526c74098317
dashboard link: https://syzkaller.appspot.com/bug?extid=d56eaa979f1a3d6e2e2e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110912a4300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d56eaa979f1a3d6e2e2e@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888126b3d500 (size 232):
  comm "softirq", pid 0, jiffies 4294974634 (age 13.120s)
  hex dump (first 32 bytes):
    68 16 14 26 81 88 ff ff 68 16 14 26 81 88 ff ff  h..&....h..&....
    00 80 5d 22 81 88 ff ff 00 00 00 00 00 00 00 00  ..]"............
  backtrace:
    [<ffffffff836a0d5f>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:413
    [<ffffffff83c599e1>] alloc_skb include/linux/skbuff.h:1107 [inline]
    [<ffffffff83c599e1>] j1939_session_fresh_new net/can/j1939/transport.c:1484 [inline]
    [<ffffffff83c599e1>] j1939_xtp_rx_rts_session_new net/can/j1939/transport.c:1578 [inline]
    [<ffffffff83c599e1>] j1939_xtp_rx_rts+0x451/0xac0 net/can/j1939/transport.c:1679
    [<ffffffff83c5a7eb>] j1939_tp_cmd_recv net/can/j1939/transport.c:1986 [inline]
    [<ffffffff83c5a7eb>] j1939_tp_recv+0x44b/0x640 net/can/j1939/transport.c:2067
    [<ffffffff83c515dc>] j1939_can_recv+0x2bc/0x420 net/can/j1939/main.c:101
    [<ffffffff83c43d98>] deliver net/can/af_can.c:574 [inline]
    [<ffffffff83c43d98>] can_rcv_filter+0xd8/0x290 net/can/af_can.c:608
    [<ffffffff83c44360>] can_receive+0xf0/0x140 net/can/af_can.c:665
    [<ffffffff83c4442d>] can_rcv+0x7d/0xf0 net/can/af_can.c:696
    [<ffffffff836d2e1a>] __netif_receive_skb_one_core+0x6a/0xa0 net/core/dev.c:5459
    [<ffffffff836d2ea7>] __netif_receive_skb+0x27/0xa0 net/core/dev.c:5573
    [<ffffffff836d3234>] process_backlog+0xb4/0x1a0 net/core/dev.c:6437
    [<ffffffff836d54fd>] __napi_poll+0x3d/0x2a0 net/core/dev.c:6985
    [<ffffffff836d5cea>] napi_poll net/core/dev.c:7052 [inline]
    [<ffffffff836d5cea>] net_rx_action+0x32a/0x410 net/core/dev.c:7139
    [<ffffffff846000bf>] __do_softirq+0xbf/0x2ab kernel/softirq.c:559
    [<ffffffff81238a0c>] do_softirq kernel/softirq.c:460 [inline]
    [<ffffffff81238a0c>] do_softirq+0x5c/0x80 kernel/softirq.c:447
    [<ffffffff81238a81>] __local_bh_enable_ip+0x51/0x60 kernel/softirq.c:384
    [<ffffffff840bf0cd>] spin_unlock_bh include/linux/spinlock.h:399 [inline]
    [<ffffffff840bf0cd>] batadv_nc_purge_paths+0x19d/0x1f0 net/batman-adv/network-coding.c:467

BUG: memory leak
unreferenced object 0xffff888126141600 (size 512):
  comm "softirq", pid 0, jiffies 4294974634 (age 13.120s)
  hex dump (first 32 bytes):
    00 e0 9f 2a 81 88 ff ff 08 16 14 26 81 88 ff ff  ...*.......&....
    08 16 14 26 81 88 ff ff 18 16 14 26 81 88 ff ff  ...&.......&....
  backtrace:
    [<ffffffff83c552eb>] kmalloc include/linux/slab.h:556 [inline]
    [<ffffffff83c552eb>] kzalloc include/linux/slab.h:686 [inline]
    [<ffffffff83c552eb>] j1939_session_new+0x5b/0x160 net/can/j1939/transport.c:1443
    [<ffffffff83c59a78>] j1939_session_fresh_new net/can/j1939/transport.c:1495 [inline]
    [<ffffffff83c59a78>] j1939_xtp_rx_rts_session_new net/can/j1939/transport.c:1578 [inline]
    [<ffffffff83c59a78>] j1939_xtp_rx_rts+0x4e8/0xac0 net/can/j1939/transport.c:1679
    [<ffffffff83c5a7eb>] j1939_tp_cmd_recv net/can/j1939/transport.c:1986 [inline]
    [<ffffffff83c5a7eb>] j1939_tp_recv+0x44b/0x640 net/can/j1939/transport.c:2067
    [<ffffffff83c515dc>] j1939_can_recv+0x2bc/0x420 net/can/j1939/main.c:101
    [<ffffffff83c43d98>] deliver net/can/af_can.c:574 [inline]
    [<ffffffff83c43d98>] can_rcv_filter+0xd8/0x290 net/can/af_can.c:608
    [<ffffffff83c44360>] can_receive+0xf0/0x140 net/can/af_can.c:665
    [<ffffffff83c4442d>] can_rcv+0x7d/0xf0 net/can/af_can.c:696
    [<ffffffff836d2e1a>] __netif_receive_skb_one_core+0x6a/0xa0 net/core/dev.c:5459
    [<ffffffff836d2ea7>] __netif_receive_skb+0x27/0xa0 net/core/dev.c:5573
    [<ffffffff836d3234>] process_backlog+0xb4/0x1a0 net/core/dev.c:6437
    [<ffffffff836d54fd>] __napi_poll+0x3d/0x2a0 net/core/dev.c:6985
    [<ffffffff836d5cea>] napi_poll net/core/dev.c:7052 [inline]
    [<ffffffff836d5cea>] net_rx_action+0x32a/0x410 net/core/dev.c:7139
    [<ffffffff846000bf>] __do_softirq+0xbf/0x2ab kernel/softirq.c:559
    [<ffffffff81238a0c>] do_softirq kernel/softirq.c:460 [inline]
    [<ffffffff81238a0c>] do_softirq+0x5c/0x80 kernel/softirq.c:447
    [<ffffffff81238a81>] __local_bh_enable_ip+0x51/0x60 kernel/softirq.c:384
    [<ffffffff840bf0cd>] spin_unlock_bh include/linux/spinlock.h:399 [inline]
    [<ffffffff840bf0cd>] batadv_nc_purge_paths+0x19d/0x1f0 net/batman-adv/network-coding.c:467

BUG: memory leak
unreferenced object 0xffff888126b3d300 (size 232):
  comm "softirq", pid 0, jiffies 4294974634 (age 13.120s)
  hex dump (first 32 bytes):
    68 08 05 27 81 88 ff ff 68 08 05 27 81 88 ff ff  h..'....h..'....
    00 00 0b 22 81 88 ff ff 00 00 00 00 00 00 00 00  ..."............
  backtrace:
    [<ffffffff836a0d5f>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:413
    [<ffffffff83c599e1>] alloc_skb include/linux/skbuff.h:1107 [inline]
    [<ffffffff83c599e1>] j1939_session_fresh_new net/can/j1939/transport.c:1484 [inline]
    [<ffffffff83c599e1>] j1939_xtp_rx_rts_session_new net/can/j1939/transport.c:1578 [inline]
    [<ffffffff83c599e1>] j1939_xtp_rx_rts+0x451/0xac0 net/can/j1939/transport.c:1679
    [<ffffffff83c5a7eb>] j1939_tp_cmd_recv net/can/j1939/transport.c:1986 [inline]
    [<ffffffff83c5a7eb>] j1939_tp_recv+0x44b/0x640 net/can/j1939/transport.c:2067
    [<ffffffff83c515dc>] j1939_can_recv+0x2bc/0x420 net/can/j1939/main.c:101
    [<ffffffff83c43d98>] deliver net/can/af_can.c:574 [inline]
    [<ffffffff83c43d98>] can_rcv_filter+0xd8/0x290 net/can/af_can.c:608
    [<ffffffff83c44360>] can_receive+0xf0/0x140 net/can/af_can.c:665
    [<ffffffff83c4442d>] can_rcv+0x7d/0xf0 net/can/af_can.c:696
    [<ffffffff836d2e1a>] __netif_receive_skb_one_core+0x6a/0xa0 net/core/dev.c:5459
    [<ffffffff836d2ea7>] __netif_receive_skb+0x27/0xa0 net/core/dev.c:5573
    [<ffffffff836d3234>] process_backlog+0xb4/0x1a0 net/core/dev.c:6437
    [<ffffffff836d54fd>] __napi_poll+0x3d/0x2a0 net/core/dev.c:6985
    [<ffffffff836d5cea>] napi_poll net/core/dev.c:7052 [inline]
    [<ffffffff836d5cea>] net_rx_action+0x32a/0x410 net/core/dev.c:7139
    [<ffffffff846000bf>] __do_softirq+0xbf/0x2ab kernel/softirq.c:559
    [<ffffffff81238a0c>] do_softirq kernel/softirq.c:460 [inline]
    [<ffffffff81238a0c>] do_softirq+0x5c/0x80 kernel/softirq.c:447
    [<ffffffff81238a81>] __local_bh_enable_ip+0x51/0x60 kernel/softirq.c:384
    [<ffffffff840bf0cd>] spin_unlock_bh include/linux/spinlock.h:399 [inline]
    [<ffffffff840bf0cd>] batadv_nc_purge_paths+0x19d/0x1f0 net/batman-adv/network-coding.c:467



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
