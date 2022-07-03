Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E53E5645AB
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 09:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiGCH53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 03:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiGCH51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 03:57:27 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B831B1D6
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 00:57:23 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id n4-20020a5d8244000000b0067566682c09so4084906ioo.13
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 00:57:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pKXHXUQ8SF8H1iXfTQ0H7r6e3pNzOGjibivY6+EUllY=;
        b=Ha76Zd8SSEIWTWOO1WnJkvyaYPB+Njhqk0nnJVy7SGv7t+rhWnyKt4Vfsz6YMTDRSX
         Mf8efUe6ro/3mCL3QqnMX0Fl2mSk7MkvuVdbBWA55rlItMB0SlllqR+FPvlJhpriU/kk
         7mrUyeGdbgtPAK/5DJDIlm0dQ9y+jev5rb1+jd36daV7TFkAECpVFf8uW2hFSGk+ypn3
         FPvW47ManPVTsiC2AoBdCn9tI97AiVNyvDrP9evPL3Fj7BaouwdTl6gO27H2tH1X25/n
         o4W01ThXwaWAjh6+ESpDYGvtmDLgfUp2/Q5kuiN2cRWieIVcm5sQKQzVaCBt0CSgh/D5
         grZw==
X-Gm-Message-State: AJIora9Nk0l0QDa37yOF8J0fWl7VHSg+DupdmItgkllwzSbR2njkqP6l
        1RjOUK4XvAI9uu+PmvAkUE8BsXx2nfa1kixtO2rbEqWN4gIG
X-Google-Smtp-Source: AGRyM1tpWIwU1CgXOZqm2iMk1llhS+McHiymnuSOVRdUfLtk7MFZdhDl0T8n78AC0pHQlQ2vKpbjtnUTMwqQBsW2wDUu0lypeznt
MIME-Version: 1.0
X-Received: by 2002:a02:a892:0:b0:33b:b69c:304b with SMTP id
 l18-20020a02a892000000b0033bb69c304bmr14252796jam.150.1656835042750; Sun, 03
 Jul 2022 00:57:22 -0700 (PDT)
Date:   Sun, 03 Jul 2022 00:57:22 -0700
In-Reply-To: <00000000000073b3e805d7fed17e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002cb7d405e2e1f886@google.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_jit_free
From:   syzbot <syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dvyukov@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kernel-team@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nogikh@google.com, patchwork-bot@kernel.org, song@kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
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

HEAD commit:    b0d93b44641a selftests/bpf: Skip lsm_cgroup when we don't ..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10c495e0080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=70e1a4d352a3c6ae
dashboard link: https://syzkaller.appspot.com/bug?extid=2f649ec6d2eea1495a8f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a10a58080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ab8cb8080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in bpf_jit_binary_free kernel/bpf/core.c:1081 [inline]
BUG: KASAN: vmalloc-out-of-bounds in bpf_jit_free+0x26c/0x2b0 kernel/bpf/core.c:1206
Read of size 4 at addr ffffffffa0000000 by task syz-executor334/3608

CPU: 0 PID: 3608 Comm: syz-executor334 Not tainted 5.19.0-rc2-syzkaller-00498-gb0d93b44641a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xf/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 bpf_jit_binary_free kernel/bpf/core.c:1081 [inline]
 bpf_jit_free+0x26c/0x2b0 kernel/bpf/core.c:1206
 jit_subprogs kernel/bpf/verifier.c:13767 [inline]
 fixup_call_args kernel/bpf/verifier.c:13796 [inline]
 bpf_check+0x7035/0xb040 kernel/bpf/verifier.c:15287
 bpf_prog_load+0xfb2/0x2250 kernel/bpf/syscall.c:2575
 __sys_bpf+0x11a1/0x5790 kernel/bpf/syscall.c:4934
 __do_sys_bpf kernel/bpf/syscall.c:5038 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5036 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5036
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fe5b823e209
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc68d718c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fe5b823e209
RDX: 0000000000000070 RSI: 0000000020000440 RDI: 0000000000000005
RBP: 00007ffc68d718e0 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>

