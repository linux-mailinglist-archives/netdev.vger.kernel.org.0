Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6218C48EF91
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 18:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbiANR6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 12:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiANR63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 12:58:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD42C061574;
        Fri, 14 Jan 2022 09:58:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 106FFB82475;
        Fri, 14 Jan 2022 17:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511E7C36AED;
        Fri, 14 Jan 2022 17:58:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Jx12eIPE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642183102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YHyEepeNh59ZLXwWnhnQQJ/e6lEcnUrxsutiHo3eOR4=;
        b=Jx12eIPENreJzRSXmN0btIEaD8vfeFsBgbnq7bkmz8aBz9fidv26hr9Hn2sADN1F53qWRv
        vL+Dro9NUsb2SuA/+oQewDEz3bYpkKrTkDoYZ2h8aF6MZSQVd4VvfaQYA2kYF5HWs5t8Z7
        pHT7OoyEXHvdD61nHROxrBKJb0HepBc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 18a1a83b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 17:58:22 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id z22so25453076ybi.11;
        Fri, 14 Jan 2022 09:58:21 -0800 (PST)
X-Gm-Message-State: AOAM530BtDi/0GZNrdW4myrs7OXQBAD0EB/fWF/5+vEucJRc17Q0AyGc
        soiQ8Rps3Ydvt3km/t7vRlkXU0qiGTsRipDVmk8=
X-Google-Smtp-Source: ABdhPJwxV9VOAFJPoenBfXtLga5hL8bzJYQgUTXqzUI6VsYxsbXZqCidxviLJmz76mwNLT48akKG1DOjcYTWkhknw0c=
X-Received: by 2002:a25:f90d:: with SMTP id q13mr14306810ybe.32.1642183100170;
 Fri, 14 Jan 2022 09:58:20 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
 <87r19cftbr.fsf@toke.dk> <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
 <CAHmME9pR+qTn72vyANq8Nxx0BtGy7a_+dRvZS_F7RCag8Rvxng@mail.gmail.com> <3db9c306-ea22-444f-b932-f66f800a7a28@www.fastmail.com>
In-Reply-To: <3db9c306-ea22-444f-b932-f66f800a7a28@www.fastmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Jan 2022 18:58:09 +0100
X-Gmail-Original-Message-ID: <CAHmME9qy4-qkBAD9fJ6jqHxw2DYtscerZdriMYXw1T4iPD6Y-A@mail.gmail.com>
Message-ID: <CAHmME9qy4-qkBAD9fJ6jqHxw2DYtscerZdriMYXw1T4iPD6Y-A@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hannes,

On Fri, Jan 14, 2022 at 6:44 PM Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> I don't think we can argue our way out of this by stating that there are
> no guarantees anyway, as much as I would like to change the hash
> function as well.

Shucks. Alright then.

> As much as I know about the problems with SHA1 and would like to see it
> removed from the kernel as well, I fear that in this case it seems hard
> to do. I would propose putting sha1 into a compilation unit and
> overwrite the compiler flags to optimize the function optimized for size
> and maybe add another mode or knob to switch the hashing algorithm if
> necessary.

Already on it! :)
https://lore.kernel.org/linux-crypto/20220114154247.99773-3-Jason@zx2c4.com/

> I haven't investigated recent research into breakage of SHA1, I mostly
> remember the chosen-image and collision attacks against it. Given the
> particular usage of SHA1 in this case, do you think switching the
> hashing function increases security?

Considering we're only using 64-bits of SHA-1 output, I don't think
the SHA-1 collision attacks give you that much here. And it seems like
there are other network-level security concerns with the whole scheme
anyway. So it might not be the largest of matters. However...

> I am asking because of the desire
> to decrease the instruction size of the kernel

Indeed this is what I was hoping for.

Jason
