Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30E2599309
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 04:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243915AbiHSC3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 22:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241306AbiHSC3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 22:29:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B32C12C1;
        Thu, 18 Aug 2022 19:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ABDCB82472;
        Fri, 19 Aug 2022 02:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453EBC433D6;
        Fri, 19 Aug 2022 02:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660876147;
        bh=Qw9MjUms9wBvoPnf31Xo0BVSKVtFYLFPGFLpkZAkrHs=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=svvW5ZYZcdWZVHmVOFMAJn6QbKdMChvymvYVKj6yw4av3lRNdIGTBuKx6LmhpmJjY
         Br2lxBG9bf1eKgsV58lTYkEZ2vLB14LFfAVCEHocKNqinGWsn7vIGqe9k+4QGM/tBD
         kmT9SJqKkkGg/EQKj338yG5nGxG10Ig6YV0ACSyNQ+w+BsGgWMPmphts3v6pT67B/n
         /PJo1kLK8+8faomdhkJHuHnujDl67xuBCCHFz8PqVSURFVXPfeMfoNaNhg5w1FcQNJ
         GW9e1qaEL/fMJtlNINVZOyEiOjoLZOfyjzLH1YeLDIa2kxu4AnyHDMU3UqZLwQlcKm
         YZLKlSBuKBjiQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id D3A395C044D; Thu, 18 Aug 2022 19:29:06 -0700 (PDT)
Date:   Thu, 18 Aug 2022 19:29:06 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, rcu@vger.kernel.org,
        Shigeru Yoshida <syoshida@redhat.com>
