Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAF81743E2
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgB2AqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:46:17 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39244 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB2AqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:46:17 -0500
Received: by mail-ed1-f68.google.com with SMTP id m13so5489535edb.6
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 16:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p3QTXz+nIO8Jf4tAk1sGo/7GBre6AV11fFZ4v0DGOUY=;
        b=M08gyMPYFwHXiR69GbhRhTTdkvWYofjimCBL45axBtQEfzm6GZRzEMyTvt18PxJ9ah
         YhFyOozyFjTFZxRunqxToWzVulMUMmhivNcZFE73CXDmRGaMgi4gy0pBX+U15S+gYo71
         FQdYpwySleNWt4INjGSIs8y4UsIYs3c45M/YUD7BH7HYUpNWE6YnyW2xiFbasJdX4k1K
         Nls2yvuZnEIim4QeG5tGbhsv1dgnhaPgUKmJ9X/pgw0OmWS2sScv0faDD62FgbNu2kuK
         alQI3lRuHvZz7OfpzOPYwpNfiBmY2xSY9L/xGBlQMqjaUCzD/cnt5j/O+om3KLhqg0x9
         gMoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p3QTXz+nIO8Jf4tAk1sGo/7GBre6AV11fFZ4v0DGOUY=;
        b=A/A9Kjo6thUWsHfv8YQhlXUXM/CKIB12WFF6ZX0zu5u0iqfYVQgnkpxlXVFmG4blnp
         3vcETOYPJh6qqnOP4rNJR4L2MAJCyGAvquNNGNoOHeBlT8ZTlmoUi4WCAcQDuBfhFk/T
         pV1IwdCE3KwM+NP5T5LazH+spDomM3pacHrpaTYwegQyBJqHGoFJkznb3B8G4S8nr5xh
         DvqaAcSos8k/05rxCoNNk38CO4htegiUi+cFZiqVgvEFyz3jsjtVGxBPUMcfJWzvFRIp
         f8dNPkAv4ClwRd/R10kmBhcPAHD1oMTiqz03SnErMdu/IAi7N6k+a075qFekGQE5Jvu1
         c6zg==
X-Gm-Message-State: APjAAAXTEJEM65x7nyJygdjA5rZVy0Tn+shmGSybZCjf5VN3R6q5LO88
        RXnX8p5HmjE1OU3h4Mj2ptrnOZWVTpPke8aUKGM=
X-Google-Smtp-Source: APXvYqyPwTzRxt/nGujfMAUXOC7oxdxSY2xGsIQM6HjJFYp8OpdRNNJ3xTa92YVNe5ybxDh77OxsylK/a9Sdq4f7Qs0=
X-Received: by 2002:a17:906:9501:: with SMTP id u1mr6006662ejx.113.1582937174856;
 Fri, 28 Feb 2020 16:46:14 -0800 (PST)
MIME-Version: 1.0
References: <E1j7lU0-0003pp-Ff@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1j7lU0-0003pp-Ff@rmk-PC.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 29 Feb 2020 02:46:04 +0200
Message-ID: <CA+h21hrcZbSvpvM4JDHnnb98ddhe9KpaPb2ni7OzaLcwBHHA8A@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: fix phylink_start()/phylink_stop() calls
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Fri, 28 Feb 2020 at 21:39, Russell King <rmk+kernel@armlinux.org.uk> wrote:
>
> Place phylink_start()/phylink_stop() inside dsa_port_enable() and
> dsa_port_disable(), which ensures that we call phylink_stop() before
> tearing down phylink - which is a documented requirement.  Failure
> to do so can cause use-after-free bugs.
>
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---

Thanks for the patch!
With the ocelot/felix driver, which uses the pcs_poll functionality
(and therefore the link timer), this is the behavior on unbind without
this patch:

