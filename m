Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1CCF5ADD7
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 02:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfF3AMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 20:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbfF3AMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 20:12:24 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E70A217D7
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 00:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561853542;
        bh=dry21q7c7uLneW8C+7n+tBewFMAQGQg4xVKmjaoSQko=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z110kg3Ic70AzYoTR5dCABspWFR19UTFe3C472D4aYeWL+gT9bEQBuVaVGlJg0vDg
         4IUa2DU1+FW/I5HS2YNXOEAH76twSShNLWRGBNXWE7FvTHubHi3LQfxmd2RBuHqeuJ
         08n8Hics4/bjToR8eSrlxyBGJxryJ/Vdo28kgy0M=
Received: by mail-wr1-f46.google.com with SMTP id n9so9978463wru.0
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 17:12:21 -0700 (PDT)
X-Gm-Message-State: APjAAAWdMNbEunp7sgj/RPZdbYkF4nbvP5z19lYvCl7HptYtMVHv096U
        bfTsUrCh7dlO5J+ap4Kn1T9sdlmWYffYfXJuhJQENw==
X-Google-Smtp-Source: APXvYqz/ogITgPfao2eygdVo/OX1Tsk1zmulDyd+kPJV5IoCxQg4RCMhJBnu7BsQaK5PH1oq2tR3PEmP4qr6ml80KNw=
X-Received: by 2002:adf:a143:: with SMTP id r3mr3437082wrr.352.1561853540531;
 Sat, 29 Jun 2019 17:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
In-Reply-To: <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 29 Jun 2019 17:12:09 -0700
X-Gmail-Original-Message-ID: <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
Message-ID: <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Song Liu <songliubraving@fb.com>, linux-security@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-abi@vger.kernel.org" <linux-abi@vger.kernel.org>,
        "kees@chromium.org" <kees@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 12:05 PM Song Liu <songliubraving@fb.com> wrote:
>
> Hi Andy,
>
> > On Jun 27, 2019, at 4:40 PM, Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On 6/27/19 1:19 PM, Song Liu wrote:
> >> This patch introduce unprivileged BPF access. The access control is
> >> achieved via device /dev/bpf. Users with write access to /dev/bpf are =
able
> >> to call sys_bpf().
> >> Two ioctl command are added to /dev/bpf:
> >> The two commands enable/disable permission to call sys_bpf() for curre=
nt
> >> task. This permission is noted by bpf_permitted in task_struct. This
> >> permission is inherited during clone(CLONE_THREAD).
> >> Helper function bpf_capable() is added to check whether the task has g=
ot
> >> permission via /dev/bpf.
> >
> >> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >> index 0e079b2298f8..79dc4d641cf3 100644
> >> --- a/kernel/bpf/verifier.c
> >> +++ b/kernel/bpf/verifier.c
> >> @@ -9134,7 +9134,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_=
attr *attr,
> >>              env->insn_aux_data[i].orig_idx =3D i;
> >>      env->prog =3D *prog;
> >>      env->ops =3D bpf_verifier_ops[env->prog->type];
> >> -    is_priv =3D capable(CAP_SYS_ADMIN);
> >> +    is_priv =3D bpf_capable(CAP_SYS_ADMIN);
> >
> > Huh?  This isn't a hardening measure -- the "is_priv" verifier mode all=
ows straight-up leaks of private kernel state to user mode.
> >
> > (For that matter, the pending lockdown stuff should possibly consider t=
his a "confidentiality" issue.)
> >
> >
> > I have a bigger issue with this patch, though: it's a really awkward wa=
y to pretend to have capabilities.  For bpf, it seems like you could make t=
his be a *real* capability without too much pain since there's only one sys=
call there.  Just find a way to pass an fd to /dev/bpf into the syscall.  I=
f this means you need a new bpf_with_cap() syscall that takes an extra argu=
ment, so be it.  The old bpf() syscall can just translate to bpf_with_cap(.=
.., -1).
> >
> > For a while, I've considered a scheme I call "implicit rights".  There =
would be a directory in /dev called /dev/implicit_rights.  This would eithe=
r be part of devtmpfs or a whole new filesystem -- it would *not* be any ot=
her filesystem.  The contents would be files that can't be read or written =
and exist only in memory.  You create them with a privileged syscall.  Cert=
ain actions that are sensitive but not at the level of CAP_SYS_ADMIN (use o=
f large-attack-surface bpf stuff, creation of user namespaces, profiling th=
e kernel, etc) could require an "implicit right".  When you do them, if you=
 don't have CAP_SYS_ADMIN, the kernel would do a path walk for, say, /dev/i=
mplicit_rights/bpf and, if the object exists, can be opened, and actually r=
efers to the "bpf" rights object, then the action is allowed.  Otherwise it=
's denied.
> >
> > This is extensible, and it doesn't require the rather ugly per-task sta=
te of whether it's enabled.
> >
> > For things like creation of user namespaces, there's an existing API, a=
nd the default is that it works without privilege.  Switching it to an impl=
icit right has the benefit of not requiring code changes to programs that a=
lready work as non-root.
> >
> > But, for BPF in particular, this type of compatibility issue doesn't ex=
ist now.  You already can't use most eBPF functionality without privilege. =
 New bpf-using programs meant to run without privilege are *new*, so they c=
