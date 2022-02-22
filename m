Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35054BF58E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiBVKOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiBVKOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:14:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A46C13A1CC;
        Tue, 22 Feb 2022 02:13:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A995DCE13AA;
        Tue, 22 Feb 2022 10:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D8BC340E8;
        Tue, 22 Feb 2022 10:13:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FyK4kZ8b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645524828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kpDNdh5isxkhK3fXHymqHlY32XR18j5hKDN11bOdsv8=;
        b=FyK4kZ8bGV4PEH+8Gf6cTC5RQDFt8yAOFU6Hae9J9xnblTTAd66xo/xC74DbOFAF2r9/2v
        Z88dlW+7z9e56u4Wjm3Q2UNiD8V1aFXHFaCuUBjw+KGmhfKWCE8fGsBQ4V/+mLApIV7Aoo
        hkXWpA3t5/rRmIeVtg7koKdXcJJo0E8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d3cb9608 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 22 Feb 2022 10:13:48 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id j12so39943948ybh.8;
        Tue, 22 Feb 2022 02:13:47 -0800 (PST)
X-Gm-Message-State: AOAM532+X2f37tTKzZwMi7X1/fJ+fmQcRAeOOlnM9L75nrVuhjpskoGQ
        DL7lomPItxxnMRQFOP2elb/T6RI+somjBLQKecg=
X-Google-Smtp-Source: ABdhPJwWpiFGMVhm1YI6hSWqRxcYa0Kq8ueTB8UmBj9lC6mB8/xFLLPBtY0rg6XsLGvngvkkWASPOukLydtudnPxKNY=
X-Received: by 2002:a05:6902:693:b0:613:7f4f:2e63 with SMTP id
 i19-20020a056902069300b006137f4f2e63mr21470625ybt.271.1645524826098; Tue, 22
 Feb 2022 02:13:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:71a8:b0:167:24f9:2d40 with HTTP; Tue, 22 Feb 2022
 02:13:45 -0800 (PST)
In-Reply-To: <CAMj1kXFLx1xGexd5P9xnB-2=cFn1DScCa8U6a7AyRAxQPLCWLw@mail.gmail.com>
References: <20220216113323.53332-1-Jason@zx2c4.com> <164543897830.26423.13654986323403498456.kvalo@kernel.org>
 <CAMj1kXFLx1xGexd5P9xnB-2=cFn1DScCa8U6a7AyRAxQPLCWLw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 22 Feb 2022 11:13:45 +0100
X-Gmail-Original-Message-ID: <CAHmME9rOWOki8fpMC=wNr=4En8iN4DhWm8XVOquprnUUh62yqA@mail.gmail.com>
Message-ID: <CAHmME9rOWOki8fpMC=wNr=4En8iN4DhWm8XVOquprnUUh62yqA@mail.gmail.com>
Subject: Re: [PATCH v3] ath9k: use hw_random API instead of directly dumping
 into random.c
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>, miaoqing@codeaurora.org,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/22, Ard Biesheuvel <ardb@kernel.org> wrote:
> On Mon, 21 Feb 2022 at 11:57, Kalle Valo <kvalo@kernel.org> wrote:
>>
>> "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
>>
>> > Hardware random number generators are supposed to use the hw_random
>> > framework. This commit turns ath9k's kthread-based design into a prope=
r
>> > hw_random driver.
>> >
>> > Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > Cc: Kalle Valo <kvalo@kernel.org>
>> > Cc: Rui Salvaterra <rsalvaterra@gmail.com>
>> > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
>> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> > Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
>> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>> > Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
>>
>> Patch applied to ath-next branch of ath.git, thanks.
>>
>> fcd09c90c3c5 ath9k: use hw_random API instead of directly dumping into
>> random.c
>>
>
> With this patch, it seems we end up registering the hw_rng every time
> the link goes up, and unregister it again when the link goes down,
> right?
>
> Wouldn't it be better to split off this driver from the 802.11 link
> state handling?
>

I really have no idea how this thing works, and I tried hard to change
as little as possible in converting it to the API. You may want to
send some follow-up patches if you have hardware to experiment with.
One consideration does leap out, which is that in my experience wifi
cards use a lot less power when they're set "down", as though a decent
amount of hardware is being switched off. I think this ath9k rng call
might be using the ADC to gather samples of ether from somewhere. I
imagine this gets shutdown too as part of that dame circuitry.
