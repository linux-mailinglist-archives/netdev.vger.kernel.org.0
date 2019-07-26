Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC3F0762C1
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfGZJpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:45:47 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:32956 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfGZJpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 05:45:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C392A20268;
        Fri, 26 Jul 2019 11:45:44 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lEmaeQYyVd6U; Fri, 26 Jul 2019 11:45:14 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 897FB201E1;
        Fri, 26 Jul 2019 11:45:14 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.468.0; Fri, 26 Jul 2019
 11:45:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 31D303180409;
 Fri, 26 Jul 2019 11:45:14 +0200 (CEST)
Date:   Fri, 26 Jul 2019 11:45:14 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: key: af_key: Fix possible null-pointer dereferences
 in pfkey_send_policy_notify()
Message-ID: <20190726094514.GD14601@gauss3.secunet.de>
References: <20190724093509.1676-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190724093509.1676-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 05:35:09PM +0800, Jia-Ju Bai wrote:
> In pfkey_send_policy_notify(), there is an if statement on line 3081 to
> check whether xp is NULL:
>     if (xp && xp->type != XFRM_POLICY_TYPE_MAIN)
> 
> When xp is NULL, it is used by key_notify_policy() on line 3090:
>     key_notify_policy(xp, ...)
>         pfkey_xfrm_policy2msg_prep(xp) -- line 2211
>             pfkey_xfrm_policy2msg_size(xp) -- line 2046
>                 for (i=0; i<xp->xfrm_nr; i++) -- line 2026
>                 t = xp->xfrm_vec + i; -- line 2027
>     key_notify_policy(xp, ...)
>         xp_net(xp) -- line 2231
>             return read_pnet(&xp->xp_net); -- line 534

Please don't quote random code lines, explain the
problem instead.

> 
> Thus, possible null-pointer dereferences may occur.
> 
> To fix these bugs, xp is checked before calling key_notify_policy().
> 
> These bugs are found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  net/key/af_key.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index b67ed3a8486c..ced54144d5fd 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -3087,6 +3087,8 @@ static int pfkey_send_policy_notify(struct xfrm_policy *xp, int dir, const struc
>  	case XFRM_MSG_DELPOLICY:
>  	case XFRM_MSG_NEWPOLICY:
>  	case XFRM_MSG_UPDPOLICY:
> +		if (!xp)
> +			break;

I think this can not happen. Who sends one of these notifications
without a pointer to the policy?

