Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F1610844A
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 18:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKXRQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 12:16:33 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:39046 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfKXRQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 12:16:33 -0500
Received: by mail-qv1-f68.google.com with SMTP id v16so4785721qvq.6;
        Sun, 24 Nov 2019 09:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BP3QlOAS6TC4ZpqvyGCUa6UmnZm7bb5wni9SFB36WMo=;
        b=KTrocz6o9oo9xIzOZUWQWeLdRpOuqJdgoFLr9CB//ol1L2BHvA0mXLI9S/6CJ0nM7M
         LfPHvzxqTb0XWz+FDnHepZyIsI01OQD42wIZxhRrBaN5AvLTk5UJCcI2kNcmIHGw1mGu
         W9WoOdlEv0Jv853okCgUNKfayKyffZVwQhXPa4kzdb24psWBVwaROMbmcnvAmnNC4Czw
         vOlUWpgwRyGO+WdDi9ar/EPu4AcOfeetbTVYfTHO5WX5Sa3XxIh5R7TZ2pGzRDqPVxFr
         RlbEeSAgipPK+iUwkW48PKWTDeORDs4LUXXXAAhlcyk6hnWlPZKLhwGbecCSu6C+401N
         PMmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BP3QlOAS6TC4ZpqvyGCUa6UmnZm7bb5wni9SFB36WMo=;
        b=loPAnaw7HteeHEMs1Da1Wu0An6AZ54nuYH8MBAQzMxHzlpXkTcwEEeFAyFRACz1A9d
         iRHt24wEJA4sTknu61WE7kC9+UcbANvCW3hDp5XQiyD3R9HSMIwn+E//yDcQ8i3hPlqv
         dD/0Vrhxm5AA3Fe9zm3ub4+oO4xYvMAdbNQ4YLRmSm3lYO5OFIWJUF+CPRA8zsr85nTy
         ZUr0tAk6u1nW+kmcHlyil9NBxcfxIfvYw/apXYJsGg59urhVZr0+X0yQHb+FLqAOkuTg
         AkJ53B6A5cGsgdmAFc8Qigze3TimRKjWHgCRLzoUwMvPUDJLxXdjXPS6aRMj1PJvDwBt
         Hnsg==
X-Gm-Message-State: APjAAAWx7Gg6MbToUQM0TUneWh2aavyIKBBM+ryEpZKWMcVGlt/C7BCC
        sZnBLZIWkQ4sIL6OhdJgYeJ+R1IfIXCV6NeNBT0=
X-Google-Smtp-Source: APXvYqxLbCN9mwmTuh/4qLEFGR57XAzaZFFlu+uzhGAK6oLZ6tw8rzkVmxNTg3rDPY8gP++5q4ps0Eqyw899Z1s/rSQ=
X-Received: by 2002:a0c:fe11:: with SMTP id x17mr14791831qvr.162.1574615791752;
 Sun, 24 Nov 2019 09:16:31 -0800 (PST)
MIME-Version: 1.0
References: <20191123071226.6501-1-bjorn.topel@gmail.com> <20191123071226.6501-2-bjorn.topel@gmail.com>
 <20191124015504.yypqw4gx52e5e6og@ast-mbp.dhcp.thefacebook.com>
 <CAJ+HfNhtgvRyvnNT7_iSs9RD3rV_y8++pLddWy+i+Eya5_BJVw@mail.gmail.com> <20191124170841.x4ohh7sy6kbjnbno@ast-mbp>
In-Reply-To: <20191124170841.x4ohh7sy6kbjnbno@ast-mbp>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sun, 24 Nov 2019 18:16:07 +0100
Message-ID: <CAJ+HfNgLmC3O2YVFW8gzW6Jsf9=MKWo_gw-FXog3YeuGs=bwAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/6] bpf: introduce BPF dispatcher
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Nov 2019 at 18:08, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Nov 24, 2019 at 07:55:07AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > >
> > > I think I got it why it works.
> > > Every time the prog cnt goes to zero you free the trampoline right aw=
ay
> > > and next time it will be allocated again and kzalloc() will zero sele=
ctor.
> > > That's hard to spot.
> > > Also if user space does for(;;) attach/detach;
> > > it will keep stressing bpf_jit_alloc_exec.
> > > In case of bpf trampoline attach/detach won't be stressing it.
> > > Only load/unload which are much slower due to verification.
> > > I guess such difference is ok.
> > >
> >
> > Alexei, thanks for all feedback (on the weekend)! I agree with all of
> > above, and especially missing selftests and too much code duplication.
> >
> > I'll do a respin, but that'll be in the next window, given that Linus
> > will (probably) tag the release today.
>
> I want it to land just as much as you do :) Two weeks is not a big deal. =
We
> backport all of bpf and xdp as soon as it lands in bpf-next/net-next. We =
don't
> wait for patches to reach Linus's tree. So this dispatch logic will be ru=
nning
> on our servers way sooner than you'd expect. I guess that explains my obs=
ession
> with quality. Same goes for libbpf.
>

No reason to rush it in! It's just a week back and forth, and your
comments were spot on.


Cheers,
Bj=C3=B6rn


>
