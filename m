Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6A7266280
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgIKPuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgIKPtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:49:50 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7D1C061756
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 08:49:37 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id p4so10333170qkf.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 08:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KK9DqDT0nRrrH1BnI4TG9/GxMoG/9TkPvavel0k2iEE=;
        b=OqKkm9m3GqjIFqLrSgv2aIJOycuG4TfjBYNODlxu6GOChwl5JD6GtO+/nhSsUlhsEs
         1+ak2c/fzhQUsmA4OnAUjxE/E7ANlooVJwmIQbg/fLF7nDcBDCYrZRAKW96g+mauow6j
         Xva5HvSsBHWgKmMx6anHFijKeKKkpz+wLHeJXJyQJKJDK+lQQ2KoHPX8xDo0ca5CvEXU
         5R7f4C6A404p4qsMetxqb9GtC5z8GxTo99DW6UA7m0T66IwIMOsmqXUJnuYT7c4xX/Gx
         K33g1XXQIxnxwQlYNHmoF+2I5I61hIw3zlo4C+hjELf1z4OZ9od70S76dPpDGDkpb+fL
         4euQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KK9DqDT0nRrrH1BnI4TG9/GxMoG/9TkPvavel0k2iEE=;
        b=RDdo0rSQKeSJRqSC3RjBts9EEjyLDm7fZuRl4Gd6/OGq1oRUWKqoFvZkbdpLDXLpdB
         BskiwQzWZLn4PmcpvAAYACf1pU/XqHpo3AFbfC12RrTqtTQzbKxkepLT9GIjTthtoZZ0
         Cpi0gM070fIoDcJm+Xh/HLeS/jASfgi3wKdZVV2cLrGlMFFl86ZVKlMsW+UxhO9UjJjI
         cAAshIPtujYUW6lc/TrkSVvWNPu5MHzWL1auT7Y5XjlF9wyolJNYrawAAyW28W6KhA+d
         5y6M8S86/oPinh698UVLSpFExQt6tvY/44ozVehA9bhadDCj60JDP0hY+QBnS8VZ0Qyz
         erng==
X-Gm-Message-State: AOAM530Gy6er1IUf70P3PMlpQ0thqrupfK0CvDvCk71rn8Pex8TD/Nn3
        e4h+C5wQYjEryayeoWhxs9ph5l/C+Z7UPUISpBUkeQ==
X-Google-Smtp-Source: ABdhPJyV20mOCwhrDag0+eZAX1vU/Jz/dfXavw/33DwtltASXUYEAJVFmM/510FVmVyZ62iheN+xfYrfiRZLDEttqIk=
X-Received: by 2002:a37:a6c3:: with SMTP id p186mr2077408qke.237.1599839376654;
 Fri, 11 Sep 2020 08:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com> <20200909182406.3147878-4-sdf@google.com>
 <CAEf4BzaOmaOHdc2kkWk9KEByZqU+cKWHnFmFin4D3C2+xNubew@mail.gmail.com>
In-Reply-To: <CAEf4BzaOmaOHdc2kkWk9KEByZqU+cKWHnFmFin4D3C2+xNubew@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 11 Sep 2020 08:49:25 -0700
Message-ID: <CAKH8qBtJoZpacMj+4sEJkt1BcQ1-oju=Z9SOVq-GxitUTJch=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/5] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .metadata section
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 12:41 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Sep 9, 2020 at 11:25 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > From: YiFei Zhu <zhuyifei@google.com>
> >
> > The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
> > When the libbpf tries to load a program, it will probe the kernel for
> > the support of this syscall and unconditionally bind .rodata section
>
> btw, you subject is out of sync, still mentions .metadata
Ooops, will fix, thanks!

> > to the program.
> >
> > Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> > Signed-off-by: YiFei Zhu <zhuyifei@google.com>
>
> Please drop zhuyifei@google.com from CC list (it's unreachable), when
> you submit a new version.
I think git-send-email automatically adds it because of the sign-off,
let me try to see if I can remove it. I guess I can just do
s/zhuyifei@google.com/zhuyifei1999@gmail.com/ to make
it quiet.

> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/lib/bpf/bpf.c      | 13 ++++++
> >  tools/lib/bpf/bpf.h      |  8 ++++
> >  tools/lib/bpf/libbpf.c   | 94 ++++++++++++++++++++++++++++++++--------
> >  tools/lib/bpf/libbpf.map |  1 +
> >  4 files changed, 98 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 82b983ff6569..5f6c5676cc45 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -872,3 +872,16 @@ int bpf_enable_stats(enum bpf_stats_type type)
> >
> >         return sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
> >  }
> > +
> > +int bpf_prog_bind_map(int prog_fd, int map_fd,
> > +                     const struct bpf_prog_bind_opts *opts)
> > +{
> > +       union bpf_attr attr;
> > +
>
> you forgot OPTS_VALID check here
Good point, will do!

> > @@ -3748,26 +3749,40 @@ static int probe_kern_global_data(void)
> >         map_attr.value_size = 32;
> >         map_attr.max_entries = 1;
> >
> > -       map = bpf_create_map_xattr(&map_attr);
> > -       if (map < 0) {
> > -               ret = -errno;
> > -               cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
> > +       *map = bpf_create_map_xattr(&map_attr);
> > +       if (*map < 0) {
> > +               err = errno;
> > +               cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
> >                 pr_warn("Error in %s():%s(%d). Couldn't create simple array map.\n",
> > -                       __func__, cp, -ret);
> > -               return ret;
> > +                       __func__, cp, -err);
> > +               return;
> >         }
> >
> > -       insns[0].imm = map;
> > +       insns[0].imm = *map;
>
> I think I already complained about this? You are assuming that
> insns[0] is BPF_LD_MAP_VALUE, which is true only for one case out of
> two already! It's just by luck that probe_prog_bind_map works because
> the verifier ignores the exit code, apparently.
>
> If this doesn't generalize well, don't generalize. But let's not do a
> blind instruction rewrite, which will cause tons of confusion later.
I might have missed your previous comment, sorry about that.
Agreed, it might be easier to just copy-paste the original function
and explicitly change the insns.

> [...]
>
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 92ceb48a5ca2..0b7830f4ff8b 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -308,4 +308,5 @@ LIBBPF_0.2.0 {
> >                 perf_buffer__epoll_fd;
> >                 perf_buffer__consume_buffer;
> >                 xsk_socket__create_shared;
> > +               bpf_prog_bind_map;
>
> please keep this list sorted
Sure, will do!
