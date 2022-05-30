Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7278537928
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiE3Khm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiE3Khk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:37:40 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36583101DB;
        Mon, 30 May 2022 03:37:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 81D19205D2;
        Mon, 30 May 2022 12:37:35 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yqTvz7IRuTuA; Mon, 30 May 2022 12:37:35 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0DBF82057A;
        Mon, 30 May 2022 12:37:35 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 083F180004A;
        Mon, 30 May 2022 12:37:35 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 12:37:34 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 30 May
 2022 12:37:34 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 373283182D2D; Mon, 30 May 2022 12:37:34 +0200 (CEST)
Date:   Mon, 30 May 2022 12:37:34 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Hangyu Hua <hbh25y@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfrm: xfrm_input: fix a possible memory leak in
 xfrm_input()
Message-ID: <20220530103734.GD2517843@gauss3.secunet.de>
References: <20220530102046.41249-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220530102046.41249-1-hbh25y@gmail.com>
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

On Mon, May 30, 2022 at 06:20:46PM +0800, Hangyu Hua wrote:
> xfrm_input needs to handle skb internally. But skb is not freed When
> xo->flags & XFRM_GRO == 0 and decaps == 0.
> 
> Fixes: 7785bba299a8 ("esp: Add a software GRO codepath")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/xfrm/xfrm_input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index 144238a50f3d..6f9576352f30 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -742,7 +742,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>  			gro_cells_receive(&gro_cells, skb);
>  			return err;
>  		}
> -
> +		kfree_skb(skb);
>  		return err;
>  	}

Did you test this? The function behind the 'afinfo->the transport_finish()'
pointer handles this skb and frees it in that case.
