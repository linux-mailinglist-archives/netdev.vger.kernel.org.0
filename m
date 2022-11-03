Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39735618437
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiKCQWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiKCQWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:22:43 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960591B1C8
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 09:22:42 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id z15-20020a5e860f000000b006c09237cc06so1346406ioj.21
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 09:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zF+LnUs7wc8wKYqlZFfZx8ApaFDzlUVEz4r+Sncfplo=;
        b=VxusMT/fWZIIaSfwfMGJupuGWlgfAFbHAqlmj+G1fOvKrBV5nT/+lT7DnLQ3SemcnI
         kmpYxNElO0K3HX41V9fCdEBMe4j82vhwdlFSUEbLNDzOGBAPeRuozQT9lDw9qJ5iyXI2
         vnzWX7HvMU1bSgymdDGgdv3ggrJS82Ct6QbyUZiHlg5cpGaP2SFZDjemqrtngnyrya1T
         H7ajmYYVzyinlnVS/kJxqmBzVl1Nl4cX9AJgCxcPp0ItlVOKXfc6dfJCOewc7pTJzxzI
         I3RYKcdme+M6qD19+gbYCO+UOnDI/HPe0Nw2erF7lUCAkF3UeY3zoGRC5JLz79Xwgek3
         OIVQ==
X-Gm-Message-State: ACrzQf3u8PnsG4+Er8VKE9cl3KCMyyRISrvz/Z14nyisvr8hfNKQg5Zh
        kPOnC/i4x+A0duYGGOaSb3uSV9cAbJHY/wg/H5grI2FhwJab
X-Google-Smtp-Source: AMsMyM6CtiwGH8w+Qk82GrF/KQwXo+GUxBslIeSaAAXIhRIedLc33G0AS41rCcvpZUMEVSr15XVGld2QMOjWFloPRgPdGhYLFtFk
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174b:b0:300:5dbf:5568 with SMTP id
 y11-20020a056e02174b00b003005dbf5568mr18402572ill.214.1667492561976; Thu, 03
 Nov 2022 09:22:41 -0700 (PDT)
Date:   Thu, 03 Nov 2022 09:22:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d285ef05ec935d9e@google.com>
Subject: [syzbot] KMSAN: uninit-value in tipc_nl_compat_name_table_dump (3)
From:   syzbot <syzbot+e5dbaaa238680ce206ea@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
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

HEAD commit:    8f4ae27df775 Revert "Revert "crypto: kmsan: disable accele..
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=142d16cf080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=121c7ef28ec597bd
dashboard link: https://syzkaller.appspot.com/bug?extid=e5dbaaa238680ce206ea
compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176a716f080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140256a0880000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e5dbaaa238680ce206ea@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in tipc_nl_compat_name_table_dump+0x841/0xea0 net/tipc/netlink_compat.c:934
 tipc_nl_compat_name_table_dump+0x841/0xea0 net/tipc/netlink_compat.c:934
 __tipc_nl_compat_dumpit+0xab2/0x1320 net/tipc/netlink_compat.c:238
 tipc_nl_compat_dumpit+0x991/0xb50 net/tipc/netlink_compat.c:321
 tipc_nl_compat_recv+0xb6e/0x1640 net/tipc/netlink_compat.c:1324
 genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x103f/0x1260 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x3a5/0x6c0 net/netlink/af_netlink.c:2501
 genl_rcv+0x3c/0x50 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xabc/0xe90 net/socket.c:2482
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2536
 __sys_sendmsg net/socket.c:2565 [inline]
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2572
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3258 [inline]
 __kmalloc_node_track_caller+0x814/0x1250 mm/slub.c:4970
 kmalloc_reserve net/core/skbuff.c:362 [inline]
 __alloc_skb+0x346/0xcf0 net/core/skbuff.c:434
 alloc_skb include/linux/skbuff.h:1257 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1191 [inline]
 netlink_sendmsg+0xb71/0x1440 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xabc/0xe90 net/socket.c:2482
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2536
 __sys_sendmsg net/socket.c:2565 [inline]
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2572
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 1 PID: 3490 Comm: syz-executor155 Not tainted 6.0.0-rc5-syzkaller-48538-g8f4ae27df775 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
