Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D57435641
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 01:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhJTXEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 19:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhJTXE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 19:04:29 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74E7C061753;
        Wed, 20 Oct 2021 16:02:14 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id r184so15864604ybc.10;
        Wed, 20 Oct 2021 16:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RVhYIarSWZE8BXpUxqb7NLQxJjfl+O9Hp2K98jz+RM4=;
        b=KQzaieknGy7KMvT5SygmrkKJbHzDP0o1/vim8/n8L2yFNHskPUX6PY++Xkiu3n9ty8
         MeQcku0NTlunsfMj76GoMF81/yGwHCK5kGe2L8zf7U9+2o9hPgbKGsvu5xIYJ3jNYOQZ
         EjYgc46YMdIvlO7Lzgxqko2zQnfCY1yNYR9MI6saReASsSZGgUNSfr8DTZhkNU0aiWy1
         fGlvWBAm6R+8J+be6BBQ5OnGephElMEHVdKXVAWoEg7vzq92K1V93QEeZaZDg+NsgYBF
         d4M3eMElp8fKJtkq5mgQN8N9inxqOgjHpBrqtYjVp68cD+lCrbkDDwD6imoyznNkz0I9
         ea6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RVhYIarSWZE8BXpUxqb7NLQxJjfl+O9Hp2K98jz+RM4=;
        b=4vh12d09v6GCnmd4ifU5vMqLrsG+9xSablv3shmYDq9GyMND7/iWW/Yx3xXsbeAd1K
         vmmdSBm8vHIQAf5zWkQ10CTB9o9/LyPym6ql3UPubqD6ZxvpV/czK/8HpK1z+yG5cFMI
         cluhz7ro371W5pIiYOQ/LhnpZTHWjv998hfJI1+oaQw8VbU+T+Ny8Yqp7YXka8hlI0n5
         2KW9qIGJdSrFunwKcSaahdNOJQyTRJkYK5TAmBtvpp5jIG4FjNpF8eNvUIcQ5HJrFUXi
         vm6RjI90xcGvv37tVLQkT345iGC0y60GaGVqeYSMLWG/d03raWkmHhQCSlzwaZZaCIgm
         S8Yw==
X-Gm-Message-State: AOAM5310SvD1ivMyw7v9lqTWGt0twrsfXHX4HbMjl1Xosm4Bk0DATWjM
        ex5aRGpz7a/MnFPGziL2sgWuHlcdyR4WPNE5V7mS5XFO/qPDpA==
X-Google-Smtp-Source: ABdhPJzangV2d+8Ys5pHQopS2MBXhqRHXfbJfxLJknGT8AHP+AF6eYJ8Emwj49NtgtrWHPrUSVdiNazaMPomrkylntw=
X-Received: by 2002:a25:918e:: with SMTP id w14mr2050835ybl.225.1634770934101;
 Wed, 20 Oct 2021 16:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20211020191526.2306852-1-memxor@gmail.com> <20211020191526.2306852-5-memxor@gmail.com>
 <CAEf4BzbWeVOATjjRTdoKUvrwdmObcRO1X_FBKOm4zHjP5Rie4w@mail.gmail.com> <20211020223322.luzn2ptajxhi2keo@apollo.localdomain>
In-Reply-To: <20211020223322.luzn2ptajxhi2keo@apollo.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 16:02:03 -0700
Message-ID: <CAEf4BzYneSm9+Mx7TM=Oze=w5uSCdi21SBzM7MwaNRoXqDRfmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/8] libbpf: Ensure that BPF syscall fds are
 never 0, 1, or 2
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 3:33 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Thu, Oct 21, 2021 at 03:39:08AM IST, Andrii Nakryiko wrote:
> > On Wed, Oct 20, 2021 at 12:15 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > Add a simple wrapper for passing an fd and getting a new one >= 3 if it
> > > is one of 0, 1, or 2. There are two primary reasons to make this change:
> > > First, libbpf relies on the assumption a certain BPF fd is never 0 (e.g.
> > > most recently noticed in [0]). Second, Alexei pointed out in [1] that
> > > some environments reset stdin, stdout, and stderr if they notice an
> > > invalid fd at these numbers. To protect against both these cases, switch
> > > all internal BPF syscall wrappers in libbpf to always return an fd >= 3.
> > > We only need to modify the syscall wrappers and not other code that
> > > assumes a valid fd by doing >= 0, to avoid pointless churn, and because
> > > it is still a valid assumption. The cost paid is two additional syscalls
> > > if fd is in range [0, 2].
> > >
> > > This is only done for fds that are held by objects created using libbpf,
> > > or returned from libbpf functions, not for intermediate fds closed soon
> > > after their use is over. This implies that one of the assumptions is
> > > that the environment resetting fds in the starting range [0, 2] only do
> > > so before libbpf function call or after, but never in parallel, since
> > > that would close fds while we dup them.
> > >
> > > [0]: e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")
> > > [1]: https://lore.kernel.org/bpf/CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com

