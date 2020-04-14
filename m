Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803221A8B06
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504961AbgDNTi0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Apr 2020 15:38:26 -0400
Received: from outbound-mail2.linode.com ([173.255.198.11]:40612 "EHLO
        outbound-mail2.linode.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504934AbgDNTh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:37:26 -0400
X-Greylist: delayed 2280 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2020 15:37:25 EDT
From:   "Christopher S. Aker" <caker@theshore.net>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: WARNING: at net/sched/sch_generic.c - Reproducible crash & rcu stalls
Message-Id: <13761CC9-9394-4B5B-84B2-C86DC8DA5C39@theshore.net>
Date:   Tue, 14 Apr 2020 14:59:22 -0400
Cc:     netfilter@vger.kernel.org
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My apologies for cross posting. I sent https://lkml.org/lkml/2020/4/8/980 to LKML a week ago, but perhaps I didn't have the correct audience. Please let me know if I'm still off base...

We're able to reliably trigger a NETDEV WATCHDOG and a WARNING, which then some combination of [NMIs, stuck kworkers, network device timeouts, rcu stalls] happens, and, in 99% of cases, the system descends into madness and needs to be rebooted.

Encountered on: 4.14.x, 4.19.x, 5.4.x, 5.5.9, (and probably older kernels)

We've actually been encountering this bug for quite a long time. It was annoying but not a frequent problem and we were never able to figure it out.

Recently, with our move towards AMD powered machines, this has become a critical issue. We're facing many of these crashes daily across our fleet of these machines. Thankfully, we've figured out how to reproduce it - and hope to find a fix:

What these machines do:
- Hosts for virtual machines - qemu/kvm
- Linux bridging + tuntap
- ebtable, iptable, and iptable6 rules, ipsets, cgroups, etc
- Happening on multiple NICs (Intel and Mellanox)

How we're reproducing the problem:
- Have the VMs flood udp outbound
- Run a boatload of: "ebtables -t nat -L --Lx --Lmac2 --Lc" and/or "ebtables -t nat -L --Lc"

It will crash in minutes.

The combination of outbound packets and running ebtables seems to be what triggers it. Do either without the other and the machine is fine. Combine them and it will crash. Example initial kernel output:

[ 6755.833166] ------------[ cut here ]------------
[ 6755.836716] NETDEV WATCHDOG: eth1 (mlx5_core): transmit queue 19 timed out
[ 6755.843728] WARNING: CPU: 15 PID: 30568 at net/sched/sch_generic.c:443 dev_watchdog+0x22f/0x240
[ 6755.851487] Modules linked in: cls_u32 sch_ingress act_police xt_u32 xt_physdev ebt_set xt_multiport xt_set nf_conntrack_netlink xt_CT xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 tun ebt_comment ebt_limit ebt_arp ebt_ip6 ebt_ip ip_set_hash_net ip_set ip6table_raw ip6table_mangle ip6_tables iptable_raw iptable_filter ip_tables bpfilter ebtable_nat 8021q mrp bonding amd64_edac_mod kvm_amd kvm irqbypass crct10dif_pclmul crc32_pclmul mlx5_core crc32c_intel evdev fuse autofs4
[ 6755.893442] CPU: 15 PID: 30568 Comm: qemu-system-x86 Not tainted 5.5.9-1 #1
[ 6755.899410] Hardware name: Supermicro Super Server/H11DSi-NT, BIOS 1.1 04/13/2018
[ 6755.905729] RIP: 0010:dev_watchdog+0x22f/0x240
[ 6755.908994] Code: c0 75 e4 eb 98 4c 89 ef c6 05 f3 19 eb 00 01 e8 17 7a fb ff 89 d9 48 89 c2 4c 89 ee 48 c7 c7 48 d3 61 92 31 c0 e8 a1 ec 5b ff <0f> 0b e9 75 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
[ 6755.926764] RSP: 0018:ffff8df80cbacec0 EFLAGS: 00010282
[ 6755.930823] RAX: 000000000000003e RBX: 0000000000000013 RCX: 0000000000000000
[ 6755.936789] RDX: ffff8b3dafbe7480 RSI: ffff8b3dafbd8a18 RDI: ffff8b3dafbd8a18
[ 6755.942753] RBP: ffff8b3d99d80440 R08: 0000000000000000 R09: 0000000000000a4a
[ 6755.948717] R10: ffff8df81a243c40 R11: 0000000000000000 R12: 00000000000001f8
[ 6755.954680] R13: ffff8b3d99d80000 R14: 0000000100628200 R15: 0000000000000000
[ 6755.960643] FS:  00007f2ef5387000(0000) GS:ffff8b3dafbc0000(0000) knlGS:0000000000000000
[ 6755.967570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6755.972283] CR2: 00007fffbd746d28 CR3: 0000001f119cc000 CR4: 00000000003406e0
[ 6755.978403] Call Trace:
[ 6755.979673]  <IRQ>
[ 6755.980510]  ? dev_deactivate_queue.constprop.60+0x90/0x90
[ 6755.984829]  call_timer_fn+0x2d/0x140
[ 6755.987443]  run_timer_softirq+0x16a/0x1e0
[ 6755.990438]  ? __hrtimer_run_queues+0x11c/0x260
[ 6755.993800]  ? ktime_get+0x38/0x90
[ 6755.996028]  __do_softirq+0x117/0x2d0
[ 6755.998514]  do_softirq_own_stack+0x2a/0x40
[ 6756.001524]  </IRQ>
[ 6756.002469]  do_softirq.part.20+0x2b/0x30
[ 6756.005439]  __local_bh_enable_ip+0x59/0x60
[ 6756.008490]  tun_get_user+0xe87/0xfd0 [tun]
[ 6756.011511]  tun_chr_write_iter+0x4d/0x70 [tun]
[ 6756.014874]  do_iter_readv_writev+0x177/0x1b0
[ 6756.018061]  do_iter_write+0x87/0x1b0
[ 6756.020557]  vfs_writev+0x83/0x100
[ 6756.022790]  ? do_vfs_ioctl+0x8e/0x620
[ 6756.025408]  ? do_writev+0x51/0xe0
[ 6756.027637]  ? ksys_ioctl+0x6f/0x90
[ 6756.029948]  do_writev+0x51/0xe0
[ 6756.032003]  do_syscall_64+0x54/0x280
[ 6756.034505]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 6756.038406] RIP: 0033:0x7f2ef20a72f0
[ 6756.040811] Code: 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 09 39 01 00 48 63 54 24 1c 41 89 c0 48 8b 74 24 10 48 63 7c 24 08 b8 14 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 17 44 89 c7 48 89 44 24 08 e8 3b 39 01 00 48
[ 6756.058563] RSP: 002b:00007fffbd748e20 EFLAGS: 00000293 ORIG_RAX: 0000000000000014
[ 6756.064967] RAX: ffffffffffffffda RBX: 000055a3ce26ecd0 RCX: 00007f2ef20a72f0
[ 6756.070940] RDX: 0000000000000001 RSI: 000055a3ce259e38 RDI: 0000000000000012
[ 6756.076909] RBP: 000055a3ce26ecd0 R08: 0000000000000000 R09: 000055a3cd0715c0
[ 6756.082881] R10: 0000000000000001 R11: 0000000000000293 R12: 0000000000000001
[ 6756.088848] R13: 000055a3ce259e38 R14: 000055a3ce259e38 R15: 0000000000000001
[ 6756.094813] ---[ end trace a91e624ca8f4292c ]---
[ 6756.098429] mlx5_core 0000:13:00.1 eth1: TX timeout detected
[ 6756.102952] mlx5_core 0000:13:00.1 eth1: TX timeout on queue: 19, SQ: 0xab6, CQ: 0xd4a, SQ Cons: 0x3fd7 SQ Prod: 0x3fe6, usecs since last trans: 27541000
[ 6756.115632] mlx5_core 0000:13:00.1 eth1: EQ 0x1a: Cons = 0x9c0e, irqn = 0x120
[ 6775.300229] rcu: INFO: rcu_sched self-detected stall on CPU
[ 6775.304787] rcu: 	85-....: (59999 ticks this GP) idle=ca2/1/0x4000000000000002 softirq=7985603/7985603 fqs=14090
[ 6775.313959] 	(t=60013 jiffies g=687873 q=106209)
[ 6775.317527] NMI backtrace for cpu 85
[ 6775.319932] CPU: 85 PID: 23160 Comm: ebtables Tainted: G        W         5.5.9-1 #1
[ 6775.326520] Hardware name: Supermicro Super Server/H11DSi-NT, BIOS 1.1 04/13/2018
[ 6775.332839] Call Trace:
[ 6775.334112]  <IRQ>
[ 6775.334957]  dump_stack+0x50/0x6b
[ 6775.337099]  nmi_cpu_backtrace+0x90/0xa0
[ 6775.339848]  ? lapic_can_unplug_cpu+0xa0/0xa0
[ 6775.343038]  nmi_trigger_cpumask_backtrace+0x6f/0x100
[ 6775.346926]  rcu_dump_cpu_stacks+0x8f/0xbf
[ 6775.349849]  rcu_sched_clock_irq+0x517/0x790
[ 6775.352947]  ? tick_init_highres+0x20/0x20
[ 6775.355875]  update_process_times+0x24/0x50
[ 6775.358891]  tick_sched_timer+0x51/0x160
[ 6775.361654]  __hrtimer_run_queues+0xec/0x260
[ 6775.364764]  hrtimer_interrupt+0x122/0x270
[ 6775.367689]  ? rcu_irq_enter+0x35/0x110
[ 6775.370498]  smp_apic_timer_interrupt+0x6a/0x140
[ 6775.373951]  apic_timer_interrupt+0xf/0x20
[ 6775.376887]  </IRQ>
[ 6775.377810] RIP: 0010:queued_write_lock_slowpath+0x51/0x80
[ 6775.382133] Code: ff 00 00 00 f0 0f b1 13 85 c0 74 32 f0 81 03 00 01 00 00 ba ff 00 00 00 b9 00 01 00 00 8b 03 3d 00 01 00 00 74 0b f3 90 8b 03 <3d> 00 01 00 00 75 f5 89 c8 f0 0f b1 13 3d 00 01 00 00 75 df c6 43
[ 6775.399890] RSP: 0018:ffff8df85fc9bc70 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 6775.406369] RAX: 0000000000003b00 RBX: ffff8b3d8743b39c RCX: 0000000000000100
[ 6775.412419] RDX: 00000000000000ff RSI: ffff8df824d4c000 RDI: ffff8b3d8743b3a0
[ 6775.418504] RBP: ffff8b3d8743b39c R08: 000ffffffffff000 R09: 0000000000000000
[ 6775.424528] R10: ffff8df824d4c000 R11: 000000000000000a R12: ffff8df824d42000
[ 6775.430505] R13: 00000000000009f3 R14: ffff8df8f73d5080 R15: 00000000013ea8d0
[ 6775.436513]  copy_counters_to_user.part.13+0x3d/0xa0
[ 6775.440364]  copy_everything_to_user+0x4ca/0x510
[ 6775.443813]  do_ebt_get_ctl+0x9a/0x1b0
[ 6775.446487]  ? mem_cgroup_commit_charge+0x4a/0xa0
[ 6775.450027]  nf_getsockopt+0x48/0x60
[ 6775.452496]  ip_getsockopt+0x6d/0xb0
[ 6775.454906]  __sys_getsockopt+0x8d/0x100
[ 6775.457662]  __x64_sys_getsockopt+0x20/0x30
[ 6775.460673]  do_syscall_64+0x54/0x280
[ 6775.463172]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 6775.467056] RIP: 0033:0x7f35e1d9f40a
[ 6775.469520] Code: 48 8b 0d 81 ba 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4e ba 2b 00 f7 d8 64 89 01 48
[ 6775.487403] RSP: 002b:00007fff5491c5e8 EFLAGS: 00000217 ORIG_RAX: 0000000000000037
[ 6775.493810] RAX: ffffffffffffffda RBX: 00007fff5491c630 RCX: 00007f35e1d9f40a
[ 6775.499781] RDX: 0000000000000081 RSI: 0000000000000000 RDI: 0000000000000003
[ 6775.505750] RBP: 0000000000000000 R08: 00007fff5491c6ac R09: 0000000000000000
[ 6775.511720] R10: 00007fff5491c630 R11: 0000000000000217 R12: 00007f35e509a648
[ 6775.517695] R13: 00007fff5491c6ac R14: 0000000000000000 R15: 0000000000000000

