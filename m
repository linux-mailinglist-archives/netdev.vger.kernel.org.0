Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABABD32C9C4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242857AbhCDBMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1453017AbhCDAlR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 19:41:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82FF264E51;
        Thu,  4 Mar 2021 00:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614818436;
        bh=jwIQue5ED+l/+m/HVgX1Ad5H+tP2gso4JEfV/YeNyAM=;
        h=Date:From:To:Cc:Subject:From;
        b=bvHKNi3Do5hE6gQxIrowlDt2hSUVcw1I0Sh7PqozQ8cJ5N7BqK1TtCoifhctA3WjT
         aywtS8ALqTL5KRSu9GKRpc62HK9TEE254toOAM5F/s35oivD8yjNcXTdYAVp8VdM6h
         GErx/XWfSISNnCw1SJ9K6IV2TlnAODgk5YSG1PSXPVMqy8cVXZozYOK0rX0PUDO7lj
         aj/j3cKXGVm7rVllsXmWYy+sPSm+5a6hruS23Vk3jeIRtKSHxXMCReRClq9hcOEYiN
         GDVRyZcARI38AAqrR+/aeNCTJtXYOLUShhALivd/KbTnvViEenFZpEbX8pdXFYDfjh
         BQ+LLf+luWwXw==
Date:   Wed, 3 Mar 2021 16:40:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     erhard_f@mailbox.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: seqlock lockdep false positives?
Message-ID: <20210303164035.1b9a1d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ahmed!

Erhard is reporting a lockdep splat in drivers/net/ethernet/realtek/8139too.c

https://bugzilla.kernel.org/show_bug.cgi?id=211575

I can't quite grasp how that happens it looks like it's the Rx
lock/syncp on one side and the Tx lock on the other side :S

================================
WARNING: inconsistent lock state
5.12.0-rc1-Pentium4 #2 Not tainted
--------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
c113c804 (&syncp->seq#2){?.-.}-{0:0}, at: rtl8139_poll+0x251/0x350
{IN-HARDIRQ-W} state was registered at:
  lock_acquire+0x239/0x2c5
  do_write_seqcount_begin_nested.constprop.0+0x1a/0x1f
  rtl8139_interrupt+0x346/0x3cb
  __handle_irq_event_percpu+0xe5/0x20c
  handle_irq_event_percpu+0x17/0x3d
  handle_irq_event+0x29/0x42
  handle_fasteoi_irq+0x67/0xd7
  __handle_irq+0x7d/0x9c
  __common_interrupt+0x68/0xc3
  common_interrupt+0x22/0x35
  asm_common_interrupt+0x106/0x180
  _raw_spin_unlock_irqrestore+0x41/0x45
  __mod_timer+0x1cd/0x1d8
  mod_timer+0xa/0xc
  mld_ifc_start_timer+0x24/0x37
  mld_ifc_timer_expire+0x1b0/0x1c0
  call_timer_fn+0xfe/0x201
  __run_timers+0x134/0x159
  run_timer_softirq+0x14/0x27
  __do_softirq+0x15f/0x307
  call_on_stack+0x40/0x46
  do_softirq_own_stack+0x1c/0x1e
  __irq_exit_rcu+0x4f/0x85
  irq_exit_rcu+0x8/0x11
  sysvec_apic_timer_interrupt+0x20/0x2e
  handle_exception_return+0x0/0xaf
  default_idle+0xa/0xc
  arch_cpu_idle+0xd/0xf
  default_idle_call+0x48/0x74
  do_idle+0xb7/0x1c3
  cpu_startup_entry+0x19/0x1b
  rest_init+0x11d/0x120
  arch_call_rest_init+0x8/0xb
  start_kernel+0x417/0x425
  i386_start_kernel+0x43/0x45
  startup_32_smp+0x164/0x168
irq event stamp: 26328
hardirqs last  enabled at (26328): [<c4362e64>] __slab_alloc.constprop.0+0x3e/0x59
hardirqs last disabled at (26327): [<c4362e47>] __slab_alloc.constprop.0+0x21/0x59
softirqs last  enabled at (26314): [<c4789f1f>] __do_softirq+0x2d7/0x307
softirqs last disabled at (26321): [<c420fecb>] call_on_stack+0x40/0x46

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&syncp->seq#2);
  <Interrupt>
    lock(&syncp->seq#2);

 *** DEADLOCK ***

1 lock held by swapper/0/0:
 #0: c113c8a4 (&tp->rx_lock){+.-.}-{2:2}, at: rtl8139_poll+0x31/0x350

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc1-Pentium4 #2
Hardware name:  /FS51, BIOS 6.00 PG 12/02/2003
Call Trace:
 <SOFTIRQ>
 dump_stack+0x78/0xa5
 print_usage_bug+0x17d/0x188
 mark_lock.part.0+0xfd/0x27a
 ? hlock_class+0x18/0x58
 ? mark_lock.part.0+0x33/0x27a
 ? ___slab_alloc.constprop.0+0x2b7/0x2d1
 __lock_acquire+0x458/0x1488
 ? rcu_read_lock_sched_held+0x23/0x4a
 ? trace_kmalloc+0x8c/0xb9
 ? __kmalloc_track_caller+0x130/0x143
 lock_acquire+0x239/0x2c5
 ? rtl8139_poll+0x251/0x350
 ? __alloc_skb+0xb7/0x102
 do_write_seqcount_begin_nested.constprop.0+0x1a/0x1f
 ? rtl8139_poll+0x251/0x350
 rtl8139_poll+0x251/0x350
 __napi_poll+0x24/0xf1
 net_rx_action+0xbb/0x177
 __do_softirq+0x15f/0x307
 ? __entry_text_end+0x5/0x5
 call_on_stack+0x40/0x46
 </SOFTIRQ>
 ? __irq_exit_rcu+0x4f/0x85
 ? irq_exit_rcu+0x8/0x11
 ? common_interrupt+0x27/0x35
 ? asm_common_interrupt+0x106/0x180
 ? ldsem_down_write+0x1f/0x1f
 ? newidle_balance+0x1d0/0x3ab
 ? default_idle+0xa/0xc
 ? __pci_setup_bridge+0x4e/0x64
 ? default_idle+0xa/0xc
 ? arch_cpu_idle+0xd/0xf
 ? default_idle_call+0x48/0x74
 ? do_idle+0xb7/0x1c3
 ? cpu_startup_entry+0x19/0x1b
 ? rest_init+0x11d/0x120
 ? arch_call_rest_init+0x8/0xb
 ? start_kernel+0x417/0x425
 ? i386_start_kernel+0x43/0x45
 ? startup_32_smp+0x164/0x168
