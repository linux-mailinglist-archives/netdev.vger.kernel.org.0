Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBAEC20D08
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfEPQas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 12:30:48 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:16045 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfEPQar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 12:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1558024245;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=FQma3RmWDS8VYLqxGeNcHo7p5BwbUBC6TbpAzjFKweQ=;
        b=Ud+R7juj9V8dW3YGjEnsvVemVWpTSAe/JKmdSHKUJ3VPz29qFZOWciGQcrJCkNGmNd
        VaRHYTN2JNaDub3HR0xARyMf8CvOl6KC/GYCYeclzP2h8FuKMIv4gJTFSTG2YyxfMpSg
        vY2yIlke5jCNtYCVQcOGzAgbNhoJlVlW/Mx8aYn4dS6tnEBCy/keyzYCEN6viyyA1dvM
        lGpW+NZ/ItGEyFbNCAL0x+lPXFLJcowNttFNUBnOmZLaNBy+2P3NHJ3p4xKCBKYUZymT
        e0rgk/KapagHXdKhhhDiBAHxE1lbrKdR3a707Jg6wv0RyMrGZX43wOYux8n8Dfdmcxxs
        fI0w==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJUMh6kkRA"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.200]
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id q0b361v4GGOjEiy
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 16 May 2019 18:24:45 +0200 (CEST)
Subject: Re: [PATCH] can: gw: Fix error path of cgw_module_init
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        mkl@pengutronix.de
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
References: <20190516155435.42376-1-yuehaibing@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <5e833f8b-537b-f4b0-4d7d-489936026cca@hartkopp.net>
Date:   Thu, 16 May 2019 18:24:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190516155435.42376-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.05.19 17:54, YueHaibing wrote:
> This patch fix error path for cgw_module_init
> to avoid possible crash if some error occurs.
> 
> Fixes: c1aabdf379bc ("can-gw: add netlink based CAN routing")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks!

> ---
>   net/can/gw.c | 46 +++++++++++++++++++++++++++++++---------------
>   1 file changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/net/can/gw.c b/net/can/gw.c
> index 53859346..8b53ec7 100644
> --- a/net/can/gw.c
> +++ b/net/can/gw.c
> @@ -1046,32 +1046,48 @@ static __init int cgw_module_init(void)
>   	pr_info("can: netlink gateway (rev " CAN_GW_VERSION ") max_hops=%d\n",
>   		max_hops);
>   
> -	register_pernet_subsys(&cangw_pernet_ops);
> +	ret = register_pernet_subsys(&cangw_pernet_ops);
> +	if (ret)
> +		return ret;
> +
> +	ret = -ENOMEM;
>   	cgw_cache = kmem_cache_create("can_gw", sizeof(struct cgw_job),
>   				      0, 0, NULL);
> -
>   	if (!cgw_cache)
> -		return -ENOMEM;
> +		goto out_cache_create;
>   
>   	/* set notifier */
>   	notifier.notifier_call = cgw_notifier;
> -	register_netdevice_notifier(&notifier);
> +	ret = register_netdevice_notifier(&notifier);
> +	if (ret)
> +		goto out_register_notifier;
>   
>   	ret = rtnl_register_module(THIS_MODULE, PF_CAN, RTM_GETROUTE,
>   				   NULL, cgw_dump_jobs, 0);
> -	if (ret) {
> -		unregister_netdevice_notifier(&notifier);
> -		kmem_cache_destroy(cgw_cache);
> -		return -ENOBUFS;
> -	}
> -
> -	/* Only the first call to rtnl_register_module can fail */
> -	rtnl_register_module(THIS_MODULE, PF_CAN, RTM_NEWROUTE,
> -			     cgw_create_job, NULL, 0);
> -	rtnl_register_module(THIS_MODULE, PF_CAN, RTM_DELROUTE,
> -			     cgw_remove_job, NULL, 0);
> +	if (ret)
> +		goto out_rtnl_register1;
> +
> +	ret = rtnl_register_module(THIS_MODULE, PF_CAN, RTM_NEWROUTE,
> +				   cgw_create_job, NULL, 0);
> +	if (ret)
> +		goto out_rtnl_register2;
> +	ret = rtnl_register_module(THIS_MODULE, PF_CAN, RTM_DELROUTE,
> +				   cgw_remove_job, NULL, 0);
> +	if (ret)
> +		goto out_rtnl_register2;
>   
>   	return 0;
> +
> +out_rtnl_register2:
> +	rtnl_unregister_all(PF_CAN);
> +out_rtnl_register1:
> +	unregister_netdevice_notifier(&notifier);
> +out_register_notifier:
> +	kmem_cache_destroy(cgw_cache);
> +out_cache_create:
> +	unregister_pernet_subsys(&cangw_pernet_ops);
> +
> +	return ret;
>   }
>   
>   static __exit void cgw_module_exit(void)
> 
