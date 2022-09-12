Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00065B533B
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 06:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiILE1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 00:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiILE1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 00:27:35 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAE91CB0D
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 21:27:33 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id s15-20020a056e021a0f00b002f1760d1437so5600390ild.1
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 21:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=16yC2ygk9mZoAXYPBA0Bif3TAfj/BVSlCgkYb6seZeU=;
        b=ud66DCssMj7J8j0BT7u/EWfL9XW7mA/Mxlr56Sz/xq7QY1OtfVuqNRlYcTcDRBBv2O
         VHrDAYTEn21aIZEDbBSu7Yqyxi18UbiFE47TFyXRMpt5nNeSX0nQDjcWT8ZO98OBR89D
         CyCcBE/paq9v3XJH9Mf2zm/oR3e86aStL2UMXNJpu2fscrRzo63aLmTpBrqw4fmt83rj
         820GaMm2uW3mpyb2O3vdpdwKUZ+WSwh2eCo+pgXqScohLQMYSUYxNBj5TGkcNLZ8Qfdg
         OSpKlYwPh37HHabXYONo/jgtK1JR4xWK14GaJd6I56NyExwBGqHWje2LkSHoQmvtUhAk
         2giw==
X-Gm-Message-State: ACgBeo0OS9H4zgDXYJjwV+ABn8sAdtbmJ391OoWWDo9szH4UsFfkxA4E
        0QR5t1JuCsi8OaNr+gYzF5aGpgqGOKHIcFjoLWXojUnKHtVB
X-Google-Smtp-Source: AA6agR6Ml96L2V6wdj/4IvzG8ov9MQiDcjCkGDfGFDH3A20lTENPH8EEeIAuxui69fo0IRwAtaY33G8Th6evr85SbIMBxTpFKYNZ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c4a:b0:2ed:c3de:c7c7 with SMTP id
 d10-20020a056e021c4a00b002edc3dec7c7mr9618188ilg.261.1662956852834; Sun, 11
 Sep 2022 21:27:32 -0700 (PDT)
Date:   Sun, 11 Sep 2022 21:27:32 -0700
In-Reply-To: <000000000000f537cc05ddef88db@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007d793405e87350df@google.com>
Subject: Re: [syzbot] BUG: Bad page map (5)
From:   syzbot <syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bigeasy@linutronix.de, bpf@vger.kernel.org, brauner@kernel.org,
        daniel@iogearbox.net, david@redhat.com, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, yhs@fb.com
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

HEAD commit:    e47eb90a0a9a Add linux-next specific files for 20220901
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17330430880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7933882276523081
dashboard link: https://syzkaller.appspot.com/bug?extid=915f3e317adb0e85835f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13397b77080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1793564f080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com

BUG: Bad page map in process syz-executor198  pte:8000000071c00227 pmd:74b30067
addr:0000000020563000 vm_flags:08100077 anon_vma:ffff8880547d2200 mapping:0000000000000000 index:20563
file:(null) fault:0x0 mmap:0x0 read_folio:0x0
CPU: 1 PID: 3614 Comm: syz-executor198 Not tainted 6.0.0-rc3-next-20220901-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_bad_pte.cold+0x2a7/0x2d0 mm/memory.c:565
 vm_normal_page+0x10c/0x2a0 mm/memory.c:636
 hpage_collapse_scan_pmd+0x729/0x1da0 mm/khugepaged.c:1199
 madvise_collapse+0x481/0x910 mm/khugepaged.c:2433
 madvise_vma_behavior+0xd0a/0x1cc0 mm/madvise.c:1062
 madvise_walk_vmas+0x1c7/0x2b0 mm/madvise.c:1236
 do_madvise.part.0+0x24a/0x340 mm/madvise.c:1415
 do_madvise mm/madvise.c:1428 [inline]
 __do_sys_madvise mm/madvise.c:1428 [inline]
 __se_sys_madvise mm/madvise.c:1426 [inline]
 __x64_sys_madvise+0x113/0x150 mm/madvise.c:1426
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f770ba87929
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f770ba18308 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f770bb0f3f8 RCX: 00007f770ba87929
RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000000020000000
RBP: 00007f770bb0f3f0 R08: 00007f770ba18700 R09: 0000000000000000
R10: 00007f770ba18700 R11: 0000000000000246 R12: 00007f770bb0f3fc
R13: 00007ffc2d8b62ef R14: 00007f770ba18400 R15: 0000000000022000
 </TASK>

