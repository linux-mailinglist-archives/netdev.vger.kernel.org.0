Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA962CEA50
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbfJGRMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:12:50 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36732 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbfJGRMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 13:12:49 -0400
Received: by mail-oi1-f196.google.com with SMTP id k20so12372180oih.3
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 10:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=voxQqlXcqJ7mOo4KVvha7FaxVVFvUMitFdHwmuWnFVE=;
        b=ylpNkZLTfv7jeQ1uzPQDjIlQb6tJXjGs1GaCB6dQH2B7VIscYPzQRG0T6AWuvQcAwX
         UaYkok+r0Uct6mz8WKCK+drL+zFhLmfLLp0NwzSz7cb5q2uwYEArsL0/TqYuP3fg6QIE
         lnjKbp0c96AZT4oxE9Etvd2re8yMC7bWAIymA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=voxQqlXcqJ7mOo4KVvha7FaxVVFvUMitFdHwmuWnFVE=;
        b=NbnPEAKWBURxBAmkOFNmqFv555sfG1pMF28dgnZTdPeT8cD7JukCZVvWuUnnC5n6VX
         y488EDlJoJB9zCvCMZfWP3H6Ruq5ceEsMJbqQbMgyx0Mpq4ryjFYQq+vO8O6W4FL/kH/
         rNZq9VNXbU9wYNCZCdZH8mOgtlUhQovu2mh1i5Rw8Vvi59OnCmJLxQpB+/e2/w8469Jz
         paH8hqPLlt6Jw5OGNhDLipOt6yyrARuWnsUjMBTHKFkGXxgcqrYmEfP5AZYr+8CjmfN3
         PUzkgry1P7T3468TEgE2qr4ZtfP8TYuHpADbgCVBokf9p0xaYjRs85eEAwzyuheBXeJr
         JSZA==
X-Gm-Message-State: APjAAAXo6Z2hWw7FSaujNrxW57EGo2YSaVwESXXZM/9K/MF2aqXdxe+a
        RVEW1MXQUzpEFgvq5b+4DZbPE1n+Qes9iCYLRumBSQ==
X-Google-Smtp-Source: APXvYqxPJygoEvkl+rxpN2s9Nqb7Ree9yYY3K/Q5BCmPM8737XcrtX6MRYflZavuy2uNqaV0MkJ838fwSme1B8cSAug=
X-Received: by 2002:aca:4f46:: with SMTP id d67mr286443oib.102.1570468368804;
 Mon, 07 Oct 2019 10:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com> <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com>
 <87r23vq79z.fsf@toke.dk> <20191003105335.3cc65226@carbon> <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
 <87pnjdq4pi.fsf@toke.dk> <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
 <5d964d8ccfd90_55732aec43fe05c47b@john-XPS-13-9370.notmuch>
 <87tv8pnd9c.fsf@toke.dk> <68466316-c796-7808-6932-01d9d8c0a40b@solarflare.com>
 <CACAyw99oUfst5LDaPZmbKNfQtM2wF8fP0rz7qMk+Qn7SMaF_vw@mail.gmail.com> <1871cacb-4a43-f906-9a9b-ba6a2ca866dd@solarflare.com>
In-Reply-To: <1871cacb-4a43-f906-9a9b-ba6a2ca866dd@solarflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 7 Oct 2019 18:12:37 +0100
Message-ID: <CACAyw98mYK3Psv61+BDcyk56PbnJf2JhdfDLsB0eD4vLJJnGYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
To:     Edward Cree <ecree@solarflare.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 at 17:43, Edward Cree <ecree@solarflare.com> wrote:
>
> I might be being na=C3=AFve, but it doesn't sound more painful than is no=
rmal
>  for userland.  I mean, what operations have you got-
> * create/destroy map (maybe, see above)
> * load prog (pass it an fd from which it can read an ELF, and more fds
>   for the maps it uses.  Everything else, e.g. BTFs, can just live in the
>   ELF.)
> * destroy prog
> * bind prog to hook (admittedly there's a long list of hooks, but this is
>   only to cover the XDP ones, so basically we just have to specify
>   interface and generic/driver/hw)
> -that doesn't seem like it presents great difficulties?

Sure, but this is the simplest, not necessarily realistic use case. There
is a reason that libbpf has the API it has. For example, we patch our
eBPF before loading it. I'm sure there are other complications, which is
why I prefer to keep loading my own programs.

> No, I'm talking about doing a linker step (using the 'full-blown calls'
>  _within_ an eBPF program that Alexei added a few months back) before the
>  program is submitted to the kernel.  So the BPF_CALL|BPF_PSEUDO_CALL ins=
n
>  gets JITed to a direct call.

Ah, I see. I'm not sure whether this restriction has been lifted, but those
calls are incompatible with tail calls. So we wouldn't be able to use this.

> OK, but in that case xdpd isn't evidence that the "loader" approach doesn=
't
>  work, so I still think it should be tried before we go to the lengths of
>  pushing something into the kernel (that we then have to maintain forever=
).

Maybe this came across the wrong way, I never said it is. Merely that it's
the status quo we'd like to move away from. If we can achieve that in
userspace, great.

Lorenz

--=20
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
