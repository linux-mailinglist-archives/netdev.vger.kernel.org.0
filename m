Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16A462DA69
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbiKQMMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240024AbiKQMMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:12:47 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713876EB42
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:12:46 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1A48920569;
        Thu, 17 Nov 2022 13:12:45 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gfhUMt03ugh4; Thu, 17 Nov 2022 13:12:44 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 90FB32053B;
        Thu, 17 Nov 2022 13:12:44 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 8B36280004A;
        Thu, 17 Nov 2022 13:12:44 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 13:12:44 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 13:12:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C7E3731808E0; Thu, 17 Nov 2022 13:12:43 +0100 (CET)
Date:   Thu, 17 Nov 2022 13:12:43 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <20221117121243.GJ704954@gauss3.secunet.de>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f611857594c5c53918d782f104d6f4e028ba465d.1667997522.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f611857594c5c53918d782f104d6f4e028ba465d.1667997522.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 02:54:34PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> @@ -1166,16 +1187,24 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
>  			spin_lock_bh(&net->xfrm.xfrm_state_lock);
>  			x->km.state = XFRM_STATE_ACQ;
>  			list_add(&x->km.all, &net->xfrm.state_all);
> -			hlist_add_head_rcu(&x->bydst, net->xfrm.state_bydst + h);
> +			XFRM_STATE_INSERT(bydst, &x->bydst,
> +					  net->xfrm.state_bydst + h,
> +					  x->xso.type);
>  			h = xfrm_src_hash(net, daddr, saddr, encap_family);
> -			hlist_add_head_rcu(&x->bysrc, net->xfrm.state_bysrc + h);
> +			XFRM_STATE_INSERT(bysrc, &x->bysrc,
> +					  net->xfrm.state_bysrc + h,
> +					  x->xso.type);
>  			if (x->id.spi) {
>  				h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto, encap_family);
> -				hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
> +				XFRM_STATE_INSERT(byspi, &x->byspi,
> +						  net->xfrm.state_byspi + h,
> +						  x->xso.type);
>  			}
>  			if (x->km.seq) {
>  				h = xfrm_seq_hash(net, x->km.seq);
> -				hlist_add_head_rcu(&x->byseq, net->xfrm.state_byseq + h);
> +				XFRM_STATE_INSERT(byseq, &x->byseq,
> +						  net->xfrm.state_byseq + h,
> +						  x->xso.type);
>  			}

This does not work. A larval state will never have a x->xso.type set.
So this raises the question how to handle acquires with this packet
offload. You could place the type and offload device to the template,
but we also have to make sure not to mess too much with the non
offloaded codepath.

This is yet another corner case where the concept of doing policy and
state lookup in software for a HW offload does not work so well. I
fear this is not the last corner case that comes up once you put this
into a real network.

