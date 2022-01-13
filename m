Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D2D48D76B
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 13:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbiAMMWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 07:22:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53886 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiAMMWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 07:22:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD5C5B81E01;
        Thu, 13 Jan 2022 12:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1426BC36AEC;
        Thu, 13 Jan 2022 12:22:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EU4uyXl4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642076537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V0JeEnmtJgLb+y+51mSgUr3EG3+TtCyN0Me8Wbf10SI=;
        b=EU4uyXl436+kI+UsnnGnCRK9emZW6OBHqUuJJbvBFRLdhwjKw1Hjua83yG6/1Y/LwnkJSW
        c/ho+xCRKj3JkpapWxBtXFmXL2e0Ivybi7suTwgbVqoX1VMhKKYZA8QGVuoCJIz6YrJKUC
        SIIGAdpfx5QKTs7xvkOWJnGL9Z+1ucI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d6fa39be (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 13 Jan 2022 12:22:16 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id c10so14443771ybb.2;
        Thu, 13 Jan 2022 04:22:16 -0800 (PST)
X-Gm-Message-State: AOAM532kTnQBELrUDYhAiBSM8iQ2xxK++BqbEto9GfVU1lF0v7pYlkzQ
        swdzLJxaOP2CAiwXvbykz/QmXK+jpWle8WSYL+g=
X-Google-Smtp-Source: ABdhPJz3gmZdBni/keHIwoL6GRGvWrdqdy6dH+SLERbFloukzNWhMunehPoj2kE6CLqLLpIJHq5uey154hpLJtFBUEw=
X-Received: by 2002:a25:4109:: with SMTP id o9mr2956311yba.115.1642076534819;
 Thu, 13 Jan 2022 04:22:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:209:b0:11c:1b85:d007 with HTTP; Thu, 13 Jan 2022
 04:22:14 -0800 (PST)
In-Reply-To: <CAMj1kXGz7_98B_b=SJER6-Q2g-nOT5X3cfN=nfhYoH0eHep5bw@mail.gmail.com>
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
 <87r19cftbr.fsf@toke.dk> <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org> <CAMj1kXGz7_98B_b=SJER6-Q2g-nOT5X3cfN=nfhYoH0eHep5bw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 13 Jan 2022 13:22:14 +0100
X-Gmail-Original-Message-ID: <CAHmME9paa0Z+wBza4gDT3xPzKqhGk9AoL433sOu9H=NHxiZA_Q@mail.gmail.com>
Message-ID: <CAHmME9paa0Z+wBza4gDT3xPzKqhGk9AoL433sOu9H=NHxiZA_Q@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Hannes Frederic Sowa <hannes@stressinduktion.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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
        hideaki.yoshifuji@miraclelinux.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/22, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> The question is not whether but when we can/will change this.
>
> SHA-1 is broken and should be removed at *some* point, so unless the
> feature itself is going to be obsolete, its implementation will need
> to switch to a PRF that fulfils the requirements in RFC7217 once SHA-1
> ceases to do so.
>
> And I should also point out that the current implementation does not
> even use SHA-1 correctly, as it omits the finalization step. This may
> or may not matter in practice, but it deviates from crypto best
> practices, as well as from RFC7217
>
> I already pointed out to Jason (in private) that the PRF does not need
> to be based on a cryptographic hash, so as far as I can tell, siphash
> would be a suitable candidate here as well, and I already switched the
> TCP fastopen code to that in the past. But SHA-1 definitely has to go.
>

Correction: this should be a cryptographically secure. That's part of
the point of moving away from SHA-1 of course. But fortunately,
siphash *is*
considered to be cryptographically secure. Whether you want blake2s's
keyed mode or siphash doesn't really matter to me. I thought the
former's API mapped a bit neater here.
