Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0AA399EE3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhFCK0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:26:11 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:39792 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhFCK0L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 06:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622715862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GyH1gx7L7M3lribcnda2WYET6S9/o5F6OxhuQOeFGSI=;
        b=RwCicTeA4FkqDwhVszPp/M7WDMtv8Wn+vo7lT/eF0EH4dPhghUP59K+6gdhwoes+Ln28c3
        N36t7Z6rwrFb4OREmLfdht4twh+o5WS2NMAe1RtjBXlCsPDC9xTWOqHJE0bJ/1EoRftzaN
        n6FKWJ/9ACKJSIradpYQg4oQCrwfO3w=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 13f8325f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 3 Jun 2021 10:24:22 +0000 (UTC)
Received: by mail-yb1-f170.google.com with SMTP id e10so8110554ybb.7;
        Thu, 03 Jun 2021 03:24:22 -0700 (PDT)
X-Gm-Message-State: AOAM530aDyPqYlvOT7lLXIfC7emmXvf0ZbM5wGSmHQBoyy5Vt5pI61/t
        6GEhRzvFION3xs++Kjv0PZNOF63XP6hoPtNTgnw=
X-Google-Smtp-Source: ABdhPJzENh/NXNtOHfgoNtZEqo49ueK1GGr1R9Q3CD2YaGJkF973Ns5YPi5eJh/bpn0c9h5TsLnY6IcynydHv2vCeww=
X-Received: by 2002:a5b:5c6:: with SMTP id w6mr52152482ybp.279.1622715861520;
 Thu, 03 Jun 2021 03:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210603055341.24473-1-liuhangbin@gmail.com>
In-Reply-To: <20210603055341.24473-1-liuhangbin@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 3 Jun 2021 12:24:10 +0200
X-Gmail-Original-Message-ID: <CAHmME9qXTYVLenPBfq2xpfq=DSJAsdUwSqP4Fzc=0YP6kW+QsQ@mail.gmail.com>
Message-ID: <CAHmME9qXTYVLenPBfq2xpfq=DSJAsdUwSqP4Fzc=0YP6kW+QsQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/curve25519 - fix cpu feature checking logic
 in mod_exit
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 7:53 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> In curve25519_mod_init() the curve25519_alg will be registered only when
> (X86_FEATURE_BMI2 && X86_FEATURE_ADX). But in curve25519_mod_exit()
> it still checks (X86_FEATURE_BMI2 || X86_FEATURE_ADX) when do crypto
> unregister. This will trigger a BUG_ON in crypto_unregister_alg() as
> alg->cra_refcnt is 0 if the cpu only supports one of X86_FEATURE_BMI2
> and X86_FEATURE_ADX.
>
> Fixes: 07b586fe0662 ("crypto: x86/curve25519 - replace with formally verified implementation")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  arch/x86/crypto/curve25519-x86_64.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
> index 6706b6cb1d0f..38caf61cd5b7 100644
> --- a/arch/x86/crypto/curve25519-x86_64.c
> +++ b/arch/x86/crypto/curve25519-x86_64.c
> @@ -1500,7 +1500,7 @@ static int __init curve25519_mod_init(void)
>  static void __exit curve25519_mod_exit(void)
>  {
>         if (IS_REACHABLE(CONFIG_CRYPTO_KPP) &&
> -           (boot_cpu_has(X86_FEATURE_BMI2) || boot_cpu_has(X86_FEATURE_ADX)))
> +           static_branch_likely(&curve25519_use_bmi2_adx))
>                 crypto_unregister_kpp(&curve25519_alg);
>  }

Looks like the error is actually that the `||` should be a `&&`. But
if you'd like to branch on that static key instead, that's fine.

Cc: stable@vger.kernel.org
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
