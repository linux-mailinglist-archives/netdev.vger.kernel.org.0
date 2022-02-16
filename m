Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7274B8613
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 11:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiBPKnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 05:43:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBPKng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 05:43:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7177326835F;
        Wed, 16 Feb 2022 02:43:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 204F1B81E74;
        Wed, 16 Feb 2022 10:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEEEC004E1;
        Wed, 16 Feb 2022 10:43:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LN+U314q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645008198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FLVrjfhT3W8aNO8W4YUK8UwxqHmr1OB3Xs9XyYu/LAw=;
        b=LN+U314qz5ae0xe+2oW32YGWXiptKFKcPzAFi//V42h1bKx4w3Od+Qez3w4SHdbajhEqg7
        fA7pD6+VRD3CLJ1QoFxpQMIONiUORBqmEbZIIllpkqbQGU48FJSVea36EGYCk4QXxqEdbR
        GBtBGG+qjJP5+m3myWISxpoIHMpXJIs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9bc629c6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 16 Feb 2022 10:43:17 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id v63so4661542ybv.10;
        Wed, 16 Feb 2022 02:43:16 -0800 (PST)
X-Gm-Message-State: AOAM530v+4nRHutthXlLu56kXv2kKOek5/ZWfQl28GDX84GSd8bU4Bd8
        PLmZ+U7/cb0NzoRZr1zj+vgRURyVPpX1mkwN3vw=
X-Google-Smtp-Source: ABdhPJxiaSHJ3i2RRcIsj07+mvucZb540gljBceIzpbXww7fLhg+Lg6D8LmDRmq5NyIV/ooc3fooNxW+9sq/0Bf+KkU=
X-Received: by 2002:a81:7d04:0:b0:2d0:d0e2:126f with SMTP id
 y4-20020a817d04000000b002d0d0e2126fmr1714487ywc.485.1645008195447; Wed, 16
 Feb 2022 02:43:15 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
 <20220216000230.22625-1-Jason@zx2c4.com> <5c23585b-7865-54fb-3835-12e58a7aee46@gmail.com>
In-Reply-To: <5c23585b-7865-54fb-3835-12e58a7aee46@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 16 Feb 2022 11:43:04 +0100
X-Gmail-Original-Message-ID: <CAHmME9rkDXbeNbe1uehoVONioy=pa8oBtJEW22Afbp=86A9SUQ@mail.gmail.com>
Message-ID: <CAHmME9rkDXbeNbe1uehoVONioy=pa8oBtJEW22Afbp=86A9SUQ@mail.gmail.com>
Subject: Re: [PATCH v2] ath9k: use hw_random API instead of directly dumping
 into random.c
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     miaoqing@codeaurora.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Feb 16, 2022 at 4:13 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> You will have to give this instance an unique name because there can be
> multiple ath9k adapters registered in a given system (like Wi-Fi
> routers), and one of the first thing hwrng_register() does is ensure
> that there is not an existing rng with the same name.
>
> Maybe using a combination of ath9k + dev_name() ought to be unique enough?

Good point. Will do. dev_name() probably won't cut it because of
namespaces, but I can always just attach a counter. Will do that for
v3.

Jason
