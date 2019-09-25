Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577EDBE686
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392728AbfIYUf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:35:28 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42251 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfIYUf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:35:28 -0400
Received: by mail-qk1-f194.google.com with SMTP id f16so6490201qkl.9;
        Wed, 25 Sep 2019 13:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KHD8AV/Lz/qkKV1ArvEp/nkjiFDMrKj0NHgMCiqxtJ0=;
        b=ooTXcbGWETcliHpphTDvGrPvci2ck1wWxzjm53cG6hNr4T7FKi2poYd4V5wgeaGvnK
         faa43w1PMknoZytWKDRXRkxoG4L94Tg5lqPe7Fgf/Da4IXuyptkbykY2BCnf4vpQ2HxD
         n5MnaFECkMkpUaZz/I8PmQ5yNkC4vMtxKdPCIOL6rgB4xPqm4gF5KYwkfgb9Wxz90VN9
         tl70qapjyhXD1/NushyA6rPVQ/ROqV6syAaxDo80G0KTWqMSaLFlfqZrIEOq0Y1i0SDd
         +mpX+HhTUWXIQR6pMDPW31LcZCyn/5nJJ57ADrifyJDHmKX4KhV5V4olNUN/IxwHkagF
         DVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KHD8AV/Lz/qkKV1ArvEp/nkjiFDMrKj0NHgMCiqxtJ0=;
        b=MrIO9o0mkIW+u0k50geo/3tXGNVGtDcT4kT2UNLfCCRTJJN9+lk/zTBTzvuyOJPQb2
         FuByMzs4nqnh124FhDHw7PL2dVzzDR0I0LiJWV6XhO1q2IicNvYfHQAxsjEH6V3zmsZx
         E7rECQeXm/rMF3gN2vA5Q9xTzF4y7S6u+GKE0yq5GhCi5UAGG9In1cp+sswXrKhHUG7b
         EVNMgOwzUkX+BxOU5AdQ1FlytpxtmUUxMY4TSe5e0KZ/IC5p7NEZUCuF2/x1iKngcGlO
         PS2GbMlPP9ykH89B5HJD1z9kUcgT998mZZuJBr0vc5cC6T2+wAuobVaWIA8fqveYLQME
         kIIw==
X-Gm-Message-State: APjAAAVv6y8tVhOMH7dLcJkSw903dMhhnCKo9C/qAaubSppPtDbUH2XD
        +5UmwE8DXMIvGqWGbwOSGH1xITvu/jVSHUsMplI=
X-Google-Smtp-Source: APXvYqwsMOZr3LHvxtKi6ioEfYyLCGamVdq6NQvcFyGg18O0lSDjg0Y8IeQiCKzNxD5YOjvHVa0FJwD7FvwhFEYZnP8=
X-Received: by 2002:a37:4e55:: with SMTP id c82mr5813124qkb.437.1569443725648;
 Wed, 25 Sep 2019 13:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190925185205.2857838-1-andriin@fb.com> <20190925203301.GE9500@pc-63.home>
In-Reply-To: <20190925203301.GE9500@pc-63.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 25 Sep 2019 13:35:14 -0700
Message-ID: <CAEf4BzZREUDrjKKcsWjjTEjwV9PSXtHvb-+DB5Gs4uTk-05Pgg@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: adjust strobemeta loop to satisfy
 latest clang
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

On Wed, Sep 25, 2019 at 1:33 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Wed, Sep 25, 2019 at 11:52:05AM -0700, Andrii Nakryiko wrote:
> > Some recent changes in latest Clang started causing the following
> > warning when unrolling strobemeta test case main loop:
> >
> >   progs/strobemeta.h:416:2: warning: loop not unrolled: the optimizer was
> >   unable to perform the requested transformation; the transformation might
> >   be disabled or specified as part of an unsupported transformation
> >   ordering [-Wpass-failed=transform-warning]
> >
> > This patch simplifies loop's exit condition to depend only on constant
> > max iteration number (STROBE_MAX_MAP_ENTRIES), while moving early
> > termination logic inside the loop body. The changes are equivalent from
> > program logic standpoint, but fixes the warning. It also appears to
> > improve generated BPF code, as it fixes previously failing non-unrolled
> > strobemeta test cases.
> >
> > Cc: Alexei Starovoitov <ast@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Sounds like a clang regression? Was that from an official release?

It does, but I didn't dig deep enough to figure out what exactly
caused this. The version I used was latest Clang 10 built from
sources. Might be worth-while to investigate this further to prevent
some other unexpected breakages for user programs.

>
> Applied.

Thanks!
