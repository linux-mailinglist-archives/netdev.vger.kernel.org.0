Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B134632FFDD
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 10:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhCGJUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 04:20:32 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39168 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhCGJUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 04:20:12 -0500
Date:   Sun, 7 Mar 2021 10:20:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615108811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8bAHuHfAzFNU5a9mOC3/9M/nvCXj5WRgok5Y4qc3ML8=;
        b=wfnzL3S0PXyJ/lNVR8PNv1rk0rV9XGHlirShjDey9mm/P0Heve+vBtweNQwe77qJYbVeRq
        Dr9pf3xgWSMn83XOVJp0ouehYmEFyJa1oQ1td8TkESCnkARVUASOELAYLXkROKuQfZ3UTV
        3inMN9UnZ7khO0eTk09dpqotZwczvmd8tCnRp6+vW5OTmyQRASdYoa7aUQXYjMhO+H14+b
        Pq6sorVbd09nRRNmSX78n0hUmW0t+cfGLRANN8y12fiMV4wgTaGc+IBp8LjFtYEN1Udl3u
        SrnfPFEewPmnSLyDPQbm8BnDkb8U+4nl9Z44d+uwhhf7B254P+2oJrZdIqpDEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615108811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8bAHuHfAzFNU5a9mOC3/9M/nvCXj5WRgok5Y4qc3ML8=;
        b=aqZSBjPsjJU8XtfNCV0CrXgyDWrtEU+32srMUi6DCz0hB6HkcxII7UEUg9guORFq82Tw0N
        JaTvOM8XVM5GlHAQ==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     erhard_f@mailbox.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: seqlock lockdep false positives?
