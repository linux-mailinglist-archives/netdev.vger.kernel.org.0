Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316471D26C7
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 07:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgENFpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 01:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725788AbgENFpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 01:45:30 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFC8C061A0C;
        Wed, 13 May 2020 22:45:29 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id b1so1959940qtt.1;
        Wed, 13 May 2020 22:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CeLcerrPYswIIq5/LOYFPT5DqB/kULYtQV2dtaUcTKI=;
        b=lopipD4Dbh3zX8t+77tW/y8p6c+Vx9SmjPyVRtSc+M7oRew6wU5gA19D9+tgXD/tnr
         dnw5wcXRsr19RgqKWTYFwDEz7/SN6JYcKkYIS3tL4XDeSDVXS/Ivt1kJEcuTxSlwH80s
         CgVEduETsv04QYGIpmg4e//xmMqI1qvwgJSd9pISUl6vs16ETWrwLk+iCFQ5fHEDnJ7/
         ryY0L5WCxBThMeTw98YA1uWw36iCSyf6EEkvXjScx099xwxMrEZ/GZxiO3Sh8mqtd1QI
         3W+686oRAFtDKt7ajSQSAapdLgtea2ZnrTxj6339u6aUUF7sWthDw/x4OdkkSu4t1paA
         U6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CeLcerrPYswIIq5/LOYFPT5DqB/kULYtQV2dtaUcTKI=;
        b=mUhmAILiJMpEmAok2n43iZKow52hz8Za2mFPLxUfaTwetoD+Rb0pNLcbpGA98nz+Ec
         3RZSHNLv8gqLUrOA1/v/X3+epw7NH79B9+DYM0S5+uojygrzoV1Eq0H8V8dqFhOGj9Dr
         93KRyLwZflVuQtTIZ6UqraM7h87DTrcz2EBBR85jLym5v9p3ib1Ju7ZrLwsTuMtBL2sW
         e9fGAK13ZZjWERdfEmN+g5eMnjIYCjqZ8FdbtTgeqbSXDejpy4laqURYHU4HSZ/E98J3
         jP5ULBaR5kCv3X5riskn7ISfiMS1oVOOt4HacRFyhGuD6/lQTTo8+q5uN+kMsioPlYOU
         xrhQ==
X-Gm-Message-State: AOAM532cD5FxjolBnTskFns2zhSrZ8kXTjJr7Rs75GGjLWKYNMDMuc5o
        uaeRFGytYUo/tsvmI2AfhVTPYPRdbB2gE9vCUdrf6g==
X-Google-Smtp-Source: ABdhPJyaB2OKkqspvUB3KXInSih0EveX84naqUESpAj96BSwXYj5Asmib940+sKnrSU26rRaIhNqJUO3l6vvzUE2qIA=
X-Received: by 2002:aed:2f02:: with SMTP id l2mr2681055qtd.117.1589435128820;
 Wed, 13 May 2020 22:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200513212057.147133-1-andriin@fb.com> <CAADnVQJoU__8UrOE8Nm5R4W3qsV=YfCaWwYjNDKGaQrYPw2Wzg@mail.gmail.com>
In-Reply-To: <CAADnVQJoU__8UrOE8Nm5R4W3qsV=YfCaWwYjNDKGaQrYPw2Wzg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 May 2020 22:45:17 -0700
Message-ID: <CAEf4BzYo23gyF=5-N0RzHmk6ajsQ97L=CsntfeUSK4bJKeqVtQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix bpf_iter's task iterator logic
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 3:42 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, May 13, 2020 at 2:23 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > task_seq_get_next might stop prematurely if get_pid_task() fails to get
> > task_struct. Failure to do so doesn't mean that there are no more tasks=
 with
> > higher pids. Procfs's iteration algorithm (see next_tgid in fs/proc/bas=
e.c)
> > does a retry in such case. After this fix, instead of stopping prematur=
ely
> > after about 300 tasks on my server, bpf_iter program now returns >4000,=
 which
> > sounds much closer to reality.
> >
> > Cc: Yonghong Song <yhs@fb.com>
> > Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  kernel/bpf/task_iter.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> > index a9b7264dda08..e1836def6738 100644
> > --- a/kernel/bpf/task_iter.c
> > +++ b/kernel/bpf/task_iter.c
> > @@ -27,9 +27,15 @@ static struct task_struct *task_seq_get_next(struct =
pid_namespace *ns,
> >         struct pid *pid;
> >
> >         rcu_read_lock();
> > +retry:
> >         pid =3D idr_get_next(&ns->idr, tid);
> > -       if (pid)
> > +       if (pid) {
> >                 task =3D get_pid_task(pid, PIDTYPE_PID);
> > +               if (!task) {
> > +                       *tid++;
>
> ../kernel/bpf/task_iter.c: In function =E2=80=98task_seq_get_next=E2=80=
=99:
> ../kernel/bpf/task_iter.c:35:4: warning: value computed is not used
> [-Wunused-value]
>    35 |    *tid++;
>       |    ^~~~~~

welp... thanks, fixing to prefix form
