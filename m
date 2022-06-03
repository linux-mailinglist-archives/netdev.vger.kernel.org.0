Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D54D53D252
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiFCTVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiFCTVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:21:34 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FCD48889;
        Fri,  3 Jun 2022 12:21:32 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id h23so14091369lfe.4;
        Fri, 03 Jun 2022 12:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vRu2HMj+s0FqdXBsHbhcGVbuFfWd/V443d4ot13YWmo=;
        b=OKV7tTcP036iyUftGLcun4D6VX/mIbJnOq4KbylU0UckLQV0YRi7rT20aalYukRkbB
         x5ztf/ipTvP7Aclc2Yk8Oug9b6uiclWXsTxwWWHTfF2hnQ5DUra8Tc71Eeyzq5PzP4+7
         jT7neRneUab4RjY5G+Q3SqnJMP5Oviq/ixZWD/HsQ4lHEeQNTh+o6OYeCG3pWn6bYI78
         gzVzLvFBc/npFvyaFYPysstw+gN7bPMN44vtBD2k/yDBlGEnK+ks4pINO1n38lqH7y4S
         OAjofZF6yPpvsFVMvdXpEwIvywbS8KtA8lq4NKFoC6hFvdkfVdo2KfVFCDlyUIO9fRUu
         ta6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vRu2HMj+s0FqdXBsHbhcGVbuFfWd/V443d4ot13YWmo=;
        b=neMM2MWL/UcMb2R0HfJVjEoYHu2gfUdiZULgI49Pj5lJBh76t/VT7KC2YBWV642HTf
         2QWTK7mnh3ChT2zsRvGkcRCY4B+UEgOzrBd0leFFZ50xKHDvA+hvugNBtz7qZE93ufqQ
         ZS4Zoik2YbPF2V+jNPOKdAdTTRemZ1tpjMTDY0u/6lpwb/5YIINPDRo6hja16dc3zSpX
         ElsQYDNZl6nZH/pBhF+0+s3nCd9E1GvuLdogAYpnHX2BfZjkkZ8a4AAYGCAsaFi3Vsb4
         C2oeclbRXbAk8TEAldHdmHUjIfIG56oKne19Q4gzmvGKWRJUSAZj4OD/16kcm62DdMXr
         oWXg==
X-Gm-Message-State: AOAM532x1TNX7Hs2Mw+aM0J1lBYbNVTRyP9JVJK57/VZ9SRRTx+8YfSF
        NqKhETjpttxe8iiqbWy2ZWnSXuKCYxC/PaJhtcM=
X-Google-Smtp-Source: ABdhPJwMLUFTdm93iXq8E4Z/0ob4mwl9RuQRIleNT7awKXEEwPxrOOobu6es6AroM4YQ/4R62QnGVt+d9OBosxaSwdc=
X-Received: by 2002:a05:6512:685:b0:479:176c:5a5e with SMTP id
 t5-20020a056512068500b00479176c5a5emr3578203lfe.408.1654284090835; Fri, 03
 Jun 2022 12:21:30 -0700 (PDT)
MIME-Version: 1.0
References: <165189881197.175864.14757002789194211860.stgit@devnote2>
 <20220524192301.0c2ab08a@gandalf.local.home> <20220526232530.cb7d0aed0c60625ef093a735@kernel.org>
 <Yo+TWcfpyHy55Il5@krava> <20220527011434.9e8c47d1b40f549baf2cf52a@kernel.org>
 <YpFMQOjvV/tgwsuK@krava> <20220528101928.5118395f2d97142f7625b761@kernel.org>
In-Reply-To: <20220528101928.5118395f2d97142f7625b761@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 12:21:19 -0700
Message-ID: <CAEf4BzZdPc3HVUwtuyifaPwz_=9VtykafJsSsvDbYonLA=K=2Q@mail.gmail.com>
Subject: Re: [PATCH] rethook: Reject getting a rethook if RCU is not watching
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
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

