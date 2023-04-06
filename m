Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5799A6D9082
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbjDFHgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbjDFHgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:36:02 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA312112
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:36:00 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pkK9t-00D0aP-Dn; Thu, 06 Apr 2023 15:35:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Apr 2023 15:35:49 +0800
Date:   Thu, 6 Apr 2023 15:35:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alexander.duyck@gmail.com, hkallweit1@gmail.com,
        andrew@lunn.ch, willemb@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v3 7/7] net: piggy back on the memory barrier in
 bql when waking queues
Message-ID: <ZC52VRfUOOObx2fw@gondor.apana.org.au>
References: <20230405223134.94665-1-kuba@kernel.org>
 <20230405223134.94665-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405223134.94665-8-kuba@kernel.org>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 03:31:34PM -0700, Jakub Kicinski wrote:
>					\
> @@ -82,10 +82,26 @@
>  		_res;							\
>  	})								\
>  
> +/* Variant of netdev_tx_completed_queue() which guarantees smp_mb() if
> + * @bytes != 0, regardless of kernel config.
> + */
> +static inline void
> +netdev_txq_completed_mb(struct netdev_queue *dev_queue,
> +			unsigned int pkts, unsigned int bytes)
> +{
> +#ifdef CONFIG_BQL
> +	netdev_tx_completed_queue(dev_queue, pkts, bytes);
> +#else
> +	if (bytes)
> +		smp_mb();
> +#endif
> +}

Minor nit, I would write this as

	if (IS_ENABLED(CONFIG_BQL))
		netdev_tx_completed_queue(dev_queue, pkts, bytes);
	else if (bytes)
		smp_mb();

Actually, why is this checking bytes while the caller is checking
pkts? Do we need to check them at all? If pkts/bytes is commonly
non-zero, then we should just do a barrier unconditionally and make
the uncommon path pay the penalty.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
