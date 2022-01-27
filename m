Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755B449E3A9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241893AbiA0NjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242230AbiA0Nh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 08:37:58 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ED7C0613EE;
        Thu, 27 Jan 2022 05:34:44 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id bg19-20020a05600c3c9300b0034565e837b6so3316120wmb.1;
        Thu, 27 Jan 2022 05:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PtD0FgMryNIEfo1jRPVV0cUNzb19Sn8D3fM6blA12z8=;
        b=mJEfK4o/cPw8XO1sAK5M7gsOLWGX80WauflsKooGb7ZFVVa+s4u32wNhJ0tg/klSo4
         sqJu1MumMXoK58OinVz9HOj5EKN66PedW5tRPhyn3WrhM0pqnjndsRUMVPXjrP5e557S
         xVcvoaedKwnKP5WnRXtjU736LRLI3UunPwNQMWWqvTlJPC7ogCr4tGM6zIkpS8CKpwc4
         TtALbxfc2E2gE6y1ckb/C1QjWq1aoq06jUzOJFcb7L4S64vR6wRZRNvxTAP+TT79um4z
         fsE/6bqfMz3U06V1OWVPgEU+NWIX8+d97nkTtWVZhWpcJNPUKwLtHfMwkLdcAyfhMoK8
         YYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PtD0FgMryNIEfo1jRPVV0cUNzb19Sn8D3fM6blA12z8=;
        b=IOi4dXdhKguuDFhNfm7ePwvsr88VT6nUFR7zeeHXcGUYzsiARaqDfi34eHDmJpWMf+
         Rd7qfR9UJXclEZv+TkYD8iWqLrjrDYkUmdmaY7jQsvT7Ks7vgcoHrfZ4YQJsq2ofSO5B
         zy8NhFq8dtwgX0dG/xJVpyxj6aL1mKSkt8kHXC5oo//Qbn0Ldg3eouLZfOPox7H8Nhwm
         Lvt6qKTWHeVmt52u5BJHBR71mdnjY7/q15cgLSHGAr5twz5w4GEIGwE6aoSJ5S0h+N7r
         GsA5ys2fL6/t1S9t/AsFRDDxG3nY1CtOyNQFbHbhURcVvyuiz457WKHyS75qBvVnLEA0
         paCA==
X-Gm-Message-State: AOAM5335JAxXgoZTukNkUbRjc7uI5Ls7EHVP2G8Oinb33ZOY/tAX/L8j
        y5G1nnhTxmsshaiOgLmD1hiYn2/vrxE=
X-Google-Smtp-Source: ABdhPJwpccnsbgjKRndlWasEVTPIjTprM6ThyfKPt7POLIcMIUxxWzIt7TDhKx/s2vN+i8nPotXfHQ==
X-Received: by 2002:a05:600c:1e8b:: with SMTP id be11mr11928824wmb.96.1643290483143;
        Thu, 27 Jan 2022 05:34:43 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id e13sm2572953wrq.35.2022.01.27.05.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 05:34:42 -0800 (PST)
Date:   Thu, 27 Jan 2022 14:34:41 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: authenc - Fix sleep in atomic context in
 decrypt_tail
Message-ID: <YfKfcRCOgCzYNLRG@Red>
References: <Yd1SIHUNdLIvKhzz@Red>
 <YeD4rt1OVnEMBr+A@gondor.apana.org.au>
 <YeD6vt47+pAl0SxG@gondor.apana.org.au>
 <YeEiWmkyNwfgQgmn@Red>
 <YeZx1aVL0HnT9tCB@Red>
 <Yee2oKxPSLaYY31N@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yee2oKxPSLaYY31N@gondor.apana.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, Jan 19, 2022 at 05:58:40PM +1100, Herbert Xu a écrit :
> On Tue, Jan 18, 2022 at 08:52:53AM +0100, Corentin Labbe wrote:
> >
> > With my patch, I got:
> > [   38.515668] BUG: sleeping function called from invalid context at crypto/skcipher.c:482
> > [   38.523708] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 84, name: 1c15000.crypto-
> > [   38.532176] preempt_count: 200, expected: 0
> > [   38.536381] CPU: 6 PID: 84 Comm: 1c15000.crypto- Not tainted 5.16.0-next-20220115-00124-g13473e8fac33-dirty #116
> > [   38.546551] Hardware name: Allwinner A83t board
> > [   38.551100]  unwind_backtrace from show_stack+0x10/0x14
> > [   38.556358]  show_stack from dump_stack_lvl+0x40/0x4c
> > [   38.561428]  dump_stack_lvl from __might_resched+0x118/0x154
> > [   38.567107]  __might_resched from skcipher_walk_virt+0xe8/0xec
> > [   38.572955]  skcipher_walk_virt from crypto_cbc_decrypt+0x2c/0x170
> > [   38.579147]  crypto_cbc_decrypt from crypto_skcipher_decrypt+0x38/0x5c
> > [   38.585680]  crypto_skcipher_decrypt from authenc_verify_ahash_done+0x18/0x34
> > [   38.592825]  authenc_verify_ahash_done from crypto_finalize_request+0x6c/0xe4
> > [   38.599974]  crypto_finalize_request from sun8i_ss_hash_run+0x73c/0xb98
> > [   38.606602]  sun8i_ss_hash_run from crypto_pump_work+0x1a8/0x330
> > [   38.612616]  crypto_pump_work from kthread_worker_fn+0xa8/0x1c4
> > [   38.618550]  kthread_worker_fn from kthread+0xf0/0x110
> > [   38.623701]  kthread from ret_from_fork+0x14/0x2c
> > [   38.628414] Exception stack(0xc2247fb0 to 0xc2247ff8)
> > [   38.633468] 7fa0:                                     00000000 00000000 00000000 00000000
> > [   38.641640] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > [   38.649809] 7fe0:i 00000000 00000000 00000000 00000000 00000013 00000000
> > 
> > This is when testing hmac(sha1) on my crypto driver sun8i-ss and crypto testing authenc(hmac-sha1-sun8i-ss,cbc(aes-generic)).
> > 
> > Do you have any idea to better fix my issue ?
> 
> This backtrace is caused by a bug in authenc:
> 
> ---8<---
> The function crypto_authenc_decrypt_tail discards its flags
> argument and always relies on the flags from the original request
> when starting its sub-request.
> 
> This is clearly wrong as it may cause the SLEEPABLE flag to be
> set when it shouldn't.
> 
> Fixes: 92d95ba91772 ("crypto: authenc - Convert to new AEAD interface")
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/authenc.c b/crypto/authenc.c
> index 670bf1a01d00..17f674a7cdff 100644
> --- a/crypto/authenc.c
> +++ b/crypto/authenc.c
> @@ -253,7 +253,7 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
>  		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
>  
>  	skcipher_request_set_tfm(skreq, ctx->enc);
> -	skcipher_request_set_callback(skreq, aead_request_flags(req),
> +	skcipher_request_set_callback(skreq, flags,
>  				      req->base.complete, req->base.data);
>  	skcipher_request_set_crypt(skreq, src, dst,
>  				   req->cryptlen - authsize, req->iv);
> -- 

This fixes my issue.

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
