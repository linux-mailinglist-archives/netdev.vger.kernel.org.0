Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C55A48D02C
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 02:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiAMBd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 20:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiAMBd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 20:33:56 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9CCC06173F;
        Wed, 12 Jan 2022 17:33:56 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n11so5289152plf.4;
        Wed, 12 Jan 2022 17:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m18no3eU9YHeOBJ70PLazPrqlrGWJoUY+UtRV0RJfnE=;
        b=UmuUGXve9r7RpYvZiev379MA7uABBPIy9NIzLlVQhCGARCNeA/XjbLXQelwd22Mej0
         h5Iz1VIfFDIDHao2yWLxgdxlqhcWkTX26NtLyVoTbJszoXGMfwcedOCg8vcf3ZbCKDbA
         NYEOMU3JWY3nuGgrPhMOfyQs1k3NewqmLeKJtNJIsJsd91tUMyU4g9PsuIkNxSH6JmBC
         NDrtMv69cUP9EDabJI/kJZF4z4oXMfqsKhiLVDPl2rjwBU9Jc9+wXx7vcvehSkYXqBeq
         HDS5kFfAXxOTFj494Qi1piZ4QZ0/9cfRHutIueLlMtDLAg5jHot2s3D8b2hTsNDaYKpc
         s3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m18no3eU9YHeOBJ70PLazPrqlrGWJoUY+UtRV0RJfnE=;
        b=VVTEBGHRreeOmId70EU+TpmTEdR1lLZhHxcU8rZu4YwUDSNyRgtijiu+yXca7fO3yH
         wnCFz9b3LF5NTtPaN+fUP+Pxt8iJsjd/OTgtbK4Wx6F+OKCohdF0Qkeoo2og/M5iNBoH
         brUu2J77GsP79bN5mOIHqP8hNEl3EUV91jWo17SnqScVsnURrOQO/FqDsuCxXyrgh3/p
         8xgTcPj3T+g3pAXfFRlP1YkonXC7IFcKegf3ExgtG2l5pSAX/4YjaIm5Mh14y5yidJNL
         aUh7ejj9AoUzgFwytmxHzBIQ+EAbSMtCk3+bo+/+NZFuWQ7uW1F8080Kl1En5TGBDraU
         aKDA==
X-Gm-Message-State: AOAM5335Jm4Wnz5JU7TzJ7F4dWPVMO9dWnomlBMdzY1pDQeJr1kEd/TK
        aKqVwuyk43mFKsq+Hfo1FXZ4lbVbNcoDAwefO1g=
X-Google-Smtp-Source: ABdhPJz4qeYIqi1ZeoHta49vEZlTq7oCkXYJDmz+FrBq+qxv0Qi2VWJg4urS6VyhZlHFR5eZ9MN/iySryZKlDcCLMdE=
X-Received: by 2002:a63:be49:: with SMTP id g9mr1967928pgo.375.1642037635993;
 Wed, 12 Jan 2022 17:33:55 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk>
In-Reply-To: <87tue8ftrm.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Jan 2022 17:33:44 -0800
Message-ID: <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 5:14 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
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

Nack.
It's part of api. We cannot change it.