Memory state around the buggy address:
BUG: unable to handle page fault for address: fffffbfff3ffffe0
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 23ffe4067 P4D 23ffe4067 PUD 23ffe3067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3608 Comm: syz-executor334 Not tainted 5.19.0-rc2-syzkaller-00498-gb0d93b44641a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:memcpy_erms+0x6/0x10 arch/x86/lib/memcpy_64.S:55
Code: cc cc cc cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
RSP: 0018:ffffc9000215f7b8 EFLAGS: 00010082
RAX: ffffc9000215f7c4 RBX: ffffffff9fffff00 RCX: 0000000000000010
RDX: 0000000000000010 RSI: fffffbfff3ffffe0 RDI: ffffc9000215f7c4
RBP: ffffffffa0000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000014 R11: 0000000000000001 R12: 00000000fffffffe
R13: ffffffff9fffff80 R14: ffff888025745880 R15: 0000000000000282
FS:  0000555555ac7300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff3ffffe0 CR3: 000000007dc79000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 print_memory_metadata+0x5a/0xdf mm/kasan/report.c:404
 print_report mm/kasan/report.c:430 [inline]
 kasan_report.cold+0xfe/0x1c6 mm/kasan/report.c:491
 bpf_jit_binary_free kernel/bpf/core.c:1081 [inline]
 bpf_jit_free+0x26c/0x2b0 kernel/bpf/core.c:1206
 jit_subprogs kernel/bpf/verifier.c:13767 [inline]
 fixup_call_args kernel/bpf/verifier.c:13796 [inline]
 bpf_check+0x7035/0xb040 kernel/bpf/verifier.c:15287
 bpf_prog_load+0xfb2/0x2250 kernel/bpf/syscall.c:2575
 __sys_bpf+0x11a1/0x5790 kernel/bpf/syscall.c:4934
 __do_sys_bpf kernel/bpf/syscall.c:5038 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5036 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5036
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fe5b823e209
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc68d718c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fe5b823e209
RDX: 0000000000000070 RSI: 0000000020000440 RDI: 0000000000000005
RBP: 00007ffc68d718e0 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
CR2: fffffbfff3ffffe0
---[ end trace 0000000000000000 ]---
RIP: 0010:memcpy_erms+0x6/0x10 arch/x86/lib/memcpy_64.S:55
Code: cc cc cc cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
RSP: 0018:ffffc9000215f7b8 EFLAGS: 00010082
RAX: ffffc9000215f7c4 RBX: ffffffff9fffff00 RCX: 0000000000000010
RDX: 0000000000000010 RSI: fffffbfff3ffffe0 RDI: ffffc9000215f7c4
RBP: ffffffffa0000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000014 R11: 0000000000000001 R12: 00000000fffffffe
R13: ffffffff9fffff80 R14: ffff888025745880 R15: 0000000000000282
FS:  0000555555ac7300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff3ffffe0 CR3: 000000007dc79000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	cc                   	int3
   1:	cc                   	int3
   2:	cc                   	int3
   3:	cc                   	int3
   4:	eb 1e                	jmp    0x24
   6:	0f 1f 00             	nopl   (%rax)
   9:	48 89 f8             	mov    %rdi,%rax
   c:	48 89 d1             	mov    %rdx,%rcx
   f:	48 c1 e9 03          	shr    $0x3,%rcx
  13:	83 e2 07             	and    $0x7,%edx
  16:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  19:	89 d1                	mov    %edx,%ecx
  1b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  1d:	c3                   	retq
  1e:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  24:	48 89 f8             	mov    %rdi,%rax
  27:	48 89 d1             	mov    %rdx,%rcx
* 2a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi) <-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  34:	48 89 f8             	mov    %rdi,%rax
  37:	48 83 fa 20          	cmp    $0x20,%rdx
  3b:	72 7e                	jb     0xbb
  3d:	40 38 fe             	cmp    %dil,%sil

