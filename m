Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5861D4D527E
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbiCJSi0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Mar 2022 13:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245499AbiCJSiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 13:38:23 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1744019D63F
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 10:37:21 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id w28-20020a05660205dc00b00645d3cdb0f7so4469591iox.10
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 10:37:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=LYK3nhgyD/Ny5AedOdu53cRFHrQjQndHfGqYjWxTv10=;
        b=xUcDZP/QvWrOon9KRWNWHFGWp+7JbbsA+mYgNyvpnThYGEY04WlxJKcjfqyehftMxu
         XY/pnHATS7hStEuB4BYbrz0yDQkkCkMTyilOHePPS2dS0dYbxCPcALOhRIm9vZsq0zeC
         B8CbilUwR6Mf4GBN6J3iGmdci9ZTuD6EHScLjQSL0H+0IOyy5DPDnkF8IwCP8eiUaA7o
         uhsvR4WwU5U4no1Byt9t9/l8RT04w/l+FUiqgOx+dIP0iuTI+MsWkpeMPyUyAPDWD26t
         wbvCQCRt95Q2WYfwadCeCwE/ns2cEhKgcJeu7DbCKNOEn+GL7wGmMBB8nq7o2gNIJACR
         Um/w==
X-Gm-Message-State: AOAM532+7hDRZSSstFMg8OpLkHN/MJPlfN5Hb+40XuERxQ1VclHN7+O0
        H2pr+p7wWDJZLXVqoekpjN/PPoX1cGe88Dm5+luoM37Ry36l
X-Google-Smtp-Source: ABdhPJyO4snl/KIWGs+wTTMW3KVNN9VcA1ZTFF0sRWA0kDSRXP9wtScBTqSM6MCJ+rSLjTH6qVrLL7iHvL8l6p3QQIrJZslaA2ae
MIME-Version: 1.0
X-Received: by 2002:a5d:8796:0:b0:645:bd36:3833 with SMTP id
 f22-20020a5d8796000000b00645bd363833mr4837920ion.158.1646937440370; Thu, 10
 Mar 2022 10:37:20 -0800 (PST)
Date:   Thu, 10 Mar 2022 10:37:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000019c51e05d9e18158@google.com>
Subject: [syzbot] BUG: missing reserved tailroom
From:   syzbot <syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, toke@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
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

HEAD commit:    de55c9a1967c Merge branch 'Add support for transmitting pa..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14ce88ad700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2fa13781bcea50fc
dashboard link: https://syzkaller.appspot.com/bug?extid=0e91362d99386dc5de99
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f36345700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c8ca65700000

The issue was bisected to:

commit b530e9e1063ed2b817eae7eec6ed2daa8be11608
Author: Toke Høiland-Jørgensen <toke@redhat.com>
Date:   Wed Mar 9 10:53:42 2022 +0000

    bpf: Add "live packet" mode for XDP in BPF_PROG_RUN

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17696e55700000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14e96e55700000
console output: https://syzkaller.appspot.com/x/log.txt?x=10e96e55700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com
Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")

------------[ cut here ]------------
XDP_WARN: xdp_update_frame_from_buff(line:274): Driver BUG: missing reserved tailroom
WARNING: CPU: 0 PID: 3590 at net/core/xdp.c:599 xdp_warn+0x28/0x30 net/core/xdp.c:599
Modules linked in:
CPU: 0 PID: 3590 Comm: syz-executor167 Not tainted 5.17.0-rc6-syzkaller-01958-gde55c9a1967c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:xdp_warn+0x28/0x30 net/core/xdp.c:599
Code: 40 00 41 55 49 89 fd 41 54 41 89 d4 55 48 89 f5 e8 2d 08 3a fa 4c 89 e9 44 89 e2 48 89 ee 48 c7 c7 80 ea b0 8a e8 ef c7 cd 01 <0f> 0b 5d 41 5c 41 5d c3 55 53 48 89 fb e8 06 08 3a fa 48 8d 7b ec
RSP: 0018:ffffc9000370f6f8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888018d8a198 RCX: 0000000000000000
RDX: ffff88802272d700 RSI: ffffffff815fe2c8 RDI: fffff520006e1ed1
RBP: ffffffff8ab54aa0 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff815f895e R11: 0000000000000000 R12: 0000000000000112
R13: ffffffff8ab54780 R14: ffff888018d8a000 R15: ffff888018d8ae98
FS:  000055555694a300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001000 CR3: 000000007255a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 xdp_update_frame_from_buff include/net/xdp.h:274 [inline]
 xdp_update_frame_from_buff include/net/xdp.h:260 [inline]
 xdp_test_run_init_page+0x3f1/0x500 net/bpf/test_run.c:143
 page_pool_set_pp_info net/core/page_pool.c:268 [inline]
 __page_pool_alloc_pages_slow+0x269/0x1050 net/core/page_pool.c:339
 page_pool_alloc_pages+0xb6/0x100 net/core/page_pool.c:372
 page_pool_dev_alloc_pages include/net/page_pool.h:197 [inline]
 xdp_test_run_batch net/bpf/test_run.c:280 [inline]
 bpf_test_run_xdp_live+0x53a/0x18c0 net/bpf/test_run.c:363
 bpf_prog_test_run_xdp+0x8f6/0x1440 net/bpf/test_run.c:1317
 bpf_prog_test_run kernel/bpf/syscall.c:3363 [inline]
 __sys_bpf+0x1858/0x59a0 kernel/bpf/syscall.c:4665
 __do_sys_bpf kernel/bpf/syscall.c:4751 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4749 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4749
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc3679a71f9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd3b6d268 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc3679a71f9
RDX: 0000000000000048 RSI: 0000000020000000 RDI: 000000000000000a
RBP: 00007fc36796b1e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fc36796b270
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
