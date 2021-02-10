Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064A23170A9
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhBJTxF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Feb 2021 14:53:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232715AbhBJTww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 14:52:52 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCAD464EDA;
        Wed, 10 Feb 2021 19:52:08 +0000 (UTC)
Date:   Wed, 10 Feb 2021 14:52:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>, mmullins@fb.com,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Read in bpf_trace_run3
Message-ID: <20210210145207.77798d6c@gandalf.local.home>
In-Reply-To: <7b0fe079-bcd3-484d-fda6-12d962f584f8@gmail.com>
References: <00000000000004500b05b31e68ce@google.com>
        <CACT4Y+aBVQ6LKYf9wCV=AUx23xpWmb_6-mBqwkQgeyfXA3SS2A@mail.gmail.com>
        <20201113053722.7i4xkiyrlymcwebg@hydra.tuxags.com>
        <c63f89b2-0627-91d8-a609-3f2a3b5b5a2d@fb.com>
        <7b0fe079-bcd3-484d-fda6-12d962f584f8@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 19:23:38 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> >> The problem here is a kmalloc failure injection into
> >> tracepoint_probe_unregister, but the error is ignored -- so the bpf
> >> program is freed even though the tracepoint is never unregistered.
> >>
> >> I have a first pass at a patch to pipe through the error code, but it's
> >> pretty ugly.  It's also called from the file_operations ->release(), for  
> > 
> > Maybe you can still post the patch, so people can review and make suggestions which may lead to a *better* solution.  
> 
> 
> ping
> 
> This bug is still there.

Is this a bug via syzkaller?

I have this fix in linux-next:

  befe6d946551 ("tracepoint: Do not fail unregistering a probe due to memory failure")

But because it is using undefined behavior (calling a sub return from a
call that has parameters, but Peter Zijlstra says is OK), I'm hesitant to
send it to Linus now or label it as stable.

Now this can only happen if kmalloc fails from here (called by func_remove).

static inline void *allocate_probes(int count)
{
	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
				       GFP_KERNEL);
	return p == NULL ? NULL : p->probes;
}

As probes and count together is typically much less than a page (unless you
are doing fuzz testing and adding a ton of callbacks to a single
tracepoint), that kmalloc should always succeed.

The failure above can only happen if allocate_probes returns NULL, which is
extremely unlikely.

My question is, how is this triggered? And this should only be triggered by
root doing stupid crap. Is it that critical to have fixed?

-- Steve
