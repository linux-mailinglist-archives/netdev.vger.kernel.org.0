Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109D51EF0D0
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 07:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgFEFJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 01:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgFEFJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 01:09:11 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72612207D5;
        Fri,  5 Jun 2020 05:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591333751;
        bh=UzyDlahrvzCn5RxpxYl+m85rQsa0HCgoF/xHBV+f4j0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TKh1NKbROLLp3vX6PmXrzkE1rDwcwsFbSe5Uud+LufF6E+qldnJPBWfWT5czJbw9i
         qSIvkZ7swPo6k02ohRf0Ax+mLYUjFFOKUE+qNbeN/XDe07To5TmfM4UPQLXtAn/t3S
         B2SAJnNLi5Y6y5J9T24xtdetUL0+HESHpNMqamf4=
Date:   Thu, 4 Jun 2020 22:09:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net] esp: select CRYPTO_SEQIV
Message-ID: <20200605050910.GS2667@sol.localdomain>
References: <20200604192322.22142-1-ebiggers@kernel.org>
 <20200605002858.GB31846@gondor.apana.org.au>
 <20200605002956.GA31947@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605002956.GA31947@gondor.apana.org.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 10:29:56AM +1000, Herbert Xu wrote:
> On Fri, Jun 05, 2020 at 10:28:58AM +1000, Herbert Xu wrote:
> >
> > Hmm, the selection list doesn't include CTR so just adding SEQIV
> > per se makes no sense.  I'm not certain that we really want to
> > include every algorithm under the sun.  Steffen, what do you think?
> 
> Or how about
> 
> 	select CRYPTO_SEQIV if CRYPTO_CTR
> 
> That would make more sense.
> 
> Cheers,

There's also a case where "seqiv" is used without counter mode:

net/xfrm/xfrm_algo.c:

{
        .name = "rfc7539esp(chacha20,poly1305)",

        .uinfo = {
                .aead = {
                        .geniv = "seqiv",
                        .icv_truncbits = 128,
                }
        },

        .pfkey_supported = 0,
},


FWIW, we make CONFIG_FS_ENCRYPTION select only the algorithms that we consider
the "default", and any "non-default" algorithms need to be explicitly enabled.

Is something similar going on here with INET_ESP and INET_ESP6?  Should "seqiv"
be considered a "default" for IPsec?

- Eric
