Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE0E30A671
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 12:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhBALYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 06:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbhBALYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 06:24:32 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B92C061573;
        Mon,  1 Feb 2021 03:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BjxzCjyvE86hv4IVx4QuIbHwWzdS3+eGyttOKbxAB1s=; b=1UZSHSE/zTgS5jW4wzsPVCDL60
        8VH/s7SxOrxeCDJunG8y0vlAez0DHYRzD2dS1/WLjLRfOxUBT+6DYQ0dRSsPEdvQX5g4BMTuHbyPG
        Ztj21/eGMwfD91RRyEEfwiZBhgDfD+V4jcwLLcKAZTKRFetfuV/qE0xrAqNAyhmZPou9ShTe/8dbh
        2T1go5K2FcC/Jyf+xWf1cMriDQQLhsBg0vBqLc37igYiglgkfe+o3ZH7NFAknT1O9QErYdUgWFYMz
        f1gT+GxD/VoY6ijmbVkYWzbQuYmsfpqk9CBYFT0BZWDPupcMYYWw0bvqUoVwVrlGhf09t+KdBqj5i
        BCK5OPag==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l6XIz-0000G3-Ni; Mon, 01 Feb 2021 11:23:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5AF083011FE;
        Mon,  1 Feb 2021 12:23:39 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4884221A2F1EA; Mon,  1 Feb 2021 12:23:39 +0100 (CET)
Date:   Mon, 1 Feb 2021 12:23:39 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: corrupted pvqspinlock in htab_map_update_elem
Message-ID: <YBfkuyIfB1+VRxXP@hirez.programming.kicks-ass.net>
References: <CACT4Y+YJp0t0HA3+wDsAVxgTK4J+Pvht-J4-ENkOtS=C=Fhtzg@mail.gmail.com>
 <YBfPAvBa8bbSU2nZ@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBfPAvBa8bbSU2nZ@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 10:50:58AM +0100, Peter Zijlstra wrote:

> >  queued_spin_unlock arch/x86/include/asm/qspinlock.h:56 [inline]
> >  lockdep_unlock+0x10e/0x290 kernel/locking/lockdep.c:124
> >  debug_locks_off_graph_unlock kernel/locking/lockdep.c:165 [inline]
> >  print_usage_bug kernel/locking/lockdep.c:3710 [inline]
> 
> Ha, I think you hit a bug in lockdep.

Something like so I suppose.

---
Subject: locking/lockdep: Avoid unmatched unlock
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon Feb 1 11:55:38 CET 2021

Commit f6f48e180404 ("lockdep: Teach lockdep about "USED" <- "IN-NMI"
inversions") overlooked that print_usage_bug() releases the graph_lock
and called it without the graph lock held.

Fixes: f6f48e180404 ("lockdep: Teach lockdep about "USED" <- "IN-NMI" inversions")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/locking/lockdep.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3773,7 +3773,7 @@ static void
 print_usage_bug(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
 {
-	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
+	if (!debug_locks_off() || debug_locks_silent)
 		return;
 
 	pr_warn("\n");
@@ -3814,6 +3814,7 @@ valid_state(struct task_struct *curr, st
 	    enum lock_usage_bit new_bit, enum lock_usage_bit bad_bit)
 {
 	if (unlikely(hlock_class(this)->usage_mask & (1 << bad_bit))) {
+		graph_unlock()
 		print_usage_bug(curr, this, bad_bit, new_bit);
 		return 0;
 	}
