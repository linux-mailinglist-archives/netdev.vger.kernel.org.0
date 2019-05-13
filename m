Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BF91B79F
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 16:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbfEMOBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 10:01:15 -0400
Received: from mx2.cyber.ee ([193.40.6.72]:56499 "EHLO mx2.cyber.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbfEMOBP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 10:01:15 -0400
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
From:   Meelis Roos <mroos@linux.ee>
Subject: bpf VM_FLUSH_RESET_PERMS breaks sparc64 boot
Message-ID: <4401874b-31b9-42a0-31bd-32bef5b36f2a@linux.ee>
Date:   Mon, 13 May 2019 17:01:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: et-EE
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I tested yesterdays 5.2 devel git and it failed to boot on my Sun Fire V445
(4x UltraSparc III). Init is started and it hangs there:

[   38.414436] Run /sbin/init as init process
[   38.530711] random: fast init done
[   39.580678] systemd[1]: Inserted module 'autofs4'
[   39.721577] systemd[1]: systemd 241 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=hybrid)
[   40.028068] systemd[1]: Detected architecture sparc64.

Welcome to Debian GNU/Linux 10 (buster)!

[   40.168713] systemd[1]: Set hostname to <v445>.
[   61.318034] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[   61.403039] rcu:     1-...!: (0 ticks this GP) idle=602/1/0x4000000000000000 softirq=85/85 fqs=1
[   61.526780] rcu:     (detected by 3, t=5252 jiffies, g=-967, q=228)
[   61.613037]   CPU[  1]: TSTATE[0000000080001602] TPC[000000000043f2b8] TNPC[000000000043f2bc] TASK[systemd-fstab-g:90]
[   61.766828]              TPC[smp_synchronize_tick_client+0x18/0x180] O7[__do_munmap+0x204/0x3e0] I7[xcall_sync_tick+0x1c/0x2c] RPC[page_evictable+0x4/0x60]
[   61.966807] rcu: rcu_sched kthread starved for 5250 jiffies! g-967 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=2
[   62.113058] rcu: RCU grace-period kthread stack dump:
[   62.185558] rcu_sched       I    0    10      2 0x06000000
[   62.264312] Call Trace:
[   62.299316]  [000000000092a1fc] schedule+0x1c/0x80
[   62.368071]  [000000000092d3fc] schedule_timeout+0x13c/0x280
[   62.449328]  [00000000004b6c64] rcu_gp_kthread+0x4c4/0xa40
[   62.528077]  [000000000047e95c] kthread+0xfc/0x120
[   62.596833]  [00000000004060a4] ret_from_fork+0x1c/0x2c
[   62.671831]  [0000000000000000]           (null)

5.1.0 worked fine. I bisected it to the following commit:

d53d2f78ceadba081fc7785570798c3c8d50a718 is the first bad commit
commit d53d2f78ceadba081fc7785570798c3c8d50a718
Author: Rick Edgecombe <rick.p.edgecombe@intel.com>
Date:   Thu Apr 25 17:11:38 2019 -0700

     bpf: Use vmalloc special flag
     
     Use new flag VM_FLUSH_RESET_PERMS for handling freeing of special
     permissioned memory in vmalloc and remove places where memory was set RW
     before freeing which is no longer needed. Don't track if the memory is RO
     anymore because it is now tracked in vmalloc.
     
     Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
     Cc: <akpm@linux-foundation.org>
     Cc: <ard.biesheuvel@linaro.org>
     Cc: <deneen.t.dock@intel.com>
     Cc: <kernel-hardening@lists.openwall.com>
     Cc: <kristen@linux.intel.com>
     Cc: <linux_dti@icloud.com>
     Cc: <will.deacon@arm.com>
     Cc: Alexei Starovoitov <ast@kernel.org>
     Cc: Andy Lutomirski <luto@kernel.org>
     Cc: Borislav Petkov <bp@alien8.de>
     Cc: Daniel Borkmann <daniel@iogearbox.net>
     Cc: Dave Hansen <dave.hansen@linux.intel.com>
     Cc: H. Peter Anvin <hpa@zytor.com>
     Cc: Linus Torvalds <torvalds@linux-foundation.org>
     Cc: Nadav Amit <nadav.amit@gmail.com>
     Cc: Rik van Riel <riel@surriel.com>
     Cc: Thomas Gleixner <tglx@linutronix.de>
     Link: https://lkml.kernel.org/r/20190426001143.4983-19-namit@vmware.com
     Signed-off-by: Ingo Molnar <mingo@kernel.org>

:040000 040000 58066de53107eab0705398b5d0c407424c138a86 7a1345d43c4cacee60b9135899b775ecdb54ea7e M      include
:040000 040000 d02692cf57a359056b34e636d0f102d37de5b264 81c4c2c6408b68eb555673bd3f0bc3071db1f7ed M      kernel

-- 
Meelis Roos <mroos@linux.ee>
