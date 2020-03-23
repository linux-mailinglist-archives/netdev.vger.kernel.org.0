Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60FCE18EFCB
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 07:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgCWG3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 02:29:45 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56914 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgCWG3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 02:29:45 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jGGaI-0004Wx-IH; Mon, 23 Mar 2020 17:29:15 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Mar 2020 17:29:14 +1100
Date:   Mon, 23 Mar 2020 17:29:14 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        timo.teras@iki.fi, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfrm: policy: Fix doulbe free in xfrm_policy_timer
Message-ID: <20200323062914.GA5811@gondor.apana.org.au>
References: <20200318034839.57996-1-yuehaibing@huawei.com>
 <20200323014155.56376-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323014155.56376-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 09:41:55AM +0800, YueHaibing wrote:
>
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index dbda08ec566e..ae0689174bbf 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -434,6 +434,7 @@ EXPORT_SYMBOL(xfrm_policy_destroy);
>  
>  static void xfrm_policy_kill(struct xfrm_policy *policy)
>  {
> +	write_lock_bh(&policy->lock);
>  	policy->walk.dead = 1;
>  
>  	atomic_inc(&policy->genid);
> @@ -445,6 +446,7 @@ static void xfrm_policy_kill(struct xfrm_policy *policy)
>  	if (del_timer(&policy->timer))
>  		xfrm_pol_put(policy);
>  
> +	write_unlock_bh(&policy->lock);

Why did you expand the critical section? Can't you just undo the
patch in xfrm_policy_kill?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
