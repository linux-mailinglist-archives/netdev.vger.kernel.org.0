Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8556373475
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 06:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhEEEoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 00:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhEEEn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 00:43:59 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3DCC061574;
        Tue,  4 May 2021 21:43:02 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z9so705798lfu.8;
        Tue, 04 May 2021 21:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6tfWMiqn6tTusu+83OD8TRFhIHM3EtAwOkc3hLLH0g=;
        b=XktYorfIIBfBLTBr5zmtIeIvOzwJojU7pduKcNznDQdlv0kcRrBH2a6sKjf7Me15gO
         MEU0EVh7GGFr31PXSGqAw8T/jRCMgfoFft73Mr8bC59gHHbwba0NMZOWtHRGQIEq1hLY
         bXW7RweE1fOsEeAGSsFiZsv83INrYCLRjJVZE6QMts0tCKjAApvUZae8jqLDbXI5TQAm
         DEWyYCOriUUUYmuISjQucr6HmYC98sikOD0lLpYYsYGpFuoa+RM1w9Il9X98KDXu+o+G
         zc7ufPY1cLiyUgeg1zI3wekirkzqrf7fJs5KvbTo+62a+QDdheurRlUkou0oh/sUTO3S
         hr4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6tfWMiqn6tTusu+83OD8TRFhIHM3EtAwOkc3hLLH0g=;
        b=lgvjHRBc+NGbiSXlKjcU6KDefuv7CKcTEZvquN6nrZyKEzZk1UFrifpM4p9RzfrYYa
         5O+q7l8I8r9R02+A1xTOo+BOnUbBxtkTjORndewEq2pdKJpjb8Lyaoz1isnB2xNO0OV4
         t0aBNu1wj/V747S0EnTUcOjKNmobhwAhmyWfwTObyausCC1dJRm/FRkc7TdaRaoLo90F
         wowZu0u4W9Iz93gcky48S4Mjfk2hpTx8/30b919ivcuSkBz1QwY2FkyFDAs1eg9baStL
         uo1Anns2eOgyRtHC1Cjd34iNtHvM6htoFsT7KNDJyg96P1Zsl4MlgfDH8uow1yVVQN6S
         licw==
X-Gm-Message-State: AOAM530qxHq4buHR5J3wplDLYORMZsLOjLqQeqlunhF6pS+GOeZBtcTz
        s2lH+d8xp0PpQoPsiVMk0Vxe6fQ+R5yXOl0sKPQ=
X-Google-Smtp-Source: ABdhPJyOptnjgcBivEYhyOXQI3+huGmMZOpKV2bxRJc7Jd726yTpLneY9I2VH7UeyuCQbom7C2aTKuhNY1l2vzkQlf8=
X-Received: by 2002:ac2:5b1a:: with SMTP id v26mr6672147lfn.534.1620189780883;
 Tue, 04 May 2021 21:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210430134754.179242-1-jolsa@kernel.org> <CAEf4BzbEjvccUDabpTiPOiXK=vfcmHaXjeaTL8gCr08=6fBqhg@mail.gmail.com>
 <YJFM/iLKb1EWCYEx@krava> <CAEf4BzbY24gFqCORLiAFpSjrv_TUPMwvGzn96hGtk+eYVDnbSQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbY24gFqCORLiAFpSjrv_TUPMwvGzn96hGtk+eYVDnbSQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 May 2021 21:42:49 -0700
Message-ID: <CAADnVQKE-jXi22mrOvEX_PpjK5vxNrb6m6-G71iP5ih+R5svqA@mail.gmail.com>
Subject: Re: [RFC] bpf: Fix crash on mm_init trampoline attachment
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 4, 2021 at 5:36 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, May 4, 2021 at 6:32 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Mon, May 03, 2021 at 03:45:28PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Apr 30, 2021 at 6:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > There are 2 mm_init functions in kernel.
> > > >
> > > > One in kernel/fork.c:
> > > >   static struct mm_struct *mm_init(struct mm_struct *mm,
> > > >                                    struct task_struct *p,
> > > >                                    struct user_namespace *user_ns)
> > > >
> > > > And another one in init/main.c:
> > > >   static void __init mm_init(void)
> > > >
> > > > The BTF data will get the first one, which is most likely
> > > > (in my case) mm_init from init/main.c without arguments.

did you hack pahole in some way to get to this point?
I don't see this with pahole master.
mm_init in BTF matches the one in init/main.c. The void one.
Do you have two static mm_init-s in BTF somehow?

In general it's possible to have different static funcs with the same
name in kallsyms. I found 3 'seq_start' in my .config.
So renaming static funcs is not an option.
The simplest approach for now is to avoid emitting BTF
if there is more than one func (that will prevent attaching because
there won't be any BTF for that func).
Long term I think BTF can store the .text offset and the verifier
can avoid kallsym lookup.
We do store insn_off in bpf_func_info for bpf progs.
Something like this could be done for kernel and module funcs.
But that's long term.
