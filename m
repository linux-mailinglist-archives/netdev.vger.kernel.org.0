Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0716A48CF1F
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 00:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbiALXcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 18:32:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38234 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiALXb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 18:31:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4165B82188;
        Wed, 12 Jan 2022 23:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF377C36AF2;
        Wed, 12 Jan 2022 23:31:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TfsWPvgX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642030311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hstk73wuIKZWiikWlym2h0bIC3qGMXsXWymKJtQh5ys=;
        b=TfsWPvgXekG/1IVjr0hbJSZ9+mLRmpbL5U4Eq5MjE6/kba79M6pIMbxIGKKGDgv+Fejvya
        lfNJJqkjkmxJF2zUmC1gjt9u4ZNPb03bc2K4K3oMolN6Afn8kHPhERaS36Mo55OKhZaDbC
        SVR4F0lYxwTH+iea5Wziem4LXnxE0Ag=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 98d0b2c9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 23:31:51 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id g81so10029968ybg.10;
        Wed, 12 Jan 2022 15:31:50 -0800 (PST)
X-Gm-Message-State: AOAM530uzYfmi2peL82YFOSG8xY1Xco12LXAEhmpO+RXbxM3c4TrVSVX
        xcSzhkr9wCVapmmnvKnos4oLPlpMxmXAUdRG7So=
X-Google-Smtp-Source: ABdhPJxqG3O8kUM3OYzd+VIHfE/yG6UzHPq2cANRI+RCJfa44HWXEDoNmTxlpM0TKv/14nigRVPki5q61d4r/6RbYj0=
X-Received: by 2002:a25:a0c4:: with SMTP id i4mr2845644ybm.457.1642030309048;
 Wed, 12 Jan 2022 15:31:49 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:209:b0:11c:1b85:d007 with HTTP; Wed, 12 Jan 2022
 15:31:48 -0800 (PST)
In-Reply-To: <87r19cftbr.fsf@toke.dk>
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
 <87r19cftbr.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 13 Jan 2022 00:31:48 +0100
X-Gmail-Original-Message-ID: <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
Message-ID: <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org, Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        hideaki.yoshifuji@miraclelinux.com,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On 1/13/22, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> However, if we make this change, systems setting a stable_secret and
> using addr_gen_mode 2 or 3 will come up with a completely different
> address after a kernel upgrade. Which would be bad for any operator
> expecting to be able to find their machine again after a reboot,
> especially if it is accessed remotely.
>
> I haven't ever used this feature myself, though, or seen it in use. So I
> don't know if this is purely a theoretical concern, or if the
> stable_address feature is actually used in this way in practice. If it
> is, I guess the switch would have to be opt-in, which kinda defeats the
> purpose, no (i.e., we'd have to keep the SHA1 code around

I'm not even so sure that's true. That was my worry at first, but
actually, looking at this more closely, DAD means that the address can
be changed anyway - a byte counter is hashed in - so there's no
gurantee there.

There's also the other aspect that open coding sha1_transform like
this and prepending it with the secret (rather than a better
construction) isn't so great... Take a look at the latest version of
this in my branch to see a really nice simplification and security
improvement:

https://git.zx2c4.com/linux-dev/log/?h=3Dremove-sha1

Jason
