Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC742BC242
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 22:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgKUVZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 16:25:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbgKUVZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 16:25:52 -0500
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11A54217A0
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 21:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605993952;
        bh=3ZaqyGNkOtKVAfN7lmqpobgdhXBpWL3ofa/gEGqOwGk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IvxlB80sx0aGnhJJJhe2G1nB+Q+wJb6AcfM682+zhUQOAhOSVTrTexSdi2Rr7h4Qh
         WoatsyyoTGx7KSicYLRq109foWDTFwbaSVSqFU6iQqVDsBMyOfVlt6mn00PhhXFj6m
         5YV54F6WPe8lqX0UKARniX7WsuaTcQtZc+ZO7rtc=
Received: by mail-ot1-f44.google.com with SMTP id y24so6746710otk.3
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 13:25:52 -0800 (PST)
X-Gm-Message-State: AOAM531ULbfm59nOD3NeQEN2dsp5mmJ7HnTrBx/dNyg0pLSMWocVkqid
        X8H4gRagggLJbHKR0bE2L8WZUE51wADimqhppI4=
X-Google-Smtp-Source: ABdhPJyZMSz8Prx69e2wSjSbmNLNt4RRdNiy0jqEBT7kBkcol4RjZQE/o1xAoo+LvVtpVaaJR/QqRMYk0JXm/lYdHVg=
X-Received: by 2002:a9d:be1:: with SMTP id 88mr1990799oth.210.1605993951426;
 Sat, 21 Nov 2020 13:25:51 -0800 (PST)
MIME-Version: 1.0
References: <20201121175224.1465831-1-kuba@kernel.org>
In-Reply-To: <20201121175224.1465831-1-kuba@kernel.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 21 Nov 2020 22:25:35 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1sZ7CUwQ-fUCS-z4CkhgSiNqzPcc_MTc2D54-8vfmV=g@mail.gmail.com>
Message-ID: <CAK8P3a1sZ7CUwQ-fUCS-z4CkhgSiNqzPcc_MTc2D54-8vfmV=g@mail.gmail.com>
Subject: Re: [PATCH net-next] compat: always include linux/compat.h from net/compat.h
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 6:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> We're about to do some reshuffling in networking headers and make
> some of the file lose the implicit includes. This results in:
>
> In file included from net/ipv4/netfilter/arp_tables.c:26:
> include/net/compat.h:57:23: error: conflicting types for =E2=80=98uintptr=
_t=E2=80=99
>  #define compat_uptr_t uintptr_t
>                        ^~~~~~~~~
> include/asm-generic/compat.h:22:13: note: in expansion of macro =E2=80=98=
compat_uptr_t=E2=80=99
>  typedef u32 compat_uptr_t;
>              ^~~~~~~~~~~~~
> In file included from include/linux/limits.h:6,
>                  from include/linux/kernel.h:7,
>                  from net/ipv4/netfilter/arp_tables.c:14:
> include/linux/types.h:37:24: note: previous declaration of =E2=80=98uintp=
tr_t=E2=80=99 was here
>  typedef unsigned long  uintptr_t;
>                         ^~~~~~~~~
>
> Currently net/compat.h depends on linux/compat.h being included
> first. After the upcoming changes this would break the 32bit build.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Not sure who officially maintains this. Arnd, Christoph any objections?

Looks good to me. I would actually go one step further and completely
remove this #ifdef, if possible. In the old days, it was not possible to
include linux/compat.h on 32-bit architectures, but now this should just
work without an #ifdef.

     Arnd
