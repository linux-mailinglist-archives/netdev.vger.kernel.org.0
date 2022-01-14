Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FB348F2CA
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiANXE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiANXE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:04:26 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B672CC061574;
        Fri, 14 Jan 2022 15:04:26 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i65so4065901pfc.9;
        Fri, 14 Jan 2022 15:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=J4+lZIDd6o5zmH05CFS7Chus/4ckzIXTgk91SRnxUls=;
        b=FTpEGS7qAx/sQGZEcABd019S7Hymf9UHf4a+Z/FjMnKETvgcSNOuprT2LqLixPDeU4
         my/DZmh4kvT5trb5uQ3kQHJzq/69VUUie5znya1InMaurhjnGjQeyR5fxccRqI+cmpbC
         w/WhOjbKT3fzbrAceqOtVrj3g5BC76OA3C5KYveiiPrCq9ufFYuHPali89mMa01htUNJ
         MBap2BbkvaqdkGLioyzQFVXTrBD500qzM+J3gJVNk7Vv1kOTv2zyGl4Qqi0Ar/IuZlT3
         7w0e/9eoys1y57wiS2gXvQqcdoAwBLuPKp6AB4VU0xZfs8Md1OWiAoeqVo8CVK2ITK95
         t+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=J4+lZIDd6o5zmH05CFS7Chus/4ckzIXTgk91SRnxUls=;
        b=foP2Z01vh5BnAH+Hp5OB+R4YIugPWpP6kob3kdKS/EsaUa6Kvdk5nGHJilvgeEYTKs
         kFIFox3YIIx+W5ZkCqvaJPUn8h0I31RP0B7x4FfLvZMuIocMIS9JtFnDHN/t29l6bV65
         ZJXRgBQOPLw8lCa8qiqBqQfHhZ3H/ejS0xg5FIGMWycKkVTUNeArsRhuIK31LKb16aXe
         +A+BMXxByWB97z0cTSj087AuEiWnBf57i2woR1ngq1d9yYKrgyXcXkJ26mpmQpRHS0oA
         HHvqLhWKGEokHafVpuAMUh2K/gN7iYTTeLLwEes5D9TqeDZWI3BFlw0HfmUh//I4xPD+
         egyw==
X-Gm-Message-State: AOAM533ie7LS/BP6JQfftXLXdSWXO3wCrTNWcjXSjTRWIWXewvXvREqn
        Pc7xz6c/Fb4WNnXwec9zJgyIu4ebWIO9dFfdbng=
X-Google-Smtp-Source: ABdhPJxiGyyevi/x/S48E/qQOg2S+H4ILpi11ez7OVZ6hwF0rP9lAfUr9XzA8Y1pOZL3sRiAWpW5jLpJ1QRsiRsHH4g=
X-Received: by 2002:a63:a619:: with SMTP id t25mr9755116pge.235.1642201466182;
 Fri, 14 Jan 2022 15:04:26 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk>
In-Reply-To: <87tue8ftrm.fsf@toke.dk>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Fri, 14 Jan 2022 18:04:14 -0500
Message-ID: <CAH8yC8=+7p1i6a+_zq3fL5MqHem34vMDGxY+KGcZbjOg1H9q1Q@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 8:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> [ adding the bpf list - please make sure to include that when sending
>   BPF-related patches, not everyone in BPF land follows netdev ]
>
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>
> > BLAKE2s is faster and more secure. SHA-1 has been broken for a long tim=
e
> > now. This also removes quite a bit of code, and lets us potentially
> > remove sha1 from lib, which would further reduce vmlinux size.
>
> AFAIU, the BPF tag is just used as an opaque (i.e., arbitrary) unique
> identifier for BPF programs, without any guarantees of stability. Which
> means changing it should be fine; at most we'd confuse some operators
> who have memorised the tags of their BPF programs :)
>
> The only other concern I could see would be if it somehow locked us into
> that particular algorithm for other future use cases for computing
> hashes of BPF programs (say, signing if that ends up being the direction
> we go in). But obviously SHA1 would not be a good fit for that anyway,
> so the algorithm choice would have to be part of that discussion in any
> case.
>
> So all in all, I don't see any issues with making this change for BPF.

Somewhat related, if BPF is going to move from SHA to something, then
consider SipHash. Here are the numbers I regularly observe. They
remain relative the same on 64-bit platforms:

    * SHA-1: 4.31 cpb using SSE2
    * BLAKE2s: 4.84 cpb using SSE4.1
    * BLAKE2b: 3.49 cpb using SSE4.1
    * SipHash 2-4: 1.54 cpb using C/C++
    * SipHash 4-8: 2.55 cpb using C/C++

If BPF is Ok with 64-bit tags, then SipHash 2-4 is probably what you
want on the wish list.

Jeff
