Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20983F73D0
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240171AbhHYK43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240147AbhHYK42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:56:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA3616113C
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 10:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629888942;
        bh=UotmhqxofGpvvQkvxOp1E79lCEXlcshwQIXkdStegzk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hSSuD2MOe6hHkd3hjHDbVqXs/wnQhwcp0O06jqOqpKbyJChF1twk94U9YO/9hoTpp
         sD0qjCq36WHh5QJcjvV3GK91/1jNtVpkNN0vcbh79wVaU6AXQW2xEYshR/kq+oBLn0
         7VUFolw4UIB9SE8/2pb490dmcw41Y+knA97wTV+NZ2W+aJRl8qvQ0F6SNaiSF6WfiX
         jJdu6ptCEyzNLIPQvHs1RGQGuGlDbh8itGFVGOj8hBxmTlFxO/rUQceChvCRLaScWh
         +g9JEuqxDgJ5WRKT3P90LJoVwBQ9gt+VDP1Gzm2P/6yIotAWPms5tVSO3LUnWqXQKT
         I3IYhx9ZxtHWw==
Received: by mail-wr1-f52.google.com with SMTP id h13so35801063wrp.1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:55:42 -0700 (PDT)
X-Gm-Message-State: AOAM533yIh0O107cM+sS6rJ9fuAE6kcKX7i7OV4r6rVVeRcQRS4kGzI5
        QzDRQzlfCKJTwcNh2RPDxgKe3Jd53CDdi1BRR1g=
X-Google-Smtp-Source: ABdhPJzOZzYmnc4+3NQzqJAUrZmU8KCO7rlzuL9+ziC6Nczucg2O335v773X/Y4w7oKAWw/nM0Qs5n2ou+LRgCl1VyM=
X-Received: by 2002:a5d:58c8:: with SMTP id o8mr14402242wrf.361.1629888941350;
 Wed, 25 Aug 2021 03:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210813203026.27687-1-rdunlap@infradead.org> <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
 <20210820153100.GA9604@hoboy.vegasvil.org> <80be0a74-9b0d-7386-323c-c261ca378eef@infradead.org>
In-Reply-To: <80be0a74-9b0d-7386-323c-c261ca378eef@infradead.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 25 Aug 2021 12:55:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a11wvEhoEutCNBs5NqiZ2VUA1r-oE1CKBBaYbu_abr4Aw@mail.gmail.com>
Message-ID: <CAK8P3a11wvEhoEutCNBs5NqiZ2VUA1r-oE1CKBBaYbu_abr4Aw@mail.gmail.com>
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 11:48 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 8/20/21 8:31 AM, Richard Cochran wrote:
> > On Fri, Aug 20, 2021 at 12:45:42PM +0200, Arnd Bergmann wrote:
> >
> >> I would also suggest removing all the 'imply' statements, they
> >> usually don't do what the original author intended anyway.
> >> If there is a compile-time dependency with those drivers,
> >> it should be 'depends on', otherwise they can normally be
> >> left out.
> >
> > +1
>
> Hi,
>
> Removing the "imply" statements is simple enough and the driver
> still builds cleanly without them, so Yes, they aren't needed here.
>
> Removing the SPI dependency is also clean.
>
> The driver does use I2C, MTD, and SERIAL_8250 interfaces, so they
> can't be removed without some other driver changes, like using
> #ifdef/#endif (or #if IS_ENABLED()) blocks and some function stubs.

If the SERIAL_8250 dependency is actually required, then using
'depends on' for this is probably better than an IS_ENABLED() check.
The 'select' is definitely misplaced here, that doesn't even work when
the dependencies fo 8250 itself are not met, and it does force-enable
the entire TTY subsystem.

      Arnd


        Arnd