see my recent reply to Dave, so far such references were always
indented by two spaces (AFAIK)

> > >
> > > Acked-by: Song Liu <songliubraving@fb.com>
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  tools/lib/bpf/bpf.c             | 28 ++++++++++++-------------
> > >  tools/lib/bpf/libbpf.c          | 36 ++++++++++++++++-----------------
> > >  tools/lib/bpf/libbpf_internal.h | 23 +++++++++++++++++++++
> > >  tools/lib/bpf/linker.c          |  2 +-
> > >  tools/lib/bpf/ringbuf.c         |  2 +-
> > >  tools/lib/bpf/skel_internal.h   | 35 +++++++++++++++++++++++++++++++-
> > >  6 files changed, 91 insertions(+), 35 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > > index 7d1741ceaa32..0e1dedd94ebf 100644
> > > --- a/tools/lib/bpf/bpf.c
> > > +++ b/tools/lib/bpf/bpf.c
> > > @@ -74,7 +74,7 @@ static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size)
> > >                 fd = sys_bpf(BPF_PROG_LOAD, attr, size);
> > >         } while (fd < 0 && errno == EAGAIN && retries-- > 0);
> > >
> > > -       return fd;
> > > +       return ensure_good_fd(fd);
> > >  }
> > >
> > >  int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
> > > @@ -104,7 +104,7 @@ int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
> > >                 attr.inner_map_fd = create_attr->inner_map_fd;
> > >
> > >         fd = sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
> > > -       return libbpf_err_errno(fd);
> > > +       return libbpf_err_errno(ensure_good_fd(fd));
> >
> > I think it will be cleaner in all the places to do
> >
> > fd = ensure_good_fd(fd);
> >
> > That's especially true for more complicated multi-line invocations,
> > like the ones with perf_event_open syscall.
> >
>
> Ok, will fix.
>
> > But also, I feel like adding a sys_bpf_fd() wrapper to use for all bpf
> > syscalls that can return FDs would be cleaner still and will make it
> > more obvious which APIs return "objects" (that is, FDs). Then you'll
> > have ensure_good_fd() business in one or maybe just a few places,
> > instead of spread around a dozen functions.
> >
>
> Can you give a short example?

Sure.

static inline int sys_bpf_fd(enum bpf_cmd cmd, union bpf_attr *attr)
{
    int fd;

    fd = syscall(__NR_BPF, cmd, attr, sizeof(*attr));
    fd = ensure_good_fd(fd);
    return fd;
}

>
> > >  }
> > >

[...]

> > >         /* pid filter is meaningful only for uprobes */
> > > -       pfd = syscall(__NR_perf_event_open, &attr,
> > > -                     pid < 0 ? -1 : pid /* pid */,
> > > -                     pid == -1 ? 0 : -1 /* cpu */,
> > > -                     -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> > > +       pfd = ensure_good_fd(syscall(__NR_perf_event_open, &attr,
> > > +                            pid < 0 ? -1 : pid /* pid */,
> > > +                            pid == -1 ? 0 : -1 /* cpu */,
> > > +                            -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC));
> >
> > see above, pfd = ensure_good_fd(pfd) on a separate line after
> > syscall() is much cleaner
> >
> > but thinking about this some more... do we ever pass perf_event_fd
> > into BPF UAPI? I don't think so, so there is no need to enforce FD >
> > 0. Let's drop that everywhere for perf_event_open().
> >
>
> I thought it was not just about BPF UAPI anymore, but also the first three fds
> that can be closed by the runtime. So any fds held across calls, inside objects,
> or returned from libbpf syscall functions needed to go through this. For fds
> that are temporarily open and then closed later, it doesn't matter (because even
> when duplicating the fd, we temporarily open an fd in the invalid slot, so if
> someone was closing it in parallel, it would already be a problem).

