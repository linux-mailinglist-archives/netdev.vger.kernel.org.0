Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A72545FBE9
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 03:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352179AbhK0CTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 21:19:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56574 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhK0CRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 21:17:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1536660C03;
        Sat, 27 Nov 2021 02:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77123C53FCA;
        Sat, 27 Nov 2021 02:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637979249;
        bh=7pjtayI21JZZUNaRaXhr1b9xe4JsEM8VVt0hkGACp08=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jubweFa9Y8gIX83+JquozziDV/3xfxFkyzbeFCFGH8y8SRVz4vUbqeE4vLvNoqdW1
         KCUDhih7yUQlJtx3gz8HdGU2aOzqKoMsqytGgteILh8QHDtJuEQjLvbCjuSVmPdm0W
         l4mZca98KfcFUsZZnaSnY/FLM9zAlMKatF2W388JPuUqOkwucUJETBA9di3kMo05Je
         WMJ02oOBXHnpIga8/bTnbUCB8Jpki+8FrodqjcBAL38QBnK9s6eVMD7g69PoIxVzqY
         /XUdaaZE6u2sHvvOHnt6TavRxsARQvindxeqOpZw0MUklg2A83XOljOadZHQ+k+7yE
         nN+e191stXHxw==
Received: by mail-yb1-f180.google.com with SMTP id x32so24545837ybi.12;
        Fri, 26 Nov 2021 18:14:09 -0800 (PST)
X-Gm-Message-State: AOAM5302h3i7QrR7ZRbVzEu66ffOujcY3uyvhbRbhFrn9uuodn3QlJuk
        E8WZnkAzh2gizgf82WYra1rFnTRKpCcgVMLQj5M=
X-Google-Smtp-Source: ABdhPJxqDkMGG8d1vVnG9HdX8nQGKnQ6qjyLcbvPEUHVpA4AF+sMzOmWF1dBAyV75w65nr3VgsVZRntwN4joLNAmb2U=
X-Received: by 2002:a25:660d:: with SMTP id a13mr19871414ybc.460.1637979248636;
 Fri, 26 Nov 2021 18:14:08 -0800 (PST)
MIME-Version: 1.0
References: <20211123205607.452497-1-zenczykowski@gmail.com> <CANP3RGdZq6x0NB2wKn5YG2Va=j0YHKd5DcM7_dyaKWhdyUrzOw@mail.gmail.com>
In-Reply-To: <CANP3RGdZq6x0NB2wKn5YG2Va=j0YHKd5DcM7_dyaKWhdyUrzOw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 Nov 2021 18:13:57 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6h4cvFiRwT9h-0z1xTr_HeWcXMTgnd0FERSmTTjbZOUA@mail.gmail.com>
Message-ID: <CAPhsuW6h4cvFiRwT9h-0z1xTr_HeWcXMTgnd0FERSmTTjbZOUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: allow readonly direct path access for skfilter
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 3:02 PM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
>
> Note: this is more of an RFC... question in patch format... is this
> even a good idea?
>
> On Tue, Nov 23, 2021 at 12:56 PM Maciej =C5=BBenczykowski
> <zenczykowski@gmail.com> wrote:
> >
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > skfilter bpf programs can read the packet directly via llvm.bpf.load.by=
te/
> > /half/word which are 8/16/32-bit primitive bpf instructions and thus
> > behave basically as well as DPA reads.  But there is no 64-bit equivale=
nt,
> > due to the support for the equivalent 64-bit bpf opcode never having be=
en
> > added (unclear why, there was a patch posted).
> > DPA uses a slightly different mechanism, so doesn't suffer this limitat=
ion.
> >
> > Using 64-bit reads, 128-bit ipv6 address comparisons can be done in jus=
t
> > 2 steps, instead of the 4 steps needed with llvm.bpf.word.
> >
> > This should hopefully allow simpler (less instructions, and possibly le=
ss
> > logic and maybe even less jumps) programs.  Less jumps may also mean va=
stly
> > faster bpf verifier times (it can be exponential in the number of jumps=
...).
> >
> > This can be particularly important when trying to do something like sca=
n
> > a netlink message for a pattern (2000 iteration loop) to decide whether
> > a message should be dropped, or delivered to userspace (thus waking it =
up).
> >
> > I'm requiring CAP_NET_ADMIN because I'm not sure of the security
> > implications...

I don't know BPF_PROG_TYPE_SOCKET_FILTER very well, but the patch
seems reasonable to me. It will be great if we can show the performance
impact with a benchmark or a selftests.

Thanks,
Song
