Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60617476CB
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 22:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfFPUrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 16:47:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPUrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 16:47:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5B627151C2854;
        Sun, 16 Jun 2019 13:47:06 -0700 (PDT)
Date:   Sun, 16 Jun 2019 13:47:05 -0700 (PDT)
Message-Id: <20190616.134705.1682820035874057137.davem@davemloft.net>
To:     ard.biesheuvel@linaro.org
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, ebiggers@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jbaron@akamai.com, cpaasch@apple.com, David.Laight@aculab.com
Subject: Re: [PATCH v2] net: ipv4: move tcp_fastopen server side code to
 SipHash library
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614140122.20934-1-ard.biesheuvel@linaro.org>
References: <20190614140122.20934-1-ard.biesheuvel@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 13:47:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 14 Jun 2019 16:01:22 +0200

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

Please add some text to the commit message explaining the potential
partial deployment problems Eric mentioned.

Thank you.
