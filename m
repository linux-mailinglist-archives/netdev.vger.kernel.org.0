Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC6A17283E
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgB0TAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:00:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729170AbgB0TAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 14:00:11 -0500
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CCA9246B6;
        Thu, 27 Feb 2020 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582830010;
        bh=/RVYp/H4JUhoBehpG+w0YlGMDIo8L7dvW4H0ViHvyao=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=h66paGACia70+sOzy9iYb3ftg1f62T2M6GX5MZEpUQkYXqVuoBZSsWqSNRAbXT4Ei
         vF4XpyZGD3o9VDGGqD+XnCqt0LqHmxXXtvNxeyVSk86P2cJ+Qfideoe26g0fqV/pXF
         zlMMa6n1/tbW59zBFn5sYe1J7jT2Te6GpqhiE3dY=
Received: by mail-lj1-f170.google.com with SMTP id y6so469664lji.0;
        Thu, 27 Feb 2020 11:00:10 -0800 (PST)
X-Gm-Message-State: ANhLgQ0AazVfg3hACXdESJ3u+y/FAnZ2vU3+TMWy715zm1Cnbvimw1te
        vFwZmOuGkfVG/czbBzWgf5RHtAOrKyOOPog5Tmc=
X-Google-Smtp-Source: ADFU+vsvp2M9KmX9Ay+2NolcqmhEkT/seKsrKbY0g5xr+5S1sMITSJ2wfDSaNaoHOgXFEBseiBBVpJHZjwfLjD5ji54=
X-Received: by 2002:a2e:804b:: with SMTP id p11mr286553ljg.235.1582830008673;
 Thu, 27 Feb 2020 11:00:08 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-5-jolsa@kernel.org>
 <CAPhsuW5u=6MEWKU4-Cfdr3VfYn+NuTgX6SezC_W33WZsM3j8ng@mail.gmail.com> <20200227085002.GC34774@krava>
In-Reply-To: <20200227085002.GC34774@krava>
From:   Song Liu <song@kernel.org>
Date:   Thu, 27 Feb 2020 10:59:57 -0800
X-Gmail-Original-Message-ID: <CAPhsuW78oZ=g51B55z0etMzYyotztFC+4kMaYPOUaMVD-=mOvg@mail.gmail.com>
Message-ID: <CAPhsuW78oZ=g51B55z0etMzYyotztFC+4kMaYPOUaMVD-=mOvg@mail.gmail.com>
Subject: Re: [PATCH 04/18] bpf: Add name to struct bpf_ksym
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 12:50 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Feb 26, 2020 at 01:14:43PM -0800, Song Liu wrote:
> > On Wed, Feb 26, 2020 at 5:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding name to 'struct bpf_ksym' object to carry the name
> > > of the symbol for bpf_prog, bpf_trampoline, bpf_dispatcher.
> > >
> > > The current benefit is that name is now generated only when
> > > the symbol is added to the list, so we don't need to generate
> > > it every time it's accessed.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >
> > The patch looks good. But I wonder whether we want pay the cost of
> > extra 128 bytes per bpf program. Maybe make it a pointer and only
> > generate the string when it is first used?
>
> I thought 128 would not be that bad, also the code is quite
> simple because of that.. if that's really a concern I could
> make the changes, but that would probably mean changing the
> design

I guess this is OK. We can further optimize it if needed.

Acked-by: Song Liu <songliubraving@fb.com>
