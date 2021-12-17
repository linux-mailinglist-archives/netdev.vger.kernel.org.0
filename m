Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDA4478593
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 08:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhLQHcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 02:32:53 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37146 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232167AbhLQHcx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 02:32:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8ECB9201AE;
        Fri, 17 Dec 2021 08:32:51 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id o5Q4tS6M6aqG; Fri, 17 Dec 2021 08:32:51 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 15FEF2009B;
        Fri, 17 Dec 2021 08:32:51 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 0539A80004A;
        Fri, 17 Dec 2021 08:32:51 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 08:32:50 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 17 Dec
 2021 08:32:50 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E53103183CA5; Fri, 17 Dec 2021 08:32:48 +0100 (CET)
Date:   Fri, 17 Dec 2021 08:32:48 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Thomas Egerer <thomas.egerer@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm: rate limit SA mapping change message to
 user space
Message-ID: <20211217073248.GM427717@gauss3.secunet.de>
References: <YafsUMtO+zj/2xcC@moon.secunet.de>
 <3453d9c8dccd74e43c8eef1ee261c85e7a3460db.1639693812.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3453d9c8dccd74e43c8eef1ee261c85e7a3460db.1639693812.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 11:37:06PM +0100, Antony Antony wrote:
> Kernel generates mapping change message, XFRM_MSG_MAPPING,
> when a source port chage is detected on a input state with UDP
> encapsulation. Kernel generates a message per each IPsec packet
> with the new source port. For a high speed flow per packet mapping change
> message can be very excessive, and can overload the user space listener.
> 
> Introduce rate limiting for XFRM_MSG_MAPPING message to the user space.
> 
> The rate limiting is configurable via netlink, when adding a new SA or
> updating it. Use the new attribute XFRMA_MTIMER_THRESH, in seconds.
> 
> Co-developed-by: Thomas Egerer <thomas.egerer@secunet.com>
> Signed-off-by: Thomas Egerer <thomas.egerer@secunet.com>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  include/net/xfrm.h        |  5 +++++
>  include/uapi/linux/xfrm.h |  1 +
>  net/xfrm/xfrm_state.c     | 23 ++++++++++++++++++++++-
>  net/xfrm/xfrm_user.c      | 12 +++++++++++-
>  4 files changed, 39 insertions(+), 2 deletions(-)

...

>  
>  static void xfrm_smark_init(struct nlattr **attrs, struct xfrm_mark *m)
> @@ -1024,8 +1028,14 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
>  		if (ret)
>  			goto out;
>  	}
> -	if (x->security)
> +	if (x->security) {
>  		ret = copy_sec_ctx(x->security, skb);
> +		if (ret)
> +			goto out;
> +	}
> +	if (x->mapping_maxage)
> +		ret = nla_put_u32(skb, XFRMA_MTIMER_THRESH,
> +				  (x->mapping_maxage / HZ));

I think you need to update xfrm_sa_len() when you add data here.
