Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF8964B5CB
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 14:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiLMNMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 08:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbiLMNL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 08:11:56 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461F02657;
        Tue, 13 Dec 2022 05:11:52 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id kw15so36330650ejc.10;
        Tue, 13 Dec 2022 05:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OCA9EB9LKetY79m77VlC6M0hSYOaeN1AdMgT0kQGhBw=;
        b=NocRLvvbdUDm8VP8WWAbrIKzt9Ttkh86KrkRUEvDXfOzDQrlO6S0vzZrT4rSdwl6Zr
         N28JSQykgjRG5VfferltdhL2kKckxJ3izRwjg0TQ785MAxIoMgNE6Kuc50l2n6AU//7B
         xe7jgmLI3msRWFalxO0dwOyCdcM61k82t02MSTTPQg1FqZ2vKnaMZN84H4Pk9mob7ovu
         p2KcIqko4eoK1wxo15ZN/7PjNMxV1czwLuomaaWZRnuOgjg3VFe2caB2h6YSRQgcIzgb
         e9bnB2ldzN+RBT3WvwrBxmjCJZ3G1qH7CPia561dlztbbil/Fn6/QM1llVdUhL6Jo6G1
         KZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OCA9EB9LKetY79m77VlC6M0hSYOaeN1AdMgT0kQGhBw=;
        b=LcmdsKwef2mY7KkGxBHL9iKf/WUK+Zt8RRCjUbCByNiGbGg+s9Rvq4eEqb8mx4crWO
         zRNPJNu9pcp7DSaCz1iRGrjD5t5a7nCexi04vAjsxqZX0hq5E4CkesqpzMwZPwxc1WOj
         aw9oqW2k8L5HF6OfGaQesQx99Pzs4arZznXwOH7QhdMfxrkr799hnKMEdPPUrW9F7m4W
         7eR6d8XEQx57g4l89ZcVL7q0VCYYaHKJz8tKsDL+ncChOYbOIDDXSHzLzVUrOpRMTCvx
         L91vPjw/07C7tWNJZEj80MLK++CkPKnExr6QDcj34k5IZw0AiavIrWBQJxMXDgcatJUB
         6fqQ==
X-Gm-Message-State: ANoB5pnN2WgB8KBEtLVNFNrwWxQUmA+uiYXeNzzcvD6hEYha4a2NKMMQ
        ZDNt1i4EmcrqAxQP4ebeTSBKJNtIQR9jTUUTn6JrlEca5cNWsA==
X-Google-Smtp-Source: AA0mqf7zwtPyaBWk8dtksho1p5lOuaxcfg1Dfk+alO3fwAnrdFkEUODM9qdE2N2Ib5BUn8ermKofd++RsgFwzRxNNFs=
X-Received: by 2002:a17:906:c358:b0:7c1:15ff:ce80 with SMTP id
 ci24-20020a170906c35800b007c115ffce80mr8762394ejb.172.1670937110471; Tue, 13
 Dec 2022 05:11:50 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Tue, 13 Dec 2022 21:11:14 +0800
Message-ID: <CAO4mrffvqv1TrMO2A9rmysq4QrGcn8PdrzNWpLDjP_u_3U-7Cw@mail.gmail.com>
Subject: BUG: unable to handle kernel paging request in tcp_write_wakeup
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        bpf@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
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

Recently, when using our tool to fuzz kernel, the following crash was triggered.

HEAD commit: 76dcd734eca
git tree: linux-next
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1mHUUrG4QFkrmP3xw7QgiytT7xWE6lbPy/view?usp=share_link
kernel config: https://drive.google.com/file/d/1jH4qV5XblPADvMDUlvS7DwtW0FroMoVB/view?usp=share_link

Unfortunately, I do not have a reproducer for this crash. My manual
investigation found that the value of %rax may be invalid. When adding
statistics to net_statistics of the current network namespace, the
value of net->mib (which is %rax) is invalid. I'm wondering if sk or
net is freed, which causes an invalid address of mib.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

