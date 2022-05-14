Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201F3526EB0
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiENGYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 02:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiENGYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 02:24:30 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5396C25C2
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 23:24:28 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id m205-20020a6b3fd6000000b006586ca958d2so6152609ioa.22
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 23:24:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=A9wNDjXdGRpuh2KPLSQl2FaHhAdF0vre7xDYlmgpQ0s=;
        b=Q0M8jwQLvlhRT/J0TQyQUe+Y1PU4LP33Z7h3ROmlApwr25inzHL8qgY/ygGr9ScQh6
         Bo8OwLGT4PBfRDUOXhvlBb9oGlwO59oSFAzMf3R+ijxE1AZeKpm826warWuCG8L+djOf
         tJOuZ9fd3kWyhz63RrdAMTZeSboT3/vbjm13kp2OnBFJfYTaPtFas3Mzc/wP3cKqkZ2f
         PNZqB61nk/eZMlGWzVvRmuS3tM1fGa2aZXaZrWwR3y+0tJyuvGgGXS6wjBMDVCfNXOE0
         vp2LVD6YCFKYn51sFXmycjATHu10uIreImqk8Jxpr0p2K/9KYGOK6ROZQF1ZFdJRqHKm
         pt2w==
X-Gm-Message-State: AOAM5316hWGQgZ4dZQp9KfwCJnOxwl4xGPbSBTKVv+e1cn1NU/eP4NRy
        NfZZPrHk6CHmY60Ctpz8tfdIcMkhtx8Fh3w+S1ZXTbLACQi+
X-Google-Smtp-Source: ABdhPJwE2FF9dllSoYddXbWPp1Fqh0/9KXiffw/RfZZ4B00tS+llhCe3VPiQFzEfGwGGgXETJ8Tmnab7hPH+8QuLI9zoNtR5/Cpe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a06:b0:2cf:d11d:d419 with SMTP id
 s6-20020a056e021a0600b002cfd11dd419mr4200244ild.309.1652509467675; Fri, 13
 May 2022 23:24:27 -0700 (PDT)
Date:   Fri, 13 May 2022 23:24:27 -0700
In-Reply-To: <00000000000062b6fd057d4b7dc2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf146c05def2d7ab@google.com>
Subject: Re: [syzbot] KMSAN: uninit-value in __tipc_nl_bearer_enable
From:   syzbot <syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, jmaloy@redhat.com,
        jon.maloy@ericsson.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    d6e2c8c7eb40 x86: kmsan: enable KMSAN builds for x86
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=115c49b1f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65d9eb7bfd2865c9
dashboard link: https://syzkaller.appspot.com/bug?extid=e820fdc8ce362f2dea51
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b563faf00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1310ee59f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com

netlink: 20 bytes leftover after parsing attributes in process `syz-executor377'.
=====================================================
BUG: KMSAN: uninit-value in string_nocheck lib/vsprintf.c:644 [inline]
BUG: KMSAN: uninit-value in string+0x4f9/0x6f0 lib/vsprintf.c:725
 string_nocheck lib/vsprintf.c:644 [inline]
 string+0x4f9/0x6f0 lib/vsprintf.c:725
 vsnprintf+0x2222/0x3650 lib/vsprintf.c:2806
 vprintk_store+0x537/0x2150 kernel/printk/printk.c:2158
 vprintk_emit+0x28b/0xab0 kernel/printk/printk.c:2256
 vprintk_default+0x86/0xa0 kernel/printk/printk.c:2283
 vprintk+0x15f/0x180 kernel/printk/printk_safe.c:50
 _printk+0x18d/0x1cf kernel/printk/printk.c:2293
 tipc_enable_bearer net/tipc/bearer.c:371 [inline]
 __tipc_nl_bearer_enable+0x2022/0x22a0 net/tipc/bearer.c:1033
 tipc_nl_bearer_enable+0x6c/0xb0 net/tipc/bearer.c:1042
 genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x157f/0x1660 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x40c/0x7e0 net/netlink/af_netlink.c:2503
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x109c/0x1370 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x14dc/0x1720 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2496
 __do_sys_sendmsg net/socket.c:2505 [inline]
 __se_sys_sendmsg net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0xe2/0x120 net/socket.c:2503
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x51/0xa0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:754 [inline]
 slab_alloc_node mm/slub.c:3231 [inline]
 __kmalloc_node_track_caller+0xde3/0x14f0 mm/slub.c:4962
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1300 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1191 [inline]
 netlink_sendmsg+0xde3/0x1720 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2496
 __do_sys_sendmsg net/socket.c:2505 [inline]
 __se_sys_sendmsg net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0xe2/0x120 net/socket.c:2503
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x51/0xa0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 0 PID: 3475 Comm: syz-executor377 Not tainted 5.18.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================

