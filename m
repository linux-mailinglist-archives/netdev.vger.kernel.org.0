Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A669D35EC94
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 07:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349011AbhDNFye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 01:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347991AbhDNFxi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 01:53:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EF4C60BBB;
        Wed, 14 Apr 2021 05:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618379596;
        bh=ifghnpZF4cab51wf/GaXfpPHxzkiE0Xm9QeqXGQPtgc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Kgs86P2usKXy+79WZ7fLegeuNMGJUONny7PUPqyU4JZ1XVKgYUXBSPqI654aQ/40P
         1pyxe9z+GPUF96ddcIdONrzpGBAEzr2H2ZsmfkR4zZQeLe83pwrqpS3jYQXQCebw6X
         WeOx/fnVkTQ0QWJHA2y5wBJ4zHm+lOdRHslFR9Ka0bIB35yqWAUD+r5Q1iUS+JO92Y
         PuLRP7KJ26dZeHUpMWSN4rc7S4bCwPqwrhxhuMAA+8d63DXLNzJdFiexDPdKeyTtW0
         sNMvC5aSECkqq68BjS4duzoAkyv6T2xhL2gdcerrd/hnYg6xEPRFfnyKVxSVIBP3Ho
         YVnJpaNQBDOsg==
Received: by mail-wr1-f52.google.com with SMTP id g9so2577800wrx.0;
        Tue, 13 Apr 2021 22:53:16 -0700 (PDT)
X-Gm-Message-State: AOAM531xdsOyXGS3A+bos6H8H/ADcs0zdvOng4z4mqY0H3tiuD3P7j/n
        uKpMcQ4bCpHiAbO6Yw7fLlLgT3AMdcl11VQl+yY=
X-Google-Smtp-Source: ABdhPJy51/b6W+EKiNhSS+iJU3+dVxLryertqO+/vSmzLGmUXWnERfTqC6hgIaSxp0ZQLn4367Xq17TqiphXEElHql4=
X-Received: by 2002:adf:e483:: with SMTP id i3mr13495285wrm.286.1618379594859;
 Tue, 13 Apr 2021 22:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210413141627.2414092-1-arnd@kernel.org> <20210413154204.1ae59d6a@hermes.local>
In-Reply-To: <20210413154204.1ae59d6a@hermes.local>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 14 Apr 2021 07:52:58 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1bZWsMvARCj2LKerQrdw_asiOvffxN2c5ekoDDNESooA@mail.gmail.com>
Message-ID: <CAK8P3a1bZWsMvARCj2LKerQrdw_asiOvffxN2c5ekoDDNESooA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Space: remove hp100 probe
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021, 00:42 Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 13 Apr 2021 16:16:17 +0200 Arnd Bergmann <arnd@kernel.org> wrote:
>
> >   */
> >  static struct devprobe2 isa_probes[] __initdata = {
> > -#if defined(CONFIG_HP100) && defined(CONFIG_ISA)     /* ISA, EISA */
> > -     {hp100_probe, 0},
> > -#endif
> >  #ifdef CONFIG_3C515
> >       {tc515_probe, 0},
> >  #endif
>
> Thanks, do we even need to have the static initialization anymore?

I actually did some more cleanups after I sent the above patch when
I found out that this code still exists. It turned out that above half of
the static initializations are completely pointless because the
drivers never rely on the netdev= command line arguments and
can simply be changed to always using module_init() instead of
relying on net_olddevs_init() for the built-in case.

The remaining ones are all ISA drivers: 3c515, Ultra, WD80x3,
NE2000, Lance, SMC9194, CS89x0, NI65 and COPS.

With my cleanups, I move the netdev_boot_setup infrastructure
into drivers/net/Space.c and only compile it when at least one of
these eight drivers is enabled.

All these drivers also support being built as loadable modules, but
in that configuration they only support a single device (back in the
day you could copy the module and just load it twice to support
more than one instance, not sure we still want to support that).

None of these drivers have a maintainer listed, but I suppose
there are still some PC/104 machines with NE2000 network
cards that could theoretically run a modern kernel.

        Arnd
