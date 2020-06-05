Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07701EF1A4
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 08:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgFEGrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 02:47:55 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40784 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgFEGrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 02:47:55 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jh68q-0007J7-Iq; Fri, 05 Jun 2020 16:47:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2020 16:47:48 +1000
Date:   Fri, 5 Jun 2020 16:47:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net] esp: select CRYPTO_SEQIV
Message-ID: <20200605064748.GA595@gondor.apana.org.au>
References: <20200604192322.22142-1-ebiggers@kernel.org>
 <20200605002858.GB31846@gondor.apana.org.au>
 <20200605002956.GA31947@gondor.apana.org.au>
 <20200605050910.GS2667@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605050910.GS2667@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 10:09:10PM -0700, Eric Biggers wrote:
>
> There's also a case where "seqiv" is used without counter mode:
> 
> net/xfrm/xfrm_algo.c:
> 
> {
>         .name = "rfc7539esp(chacha20,poly1305)",

So

	select CRYPTO_SEQIV if CRYPTO_CTR || CRYPTO_CHACHA20POLY1305

and if the list gets too long we could create another symbol that is
selected by the algorithms, say CRYPTO_SEQIV_ESP which could then
be used as the condition:

	config CRYPTO_SEQIV_ESP
		bool

	config CRYPTO_CTR
		select CRYPTO_SEQIV_ESP

	config INET_ESP
		select CRYPTO_SEQIV if CRYPTO_SEQIV_ESP

> FWIW, we make CONFIG_FS_ENCRYPTION select only the algorithms that we consider
> the "default", and any "non-default" algorithms need to be explicitly enabled.
> 
> Is something similar going on here with INET_ESP and INET_ESP6?  Should "seqiv"
> be considered a "default" for IPsec?

The default with IPsec is up to the user-space IPsec manager,
e.g., libreswan.  So the kernel has no idea what the default
is.  Also, unlike filesystems IPsec is about interoperability
so the default is actually a list of algorithms.

If you were using libreswan then top of the list is gcm(aes),
followed by aes(cbc)+sha256, and then aes(cbc)+sha1.

Incidentally we should probably prune the INET_ESP select list.
At least MD5/SHA1/DES shouldn't be on it.  We probably should
add AES, SHA256 and GCM to the list.

Another potential improvement is to merge the two select lists
between ESP and ESP6.  Perhaps move them to a new tristate say
XFRM_ESP that would then be selected by ESP and ESP6.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
