Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0191C20CF7
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 18:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfEPQ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 12:29:02 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:15847 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfEPQ3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 12:29:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1558024140;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Apx7ZxqDR7YHZ7kD/2IJRkM4VaciDIYJ3ycVJe9uIxc=;
        b=aCMm45J8B2y/lyCbLNQ0dAXDmoX16yAxuCp/f+Rvqwvu0lfmvu70BPqSGPJyd1IvNv
        Xj9eoFFcQFRMO++b7o4Yt3z4WJsa1vbDCEVkgsL6yKs0kxnNrxrbTmPg6XWxv+oCUOji
        GIFFBuf85PUTE9K3PN2agzbvUFU3YgR77iWq2UcVXUW27dYt7TseJgUZZwJQQ8KcPxC4
        NpD6eNQqUVsTMFl+dEOMOAOapKZI/lwqp9g4YWnhao5UFQGklW2VZ2fRxL6SC9LlX2Z4
        Nm+Weotw44fQOr3K0nJQfDIjMt0vvkYKzgf9aeUu4gFlIZZ1LWvHrHSBcPp1QzwAv15t
        oKtg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJUMh6kkRA"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.200]
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id q0b361v4GGPnEj4
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 16 May 2019 18:25:49 +0200 (CEST)
Subject: Re: [PATCH] can: Fix error path of can_init
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        mkl@pengutronix.de
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
References: <20190516143626.27636-1-yuehaibing@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <70bc346c-9328-d0a2-bd7e-af8dff748061@hartkopp.net>
Date:   Thu, 16 May 2019 18:25:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190516143626.27636-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.05.19 16:36, YueHaibing wrote:
> This patch add error path for can_init to
> avoid possible crash if some error occurs.
> 
> Fixes: 0d66548a10cb ("[CAN]: Add PF_CAN core module")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks!

> ---
>   net/can/af_can.c | 24 +++++++++++++++++++++---
>   1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 1684ba5..a1781ea 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -958,6 +958,8 @@ static void can_pernet_exit(struct net *net)
>   
>   static __init int can_init(void)
>   {
> +	int rc;
> +
>   	/* check for correct padding to be able to use the structs similarly */
>   	BUILD_BUG_ON(offsetof(struct can_frame, can_dlc) !=
>   		     offsetof(struct canfd_frame, len) ||
> @@ -971,15 +973,31 @@ static __init int can_init(void)
>   	if (!rcv_cache)
>   		return -ENOMEM;
>   
> -	register_pernet_subsys(&can_pernet_ops);
> +	rc = register_pernet_subsys(&can_pernet_ops);
> +	if (rc)
> +		goto out_pernet;
>   
>   	/* protocol register */
> -	sock_register(&can_family_ops);
> -	register_netdevice_notifier(&can_netdev_notifier);
> +	rc = sock_register(&can_family_ops);
> +	if (rc)
> +		goto out_sock;
> +	rc = register_netdevice_notifier(&can_netdev_notifier);
> +	if (rc)
> +		goto out_notifier;
> +
>   	dev_add_pack(&can_packet);
>   	dev_add_pack(&canfd_packet);
>   
>   	return 0;
> +
> +out_notifier:
> +	sock_unregister(PF_CAN);
> +out_sock:
> +	unregister_pernet_subsys(&can_pernet_ops);
> +out_pernet:
> +	kmem_cache_destroy(rcv_cache);
> +
> +	return rc;
>   }
>   
>   static __exit void can_exit(void)
> 
