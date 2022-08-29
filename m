Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1725A57A5
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 01:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiH2Xdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 19:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiH2Xde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 19:33:34 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0796082D24
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 16:33:33 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id i1-20020a056e0212c100b002e9fda30fbdso6943189ilm.2
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 16:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=pQsvM0lNlMEBpkZs+6Ir9JLbqpOTi5k2pYARw9hKdac=;
        b=U4hA3cMQZAGjC12t9b9BFzcUTfNlsLNrCMYYR6BYuwv4I88ISYe0qGQ/TvsitvOLZT
         VO3MA1EzBl4wf+CaV7W+1jx8MH0j4j49u3j6nDEEUg3dNX6onK1UtX2cmtXfOFVorEcX
         QZmIBvw+u6Iox6YmNSHeQB+IsxjMCg7mYcArPasHfp35BpZ9lEE7bH5YrAAv6rm39R5S
         ernTcd/nBxsvH1bJStP8gKorxl0SDJXKtG7rnG0wkoAHItWcThx9S6YfBGpmgtQ9euqz
         bgY8l6xfty2baI8QycLQq6EA38+RvJAHqh2YKoco8XKvfIrV7U9CeIf19jUq/LgkCdBF
         Hj0Q==
X-Gm-Message-State: ACgBeo1CpZaqIOBrf2ZA/FFv6UEr2jzYsBUaOtuDJaUvNdJOy8Gw03/7
        vhcLcfZ2phAYU4+QjCEPxORbW2/8OZGVpK+s4sNkvLqLeJ/5
X-Google-Smtp-Source: AA6agR5C6Qga/30TVGHv4ICPLSc92WhV+sBpWb2mo+IP20l01OrArs+sJYQqXxJXN4xomqaZsq9enJTHDKmB7j3DDMS+mDXr00nb
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3804:b0:349:881b:a4bc with SMTP id
 i4-20020a056638380400b00349881ba4bcmr10689708jav.313.1661816012409; Mon, 29
 Aug 2022 16:33:32 -0700 (PDT)
Date:   Mon, 29 Aug 2022 16:33:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001a12f105e769b1eb@google.com>
Subject: [syzbot] memory leak in nft_chain_parse_hook
From:   syzbot <syzbot+5fcdbfab6d6744c57418@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
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

HEAD commit:    4c612826bec1 Merge tag 'net-6.0-rc3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13db4765080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1831d905b683446
dashboard link: https://syzkaller.appspot.com/bug?extid=5fcdbfab6d6744c57418
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1263c283080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111b6545080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5fcdbfab6d6744c57418@syzkaller.appspotmail.com

executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810180b100 (size 96):
  comm "syz-executor133", pid 3619, jiffies 4294945714 (age 12.690s)
  hex dump (first 32 bytes):
    28 64 23 02 81 88 ff ff 28 64 23 02 81 88 ff ff  (d#.....(d#.....
    90 a8 aa 83 ff ff ff ff 00 00 b5 0f 81 88 ff ff  ................
  backtrace:
    [<ffffffff83a8c59b>] kmalloc include/linux/slab.h:600 [inline]
    [<ffffffff83a8c59b>] nft_netdev_hook_alloc+0x3b/0xc0 net/netfilter/nf_tables_api.c:1901
    [<ffffffff83a9239a>] nft_chain_parse_netdev net/netfilter/nf_tables_api.c:1998 [inline]
    [<ffffffff83a9239a>] nft_chain_parse_hook+0x33a/0x530 net/netfilter/nf_tables_api.c:2073
    [<ffffffff83a9b14b>] nf_tables_addchain.constprop.0+0x10b/0x950 net/netfilter/nf_tables_api.c:2218
    [<ffffffff83a9c41b>] nf_tables_newchain+0xa8b/0xc60 net/netfilter/nf_tables_api.c:2593
    [<ffffffff83a3d6a6>] nfnetlink_rcv_batch+0xa46/0xd20 net/netfilter/nfnetlink.c:517
    [<ffffffff83a3db79>] nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:638 [inline]
    [<ffffffff83a3db79>] nfnetlink_rcv+0x1f9/0x220 net/netfilter/nfnetlink.c:656
    [<ffffffff83a13b17>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff83a13b17>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff83a13fd6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff83865ab6>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff83865ab6>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff8386601c>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2482
    [<ffffffff8386a918>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff8386aaa8>] __sys_sendmsg+0x88/0x100 net/socket.c:2565
    [<ffffffff845e5955>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845e5955>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
