Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A622598172
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 12:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbiHRKY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 06:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237435AbiHRKY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 06:24:56 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3FD51400
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:24:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BDFF4204B4;
        Thu, 18 Aug 2022 12:24:52 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3M1rtPC0cPJT; Thu, 18 Aug 2022 12:24:52 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 310522009B;
        Thu, 18 Aug 2022 12:24:52 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 1EFD880004A;
        Thu, 18 Aug 2022 12:24:52 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 18 Aug 2022 12:24:51 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 18 Aug
 2022 12:24:51 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7F2993182AA7; Thu, 18 Aug 2022 12:24:51 +0200 (CEST)
Date:   Thu, 18 Aug 2022 12:24:51 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 4/6] xfrm: add TX datapath support for IPsec
 full offload mode
Message-ID: <20220818102451.GE566407@gauss3.secunet.de>
References: <cover.1660639789.git.leonro@nvidia.com>
 <aa0b418e5bccb0b32625f8615124c8d0e58d9980.1660639789.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aa0b418e5bccb0b32625f8615124c8d0e58d9980.1660639789.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 11:59:25AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In IPsec full mode, the device is going to encrypt and encapsulate
> packets that are associated with offloaded policy. After successful
> policy lookup to indicate if packets should be offloaded or not,
> the stack forwards packets to the device to do the magic.
> 
> Signed-off-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  net/xfrm/xfrm_device.c | 13 +++++++++++++
>  net/xfrm/xfrm_output.c | 20 ++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> index 1cc482e9c87d..db5ebd36f68c 100644
> --- a/net/xfrm/xfrm_device.c
> +++ b/net/xfrm/xfrm_device.c

> @@ -366,6 +376,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
>  	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
>  	struct net_device *dev = x->xso.dev;
>  
> +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL)
> +		goto ok;

You skip the PMTU checks here. I've seen that you check
the packet length against the device MTU in one of your
mlx5 patches, but that does not help if the PMTU is below.

>  
> diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> index 555ab35cd119..27a8dac9ca7d 100644
> --- a/net/xfrm/xfrm_output.c
> +++ b/net/xfrm/xfrm_output.c
> @@ -719,6 +719,26 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
>  		break;
>  	}
>  
> +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
> +		struct dst_entry *dst = skb_dst_pop(skb);
> +
> +		if (!dst || !xfrm_dev_offload_ok(skb, x)) {
> +			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
> +			kfree_skb(skb);
> +			return -EHOSTUNREACH;
> +		}
> +
> +		skb_dst_set(skb, dst);
> +		err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
> +		if (unlikely(err != 1))
> +			return err;
> +
> +		if (!skb_dst(skb)->xfrm)
> +			return dst_output(net, skb->sk, skb);
> +
> +		return 0;

You leak skb here. Also, this skb needs another tfm because
skb_dst(skb)->xfrm is set.