BUG: unable to handle page fault for address: ffff88800167981d
#PF: supervisor write access in kernel mode
#PF: error_code(0x0003) - permissions violation
PGD 7201067 P4D 7201067 PUD 7202067 PMD 80000000016001e1
Oops: 0003 [#1] PREEMPT SMP
CPU: 0 PID: 1425 Comm: systemd-udevd Not tainted 6.1.0-rc8 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:tcp_xmit_probe_skb net/ipv4/tcp_output.c:4024 [inline]
RIP: 0010:tcp_write_wakeup+0x450/0x710 net/ipv4/tcp_output.c:4078
Code: fd 44 89 6d 2c 49 8d 7c 24 30 e8 9b 93 49 fd 49 8b 5c 24 30 48
8d bb c8 01 00 00 e8 8a 93 49 fd 48 8b 83 c8 01 00 00 49 63 cf <65> 48
ff 04 c8 49 8d bc 24 90 05 00 00 e8 ee 8e 49 fd 45 8b 84 24
RSP: 0018:ffffc90000003cb8 EFLAGS: 00010246
RAX: ffffffff83a794b5 RBX: ffff88800bbe8040 RCX: 000000000000006d
RDX: 0000000000000855 RSI: 0000000000000000 RDI: ffff88800bbe8208
RBP: ffff88800bb1a000 R08: 000188800bbe820f R09: 0000000000000000
R10: 0001ffffffffffff R11: 000188800bb1a02c R12: ffff8880368d00c0
R13: 00000000ffffffff R14: ffff88800bb1a028 R15: 000000000000006d
FS:  00007fa45b07c8c0(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88800167981d CR3: 000000000ac20000 CR4: 00000000003506f0
Call Trace:
 <IRQ>
 tcp_send_probe0+0x2c/0x2b0 net/ipv4/tcp_output.c:4093
 tcp_probe_timer net/ipv4/tcp_timer.c:393 [inline]
 tcp_write_timer_handler+0x322/0x4c0 net/ipv4/tcp_timer.c:624
 tcp_write_timer+0xb9/0x160 net/ipv4/tcp_timer.c:637
 call_timer_fn+0x2e/0x240 kernel/time/timer.c:1474
 expire_timers+0x116/0x240 kernel/time/timer.c:1519
 __run_timers+0x368/0x410 kernel/time/timer.c:1790
 run_timer_softirq+0x2e/0x60 kernel/time/timer.c:1803
 __do_softirq+0xf2/0x2c9 kernel/softirq.c:571
 __irq_exit_rcu kernel/softirq.c:650 [inline]
 irq_exit_rcu+0x41/0x70 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x8d/0xb0 arch/x86/kernel/apic/apic.c:1107
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:check_kcov_mode kernel/kcov.c:173 [inline]
RIP: 0010:write_comp_data kernel/kcov.c:236 [inline]
RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x14/0xa0 kernel/kcov.c:304
Code: 12 4d 89 44 fa 18 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
00 4c 8b 04 24 65 48 8b 14 25 80 ac 01 00 65 8b 05 04 22 da 7e <a9> 00
01 ff 00 74 10 a9 00 01 00 00 74 6e 83 ba c4 0a 00 00 00 74
RSP: 0018:ffffc9000059ba10 EFLAGS: 00000246
RAX: 0000000080000000 RBX: ffff8880090653c0 RCX: 0000000000000000
RDX: ffff888009b60e80 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff818fa64f R09: ffffc9000059ba30
R10: 0001ffffffffffff R11: 00018880095f63f0 R12: 0000000000000001
R13: ffff8880095f63a8 R14: 0000000000000000 R15: ffff8880095f63a8
 selinux_inode_permission+0x6f/0x400 security/selinux/hooks.c:3073
 security_inode_permission+0x72/0xc0 security/security.c:1326
 inode_permission+0xc5/0x460 fs/namei.c:533
 may_lookup fs/namei.c:1715 [inline]
 link_path_walk+0x1b2/0x7e0 fs/namei.c:2262
 path_lookupat+0x8b/0x3c0 fs/namei.c:2473
 filename_lookup+0x133/0x310 fs/namei.c:2503
 vfs_statx+0xa3/0x460 fs/stat.c:229
 vfs_fstatat fs/stat.c:267 [inline]
 vfs_lstat include/linux/fs.h:3304 [inline]
 __do_sys_newlstat fs/stat.c:423 [inline]
 __se_sys_newlstat+0x6c/0x270 fs/stat.c:417
 __x64_sys_newlstat+0x2d/0x40 fs/stat.c:417
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fa459eef335
Code: 69 db 2b 00 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00
83 ff 01 48 89 f0 77 30 48 89 c7 48 89 d6 b8 06 00 00 00 0f 05 <48> 3d
00 f0 ff ff 77 03 f3 c3 90 48 8b 15 31 db 2b 00 f7 d8 64 89
RSP: 002b:00007ffeff53e148 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
RAX: ffffffffffffffda RBX: 000055cd6b8d7780 RCX: 00007fa459eef335
RDX: 00007ffeff53e180 RSI: 00007ffeff53e180 RDI: 000055cd6b8d6780
RBP: 00007ffeff53e240 R08: 00007fa45a1ae248 R09: 0000000000001010
R10: 0000000000000020 R11: 0000000000000246 R12: 000055cd6b8d6780
R13: 000055cd6b8d67a0 R14: 000055cd6b8cabbb R15: 000055cd6b8cabc0
 </TASK>
Modules linked in:
CR2: ffff88800167981d
---[ end trace 0000000000000000 ]---
RIP: 0010:tcp_xmit_probe_skb net/ipv4/tcp_output.c:4024 [inline]
RIP: 0010:tcp_write_wakeup+0x450/0x710 net/ipv4/tcp_output.c:4078
Code: fd 44 89 6d 2c 49 8d 7c 24 30 e8 9b 93 49 fd 49 8b 5c 24 30 48
8d bb c8 01 00 00 e8 8a 93 49 fd 48 8b 83 c8 01 00 00 49 63 cf <65> 48
ff 04 c8 49 8d bc 24 90 05 00 00 e8 ee 8e 49 fd 45 8b 84 24
RSP: 0018:ffffc90000003cb8 EFLAGS: 00010246
RAX: ffffffff83a794b5 RBX: ffff88800bbe8040 RCX: 000000000000006d
RDX: 0000000000000855 RSI: 0000000000000000 RDI: ffff88800bbe8208
RBP: ffff88800bb1a000 R08: 000188800bbe820f R09: 0000000000000000
R10: 0001ffffffffffff R11: 000188800bb1a02c R12: ffff8880368d00c0
R13: 00000000ffffffff R14: ffff88800bb1a028 R15: 000000000000006d
FS:  00007fa45b07c8c0(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88800167981d CR3: 000000000ac20000 CR4: 00000000003506f0
----------------
Code disassembly (best guess):
   0: fd                   std
   1: 44 89 6d 2c           mov    %r13d,0x2c(%rbp)
   5: 49 8d 7c 24 30       lea    0x30(%r12),%rdi
   a: e8 9b 93 49 fd       callq  0xfd4993aa
   f: 49 8b 5c 24 30       mov    0x30(%r12),%rbx
  14: 48 8d bb c8 01 00 00 lea    0x1c8(%rbx),%rdi
  1b: e8 8a 93 49 fd       callq  0xfd4993aa
  20: 48 8b 83 c8 01 00 00 mov    0x1c8(%rbx),%rax
  27: 49 63 cf             movslq %r15d,%rcx
* 2a: 65 48 ff 04 c8       incq   %gs:(%rax,%rcx,8) <-- trapping instruction
  2f: 49 8d bc 24 90 05 00 lea    0x590(%r12),%rdi
  36: 00
  37: e8 ee 8e 49 fd       callq  0xfd498f2a
  3c: 45                   rex.RB
  3d: 8b                   .byte 0x8b
  3e: 84                   .byte 0x84
  3f: 24                   .byte 0x24

Best,
Wei
