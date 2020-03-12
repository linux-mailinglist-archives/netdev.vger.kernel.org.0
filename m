Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2635E183D49
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgCLX1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:27:19 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38768 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgCLX1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:27:19 -0400
Received: by mail-qk1-f193.google.com with SMTP id h14so9437500qke.5;
        Thu, 12 Mar 2020 16:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiM2ltf/8QOlDjhkASi+H04IFyQ2p4Bmuv++pNA1Nq0=;
        b=d2QtAHuZQu16etpGyLI9QF3DGhWB3ABeID1KxIgQHZbAt+M0BuaTNmLyJPMaqZuu9k
         FsdBP/UOsmDIRbTGzMGBJO75hWh9BehYW9h7SGOdU2TvZWV+OJfBCdNPFxRQPMAuN+2D
         iscEJOt//rmB41DiZ6w9rbAfjMXOMxi9goopDR8NBqMXweIVTXy2Px59C4RB4xspvRIa
         Y/4twDidJdZAOLL9NKqIr2leKsO4IMDtTyFvLvilhcsOzf+GgdrZnW0QedLcS+ztNfQO
         Viv2p6LMNtwvH8S+akTt7mQ3UUluubbiG5VUXIzrDnkjtKhnwvIxgU+sp1dru6ZsIdg6
         m1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiM2ltf/8QOlDjhkASi+H04IFyQ2p4Bmuv++pNA1Nq0=;
        b=U7V8qVwYqJD/tqTiQk+OrrVh+Cw7IJf51XqrxdR1I9Uq6ITGQiUwZXTVqe+r9rY3JF
         HbRtHDWR0YB83v8bWeybq6oYvyTwzPd9gbW3hp4CMzhhQ19EOJoEyHC9Bc4mw+C1Ae5a
         H+quqcz1X8yKS/oe4lmP9xsbngFxzRJGQa/RWOkXQckq8aU56FHLKXlZuAHHmfFnAmMm
         ulBxS+Z2SfARu+yInsE55e6YSSSBdVKADvVdyf1lh6UzROGINuI+aYHfpxMxoL5vjSU1
         SjeNTmPEuWdm6fTUlHQZq2gkJFUZxM2xYT0vllYlrcQsA4xhuseMxQTGSiJ1+JdA/z6b
         llcQ==
X-Gm-Message-State: ANhLgQ0+zWC8iXe4On/i7QOE31OdBa3VSy56ZOBsU8qgoVlaWh2Xx88b
        c11xlu83+FLLuSDG4p3V3qn3TNsljRzIyALLe70=
X-Google-Smtp-Source: ADFU+vt6FVuN1DZ6WmcfOFCRRDKzD3ic4YinehJmkSJV7uiPTTH8e1pVkq06/W/nWQawfwRz2Q5/jf81qez8YUom+sM=
X-Received: by 2002:a37:6411:: with SMTP id y17mr10570387qkb.437.1584055637717;
 Thu, 12 Mar 2020 16:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200312203914.1195762-1-andriin@fb.com> <2d6ae192-fe22-0239-54c7-142ec21b7794@iogearbox.net>
In-Reply-To: <2d6ae192-fe22-0239-54c7-142ec21b7794@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Mar 2020 16:27:06 -0700
Message-ID: <CAEf4BzbcSC3LXckg3ksRhTN27g4sAXp_9-GgJFog21ZWAJU-DQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: abstract away entire bpf_link clean up procedure
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 4:23 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/12/20 9:39 PM, Andrii Nakryiko wrote:
> > Instead of requiring users to do three steps for cleaning up bpf_link, its
> > anon_inode file, and unused fd, abstract that away into bpf_link_cleanup()
> > helper. bpf_link_defunct() is removed, as it shouldn't be needed as an
> > individual operation anymore.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   include/linux/bpf.h  |  3 ++-
> >   kernel/bpf/syscall.c | 18 +++++++++++-------
> >   2 files changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 4fd91b7c95ea..358f3eb07c01 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1075,7 +1075,8 @@ struct bpf_link_ops {
> >
> >   void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
> >                  struct bpf_prog *prog);
> > -void bpf_link_defunct(struct bpf_link *link);
> > +void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
> > +                   int link_fd);
> >   void bpf_link_inc(struct bpf_link *link);
> >   void bpf_link_put(struct bpf_link *link);
> >   int bpf_link_new_fd(struct bpf_link *link);
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index b2f73ecacced..d2f49ae225b0 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2188,9 +2188,17 @@ void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
> >       link->prog = prog;
> >   }
> >
> > -void bpf_link_defunct(struct bpf_link *link)
> > +/* Clean up bpf_link and corresponding anon_inode file and FD. After
> > + * anon_inode is created, bpf_link can't be just kfree()'d due to deferred
> > + * anon_inode's release() call. This helper manages marking bpf_link as
> > + * defunct, releases anon_inode file and puts reserved FD.
> > + */
> > +void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
> > +                   int link_fd)
>
> Looks good, but given it is only used here this should be static instead.
>

This is part of bpf_link internal API. I have patches locally for
cgroup bpf_link that use this for clean up as well already, other
bpf_link types will also use this.

> >   {
> >       link->prog = NULL;
> > +     fput(link_file);
> > +     put_unused_fd(link_fd);
> >   }
> >
> >   void bpf_link_inc(struct bpf_link *link)
> > @@ -2383,9 +2391,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
> >
> >       err = bpf_trampoline_link_prog(prog);
> >       if (err) {
> > -             bpf_link_defunct(&link->link);
> > -             fput(link_file);
> > -             put_unused_fd(link_fd);
> > +             bpf_link_cleanup(&link->link, link_file, link_fd);
> >               goto out_put_prog;
> >       }
> >
> > @@ -2498,9 +2504,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
> >
> >       err = bpf_probe_register(link->btp, prog);
> >       if (err) {
> > -             bpf_link_defunct(&link->link);
> > -             fput(link_file);
> > -             put_unused_fd(link_fd);
> > +             bpf_link_cleanup(&link->link, link_file, link_fd);
> >               goto out_put_btp;
> >       }
> >
> >
>
