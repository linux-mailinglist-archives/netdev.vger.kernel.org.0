Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF65C6DC
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 03:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfGBB72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 21:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbfGBB72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 21:59:28 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D7452173E
        for <netdev@vger.kernel.org>; Tue,  2 Jul 2019 01:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562032766;
        bh=vfBqxjBFiv4f2Mh6w2VjvKxzYfLG/G8MOOehI4eM1Uc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nkjEXELg0rCs3JkahPXhkWW6EzViUeJoi5Tv2L/pOtrLwWonVWt8noxz06g4cfFlO
         rxUgkfqRm1bSLTUZ81McgdZ8Z5lS7S5XR3she+E9wOAF+auHn/a2TYsPW9MWdbd+OU
         YReF4BpLlVklhrAbV5WG9GfEMh81O7RJuBVVpBj4=
Received: by mail-wm1-f51.google.com with SMTP id h19so1260550wme.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 18:59:26 -0700 (PDT)
X-Gm-Message-State: APjAAAVUE6lcnIrWJIURGIBQzQYjYnO5SQxS/4IZISgEaU+a43gYW6hJ
        nItPX0AQ8n18fUjs4I5czoZipxCLL/k6+sdXG0xQNQ==
X-Google-Smtp-Source: APXvYqxpnFWG683UJYpQwkpoYGb8geVG3M89fbVIJgxolQRP/j11U6qBqV/yYKmR+T9Z2qM7N9f7wEcMr/WxN5zmj6Q=
X-Received: by 2002:a7b:c450:: with SMTP id l16mr1276782wmi.0.1562032764995;
 Mon, 01 Jul 2019 18:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
In-Reply-To: <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 1 Jul 2019 18:59:13 -0700
X-Gmail-Original-Message-ID: <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
Message-ID: <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Song Liu <songliubraving@fb.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 2:03 AM Song Liu <songliubraving@fb.com> wrote:
>
> Hi Andy,
>
> Thanks for these detailed analysis.
>
> > On Jun 30, 2019, at 8:12 AM, Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Fri, Jun 28, 2019 at 12:05 PM Song Liu <songliubraving@fb.com> wrote=
:
> >>
> >> Hi Andy,
> >>
> >>> On Jun 27, 2019, at 4:40 PM, Andy Lutomirski <luto@kernel.org> wrote:
> >>>
> >>> On 6/27/19 1:19 PM, Song Liu wrote:
> >>>> This patch introduce unprivileged BPF access. The access control is
> >>>> achieved via device /dev/bpf. Users with write access to /dev/bpf ar=
e able
> >>>> to call sys_bpf().
> >>>> Two ioctl command are added to /dev/bpf:
> >>>> The two commands enable/disable permission to call sys_bpf() for cur=
rent
> >>>> task. This permission is noted by bpf_permitted in task_struct. This
> >>>> permission is inherited during clone(CLONE_THREAD).
> >>>> Helper function bpf_capable() is added to check whether the task has=
 got
