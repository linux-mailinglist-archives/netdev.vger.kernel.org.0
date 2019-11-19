Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4D9102900
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbfKSQLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:11:51 -0500
Received: from mx2.cyber.ee ([193.40.6.72]:36009 "EHLO mx2.cyber.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbfKSQLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 11:11:51 -0500
Subject: Re: 5.4-rc8 OOPS from bpf now
From:   Meelis Roos <mroos@linux.ee>
To:     LKML <linux-kernel@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        netdev@vger.kernel.org
References: <cf84521e-7b7e-570e-9850-1a5573e62786@linux.ee>
 <268b0af7-4d4d-ad9d-3036-554321920188@linux.ee>
Message-ID: <6d3e3d29-f23a-dd49-6b4b-f7b6bf7398ab@linux.ee>
Date:   Tue, 19 Nov 2019 18:11:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <268b0af7-4d4d-ad9d-3036-554321920188@linux.ee>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


19.11.19 16:02 I wrote:

> I changed the kernel config in semi-random ways and retried. This results in a different crash, in BPF.
> This is similar to a yet-unreported problem that I am trying to debug on Ultra 45 with 5.4-git.
[...]
> Kernel config now (CONFIG_JUMP_LABEL seems the most outstanding change?)

I turned off just CONFIG_JUMP_LABEL and tried again, and got a third kind of oops from
softirq and RCU code, during dpkg --configure rsyslog - so it looks like BPF was hit like a bystander?

[  114.436832] Unable to handle kernel NULL pointer dereference
[  114.511243] tsk->{mm,active_mm}->context = 0000000000000001
[  114.553985] Kernel unaligned access at TPC[55a9f4] anon_vma_interval_tree_insert+0x34/0xe0
[  114.584446] tsk->{mm,active_mm}->pgd = fff000133c97e000
[  114.584449]               \|/ ____ \|/
[  114.584449]               "@'/ .. \`@"
[  114.584449]               /_| \__/ |_\
[  114.584449]                  \__U_/
[  114.584453] ksoftirqd/0(16): Oops [#1]
[  114.584464] CPU: 0 PID: 16 Comm: ksoftirqd/0 Not tainted 5.4.0-rc8 #14
[  115.090062] TSTATE: 0000009980001607 TPC: 00000000004f8d20 TNPC: 00000000004f8d24 Y: 00000000    Not tainted
[  115.219328] TPC: <__bpf_prog_put_rcu+0x80/0xc0>
[  115.278884] g0: 0000000000000000 g1: 00000001000a0000 g2: 0000000000000000 g3: 0000000000000000
[  115.393260] g4: fff000133c12f7e0 g5: fff000133ec92000 g6: fff000133c17c000 g7: 000c00002b4b7c10
[  115.507646] o0: 0000000000000000 o1: 0000000000000000 o2: 00000000004bab4c o3: 000bffffffc8b048
[  115.622014] o4: fff000133ec92000 o5: 001bffecc0ff9048 sp: fff000133c17f241 ret_pc: 00000000004f8d10
[  115.740965] RPC: <__bpf_prog_put_rcu+0x70/0xc0>
[  115.800435] l0: 0000000000a5c328 l1: 0000000000b36400 l2: 0000000000000001 l3: 0000000000a670b0
[  115.914854] l4: fff000133c00c168 l5: 0000000000000002 l6: ffffffffffffffc8 l7: fff000133c00d028
[  116.029294] i0: fff000133dcf7900 i1: fff000133dfe5b00 i2: 0000000000001a31 i3: 0000000000000000
[  116.143661] i4: fff000133f80a3d0 i5: 0000000000000000 i6: fff000133c17f2f1 i7: 00000000004bab4c
[  116.258039] I7: <rcu_core+0x1cc/0x540>
[  116.307208] Call Trace:
[  116.339235]  [00000000004bab4c] rcu_core+0x1cc/0x540
[  116.404439]  [000000000095a398] __do_softirq+0xd8/0x240
[  116.473055]  [000000000046708c] run_ksoftirqd+0x2c/0x40
[  116.541680]  [0000000000484e24] smpboot_thread_fn+0x164/0x1e0
[  116.617178]  [0000000000481c5c] kthread+0xfc/0x120
[  116.680077]  [00000000004060a4] ret_from_fork+0x1c/0x2c
[  116.748696]  [0000000000000000] 0x0
[  116.794441] Disabling lock debugging due to kernel taint
[  116.864213] Caller[00000000004bab4c]: rcu_core+0x1cc/0x540
[  116.936268] Caller[000000000095a398]: __do_softirq+0xd8/0x240
[  117.011764] Caller[000000000046708c]: run_ksoftirqd+0x2c/0x40
[  117.087242] Caller[0000000000484e24]: smpboot_thread_fn+0x164/0x1e0
[  117.169592] Caller[0000000000481c5c]: kthread+0xfc/0x120
[  117.239358] Caller[00000000004060a4]: ret_from_fork+0x1c/0x2c
[  117.314845] Caller[0000000000000000]: 0x0
[  117.367456] Instruction DUMP:
[  117.367458]  d05e3f80
[  117.406341]  c25e3f88
[  117.437223]  c4586020
[  117.468102] <fa58a090>
[  117.498985]  02c74005
[  117.529864]  01000000
[  117.560747]  d0104000
[  117.591628]  40114967
[  117.622509]  92076050
[  117.653387]
[  117.703710] Kernel panic - not syncing: Aiee, killing interrupt handler!
[  117.791776] ------------[ cut here ]------------
[  117.852403] WARNING: CPU: 0 PID: 16 at kernel/smp.c:433 smp_call_function_many+0x350/0x380
[  117.961047] Modules linked in: tg3 i2c_ali15x3 hwmon i2c_ali1535 flash i2c_core autofs4
[  118.066275] CPU: 0 PID: 16 Comm: ksoftirqd/0 Tainted: G      D           5.4.0-rc8 #14
[  118.170351] Call Trace:
[  118.202382]  [0000000000462fc4] __warn+0x94/0xb0
[  118.262994]  [0000000000463010] warn_slowpath_fmt+0x30/0x80
[  118.336194]  [00000000004d6750] smp_call_function_many+0x350/0x380
[  118.417399]  [00000000004d6798] smp_call_function+0x18/0x40
[  118.490597]  [0000000000462d0c] panic+0x10c/0x330
[  118.552361]  [00000000004666f4] do_exit+0xa14/0xaa0
[  118.616412]  [000000000042b08c] die_if_kernel+0x1ec/0x258
[  118.687322]  [0000000000450600] unhandled_fault+0x80/0xa0
[  118.758232]  [000000000045039c] do_sparc64_fault+0x5fc/0x7e0
[  118.832579]  [00000000004076f4] sparc64_realfault_common+0x10/0x20
[  118.913783]  [00000000004f8d20] __bpf_prog_put_rcu+0x80/0xc0
[  118.988124]  [00000000004bab4c] rcu_core+0x1cc/0x540
[  119.053318]  [000000000095a398] __do_softirq+0xd8/0x240
[  119.121941]  [000000000046708c] run_ksoftirqd+0x2c/0x40
[  119.190566]  [0000000000484e24] smpboot_thread_fn+0x164/0x1e0
[  119.266054]  [0000000000481c5c] kthread+0xfc/0x120
[  119.328957] ---[ end trace 66b937e7760cb8cf ]---
[  119.389577] ------------[ cut here ]------------
[  119.450195] WARNING: CPU: 0 PID: 16 at kernel/smp.c:300 smp_call_function_single+0x168/0x1a0
[  119.561139] Modules linked in: tg3 i2c_ali15x3 hwmon i2c_ali1535 flash i2c_core autofs4
[  119.666365] CPU: 0 PID: 16 Comm: ksoftirqd/0 Tainted: G      D W         5.4.0-rc8 #14
[  119.770442] Call Trace:
[  119.802465]  [0000000000462fc4] __warn+0x94/0xb0
[  119.863084]  [0000000000463010] warn_slowpath_fmt+0x30/0x80
[  119.936286]  [00000000004d61c8] smp_call_function_single+0x168/0x1a0
[  120.019779]  [00000000004d6798] smp_call_function+0x18/0x40
[  120.092978]  [0000000000462d0c] panic+0x10c/0x330
[  120.154738]  [00000000004666f4] do_exit+0xa14/0xaa0
[  120.218787]  [000000000042b08c] die_if_kernel+0x1ec/0x258
[  120.289700]  [0000000000450600] unhandled_fault+0x80/0xa0
[  120.360612]  [000000000045039c] do_sparc64_fault+0x5fc/0x7e0
[  120.434956]  [00000000004076f4] sparc64_realfault_common+0x10/0x20
[  120.516162]  [00000000004f8d20] __bpf_prog_put_rcu+0x80/0xc0
[  120.590503]  [00000000004bab4c] rcu_core+0x1cc/0x540
[  120.655698]  [000000000095a398] __do_softirq+0xd8/0x240
[  120.724320]  [000000000046708c] run_ksoftirqd+0x2c/0x40
[  120.792946]  [0000000000484e24] smpboot_thread_fn+0x164/0x1e0
[  120.868432]  [0000000000481c5c] kthread+0xfc/0x120
[  120.931337] ---[ end trace 66b937e7760cb8d0 ]---
[  120.991962] Press Stop-A (L1-A) from sun keyboard or send break
[  120.991962] twice on console to return to the boot prom
[  121.138356] ---[ end Kernel panic - not syncing: Aiee, killing interrupt handler! ]---

-- 
Meelis Roos <mroos@linux.ee>