I think you are a bit overzealous about "preventing" this FD > 2
problem here. If it was such an easy problem to run into, not just
libbpf, but any library that opens files would be broken. So clearly
this doesn't happen all the time. I assume that apps where such
stdin/stdout/stderr forcing happens get those FD 0, 1, 2 "fixed" way
before libbpf gets involved. If someone is trying to be clever and
manipulates FD 0, 1, 2 manually, sure, then they will run into
troubles. But libbpf doesn't do anything clever like that. So it's
fine if we enforce FD > 2, not just FD > 0 (it's one fcntl() syscall
anyway), but let's not overdo it. We should be intentional about doing
this only for BPF objects (progs, btfs, maps, links; that's it).

>
> >
> > >         if (pfd < 0) {
> > >                 err = -errno;
> > >                 pr_warn("%s perf_event_open() failed: %s\n",

[...]

> > >
> > > @@ -472,4 +474,25 @@ static inline bool is_ldimm64_insn(struct bpf_insn *insn)
> > >         return insn->code == (BPF_LD | BPF_IMM | BPF_DW);
> > >  }
> > >
> > > +/* if fd is stdin, stdout, or stderr, dup to a fd greater than 2
> > > + * Takes ownership of the fd passed in, and closes it if calling
> > > + * fcntl(fd, F_DUPFD_CLOEXEC, 3).
> > > + */
> > > +static inline int ensure_good_fd(int fd)
> > > +{
> > > +       int old_fd = fd, save_errno;
> > > +
> > > +       if (unlikely(fd >= 0 && fd < 3)) {
> > > +               fd = fcntl(fd, F_DUPFD_CLOEXEC, 3);
> > > +               if (fd < 0) {
> > > +                       save_errno = errno;
> > > +                       pr_warn("failed to dup FD %d to FD > 2: %d\n", old_fd, -errno);
> > > +               }
> > > +               close(old_fd);
> > > +               if (fd < 0)
> > > +                       errno = save_errno;
> > > +       }
> > > +       return fd;
> >
> > with all the if nestedness it looks more complicated than it needs to.
> > How about something like this:
> >
> > if (fd < 0)
> >     return fd;
> >
> > if (fd < 3) {
> >     fd = fcnt(...);
> >     save_errno = errno;
> >     close(old_fd);
> >     if (fd < 0) {
> >        pr_warn(...);
> >        errno = saved_errno;
> >     }
> > }
> >
> > return fd;
> >
> >
> > WDYT?
> >
>
> Looks better, I'll do it like this.
>

Thanks.

> > > +}
> > > +

[...]

>
> >
> > But also, why do still need to "reserve" bad FDs at all with all the
> > ensure_good_fd() business?
> >
>
> This file is included in light skeleton, so it never goes through libbpf syscall


oh yeah? ;) how about bpf_create_map_name() just a few lines below?..

But in general, I don't think you should worry about this FD problem
for skeleton at all. Even if FD 0 is unused,
skel_sys_bpf(BPF_PROG_LOAD) will take it, so whatever loader prog is
doing in the kernel will get FD > 0 automatically. I think you can
drop this fragile "FD reservation" logic.

> wrappers, also, not only will it invoke bpf syscall before calling
> BPF_PROG_TEST_RUN, but also inside the syscall loader program. In there, doing
> the fcntl stuff is much ugly (add a helper, more BPF assembly in gen_loader), so
> I just reserve 3 fds in the beginning of the code sequence where fds are
> acquired, and release them after we're done.
>
> > > +                       close(fd);
> > > +                       break;
> > > +               }
> > > +               fds[i] = fd;
> > > +       }
> > > +       return 0;
> > > +}
> > > +
> > >  static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
> > >  {
> > > -       int map_fd = -1, prog_fd = -1, key = 0, err;
> > > +       int map_fd = -1, prog_fd = -1, key = 0, err, i;
> > > +       int res_fds[3] = { -1, -1, -1 };
> > >         union bpf_attr attr;
> > >
> > > +       /* ensures that we don't open fd 0, 1, or 2 from here on out */
> > > +       err = skel_reserve_bad_fds(opts, res_fds);
> > > +       if (err < 0) {
> > > +               errno = -err;
> > > +               goto out;
> > > +       }
> > > +
> > >         map_fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "__loader.map", 4,
> > >                                      opts->data_sz, 1, 0);
> > >         if (map_fd < 0) {
> > > @@ -115,6 +144,10 @@ static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
> > >         }
> > >         err = 0;
> > >  out:
> > > +       for (i = 0; i < 3; i++) {
> > > +               if (res_fds[i] >= 0)
> > > +                       close(res_fds[i]);
> > > +       }
> > >         if (map_fd >= 0)
> > >                 close(map_fd);
> > >         if (prog_fd >= 0)
> > > --
> > > 2.33.1
> > >
>
> --
> Kartikeya