- https://us-east-1.linodeobjects.com/caker/LKML/config-5.5.9-1
- https://us-east-1.linodeobjects.com/caker/LKML/vmlinuz-5.5.9-1
- https://us-east-1.linodeobjects.com/caker/LKML/ebdie.sh (a few of these in the bg is effective)


NOTE: We do have two in-house patches we apply to add ebtables comment and ebtables ipset support. These patches were essentially copied from their IP equivalents. However, we're able to trigger the following bug without those two modules loaded:


------------[ cut here ]------------
NETDEV WATCHDOG: eth1 (mlx5_core): transmit queue 5 timed out
WARNING: CPU: 41 PID: 0 at net/sched/sch_generic.c:448 dev_watchdog+0x22f/0x240
Modules linked in: cls_u32 sch_ingress act_police xt_comment xt_u32 xt_physdev xt_multiport xt_set nf_conntrack_net
link xt_CT xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 tun ebt_ip6 ebt_ip ebt_limit ebt_arp ip_set_hash_net ip_set ip6table_raw ip6table_m
angle ip6_tables iptable_raw iptable_filter ip_tables bpfilter ebtable_nat 8021q mrp bonding amd64_edac_mod kvm_amd kvm irqbypass crct10dif_pclmul crc
32_pclmul mlx5_core crc32c_intel evdev fuse autofs4
CPU: 41 PID: 0 Comm: swapper/41 Not tainted 5.4.25-1 #1
Hardware name: Supermicro Super Server/H11DSi-NT, BIOS 1.1 04/13/2018
RIP: 0010:dev_watchdog+0x22f/0x240
Code: c0 75 e4 eb 98 4c 89 ef c6 05 e9 6d ce 00 01 e8 67 8f fb ff 89 d9 48 89 c2 4c 89 ee 48 c7 c7 d0 d8 3d 8d 31 c
link xt_CT xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 tun ebt_ip6 ebt_ip ebt_limit ebt_arp ip_set_hash_net ip_set ip6table_raw ip6table_m
angle ip6_tables iptable_raw iptable_filter ip_tables bpfilter ebtable_nat 8021q mrp bonding amd64_edac_mod kvm_amd kvm irqbypass crct10dif_pclmul crc
32_pclmul mlx5_core crc32c_intel evdev fuse autofs4
CPU: 41 PID: 0 Comm: swapper/41 Not tainted 5.4.25-1 #1
Hardware name: Supermicro Super Server/H11DSi-NT, BIOS 1.1 04/13/2018
RIP: 0010:dev_watchdog+0x22f/0x240
Code: c0 75 e4 eb 98 4c 89 ef c6 05 e9 6d ce 00 01 e8 67 8f fb ff 89 d9 48 89 c2 4c 89 ee 48 c7 c7 d0 d8 3d 8d 31 c
0 e8 81 53 5f ff <0f> 0b e9 75 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
RSP: 0018:ffffaa344d044ea0 EFLAGS: 00010286
RAX: 000000000000003d RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff9f70ef865080 RSI: ffff9f70ef856618 RDI: ffff9f70ef856618
RBP: ffff9f70e3c80480 R08: 0000000000000000 R09: 00000000000009ce
R10: 000000ebc9cd75c0 R11: 0000000000000000 R12: 00000000000001f8
R13: ffff9f70e3c80000 R14: 00000001000ae000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff9f70ef840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe4fa769028 CR3: 0000005f99d66000 CR4: 00000000003406e0
Call Trace:
<IRQ>
? dev_deactivate_queue.constprop.60+0x90/0x90
call_timer_fn+0x2d/0x140
run_timer_softirq+0x16a/0x1e0
? timerqueue_add+0x5e/0x70
? enqueue_hrtimer+0x3a/0x90
? __hrtimer_run_queues+0x11c/0x260
__do_softirq+0x117/0x2d0
irq_exit+0x5a/0x60
smp_apic_timer_interrupt+0x74/0x140
apic_timer_interrupt+0xf/0x20
</IRQ>
RIP: 0010:cpuidle_enter_state+0xc5/0x420
Code: c7 0f 1f 44 00 00 31 ff e8 c8 0b 6d ff 80 7c 24 0f 00 74 12 9c 58 f6 c4 02 0f 85 2a 03 00 00 31 ff e8 4f 66 72 ff fb 45 85 f6 <0f> 88 84 02 00 00 4c 2b 7c 24 10 49 63 ce 48 ba cf f7 53 e3 a5 9b
RSP: 0018:ffffaa344c657e90 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: ffff9f70ef867c80 RBX: ffff9f60e9303400 RCX: 000000000000001f
RDX: 0000000000000000 RSI: 000002473351b006 RDI: 0000000000000000
RBP: ffffffff8d6f8b80 R08: ffffffe2d30f09e7 R09: 0000000000000070
R10: 0000000000000098 R11: 0000000000010000 R12: 0000000000000029
R13: 0000000000000029 R14: 0000000000000001 R15: 000000ebd1985923
cpuidle_enter+0x2f/0x40
Code: c7 0f 1f 44 00 00 31 ff e8 c8 0b 6d ff 80 7c 24 0f 00 74 12 9c 58 f6 c4 02 0f 85 2a 03 00 00 31 ff e8 4f 66 72 ff fb 45 85 f6 <0f> 88 84 02 00 00 4c 2b 7c 24 10 49 63 ce 48 ba cf f7 53 e3 a5 9b
RSP: 0018:ffffaa344c657e90 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: ffff9f70ef867c80 RBX: ffff9f60e9303400 RCX: 000000000000001f
RDX: 0000000000000000 RSI: 000002473351b006 RDI: 0000000000000000
RBP: ffffffff8d6f8b80 R08: ffffffe2d30f09e7 R09: 0000000000000070
R10: 0000000000000098 R11: 0000000000010000 R12: 0000000000000029
R13: 0000000000000029 R14: 0000000000000001 R15: 000000ebd1985923
cpuidle_enter+0x2f/0x40
do_idle+0x10b/0x1c0
cpu_startup_entry+0x19/0x20
secondary_startup_64+0xa4/0xb0
---[ end trace 97959de9cd2c1919 ]---
hrtimer: interrupt took 8720 ns
mlx5_core 0000:13:00.0: modify lag map port 1:1 port 2:1
mlx5_core 0000:13:00.0: modify lag map port 1:1 port 2:2

We have output from other kernel versions crashing and are happy to provide or test anything we can to help get this resolved.

Thanks,
-Chris

