Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270351F60A6
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 05:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgFKDsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 23:48:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33278 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgFKDsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 23:48:22 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jjECK-0002wh-Se; Thu, 11 Jun 2020 13:48:14 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2020 13:48:12 +1000
Date:   Thu, 11 Jun 2020 13:48:12 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        manojmalviya@chelsio.com
Subject: Re: [PATCH net-next 2/2] Crypto/chcr: Checking cra_refcnt before
 unregistering the algorithms
Message-ID: <20200611034812.GA27335@gondor.apana.org.au>
References: <20200609212432.2467-1-ayush.sawal@chelsio.com>
 <20200609212432.2467-3-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609212432.2467-3-ayush.sawal@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 02:54:32AM +0530, Ayush Sawal wrote:
> This patch puts a check for algorithm unregister, to avoid removal of
> driver if the algorithm is under use.
> 
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index f8b55137cf7d..4c2553672b6f 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -4391,22 +4391,32 @@ static int chcr_unregister_alg(void)
>  	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
>  		switch (driver_algs[i].type & CRYPTO_ALG_TYPE_MASK) {
>  		case CRYPTO_ALG_TYPE_SKCIPHER:
> -			if (driver_algs[i].is_registered)
> +			if (driver_algs[i].is_registered && refcount_read(
> +			    &driver_algs[i].alg.skcipher.base.cra_refcnt)
> +			    == 1) {
>  				crypto_unregister_skcipher(
>  						&driver_algs[i].alg.skcipher);
> +				driver_algs[i].is_registered = 0;
> +			}

This is wrong.  cra_refcnt must not be used directly by drivers.

Normally driver unregister is stopped by the module reference
count.  This is not the case for your driver because of the existence
of a path of unregistration that is not tied to module removal.

To support that properly, we need to add code to the Crypto API
to handle this, as opposed to adding hacks to the driver.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
