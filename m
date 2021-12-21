Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC547C395
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 17:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhLUQOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 11:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbhLUQOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 11:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A7AC061574;
        Tue, 21 Dec 2021 08:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A17C461677;
        Tue, 21 Dec 2021 16:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A031C36AE9;
        Tue, 21 Dec 2021 16:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640103281;
        bh=DCUegUz4qFBNqxU7F0Pr/UOpihyC6+MhD0WLiW8u0uQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PEK4Ai4ZemSH+x5b78S8go//jqsIdGzld9skJw4+CoVu2VoRp6rOz65mNw9TdQexu
         3uDJ4pur51/ci8dkzXUhwjORILopKTXWNcbf/7cQLD2Qr81ro4RMHFeEhjg/zZCgzF
         PVi+Gq7NdFpKbxzvJznXX+OSjSOsac+Zze2yEtJGIvAwLeHF4KqxyCsl1I/BErSxdc
         TU2QkEzEhHbEMTTySf6AGbUKfVMys5mhamVDQxCIR5JB+UDydv2GwnfEIjMU41a8CX
         gm5Eq/XN2guDDEnbtUDNsyXT9ScGAd7Hj60pRjoVetJuw2lcOSkiokvp5TSbKpmY9s
         Vs3jx5Cj+Ldsg==
Received: by mail-wr1-f43.google.com with SMTP id a9so27933322wrr.8;
        Tue, 21 Dec 2021 08:14:40 -0800 (PST)
X-Gm-Message-State: AOAM533yzWGNPHIqHvU+SCdFcrdQrdhxTx/MehSBoSE2OJ9x746lrcpq
        dTijPxMY1qXKq26qL28vQJlK/QhIqwqDilL2LCY=
X-Google-Smtp-Source: ABdhPJzOcgRLgtdcEc68x50V71Z1/jvQ6npLQiCgiRWtFLuMqVaROo1BPwvjc5a4e1jjuNonj0Kkxp9HGbvFSiZv9ZU=
X-Received: by 2002:adf:c450:: with SMTP id a16mr3069705wrg.454.1640103279352;
 Tue, 21 Dec 2021 08:14:39 -0800 (PST)
MIME-Version: 1.0
References: <20211221150611.3692437-1-kuba@kernel.org>
In-Reply-To: <20211221150611.3692437-1-kuba@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 21 Dec 2021 17:14:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHvLyUQdM9U4hkHdBoLHFJJn19-iESRXV6XZv87=F1x8g@mail.gmail.com>
Message-ID: <CAMj1kXHvLyUQdM9U4hkHdBoLHFJJn19-iESRXV6XZv87=F1x8g@mail.gmail.com>
Subject: Re: [PATCH crypto] x86/aesni: don't require alignment of data
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, "# 3.4.x" <stable@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 at 16:06, Jakub Kicinski <kuba@kernel.org> wrote:
>
> x86 AES-NI routines can deal with unaligned data. Crypto context
> (key, iv etc.) have to be aligned but we take care of that separately
> by copying it onto the stack. We were feeding unaligned data into
> crypto routines up until commit 83c83e658863 ("crypto: aesni -
> refactor scatterlist processing") switched to use the full
> skcipher API which uses cra_alignmask to decide data alignment.
>
> This fixes 21% performance regression in kTLS.
>
> Tested by booting with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> (and running thru various kTLS packets).
>
> CC: stable@vger.kernel.org # 5.15+
> Fixes: 83c83e658863 ("crypto: aesni - refactor scatterlist processing")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
> CC: herbert@gondor.apana.org.au
> CC: x86@kernel.org
> CC: ardb@kernel.org
> CC: linux-crypto@vger.kernel.org
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index e09f4672dd38..41901ba9d3a2 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -1107,7 +1107,7 @@ static struct aead_alg aesni_aeads[] = { {
>                 .cra_flags              = CRYPTO_ALG_INTERNAL,
>                 .cra_blocksize          = 1,
>                 .cra_ctxsize            = sizeof(struct aesni_rfc4106_gcm_ctx),
> -               .cra_alignmask          = AESNI_ALIGN - 1,
> +               .cra_alignmask          = 0,
>                 .cra_module             = THIS_MODULE,
>         },
>  }, {
> @@ -1124,7 +1124,7 @@ static struct aead_alg aesni_aeads[] = { {
>                 .cra_flags              = CRYPTO_ALG_INTERNAL,
>                 .cra_blocksize          = 1,
>                 .cra_ctxsize            = sizeof(struct generic_gcmaes_ctx),
> -               .cra_alignmask          = AESNI_ALIGN - 1,
> +               .cra_alignmask          = 0,
>                 .cra_module             = THIS_MODULE,
>         },
>  } };
> --
> 2.31.1
>
