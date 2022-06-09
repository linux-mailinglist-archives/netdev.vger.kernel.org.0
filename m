Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0DE545420
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345175AbiFIS1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiFIS1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:27:12 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D146FF5537;
        Thu,  9 Jun 2022 11:27:10 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id s6so39254887lfo.13;
        Thu, 09 Jun 2022 11:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AhmBOTJY8amk0N1XljgJRz/lxToy2L4Z1S8IA0lM0a4=;
        b=JKdsW4M/5b0xswfjyJ9Po84LMJR6RtHicDkvP4L6WrSNv6HPDMPG+mlg0SzEr3fXIz
         9k/6yYFcZZ7JXj0DNgU2zUVW/gG0+jn5L7oDxxu54Su5vkjz+g9SPxsYDc7ohDIO4f99
         J8xb909ZKmoziU91OGwsq0oYfnmUDzIhcHV9I9bjoELHQQ6GQpJDndwns8xc08cSSYDv
         0sHfZ4WQrnplrOReP4U9Qe9LOHkD+UrMFKZidmBiIC7JoZiNBhXRcxQfmJXdillacsjn
         Kj2Es3lpu1Si/5QtH1k+7fKE9U6lIuQHO1yF9aaUuiUkcSYZ9kXtHYNuUgmssT1rJWNy
         8aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AhmBOTJY8amk0N1XljgJRz/lxToy2L4Z1S8IA0lM0a4=;
        b=bQS7xpkedYWnFgIaot/PVOldQlFD09GNLmpGWZosotjwwbkwHpwgA6g39jBcYaOsOw
         frF4tSx35ds68jthNnmZm9G5rjuOF9xwa0lGnVJNQL+9EYgelzhsw9DYFaTUKIkmvTYV
         nammp8z8AWG0YUWFvUARVumri3ifYkdfW8wRT2oFl8eYQromxvL8AZVoyZqQLPtf2HHC
         c811h6DXBAQ/J955vMJPZh8DM8JnOMgpq7eK7zd3LUr4/k7lxzUNSLPhfsrv5Dv8rhIW
         b7D9YA/peRW4yrWJq9oYiVdF8xGIF3UhBWaLOzAsbRmtop7WXfIbfqrdjUnuiV3Uctks
         Zvxw==
X-Gm-Message-State: AOAM532/IpErj2K1oLQ14QIxwiM2xGbQyVYOylNSoKTLQ2oQ7T8lUDEC
        O/QfZkuv7B5iyJtIbxGdfmGYUCtwgKcqxpGj3ZY=
X-Google-Smtp-Source: ABdhPJwwsqXPmHoicC+bnRDVoPHXDWaNbFPAGRJZRG8wMVtfxhOutw+MN/PaK7jQL9d6MHouqIHxKZzybmPvPOc7tNs=
X-Received: by 2002:a05:6512:2296:b0:479:5805:6f05 with SMTP id
 f22-20020a056512229600b0047958056f05mr10829913lfu.302.1654799229020; Thu, 09
 Jun 2022 11:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220525114003.61890-1-jolsa@kernel.org> <CAEf4BzZ-xe-zSjbBpKLHfQKPnTRTBMA2Eg382+_4kQoTLnj4eQ@mail.gmail.com>
 <CAADnVQJcDKVAOeJ8LX9j-cUKdkptuFWFDnB3o9C_o0bSScGnsQ@mail.gmail.com>
In-Reply-To: <CAADnVQJcDKVAOeJ8LX9j-cUKdkptuFWFDnB3o9C_o0bSScGnsQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jun 2022 11:26:57 -0700
Message-ID: <CAEf4Bzay1-pRLw+zHG1TjHRTRpqQdtmpmDvNdq=ef-0OUQD0QQ@mail.gmail.com>
Subject: Re: [RFC bpf-next] bpf: Use prog->active instead of bpf_prog_active
 for kprobe_multi
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
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

