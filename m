Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F492C3071
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404411AbgKXTGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:06:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404309AbgKXTGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 14:06:05 -0500
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 885CE206E5
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606244764;
        bh=BS6XLB0q6ptAQ4wnReP6rSCBW2YtfjSMtz+ICfC6Nvg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EkWMGfhrKkObsRXPrazJY2st2zUY6voYUmz1QtdHfPxXd025GKGyPZlaJoIHUdMR0
         czqQ55/IGUlJGyW5nPiaw1FK4JduuVUK213jgwjw5rtnbJLYcvOgsQA+q0kchUdjhY
         wICy5OrNQLVqLNJVMACqLrLHUrqskL1NHdve/UZs=
Received: by mail-ot1-f52.google.com with SMTP id 92so17325938otd.5
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 11:06:04 -0800 (PST)
X-Gm-Message-State: AOAM532PzQ38SxJewjnycBUPrOOxK+wth8Kzq4Mb+qPn8FZYVwDLytsi
        +CTBR5APmFzZrqp3O0P6r9d2lZR5PbpJLO4kIt8=
X-Google-Smtp-Source: ABdhPJzvvM1on9CXhn9Jxz5Qh0FD4/UHd8EMcj2vqoC1zOkpBCV3KGHpRyKu+d35Inz8UZ+go1NvGvBPmIcVEDQTq5U=
X-Received: by 2002:a05:6830:22d2:: with SMTP id q18mr4071648otc.305.1606244763713;
 Tue, 24 Nov 2020 11:06:03 -0800 (PST)
MIME-Version: 1.0
References: <20201124151828.169152-1-arnd@kernel.org> <20201124151828.169152-3-arnd@kernel.org>
 <e86a5d8a3aed44139010dac219dfcf08@AcuMS.aculab.com>
In-Reply-To: <e86a5d8a3aed44139010dac219dfcf08@AcuMS.aculab.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 24 Nov 2020 20:05:46 +0100
X-Gmail-Original-Message-ID: <CAK8P3a08F1Xk2Vz69CUN=sJcBkqZvcrkd06qrmG3SMR8VhBN4A@mail.gmail.com>
Message-ID: <CAK8P3a08F1Xk2Vz69CUN=sJcBkqZvcrkd06qrmG3SMR8VhBN4A@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] net: socket: rework SIOC?IFMAP ioctls
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 5:13 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Arnd Bergmann
> > Sent: 24 November 2020 15:18
> >
> > SIOCGIFMAP and SIOCSIFMAP currently require compat_alloc_user_space()
> > and copy_in_user() for compat mode.
> >
> > Move the compat handling into the location where the structures are
> > actually used, to avoid using those interfaces and get a clearer
> > implementation.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > changes in v3:
> >  - complete rewrite
> ...
> >  include/linux/compat.h | 18 ++++++------
> >  net/core/dev_ioctl.c   | 64 +++++++++++++++++++++++++++++++++---------
> >  net/socket.c           | 39 ++-----------------------
> >  3 files changed, 62 insertions(+), 59 deletions(-)
> >
> > diff --git a/include/linux/compat.h b/include/linux/compat.h
> > index 08dbd34bb7a5..47496c5eb5eb 100644
> > --- a/include/linux/compat.h
> > +++ b/include/linux/compat.h
> > @@ -96,6 +96,15 @@ struct compat_iovec {
> >       compat_size_t   iov_len;
> >  };
> >
> > +struct compat_ifmap {
> > +     compat_ulong_t mem_start;
> > +     compat_ulong_t mem_end;
> > +     unsigned short base_addr;
> > +     unsigned char irq;
> > +     unsigned char dma;
> > +     unsigned char port;
> > +};
>
> Isn't the only difference the number of pad bytes at the end?

No, the main difference is in the first two fields, which are
'unsigned long' and therefore different. The three-byte padding
is in fact the same on all architectures (including x86) that
have a compat mode, though it might be different on
m68k and arm-oabi, which have slightly special struct
alignment rules.

It could be done with two assignments and a memcpy, but
I like the individual assignments better here.

      Arnd
