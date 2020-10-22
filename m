Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932B4295E62
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 14:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898217AbgJVM3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 08:29:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37662 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898209AbgJVM3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 08:29:40 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kVZid-00048U-5g; Thu, 22 Oct 2020 23:29:24 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Oct 2020 23:29:23 +1100
Date:   Thu, 22 Oct 2020 23:29:23 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhuoliang Zhang <zhuoliang.zhang@mediatek.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com
Subject: Re: [PATCH v2] net: xfrm: fix a race condition during allocing spi
Message-ID: <20201022122923.GA16706@gondor.apana.org.au>
References: <20201022100126.19565-1-zhuoliang.zhang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022100126.19565-1-zhuoliang.zhang@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 06:01:27PM +0800, Zhuoliang Zhang wrote:
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
> 1. a new state x is alloced in xfrm_state_alloc() and added into the bydst hlist
> in  __find_acq_core() on the LHS;
> 2. on the RHS, state_hash_work thread travels the old bydst and tranfers every xfrm_state
> (include x) into the new bydst hlist and new byspi hlist;
> 3. user thread on the LHS gets the lock and adds x into the new byspi hlist again.
> 
> So the same xfrm_state (x) is added into the same list_hash
> (net->xfrm.state_byspi) 2 times that makes the list_hash become
> an inifite loop.
> 
> To fix the race, x->id.spi = htonl(spi) in the xfrm_alloc_spi() is moved
> to the back of spin_lock_bh, sothat state_hash_work thread no longer add x
> which id.spi is zero into the hash_list.
> 
> Fixes: f034b5d4efdf ("[XFRM]: Dynamic xfrm_state hash table sizing.")
> Signed-off-by: zhuoliang zhang <zhuoliang.zhang@mediatek.com>
> ---
>  net/xfrm/xfrm_state.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
