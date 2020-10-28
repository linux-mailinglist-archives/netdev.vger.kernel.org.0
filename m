Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA47229DE60
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbgJ1WTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731697AbgJ1WRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:41 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B599724658;
        Wed, 28 Oct 2020 08:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603874169;
        bh=tR5T1ixXSQsN1p3RFSnnK5n87sXC6NvZ2LmyQ9KYqew=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WMDLNdKLDhqkIvvJH7y8KwUNKg5yd3myAMFox9dG+dZuCpFin9ejEFcjuJUpvDDeZ
         sCP0aRhfXzzXZ/kgfl5VCvoAfvZLKFBZrw6QpyFlC+S/xoWXYfgpRhcvWBdExx1qUP
         FWwryo469rY/80saP+7qRULEonovseMm0snoC0Ew=
Received: by mail-qt1-f178.google.com with SMTP id r8so2971777qtp.13;
        Wed, 28 Oct 2020 01:36:09 -0700 (PDT)
X-Gm-Message-State: AOAM530BjIW6XJjY3Q3HdzaoSIHrnSCWrPEMVnkq+hRb8J+XsU7yF+9X
        9qCTLKu6Q+7Ra/yniLPgk/VJhacwnyJ3WzPs/Co=
X-Google-Smtp-Source: ABdhPJyvQK7A6eVqNlZh9SImBHOPgfZPetL/xuQ/QKJ2RTER9SX+SnPDHfWDJLbNIPOIGFTtguwvTzfUSnxARr0lfRM=
X-Received: by 2002:ac8:7b33:: with SMTP id l19mr5954088qtu.304.1603874168761;
 Wed, 28 Oct 2020 01:36:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201026213040.3889546-1-arnd@kernel.org> <20201027174226.4bd50144@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201027174226.4bd50144@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 28 Oct 2020 09:35:52 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2=MDw5Oem45Omuhq0xk8c-yN5XzhSdrCguCSZDOu_gfA@mail.gmail.com>
Message-ID: <CAK8P3a2=MDw5Oem45Omuhq0xk8c-yN5XzhSdrCguCSZDOu_gfA@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] atm: horizon: shut up clang null pointer
 arithmetic warning
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Chas Williams <3chas3@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-atm-general@lists.sourceforge.net,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 1:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 26 Oct 2020 22:29:48 +0100 Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > Building a "W=1" kernel with clang produces a warning about
> > suspicous pointer arithmetic:
> >
> > drivers/atm/horizon.c:1844:52: warning: performing pointer arithmetic
> > on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >   for (mem = (HDW *) memmap; mem < (HDW *) (memmap + 1); ++mem)
> >
> > The way that the addresses are handled is very obscure, and
> > rewriting it to be more conventional seems fairly pointless, given
> > that this driver probably has no users.
> > Shut up this warning by adding a cast to uintptr_t.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Hi!
>
> I'm not sure what your plan is for re-spinning but when you do could
> you please split the wireless changes out?

Sure, will do. The easiest for me would be if you just merge the ones
that have been acked or that look obvious enough for you, and I'll
then resend whatever is left after addressing the review comments.

If that causes you extra work, I'll just send everything that should go
through your tree.

> Also we never got patch 3
> IDK if that's a coincidence or if it wasn't for networking...

Yes, that one slipped in when I was sorting my longer series, it
was a block driver change.

      Arnd
