Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815BF62ED1E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 06:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbiKRFSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 00:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbiKRFSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 00:18:46 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EE151300
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 21:18:44 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id j20-20020a056e02219400b00300a22a7fe0so2704219ila.3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 21:18:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iLs1sxjOYBo2QST7SZBpOYOlWZyNAL1AT8/a4qqXn94=;
        b=6IBU2ksxl5B4aImfgzLOR+mJTt3DvsUulEe2Nd1TTGCF/+2GcDNAol4Z8Wga0TZ7xU
         l6dDwmmv+OFPI9lo76ioifuqHRN7eOnFNWtpnNgBKKtNiDSiRxXydaTtf1fHfytsysXe
         DJ1jY7hUmNS8M2RI90BiL4q2kUtPxazc6ZmFa/6k9eJegftk5zzO/2EAZk1c3b8+RAtl
         Wz1JPy88ODmFqGgUAEx2mTYSlN/2TVjkSm5w9dwW6l1tHBCrL2U/s1z5/5sXKtDOEXJg
         wQahts6uHmijKCMMFC1Q/GxVaVmbRzhEhsahnI/DI4EkUiNW+rsG4SWEmPkrx2wFrkfO
         6HNg==
X-Gm-Message-State: ANoB5pnIDXYlAeS9m84MetbK9roltOOcwQawBZq8o3+IkUHL7lbGmdIM
        +Ix72yHxHVxZfnJAyV6NYRwEmPZHG3pLKAq0KmlaAzIBcbRH
X-Google-Smtp-Source: AA0mqf5KekID4vpEbdLvNd9uzzkJO+Lj0mCW4P/N/kiep5eM0wrOY36t0LoxFBQyMxAPI54sDSkYWDuaP/CqSSndZj024ML3Nwta
MIME-Version: 1.0
X-Received: by 2002:a5e:aa06:0:b0:6bc:614c:63c2 with SMTP id
 s6-20020a5eaa06000000b006bc614c63c2mr2774824ioe.21.1668748723984; Thu, 17 Nov
 2022 21:18:43 -0800 (PST)
Date:   Thu, 17 Nov 2022 21:18:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e99e2705edb7d6cf@google.com>
Subject: [syzbot] memory leak in sctp_sched_prio_set
From:   syzbot <syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b2d229d4ddb1 Linux 5.18-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e439b8f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2197cd22d3971cc5
dashboard link: https://syzkaller.appspot.com/bug?extid=29c402e56c4760763cc0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17daf0af700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ae4d5cf00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com

executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810b472a00 (size 64):
  comm "syz-executor206", pid 3601, jiffies 4294944661 (age 12.290s)
  hex dump (first 32 bytes):
    00 2a 47 0b 81 88 ff ff 00 2a 47 0b 81 88 ff ff  .*G......*G.....
    10 2a 47 0b 81 88 ff ff 10 2a 47 0b 81 88 ff ff  .*G......*G.....
  backtrace:
    [<ffffffff83fa1634>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff83fa1634>] sctp_sched_prio_new_head net/sctp/stream_sched_prio.c:33 [inline]
    [<ffffffff83fa1634>] sctp_sched_prio_get_head net/sctp/stream_sched_prio.c:77 [inline]
    [<ffffffff83fa1634>] sctp_sched_prio_set+0x2c4/0x370 net/sctp/stream_sched_prio.c:159
    [<ffffffff83f9b6a6>] sctp_stream_init_ext+0x86/0xf0 net/sctp/stream.c:176
    [<ffffffff83f86e0e>] sctp_sendmsg_to_asoc+0xc8e/0xdb0 net/sctp/socket.c:1807
    [<ffffffff83f8f77f>] sctp_sendmsg+0x99f/0x1030 net/sctp/socket.c:2027
    [<ffffffff83b7a315>] inet_sendmsg+0x45/0x70 net/ipv4/af_inet.c:819
    [<ffffffff837cb3e6>] sock_sendmsg_nosec net/socket.c:705 [inline]
    [<ffffffff837cb3e6>] sock_sendmsg+0x56/0x80 net/socket.c:725
    [<ffffffff837ce38c>] __sys_sendto+0x15c/0x200 net/socket.c:2040
    [<ffffffff837ce456>] __do_sys_sendto net/socket.c:2052 [inline]
    [<ffffffff837ce456>] __se_sys_sendto net/socket.c:2048 [inline]
    [<ffffffff837ce456>] __x64_sys_sendto+0x26/0x30 net/socket.c:2048
    [<ffffffff8451da45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff8451da45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
