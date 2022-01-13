Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC0D48D954
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbiAMNyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiAMNyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:54:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33F9C06173F;
        Thu, 13 Jan 2022 05:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C68561873;
        Thu, 13 Jan 2022 13:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734ABC36AED;
        Thu, 13 Jan 2022 13:54:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="iag1Pjyt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642082058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=61YSROwWE/Gcp7WTXjpiVvqSydZzak+NmIjnkeum6eQ=;
        b=iag1Pjyt5hj2O7W99Cq8EWehILGtjwKA5fFqIciqQlDVCeAeFVfVnDT/VFWpNePsajIVJl
        HhzMdZOagjz91mrG7CzGtTq4CoakhKpL7KxoLT9+/tTGl222fdIX9rutSGgsawnpvyvRWQ
        KwTYtRZ1o9SRq+hsa+o26HU7pwIgpYM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 716f9775 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 13 Jan 2022 13:54:18 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id p187so15266838ybc.0;
        Thu, 13 Jan 2022 05:54:17 -0800 (PST)
X-Gm-Message-State: AOAM5311JJBOC4o92Mm2aN8iI0ox6G6P9nDSnXmlIRNQh1WpQ3C0nWWd
        q9X3dhYkjpQMu80ojMqy0gGGwtvTXywWVQXBezY=
X-Google-Smtp-Source: ABdhPJwjbRd36GMfxwrG3pG8iDeZufs5Li2mGATKWmYMFJUbMvilv8ZPwE22YlkQM3JQRSbI4zFZEQJ56ru2gKTVYiA=
X-Received: by 2002:a25:854f:: with SMTP id f15mr6074236ybn.121.1642082056304;
 Thu, 13 Jan 2022 05:54:16 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
 <87r19cftbr.fsf@toke.dk> <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
 <CAMj1kXGz7_98B_b=SJER6-Q2g-nOT5X3cfN=nfhYoH0eHep5bw@mail.gmail.com>
 <87ilung3uo.fsf@toke.dk> <CAHmME9onde38SNBBsmypzr_QDSDiQ_0opPiqJ7sU5X-iMDtncQ@mail.gmail.com>
 <CAMj1kXE0Hhi1kgXx2vNchoKOrQOZEBg1V6c5w7if3yN4_GNn8g@mail.gmail.com>
In-Reply-To: <CAMj1kXE0Hhi1kgXx2vNchoKOrQOZEBg1V6c5w7if3yN4_GNn8g@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 13 Jan 2022 14:54:05 +0100
X-Gmail-Original-Message-ID: <CAHmME9qLPxVSypcMECUjNeFz8qeUpeDe-LiXFoZTBYnGW9=ukQ@mail.gmail.com>
Message-ID: <CAHmME9qLPxVSypcMECUjNeFz8qeUpeDe-LiXFoZTBYnGW9=ukQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 2:50 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > Then, at some point down the road, we can talk about removing
> > CONFIG_NET_OBSOLETE_INSECURE_ADDRCONF_HASH too.
> >
>
> What is the point of having CONFIG_OLD_N_CRUSTY if all distros are
> going to enable it indefinitely?

I think there's probably some combination of
CONFIG_NET_OBSOLETE_INSECURE_ADDRCONF_HASH and CONFIG_OLD_N_CRUSTY and
maybe even a CONFIG_GOD_MURDERS_KITTENS that might be sufficiently
disincentivizing? Or this ties into other general ideas on a gradual
obsolescence->removal flow for things.