On Fri, May 27, 2022 at 6:19 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Sat, 28 May 2022 00:10:08 +0200
> Jiri Olsa <olsajiri@gmail.com> wrote:
>
> > On Fri, May 27, 2022 at 01:14:34AM +0900, Masami Hiramatsu wrote:
> > > On Thu, 26 May 2022 16:49:26 +0200
> > > Jiri Olsa <olsajiri@gmail.com> wrote:
> > >
> > > > On Thu, May 26, 2022 at 11:25:30PM +0900, Masami Hiramatsu wrote:
> > > > > On Tue, 24 May 2022 19:23:01 -0400
> > > > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > >
> > > > > > On Sat,  7 May 2022 13:46:52 +0900
> > > > > > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > > > >
> > > > > > Is this expected to go through the BPF tree?
> > > > > >
> > > > >
> > > > > Yes, since rethook (fprobe) is currently used only from eBPF.
> > > > > Jiri, can you check this is good for your test case?
> > > >
> > > > sure I'll test it.. can't see the original email,
> > > > perhaps I wasn't cc-ed.. but I'll find it
> > >
> > > Here it is. I Cc-ed your @kernel.org address.
> > > https://lore.kernel.org/all/165189881197.175864.14757002789194211860.stgit@devnote2/T/#u
> > >
> > > >
> > > > is this also related to tracing 'idle' functions,
> > > > as discussed in here?
> > > >   https://lore.kernel.org/bpf/20220515203653.4039075-1-jolsa@kernel.org/
> > >
> > > Ah, yes. So this may not happen with the above patch, but for the
> > > hardening (ensuring it is always safe), I would like to add this.
> > >
> > > >
> > > > because that's the one I can reproduce.. but I can
> > > > certainly try that with your change as well
> > >
> > > Thank you!
> >
> > it did not help the idle warning as expected, but I did not
> > see any problems running bpf tests on top of this
>
> Oops, right. I forgot this is only for the rethook, not protect the
> fprobe handlers, since fprobe code doesn't involve the RCU code (it
> depends on ftrace's check). Sorry about that.
> Hmm, I need to add a test code for this issue, but that could be
> solved by your noninstr patch.
>


Masami,

It's not clear to me, do you intend to send a new revision with some
more tests or this patch as is ready to go into bpf tree?


> Thank you,
>
> >
> > jirka
> >
> > >
> > > >
> > > > jirka
> > > >
> > > > >
> > > > > Thank you,
> > > > >
> > > > >
> > > > > > -- Steve
> > > > > >
> > > > > >
> > > > > > > Since the rethook_recycle() will involve the call_rcu() for reclaiming
> > > > > > > the rethook_instance, the rethook must be set up at the RCU available
> > > > > > > context (non idle). This rethook_recycle() in the rethook trampoline
> > > > > > > handler is inevitable, thus the RCU available check must be done before
> > > > > > > setting the rethook trampoline.
> > > > > > >
> > > > > > > This adds a rcu_is_watching() check in the rethook_try_get() so that
> > > > > > > it will return NULL if it is called when !rcu_is_watching().
> > > > > > >
> > > > > > > Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
> > > > > > > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > > > > > > ---
> > > > > > >  kernel/trace/rethook.c |    9 +++++++++
> > > > > > >  1 file changed, 9 insertions(+)
> > > > > > >
> > > > > > > diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> > > > > > > index b56833700d23..c69d82273ce7 100644
> > > > > > > --- a/kernel/trace/rethook.c
> > > > > > > +++ b/kernel/trace/rethook.c
> > > > > > > @@ -154,6 +154,15 @@ struct rethook_node *rethook_try_get(struct rethook *rh)
> > > > > > >     if (unlikely(!handler))
> > > > > > >             return NULL;
> > > > > > >
> > > > > > > +   /*
> > > > > > > +    * This expects the caller will set up a rethook on a function entry.
> > > > > > > +    * When the function returns, the rethook will eventually be reclaimed
> > > > > > > +    * or released in the rethook_recycle() with call_rcu().
> > > > > > > +    * This means the caller must be run in the RCU-availabe context.
> > > > > > > +    */
> > > > > > > +   if (unlikely(!rcu_is_watching()))
> > > > > > > +           return NULL;
> > > > > > > +
> > > > > > >     fn = freelist_try_get(&rh->pool);
> > > > > > >     if (!fn)
> > > > > > >             return NULL;
> > > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > >
> > >
> > > --
> > > Masami Hiramatsu (Google) <mhiramat@kernel.org>
>
>
> --
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
