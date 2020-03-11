Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D740181C37
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 16:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgCKPWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 11:22:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43941 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbgCKPWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 11:22:10 -0400
Received: by mail-qt1-f195.google.com with SMTP id l13so1812144qtv.10;
        Wed, 11 Mar 2020 08:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+XuEC6YpsVyHyILAIOZV81/k0zuEtXi/W/9shV+FDZY=;
        b=vcRq3YncvaNTTHaCYdaeDDF6B21k5AKx6Wpud88znCXg9psVExItvQwg03Stw0APZ9
         e5ZrYywvWM1N91b7Nb8oULMndqhBMBNTBAqFYFGg4OYJXa6ykFuKsvfnF7tTwgBjrsAO
         RUTnsNuuGCfJtj9Oco376etvq6vhCcPtaX5q11CJWX3g6AfkWO5i355ub5Ty9S5bolIm
         mjpQzus9eurc6HIqJxmNHmAKnje2muhP7w7KG61+FJv3YZG+vZZNp/VfJojc1p1Ls9wv
         KEwHq3WfJINq2QCn/OgYl28QzbBAYee6zF2kYSNTHOaaqIB6wf02d7oKdztbX2ka8lOu
         lPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+XuEC6YpsVyHyILAIOZV81/k0zuEtXi/W/9shV+FDZY=;
        b=F9G3GSdpVLE3NtAuEqmtxFXEvaYGk7D9OwmsBWj6jXuWatSrBeD5aRiobTw9OrouwM
         d6eIiYuygkp0Rq6e9J50NBgJyy9C6M8Er48AtEsjZlJnu5T9X0eeFoZkzl+MhFPMxFc9
         EAn+d4+EbBomvdKPtWYxVWE9ZY0J5hUE/N3Q3Nh0AGgu4hkKU0y/y8nlqXkEoMxG19MF
         08V9JC2XrHguyqycjSDdRME+ZtHtLzmMmBj1066184GFV7eaNTjr1xiUTWQJnfc+BxFX
         RK4CKyoVPyzEXAdHiTrhv+gXxzPsvLzIZ10RQWvkSsbgdVPYrrb4G0m1EYFw7DF2r6S7
         +lIA==
X-Gm-Message-State: ANhLgQ2hLtOxc7XfKUGlxItge19mSAS49bTxY4mpDIqzvAlqQQYV4KXo
        z32ZJV0Q+z+OjQNecajpSBUBskEQbtlynsZ49w0=
X-Google-Smtp-Source: ADFU+vu5PjyZshowGTeFR0/IH2JAKGr6iZLxo5cTaZMf7pWDqBLv3ZhuaDcIVYbDW3g9u1AJFaLwc6ChU1vH8VZTzqk=
X-Received: by 2002:ac8:1865:: with SMTP id n34mr2982890qtk.93.1583940127817;
 Wed, 11 Mar 2020 08:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200309231051.1270337-1-andriin@fb.com> <7467529c-b712-5314-ebbe-13f73ac01bdb@iogearbox.net>
In-Reply-To: <7467529c-b712-5314-ebbe-13f73ac01bdb@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Mar 2020 08:21:56 -0700
Message-ID: <CAEf4BzaKF17LeV8jaFJ74vS4v4vJ3ri1Pv_d48Umvr3bXN+vew@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add bpf_link_new_file that doesn't install FD
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

On Wed, Mar 11, 2020 at 6:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/10/20 12:10 AM, Andrii Nakryiko wrote:
> > Add bpf_link_new_file() API for cases when we need to ensure anon_inode is
> > successfully created before we proceed with expensive BPF program attachment
> > procedure, which will require equally (if not more so) expensive and
> > potentially failing compensation detachment procedure just because anon_inode
> > creation failed. This API allows to simplify code by ensuring first that
> > anon_inode is created and after BPF program is attached proceed with
> > fd_install() that can't fail.
> >
> > After anon_inode file is created, link can't be just kfree()'d anymore,
> > because its destruction will be performed by deferred file_operations->release
> > call. For this, bpf_link API required specifying two separate operations:
> > release() and dealloc(), former performing detachment only, while the latter
> > frees memory used by bpf_link itself. dealloc() needs to be specified, because
> > struct bpf_link is frequently embedded into link type-specific container
> > struct (e.g., struct bpf_raw_tp_link), so bpf_link itself doesn't know how to
> > properly free the memory. In case when anon_inode file was successfully
> > created, but subsequent BPF attachment failed, bpf_link needs to be marked as
> > "defunct", so that file's release() callback will perform only memory
> > deallocation, but no detachment.
> >
> > Convert raw tracepoint and tracing attachment to new API and eliminate
> > detachment from error handling path.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Applied, but ...
>
> [...]
> > @@ -2337,20 +2374,24 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
> >       }
> >       bpf_link_init(&link->link, &bpf_tracing_link_lops, prog);
> >
> > -     err = bpf_trampoline_link_prog(prog);
> > -     if (err)
> > -             goto out_free_link;
> > +     link_file = bpf_link_new_file(&link->link, &link_fd);
> > +     if (IS_ERR(link_file)) {
> > +             kfree(link);
> > +             err = PTR_ERR(link_file);
> > +             goto out_put_prog;
> > +     }
> >
> > -     link_fd = bpf_link_new_fd(&link->link);
> > -     if (link_fd < 0) {
> > -             WARN_ON_ONCE(bpf_trampoline_unlink_prog(prog));
> > -             err = link_fd;
> > -             goto out_free_link;
> > +     err = bpf_trampoline_link_prog(prog);
> > +     if (err) {
> > +             bpf_link_defunct(&link->link);
> > +             fput(link_file);
> > +             put_unused_fd(link_fd);
>
> Given the tear-down in error case requires 3 manual steps here, I think this begs
> for a small helper.

Sounds good, will follow up. Thanks for applying!

>
> > +             goto out_put_prog;
> >       }
> > +
> > +     fd_install(link_fd, link_file);
> >       return link_fd;
> >
> [...]
> > @@ -2431,28 +2481,32 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
> >               goto out_put_prog;
> >       }
> >
> [...]
> >
> > -     link_fd = bpf_link_new_fd(&raw_tp->link);
> > -     if (link_fd < 0) {
> > -             bpf_probe_unregister(raw_tp->btp, prog);
> > -             err = link_fd;
> > -             goto out_free_tp;
> > +     err = bpf_probe_register(link->btp, prog);
> > +     if (err) {
> > +             bpf_link_defunct(&link->link);
> > +             fput(link_file);
> > +             put_unused_fd(link_fd);
>
> Especially since you need it in multiple places; please follow-up.
>
> > +             goto out_put_btp;
> >       }
> > +
> > +     fd_install(link_fd, link_file);
> >       return link_fd;
> >
> > -out_free_tp:
> > -     kfree(raw_tp);
> >   out_put_btp:
> >       bpf_put_raw_tracepoint(btp);
> >   out_put_prog:
> >
>