# echo 0000\:00\:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
[   70.183056] DSA: tree 0 torn down
# [   70.490562] Unable to handle kernel paging request at virtual
address 00646d692d352e38
[   70.498994] Mem abort info:
[   70.501792]   ESR = 0x96000044
[   70.504854]   EC = 0x25: DABT (current EL), IL = 32 bits
[   70.510182]   SET = 0, FnV = 0
[   70.513242]   EA = 0, S1PTW = 0
[   70.516389] Data abort info:
[   70.519274]   ISV = 0, ISS = 0x00000044
[   70.523119]   CM = 0, WnR = 1
[   70.526092] [00646d692d352e38] address between user and kernel address ranges
[   70.533253] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[   70.538843] Modules linked in:
[   70.541907] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
5.6.0-rc2-00778-gc494e38c83ed #383
[   70.550025] Hardware name: LS1028A RDB Board (DT)
[   70.554743] pstate: 60000085 (nZCv daIf -PAN -UAO)
[   70.559549] pc : run_timer_softirq+0x520/0x6e0
[   70.564005] lr : run_timer_softirq+0x678/0x6e0
[   70.568461] sp : ffff800010003e10
[   70.571783] x29: ffff800010003e10 x28: ffffdb930e5f2ea0
[   70.577113] x27: ffffdb930e5f0000 x26: 0000000000000000
[   70.582443] x25: ffff00205829c8a0 x24: dead000000000122
[   70.587772] x23: 00000000ffff1fc0 x22: ffff800010003e80
[   70.593102] x21: ffff00207f7c09c0 x20: ffffdb930e2f1b20
[   70.598431] x19: ffffdb930dbee018 x18: 0000000000000000
[   70.603760] x17: 0000000000000000 x16: 0000000000000000
[   70.609089] x15: 0000000000000000 x14: 003d090000000000
[   70.614419] x13: 00003d08f8004540 x12: 0000000007ffbac0
[   70.619748] x11: 0000000000000002 x10: ffff00207f7c0a60
[   70.625077] x9 : 0000000000000001 x8 : 0000000000000000
[   70.630405] x7 : ffff800010003e88 x6 : ffff00207f7c0a18
[   70.635734] x5 : 8000000000000000 x4 : 0000000000000000
[   70.641063] x3 : 0000000000000001 x2 : 6f9d4d2bf8c48e00
[   70.646392] x1 : ffff800010003e80 x0 : 69646d692d352e30
[   70.651722] Call trace:
[   70.654173]  run_timer_softirq+0x520/0x6e0
[   70.658280]  __do_softirq+0x118/0x568
[   70.661952]  irq_exit+0x13c/0x148
[   70.665275]  __handle_domain_irq+0x6c/0xc0
[   70.669382]  gic_handle_irq+0x6c/0x160
[   70.673140]  el1_irq+0xbc/0x180
[   70.676287]  cpuidle_enter_state+0xb4/0x4e8
[   70.680482]  cpuidle_enter+0x3c/0x50
[   70.684066]  call_cpuidle+0x44/0x78
[   70.687563]  do_idle+0x228/0x2c8
[   70.690799]  cpu_startup_entry+0x28/0x48
[   70.694732]  rest_init+0x1ac/0x280
[   70.698143]  arch_call_rest_init+0x14/0x1c
[   70.702251]  start_kernel+0x728/0x758
[   70.705925] Code: 370008c1 a9400720 f9000020 b4000040 (f9000401)
[   70.712040]
[   70.712042] ======================================================
[   70.712043] WARNING: possible circular locking dependency detected
[   70.712045] 5.6.0-rc2-00778-gc494e38c83ed #383 Not tainted
[   70.712046] ------------------------------------------------------
[   70.712048] swapper/0/0 is trying to acquire lock:
[   70.712049] ffffdb930e323978 (console_owner){-.-.}, at:
console_unlock+0x1e4/0x5c8
[   70.712054]
[   70.712056] but task is already holding lock:
[   70.712057] ffff00207f7c09d8 (&base->lock){-.-.}, at:
run_timer_softirq+0x3d0/0x6e0
[   70.712062]
[   70.712063] which lock already depends on the new lock.
[   70.712064]
[   70.712066]
[   70.712067] the existing dependency chain (in reverse order) is:
[   70.712068]
[   70.712069] -> #3 (&base->lock){-.-.}:
[   70.712074]        _raw_spin_lock_irqsave+0x60/0x80
[   70.712075]        lock_timer_base+0x98/0xc8
[   70.712077]        mod_timer+0x1dc/0x330
[   70.712078]        worker_enter_idle+0x100/0x120
[   70.712079]        worker_thread+0x9c/0x498
[   70.712080]        kthread+0x138/0x140
[   70.712082]        ret_from_fork+0x10/0x18
[   70.712083]
[   70.712084] -> #2 (&pool->lock/1){-.-.}:
[   70.712089]        _raw_spin_lock+0x44/0x58
[   70.712091]        __queue_work+0x114/0x790
[   70.712092]        queue_work_on+0xd0/0xf0
[   70.712093]        tty_flip_buffer_push+0x3c/0x48
[   70.712094]        serial8250_rx_chars+0x74/0x88
[   70.712096]        fsl8250_handle_irq+0x15c/0x1a0
[   70.712097]        serial8250_interrupt+0x7c/0x130
[   70.712099]        __handle_irq_event_percpu+0xb8/0x448
[   70.712100]        handle_irq_event_percpu+0x40/0x98
[   70.712101]        handle_irq_event+0x4c/0xd0
[   70.712103]        handle_fasteoi_irq+0xb4/0x158
[   70.712104]        generic_handle_irq+0x34/0x50
[   70.712105]        __handle_domain_irq+0x68/0xc0
[   70.712106]        gic_handle_irq+0x6c/0x160
[   70.712108]        el1_irq+0xbc/0x180
[   70.712109]        cpuidle_enter_state+0xb4/0x4e8
[   70.712110]        cpuidle_enter+0x3c/0x50
[   70.712111]        call_cpuidle+0x44/0x78
[   70.712113]        do_idle+0x228/0x2c8
[   70.712114]        cpu_startup_entry+0x2c/0x48
[   70.712115]        rest_init+0x1ac/0x280
[   70.712117]        arch_call_rest_init+0x14/0x1c
[   70.712118]        start_kernel+0x728/0x758
[   70.712119]
[   70.712120] -> #1 (&port_lock_key){-.-.}:
[   70.712125]        _raw_spin_lock_irqsave+0x60/0x80
[   70.712126]        serial8250_console_write+0x170/0x2a0
[   70.712127]        univ8250_console_write+0x44/0x58
[   70.712129]        console_unlock+0x43c/0x5c8
[   70.712130]        vprintk_emit+0x174/0x350
[   70.712131]        vprintk_default+0x48/0x58
[   70.712132]        vprintk_func+0xe8/0x230
[   70.712134]        printk+0x74/0x94
[   70.712135]        register_console+0x2c0/0x3b0
[   70.712136]        uart_add_one_port+0x4a0/0x4e0
[   70.712138]        serial8250_register_8250_port+0x2bc/0x498
[   70.712139]        of_platform_serial_probe+0x310/0x640
[   70.712140]        platform_drv_probe+0x58/0xa8
[   70.712141]        really_probe+0x284/0x470
[   70.712143]        driver_probe_device+0x12c/0x148
[   70.712144]        device_driver_attach+0x74/0x98
[   70.712145]        __driver_attach+0xc4/0x170
[   70.712146]        bus_for_each_dev+0x84/0xd8
[   70.712148]        driver_attach+0x30/0x40
[   70.712149]        bus_add_driver+0x18c/0x258
[   70.712150]        driver_register+0x64/0x110
[   70.712152]        __platform_driver_register+0x58/0x68
[   70.712153]        of_platform_serial_driver_init+0x20/0x28
[   70.712154]        do_one_initcall+0x94/0x438
[   70.712156]        kernel_init_freeable+0x278/0x2e0
[   70.712157]        kernel_init+0x18/0x110
[   70.712158]        ret_from_fork+0x10/0x18
[   70.712159]
[   70.712160] -> #0 (console_owner){-.-.}:
[   70.712165]        __lock_acquire+0x1088/0x1530
[   70.712166]        lock_acquire+0xe8/0x268
[   70.712167]        console_unlock+0x23c/0x5c8
[   70.712169]        vprintk_emit+0x174/0x350
[   70.712170]        vprintk_default+0x48/0x58
[   70.712171]        vprintk_func+0xe8/0x230
[   70.712172]        printk+0x74/0x94
[   70.712174]        die_kernel_fault+0x44/0x7c
[   70.712175]        __do_kernel_fault+0x130/0x170
[   70.712176]        do_translation_fault+0x6c/0xc0
[   70.712178]        do_mem_abort+0x50/0xb0
[   70.712179]        el1_sync_handler+0xd8/0x108
[   70.712180]        el1_sync+0x7c/0x100
[   70.712181]        run_timer_softirq+0x520/0x6e0
[   70.712183]        __do_softirq+0x118/0x568
[   70.712184]        irq_exit+0x13c/0x148
[   70.712185]        __handle_domain_irq+0x6c/0xc0
[   70.712187]        gic_handle_irq+0x6c/0x160
[   70.712188]        el1_irq+0xbc/0x180
[   70.712189]        cpuidle_enter_state+0xb4/0x4e8
[   70.712190]        cpuidle_enter+0x3c/0x50
[   70.712192]        call_cpuidle+0x44/0x78
[   70.712193]        do_idle+0x228/0x2c8
[   70.712194]        cpu_startup_entry+0x28/0x48
[   70.712195]        rest_init+0x1ac/0x280
[   70.712197]        arch_call_rest_init+0x14/0x1c
[   70.712198]        start_kernel+0x728/0x758
[   70.712199]
[   70.712200] other info that might help us debug this:
[   70.712201]
[   70.712202] Chain exists of:
[   70.712203]   console_owner --> &pool->lock/1 --> &base->lock
[   70.712211]
[   70.712212]  Possible unsafe locking scenario:
[   70.712213]
[   70.712214]        CPU0                    CPU1
[   70.712215]        ----                    ----
[   70.712216]   lock(&base->lock);
[   70.712220]                                lock(&pool->lock/1);
[   70.712223]                                lock(&base->lock);
[   70.712226]   lock(console_owner);
[   70.712229]
[   70.712231]  *** DEADLOCK ***
[   70.712232]
[   70.712233] 2 locks held by swapper/0/0:
[   70.712234]  #0: ffff00207f7c09d8 (&base->lock){-.-.}, at:
run_timer_softirq+0x3d0/0x6e0
[   70.712240]  #1: ffffdb930e323878 (console_lock){+.+.}, at:
vprintk_emit+0x16c/0x350
[   70.712246]
[   70.712247] stack backtrace:
[   70.712248] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
5.6.0-rc2-00778-gc494e38c83ed #383
[   70.712250] Hardware name: LS1028A RDB Board (DT)
[   70.712251] Call trace:
[   70.712252]  dump_backtrace+0x0/0x1d8
[   70.712253]  show_stack+0x24/0x30
[   70.712254]  dump_stack+0xe8/0x150
[   70.712256]  print_circular_bug.isra.41+0x1b8/0x210
[   70.712257]  check_noncircular+0x154/0x1b8
[   70.712258]  __lock_acquire+0x1088/0x1530
[   70.712259]  lock_acquire+0xe8/0x268
[   70.712261]  console_unlock+0x23c/0x5c8
[   70.712262]  vprintk_emit+0x174/0x350
[   70.712263]  vprintk_default+0x48/0x58
[   70.712264]  vprintk_func+0xe8/0x230
[   70.712265]  printk+0x74/0x94
[   70.712267]  die_kernel_fault+0x44/0x7c
[   70.712268]  __do_kernel_fault+0x130/0x170
[   70.712269]  do_translation_fault+0x6c/0xc0
[   70.712270]  do_mem_abort+0x50/0xb0
[   70.712272]  el1_sync_handler+0xd8/0x108
[   70.712273]  el1_sync+0x7c/0x100
[   70.712274]  run_timer_softirq+0x520/0x6e0
[   70.712275]  __do_softirq+0x118/0x568
[   70.712276]  irq_exit+0x13c/0x148
[   70.712278]  __handle_domain_irq+0x6c/0xc0
[   70.712279]  gic_handle_irq+0x6c/0x160
[   70.712280]  el1_irq+0xbc/0x180
[   70.712281]  cpuidle_enter_state+0xb4/0x4e8
[   70.712282]  cpuidle_enter+0x3c/0x50
[   70.712284]  call_cpuidle+0x44/0x78
[   70.712285]  do_idle+0x228/0x2c8
[   70.712286]  cpu_startup_entry+0x28/0x48
[   70.712287]  rest_init+0x1ac/0x280
[   70.712288]  arch_call_rest_init+0x14/0x1c
[   70.712289]  start_kernel+0x728/0x758
[   71.385911] ---[ end trace 8d1de617361f13c3 ]---
[   71.390542] Kernel panic - not syncing: Fatal exception in interrupt
[   71.396919] SMP: stopping secondary CPUs
[   71.400857] Kernel Offset: 0x5b92fbe00000 from 0xffff800010000000
[   71.406968] PHYS_OFFSET: 0xffff83ed40000000
[   71.411163] CPU features: 0x10002,21806008
[   71.415269] Memory Limit: none
[   71.418338] Rebooting in 3 seconds..

