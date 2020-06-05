Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39571EFF89
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgFESA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 14:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgFESAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 14:00:25 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17943206FA;
        Fri,  5 Jun 2020 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591380025;
        bh=nUoGQJJatWp2zZsQPPYM/lEeI2R8ERs7apdKRZESNIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uGwjudMG8Mnv3QwJTyhGKPOlTDjCG18+q8zDsf+ChbCmQPR5qZUaSPBUYkvHyqXL2
         I0cUcqgicbHdSU35lCOYDbeeTvoHcp0CeI7iIbnsTJIn2FSMsMZrrHueL92jQ4gsoC
         udNI+gOlqgp1gEVMRurCBuHj570Q5kLRGsiTSzqs=
Date:   Fri, 5 Jun 2020 11:00:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net v2] esp: select CRYPTO_SEQIV when useful
Message-ID: <20200605180023.GF1373@sol.localdomain>
References: <20200605064748.GA595@gondor.apana.org.au>
 <20200605173931.241085-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605173931.241085-1-ebiggers@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 10:39:31AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> CRYPTO_CTR no longer selects CRYPTO_SEQIV, which breaks IPsec for users
> who need any of the algorithms that use seqiv.  These users now would
> need to explicitly enable CRYPTO_SEQIV.
> 
> There doesn't seem to be a clear rule on what algorithms the IPsec
> options (INET_ESP and INET6_ESP) actually select, as apparently none is
> *always* required.  They currently select just a particular subset,
> along with CRYPTO_ECHAINIV which is the other IV generator template.
> 
> As a compromise between too many and too few selections, select
> CRYPTO_SEQIV if either CRYPTO_CTR or CRYPTO_CHACHA20POLY1305 is enabled.
> These are the algorithms that can use seqiv for IPsec.  (Note: GCM and
> CCM can too, but those both use CTR.)
> 
> Fixes: f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV")
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> v2: added the 'if' condition and updated commit message
> 
>  net/ipv4/Kconfig | 1 +
>  net/ipv6/Kconfig | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index 23ba5045e3d3..6520b30883cf 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -361,6 +361,7 @@ config INET_ESP
>  	select CRYPTO_SHA1
>  	select CRYPTO_DES
>  	select CRYPTO_ECHAINIV
> +	select CRYPTO_SEQIV if CRYPTO_CTR || CRYPTO_CHACHA20POLY1305
>  	---help---
>  	  Support for IPsec ESP.
>  

Oops, this doesn't actually work:

scripts/kconfig/conf  --olddefconfig Kconfig
crypto/Kconfig:1799:error: recursive dependency detected!
crypto/Kconfig:1799:	symbol CRYPTO_DRBG_MENU is selected by CRYPTO_RNG_DEFAULT
crypto/Kconfig:83:	symbol CRYPTO_RNG_DEFAULT is selected by CRYPTO_SEQIV
crypto/Kconfig:330:	symbol CRYPTO_SEQIV is selected by CRYPTO_CTR
crypto/Kconfig:370:	symbol CRYPTO_CTR is selected by CRYPTO_DRBG_CTR
crypto/Kconfig:1819:	symbol CRYPTO_DRBG_CTR depends on CRYPTO_DRBG_MENU
For a resolution refer to Documentation/kbuild/kconfig-language.rst
subsection "Kconfig recursive dependency limitations"


I guess we need to go with v1 (which just had 'select CRYPTO_SEQIV'),
or else make users explicitly select CRYPTO_SEQIV?

- Eric
