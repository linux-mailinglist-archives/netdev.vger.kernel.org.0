Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D9A29F92B
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgJ2XhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJ2XhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 19:37:21 -0400
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F432074A;
        Thu, 29 Oct 2020 23:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604014641;
        bh=hUm6EKixMzK0UQl5hwaT/IX58lVoysxhR2u/b2BAN5Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E13C8bLEkGyKTKREDMOd4y/w8DeqflUjJoNr27mXOmII2WR6JLRKZFUxaJ9ZdZlci
         8QeqM7rUsAd2JrAN2kgvQgo33rQz5Orm2nVm4zY96uUB9zw2zOcLso1EVY2e7DMYTU
         ueWiRmTEL//jzjYQtThbozMbQYv1/6DukSGZHYpU=
Received: by mail-lf1-f50.google.com with SMTP id l28so5521497lfp.10;
        Thu, 29 Oct 2020 16:37:20 -0700 (PDT)
X-Gm-Message-State: AOAM531IQmRFpPHVZ8YwGBf2mq3Hkx3p9ed48uA/gL3e5t3vRA5PuZ0J
        zl8gHjALClYJNRQbnQc89+ku0WMtASGx7d2XR7g=
X-Google-Smtp-Source: ABdhPJyU2lM5iu04/2jnRLC1CU4J1bDtoExBLSlgTl54uv6N38AkCeREq3T1GnTGDAHc8ReP6NQj0ab9HvX4/Lt+wEQ=
X-Received: by 2002:a19:ee12:: with SMTP id g18mr2761655lfb.515.1604014638909;
 Thu, 29 Oct 2020 16:37:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201029111730.6881-1-david.verbeiren@tessares.net>
 <CAPhsuW7o7D-6VW-Z3Umdw8z-7Ab+kkZrJf2EU9nCDFh0Xbn7sA@mail.gmail.com> <CAEf4BzZaZ2PT7nOrXGo-XM7ysgQ8JpDObUysnS+oxGV7e6GQgA@mail.gmail.com>
In-Reply-To: <CAEf4BzZaZ2PT7nOrXGo-XM7ysgQ8JpDObUysnS+oxGV7e6GQgA@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 29 Oct 2020 16:37:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6JH=eoa0VVJziCMfN78E88G4Vy4jpxkKDm3z-Xh0jVYQ@mail.gmail.com>
Message-ID: <CAPhsuW6JH=eoa0VVJziCMfN78E88G4Vy4jpxkKDm3z-Xh0jVYQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftest/bpf: Validate initial values of per-cpu hash elems
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Verbeiren <david.verbeiren@tessares.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 3:37 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 11:36 AM Song Liu <song@kernel.org> wrote:
> >
> > On Thu, Oct 29, 2020 at 4:19 AM David Verbeiren
> > <david.verbeiren@tessares.net> wrote:
> > >
> > > Tests that when per-cpu hash map or LRU hash map elements are
> > > re-used as a result of a bpf program inserting elements, the
> > > element values for the other CPUs than the one executing the
> > > BPF code are reset to 0.

[...]

> >
> > > +                               return -1;
> > > +                       }
> > [...]
> >
> > > +
> > > +       /* delete key=1 element so it will later be re-used*/
> > > +       key = 1;
> > > +       err = bpf_map_delete_elem(map_fd, &key);
> > > +       if (CHECK(err, "bpf_map_delete_elem", "failed: %s\n", strerror(errno)))
> > > +               goto error_map;
> > > +
> > > +       /* run bpf prog that inserts new elem, re-using the slot just freed */
> > > +       err = bpf_prog_insert_elem(map_fd, key, TEST_VALUE);
> > > +       if (!ASSERT_OK(err, "bpf_prog_insert_elem"))
> > > +               goto error_map;
> >
> > What's the reason to use ASSERT_OK() instead of CHECK()?
>
> I've recently added the ASSERT_xxx() family of macros to accommodate
> most common checks and provide sensible details printing. So I now
> always prefer ASSERT() macroses, it saves a bunch of typing and time.

I see. It is definitely less typing. :)

Thanks,
Song

[...]
