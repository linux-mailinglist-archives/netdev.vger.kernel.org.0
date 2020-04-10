Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FB21A4C39
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 00:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgDJWvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 18:51:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44892 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgDJWvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 18:51:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id w24so2654605qts.11;
        Fri, 10 Apr 2020 15:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZmfQ5zqyJbrC3dajpjoY1pM/m4TAuF0zBO31tm790Fw=;
        b=diOUXKjMZT7yJfTEGysqrYUArjRx4MV4Ta5nwDbu4mYX4mx/LnHHDL23ny/OWhp2OW
         AaCu3JRlmN3vsoMXpuqhGbuVBQ/O2sX/cy26fin7cl1emD9dS8yMMFFfxD0jOdVMrGhP
         1RgZXoSNpz4hgoityuVIZGadGw8vL+Ip/UevR175/pllBHvqK5PFiGSJYEQTtGCwBUDA
         LWXTeS9uwnew9TqdeXSvLHGZ/L+j5TWbw73LpruTA7Mzosb2EhkX+eWzCVvgbcGOWaBj
         V2bZOLS+ltqMAAFlzjf701VlPdBF1V8a5wiXVuwRaoPCm5mT7muCehwd6dgB9lsbMpla
         rlZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZmfQ5zqyJbrC3dajpjoY1pM/m4TAuF0zBO31tm790Fw=;
        b=fhpimuoRojjoN1ZGkSwJ4kW49a1jWVSVTQ4TagukxiJ58LXX7+2EHSisUUDMZKA1+P
         dhLvemt/Er9sgo5hR8QWq5o8nVr2qtEOqjSIgUFUTaBVAD+HbJQd9aBnYK0+G4aVO3Dl
         oAuQUi1Mu3dD5xTKsDRltivat2U2sC0XWa4sI1rMLj+1ECyq+6MNZ4w6Wy8lrlH4Q2Ix
         4D6EaYMk7ICBrvAOLJuMkrunIn70QgaH5ZRjMD/WbxMufkGK2h6OwvMTj+RegCmAW0pr
         3Tlr5vO7M89NWfZgxQQLVwpA34tfOS/SiOnZ5qB5kFqh4xb7NkVNx/uSc1I3H6OhWf57
         pQ1Q==
X-Gm-Message-State: AGi0PuY2lZrKp5agrwOSVf9N87PhS4b/ifihR4PLeWf+YSO+lTS50vB/
        PYZjUJr1urzUVlusWwJxpW6jWDiixEdRgKMxjvk=
X-Google-Smtp-Source: APiQypLpLVML+alalPcS1LGytWlShqjCWcBDa11gKDa6Szl4/RuoyhuChEugYshe61uwRtZDpRn0jskeBBxRqVO5wbs=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr1374600qto.59.1586559094861;
 Fri, 10 Apr 2020 15:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
In-Reply-To: <20200408232526.2675664-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Apr 2020 15:51:24 -0700
Message-ID: <CAEf4BzajwPzHUyBvVZzafgKZHXv7b0pmL_avtFO6-_QHh46z1g@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Given a loaded dumper bpf program, which already
> knows which target it should bind to, there
> two ways to create a dumper:
>   - a file based dumper under hierarchy of
>     /sys/kernel/bpfdump/ which uses can
>     "cat" to print out the output.
>   - an anonymous dumper which user application
>     can "read" the dumping output.
>
> For file based dumper, BPF_OBJ_PIN syscall interface
> is used. For anonymous dumper, BPF_PROG_ATTACH
> syscall interface is used.
>
> To facilitate target seq_ops->show() to get the
> bpf program easily, dumper creation increased
> the target-provided seq_file private data size
> so bpf program pointer is also stored in seq_file
> private data.
>
> Further, a seq_num which represents how many
> bpf_dump_get_prog() has been called is also
> available to the target seq_ops->show().
> Such information can be used to e.g., print
> banner before printing out actual data.
>
> Note the seq_num does not represent the num
> of unique kernel objects the bpf program has
> seen. But it should be a good approximate.
>
> A target feature BPF_DUMP_SEQ_NET_PRIVATE
> is implemented specifically useful for
> net based dumpers. It sets net namespace
> as the current process net namespace.
> This avoids changing existing net seq_ops
> in order to retrieve net namespace from
> the seq_file pointer.
>
> For open dumper files, anonymous or not, the
> fdinfo will show the target and prog_id associated
> with that file descriptor. For dumper file itself,
> a kernel interface will be provided to retrieve the
> prog_id in one of the later patches.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |   5 +
>  include/uapi/linux/bpf.h       |   6 +-
>  kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
>  kernel/bpf/syscall.c           |  11 +-
>  tools/include/uapi/linux/bpf.h |   6 +-
>  5 files changed, 362 insertions(+), 4 deletions(-)
>

[...]

>
> +struct dumper_inode_info {
> +       struct bpfdump_target_info *tinfo;
> +       struct bpf_prog *prog;
> +};
> +
> +struct dumper_info {
> +       struct list_head list;
> +       /* file to identify an anon dumper,
> +        * dentry to identify a file dumper.
> +        */
> +       union {
> +               struct file *file;
> +               struct dentry *dentry;
> +       };
> +       struct bpfdump_target_info *tinfo;
> +       struct bpf_prog *prog;
> +};

This is essentially a bpf_link. Why not do it as a bpf_link from the
get go? Instead of having all this duplication for anonymous and
pinned dumpers, it would always be a bpf_link-based dumper, but for
those pinned bpf_link itself is going to be pinned. You also get a
benefit of being able to list all dumpers through existing bpf_link
API (also see my RFC patches with bpf_link_prime/bpf_link_settle,
which makes using bpf_link safe and simple).

[...]

> +
> +static void anon_dumper_show_fdinfo(struct seq_file *m, struct file *filp)
> +{
> +       struct dumper_info *dinfo;
> +
> +       mutex_lock(&anon_dumpers.dumper_mutex);
> +       list_for_each_entry(dinfo, &anon_dumpers.dumpers, list) {

this (and few other places where you search in a loop) would also be
simplified, because struct file* would point to bpf_dumper_link, which
then would have a pointer to bpf_prog, dentry (if pinned), etc. No
searching at all.

> +               if (dinfo->file == filp) {
> +                       seq_printf(m, "target:\t%s\n"
> +                                     "prog_id:\t%u\n",
> +                                  dinfo->tinfo->target,
> +                                  dinfo->prog->aux->id);
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&anon_dumpers.dumper_mutex);
> +}
> +
> +#endif
> +

[...]
