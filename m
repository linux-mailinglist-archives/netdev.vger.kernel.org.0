Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BE24A5782
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbiBAHHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:07:05 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38082 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234542AbiBAHHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 02:07:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 989E0204A4;
        Tue,  1 Feb 2022 08:07:03 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AQymEWxCCxQu; Tue,  1 Feb 2022 08:07:03 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 221FC201E2;
        Tue,  1 Feb 2022 08:07:03 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 1A5C680004A;
        Tue,  1 Feb 2022 08:07:03 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 08:07:02 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Tue, 1 Feb
 2022 08:07:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id ED889318303F; Tue,  1 Feb 2022 08:07:01 +0100 (CET)
Date:   Tue, 1 Feb 2022 08:07:01 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>, <netdev@vger.kernel.org>,
        Shannon Nelson <shannon.nelson@oracle.com>
Subject: Re: [PATCH ipsec-next] xfrm: delete duplicated functions that calls
 same xfrm_api_check()
Message-ID: <20220201070701.GU1223722@gauss3.secunet.de>
References: <5f9d6820e0548cb3304cbb49bcb84bedb15d7403.1643274380.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5f9d6820e0548cb3304cbb49bcb84bedb15d7403.1643274380.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:08:40AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The xfrm_dev_register() and xfrm_dev_feat_change() have same
> implementation of one call to xfrm_api_check(). Instead of doing such
> indirection, call to xfrm_api_check() directly and delete duplicated
> functions.
> 
> Fixes: 92a2320697f7 ("xfrm: check for xdo_dev_ops add and delete")

There was nothing broken here, just a suboptimal implementation.
So please remove the Fixes tag, otherwise it gets backported
without a need.

Thanks!

> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  net/xfrm/xfrm_device.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> index 3fa066419d37..36d6c1835844 100644
> --- a/net/xfrm/xfrm_device.c
> +++ b/net/xfrm/xfrm_device.c
> @@ -380,16 +380,6 @@ static int xfrm_api_check(struct net_device *dev)
>  	return NOTIFY_DONE;
>  }
>  
> -static int xfrm_dev_register(struct net_device *dev)
> -{
> -	return xfrm_api_check(dev);
> -}
> -
> -static int xfrm_dev_feat_change(struct net_device *dev)
> -{
> -	return xfrm_api_check(dev);
> -}
> -
>  static int xfrm_dev_down(struct net_device *dev)
>  {
>  	if (dev->features & NETIF_F_HW_ESP)
> @@ -404,10 +394,10 @@ static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void
>  
>  	switch (event) {
>  	case NETDEV_REGISTER:
> -		return xfrm_dev_register(dev);
> +		return xfrm_api_check(dev);
>  
>  	case NETDEV_FEAT_CHANGE:
> -		return xfrm_dev_feat_change(dev);
> +		return xfrm_api_check(dev);
>  
>  	case NETDEV_DOWN:
>  	case NETDEV_UNREGISTER:
> -- 
> 2.34.1