And this is the behavior with your patch (repeatable up to 5 times, I
hope it should be enough):

# echo 0000\:00\:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
[  200.232598] mscc_felix 0000:00:00.5: Link is Down
[  200.251843] DSA: tree 0 torn down

So you can add my:

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  net/dsa/dsa_priv.h |  2 ++
>  net/dsa/port.c     | 32 ++++++++++++++++++++++++++------
>  net/dsa/slave.c    |  8 ++------
>  3 files changed, 30 insertions(+), 12 deletions(-)
>
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index a7662e7a691d..5099a337c9cc 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -117,7 +117,9 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
>  /* port.c */
>  int dsa_port_set_state(struct dsa_port *dp, u8 state,
>                        struct switchdev_trans *trans);
> +int dsa_port_enable_locked(struct dsa_port *dp, struct phy_device *phy);
>  int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
> +void dsa_port_disable_locked(struct dsa_port *dp);
>  void dsa_port_disable(struct dsa_port *dp);
>  int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
>  void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 774facb8d547..96f074670140 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -63,12 +63,15 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state)
>                 pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
>  }
>
> -int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
> +int dsa_port_enable_locked(struct dsa_port *dp, struct phy_device *phy)
>  {
>         struct dsa_switch *ds = dp->ds;
>         int port = dp->index;
>         int err;
>
> +       if (dp->pl)
> +               phylink_start(dp->pl);
> +
>         if (ds->ops->port_enable) {
>                 err = ds->ops->port_enable(ds, port, phy);
>                 if (err)
> @@ -81,7 +84,18 @@ int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
>         return 0;
>  }
>
> -void dsa_port_disable(struct dsa_port *dp)
> +int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
> +{
> +       int err;
> +
> +       rtnl_lock();
> +       err = dsa_port_enable_locked(dp, phy);
> +       rtnl_unlock();
> +
> +       return err;
> +}
> +
> +void dsa_port_disable_locked(struct dsa_port *dp)
>  {
>         struct dsa_switch *ds = dp->ds;
>         int port = dp->index;
> @@ -91,6 +105,16 @@ void dsa_port_disable(struct dsa_port *dp)
>
>         if (ds->ops->port_disable)
>                 ds->ops->port_disable(ds, port);
> +
> +       if (dp->pl)
> +               phylink_stop(dp->pl);
> +}
> +
> +void dsa_port_disable(struct dsa_port *dp)
> +{
> +       rtnl_lock();
> +       dsa_port_disable_locked(dp);
> +       rtnl_unlock();
>  }
>
>  int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
> @@ -614,10 +638,6 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
>                 goto err_phy_connect;
>         }
>
> -       rtnl_lock();
> -       phylink_start(dp->pl);
> -       rtnl_unlock();
> -
>         return 0;
>
>  err_phy_connect:
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 088c886e609e..36523e942983 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -88,12 +88,10 @@ static int dsa_slave_open(struct net_device *dev)
>                         goto clear_allmulti;
>         }
>
> -       err = dsa_port_enable(dp, dev->phydev);
> +       err = dsa_port_enable_locked(dp, dev->phydev);
>         if (err)
>                 goto clear_promisc;
>
> -       phylink_start(dp->pl);
> -
>         return 0;
>
>  clear_promisc:
> @@ -114,9 +112,7 @@ static int dsa_slave_close(struct net_device *dev)
>         struct net_device *master = dsa_slave_to_master(dev);
>         struct dsa_port *dp = dsa_slave_to_port(dev);
>
> -       phylink_stop(dp->pl);
> -
> -       dsa_port_disable(dp);
> +       dsa_port_disable_locked(dp);
>
>         dev_mc_unsync(master, dev);
>         dev_uc_unsync(master, dev);
> --
> 2.20.1
>

Regards,
-Vladimir
