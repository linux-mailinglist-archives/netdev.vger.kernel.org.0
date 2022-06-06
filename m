Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF59D53E5E2
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241416AbiFFQCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 12:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241389AbiFFQCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 12:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02A031909;
        Mon,  6 Jun 2022 09:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0126B60B4E;
        Mon,  6 Jun 2022 16:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F9EC385A9;
        Mon,  6 Jun 2022 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654531354;
        bh=4fcI46sksNPRQpKV25vl8NhCk5UfbVE4mI4k5n7Qnak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SlDHGrGws5AkJ0Oa+XUokumnrvTmtnu6PAic6lDmnGc8BznCLkQFxEDRCVF8o5oWx
         LLVRm48VOHFcW8b0sGim9MUjuu4enRCbwJgtisGXt6ngM+VTkxSdjH79sCQDGKejAx
         LGdVJLl/F2RcowjbM8n2J+GXSdGo5eVYBBzt14olldD9JS7QWmQ58UvIl7lrZvCR4w
         jsVZatcBymS2nQAuZzaPlGoJVo1Vt34KvmTDN1uzDR/8ruOIH5PRCuPtP6MDrIUDRo
         DaCtu+jS+4/pfutn+Gm5vjENdQDi/ps3by2LQPwG3Os6SiDK85aBbTjPhjb/5DPHgF
         z9jc7IyDtNBzQ==
Date:   Tue, 7 Jun 2022 01:02:29 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] rethook: Reject getting a rethook if RCU is not
 watching
Message-Id: <20220607010229.5e75445aedb12c99cae2cd51@kernel.org>
In-Reply-To: <CAEf4BzZdPc3HVUwtuyifaPwz_=9VtykafJsSsvDbYonLA=K=2Q@mail.gmail.com>
References: <165189881197.175864.14757002789194211860.stgit@devnote2>
        <20220524192301.0c2ab08a@gandalf.local.home>
        <20220526232530.cb7d0aed0c60625ef093a735@kernel.org>
        <Yo+TWcfpyHy55Il5@krava>
        <20220527011434.9e8c47d1b40f549baf2cf52a@kernel.org>
        <YpFMQOjvV/tgwsuK@krava>
        <20220528101928.5118395f2d97142f7625b761@kernel.org>
        <CAEf4BzZdPc3HVUwtuyifaPwz_=9VtykafJsSsvDbYonLA=K=2Q@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jun 2022 12:21:19 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Fri, May 27, 2022 at 6:19 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Sat, 28 May 2022 00:10:08 +0200
> > Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > > On Fri, May 27, 2022 at 01:14:34AM +0900, Masami Hiramatsu wrote:
> > > > On Thu, 26 May 2022 16:49:26 +0200
> > > > Jiri Olsa <olsajiri@gmail.com> wrote:
> > > >
> > > > > On Thu, May 26, 2022 at 11:25:30PM +0900, Masami Hiramatsu wrote:
> > > > > > On Tue, 24 May 2022 19:23:01 -0400
> > > > > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > > >
> > > > > > > On Sat,  7 May 2022 13:46:52 +0900
> > > > > > > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > > > > >
> > > > > > > Is this expected to go through the BPF tree?
> > > > > > >
> > > > > >
> > > > > > Yes, since rethook (fprobe) is currently used only from eBPF.
> > > > > > Jiri, can you check this is good for your test case?
> > > > >
> > > > > sure I'll test it.. can't see the original email,
> > > > > perhaps I wasn't cc-ed.. but I'll find it
> > > >
> > > > Here it is. I Cc-ed your @kernel.org address.
> > > > https://lore.kernel.org/all/165189881197.175864.14757002789194211860.stgit@devnote2/T/#u
> > > >
> > > > >
> > > > > is this also related to tracing 'idle' functions,
> > > > > as discussed in here?
> > > > >   https://lore.kernel.org/bpf/20220515203653.4039075-1-jolsa@kernel.org/
> > > >
> > > > Ah, yes. So this may not happen with the above patch, but for the
> > > > hardening (ensuring it is always safe), I would like to add this.
> > > >
> > > > >
> > > > > because that's the one I can reproduce.. but I can
> > > > > certainly try that with your change as well
> > > >
> > > > Thank you!
> > >
> > > it did not help the idle warning as expected, but I did not
> > > see any problems running bpf tests on top of this
> >
> > Oops, right. I forgot this is only for the rethook, not protect the
> > fprobe handlers, since fprobe code doesn't involve the RCU code (it
> > depends on ftrace's check). Sorry about that.
> > Hmm, I need to add a test code for this issue, but that could be
> > solved by your noninstr patch.
> >
> 
> 
> Masami,
> 
> It's not clear to me, do you intend to send a new revision with some
> more tests or this patch as is ready to go into bpf tree?

OK, let me make a test code against this issue. This may need a raw
fprobe test code (not a test case because it depends on that we can
trace the "arch_cpu_idle()"), but that test code won't work after
the "arch_cpu_idle()" is marked as noinstr (thus the test code will
only for the kernel which doesn't have the noinstr patch).
I want to add this check for the case if someone accidentally add
a function which is not covered by RCU and that is tracable by
fprobe (ftrace).
Thus this is a kind of preventative fix.

Thank you,

> 
> 
> > Thank you,
> >
> > >
> > > jirka
> > >
> > > >
> > > > >
> > > > > jirka
> > > > >
> > > > > >
> > > > > > Thank you,
> > > > > >
> > > > > >
> > > > > > > -- Steve
> > > > > > >
> > > > > > >
> > > > > > > > Since the rethook_recycle() will involve the call_rcu() for reclaiming
> > > > > > > > the rethook_instance, the rethook must be set up at the RCU available
> > > > > > > > context (non idle). This rethook_recycle() in the rethook trampoline
> > > > > > > > handler is inevitable, thus the RCU available check must be done before
> > > > > > > > setting the rethook trampoline.
> > > > > > > >
> > > > > > > > This adds a rcu_is_watching() check in the rethook_try_get() so that
> > > > > > > > it will return NULL if it is called when !rcu_is_watching().
> > > > > > > >
> > > > > > > > Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
> > > > > > > > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > > > > > > > ---
> > > > > > > >  kernel/trace/rethook.c |    9 +++++++++
> > > > > > > >  1 file changed, 9 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> > > > > > > > index b56833700d23..c69d82273ce7 100644
> > > > > > > > --- a/kernel/trace/rethook.c
> > > > > > > > +++ b/kernel/trace/rethook.c
> > > > > > > > @@ -154,6 +154,15 @@ struct rethook_node *rethook_try_get(struct rethook *rh)
> > > > > > > >     if (unlikely(!handler))
> > > > > > > >             return NULL;
> > > > > > > >
> > > > > > > > +   /*
> > > > > > > > +    * This expects the caller will set up a rethook on a function entry.
> > > > > > > > +    * When the function returns, the rethook will eventually be reclaimed
> > > > > > > > +    * or released in the rethook_recycle() with call_rcu().
> > > > > > > > +    * This means the caller must be run in the RCU-availabe context.
> > > > > > > > +    */
> > > > > > > > +   if (unlikely(!rcu_is_watching()))
> > > > > > > > +           return NULL;
> > > > > > > > +
> > > > > > > >     fn = freelist_try_get(&rh->pool);
> > > > > > > >     if (!fn)
> > > > > > > >             return NULL;
> > > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > > >
> > > >
> > > > --
> > > > Masami Hiramatsu (Google) <mhiramat@kernel.org>
> >
> >
> > --
> > Masami Hiramatsu (Google) <mhiramat@kernel.org>


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
