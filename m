Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E031545440
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345472AbiFISiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiFISiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:38:07 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8E936154;
        Thu,  9 Jun 2022 11:38:06 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id a29so10818394lfk.2;
        Thu, 09 Jun 2022 11:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xcC9e3Ls6scUGYBCv/pj4mSQg2WflFuIPw1XkOXhT80=;
        b=cRQtIssJzA7YIDi/Q1J2LKPKhJeon0x1Cxw02/Qv7ji5puJTX8PMhaQTQBuRe2BSHJ
         pkt5TK3P55qE9cxqHI/gjykpVQRa7ek01m/BFHNvgjLpd0TgNlJTGXb+kLijomWwY6G7
         FJV7cWcUQzX1ZkHBGkSX5RsXdADQFW+MbVUrTxThdEE1ooX8IhSYwalRuor0pnvOouBB
         7B65kOGlUSTcgP144P4Bx8YrZIGeX3/i7Qk9FSd5Oe9MQfNtSqjPV+0T8o+8+qG4GCt1
         XVuaXDKXSmjofKV9RQB7uJcOjmMAhLl3ti4+CcY7SJVo7z7pI2JlCdKee0FfSOAcr5sd
         km6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xcC9e3Ls6scUGYBCv/pj4mSQg2WflFuIPw1XkOXhT80=;
        b=mOdEejR5z25ljE0wTPTgepb+c3dQaQtf5rSrv325Eo1krHr1bm8yamfTrcUAZoJq3A
         ak5Li01Z9BO/knEO5dheXomDErMJ8DTPDyWWN5Ltdl9izzZBZ6sy9eKoIxy09Wje5YQ4
         HDc5LVjgxYdn8Uen+zZAyNYiR0tpKQ3utMIBqhpomQS/+8Z+sHbSpzDojk4J8SoCuQLK
         u5QYY62RPSP8+pEyIsfdQ3QE711JAbenDGlQpNImRq7MmtORK+DfR8IZaAJvBe236seF
         WYPgdxlORkp6xaoG1B3kEhRmAu2XgB+0e9dg0whm9bhSvB/RwjaXeQ7ZV/DCFQhT50Od
         o8Mg==
X-Gm-Message-State: AOAM5302GTNCW61V9BLuaT34z5qn/kcOmXdoIpwximlaTddsS48Vl25Q
        5XpMoUkSqiURiSygK9HGbpTBobyZLj05NSCmhbA=
X-Google-Smtp-Source: ABdhPJxXqR1rcvK9yxO2cXMt4qckgf7CSOHhXQo8EQQgyTw4cMYZf1+EYhbP+RHTX8R/kJox6qHyhUIfComxPBI/s5w=
X-Received: by 2002:a05:6512:1398:b0:448:bda0:99f2 with SMTP id
 p24-20020a056512139800b00448bda099f2mr72098283lfa.681.1654799884769; Thu, 09
 Jun 2022 11:38:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220609143614.97837-1-quentin@isovalent.com> <YqI4XrKeQkENT/+w@google.com>
