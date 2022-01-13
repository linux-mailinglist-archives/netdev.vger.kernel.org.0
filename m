Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A6748D7F2
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 13:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiAMM3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 07:29:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57400 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiAMM3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 07:29:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE2BCB8226C;
        Thu, 13 Jan 2022 12:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFB1C36AEF;
        Thu, 13 Jan 2022 12:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642076992;
        bh=X5jETQgkQZS/2fpSntJpBBFhReQIN06u1o0hN2hor78=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cm0l6TUG4CMMmVUp+jXxaKjNQyOVhj//O8GkLtbxT1csqRchAoKfMSsjZj228V4TM
         chNGd7GNKBS0UVgZX/FWjNvTNZ/QA/JD3E4n9H9x3cHB5bGkWKQUzh+HSb++jm1827
         RIK6RZYwgJopXuPX7MZ4S7YH8Dk9I148EVxeKLeKEcaF8YTleX+nFSqiN+Ja/iZ4sK
         yA9OXCWOPfNswtKqUFLQPlRVmBS7TNJ8lLqIX6c9NNJIHFPfWz3AA6iIC7pyjLvn4m
         GDaFm6XZTBTkNn6yE8ER+1kaOGUtTzIwDoC8OTwpnqcO4r+i/XTRPGEMFH04mqsdmi
         QjsnxVMtkuKAA==
Received: by mail-wr1-f53.google.com with SMTP id l25so9735844wrb.13;
        Thu, 13 Jan 2022 04:29:52 -0800 (PST)
X-Gm-Message-State: AOAM533Sq8el3gUZcNzIxJF9a9uO5FiDMuOTQQghhtZ02gMmVXc4hfuW
        tj4m0oL2E1y3u7LzVPPPHPL2WrxUsBPEni4hk1Y=
X-Google-Smtp-Source: ABdhPJzbEoF8BcekTlsuwHwDqGMGCkjXPqt10iYsm5hjT9bV1vFHGcxLmw+JEzXMd4aIE7HlJHP7IuBXHZh6PSFwxss=
X-Received: by 2002:adf:f287:: with SMTP id k7mr3883893wro.417.1642076991005;
 Thu, 13 Jan 2022 04:29:51 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
 <87r19cftbr.fsf@toke.dk> <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
 <CAMj1kXGz7_98B_b=SJER6-Q2g-nOT5X3cfN=nfhYoH0eHep5bw@mail.gmail.com> <CAHmME9paa0Z+wBza4gDT3xPzKqhGk9AoL433sOu9H=NHxiZA_Q@mail.gmail.com>
In-Reply-To: <CAHmME9paa0Z+wBza4gDT3xPzKqhGk9AoL433sOu9H=NHxiZA_Q@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 13 Jan 2022 13:29:39 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHHvm6jeoWZVcRuRtxos3MJajMkuFj4-Hu6ZADjxu=y3A@mail.gmail.com>
Message-ID: <CAMj1kXHHvm6jeoWZVcRuRtxos3MJajMkuFj4-Hu6ZADjxu=y3A@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
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

On Thu, 13 Jan 2022 at 13:22, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On 1/13/22, Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > The question is not whether but when we can/will change this.
> >
> > SHA-1 is broken and should be removed at *some* point, so unless the
> > feature itself is going to be obsolete, its implementation will need
> > to switch to a PRF that fulfils the requirements in RFC7217 once SHA-1
> > ceases to do so.
> >
> > And I should also point out that the current implementation does not
> > even use SHA-1 correctly, as it omits the finalization step. This may
> > or may not matter in practice, but it deviates from crypto best
> > practices, as well as from RFC7217
> >
> > I already pointed out to Jason (in private) that the PRF does not need
> > to be based on a cryptographic hash, so as far as I can tell, siphash
> > would be a suitable candidate here as well, and I already switched the
> > TCP fastopen code to that in the past. But SHA-1 definitely has to go.
> >
>
> Correction: this should be a cryptographically secure.

Of course. I said it does not need to be based on a cryptographic *hash*.

> That's part of
> the point of moving away from SHA-1 of course. But fortunately,
> siphash *is*
> considered to be cryptographically secure. Whether you want blake2s's
> keyed mode or siphash doesn't really matter to me. I thought the
> former's API mapped a bit neater here.

Fair enough. This is not on a hot path anyway, so it doesn't really
matter performance wise.
