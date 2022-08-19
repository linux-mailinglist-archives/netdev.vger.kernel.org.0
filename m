Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A146359919B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbiHSALC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiHSALB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:11:01 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93A0C9924;
        Thu, 18 Aug 2022 17:11:00 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e13so3772973edj.12;
        Thu, 18 Aug 2022 17:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=um1PvOysNX8tcJMPy/29j9o1fvcMRvnPg0HmnyNEt08=;
        b=d/sduwEWJVEdgVClVtAbd5LLwHkHRKPn4YfCY39Y7iwygwa8OdU6SJmZtUVjwYvn2k
         X+wHJ88/oOQIXPJnwov2yxENi3kV89xHff7yYCMiAGFHrBQ994RmOXG2p1b5vW3WJCL2
         XG63h4396vGtSG7o8QWB4/MJLhsQwtCnueDwB4hqX3ZyOyDp1BlHRPMCJfwx4s3CnjL+
         HjgJrNyUoXnLPPHjE3L/E5BLKqeEjFK56brRlieU949e6clXNrHZVeMl2iOyxnsb6PNA
         6GW17cgGDXvvSDT7zgSoxLiLPOiMTvdrA6Zj08WvwV5oR0PwN854qJgWPdVvnOzvf71/
         D5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=um1PvOysNX8tcJMPy/29j9o1fvcMRvnPg0HmnyNEt08=;
        b=vZ5m5wwQVP8dcjtJJ/7N521m0gQ9JlMXeG4KZwfS12XN2Cbflp8KJ8hSuCASvIgxIc
         iEn2vD0HxjRaXh3kABEiRWBuJCqTIVMaFba5L2CzNCQW8fGorfrNpq56QiqCs1P09/jU
         tOeVt6KyJpmqpWPCmFk5tI07nUnJZTRBrU8AH6wpNiFGPpsfHjnQkv0Al3jlWyK8B9YT
         1TCJY1r2t7Y1FGrfIXyXacWloBx54r80YmvKVmAG1Fpz6E7bPnMwPN8+i5avHQqZZxYA
         PXkGakbil1kYB/RUx3l+0xdFQnbKTBtXTLtLdvZhdR5hQeuy4bLjamhbHTQHpVMHSAcq
         ltMQ==
X-Gm-Message-State: ACgBeo2OxGKhnDQ1Ok6vB+PyQafjuer8ktyzwyM+FRjF45wyGaoji9Ii
        aKquo2JWJDCgA/HjCEEnzBMcTU2nKPIARFAmyiwCkH1m4Ns=
X-Google-Smtp-Source: AA6agR4nYBvozo08BTzceXgiePHekxcjKDCBh6hnceNsUMrhf7EySMj++rLUb0UJdtu0yuvb2cn7XViB3kTAEQMnU1o=
X-Received: by 2002:a05:6402:27ca:b0:43e:ce64:ca07 with SMTP id
 c10-20020a05640227ca00b0043ece64ca07mr4120556ede.66.1660867859182; Thu, 18
 Aug 2022 17:10:59 -0700 (PDT)
MIME-Version: 1.0
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Aug 2022 17:10:47 -0700
Message-ID: <CAADnVQKdqYM-Kyy9vez04n1HQkiDs7Y-9rx2V7qNtwkDjrJ=SA@mail.gmail.com>
Subject: kernel splat during boot
To:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kernel Team <Kernel-team@fb.com>, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

I see the following splat just booting net-next or bpf-next trees.
I have lockdep and kasan on (if that matters).
Is this a known issue?

