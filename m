Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CADC81970
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 14:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfHEMiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 08:38:24 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:55031 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728764AbfHEMiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 08:38:09 -0400
Received: by mail-io1-f71.google.com with SMTP id n8so91949470ioo.21
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 05:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0SlIsA2694wt+MQ5zgGwgDx+HJC9onZmiZCosf0h45g=;
        b=R2Lh8T1+HrkSvX9Tn1Kt1aokj6Hz1mPtN6wmfwZegNtGkH5NM9b3PaErurdOuF58Ph
         SWv14BPEzi8PUlMDu6aW3DKp3HFxOztsMML4CEex6g7As8PP+M5s27u6ES54GpoQqEAk
         4T/e0hwNtEGtASHYD+LFbFIz5YV1uL3QYg+7RRiFRIif3IytqsDpMUqrls7bRPvM9Fxg
         pJP31ytd+2nzsAWhu5Vs5Vki9gsM4fn6gZGu+6BxadoGGn2mC5rxKYD/iGbBZ8I7AsFU
         TeSdtP93K23CbcJLl1kuiFq1xxq24uCCV/cq/kq1kQX5aLiQa6qbarpEfrpTv2R4zLF9
         DNOQ==
X-Gm-Message-State: APjAAAVByqURsfgsZ7UxZrcC8/ub2iD2fp3zl1xd1evJhR51YP9SWy5Q
        E8XprlUwjJB6HPJOiCTgv3PbJl/kbpkea65QwuquK7NQXYnL
X-Google-Smtp-Source: APXvYqyl33KSmOqc0D/gaCB1vcetR2LjFAP3VYVdy4LJX4399FDTlJi85XLUKNOx6HsJaQg1toX7SXFnsmn8hwqbMaIt4hdcR0vj
MIME-Version: 1.0
X-Received: by 2002:a6b:5a17:: with SMTP id o23mr32421740iob.41.1565008688166;
 Mon, 05 Aug 2019 05:38:08 -0700 (PDT)
Date:   Mon, 05 Aug 2019 05:38:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000edc1d5058f5dfa5f@google.com>
Subject: memory leak in ppp_write
From:   syzbot <syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kafai@fb.com, linux-kernel@vger.kernel.org,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        paulus@samba.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d8778f13 Merge tag 'xtensa-20190803' of git://github.com/j..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17a953d6600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=30cef20daf3e9977
dashboard link: https://syzkaller.appspot.com/bug?extid=d9c8bf24e56416d7ce2c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16da002c600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com

2019/08/04 10:45:32 executed programs: 5
2019/08/04 10:45:38 executed programs: 7
2019/08/04 10:45:44 executed programs: 9
2019/08/04 10:45:51 executed programs: 11
BUG: memory leak
unreferenced object 0xffff88811b943200 (size 224):
   comm "syz-executor.0", pid 7102, jiffies 4294951426 (age 8.020s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000612bb18c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000612bb18c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000612bb18c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000612bb18c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<00000000f510d7dd>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<0000000064f35f9b>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<0000000064f35f9b>] ppp_write+0x48/0x120  
drivers/net/ppp/ppp_generic.c:502
     [<000000007d5732a9>] __vfs_write+0x43/0xa0 fs/read_write.c:494
     [<00000000b490138e>] vfs_write fs/read_write.c:558 [inline]
     [<00000000b490138e>] vfs_write+0xee/0x210 fs/read_write.c:542
     [<00000000d20d33e5>] ksys_write+0x7c/0x130 fs/read_write.c:611
     [<000000007b61e45c>] __do_sys_write fs/read_write.c:623 [inline]
     [<000000007b61e45c>] __se_sys_write fs/read_write.c:620 [inline]
     [<000000007b61e45c>] __x64_sys_write+0x1e/0x30 fs/read_write.c:620
     [<0000000067600a9b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000007e48b83c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