Subject: Re: kernel splat during boot
Message-ID: <20220819022906.GM2125313@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <CAADnVQKdqYM-Kyy9vez04n1HQkiDs7Y-9rx2V7qNtwkDjrJ=SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKdqYM-Kyy9vez04n1HQkiDs7Y-9rx2V7qNtwkDjrJ=SA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 05:10:47PM -0700, Alexei Starovoitov wrote:
> Hi Paul,
> 
> I see the following splat just booting net-next or bpf-next trees.
> I have lockdep and kasan on (if that matters).
> Is this a known issue?
> 
> [    3.011826] cblist_init_generic: Setting adjustable number of
> callback queues.
> [    3.011880]
> [    3.011883] =============================
> [    3.011885] [ BUG: Invalid wait context ]
> [    3.011889] 5.19.0-14019-g75179e2b7f9a #4201 Not tainted
> [    3.011893] -----------------------------
> [    3.011896] swapper/0/1 is trying to lock:
> [    3.011899] ffffffff85be94b8 (&port_lock_key){....}-{3:3}, at:
> serial8250_console_write+0x5fc/0x640
> [    3.011929] other info that might help us debug this:
> [    3.011931] context-{5:5}
> [    3.011934] 3 locks held by swapper/0/1:
> [    3.011938]  #0: ffffffff8404dae0
> (rcu_tasks_rude.cbs_gbl_lock){....}-{2:2}, at:
> cblist_init_generic+0x27/0x340
> [    3.011964]  #1: ffffffff84041d80 (console_lock){+.+.}-{0:0}, at:
> vprintk_emit+0xda/0x2e0
> [    3.011984]  #2: ffffffff839416e0 (console_owner){....}-{0:0}, at:
> console_emit_next_record.constprop.37+0x1c9/0x4d0
> [    3.012004] stack backtrace:
> [    3.012007] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 5.19.0-14019-g75179e2b7f9a #4201
> [    3.012011] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> [    3.012011] Call Trace:
> [    3.012011]  <TASK>
> [    3.012011]  dump_stack_lvl+0x44/0x57
> [    3.012011]  __lock_acquire.cold.73+0xc7/0x31b
> [    3.012011]  ? lockdep_hardirqs_on_prepare+0x1f0/0x1f0
> [    3.012011]  ? rcu_read_lock_sched_held+0x91/0xc0
> [    3.012011]  ? rcu_read_lock_bh_held+0xa0/0xa0
> [    3.012011]  lock_acquire+0x133/0x380
> [    3.012011]  ? serial8250_console_write+0x5fc/0x640
> [    3.012011]  ? lock_release+0x3b0/0x3b0
> [    3.012011]  _raw_spin_lock_irqsave+0x35/0x50
> [    3.012011]  ? serial8250_console_write+0x5fc/0x640
> [    3.012011]  serial8250_console_write+0x5fc/0x640
> [    3.012011]  ? rcu_read_lock_bh_held+0xa0/0xa0
> [    3.012011]  ? serial8250_default_handle_irq+0x80/0x80
> [    3.012011]  ? lock_release+0x3b0/0x3b0
> [    3.012011]  ? do_raw_spin_lock+0x107/0x1c0
> [    3.012011]  ? rwlock_bug.part.2+0x60/0x60
> [    3.012011]  ? prb_final_commit+0x50/0x50
> [    3.012011]  console_emit_next_record.constprop.37+0x271/0x4d0
> [    3.012011]  ? info_print_ext_header.constprop.38+0x110/0x110
> [    3.012011]  ? rcu_read_lock_sched_held+0x91/0xc0
> [    3.012011]  console_unlock+0x1d8/0x2c0
> [    3.012011]  ? devkmsg_open+0x170/0x170
> [    3.012011]  ? vprintk_emit+0xda/0x2e0
> [    3.012011]  vprintk_emit+0xe3/0x2e0
> [    3.012011]  _printk+0x96/0xb0
> [    3.012011]  ? pm_suspend.cold.6+0x2e3/0x2e3
> [    3.012011]  ? _raw_write_unlock+0x1f/0x30
> [    3.012011]  ? do_raw_spin_lock+0x107/0x1c0
> [    3.012011]  cblist_init_generic.cold.36+0x24/0x32
> [    3.012011]  rcu_init_tasks_generic+0x23/0xf0
> [    3.012011]  kernel_init_freeable+0x1d3/0x38a
> [    3.012011]  ? _raw_spin_unlock_irq+0x24/0x30
> [    3.012011]  ? rest_init+0x1d0/0x1d0
> [    3.012011]  kernel_init+0x18/0x130
> [    3.012011]  ? rest_init+0x1d0/0x1d0
> [    3.012011]  ret_from_fork+0x1f/0x30
> [    3.012011]  </TASK>
> [    3.012029] cblist_init_generic: Setting shift to 3 and lim to 1.
> [    3.013301] cblist_init_generic: Setting shift to 3 and lim to 1.
> [    3.014203] Running RCU-tasks wait API self tests

Does the the patch from Shigeru Yoshida shown below help?

This patch is in my view a workaround for printf() losing the ability
to print from interrupts-diabled sections of code, but maybe it will be
of help to you.

							Thanx, Paul

------------------------------------------------------------------------

From SRS0=JFiA=YG=redhat.com=syoshida@kernel.org Tue Aug  2 09:31:25 2022
From: Shigeru Yoshida <syoshida@redhat.com>
To: paulmck@kernel.org,
	frederic@kernel.org,
	neeraju@quicinc.com,
	josh@joshtriplett.org
Cc: rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	joel@joelfernandes.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shigeru Yoshida <syoshida@redhat.com>
Subject: [PATCH] rcu-tasks: Avoid pr_info() with spin lock in cblist_init_generic()
Date: Wed,  3 Aug 2022 01:22:05 +0900
Message-Id: <20220802162205.817796-1-syoshida@redhat.com>

pr_info() is called with rtp->cbs_gbl_lock spin lock locked.  Because
pr_info() calls printk() that might sleep, this will result in BUG
like below:

