Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10077656C4D
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 16:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiL0PKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 10:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiL0PKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 10:10:00 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7D3643A;
        Tue, 27 Dec 2022 07:09:59 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id i15so19399805edf.2;
        Tue, 27 Dec 2022 07:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fUaQ5tj7hoX8Po1zotd3qi01WMfXm06hDr7NxRfB3rc=;
        b=bSNK0leRKl5qXoee8BXMUtxaP3EpbZmgFS0jaXBLnVucycj6XvCw16p3+pt5dBm4Jm
         noksnupVKPM2JB6n8J5Ly1zbuYxJyLGoiALWnissUqCuWi5BI+8txYi4RPkeOsoxjcyw
         Tw1KCrvK5PAeqphJ8AfbajALgJH3Bh59CqCkAb4P3dCmYAIOFDG5O1FYT9F8BGM3iora
         BVXqZTjW9ABbWbnw/Sd1b5w37mSyhccqv7sTr9Pc34eq9vfOIWayyMxAAW54JQMCUQQW
         XyMNbThdd6PW+IUP2tA2X7FzmmUgdeOFWVEjR8V+s24y/ChKTivbRocADK0q4D2eR8Q4
         2oNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fUaQ5tj7hoX8Po1zotd3qi01WMfXm06hDr7NxRfB3rc=;
        b=0AWV1cWAEI6qV53agrpGCQ6IWVd4AcxoqJp6iGRpLcDiCRGs8auqxnXpN639Ez8TQp
         0Ot9M2BrKSc9AD8ENEQFDg6xBU4BE+Lc3F+FO7rkSlRYIwUU3CIxsBDjPR4LT2vec3+1
         G5jld60O45dAgxBrLubK4/C6jIeScQtXgH2f08lzQ2kix1w9RrUSGkHbk0siHfMZCoe9
         x5Z1Tqy1FFaNm+Rlzp9ndo8A7C3MeNOCWJM8zzquhv75eBjjevIZHFEH9fQRutn5CbiM
         yW94Giqaw1u0obd/j5K2dEPxXMij/UhgwVBJcUhsgsGEOwEkYrWagSX744oStmb+oxhK
         1NRw==
X-Gm-Message-State: AFqh2korlmBuu0r+wFzTcBkvJZcG/a2lOC1fKLI/hXFd6fRfXeFCVIjE
        EKEXTtA8GYaqVpksxYNEQUV8nTknOwDvsrFnb1s=
X-Google-Smtp-Source: AMrXdXu9zyB9ajo8GGe5oVBm0Igz6zPDzS1L+6ltWYZe0H4QoOW1CVLfeL7UXLrBZujcHyag9xRNFA9P6R9Zus723vQ=
X-Received: by 2002:aa7:c3c1:0:b0:47f:95e:5cea with SMTP id
 l1-20020aa7c3c1000000b0047f095e5ceamr1329858edr.83.1672153797373; Tue, 27 Dec
 2022 07:09:57 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Tue, 27 Dec 2022 23:09:21 +0800
Message-ID: <CAO4mrffVCyXXy_fcvw5iK6srAsL2Ziwi5FzsXoGHZ0MGxGTY4Q@mail.gmail.com>
Subject: WARNING: proc registration bug in clusterip_tg_check
To:     akpm@linux-foundation.org, adobriyan@gmail.com,
        muchun.song@linux.dev, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developers,

Recently, when using our tool to fuzz kernel, the following crash was
triggered. Although this crash has happened and fixed
https://syzkaller.appspot.com/bug?id=ebe48d4bdb85f09cb87ee94052a7911be0c497b1,
it persists in the latest kernel version.

HEAD commit: e45fb347b630 Linux 6.1.0-next-20221220
git tree: linux-next
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/10FADp0RJlM5p0dRvxSpaNqS8OJUIxQ9p/view?usp=share_link
kernel config: https://drive.google.com/file/d/1mMD6aopttKDGK4aYUlgiwAk6bOQHivd-/view?usp=share_link
syz repro: https://drive.google.com/file/d/1n8MmOduvafNwOvUCOr6NCVTrYln67Fgy/view?usp=share_link

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

------------[ cut here ]------------
proc_dir_entry 'ipt_CLUSTERIP/10.1.1.2' already registered
WARNING: CPU: 0 PID: 27382 at fs/proc/generic.c:377
proc_register+0x1df/0x330 fs/proc/generic.c:376
Modules linked in:
CPU: 0 PID: 27382 Comm: syz-executor.0 Not tainted 6.1.0-next-20221220 #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:proc_register+0x1df/0x330 fs/proc/generic.c:376
Code: 48 8b 1c 24 48 8d bb a0 00 00 00 e8 9b b9 d4 ff 48 8b b3 a0 00
00 00 48 c7 c7 e1 81 63 85 48 8b 54 24 08 31 c0 e8 11 4b a7 ff <0f> 0b
48 c7 c7 48 76 e8 86 e8 03 c4 46 03 48 8b 5c 24 18 48 89 df
RSP: 0018:ffffc900009d7880 EFLAGS: 00010246
RAX: 9d0fa4778954f400 RBX: ffff88803d052d80 RCX: 0000000000040000
RDX: ffffc90001161000 RSI: 000000000000087b RDI: 000000000000087c
RBP: ffff88804a1d6398 R08: ffffffff81179fd9 R09: 0000000000000000
R10: 0001ffffffffffff R11: ffff88803e614000 R12: 0000000000000000
R13: ffff88804a1d6240 R14: ffff88804a1d6388 R15: 0000000000000008
FS:  00007f90df3c4700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f90df3c3db8 CR3: 00000000481a9000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 <TASK>
 proc_create_data+0x136/0x170 fs/proc/generic.c:578
 clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:292 [inline]
 clusterip_tg_check+0x860/0xf50 net/ipv4/netfilter/ipt_CLUSTERIP.c:517
 xt_check_target+0x275/0x700 net/netfilter/x_tables.c:1038
 check_target net/ipv4/netfilter/ip_tables.c:512 [inline]
 find_check_entry net/ipv4/netfilter/ip_tables.c:554 [inline]
 translate_table+0xc73/0xfd0 net/ipv4/netfilter/ip_tables.c:718
 do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
 do_ipt_set_ctl+0x1407/0x1720 net/ipv4/netfilter/ip_tables.c:1630
 nf_setsockopt+0x1a6/0x1c0 net/netfilter/nf_sockopt.c:101
 ip_setsockopt+0xe2/0x100 net/ipv4/ip_sockglue.c:1445
 tcp_setsockopt+0x8c/0xa0 net/ipv4/tcp.c:3801
 sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3663
 __sys_setsockopt+0x1c8/0x230 net/socket.c:2246
 __do_sys_setsockopt net/socket.c:2257 [inline]
 __se_sys_setsockopt net/socket.c:2254 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2254
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x4697f9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f90df3c3c48 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 000000000077c038 RCX: 00000000004697f9
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000004d29e9 R08: 00000000000002f0 R09: 0000000000000000
R10: 0000000020000b00 R11: 0000000000000246 R12: 000000000077c038
R13: 0000000000000000 R14: 000000000077c038 R15: 00007ffd8e91dd80
 </TASK>
---[ end trace 0000000000000000 ]---

Best,
Wei
