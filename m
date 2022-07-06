Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFCE569551
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 00:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiGFW3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 18:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiGFW3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 18:29:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E5614D17;
        Wed,  6 Jul 2022 15:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E175B61CFA;
        Wed,  6 Jul 2022 22:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE56C3411C;
        Wed,  6 Jul 2022 22:29:33 +0000 (UTC)
Date:   Wed, 6 Jul 2022 18:29:31 -0400
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
Message-ID: <20220706182931.06cb0e20@gandalf.local.home>
In-Reply-To: <ECD336F1-A130-47BA-8FBB-E3573445380F@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-6-song@kernel.org>
        <20220706153843.37584b5b@gandalf.local.home>
        <DC04E081-8320-4A39-A058-D0E33F202625@fb.com>
        <20220706174049.6c60250f@gandalf.local.home>
        <ECD336F1-A130-47BA-8FBB-E3573445380F@fb.com>
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

On Wed, 6 Jul 2022 22:15:47 +0000
Song Liu <songliubraving@fb.com> wrote:

> > On Jul 6, 2022, at 2:40 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > On Wed, 6 Jul 2022 21:37:52 +0000
> > Song Liu <songliubraving@fb.com> wrote:
> >   
> >>> Can you comment here that returning -EAGAIN will not cause this to repeat.
> >>> That it will change things where the next try will not return -EGAIN?    
> >> 
> >> Hmm.. this is not the guarantee here. This conflict is a real race condition 
> >> that an IPMODIFY function (i.e. livepatch) is being registered at the same time 
> >> when something else, for example bpftrace, is updating the BPF trampoline. 
> >> 
> >> This EAGAIN will propagate to the user of the IPMODIFY function (i.e. livepatch),
> >> and we need to retry there. In the case of livepatch, the retry is initiated 
> >> from user space.   
> > 
> > We need to be careful here then. If there's a userspace application that
> > runs at real-time and does a:
> > 
> > 	do {
> > 		errno = 0;
> > 		regsiter_bpf();
> > 	} while (errno != -EAGAIN);  
> 
> Actually, do you mean:
> 
> 	do {
> 		errno = 0;
> 		regsiter_bpf();
> 	} while (errno == -EAGAIN);
> 
> (== -EAGAIN) here?

Yeah, of course.

> 
> In this specific race condition, register_bpf() will succeed, as it already
> got tr->mutex. But the IPMODIFY (livepatch) side will fail and retry. 

What else takes the tr->mutex ?

If it preempts anything else taking that mutex, when this runs, then it
needs to be careful.

You said this can happen when the live patch came first. This isn't racing
against live patch, it's racing against anything that takes the tr->mutex
and then adds a bpf trampoline to a location that has a live patch.

> 
> Since both livepatch and bpf trampoline changes are rare operations, I think 
> the chance of the race condition is low enough. 
> 
> Does this make sense?
> 

It's low, and if it is also a privileged operation then there's less to be
concern about. As if it is not, then we could have a way to deadlock the
system. I'm more concerned that this will lead to a CVE than it just
happening randomly. In other words, it only takes something that can run at
a real-time priority to connect to a live patch location, and something
that runs at a low priority to take a tr->mutex. If an attacker has both,
then it can pin both to a CPU and then cause the deadlock to the system.

One hack to fix this is to add a msleep(1) in the failed case of the
trylock. This will at least give the owner of the lock a millisecond to
release it. This was what the RT patch use to do with spin_trylock() that
was converted to a mutex (and we worked hard to remove all of them).

-- Steve
