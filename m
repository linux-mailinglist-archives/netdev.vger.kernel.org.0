Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE47657419B
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 04:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiGNCzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 22:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGNCzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 22:55:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704EABF6A;
        Wed, 13 Jul 2022 19:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15DCF61DEA;
        Thu, 14 Jul 2022 02:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C14C34114;
        Thu, 14 Jul 2022 02:55:13 +0000 (UTC)
Date:   Wed, 13 Jul 2022 22:55:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Message-ID: <20220713225511.70d03fc6@gandalf.local.home>
In-Reply-To: <C2FCCC9B-5F7D-4BBF-8410-67EA79166909@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-2-song@kernel.org>
        <20220713191846.18b05b43@gandalf.local.home>
        <0029EF24-6508-4011-B365-3E2175F9FEAB@fb.com>
        <20220713203841.76d66245@rorschach.local.home>
        <C2FCCC9B-5F7D-4BBF-8410-67EA79166909@fb.com>
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

On Thu, 14 Jul 2022 01:42:59 +0000
Song Liu <songliubraving@fb.com> wrote:

> > As I replied to patch 3, here's my thoughts.
> > 
> > DIRECT is treated as though it changes the IP. If you register it to a
> > function that has an IPMODIFY already set to it, it will call the
> > ops->ops_func() asking if the ops can use SHARED_IPMODIFY (which means
> > a DIRECT can be shared with IPMODIFY). If it can, then it returns true,
> > and the SHARED_IPMODIFY is set *by ftrace*. The user of the ftrace APIs
> > should not have to manage this. It should be managed by the ftrace
> > infrastructure.  
> 
> Hmm... I don't think this gonna work. 
> 
> First, two IPMODIFY ftrace ops cannot work together on the same kernel 
> function. So there won't be a ops with both IPMODIFY and SHARE_IPMODIFY. 

I'm not saying that.

I'm saying that ftrace does not have any clue (nor cares) about what a
DIRECT ops does. It might modify the IP or it might not. It doesn't know.

But ftrace has control over the callbacks it does control.

A DIRECT ops knows if it can work with another ops that has IPMODIFY set.
If the DIRECT ops does not work with IPMODIFY (perhaps it wants to modify
the IP), then it will tell ftrace that it can't and ftrace will not allow
it.

That is, ftrace doesn't care if the DIRECT ops modifies the IP or not. It
can only ask (through the ops->ops_func()) if the direct trampoline can
honor the IP that is modified. If it can, then it reports back that it can,
and then ftrace will set that ops to SHARED_MODIFY, and the direct function
can switch the ops->func() to one that uses SHARED_MODIFY.

> 
> non-direct ops without IPMODIFY can already share with IPMODIFY ops.

It can? ftrace sets IPMODIFY for all DIRECT callers to prevent that. Except
for this patch that removes that restriction (which I believe is broken).

> Only direct ops need SHARE_IPMODIFY flag, and it means "I can share with 
> another ops with IPMODIFY". So there will be different flavors of 
> direct ops:

I agree that only DIRECT ops can have SHARED_IPMODIFY set. That's what I'm
saying. But I'm saying it gets set by ftrace.

> 
>   1. w/ IPMODIFY, w/o SHARE_IPMODIFY;
>   2. w/o IPMODIFY, w/o SHARE_IPMODIFY;
>   3. w/o IPMODIFY, w/ SHARE_IPMODIFY. 
> 
> #1 can never work on the same function with another IPMODIFY ops, and 
> we don't plan to make it work. #2 does not work with another IPMODIFY 
> ops. And #3 works with another IPMODIFY ops.

Lets look at this differently. What I'm proposing is that registering a
direct ops does not need to tell ftrace if it modifies the IP or not.
That's because ftrace doesn't care. Once ftrace calls the direct trampoline
it loses all control. With the ftrace ops callbacks, it is the one
responsible for setting up the modified IP. That's not the case with the
direct trampolines.

I'm saying that ftrace doesn't care what the DIRECT ops does. But it will
not, by default, allow an IPMODIFY to happen when a DIRECT ops is on the
same function, or vice versa.

What I'm suggesting is when a IPMODIFY tries to attach to a function that
also has a DIRECT ops, or a DIRECT tries to attach to a function that
already has an IPMODIFY ops on it, that ftrace calls the direct
ops->ops_func() asking if it is safe to use with an IPMODIFY function.

If the direct ops modifies the IP itself, it will return a "no", and ftrace
will reject the attachment. If the direct ops can, it returns a "yes" and
then ftrace will set the SHARED_IPMODIFY flag to that ops and continue.

The fact that the ops->ops_func was called will let the caller (bpf) know
that it needs to use the stack to return to the function, or to call it if
it is also tracing the return.

If the IPMODIFY ops is removed, then ftrace will call the ops->ops_func()
telling it it no longer has the IPMODIFY set, and will clear the
SHARED_IPMODIFY flag, and then the owner of the direct ops can go back to
doing whatever it did before (the calling the function directly, or
whatever).
 
> 
> The owner of the direct trampoline uses these flags to tell ftrace 
> infrastructure the property of this trampoline. 

I disagree. The owner shouldn't have to care about the flags. Let ftrace
handle it. This will make things so much more simple for both BPF and
ftrace.

> 
> BPF trampolines with only fentry calls are #3 direct ops. BPF 
> trampolines with fexit or fmod_ret calls will be #2 trampoline by 
> default, but it is also possible to generate #3 trampoline for it.

And ftrace doesn't care about this. But bpf needs to care if the IP is
being modified or not. Which can be done by the ops->ops_func() that you
added.

>  
> BPF side will try to register #2 trampoline, If ftrace detects another 
> IPMODIFY ops on the same function, it will let BPF trampoline know 
> with -EAGAIN from register_ftrace_direct_multi(). Then, BPF side will 
> regenerate a #3 trampoline and register it again. 

This is too complex. You are missing the simple way.

> 
> I know this somehow changes the policy with direct ops, but it is the
> only way this can work, AFAICT. 

I disagree. There's a much better way that this can work.

> 
> Does this make sense? Did I miss something?


Let me start from the beginning.

1. Live kernel patching patches function foo.

2. lkp has an ops->flags | IPMODIFY set when it registers.

3. bpf registers a direct trampoline to function foo.

4. bpf has an ops->flags | DIRECT set when it registers

5. ftrace sees that the function already has an ops->flag = IPMODIFY on it,
so it calls bpf ops->ops_func(SHARE_WITH_IPMODIFY)

6. bpf can and does the following

  a. if it's the simple #1 trampoline (just traces the start of a function)
     it doesn't need to do anything special returns "yes".

  b. if it's the #2 trampoline, it will change the trampoline to use the
     stack to find what to call, and returns "yes".

7. ftrace gets "yes" and sets the *ipmodify* ops with SHARED_IPMODIFY
   (there's a reason for setting this flag for the ipmodify ops and not the
    direct ops).


8. LKP is removed from the function foo.

9. ftrace sees the lkp IPMODIFY ops has SHARED_IPMODIFY on it, and knows
   that there's a direct call here too. It removes the IPMODIFY ops, and
   then calls the direct ops->ops_func(STOP_SHARE_WITH_IPMODIFY) to let the
   direct code know that it is no longer sharing with an IPMODIFY such that
   it can change to call the function directly and not use the stack.


See how simple this is? ftrace doesn't have to care if the direct caller
changes the IP or not. It just wants to know if it can be shared with an
IPMODIFY ops. And BPF doesn't have to care about extra flags used to manage
the ftrace infrastructure.

Does this make sense now?

-- Steve


