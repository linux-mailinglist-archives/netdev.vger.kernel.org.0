Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08061F12D2
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 08:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgFHGXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 02:23:50 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53864 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbgFHGXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 02:23:50 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jiBCA-0001X8-Pj; Mon, 08 Jun 2020 16:23:43 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 Jun 2020 16:23:42 +1000
Date:   Mon, 8 Jun 2020 16:23:42 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net v2] esp: select CRYPTO_SEQIV when useful
Message-ID: <20200608062342.GA21732@gondor.apana.org.au>
References: <20200605064748.GA595@gondor.apana.org.au>
 <20200605173931.241085-1-ebiggers@kernel.org>
 <20200605180023.GF1373@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605180023.GF1373@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 11:00:23AM -0700, Eric Biggers wrote:
>
> Oops, this doesn't actually work:
> 
> scripts/kconfig/conf  --olddefconfig Kconfig
> crypto/Kconfig:1799:error: recursive dependency detected!
> crypto/Kconfig:1799:	symbol CRYPTO_DRBG_MENU is selected by CRYPTO_RNG_DEFAULT
> crypto/Kconfig:83:	symbol CRYPTO_RNG_DEFAULT is selected by CRYPTO_SEQIV
> crypto/Kconfig:330:	symbol CRYPTO_SEQIV is selected by CRYPTO_CTR
> crypto/Kconfig:370:	symbol CRYPTO_CTR is selected by CRYPTO_DRBG_CTR
> crypto/Kconfig:1819:	symbol CRYPTO_DRBG_CTR depends on CRYPTO_DRBG_MENU
> For a resolution refer to Documentation/kbuild/kconfig-language.rst
> subsection "Kconfig recursive dependency limitations"
> 
> I guess we need to go with v1 (which just had 'select CRYPTO_SEQIV'),
> or else make users explicitly select CRYPTO_SEQIV?

OK, let's just go with the unconditional select on SEQIV since
Steffen recommended RFC8221 which lists GCM and CBC as MUST and
GCM requires SEQIV to work.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