> >>>> permission via /dev/bpf.
> >>>
> >>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>>> index 0e079b2298f8..79dc4d641cf3 100644
> >>>> --- a/kernel/bpf/verifier.c
> >>>> +++ b/kernel/bpf/verifier.c
> >>>> @@ -9134,7 +9134,7 @@ int bpf_check(struct bpf_prog **prog, union bp=
f_attr *attr,
> >>>>             env->insn_aux_data[i].orig_idx =3D i;
> >>>>     env->prog =3D *prog;
> >>>>     env->ops =3D bpf_verifier_ops[env->prog->type];
> >>>> -    is_priv =3D capable(CAP_SYS_ADMIN);
> >>>> +    is_priv =3D bpf_capable(CAP_SYS_ADMIN);
> >>>
> >>> Huh?  This isn't a hardening measure -- the "is_priv" verifier mode a=
llows straight-up leaks of private kernel state to user mode.
> >>>
> >>> (For that matter, the pending lockdown stuff should possibly consider=
 this a "confidentiality" issue.)
> >>>
> >>>
> >>> I have a bigger issue with this patch, though: it's a really awkward =
way to pretend to have capabilities. For bpf, it seems like you could make =
this be a *real* capability without too much pain since there's only one sy=
scall there.  Just find a way to pass an fd to /dev/bpf into the syscall.  =
If this means you need a new bpf_with_cap() syscall that takes an extra arg=
ument, so be it.  The old bpf() syscall can just translate to bpf_with_cap(=
..., -1).
> >>>
> >>> For a while, I've considered a scheme I call "implicit rights".  Ther=
e would be a directory in /dev called /dev/implicit_rights.  This would eit=
her be part of devtmpfs or a whole new filesystem -- it would *not* be any =
other filesystem.  The contents would be files that can't be read or writte=
n and exist only in memory. You create them with a privileged syscall.  Cer=
tain actions that are sensitive but not at the level of CAP_SYS_ADMIN (use =
of large-attack-surface bpf stuff, creation of user namespaces, profiling t=
he kernel, etc) could require an "implicit right".  When you do them, if yo=
u don't have CAP_SYS_ADMIN, the kernel would do a path walk for, say, /dev/=
implicit_rights/bpf and, if the object exists, can be opened, and actually =
refers to the "bpf" rights object, then the action is allowed.  Otherwise i=
t's denied.
> >>>
> >>> This is extensible, and it doesn't require the rather ugly per-task s=
tate of whether it's enabled.
> >>>
> >>> For things like creation of user namespaces, there's an existing API,=
 and the default is that it works without privilege.  Switching it to an im=
plicit right has the benefit of not requiring code changes to programs that=
 already work as non-root.
> >>>
> >>> But, for BPF in particular, this type of compatibility issue doesn't =
exist now.  You already can't use most eBPF functionality without privilege=
.  New bpf-using programs meant to run without privilege are *new*, so they=
 can use a new improved API.  So, rather than adding this obnoxious ioctl, =
just make the API explicit, please.
> >>>
> >>> Also, please cc: linux-abi next time.
> >>
> >> Thanks for your inputs.
> >>
> >> I think we need to clarify the use case here. In this case, we are NOT
> >> thinking about creating new tools for unprivileged users. Instead, we
> >> would like to use existing tools without root.
> >
> > I read patch 4, and I interpret it very differently.  Patches 2-4 are
> > creating a new version of libbpf and a new version of bpftool.  Given
> > this, I see no real justification for adding a new in-kernel per-task
> > state instead of just pushing the complexity into libbpf.
>
> I am not sure whether we are on the same page. Let me try an example,
> say we have application A, which calls sys_bpf().
>
> Before the series: we have to run A with root;
> After the series:  we add a special user with access to /dev/bpf, and
>                    run A with this special user.
>
> If we look at the whole system, I would say we are more secure after
> the series.
>
> I am not trying to make an extreme example here, because this use case
> is the motivation here.
>
> To stay safe, we have to properly manage the permission of /dev/bpf.
> This is just like we need to properly manage access to /etc/sudoers and
> /dev/mem.
>
> Does this make sense?
>

I think I'm understanding your motivation.  You're not trying to make
bpf() generically usable without privilege -- you're trying to create
a way to allow certain users to access dangerous bpf functionality
within some limits.

That's a perfectly fine goal, but I think you're reinventing the
wheel, and the wheel you're reinventing is quite complicated and
already exists.  I think you should teach bpftool to be secure when
installed setuid root or with fscaps enabled and put your policy in
bpftool.  If you want to harden this a little bit, it would seem
entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
not all, of the capable() checks to check CAP_BPF_ADMIN instead of the
capabilities that they currently check.

Your example of /etc/sudoers is apt, and it does not involve any
kernel support :)
