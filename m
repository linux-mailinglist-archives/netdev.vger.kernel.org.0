Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E7652654A
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 16:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353946AbiEMO5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 10:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiEMO5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 10:57:03 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2C217054
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 07:57:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6C68E20680;
        Fri, 13 May 2022 16:56:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LKR7Jf3snHON; Fri, 13 May 2022 16:56:58 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E0F3A20613;
        Fri, 13 May 2022 16:56:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id DC32A80004A;
        Fri, 13 May 2022 16:56:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 16:56:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 16:56:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 323D13180A74; Fri, 13 May 2022 16:56:58 +0200 (CEST)
Date:   Fri, 13 May 2022 16:56:58 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH ipsec-next 4/6] xfrm: add TX datapath support for IPsec
 full offload mode
Message-ID: <20220513145658.GL680067@gauss3.secunet.de>
References: <cover.1652176932.git.leonro@nvidia.com>
 <905b8e8032d5cdb48ef63cb153fd86552c8a6a7d.1652176932.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <905b8e8032d5cdb48ef63cb153fd86552c8a6a7d.1652176932.git.leonro@nvidia.com>
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

On Tue, May 10, 2022 at 01:36:55PM +0300, Leon Romanovsky wrote:
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
>  net/xfrm/xfrm_output.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> index d4935b3b9983..2599f3dbac08 100644
> --- a/net/xfrm/xfrm_output.c
> +++ b/net/xfrm/xfrm_output.c
> @@ -718,6 +718,25 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
>  		break;
>  	}
>  
> +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
> +		struct dst_entry *dst = skb_dst_pop(skb);
> +
> +		if (!dst) {
> +			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
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
> +	}
> +

How do we know that we send the packet really to a device that
supports this type of offload? For crypto offload, we check that
in xfrm_dev_offload_ok() and I think something similar is required
here too.

Also, the offload type still requires software policies and states.
What if a device comes up that can do a real full offload, i.e.
in a way that the kernel acts just as a stub layer between IKE
and the device. Are we going to create XFRM_DEV_OFFLOAD_FULL_2
then? We need to make sure that this case cann be supported with
the new API too.

