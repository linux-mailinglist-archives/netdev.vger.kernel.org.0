Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5DA462E8
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfFNPea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:34:30 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:44202 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfFNPe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:34:29 -0400
Received: by mail-yb1-f196.google.com with SMTP id x187so1227522ybc.11
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 08:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZvSLdb4tGoj1KerVcujZWEcT0dZuhjXYXXie7nT7mXw=;
        b=nxrt4giWUlhE9biCVR+Nf7l0dQrFKvxLWDlX56RbVNxUEL0bUAFHio4l+uzl0nCxh7
         xXzwrZb2/VMVmB+aSmN56g905HvDn3pCUAGYNxE7lgaqutKZ1nzEtyOuvhGIdaUqZWnO
         iwxssJBIDgARes03cNAnQxvq0Dawjb1fSsJgBu8clFk87sKOVkvglbqQV3ArKpwt6YEY
         U0yhmXm8J5eHwfiEs6Vzf64EyDO/hlefYNr8XiDq9Xwgo4Bt8mHGoKc5wR3Umn5k4VRm
         PysrCqMQJpRReJvso+/R9WYMkI5EyDmBVUwyI4P9kGBArUktyJcbMOmfUlNvfdkoZDtt
         cflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZvSLdb4tGoj1KerVcujZWEcT0dZuhjXYXXie7nT7mXw=;
        b=hEKCODjXBVT6W3C1E0xl6VcFCfPNVDmo4quHft9QdtH+GLcTJVEgbqPxwsiWP8MK1l
         vXVbAUiV0tEXiSnrFriUjrysoWLD6bEuesCB71ksEYQCaTfihRTyiXKGygtNbLjscRlD
         4lf572NchxXAk6qYs3msZ5bA5cH6fq43Dr6amls8QbwEt4j1cFLtREh5VNWrEDFf5gSl
         JDdXcGpsVCjRscZuf9p8ijrXBRYsTNtzsKf+InmjolMJ4U8IZEbg05rNZZtl/2AhE66R
         o4slFIIJZhSPhwMe2+Zanh+oym2QB8kDjdn5VKJw2DNQ90flu4PyvjHB2lr6sWwFS5gY
         hroA==
X-Gm-Message-State: APjAAAUnJj5LjI6SXQn+j/yIdUr6rP5pc+BehdAjaOnS4YaN0PgnPAtt
        /tQxPFFQcvcyvSZH+o4sT1lpm7Fbe6H+Cz8JzlgduQ==
X-Google-Smtp-Source: APXvYqxJrrGfUL+aUSndZe9HBl/gZBDc+JU5kN+yx29GOggyBQLueAHuwXlwxFosnw1LNNcCP2ngQVFfaoX1rv+mQ8E=
X-Received: by 2002:a25:55d7:: with SMTP id j206mr50996255ybb.234.1560526468360;
 Fri, 14 Jun 2019 08:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190614140122.20934-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190614140122.20934-1-ard.biesheuvel@linaro.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 14 Jun 2019 08:34:16 -0700
Message-ID: <CANn89iKP2fQ6Tc0jBW_WdLq3kYQx7NsdVDB5S3y453T+6yp86g@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv4: move tcp_fastopen server side code to
 SipHash library
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, ebiggers@kernel.org,
        David Miller <davem@davemloft.net>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 7:01 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Using a bare block cipher in non-crypto code is almost always a bad idea,
> not only for security reasons (and we've seen some examples of this in
> the kernel in the past), but also for performance reasons.
>
> In the TCP fastopen case, we call into the bare AES block cipher one or
> two times (depending on whether the connection is IPv4 or IPv6). On most
> systems, this results in a call chain such as
>
>   crypto_cipher_encrypt_one(ctx, dst, src)
>     crypto_cipher_crt(tfm)->cit_encrypt_one(crypto_cipher_tfm(tfm), ...);
>       aesni_encrypt
>         kernel_fpu_begin();
>         aesni_enc(ctx, dst, src); // asm routine
>         kernel_fpu_end();
>
> It is highly unlikely that the use of special AES instructions has a
> benefit in this case, especially since we are doing the above twice
> for IPv6 connections, instead of using a transform which can process
> the entire input in one go.
>
> We could switch to the cbcmac(aes) shash, which would at least get
> rid of the duplicated overhead in *some* cases (i.e., today, only
> arm64 has an accelerated implementation of cbcmac(aes), while x86 will
> end up using the generic cbcmac template wrapping the AES-NI cipher,
> which basically ends up doing exactly the above). However, in the given
> context, it makes more sense to use a light-weight MAC algorithm that
> is more suitable for the purpose at hand, such as SipHash.
>
> Since the output size of SipHash already matches our chosen value for
> TCP_FASTOPEN_COOKIE_SIZE, and given that it accepts arbitrary input
> sizes, this greatly simplifies the code as well.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

While the patch looks fine (I yet have to run our tests with it), it
might cause some deployment issues
for server farms.

They usually share a common fastopen key, so that clients can reuse
the same token for different sessions.

Changing some servers in the pool will lead to inconsistencies.

Probably not a too big deal, but worth mentioning.
