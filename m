Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCC928E8EB
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 00:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgJNWxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 18:53:18 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:49963 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbgJNWxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 18:53:18 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 442ae914;
        Wed, 14 Oct 2020 22:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=2bwGM25lN52UQxYKx/Y8jAbUdGU=; b=Se/mlF
        eLahjhRmIiKnouDoe0+ba694TZ/NJev9yyeuuZGRGjUgc1tYuxRVDaXZrz06s0Hr
        d/BVx9kGWnNCrcuTyG6uKYR2lrzxf/bZfYpQA2S4y3ZXlDpxbfvuYg8Ov8OW0UV0
        s0dv6hhMZRnNcjbloMZnUsXO9M8M0kp16bhFCK2s26LSIp672aXuZbnh7WUZoWRs
        0D+vGZS+Y1IbyK51KiCfcZQIzTcVOL+msiHot0nrzxzMHuKcZyi6CNOxLA6S9la6
        4Dnx6RGVep3yWF6XRJ1/w5I0XMXZUzlSxWCtdsnMmjvlR+LEY2L0jSEgiWn5EC9v
        iuNHJlY1xQSHrn3A==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 830e8d48 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 14 Oct 2020 22:19:41 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id 67so1673659iob.8;
        Wed, 14 Oct 2020 15:53:16 -0700 (PDT)
X-Gm-Message-State: AOAM531NBCvdHR+rQRV3wlk/1gmV3m4JR2+FtDn4Zdewd6utotXhT8Zj
        RbOUl3pC+elhbvSimY7K2n33phkt1HhH5gR3Bpc=
X-Google-Smtp-Source: ABdhPJw6bdevPelx8D6A+pUz9BwTRHVh5Qc4DW55dxc0R3DWyvS/aEn/iKmQp/sANsC3zUjJk5FnvAdQ/gv9dzlOT+U=
X-Received: by 2002:a6b:3bcf:: with SMTP id i198mr1222193ioa.25.1602715996006;
 Wed, 14 Oct 2020 15:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200724012512.GK2786714@ZenIV.linux.org.uk> <20200724012546.302155-1-viro@ZenIV.linux.org.uk>
 <20200724012546.302155-20-viro@ZenIV.linux.org.uk> <20201014222650.GA390346@zx2c4.com>
 <CAHk-=wgTrpV=mT_EZF1BbWxqezrFJRJcaDtuM58qXMXk9=iaZA@mail.gmail.com>
In-Reply-To: <CAHk-=wgTrpV=mT_EZF1BbWxqezrFJRJcaDtuM58qXMXk9=iaZA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 15 Oct 2020 00:53:05 +0200
X-Gmail-Original-Message-ID: <CAHmME9rbiFJ8hAqU+u4TJjiSeJRa_R_QUV5VF4NRHJHP=HjyQw@mail.gmail.com>
Message-ID: <CAHmME9rbiFJ8hAqU+u4TJjiSeJRa_R_QUV5VF4NRHJHP=HjyQw@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] ppc: propagate the calling conventions change
 down to csum_partial_copy_generic()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 12:51 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Oct 14, 2020 at 3:27 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > This patch is causing crashes in WireGuard's CI over at
> > https://www.wireguard.com/build-status/ . Apparently sending a simple
> > network packet winds up triggering refcount_t's warn-on-saturate code. I
>
> Ouch.
>
> The C parts look fairly straightforward, and I don't see how they
> could cause that odd refcount issue.
>
> So I assume it's the low-level asm code conversion that is buggy. And
> it's apparently the 32-bit conversion, since your ppc64 status looks
> fine.
>
> I think it's this instruction:
>
>         addi    r1,r1,16
>
> that should be removed from the function exit, because Al removed the
>
> -       stwu    r1,-16(r1)

I just tried that about a minute ago, and indeed that seems to be
what's up. Problem goes away without it. I'll send a patch shortly.

Jason