In-Reply-To: <YqI4XrKeQkENT/+w@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jun 2022 11:37:52 -0700
Message-ID: <CAEf4BzZYWGKA7S_1jWcGcNyPmrDJeGo8YfKXpmboRdDSeEmOZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Improve probing for memcg-based memory accounting
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Thu, Jun 9, 2022 at 11:13 AM <sdf@google.com> wrote:
>
> On 06/09, Quentin Monnet wrote:
> > To ensure that memory accounting will not hinder the load of BPF
> > objects, libbpf may raise the memlock rlimit before proceeding to some
> > operations. Whether this limit needs to be raised depends on the version
> > of the kernel: newer versions use cgroup-based (memcg) memory
> > accounting, and do not require any adjustment.
>
> > There is a probe in libbpf to determine whether memcg-based accounting
> > is supported. But this probe currently relies on the availability of a
> > given BPF helper, bpf_ktime_get_coarse_ns(), which landed in the same
> > kernel version as the memory accounting change. This works in the
> > generic case, but it may fail, for example, if the helper function has
> > been backported to an older kernel. This has been observed for Google
> > Cloud's Container-Optimized OS (COS), where the helper is available but
> > rlimit is still in use. The probe succeeds, the rlimit is not raised,
> > and probing features with bpftool, for example, fails.
>
> > Here we attempt to improve this probe and to effectively rely on memory
> > accounting. Function probe_memcg_account() in libbpf is updated to set
> > the rlimit to 0, then attempt to load a BPF object, and then to reset
> > the rlimit. If the load still succeeds, then this means we're running
> > with memcg-based accounting.
>
> > This probe was inspired by the similar one from the cilium/ebpf Go
> > library [0].
>
> > [0] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
>
> > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > ---
> >   tools/lib/bpf/bpf.c | 23 ++++++++++++++++++-----
> >   1 file changed, 18 insertions(+), 5 deletions(-)
>
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 240186aac8e6..781387e6f66b 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -99,31 +99,44 @@ static inline int sys_bpf_prog_load(union bpf_attr
> > *attr, unsigned int size, int
>
> >   /* Probe whether kernel switched from memlock-based (RLIMIT_MEMLOCK) to
> >    * memcg-based memory accounting for BPF maps and progs. This was done
> > in [0].
> > - * We use the support for bpf_ktime_get_coarse_ns() helper, which was
> > added in
> > - * the same 5.11 Linux release ([1]), to detect memcg-based accounting
> > for BPF.
> > + * To do so, we lower the soft memlock rlimit to 0 and attempt to create
> > a BPF
> > + * object. If it succeeds, then memcg-based accounting for BPF is
> > available.
> >    *
> >    *   [0]
> > https://lore.kernel.org/bpf/20201201215900.3569844-1-guro@fb.com/
> > - *   [1] d05512618056 ("bpf: Add bpf_ktime_get_coarse_ns helper")
> >    */
> >   int probe_memcg_account(void)
> >   {
> >       const size_t prog_load_attr_sz = offsetofend(union bpf_attr,
> > attach_btf_obj_fd);
> >       struct bpf_insn insns[] = {
> > -             BPF_EMIT_CALL(BPF_FUNC_ktime_get_coarse_ns),
> >               BPF_EXIT_INSN(),
> >       };
> > +     struct rlimit rlim_init, rlim_cur_zero = {};
> >       size_t insn_cnt = ARRAY_SIZE(insns);
> >       union bpf_attr attr;
> >       int prog_fd;
>
> > -     /* attempt loading freplace trying to use custom BTF */
> >       memset(&attr, 0, prog_load_attr_sz);
> >       attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
> >       attr.insns = ptr_to_u64(insns);
> >       attr.insn_cnt = insn_cnt;
> >       attr.license = ptr_to_u64("GPL");
>
> > +     if (getrlimit(RLIMIT_MEMLOCK, &rlim_init))
> > +             return -1;
> > +
> > +     /* Drop the soft limit to zero. We maintain the hard limit to its
> > +      * current value, because lowering it would be a permanent operation
> > +      * for unprivileged users.
> > +      */
> > +     rlim_cur_zero.rlim_max = rlim_init.rlim_max;
> > +     if (setrlimit(RLIMIT_MEMLOCK, &rlim_cur_zero))
> > +             return -1;
> > +
> >       prog_fd = sys_bpf_fd(BPF_PROG_LOAD, &attr, prog_load_attr_sz);
> > +
> > +     /* reset soft rlimit as soon as possible */
> > +     setrlimit(RLIMIT_MEMLOCK, &rlim_init);
>
> Isn't that adding more flakiness to the other daemons running as
> the same user? Also, there might be surprises if another daemon that
> has libbpf in it starts right when we've set the limit temporarily to zero.
>

I agree, it briefly changes global process state and can introduce
some undesirable (and very non-obvious) side effects.

> Can we push these decisions to the users as part of libbpf 1.0 cleanup?


Quentin, at least for bpftool, I think it's totally fine to just
always bump RLIMIT_MEMLOCK to avoid this issue. That would solve the
issue with probing, right? And for end applications I think I agree
with Stanislav that application might need to ensure rlimit bumping
for such backported changes.


>
> > +
> >       if (prog_fd >= 0) {
> >               close(prog_fd);
> >               return 1;
> > --
> > 2.34.1
>
