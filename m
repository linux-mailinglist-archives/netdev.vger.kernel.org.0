Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CA13FFB08
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 09:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347939AbhICHYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 03:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbhICHYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 03:24:17 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10725C061575;
        Fri,  3 Sep 2021 00:23:16 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g14so3637281pfm.1;
        Fri, 03 Sep 2021 00:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=CAYgm7r5yvPHVRxLroR+04qagaPonKbxE6ejs/L/yhA=;
        b=mjGrQ/CoOev8zdQNNOa4Uf4PkX/d+pBiOR4wyoEq4bJt77479T22LNy2Fs3C1FbCvU
         5VAJVhoweKTiuK8TiDahZpAY6hXE/wpqoDBlj1HFf0kK3yztKk2stj87VZf9plR9znU3
         syH777Ef5ZQFLI8iRKK5jfdb8LgQyEeYLizaNrP8qzFm5gb0kpumCBY/rCd8ymHfXRDM
         FBY+fqlxAHNwJgjpV21nJzv8mXajTMPbIEu0C3aGfXBYOnw1bP6mSWDLSiCe1r3FPsCm
         yCxU4QeN2Q6djOSqJHBYi8Djl6DtIiKsHR/eZy5FoD2+eM0Q7ZB7XhhIR24Sk/JYtDfo
         CXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=CAYgm7r5yvPHVRxLroR+04qagaPonKbxE6ejs/L/yhA=;
        b=gwtOw8K5SFPBZVVTy0KTBHnHjS5/QyYLYDra9CniRpBELHTJ3ZHmiY3zMpX+qJE7J+
         MHgOB5ZTCDxSiReV7jtg3AjJCAzrv7pIEnkaVFTy1Uqduodjd55E72OdqI9GtsLiqHw7
         DaDa8f5TSzrcz3pPQbwU28E4tRW58X1KYIq0a8JwcmLuwzATgWcl1zKlygPfc9mbHMqF
         /cp0YhwwsrpSH5WVAPGa6t/TmFSDzt3jKlQLRa4hYNa5WiI27UOr+yfoVbZoPZa1lh5M
         N1MTjqQndnKiIoBiwJexpplvCfHO+PzLSb7SPsD5qpEgiu3NK5drcZri7AE+YXc1O69y
         OXVA==
X-Gm-Message-State: AOAM531nRlO+b3fIpICUoDU5N6giHQ5ST0HIrX5Tf9hffnM5n2HQ9MT2
        E9j2RPI3+dSAWlAR30cjwVv19kEr3uCmM/fPXqTyezaOnHp521E=
X-Google-Smtp-Source: ABdhPJxtSGOSV4WdjAKSO9lQsFaSbuwGQVddqZ2Pe0/IhgeI5wc/D7DMm5VpaBpGzGCiatqAjub+P+MmSRYdh8uTxSU=
X-Received: by 2002:a62:7c0d:0:b0:3fe:60d2:bce2 with SMTP id
 x13-20020a627c0d000000b003fe60d2bce2mr2242436pfc.27.1630653795400; Fri, 03
 Sep 2021 00:23:15 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Fri, 3 Sep 2021 15:23:04 +0800
