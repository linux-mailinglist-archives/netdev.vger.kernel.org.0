Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6804DD28D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 02:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiCRBuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 21:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiCRBuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 21:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B21E994F
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4438961678
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 01:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC85C340E9;
        Fri, 18 Mar 2022 01:48:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="f+HxzP5t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1647568136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uaLFkgtdhK4DFYf300wtdxKMbai0wlBBEdcGBBr9HBc=;
        b=f+HxzP5tk7boFzF1EEUl+cOQnVkAtAKHR5k6DLrmY70+Wwdh7TarKjxtbLod+g1h1ep0ri
        nlIWsfnnPxJGmger2N8K9aoVuBX4nFW2uImXjUG1MnDMlbXbw9gMS9BBuK2zpxuOp37opm
        JwDUztRjFDOrRgLTBNNF8jaluXkzzPk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 35b5d94e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 18 Mar 2022 01:48:55 +0000 (UTC)
Date:   Thu, 17 Mar 2022 19:48:51 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, toke@redhat.com
Subject: Re: [PATCH net-next] net: Add lockdep asserts to ____napi_schedule().
Message-ID: <YjPlAyly8FQhPJjT@zx2c4.com>
References: <YitkzkjU5zng7jAM@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YitkzkjU5zng7jAM@linutronix.de>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastian,

On Fri, Mar 11, 2022 at 04:03:42PM +0100, Sebastian Andrzej Siewior wrote:
> ____napi_schedule() needs to be invoked with disabled interrupts due to
> __raise_softirq_irqoff (in order not to corrupt the per-CPU list).
> ____napi_schedule() needs also to be invoked from an interrupt context
> so that the raised-softirq is processed while the interrupt context is
> left.
> 
> Add lockdep asserts for both conditions.
> While this is the second time the irq/softirq check is needed, provide a
> generic lockdep_assert_softirq_will_run() which is used by both caller.

I stumbled upon this commit when noticing a new failure in WireGuard's
test suite:

[    1.338823] ------------[ cut here ]------------
[    1.339289] WARNING: CPU: 0 PID: 11 at ../../../../../../../../net/core/dev.c:4268 __napi_schedule+0xa1/0x300
[    1.340222] CPU: 0 PID: 11 Comm: kworker/0:1 Not tainted 5.17.0-rc8-debug+ #1
[    1.340896] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS d55cb5a 04/01/2014
[    1.341669] Workqueue: wg-crypt-wg0 wg_packet_decrypt_worker
[    1.342207] RIP: 0010:__napi_schedule+0xa1/0x300
[    1.342655] Code: c0 03 0f b6 14 11 38 d0 7c 08 84 d2 0f 85 eb 01 00 00 8b 05 cd a9 0d 01 85 c0 74 1f 65 8b 05 d6 87 7d 7e a9 00 ff 0f 00 75 02 <0f> 0b 65 8b 05 96 8e 7d 7e 85 c0 0f 84 86 01 00 00 4c 8d 73 10 be
[    1.344366] RSP: 0018:ffff888004bc7c98 EFLAGS: 00010046
[    1.344861] RAX: 0000000080000000 RBX: ffff888007570750 RCX: 1ffffffff05251e5
[    1.345532] RDX: 0000000000000000 RSI: ffffffff822e1060 RDI: ffffffff8244c700
[    1.346189] RBP: ffff888036400000 R08: 0000000000000001 R09: ffff888007570767
[    1.346847] R10: ffffed1000eae0ec R11: 0000000000000001 R12: 0000000000000200
[    1.347504] R13: 00000000000364c0 R14: ffff8880078231c0 R15: ffff888007570750
[    1.348193] FS:  0000000000000000(0000) GS:ffff888036400000(0000) knlGS:0000000000000000
[    1.348973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.349505] CR2: 00007ffec7b8ed3c CR3: 0000000002625005 CR4: 0000000000370eb0
[    1.350207] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.350921] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.351587] Call Trace:
[    1.351822]  <TASK>
[    1.352026]  ? napi_schedule_prep+0x37/0x90
[    1.352417]  wg_packet_decrypt_worker+0x2ac/0x470
[    1.352859]  ? lock_is_held_type+0xd7/0x130
[    1.353251]  process_one_work+0x839/0x1380
[    1.353651]  ? rcu_read_unlock+0x40/0x40
[    1.354023]  ? pwq_dec_nr_in_flight+0x230/0x230
[    1.354448]  ? __rwlock_init+0x140/0x140
[    1.354826]  worker_thread+0x593/0xf60
[    1.355180]  ? process_one_work+0x1380/0x1380
[    1.355593]  ? process_one_work+0x1380/0x1380
[    1.356002]  kthread+0x262/0x300
[    1.356308]  ? kthread_exit+0xc0/0xc0
[    1.356656]  ret_from_fork+0x1f/0x30
[    1.357011]  </TASK>

Sounds like wg_packet_decrypt_worker() might be doing something wrong? I
vaguely recall a thread where you started looking into some things there
that seemed non-optimal, but I didn't realize there were correctness
issues. If your patch is correct, and wg_packet_decrypt_worker() is
wrong, do you have a concrete idea of how we should approach fixing
wireguard? Or do you want to send a patch for that?

Jason
