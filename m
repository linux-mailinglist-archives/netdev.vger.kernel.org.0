Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95EC526598
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358229AbiEMPDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381781AbiEMPDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:03:00 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A651446143
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:02:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6F5DC20688;
        Fri, 13 May 2022 17:02:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Jts-qx35MQnX; Fri, 13 May 2022 17:02:54 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E12812050A;
        Fri, 13 May 2022 17:02:54 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id DBB4C80004A;
        Fri, 13 May 2022 17:02:54 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 17:02:54 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 17:02:54 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 27AEE3180A74; Fri, 13 May 2022 17:02:54 +0200 (CEST)
Date:   Fri, 13 May 2022 17:02:54 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH ipsec-next 5/6] xfrm: add RX datapath protection for
 IPsec full offload mode
Message-ID: <20220513150254.GM680067@gauss3.secunet.de>
References: <cover.1652176932.git.leonro@nvidia.com>
 <ff459f4de434def4a1d7ab989a17577f19a67f45.1652176932.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ff459f4de434def4a1d7ab989a17577f19a67f45.1652176932.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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

On Tue, May 10, 2022 at 01:36:56PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Traffic received by device with enabled IPsec full offload should be
> forwarded to the stack only after decryption, packet headers and
> trailers removed.
> 
> Such packets are expected to be seen as normal (non-XFRM) ones, while
> not-supported packets should be dropped by the HW.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/net/xfrm.h | 55 +++++++++++++++++++++++++++-------------------
>  1 file changed, 32 insertions(+), 23 deletions(-)
> 
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index 21be19ece4f7..9f9250fe1c4d 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -1094,6 +1094,29 @@ xfrm_state_addr_cmp(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x, un
>  	return !0;
>  }
>  
> +#ifdef CONFIG_XFRM
> +static inline struct xfrm_state *xfrm_input_state(struct sk_buff *skb)
> +{
> +	struct sec_path *sp = skb_sec_path(skb);
> +
> +	return sp->xvec[sp->len - 1];
> +}
> +#endif
> +
> +static inline struct xfrm_offload *xfrm_offload(struct sk_buff *skb)
> +{
> +#ifdef CONFIG_XFRM
> +	struct sec_path *sp = skb_sec_path(skb);
> +
> +	if (!sp || !sp->olen || sp->len != sp->olen)
> +		return NULL;
> +
> +	return &sp->ovec[sp->olen - 1];
> +#else
> +	return NULL;
> +#endif
> +}
> +
>  #ifdef CONFIG_XFRM
>  int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
>  			unsigned short family);
> @@ -1113,6 +1136,15 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
>  {
>  	struct net *net = dev_net(skb->dev);
>  	int ndir = dir | (reverse ? XFRM_POLICY_MASK + 1 : 0);
> +	struct xfrm_offload *xo = xfrm_offload(skb);
> +	struct xfrm_state *x;
> +
> +	if (xo) {
> +		x = xfrm_input_state(skb);
> +		if (x->xso.type == XFRM_DEV_OFFLOAD_FULL)
> +			return (xo->flags & CRYPTO_DONE) &&
> +			       (xo->status & CRYPTO_SUCCESS);
> +	}

We can not exit without doing the policy check here. The inner
packet could still match a block policy in software. Maybe
we can reset the secpath and do the policy check.
