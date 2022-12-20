Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4001651C51
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 09:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbiLTIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 03:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiLTIZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 03:25:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0465FD1;
        Tue, 20 Dec 2022 00:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0yOdjbyBKeATeXcB92POCQhYVLCuEOP2fcG8B0Ly8LY=; b=FAlD/xR/cOWA99CT742YXA7n9e
        DzUMqoCklUiXSnLTnKWzIGJYqM8p+psf7dRQPHYHORdwC0pZB9FOWpr1D8Ft4cp9Rm15jVUULapmd
        0irrxkMVKe5wHuiP8K47Y991ErPLwJxiquvUo5B/Y3XNqZn+7mak2jxDavglJj9lyOTOZXXMZAEwx
        k8f+9N0wowB/7AgBbuoC/lDxIq3FKm3OnNJlpdff/z/iPODiuN00jyaVAkRMHIdXh7weT0/+lCf8e
        u1LKoDhLF0Ng2/xZZPuOlS1bed2dcWA0+Qq0NLrwH4sSWxj4gwZQiwb8EAolmEgZef8WzV0OfixL7
        NRg4eK4Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7Xwa-001avT-PX; Tue, 20 Dec 2022 08:25:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 34374300023;
        Tue, 20 Dec 2022 09:25:36 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1C66320B0EF91; Tue, 20 Dec 2022 09:25:36 +0100 (CET)
Date:   Tue, 20 Dec 2022 09:25:35 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
Message-ID: <Y6Fxfw5fhHhQYaSd@hirez.programming.kicks-ass.net>
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

OK, lemme try this.. still think having to repeat the tree it already
has is daft..

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 13e3c7793e2f


diff --git a/kernel/events/core.c b/kernel/events/core.c
index eacc3702654d..7da593504c5b 100644
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
