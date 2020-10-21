Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6194C2948A3
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 09:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437127AbgJUHMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 03:12:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35086 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391498AbgJUHMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 03:12:33 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kV8II-0002e1-Es; Wed, 21 Oct 2020 18:12:23 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 Oct 2020 18:12:22 +1100
Date:   Wed, 21 Oct 2020 18:12:22 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhuoliang Zhang <zhuoliang.zhang@mediatek.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com
Subject: Re: [PATCH] net: xfrm: fix a race condition during allocing spi
Message-ID: <20201021071222.GA11474@gondor.apana.org.au>
References: <20201020081800.29454-1-zhuoliang.zhang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020081800.29454-1-zhuoliang.zhang@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 04:18:00PM +0800, Zhuoliang Zhang wrote:
> From: zhuoliang zhang <zhuoliang.zhang@mediatek.com>
> 
> we found that the following race condition exists in
> xfrm_alloc_userspi flow:
> 
> user thread                                    state_hash_work thread
> ----                                           ----
> xfrm_alloc_userspi()
>  __find_acq_core()
>    /*alloc new xfrm_state:x*/
>    xfrm_state_alloc()
>    /*schedule state_hash_work thread*/
>    xfrm_hash_grow_check()   	               xfrm_hash_resize()
>  xfrm_alloc_spi                                  /*hold lock*/
>       x->id.spi = htonl(spi)                     spin_lock_bh(&net->xfrm.xfrm_state_lock)
>       /*waiting lock release*/                     xfrm_hash_transfer()
>       spin_lock_bh(&net->xfrm.xfrm_state_lock)      /*add x into hlist:net->xfrm.state_byspi*/
> 	                                                hlist_add_head_rcu(&x->byspi)
>                                                  spin_unlock_bh(&net->xfrm.xfrm_state_lock)
> 
>     /*add x into hlist:net->xfrm.state_byspi 2 times*/
>     hlist_add_head_rcu(&x->byspi)
> 
> So the same xfrm_stame (x) is added into the same list_hash
> (net->xfrm.state_byspi)2 times that makes the list_hash become
> a inifite loop.

Your explanation makes no sense.  Prior to obtaining the spin lock
on the LHS, the state x hasn't been added to thte table yet.  So
how can the RHS be transferring it?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
