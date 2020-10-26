Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008DA29883C
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771574AbgJZIXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:23:42 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39586 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771568AbgJZIXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 04:23:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 59A8020501;
        Mon, 26 Oct 2020 09:23:40 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bBK94TIIxWU1; Mon, 26 Oct 2020 09:23:39 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CBB11200A3;
        Mon, 26 Oct 2020 09:23:39 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 26 Oct 2020 09:23:39 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 26 Oct
 2020 09:23:39 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id ABD2B3184555;
 Mon, 26 Oct 2020 09:23:38 +0100 (CET)
Date:   Mon, 26 Oct 2020 09:23:38 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Zhuoliang Zhang <zhuoliang.zhang@mediatek.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>
Subject: Re: [PATCH v2] net: xfrm: fix a race condition during allocing spi
Message-ID: <20201026082338.GS31157@gauss3.secunet.de>
References: <20201022100126.19565-1-zhuoliang.zhang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201022100126.19565-1-zhuoliang.zhang@mediatek.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
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

Applied, thanks a lot!

One remark, please don't use base64 encoding when you send patches.
I had to hand edit your patch to get it applied.
