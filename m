Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2045D63806
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 16:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfGIOij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 10:38:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57992 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfGIOij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 10:38:39 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hkrGP-00033V-Ot; Tue, 09 Jul 2019 22:38:37 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hkrGK-0002HA-G4; Tue, 09 Jul 2019 22:38:32 +0800
Date:   Tue, 9 Jul 2019 22:38:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] crypto: user - make NETLINK_CRYPTO work inside netns
Message-ID: <20190709143832.hej23rahmb4basy6@gondor.apana.org.au>
References: <20190709111124.31127-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709111124.31127-1-omosnace@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 01:11:24PM +0200, Ondrej Mosnacek wrote:
> Currently, NETLINK_CRYPTO works only in the init network namespace. It
> doesn't make much sense to cut it out of the other network namespaces,
> so do the minor plumbing work necessary to make it work in any network
> namespace. Code inspired by net/core/sock_diag.c.
> 
> Tested using kcapi-dgst from libkcapi [1]:
> Before:
>     # unshare -n kcapi-dgst -c sha256 </dev/null | wc -c
>     libkcapi - Error: Netlink error: sendmsg failed
>     libkcapi - Error: Netlink error: sendmsg failed
>     libkcapi - Error: NETLINK_CRYPTO: cannot obtain cipher information for hmac(sha512) (is required crypto_user.c patch missing? see documentation)
>     0
> 
> After:
>     # unshare -n kcapi-dgst -c sha256 </dev/null | wc -c
>     32
> 
> [1] https://github.com/smuellerDD/libkcapi
> 
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

Should we really let root inside a namespace manipulate crypto
algorithms which are global?

I think we should only allow the query operations without deeper
surgery.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
