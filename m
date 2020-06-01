Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D29D1EB1E8
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgFAWwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgFAWwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 18:52:37 -0400
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 296A120823;
        Mon,  1 Jun 2020 22:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591051956;
        bh=l5lm4yKKyEc4Otlw9IBn9mSGLLCABf7CqrAzZIT0GJE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ksamNC3Idi0rFdrjx8HiCy5mdAgVQpfcCyhckiyW1UoEM/wD5BGAM+Ut2Bdvaeyk1
         Vym21yPWiSaMb7w2y8zx0lp9rGC03gJ4GDCGv3RNcB4G/ern+aCpXtj1qa/JY3fpKK
         ijqT0F2wtu/hxQb4HwVoIiuDViqIy5RUXC6X4488=
Received: by mail-lj1-f181.google.com with SMTP id z18so10183888lji.12;
        Mon, 01 Jun 2020 15:52:36 -0700 (PDT)
X-Gm-Message-State: AOAM530wdNMohljsPoqF0V5P+sOqJ/EjOwwemu7EUtwXd1eIn3xLZksL
        S+M1WLaD6PF/gXxwYHVDOxGWPcERS0g1DWywRrk=
X-Google-Smtp-Source: ABdhPJwTdgHsvleBYdxx26DPbkJTNCDEN6lGDEd2fcwQ5H8I39nAZ4tDYgww9jZsP+FyQYhAB6SrtEn9GTGuv2hkE98=
X-Received: by 2002:a2e:a377:: with SMTP id i23mr11271087ljn.392.1591051954419;
 Mon, 01 Jun 2020 15:52:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200531154255.896551-1-jolsa@kernel.org> <CAPhsuW7HevOVgEe-g3RH_OmRqzWedXzGkuoNNzJfSwKhtzGxFw@mail.gmail.com>
 <CAADnVQJquAF=XOjbyj-xmKupyCa=5O76QXWf6Pjq+j+dTvaEpg@mail.gmail.com>
In-Reply-To: <CAADnVQJquAF=XOjbyj-xmKupyCa=5O76QXWf6Pjq+j+dTvaEpg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 1 Jun 2020 15:52:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW70YkMkHCca=Ke9YKDo-TD60RjLe08UvuMnXBnq9uDG8g@mail.gmail.com>
Message-ID: <CAPhsuW70YkMkHCca=Ke9YKDo-TD60RjLe08UvuMnXBnq9uDG8g@mail.gmail.com>
Subject: Re: [PATCH] bpf: Use tracing helpers for lsm programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 3:12 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 1, 2020 at 12:00 PM Song Liu <song@kernel.org> wrote:
> >
> > On Sun, May 31, 2020 at 8:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Currenty lsm uses bpf_tracing_func_proto helpers which do
> > > not include stack trace or perf event output. It's useful
> > > to have those for bpftrace lsm support [1].
> > >
> > > Using tracing_prog_func_proto helpers for lsm programs.
> >
> > How about using raw_tp_prog_func_proto?
>
> why?
> I think skb/xdp_output is useful for lsm progs too.
> So I've applied the patch.

The only reason I asked was that the commit log only said stack trace and
perf event output. No objections allowing other helpers for lsm.

Thanks,
Song
