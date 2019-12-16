Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59203121333
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbfLPR7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:59:47 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:35485 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728806AbfLPR7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 12:59:45 -0500
Received: by mail-qv1-f66.google.com with SMTP id d17so3089173qvs.2;
        Mon, 16 Dec 2019 09:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0mHiYS8vPmhVYdFs29lXSPMh3DwpAbBEHbcksJ+EGlc=;
        b=t6YQC3ShlEYSh53qP/UEJ98kZ9TW1sgNdh59cXONq/YhYq8KlNIpO3APVpnkdnUVrc
         mFf2xceZnXxQ2ysH+hr/yhvkPt1MIyW6eHhOuB8BCfikkdw5ZKPfnbc/qVHYJvuZDROv
         n6Wcz6Jk6HZsIiGOitsVBsfiEgHfllVvsQFqNUCEDwKeLzsDJR1XlESwJMCTc2P3O0HX
         LE2LNDe3xWz564CfBec41Bgx/QcJop5mLbYgF7TmChq1B/dcMwcLGnA/hbyf5CH2oVS/
         +jgz2FC8eTqW7PKHvhHhnR4w8cBkPDbjHHfx4EBpo4nMpUsCLO8F61YdObPlM2cnXdl5
         tRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0mHiYS8vPmhVYdFs29lXSPMh3DwpAbBEHbcksJ+EGlc=;
        b=Pz686NzOoyQqoYTugM4Eq0C4jc4mMTcfPWFGopCKvVSzc9hg1stvbHPE1ALUtIGMqz
         Xn/7jlWivV5gDubDqoO1uAbhKdBbiDW7ogWes8GiolGLXbfJTOZ/Th4ZSR1cMpyZ1ybJ
         N6ZDP+niNHGGYvX5p7wFhLhL49hJFGPsVvzCERVFXF/jh660GYImvhcGvk053ewZGenn
         h2wmOkAxZC9lB7oEGNU25qSeiBdIyH43bI71GPDd87TaWVYvnnOpRYA8HfJ9B/7yIRkE
         wpjdwe2P1P3Ul6tz0leRVNemdaZP1Jq3eCy/Z+JrWbAyV4QXCFSaG+BfvUPBY77zzgdX
         RG0Q==
X-Gm-Message-State: APjAAAUi07yymtiQa4w3+O69ok71LFljaJ3ZmyIBqLNe0wcgBSwoSFnI
        oALGh02eyVmgSsY7nV7pPIVdCnL747RtnfNJ6fE=
X-Google-Smtp-Source: APXvYqy+wsuiI63oSEuKZ0yaCdSZdwjPdCKDlLHX9R2NNkzPgjSrpPTCACd6Rrdim5HWkZ1mq25hdOe8zmZ7Y83NQpY=
X-Received: by 2002:a05:6214:38c:: with SMTP id l12mr518115qvy.224.1576519183880;
 Mon, 16 Dec 2019 09:59:43 -0800 (PST)
MIME-Version: 1.0
References: <20191212013521.1689228-1-andriin@fb.com> <20191216144404.GG14887@linux.fritz.box>
In-Reply-To: <20191216144404.GG14887@linux.fritz.box>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Dec 2019 09:59:33 -0800
Message-ID: <CAEf4BzYhmFvhL_DgeXK8xxihcxcguRzox2AXpjBS1BB4n9d7rQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] Fix perf_buffer creation on systems with
 offline CPUs
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

On Mon, Dec 16, 2019 at 6:44 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Wed, Dec 11, 2019 at 05:35:20PM -0800, Andrii Nakryiko wrote:
> > This patch set fixes perf_buffer__new() behavior on systems which have some of
> > the CPUs offline/missing (due to difference between "possible" and "online"
> > sets). perf_buffer will create per-CPU buffer and open/attach to corresponding
> > perf_event only on CPUs present and online at the moment of perf_buffer
> > creation. Without this logic, perf_buffer creation has no chances of
> > succeeding on such systems, preventing valid and correct BPF applications from
> > starting.
>
> Once CPU goes back online and processes BPF events, any attempt to push into
> perf RB via bpf_perf_event_output() with flag BPF_F_CURRENT_CPU would silently

bpf_perf_event_output() will return error code in such case, so it's
not exactly undetectable by application.


> get discarded. Should rather perf API be fixed instead of plain skipping as done
> here to at least allow creation of ring buffer for BPF to avoid such case?

Can you elaborate on what perf API fix you have in mind? Do you mean
for perf to allow attaching ring buffer to offline CPU or something
else?

>
> > Andrii Nakryiko (4):
> >   libbpf: extract and generalize CPU mask parsing logic
> >   selftests/bpf: add CPU mask parsing tests
> >   libbpf: don't attach perf_buffer to offline/missing CPUs
> >   selftests/bpf: fix perf_buffer test on systems w/ offline CPUs
> >
> >  tools/lib/bpf/libbpf.c                        | 157 ++++++++++++------
> >  tools/lib/bpf/libbpf_internal.h               |   2 +
> >  .../selftests/bpf/prog_tests/cpu_mask.c       |  78 +++++++++
> >  .../selftests/bpf/prog_tests/perf_buffer.c    |  29 +++-
> >  4 files changed, 213 insertions(+), 53 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/cpu_mask.c
> >
> > --
> > 2.17.1
> >