Message-ID: <YESayEskbtjEWjFd@lx-t490>
References: <20210303164035.1b9a1d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303164035.1b9a1d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Mar 03, 2021 at 04:40:35PM -0800, Jakub Kicinski wrote:
> Hi Ahmed!
>
> Erhard is reporting a lockdep splat in drivers/net/ethernet/realtek/8139too.c
>
> https://bugzilla.kernel.org/show_bug.cgi?id=211575
>
> I can't quite grasp how that happens it looks like it's the Rx
> lock/syncp on one side and the Tx lock on the other side :S
>
> ================================
> WARNING: inconsistent lock state
> 5.12.0-rc1-Pentium4 #2 Not tainted
> --------------------------------
> inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
> swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> c113c804 (&syncp->seq#2){?.-.}-{0:0}, at: rtl8139_poll+0x251/0x350
> {IN-HARDIRQ-W} state was registered at:
>   lock_acquire+0x239/0x2c5
>   do_write_seqcount_begin_nested.constprop.0+0x1a/0x1f
>   rtl8139_interrupt+0x346/0x3cb

That's really weird.

The only way I can see this happening is lockdep mistakenly treating
both "tx_stats->syncp.seq" and "rx_stats->syncp.seq" as the same lockdep
class key... somehow.

It is claiming that the softirq code path at rtl8139_poll() is acquiring
the *tx*_stats sequence counter. But at rtl8139_poll(), I can only see
the *rx*_stats sequence counter getting acquired.

I've re-checked where tx/rx stats sequence counters are initialized, and
I see:

  static struct net_device *rtl8139_init_board(struct pci_dev *pdev)
  {
	...
	u64_stats_init(&tp->rx_stats.syncp);
	u64_stats_init(&tp->tx_stats.syncp);
	...
  }

which means they should have different lockdep class keys.  The
u64_stats sequence counters are also initialized way before any IRQ
handlers are registered.

@Erhard, can you please try below patch? Just want to confirm if this
theory has any validity to it:

diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 1e5a453dea14..c0dbb0418e9d 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -715,6 +715,11 @@ static const unsigned int rtl8139_rx_config =
 static const unsigned int rtl8139_tx_config =
 	TxIFG96 | (TX_DMA_BURST << TxDMAShift) | (TX_RETRY << TxRetryShift);

+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+static struct lock_class_key rx_stats_key;
+static struct lock_class_key tx_stats_key;
+#endif
+
 static void __rtl8139_cleanup_dev (struct net_device *dev)
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
@@ -794,8 +799,17 @@ static struct net_device *rtl8139_init_board(struct pci_dev *pdev)

 	pci_set_master (pdev);

-	u64_stats_init(&tp->rx_stats.syncp);
-	u64_stats_init(&tp->tx_stats.syncp);
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	dev_warn(d, "Manually intializing tx/rx stats sequence counters\n");
+
+	tp->rx_stats.syncp.seq.sequence = 0;
+	lockdep_set_class_and_name(&tp->rx_stats.syncp.seq,
+				   &rx_stats_key, "RX stats");
+
+	tp->tx_stats.syncp.seq.sequence = 0;
+	lockdep_set_class_and_name(&tp->tx_stats.syncp.seq,
+				   &tx_stats_key, "TX stats");
+#endif

 retry:
 	/* PIO bar register comes first. */

I've added Sebastian and Peter in Cc too. Maybe they can provide some
further input.

[ Rest of the lockdep report is left, as-is, below... ]

>   __handle_irq_event_percpu+0xe5/0x20c
>   handle_irq_event_percpu+0x17/0x3d
>   handle_irq_event+0x29/0x42
>   handle_fasteoi_irq+0x67/0xd7
>   __handle_irq+0x7d/0x9c
>   __common_interrupt+0x68/0xc3
>   common_interrupt+0x22/0x35
>   asm_common_interrupt+0x106/0x180
>   _raw_spin_unlock_irqrestore+0x41/0x45
>   __mod_timer+0x1cd/0x1d8
>   mod_timer+0xa/0xc
>   mld_ifc_start_timer+0x24/0x37
>   mld_ifc_timer_expire+0x1b0/0x1c0
>   call_timer_fn+0xfe/0x201
>   __run_timers+0x134/0x159
>   run_timer_softirq+0x14/0x27
>   __do_softirq+0x15f/0x307
>   call_on_stack+0x40/0x46
>   do_softirq_own_stack+0x1c/0x1e
>   __irq_exit_rcu+0x4f/0x85
>   irq_exit_rcu+0x8/0x11
>   sysvec_apic_timer_interrupt+0x20/0x2e
>   handle_exception_return+0x0/0xaf
>   default_idle+0xa/0xc
>   arch_cpu_idle+0xd/0xf
>   default_idle_call+0x48/0x74
>   do_idle+0xb7/0x1c3
>   cpu_startup_entry+0x19/0x1b
>   rest_init+0x11d/0x120
>   arch_call_rest_init+0x8/0xb
>   start_kernel+0x417/0x425
>   i386_start_kernel+0x43/0x45
>   startup_32_smp+0x164/0x168
> irq event stamp: 26328
> hardirqs last  enabled at (26328): [<c4362e64>] __slab_alloc.constprop.0+0x3e/0x59
> hardirqs last disabled at (26327): [<c4362e47>] __slab_alloc.constprop.0+0x21/0x59
> softirqs last  enabled at (26314): [<c4789f1f>] __do_softirq+0x2d7/0x307
> softirqs last disabled at (26321): [<c420fecb>] call_on_stack+0x40/0x46
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&syncp->seq#2);
>   <Interrupt>
>     lock(&syncp->seq#2);
>
>  *** DEADLOCK ***
>
> 1 lock held by swapper/0/0:
>  #0: c113c8a4 (&tp->rx_lock){+.-.}-{2:2}, at: rtl8139_poll+0x31/0x350
>
> stack backtrace:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc1-Pentium4 #2
> Hardware name:  /FS51, BIOS 6.00 PG 12/02/2003
> Call Trace:
>  <SOFTIRQ>
>  dump_stack+0x78/0xa5
>  print_usage_bug+0x17d/0x188
>  mark_lock.part.0+0xfd/0x27a
>  ? hlock_class+0x18/0x58
>  ? mark_lock.part.0+0x33/0x27a
>  ? ___slab_alloc.constprop.0+0x2b7/0x2d1
>  __lock_acquire+0x458/0x1488
>  ? rcu_read_lock_sched_held+0x23/0x4a
>  ? trace_kmalloc+0x8c/0xb9
>  ? __kmalloc_track_caller+0x130/0x143
>  lock_acquire+0x239/0x2c5
>  ? rtl8139_poll+0x251/0x350
>  ? __alloc_skb+0xb7/0x102
>  do_write_seqcount_begin_nested.constprop.0+0x1a/0x1f
>  ? rtl8139_poll+0x251/0x350
>  rtl8139_poll+0x251/0x350
>  __napi_poll+0x24/0xf1
>  net_rx_action+0xbb/0x177
>  __do_softirq+0x15f/0x307
>  ? __entry_text_end+0x5/0x5
>  call_on_stack+0x40/0x46
>  </SOFTIRQ>
>  ? __irq_exit_rcu+0x4f/0x85
>  ? irq_exit_rcu+0x8/0x11
>  ? common_interrupt+0x27/0x35
>  ? asm_common_interrupt+0x106/0x180
>  ? ldsem_down_write+0x1f/0x1f
>  ? newidle_balance+0x1d0/0x3ab
>  ? default_idle+0xa/0xc
>  ? __pci_setup_bridge+0x4e/0x64
>  ? default_idle+0xa/0xc
>  ? arch_cpu_idle+0xd/0xf
>  ? default_idle_call+0x48/0x74
>  ? do_idle+0xb7/0x1c3
>  ? cpu_startup_entry+0x19/0x1b
>  ? rest_init+0x11d/0x120
>  ? arch_call_rest_init+0x8/0xb
>  ? start_kernel+0x417/0x425
>  ? i386_start_kernel+0x43/0x45
>  ? startup_32_smp+0x164/0x168
