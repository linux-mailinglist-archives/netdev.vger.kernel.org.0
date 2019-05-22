Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FF727170
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbfEVVMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:12:42 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46767 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbfEVVMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 17:12:41 -0400
Received: by mail-qk1-f194.google.com with SMTP id a132so2442449qkb.13;
        Wed, 22 May 2019 14:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aeLzmRWF2SMl16m97oxGveslQ1R2/BKcrkqS1yhMUC4=;
        b=jx0yFibzlMjpDTFX74N8v0WDd0ZPqpaxb6z72yv/Gwkkv8CVWx7gQS4CJGNZ9K+iWj
         XXalWo83biv7MVJLOUHkE6i9V/V000oOnWr0LF/peksev2n/Ti+35F7+W9ltqv5B5Poh
         RSxGnNWBuuVMVwgmT06xiHXblipc4bKoYQYna3H5jLwYIVgY+ACZmn8FriPHiKxpBJxx
         xcjkENbv8kQ4sygLZFqver/MBD8x9A2ml9J5lNhjbcE99DLurL5KfpBaC4L3LvyzhLIV
         5BknKwiZW3A2ATewHtd3etWlGd+56URyVyGPS+0WJ6oy4ZIRmy5VX8aemn5ojJHDP6qD
         JYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aeLzmRWF2SMl16m97oxGveslQ1R2/BKcrkqS1yhMUC4=;
        b=RFFDPv1+jW1M2fuS3F4VP67pQWuWcDrOtnPc1MLZxFm11LAEXwvlHfLj3b4N94SU1M
         6fwn6NdxH5lxRukPfJV5MVV6ojBcCZtM954S/G8yBhsIq+I5oqpNYyhZmZ4kkFGY5/Pz
         a5Y1qbz+UcGcBFTHXNTPyJ3RvPeXpbWbEC9uhco1yE4EHtXpivY4QDcE40qrYXqTJ3Qh
         CPVbNi5hhr47EA0IRcYHjpBXYk+SwLGIi6u6Nbu3SphgwmYPZLbyt58q9T71+2D1Msk4
         aQCL0TJBFoTlu/+O5QoUbFs6D0fIFk03JQeBIEkNvOPMvRPPVBALAAKrqYZzJlIq8KPS
         PNvQ==
X-Gm-Message-State: APjAAAWxRxvMWzL8CV2dK4UVh9cZxGl61XNhULrHgZj02Xx+2n4iHuQK
        07Hc46sOnd2UDHATK7re3JQx9P88l1vShdxQeyQ=
X-Google-Smtp-Source: APXvYqzVkjaS/sFstZ6CqgYCPdGi536kD2lACo2/4soxjYUqCY4rFwLtN3gZ485ZBJ44ijbccxOIUH7cgV6++/xz8Bk=
X-Received: by 2002:a05:620a:12c4:: with SMTP id e4mr58083247qkl.81.1558559560140;
 Wed, 22 May 2019 14:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190522125353.6106-1-bjorn.topel@gmail.com> <20190522125353.6106-2-bjorn.topel@gmail.com>
 <20190522113212.68aea474@cakuba.netronome.com> <CAJ+HfNiz5xbhxshWbLXyiLKDEz3ksU5jg54xxurN17=nVPetyg@mail.gmail.com>
 <20190522140447.53468a2a@cakuba.netronome.com>
In-Reply-To: <20190522140447.53468a2a@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 22 May 2019 23:12:28 +0200
Message-ID: <CAJ+HfNhB3zs7uG+N0QyKC1PE4ZhA+dpo-kJeJYbh_mwQNPnKKg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 at 23:04, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 22 May 2019 22:54:44 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > > > Now, the same commands give:
> > > >
> > > >   # ip link set dev eth0 xdp obj foo.o sec main
> > > >   # ip link set dev eth0 xdpgeneric off
> > > >   Error: native and generic XDP can't be active at the same time.
> > >
> > > I'm not clear why this change is necessary? It is a change in
> > > behaviour, and if anything returning ENOENT would seem cleaner
> > > in this case.
> >
> > To me, the existing behavior was non-intuitive. If most people *don't*
> > agree, I'll remove this change. So, what do people think about this?
> > :-)
>
> Having things start to fail after they were successful/ignored
> is one of those ABI breakage types Linux and netdev usually takes
> pretty seriously, unfortunately.  Especially when motivation is
> "it's more intuitive" :)
>

Hey, intuition is a great thing! :-D

> If nobody chimes in please break out this behaviour change into
> a commit of its own.
>

Will do.


Bj=C3=B6rn


> > ENOENT does make more sense.
