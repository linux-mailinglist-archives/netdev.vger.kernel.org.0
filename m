Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19625569754
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbiGGBTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiGGBTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:19:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03EE2E69D;
        Wed,  6 Jul 2022 18:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85C6FB81CF4;
        Thu,  7 Jul 2022 01:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA16EC341C6;
        Thu,  7 Jul 2022 01:19:00 +0000 (UTC)
Date:   Wed, 6 Jul 2022 21:18:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <20220706211858.67f9254d@rorschach.local.home>
In-Reply-To: <9E7BD8AD-483A-4960-B4C6-223CC715D2AF@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-6-song@kernel.org>
        <20220706153843.37584b5b@gandalf.local.home>
        <DC04E081-8320-4A39-A058-D0E33F202625@fb.com>
        <20220706174049.6c60250f@gandalf.local.home>
        <ECD336F1-A130-47BA-8FBB-E3573445380F@fb.com>
        <20220706182931.06cb0e20@gandalf.local.home>
        <9E7BD8AD-483A-4960-B4C6-223CC715D2AF@fb.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 00:19:07 +0000
Song Liu <songliubraving@fb.com> wrote:

> >> In this specific race condition, register_bpf() will succeed, as it already
> >> got tr->mutex. But the IPMODIFY (livepatch) side will fail and retry.   
> > 
> > What else takes the tr->mutex ?  
> 
> tr->mutex is the local mutex for a single BPF trampoline, we only need to take
> it when we make changes to the trampoline (add/remove fentry/fexit programs). 
> 
> > 
> > If it preempts anything else taking that mutex, when this runs, then it
> > needs to be careful.
> > 
> > You said this can happen when the live patch came first. This isn't racing
> > against live patch, it's racing against anything that takes the tr->mutex
> > and then adds a bpf trampoline to a location that has a live patch.  
> 
> There are a few scenarios here:
> 1. Live patch is already applied, then a BPF trampoline is being registered 
> to the same function. In bpf_trampoline_update(), register_fentry returns
> -EAGAIN, and this will be resolved. 

Where will it be resolved?

> 
> 2. BPF trampoline is already registered, then a live patch is being applied 
> to the same function. The live patch code need to ask the bpf trampoline to
> prepare the trampoline before live patch. This is done by calling 
> bpf_tramp_ftrace_ops_func. 
> 
> 2.1 If nothing else is modifying the trampoline at the same time, 
> bpf_tramp_ftrace_ops_func will succeed. 
> 
> 2.2 In rare cases, if something else is holding tr->mutex to make changes to 
> the trampoline (add/remove fentry functions, etc.), mutex_trylock in 
> bpf_tramp_ftrace_ops_func will fail, and live patch will fail. However, the 
> change to BPF trampoline will still succeed. It is common for live patch to
> retry, so we just need to try live patch again when no one is making changes 
> to the BPF trampoline in parallel. 

If the live patch is going to try again, and the task doing the live
patch is SCHED_FIFO, and the task holding the tr->mutex is SCHED_OTHER
(or just a lower priority), then there is a chance that the live patch
task preempted the tr->mutex owner, and let's say the tr->mutex owner
is pinned to the CPU (by the user or whatever), then because the live
patch task is in a loop trying to take that mutex, it will never let
the owner continue.

Yes, this is a real scenario with trylock on mutexes. We hit it all the
time in RT.

> 
> >   
> >> 
> >> Since both livepatch and bpf trampoline changes are rare operations, I think 
> >> the chance of the race condition is low enough. 


A low race condition in a world that does this a billion times a day,
ends up being not so rare.

I like to say, "I live in a world where the unlikely is very much likely!"


> >> 
> >> Does this make sense?
> >>   
> > 
> > It's low, and if it is also a privileged operation then there's less to be
> > concern about.  
> 
> Both live patch and BPF trampoline are privileged operations. 

This makes the issue less of an issue, but if there's an application
that does this with setuid or something, there's a chance that it can
be used by an attacker as well.

> 
> > As if it is not, then we could have a way to deadlock the
> > system. I'm more concerned that this will lead to a CVE than it just
> > happening randomly. In other words, it only takes something that can run at
> > a real-time priority to connect to a live patch location, and something
> > that runs at a low priority to take a tr->mutex. If an attacker has both,
> > then it can pin both to a CPU and then cause the deadlock to the system.
> > 
> > One hack to fix this is to add a msleep(1) in the failed case of the
> > trylock. This will at least give the owner of the lock a millisecond to
> > release it. This was what the RT patch use to do with spin_trylock() that
> > was converted to a mutex (and we worked hard to remove all of them).  
> 
> The fix is really simple. But I still think we don't need it. We only hit
> the trylock case for something with IPMODIFY. The non-privileged user 
> should not be able to do that, right?

For now, perhaps. But what useful applications are there going to be in
the future that performs these privileged operations on behalf of a
non-privileged user?

In other words, if we can fix it now, we should, and avoid debugging
this issue 5 years from now where it may take months to figure out.

-- Steve