[    3.011826] cblist_init_generic: Setting adjustable number of
callback queues.
[    3.011880]
[    3.011883] =============================
[    3.011885] [ BUG: Invalid wait context ]
[    3.011889] 5.19.0-14019-g75179e2b7f9a #4201 Not tainted
[    3.011893] -----------------------------
[    3.011896] swapper/0/1 is trying to lock:
[    3.011899] ffffffff85be94b8 (&port_lock_key){....}-{3:3}, at:
serial8250_console_write+0x5fc/0x640
[    3.011929] other info that might help us debug this:
[    3.011931] context-{5:5}
[    3.011934] 3 locks held by swapper/0/1:
[    3.011938]  #0: ffffffff8404dae0
(rcu_tasks_rude.cbs_gbl_lock){....}-{2:2}, at:
cblist_init_generic+0x27/0x340
[    3.011964]  #1: ffffffff84041d80 (console_lock){+.+.}-{0:0}, at:
vprintk_emit+0xda/0x2e0
[    3.011984]  #2: ffffffff839416e0 (console_owner){....}-{0:0}, at:
console_emit_next_record.constprop.37+0x1c9/0x4d0
[    3.012004] stack backtrace:
[    3.012007] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
5.19.0-14019-g75179e2b7f9a #4201
[    3.012011] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[    3.012011] Call Trace:
[    3.012011]  <TASK>
[    3.012011]  dump_stack_lvl+0x44/0x57
[    3.012011]  __lock_acquire.cold.73+0xc7/0x31b
[    3.012011]  ? lockdep_hardirqs_on_prepare+0x1f0/0x1f0
[    3.012011]  ? rcu_read_lock_sched_held+0x91/0xc0
[    3.012011]  ? rcu_read_lock_bh_held+0xa0/0xa0
[    3.012011]  lock_acquire+0x133/0x380
[    3.012011]  ? serial8250_console_write+0x5fc/0x640
[    3.012011]  ? lock_release+0x3b0/0x3b0
[    3.012011]  _raw_spin_lock_irqsave+0x35/0x50
[    3.012011]  ? serial8250_console_write+0x5fc/0x640
[    3.012011]  serial8250_console_write+0x5fc/0x640
[    3.012011]  ? rcu_read_lock_bh_held+0xa0/0xa0
[    3.012011]  ? serial8250_default_handle_irq+0x80/0x80
[    3.012011]  ? lock_release+0x3b0/0x3b0
[    3.012011]  ? do_raw_spin_lock+0x107/0x1c0
[    3.012011]  ? rwlock_bug.part.2+0x60/0x60
[    3.012011]  ? prb_final_commit+0x50/0x50
[    3.012011]  console_emit_next_record.constprop.37+0x271/0x4d0
[    3.012011]  ? info_print_ext_header.constprop.38+0x110/0x110
[    3.012011]  ? rcu_read_lock_sched_held+0x91/0xc0
[    3.012011]  console_unlock+0x1d8/0x2c0
[    3.012011]  ? devkmsg_open+0x170/0x170
[    3.012011]  ? vprintk_emit+0xda/0x2e0
[    3.012011]  vprintk_emit+0xe3/0x2e0
[    3.012011]  _printk+0x96/0xb0
[    3.012011]  ? pm_suspend.cold.6+0x2e3/0x2e3
[    3.012011]  ? _raw_write_unlock+0x1f/0x30
[    3.012011]  ? do_raw_spin_lock+0x107/0x1c0
[    3.012011]  cblist_init_generic.cold.36+0x24/0x32
[    3.012011]  rcu_init_tasks_generic+0x23/0xf0
[    3.012011]  kernel_init_freeable+0x1d3/0x38a
[    3.012011]  ? _raw_spin_unlock_irq+0x24/0x30
[    3.012011]  ? rest_init+0x1d0/0x1d0
[    3.012011]  kernel_init+0x18/0x130
[    3.012011]  ? rest_init+0x1d0/0x1d0
[    3.012011]  ret_from_fork+0x1f/0x30
[    3.012011]  </TASK>
[    3.012029] cblist_init_generic: Setting shift to 3 and lim to 1.
[    3.013301] cblist_init_generic: Setting shift to 3 and lim to 1.
[    3.014203] Running RCU-tasks wait API self tests
