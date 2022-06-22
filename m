Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E76554BAE
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356098AbiFVNru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 09:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241493AbiFVNrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 09:47:47 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6E62FE43
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 06:47:42 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id pk21so11261489ejb.2
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 06:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2QZHrrIBVW3T6cCzOrquv5g3s3bcHIbuUCuv4UP/4ic=;
        b=FmNIAbKhrN0tr6L1fI9HtdVfR7DjgkD7iykGsVbbqVbYqmGPYkuYj88aNATFf7XmjN
         Nk65pyBmSuDZEEGv2RAHOm/IqWDB0Fp0VdstYlyMr6ivizNYuBuT5BlBI0kL5DDBrK1P
         HeY63qQi5LEvLajcHynt3VDm2pUUK7Ml7VBG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2QZHrrIBVW3T6cCzOrquv5g3s3bcHIbuUCuv4UP/4ic=;
        b=fXx8BuW7izCkJZ7dvvqQPM1RnBs7jsG/5/RMUTwSjIEYNiB/Z24DS4vIw7Svfw/L+P
         8TDlz1wrtAnxeQA3USluGJ+1VoAwtInbnDr7jWZhZUFwVGEBefadVQA+z68Q66aS1tCj
         n/OlD5D6TZG5tdcH/uk3eimynx2Tg60bZVojh+ZICzlyH9VDPCYNiMXeKf+UHfXJ49Yh
         Z5AY/ePfP4Y3x56ia5p04edF3JXbU0kZaIIFBXRq9SskV0wstO+rsB4qRNTwwTk5JTTZ
         q83fsPpDFaLPs+hfCQw2iGGCsdaEkOPvqigc9IMvA2v7oYzl1qNe9yH157+hDdJ172Tf
         UhoQ==
X-Gm-Message-State: AJIora9urylyS174GTPYIaHJYVGzo30nQwJLbis0vv51exwA2te17RYX
        lKPR0Q8fETirFgrQ54H+Ua0MSxC0cNFazBj8
X-Google-Smtp-Source: AGRyM1tjR9SjZ2lsbSQqUl8NXyUn2zC2csjtv5egxfF2hUjDkEpNk1EAv2Ht4ZN1T8zFVzinB0GQJg==
X-Received: by 2002:a17:906:6d98:b0:715:76eb:9e33 with SMTP id h24-20020a1709066d9800b0071576eb9e33mr3162107ejt.729.1655905660489;
        Wed, 22 Jun 2022 06:47:40 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id cm28-20020a0564020c9c00b0043577da51f1sm9036073edb.81.2022.06.22.06.47.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 06:47:39 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id l2-20020a05600c4f0200b0039c55c50482so11133586wmq.0
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 06:47:38 -0700 (PDT)
X-Received: by 2002:a05:600c:3485:b0:39c:7db5:f0f7 with SMTP id
 a5-20020a05600c348500b0039c7db5f0f7mr4093835wmq.8.1655905658386; Wed, 22 Jun
 2022 06:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <YrLtpixBqWDmZT/V@debian>
In-Reply-To: <YrLtpixBqWDmZT/V@debian>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 22 Jun 2022 08:47:22 -0500
X-Gmail-Original-Message-ID: <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
Message-ID: <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang support")
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_RED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 5:23 AM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> I have recently (since yesterday) started building the mainline kernel
> with clang-14 and I am seeing a build failure with allmodconfig.

Yeah, the clang build has never been allmodconfig-clean, although I
think it's starting to get pretty close.

I build the kernel I actually _use_ with clang, and make sure it's
clean in sane configurations, but my full allmodconfig build I do with
gcc.

Partly because of that "the clang build hasn't quite gotten there yet"
and partly because last I tried it was even slower to build (not a big
issue for my default config, but does matter for the allmodconfig
build, even on my beefy home machine)

I would love for people to start doing allmodconfig builds with clang
too, but it would require some initial work to fix it... Hint, hint.

And in the case of this warning attribute case, the clang error messages are

 (a) verbose

 (b) useless

because they point to where the warning attribute is (I know where it
is), but don't point to where it's actually triggering (ie where it
was actually inlined and called from).

The gcc equivalent of that warning actually says exactly where the
problem is. The clang one is useless, which is probably part of why
people aren't fixing them, because even if they would want to, they
just give up.

Nick, Nathan, any chance of getting better error messages out of
clang? In some cases, they are very good, so it's not like clang does
bad error messages by default. But in this case, the error message
really is *entirely* useless.

             Linus
