Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485A1EFACC
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 11:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbfKEKTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 05:19:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46454 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388283AbfKEKTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 05:19:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id b3so14883238wrs.13
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 02:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Vg9FJPss8oQNDihBdCZVUS9OPM3FEf7k8iX3IaB/rMk=;
        b=RcHtpXj3xta/TON458H7sjcflesgxh5ZIlGgF/w8cfKM3Tk++oQ+UbZoc9IbQXIzNP
         lZfX6mIUUKkgE4D47Exwy+dGakSiN0zHvJYFfxPtZ9uY0UBy7SkGiDKKyKO1VicjgGe2
         lHaKhpBd+dQXxgTS0O8qp8jxGhIuK897UuPkUay4dMSF3M1M5+2/j6DUaE5x4kwSlV2k
         FZPFnDT9ipt72eBrh88K+/boQvPA+ScTe+0DiBMVtpbdc48zbwDqyVtemGY50IG8Zq1f
         y1G/01WqP974kRwLTd2zh6RvthXOlf2ebuB+RJP6MnPNd7yWKGkgarAUEMiTvDTWzIKv
         1siw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Vg9FJPss8oQNDihBdCZVUS9OPM3FEf7k8iX3IaB/rMk=;
        b=Nggyh5uGO/F9/Wo4NlpEcxDzSexWl9MtMgl/fjv5pC38G+FYMaSSOfGzi+Vr2KNRTV
         G4cFClwhWRLCz4tJjBS3bWCSEXgIrBteeLm7n9WZGwi831Eqegrd/1X1mK35QpHb3rd2
         Rt8sHk5WNe2+bNegpunvVraGN3oFGSJ1UyRccJtx16kdZJ3WfMMwMA7+X/DawngfbF7N
         EAithSbM3rHxWzyA776PVMxQ4+KDUfZp5GUIG88AvzQz+gM3aX8C4kwwcHT+98y5n+GT
         gHtQhAUtoCNsLUvU9XZBLeS47XxPTTMLJj8ojViRZhODt1rk3PULYDYyxx8OtVoe54QZ
         cUrg==
X-Gm-Message-State: APjAAAURrnNMNLrLImgHfjOVR/8VxzocSxCRbYeX6vqZy7YH97fSNs3X
        XgOTCRhOwyAkX6wK79ORCAOJzHz8wkGjY3kCYJgZqw==
X-Google-Smtp-Source: APXvYqwc5X4e8SULXzuHD/iDw6JHvrLWDIMOYR8u3xD+xd7yygIt7ZnRIEQDjl27KzoMY9DuDrlrVwgs2+8GyXTUg0U=
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr28633229wrv.216.1572949159760;
 Tue, 05 Nov 2019 02:19:19 -0800 (PST)
MIME-Version: 1.0
References: <20191104170303.GA50361@gandi.net> <719eebd3-259d-8beb-025a-f2d17c632711@gmail.com>
 <20191105080554.GA1006@gandi.net>
In-Reply-To: <20191105080554.GA1006@gandi.net>
From:   Alexander Potapenko <glider@google.com>
Date:   Tue, 5 Nov 2019 11:19:08 +0100
Message-ID: <CAG_fn=V1rriybnSB3WSS-yqWEAuAdo89MG1SWPkvneizX61TVA@mail.gmail.com>
Subject: Re: Double free of struct sk_buff reported by SLAB_CONSISTENCY_CHECKS
 with init_on_free
To:     Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, clipos@ssi.gouv.fr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 5, 2019 at 9:06 AM Thibaut Sautereau
<thibaut.sautereau@clip-os.org> wrote:
>
> On Mon, Nov 04, 2019 at 09:33:18AM -0800, Eric Dumazet wrote:
> >
> >
> > On 11/4/19 9:03 AM, Thibaut Sautereau wrote:
> > >
> > > We first encountered this issue under huge network traffic (system im=
age
> > > download), and I was able to reproduce by simply sending a big packet
> > > with `ping -s 65507 <ip>`, which crashes the kernel every single time=
.
> > >
> >
> > Since you have a repro, could you start a bisection ?
>
> From my previous email:
>
>         "Bisection points to the following commit: 1b7e816fc80e ("mm: slu=
b:
>         Fix slab walking for init_on_free"), and indeed the BUG is not
>         triggered when init_on_free is disabled."
>
> Or are you meaning something else?
Could you please give more specific reproduction steps?
I've checked out v5.3.8 from
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git, ran
`make defconfig` and added CONFIG_SLUB_DEBUG_ON=3Dy.
Then I've built the kernel, ran it on QEMU with slub_debug=3DF and
init_on_free=3D1, SSHed into the machine and executed `ping -s 65507
127.0.0.1`
This however didn't trigger any crashes.
Am I missing something?
> --
> Thibaut Sautereau
> CLIP OS developer



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
