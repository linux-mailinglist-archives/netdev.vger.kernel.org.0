Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B406B4AA15
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbfFRSl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:41:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35363 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730060AbfFRSlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:41:25 -0400
Received: by mail-lj1-f193.google.com with SMTP id x25so608330ljh.2;
        Tue, 18 Jun 2019 11:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DJLrvL9J3hS2txWU4rwvYtfkkJ0VVqVRpiM8b1MdqDs=;
        b=Yob3O00VdrixZ26sFE8d4GZOnliwvMeAze/Cas41TuPtW7jaOAwS3WADHQElaVjq0b
         jiNjPyNYBhcsCvANwerwmAhO9rW1gS6LPse7Rq6sMfUPEZG0QzOciuNQHU1M5JtbrKaf
         pfFTpbTTzUS+095DiYkgk1pS64PnjdBIJ2JoEuyySWW0oPqBmAfvS0BiO4ipcBdV0LGv
         0nVPI2yi7pigL9PNbz6KtDq2SfGM/iU1A+x/vTmnCM1hAOqNX8oAoO5RSuDiFztQ67BO
         rH7kql2k7FqH213BcONqXs/X1bD9WNFDD34jg5UOI6w6ryfplTuZmKqZzNfRmuFT37V+
         er8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DJLrvL9J3hS2txWU4rwvYtfkkJ0VVqVRpiM8b1MdqDs=;
        b=HNA6J+nnUcO48R2z3oocjjT/VoOi88moQ0TiCNHQAhV6djaJzWx3BiD//2C0L84h4r
         6SIC4SVaTqpXL7nGgeU0nXnruPLlYSQKfFsLuZfau57qzBlKK31fe1r9z084NzRgvdnI
         ExWq5Nr9OPlej5EKcj665yH53XntwbMBjaQ8LW4orqowwAXjzE5tcBROgDpHEvEY8FNY
         SfFlyOAlDV50VTqsR9lQPgTjm33V75j34hW6gEM6Eo9/JrSpTD6BhxwsNsSO8mhAtT9D
         6Y8FqfMRjiLwA1eC81GVuuSxRBJ8pwSFyRRb/IJbQdaH6JGNqEcZ5IudpA6+aoal3NIo
         BxWg==
X-Gm-Message-State: APjAAAXG4LlMtIL6N1IN7Oksuows1Dlpqj3cHNqjwqMLauxGAi9lNNh0
        4CJeLHZL8EKa21njuDdOrF2FLv1+frxVpDXKsQA=
X-Google-Smtp-Source: APXvYqyzqjZErueptxEPtLixGhhXjqGYMX/q9Li2tpkzFw/YvGvB3DzUavccTah9T2sj9HcbUYt864/NuaW/fFi+bx4=
X-Received: by 2002:a2e:968e:: with SMTP id q14mr21628122lji.195.1560883282935;
 Tue, 18 Jun 2019 11:41:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190617180109.34950-1-sdf@google.com> <20190617180109.34950-2-sdf@google.com>
 <20190618163117.yuw44b24lo6prsrz@ast-mbp.dhcp.thefacebook.com>
 <20190618164913.GI9636@mini-arch> <20190618180944.GJ9636@mini-arch>
In-Reply-To: <20190618180944.GJ9636@mini-arch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Jun 2019 11:41:11 -0700
Message-ID: <CAADnVQ+kymi+zJww+PfPd4WWhvNA67ynGVTd7oj6jiU+XFeguQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/9] bpf: implement getsockopt and setsockopt hooks
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 11:09 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/18, Stanislav Fomichev wrote:
> > On 06/18, Alexei Starovoitov wrote:
> > > On Mon, Jun 17, 2019 at 11:01:01AM -0700, Stanislav Fomichev wrote:
> > > > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > > > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > > >
> > > > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> > > > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > > > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> > > >
> > > > The buffer memory is pre-allocated (because I don't think there is
> > > > a precedent for working with __user memory from bpf). This might be
> > > > slow to do for each {s,g}etsockopt call, that's why I've added
> > > > __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> > > > attached to a cgroup. Note, however, that there is a race between
> > > > __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> > > > program layout might have changed; this should not be a problem
> > > > because in general there is a race between multiple calls to
> > > > {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
> > > >
> > > > The return code of the BPF program is handled as follows:
> > > > * 0: EPERM
> > > > * 1: success, execute kernel {s,g}etsockopt path after BPF prog exits
> > > > * 2: success, do _not_ execute kernel {s,g}etsockopt path after BPF
> > > >      prog exits
> > > >
> > > > Note that if 0 or 2 is returned from BPF program, no further BPF program
> > > > in the cgroup hierarchy is executed. This is in contrast with any existing
> > > > per-cgroup BPF attach_type.
> > >
> > > This is drastically different from all other cgroup-bpf progs.
> > > I think all programs should be executed regardless of return code.
> > > It seems to me that 1 vs 2 difference can be expressed via bpf program logic
> > > instead of return code.
> > >
> > > How about we do what all other cgroup-bpf progs do:
> > > "any no is no. all yes is yes"
> > > Meaning any ret=0 - EPERM back to user.
> > > If all are ret=1 - kernel handles get/set.
> > >
> > > I think the desire to differentiate 1 vs 2 came from ordering issue
> > > on getsockopt.
> > > How about for setsockopt all progs run first and then kernel.
> > > For getsockopt kernel runs first and then all progs.
> > > Then progs will have an ability to overwrite anything the kernel returns.
> > Good idea, makes sense. For getsockopt we'd also need to pass the return
> > value of the kernel getsockopt to let bpf programs override it, but seems
> > doable. Let me play with it a bit; I'll send another version if nothing
> > major comes up.
> >
> > Thanks for another round of review!
> One clarification: we'd still probably need to have 3 return codes for
> setsockopt:
> * any 0 - EPERM
> * all 1 - continue with the kernel path (i.e. apply this sockopt as is)
> * any 2 - return after all BPF hooks are executed (bypass kernel)
>           (any 0 trumps any 2 -> EPERM)
>
> The context is readonly for setsockopt, so it shouldn't be an issue.
> Let me know if you have better idea how to handle that.

I think we don't really need 2.
The progs can reduce optlen to zero (or optname to BPF_EMPTY_SOCKOPT)
and do ret=1.
Then the kernel can see that nothing to be be done and return 0 to user space.
Since parent prog in the chain will be able to see that child prog
set optlen to zero, it will be able to overwrite if necessary.

getsockopt wil be clean as well.
all 1s return whatever was produced by progs to user space.
and progs will be able to see what kernel wanted to return because
the kernel's getsockopt logic ran first.
ret=2 doesn't have any meaning for getsockopt, so nice to keep
setsockopt symmetrical and don't do it there either.