Message-ID: <CACkBjsYoWvCcdrx+dhfMxZPQe6QNPo+TiqBZB5zqr89xikNEqQ@mail.gmail.com>
Subject: kernel BUG in icmp_glue_bits
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 7d2a07b76933 Linux 5.14
git tree: upstream
console output:
https://drive.google.com/file/d/1cnXumCo_HKWYN6f4wyomzDwCN4kUVi7O/view?usp=sharing
kernel config: https://drive.google.com/file/d/1XD9WYDViQLSXN7RGwH8AGGDvP9JvOghx/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:2921!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 4538 Comm: systemd-udevd Not tainted 5.14.0 #25
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:skb_copy_and_csum_bits+0x704/0x800 net/core/skbuff.c:2921
Code: 70 fa 49 63 c6 44 01 f5 49 01 c5 89 6c 24 04 4c 89 6c 24 08 e9
c5 f9 ff ff e8 c8 64 70 fa 0f 0b e9 95 fe ff ff e8 bc 64 70 fa <0f> 0b
e8 55 52 b7 fa e9 c9 fc ff ff 48 8b 7c 24 20 e8 46 52 b7 fa
RSP: 0018:ffffc90000167f20 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000001e8 RCX: ffff888101503980
RDX: 0000000000000000 RSI: ffff888101503980 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffffffff870493c4 R09: 0000000000000000
R10: 0000000000000005 R11: ffffed10228642a5 R12: 0000000000000000
R13: ffff888014e10868 R14: 000000000000003c R15: 000000000000003c
FS:  00007ff42eb758c0(0000) GS:ffff888119f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005610e0f77618 CR3: 00000001034f1001 CR4: 0000000000770ee0
PKRU: 55555554
Call Trace:
 <IRQ>
 icmp_glue_bits+0x79/0x1f0 net/ipv4/icmp.c:356
 __ip_append_data.isra.0+0x19be/0x33c0 net/ipv4/ip_output.c:1144
 ip_append_data.part.0+0xf6/0x180 net/ipv4/ip_output.c:1327
 ip_append_data+0x6c/0x90 net/ipv4/ip_output.c:1316
 icmp_push_reply+0x13b/0x4b0 net/ipv4/icmp.c:374
 __icmp_send+0xc47/0x1500 net/ipv4/icmp.c:769
 icmp_send include/net/icmp.h:43 [inline]
 ip_fragment net/ipv4/ip_output.c:588 [inline]
 ip_fragment.constprop.0+0x1e7/0x240 net/ipv4/ip_output.c:575
 __ip_finish_output net/ipv4/ip_output.c:306 [inline]
 __ip_finish_output+0x5db/0x11e0 net/ipv4/ip_output.c:290
 ip_finish_output+0x32/0x200 net/ipv4/ip_output.c:318
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x201/0x610 net/ipv4/ip_output.c:432
 dst_output include/net/dst.h:448 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 __ip_queue_xmit+0x823/0x1890 net/ipv4/ip_output.c:533
 __tcp_transmit_skb+0x1a2d/0x3920 net/ipv4/tcp_output.c:1405
 tcp_transmit_skb net/ipv4/tcp_output.c:1423 [inline]
 __tcp_retransmit_skb+0x5c7/0x2a60 net/ipv4/tcp_output.c:3234
 tcp_retransmit_skb+0x2a/0x360 net/ipv4/tcp_output.c:3257
 tcp_retransmit_timer+0xe44/0x3050 net/ipv4/tcp_timer.c:539
 tcp_write_timer_handler+0x4aa/0x940 net/ipv4/tcp_timer.c:622
 tcp_write_timer+0xa2/0x2b0 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x6b0/0xa90 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb6/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x1d7/0x93b kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x14f/0x170 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