an use a new improved API.  So, rather than adding this obnoxious ioctl, ju=
st make the API explicit, please.
> >
> > Also, please cc: linux-abi next time.
>
> Thanks for your inputs.
>
> I think we need to clarify the use case here. In this case, we are NOT
> thinking about creating new tools for unprivileged users. Instead, we
> would like to use existing tools without root.

I read patch 4, and I interpret it very differently.  Patches 2-4 are
creating a new version of libbpf and a new version of bpftool.  Given
this, I see no real justification for adding a new in-kernel per-task
state instead of just pushing the complexity into libbpf.

> On the kernel side, we are not planning provides a subset of safe
> features for unprivileged users. The permission here is all-or-nothing.

This may be a showstopper.  I think this series needs an extremely
clear explanation of the security implications of providing access to
/dev/bpf.  Is it just exposing more attack surface for kernel bugs, or
is it, *by design*, exposing new privileges.  Given the is_priv change
that I pointed out upthread, it appears to be the latter, and I'm
wondering how this is a reasonable thing to do.

>
> Introducing bpf_with_cap() syscall means we need teach these tools to
> manage the fd, and use the new API when necessary. This is clearly not
> easy.

How hard can it be?  I looked the the libbpf sources, and there are
really very few call sites of sys_bpf().  You could update all of them
with a very small patch.

Also, on a quick survey of kernel/bpf's capable() calls, I feel like
this series may be misguided.  If you want to enable unprivileged or
less privileged use of bpf(), how about going through all of the
capable() calls and handling them one-by-one as appropriate.  Here's a
random survey:

map_freeze(): It looks like the only reason for a capable() call is
that there isn't a clear permission model right now defining who owns
a map and therefore may freeze it.  Could you not use a check along
the lines of capable_wrt_inode_uidgid() instead of capable()?

        if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
            (attr->prog_flags & BPF_F_ANY_ALIGNMENT) &&
            !capable(CAP_SYS_ADMIN))
                return -EPERM;

I'm not sure why this is needed at all?  Is it a DoS mitigation?  If
so, couldn't you find a way to acocunt for inefficient unaligned
access similarly to how you account for complexity in general?

        if (attr->insn_cnt =3D=3D 0 ||
            attr->insn_cnt > (capable(CAP_SYS_ADMIN) ?
BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
                return -E2BIG;

This is similar.  I could imagine a cgroup setting that limits bpf
program complexity.  This is very, very different type of privilege
than reading kernel memory.

        if (type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
            type !=3D BPF_PROG_TYPE_CGROUP_SKB &&
            !capable(CAP_SYS_ADMIN))
                return -EPERM;

I suspect you could just delete this check or expand the allowable
unprivileged program types after auditing that the other types have
appropriately restrictive verifiers and require appropriate
permissions to *run* the programs.

In bpf_prog_attach():
        if (!capable(CAP_NET_ADMIN))
                return -EPERM;

This looks like it wants to be ns_capable() after you audit the code
to make sure it's safe enough.

bpf_prog_get_fd_by_id(): I really think you just need a real
permission model. Anyone can create a file on a filesystem, and there
are reasonable policies that allow appropriate users to open existing
files by name without CAP_SYS_ADMIN.  Similarly, anyone can create a
key in the kernel keyring subsystem, and there are well-defined rules
under which someone can access an existing key by name.  I think you
should come up with a way to handle this for bpf.  Adding a bpffs for
this seems like a decent approach.

bpf_prog_get_info_by_id():

        if (!capable(CAP_SYS_ADMIN)) {
                info.jited_prog_len =3D 0;
                info.xlated_prog_len =3D 0;
                info.nr_jited_ksyms =3D 0;
                info.nr_jited_func_lens =3D 0;
                info.nr_func_info =3D 0;
                info.nr_line_info =3D 0;
                info.nr_jited_line_info =3D 0;
                goto done;
        }

It looks like someone decided this information was sensitive if you
query someone else's program.  Again, there are sensible ways to
address this.

Finally, in the verifier:

is_priv =3D capable(CAP_SYS_ADMIN);

That should just be left alone.  Arguably you could make a new
capability CAP_BPF_LEAK_KERNEL_ADDRESSES or similar for this.

As it stands, it seems like bpf() was designed under the assumption
that the kind of security model needed to make it work well for
unprivileged or differently-privileged users would be developed later.
But, instead of developing such a security model, this patch is
introducing a whole new Linux "capability" that just disables all
security.  From my perspective, this seems like a bad idea.

So, if anyone cares about my opinion, NAK to the whole concept.
Please instead work on fixing this for real, one capable() check at a
time.
