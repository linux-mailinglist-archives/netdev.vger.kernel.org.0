Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534EC462AD3
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 04:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhK3DFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 22:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbhK3DFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 22:05:22 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69ECC061574;
        Mon, 29 Nov 2021 19:02:03 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id m192so25269464qke.2;
        Mon, 29 Nov 2021 19:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hilByPD8L3h9Ytyg6eTvXqp0WXWx+OL3wX2IRfH8TVI=;
        b=Xo1NrVoBOqABaaCVvLLEZyjUAmGr5+STOyjB+Pl/KgnHbeqPB0r+ESX4feZTOYkB2q
         aoweXGM9moAULJSK1z/msCYVpKpkCwdkqiyZNGpMWWv481qk8A19r1fU1siANLz0Hgn1
         vKfwoyFzqm0Ai8EVILk3tVtyor84mNb1ryzwvrXiTnCII28eF/u7hesuFgSHxxVyZwCX
         UAU0N60V6jiuC/x3h1E9V0VqtqaKb2D8va5yc3TskropS9N2TlDwZz8Ct8OdEMGXBz+D
         /BikptCg66Nw8qd2stBC6QJQ2u1tQDQYaXDFqtm9suppBCUNCU5cJVmuoyvOKAHT1/B9
         3xtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hilByPD8L3h9Ytyg6eTvXqp0WXWx+OL3wX2IRfH8TVI=;
        b=hKG3bC/7Ic1ZX8mcUwxUunhkuZZneFu/VP3wKciq56yBHfhjUL14dbjQaeDKenDKSr
         UDaIhIgm4b7gUgtmbDVlMkJgFk0s4zUXUfu+yMOIOZJUGgaR3qClLeZoDMUnPihRNFix
         lQrwaTavaYw1dcEJ2mpRtDsL0MmzeVZVffRMsdJJBIutraDh3Gk3VNLVPnKACOgPuKRu
         jNkewxN6LuXtkikaOOU2qb/GpfV+zvxD63LGTZcIoozPZ9tqSZruMJLgD8NhY040FU/R
         tv/gpEDL+06y0DPBUJ+tjVX+janp1E2ubHy+6nG48G7w5iC5ENrhjpUyErujlmeAlkyr
         1fFA==
X-Gm-Message-State: AOAM532sRnlIdBAbTQBZPz4SIrhQ71j3KojDnwMmyjj4p6RZSNIbIHBX
        8ZdoudzSpV2UOCOtvOX5VNo2H7c3Av4WxLjXquY=
X-Google-Smtp-Source: ABdhPJyUj8zY9/gTmJm9gnBT3BhDDzchPwLsvCPELhO/9hrEsiUYremqHf1uk5r6y5RjtYcFFgfFfydWTIJYBrtoeSk=
X-Received: by 2002:a05:620a:134a:: with SMTP id c10mr43400535qkl.207.1638241322873;
 Mon, 29 Nov 2021 19:02:02 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-5-laoar.shao@gmail.com>
 <20211129110140.733475f3@gandalf.local.home>
In-Reply-To: <20211129110140.733475f3@gandalf.local.home>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 30 Nov 2021 11:01:27 +0800
Message-ID: <CALOAHbB-2ESG0QgESN_b=bXzESbq+UBP-dqttirKnt1c9TZHZA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] fs/binfmt_elf: replace open-coded string copy with get_task_comm
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 12:01 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat, 20 Nov 2021 11:27:35 +0000
> Yafang Shao <laoar.shao@gmail.com> wrote:
>
> > diff --git a/include/linux/elfcore-compat.h b/include/linux/elfcore-compat.h
> > index e272c3d452ce..54feb64e9b5d 100644
> > --- a/include/linux/elfcore-compat.h
> > +++ b/include/linux/elfcore-compat.h
> > @@ -43,6 +43,11 @@ struct compat_elf_prpsinfo
> >       __compat_uid_t                  pr_uid;
> >       __compat_gid_t                  pr_gid;
> >       compat_pid_t                    pr_pid, pr_ppid, pr_pgrp, pr_sid;
> > +     /*
> > +      * The hard-coded 16 is derived from TASK_COMM_LEN, but it can't be
> > +      * changed as it is exposed to userspace. We'd better make it hard-coded
> > +      * here.
>
> Didn't I once suggest having a macro called something like:
>
>   TASK_COMM_LEN_16 ?
>
>
> https://lore.kernel.org/all/20211014221409.5da58a42@oasis.local.home/

Hi Steven,

TASK_COMM_LEN_16 is a good idea, but not all hard-coded 16 can be
replaced by this macro (which is defined in include/sched.h).
For example,  the comm[16] in include/uapi/linux/cn_proc.h can't be
replaced as it is a uapi header which can't include  linux/sched.h.
That's why I prefer to keep the hard-coded 16 as-is.

There are three options,
- option 1
  comment on all the hard-coded 16 to explain why it is hard-coded
- option 2
  replace the hard-coded 16 that can be replaced and comment on the
others which can't be replaced.
- option 3
   replace the hard-coded 16 that can be replaced and specifically
define TASK_COMM_LEN_16 in other files which can't include
linux/sched.h.

Which one do you prefer ?


>
>
> > +      */
> >       char                            pr_fname[16];
> >       char                            pr_psargs[ELF_PRARGSZ];
> >  };
> > diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
> > index 957ebec35aad..746e081879a5 100644
> > --- a/include/linux/elfcore.h
> > +++ b/include/linux/elfcore.h
> > @@ -65,6 +65,11 @@ struct elf_prpsinfo
> >       __kernel_gid_t  pr_gid;
> >       pid_t   pr_pid, pr_ppid, pr_pgrp, pr_sid;
> >       /* Lots missing */
> > +     /*
> > +      * The hard-coded 16 is derived from TASK_COMM_LEN, but it can't be
> > +      * changed as it is exposed to userspace. We'd better make it hard-coded
> > +      * here.
> > +      */
> >       char    pr_fname[16];   /* filename of executable */
> >       char    pr_psargs[ELF_PRARGSZ]; /* initial part of arg list */
> >  };



-- 
Thanks
Yafang
