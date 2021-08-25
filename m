Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D733F79C8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbhHYQFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhHYQFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 12:05:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9BBC61423;
        Wed, 25 Aug 2021 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629907498;
        bh=DaGsaCXXMEaJVHJDUEzQa5k0dv8atCixW2ZNnqxcsWE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hg0JbfCUqVGPE1Utc3XvHT2ZzmwhuzauXDTMQT2bg0Ip3+FLII4GI6ZWUjPDnjPfF
         M7RzD76tXFraOz1XVubXfFD1foCgTS2rmLMFAdjzJTeAchBuGiJ8DNuzxpjb9Oyuw9
         K73UgSv8J9dUObTEx+7S6T/nJ6t5O20iLzjbbQOlbcUSL+GIQ6qpjm6dz0or7qUrK5
         CiA+mlBO4yxQywjuQ9f1Y6FKeZeMu87Sbfk1kqUHlxVt4cxxxu9anecBEv+bQdi6Hx
         klPqNTADkiRAwFhy2Iap/IILPm1FVl01v57ITdwVID37P++NR1Frw+phAuEFjyihaq
         ao1/IxVW64apw==
Received: by mail-ot1-f41.google.com with SMTP id o16-20020a9d2210000000b0051b1e56c98fso40671568ota.8;
        Wed, 25 Aug 2021 09:04:57 -0700 (PDT)
X-Gm-Message-State: AOAM530ym4mNxDQSzBmX8FwHo2B+a1GjfxQ6XPn1Z93+psNSaCSaJEca
        uAXiyrzPM/+3i3ZI+zy8yeaFgSy2KEWDscBBzgY=
X-Google-Smtp-Source: ABdhPJzmlzK7LAvef8jbDy6p7UNkjEVB1dgSKHHKPZQG94aNN8fvddSxhazPzywPle3BYA5ZzcpcGjEz4CbQKhGhtII=
X-Received: by 2002:a9d:5c2:: with SMTP id 60mr36449769otd.77.1629907497260;
 Wed, 25 Aug 2021 09:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629840814.git.cdleonard@gmail.com> <abb720b34b9eef1cc52ef68017334e27a2af83c6.1629840814.git.cdleonard@gmail.com>
 <30f73293-ea03-d18f-d923-0cf499d4b208@gmail.com> <20210825080817.GA19149@gondor.apana.org.au>
In-Reply-To: <20210825080817.GA19149@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 25 Aug 2021 18:04:46 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE_sDZJjmkoqHcLz=9fDqLPBNbyfH4zxN2s2RdgKO=eSw@mail.gmail.com>
Message-ID: <CAMj1kXE_sDZJjmkoqHcLz=9fDqLPBNbyfH4zxN2s2RdgKO=eSw@mail.gmail.com>
Subject: Re: [RFCv3 05/15] tcp: authopt: Add crypto initialization
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 at 10:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Aug 24, 2021 at 04:34:58PM -0700, Eric Dumazet wrote:
> >
> > On 8/24/21 2:34 PM, Leonard Crestez wrote:
> > > The crypto_shash API is used in order to compute packet signatures. The
> > > API comes with several unfortunate limitations:
> > >
> > > 1) Allocating a crypto_shash can sleep and must be done in user context.
> > > 2) Packet signatures must be computed in softirq context
> > > 3) Packet signatures use dynamic "traffic keys" which require exclusive
> > > access to crypto_shash for crypto_setkey.
> > >
> > > The solution is to allocate one crypto_shash for each possible cpu for
> > > each algorithm at setsockopt time. The per-cpu tfm is then borrowed from
> > > softirq context, signatures are computed and the tfm is returned.
> > >
> >
> > I could not see the per-cpu stuff that you mention in the changelog.
>
> Perhaps it's time we moved the key information from the tfm into
> the request structure for hashes? Or at least provide a way for
> the key to be in the request structure in addition to the tfm as
> the tfm model still works for IPsec.  Ard/Eric, what do you think
> about that?
>

I think it makes sense for a shash desc to have the ability to carry a
key, which will be used instead of the TFM key, but this seems like
quite a lot of work, given that all implementations will need to be
updated. Also, setkey() can currently sleep, so we need to check
whether the existing key manipulation code can actually execute during
init/update/final if sleeping is not permitted.