RIP: 0010:check_kcov_mode+0x0/0x40 kernel/kcov.c:163
Code: 89 df e8 43 ee 46 00 e9 8d fe ff ff 48 8b 7c 24 08 e8 34 ee 46
00 e9 f3 fd ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <65> 8b
05 e9 f7 8c 7e 89 c2 81 e2 00 01 00 00 a9 00 01 ff 00 74 10
RSP: 0018:ffffc900005a7810 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffffffff83a0cb5c
RDX: 0000000000000000 RSI: ffff888101503980 RDI: 0000000000000003
RBP: ffff888103e7ea80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000005 R11: fffffbfff1f4b214 R12: 0000000000000022
R13: 0000000000000073 R14: dffffc0000000000 R15: 0000000000000000
 write_comp_data+0x1c/0x70 kernel/kcov.c:218
 tomoyo_domain_quota_is_ok+0x30c/0x540 security/tomoyo/util.c:1093
 tomoyo_supervisor+0x290/0xe30 security/tomoyo/common.c:2089
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission security/tomoyo/file.c:587 [inline]
 tomoyo_path_permission+0x270/0x3a0 security/tomoyo/file.c:573
 tomoyo_path_perm+0x2fc/0x420 security/tomoyo/file.c:838
 security_inode_getattr+0xcf/0x140 security/security.c:1333
 vfs_getattr+0x22/0x60 fs/stat.c:139
 vfs_statx+0x168/0x370 fs/stat.c:207
 vfs_fstatat fs/stat.c:225 [inline]
 vfs_lstat include/linux/fs.h:3386 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:380
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff42d9e8335
Code: 69 db 2b 00 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00
83 ff 01 48 89 f0 77 30 48 89 c7 48 89 d6 b8 06 00 00 00 0f 05 <48> 3d
00 f0 ff ff 77 03 f3 c3 90 48 8b 15 31 db 2b 00 f7 d8 64 89
RSP: 002b:00007ffddaf6d118 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
RAX: ffffffffffffffda RBX: 00005610e0f4b8d0 RCX: 00007ff42d9e8335
RDX: 00007ffddaf6d150 RSI: 00007ffddaf6d150 RDI: 00005610e0f4a8d0
RBP: 00007ffddaf6d210 R08: 00007ff42dca71d8 R09: 0000000000001010
R10: 00005610e0f34830 R11: 0000000000000246 R12: 00005610e0f4a8d0
R13: 00005610e0f4a8ea R14: 00005610e0f33d05 R15: 00005610e0f33d0a
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end trace 3f7b18088a4592dc ]---
RIP: 0010:skb_copy_and_csum_bits+0x704/0x800 net/core/skbuff.c:2921
Code: 70 fa 49 63 c6 44 01 f5 49 01 c5 89 6c 24 04 4c 89 6c 24 08 e9
c5 f9 ff ff e8 c8 64 70 fa 0f 0b e9 95 fe ff ff e8 bc 64 70 fa <0f> 0b
e8 55 52 b7 fa e9 c9 fc ff ff 48 8b 7c 24 20 e8 46 52 b7 fa
RSP: 0018:ffffc90000167f20 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000001e8 RCX: ffff888101503980
RDX: 0000000000000000 RSI: ffff888101503980 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffffffff870493c4 R09: 0000000000000000
R10: 0000000000000005 R11: ffffed10228642a5 R12: 0000000000000000
R13: ffff888014e10868 R14: 000000000000003c R15: 000000000000003c
FS:  00007ff42eb758c0(0000) GS:ffff888119f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005610e0f77618 CR3: 00000001034f1001 CR4: 0000000000770ee0
PKRU: 55555554
----------------
Code disassembly (best guess):
   0: 89 df                mov    %ebx,%edi
   2: e8 43 ee 46 00        callq  0x46ee4a
   7: e9 8d fe ff ff        jmpq   0xfffffe99
   c: 48 8b 7c 24 08        mov    0x8(%rsp),%rdi
  11: e8 34 ee 46 00        callq  0x46ee4a
  16: e9 f3 fd ff ff        jmpq   0xfffffe0e
  1b: cc                    int3
  1c: cc                    int3
  1d: cc                    int3
  1e: cc                    int3
  1f: cc                    int3
  20: cc                    int3
  21: cc                    int3
  22: cc                    int3
  23: cc                    int3
  24: cc                    int3
  25: cc                    int3
  26: cc                    int3
  27: cc                    int3
  28: cc                    int3
  29: cc                    int3
* 2a: 65 8b 05 e9 f7 8c 7e mov    %gs:0x7e8cf7e9(%rip),%eax        #
0x7e8cf81a <-- trapping instruction
  31: 89 c2                mov    %eax,%edx
  33: 81 e2 00 01 00 00    and    $0x100,%edx
  39: a9 00 01 ff 00        test   $0xff0100,%eax
  3e: 74 10                je     0x50