[    0.206455] cblist_init_generic: Setting adjustable number of callback queues.
[    0.206463]
[    0.206464] =============================
[    0.206464] [ BUG: Invalid wait context ]
[    0.206465] 5.19.0-00428-g9de1f9c8ca51 #5 Not tainted
[    0.206466] -----------------------------
[    0.206466] swapper/0/1 is trying to lock:
[    0.206467] ffffffffa0167a58 (&port_lock_key){....}-{3:3}, at: serial8250_console_write+0x327/0x4a0
[    0.206473] other info that might help us debug this:
[    0.206473] context-{5:5}
[    0.206474] 3 locks held by swapper/0/1:
[    0.206474]  #0: ffffffff9eb597e0 (rcu_tasks.cbs_gbl_lock){....}-{2:2}, at: cblist_init_generic.constprop.0+0x14/0x1f0
[    0.206478]  #1: ffffffff9eb579c0 (console_lock){+.+.}-{0:0}, at: _printk+0x63/0x7e
[    0.206482]  #2: ffffffff9ea77780 (console_owner){....}-{0:0}, at: console_emit_next_record.constprop.0+0x111/0x330
[    0.206485] stack backtrace:
[    0.206486] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.19.0-00428-g9de1f9c8ca51 #5
[    0.206488] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
[    0.206489] Call Trace:
[    0.206490]  <TASK>
[    0.206491]  dump_stack_lvl+0x6a/0x9f
[    0.206493]  __lock_acquire.cold+0x2d7/0x2fe
[    0.206496]  ? stack_trace_save+0x46/0x70
[    0.206497]  lock_acquire+0xd1/0x2f0
[    0.206499]  ? serial8250_console_write+0x327/0x4a0
[    0.206500]  ? __lock_acquire+0x5c7/0x2720
[    0.206502]  _raw_spin_lock_irqsave+0x3d/0x90
[    0.206504]  ? serial8250_console_write+0x327/0x4a0
[    0.206506]  serial8250_console_write+0x327/0x4a0
[    0.206508]  console_emit_next_record.constprop.0+0x180/0x330
[    0.206511]  console_unlock+0xf7/0x1f0
[    0.206512]  vprintk_emit+0xf7/0x330
[    0.206514]  _printk+0x63/0x7e
[    0.206516]  cblist_init_generic.constprop.0.cold+0x24/0x32
[    0.206518]  rcu_init_tasks_generic+0x5/0xd9
[    0.206522]  kernel_init_freeable+0x15b/0x2a2
[    0.206523]  ? rest_init+0x160/0x160
[    0.206526]  kernel_init+0x11/0x120
[    0.206527]  ret_from_fork+0x1f/0x30
[    0.206530]  </TASK>
[    0.207018] cblist_init_generic: Setting shift to 1 and lim to 1.

This patch moves pr_info() so that it is called without
rtp->cbs_gbl_lock locked.

Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 kernel/rcu/tasks.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 3925e32159b5..d46dd970bf22 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -227,7 +227,6 @@ static void cblist_init_generic(struct rcu_tasks *rtp)
 	if (rcu_task_enqueue_lim < 0) {
 		rcu_task_enqueue_lim = 1;
 		rcu_task_cb_adjust = true;
-		pr_info("%s: Setting adjustable number of callback queues.\n", __func__);
 	} else if (rcu_task_enqueue_lim == 0) {
 		rcu_task_enqueue_lim = 1;
 	}
@@ -256,6 +255,10 @@ static void cblist_init_generic(struct rcu_tasks *rtp)
 		raw_spin_unlock_rcu_node(rtpcp); // irqs remain disabled.
 	}
 	raw_spin_unlock_irqrestore(&rtp->cbs_gbl_lock, flags);
+
+	if (rcu_task_cb_adjust)
+		pr_info("%s: Setting adjustable number of callback queues.\n", __func__);
+
 	pr_info("%s: Setting shift to %d and lim to %d.\n", __func__, data_race(rtp->percpu_enqueue_shift), data_race(rtp->percpu_enqueue_lim));
 }
 
-- 
2.37.1


