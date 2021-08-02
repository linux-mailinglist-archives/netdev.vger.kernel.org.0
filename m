Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474D43DE126
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhHBU7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhHBU7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D08E6610FE;
        Mon,  2 Aug 2021 20:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627937977;
        bh=ME91uzg3uQGioK1v2nnqNunzlz6ItvqqOC1l0uFZutU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kcqiTXREDVH4w9R95j5w4WOfLMxOStmOouND1gl916CZScJNJtCl2GB4/lgbDDdn8
         5xkB3lwOkmI/t0GPSl79DjQj1otssX56UVlrFBidXX0eJEU7lwU6lqO+HpUUVo+xwt
         wZP28qF50h2MzZPUTIjMkv3Sb/lJw411baVC855CoXg5JOnKlfrBcuQRQ8x6ES6xdq
         zFCzAefIOUF+18rwisc0W6HOai8EG1W8b4IGfxgleFUhILKu8JwqiHgdLSfApZLAYU
         Lp0niOb4VUP4OS+u1avOiALt5h0fI0ogqg/qGz7k0ir8YhtBk5ozkl2l+0SXqQqnAb
         ttkQRLrNH58eQ==
Received: by mail-wm1-f54.google.com with SMTP id b128so11175416wmb.4;
        Mon, 02 Aug 2021 13:59:37 -0700 (PDT)
X-Gm-Message-State: AOAM531NKwDwu+K9LxegWducEHEamu9J3Omo4MKS/ZEuchieD0ApjeGw
        uMfWq+16Iv74YJMvJ6s9ZRp/0PZnDsvWQrX8cKw=
X-Google-Smtp-Source: ABdhPJy4NlTUHsygtWM7DW5cko6rUy0afbh+TXAP+SRYo4CljudxoDYG2Dg3SfR+K53fmjTEY+MfH6F9UpMtn2dxoOY=
X-Received: by 2002:a7b:ce10:: with SMTP id m16mr705834wmc.75.1627937976496;
 Mon, 02 Aug 2021 13:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210802145937.1155571-1-arnd@kernel.org> <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com> <CAK8P3a3P6=ZROxT8daW83mRp7z5rYAQydetWFXQoYF7Y5_KLHA@mail.gmail.com>
 <CO1PR11MB50892367410160A8364DBF69D6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB50892367410160A8364DBF69D6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Aug 2021 22:59:20 +0200
X-Gmail-Original-Message-ID: <CAK8P3a379=Qi7g7Hmf299GgM-6g32Them81uYXPqRDZDro_azg@mail.gmail.com>
Message-ID: <CAK8P3a379=Qi7g7Hmf299GgM-6g32Them81uYXPqRDZDro_azg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK dependencies
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 10:46 PM Keller, Jacob E
<jacob.e.keller@intel.com> wrote:

> > You can do something like it for a particular symbol though, such as
> >
> > config MAY_USE_PTP_1588_CLOCK
> >        def_tristate PTP_1588_CLOCK || !PTP_1588_CLOCK
> >
> >  config E1000E
> >         tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
> >         depends on PCI && (!SPARC32 || BROKEN)
> > +       depends on MAY_USE_PTP_1588_CLOCK
> >         select CRC32
> > -       imply PTP_1588_CLOCK
>
> What about "integrates"?

Maybe, we'd need to look at whether that fits for the other users of the
"A || !A" trick.

> Or.. what if we just changed "implies" to also include the dependencies
> automatically? i.e. "implies PTP_1588_CLOCK" also means the depends
> trick which ensures that you can't have it as module if this is built-in.
>
> I.e. we still get the nice "this will turn on automatically in the menu if you
> enable this" and we enforce that you can't have it as a module since it
> would be a dependency if it's on"?

I don't want to mess with the semantics of the keyword any further.
The original meaning was meant to avoid circular dependencies
by making it a softer version of 'select' that would not try to select
anything that has unmet dependencies. The current version made
it even softer by only having an effect during 'make defconfig'
and 'make oldconfig' but not preventing it from being soft-disabled
any more. Changing it yet again is guarantee to break lots of the
existing users, while probably also bringing back the original problem
of the circular dependencies.

         Arnd
