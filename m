Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B111640358
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiLBJae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiLBJad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:30:33 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8132B90745
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 01:30:31 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7DE1D2052D;
        Fri,  2 Dec 2022 10:30:29 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AH59pYRYLLpk; Fri,  2 Dec 2022 10:30:28 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EF7082007F;
        Fri,  2 Dec 2022 10:30:28 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id E9EC180004A;
        Fri,  2 Dec 2022 10:30:28 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 10:30:28 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 2 Dec
 2022 10:30:28 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 16B69318298A; Fri,  2 Dec 2022 10:30:28 +0100 (CET)
Date:   Fri, 2 Dec 2022 10:30:28 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 4/8] xfrm: add TX datapath support for IPsec
 packet offload mode
Message-ID: <20221202093028.GZ704954@gauss3.secunet.de>
References: <cover.1669547603.git.leonro@nvidia.com>
 <5bb21e69cff4e720c4f057238902299a3bd15a04.1669547603.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5bb21e69cff4e720c4f057238902299a3bd15a04.1669547603.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 01:18:14PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In IPsec packet mode, the device is going to encrypt and encapsulate
> packets that are associated with offloaded policy. After successful
> policy lookup to indicate if packets should be offloaded or not,
> the stack forwards packets to the device to do the magic.
> 
> Signed-off-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  net/xfrm/xfrm_device.c |  15 +++++-
>  net/xfrm/xfrm_output.c |  12 ++++-
>  net/xfrm/xfrm_state.c  | 120 +++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 141 insertions(+), 6 deletions(-)
...
> @@ -1161,7 +1240,31 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
>  			x = NULL;
>  			goto out;
>  		}
> -
> +#ifdef CONFIG_XFRM_OFFLOAD
> +		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
> +			struct xfrm_dev_offload *xdo = &pol->xdo;
> +			struct xfrm_dev_offload *xso = &x->xso;
> +
> +			xso->type = XFRM_DEV_OFFLOAD_PACKET;
> +			xso->dir = xdo->dir;
> +			xso->dev = xdo->dev;
> +			xso->real_dev = xdo->real_dev;
> +			netdev_tracker_alloc(xso->dev, &xso->dev_tracker,
> +					     GFP_ATOMIC);
> +			error = xso->dev->xfrmdev_ops->xdo_dev_state_add(x);
> +			if (error) {
> +				xso->dir = 0;
> +				netdev_put(xso->dev, &xso->dev_tracker);
> +				xso->dev = NULL;
> +				xso->real_dev = NULL;
> +				xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
> +				x->km.state = XFRM_STATE_DEAD;
> +				to_put = x;
> +				x = NULL;
> +				goto out;
> +			}
> +		}
> +#endif
>  		if (km_query(x, tmpl, pol) == 0) {
>  			spin_lock_bh(&net->xfrm.xfrm_state_lock);
>  			x->km.state = XFRM_STATE_ACQ;
> @@ -1185,6 +1288,17 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
>  			xfrm_hash_grow_check(net, x->bydst.next != NULL);
>  			spin_unlock_bh(&net->xfrm.xfrm_state_lock);
>  		} else {
> +#ifdef CONFIG_XFRM_OFFLOAD
> +			struct xfrm_dev_offload *xso = &x->xso;
> +
> +			if (xso->type == XFRM_DEV_OFFLOAD_PACKET) {
> +				xso->dir = 0;
> +				netdev_put(xso->dev, &xso->dev_tracker);
> +				xso->dev = NULL;
> +				xso->real_dev = NULL;
> +				xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
> +			}

You do a xdo_dev_state_add call to add an acquire state to HW above.
Maybe we should do a xdo_dev_state_del call here when deleting the
acquire state.

> +#endif
>  			x->km.state = XFRM_STATE_DEAD;
>  			to_put = x;
>  			x = NULL;
> -- 
> 2.38.1