On Tue, Jun 7, 2022 at 9:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, May 31, 2022 at 4:24 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, May 25, 2022 at 4:40 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > Alexei suggested to use prog->active instead global bpf_prog_active
> > > for programs attached with kprobe multi [1].
> > >
> > > AFAICS this will bypass bpf_disable_instrumentation, which seems to be
> > > ok for some places like hash map update, but I'm not sure about other
> > > places, hence this is RFC post.
> > >
> > > I'm not sure how are kprobes different to trampolines in this regard,
> > > because trampolines use prog->active and it's not a problem.
> > >
> > > thoughts?
> > >
> >
> > Let's say we have two kernel functions A and B? B can be called from
> > BPF program though some BPF helper, ok? Now let's say I have two BPF
> > programs kprobeX and kretprobeX, both are attached to A and B. With
> > using prog->active instead of per-cpu bpf_prog_active, what would be
> > the behavior when A is called somewhere in the kernel.
> >
> > 1. A is called
> > 2. kprobeX is activated for A, calls some helper which eventually calls B
> >   3. kprobeX is attempted to be called for B, but is skipped due to prog->active
> >   4. B runs
> >   5. kretprobeX is activated for B, calls some helper which eventually calls B
> >     6. kprobeX is ignored (prog->active > 0)
> >     7. B runs
> >     8. kretprobeX is ignored (prog->active > 0)
> > 9. kretprobeX is activated for A, calls helper which calls B
> >   10. kprobeX is activated for B
> >     11. kprobeX is ignored (prog->active > 0)
>
> not correct. kprobeX actually runs.
> but the end result is correct.
>

Right, it was a long sequence, but you got the idea :)

> >     12. B runs
> >     13. kretprobeX is ignored (prog->active > 0)
> >   14. B runs
> >   15. kretprobeX is ignored (prog->active > 0)
> >
> >
> > If that's correct, we get:
> >
> > 1. kprobeX for A
> > 2. kretprobeX for B
> > 3. kretprobeX for A
> > 4. kprobeX for B
>
> Here it's correct.
>
> > It's quite mind-boggling and annoying in practice. I'd very much
> > prefer just kprobeX for A followed by kretprobeX for A. That's it.
> >
> > I'm trying to protect against this in retsnoop with custom per-cpu
> > logic in each program, but I so much more prefer bpf_prog_active,
> > which basically says "no nested kprobe calls while kprobe program is
> > running", which makes a lot of sense in practice.
>
> It makes sense for retsnoop, but does not make sense in general.
>
> > Given kprobe already used global bpf_prog_active I'd say multi-kprobe
> > should stick to bpf_prog_active as well.
>
> I strongly disagree.
> Both multi kprobe and kprobe should move to per prog counter
> plus some other protection
> (we cannot just move to per-prog due to syscalls).
> It's true that the above order is mind-boggling,
> but it's much better than
> missing kprobe invocation completely just because
> another kprobe is running on the same cpu.
> People complained numerous times about this kprobe behavior.
> kprobeX attached to A
> kprobeY attached to B.
> If kprobeX calls B kprobeY is not going to be called.
> Means that anything that bpf is using is lost.
> spin locks, lists, rcu, etc.
> Sleepable uprobes are coming.
> iirc Delyan's patch correctly.
> We will do migrate_disable and inc bpf_prog_active.

This might be a different issue, I'm not sure why uprobes should be
protected by the same global bpf_prog_active, you can't trigger uprobe
from uprobe program. And especially for sleepable programs it makes no
sense to use per-CPU protection (we have bpf_run_ctx for such
protections, if needed).

> Now random kprobes on that cpu will be lost.

It's not random. The rule is you can't kernel functions and
tracepoints triggered from BPF kprobes/tracepoints. This prevents
nasty reentrance problems and makes sense. Isn't kernel tracing infra
is protecting itself similarly, preventing reentrancy and recursion?

> It's awful. We have to fix it.

You can call it "a fix" if you'd like, but it's changing a very
user-visible behavior and guarantees on which users relied for a
while. So even if we switch to per-prog protection it will have to be
some sort of opt-in (flag, new program type, whatever).
