Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90E2650D84
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 15:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiLSOkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 09:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiLSOkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 09:40:20 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7782E198;
        Mon, 19 Dec 2022 06:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1unCginLesSkuj4hqRvXqnZG2iVnHjxMfFxmdxmFUXo=; b=nk08+RKg9qmIKScG/E8PNoDGD8
        hdiV25CTyDmHQ5wqh92AaVFwnBpSaGTtp/E0ZrMcnU7JJg3+1wjhCzEVAeHfpeg3XKGfjhBvadv65
        NVupC/8rK/55pvVyr4cSJw/aXhAQChsdODiZsTci9qEhAgh8eo8DHL9zTDseazd36UuENEDDzsaFI
        xMKrEFRngTnYxOUVbQp5hMLcB3py6A80rqmWQ0wDnzLOF6QqAZjLr1oS6Xyqp2D/s0J7vlZ55EBFZ
        B611/nI1s87XhWAkjDhtLwdFfmfoeEXpc+NVC2TeBUHLCEUY30V4NSi8+nNpYKR/nwcs6C0PEmH8p
        DKx8N1aQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p7HJF-00Cd4B-0L;
        Mon, 19 Dec 2022 14:40:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AA9D33001D6;
        Mon, 19 Dec 2022 15:40:04 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6A36020A1AB9C; Mon, 19 Dec 2022 15:40:04 +0100 (CET)
Date:   Mon, 19 Dec 2022 15:40:04 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
Message-ID: <Y6B3xEgkbmFUCeni@hirez.programming.kicks-ass.net>
References: <000000000000a20a2e05f029c577@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000a20a2e05f029c577@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 12:04:43AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    13e3c7793e2f Merge tag 'for-netdev' of https://git.kernel...
> git tree:       bpf
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=177df7e0480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
> dashboard link: https://syzkaller.appspot.com/bug?extid=b8e8c01c8ade4fe6e48f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e87100480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ceeb13880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/373a99daa295/disk-13e3c779.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7fa71ed0fe17/vmlinux-13e3c779.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/2842ad5c698b/bzImage-13e3c779.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __lock_acquire+0x3ee7/0x56d0 kernel/locking/lockdep.c:4925
> Read of size 8 at addr ffff8880237d6018 by task syz-executor287/8300
> 
> CPU: 0 PID: 8300 Comm: syz-executor287 Not tainted 6.1.0-syzkaller-09661-g13e3c7793e2f #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:284 [inline]
>  print_report+0x15e/0x45d mm/kasan/report.c:395
>  kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
>  __lock_acquire+0x3ee7/0x56d0 kernel/locking/lockdep.c:4925
>  lock_acquire kernel/locking/lockdep.c:5668 [inline]
>  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>  _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
>  put_pmu_ctx kernel/events/core.c:4913 [inline]
>  put_pmu_ctx+0xad/0x390 kernel/events/core.c:4893
>  _free_event+0x3c5/0x13d0 kernel/events/core.c:5196
>  free_event+0x58/0xc0 kernel/events/core.c:5224
>  __do_sys_perf_event_open+0x66d/0x2980 kernel/events/core.c:12701
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Does this help?

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e47914ac8732..bbff551783e1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12689,7 +12689,8 @@ SYSCALL_DEFINE5(perf_event_open,
 	return event_fd;
 
 err_context:
-	/* event->pmu_ctx freed by free_event() */
+	put_pmu_ctx(event->pmu_ctx);
+	event->pmu_ctx = NULL; /* _free_event() */
 err_locked:
 	mutex_unlock(&ctx->mutex);
 	perf_unpin_context(ctx);
