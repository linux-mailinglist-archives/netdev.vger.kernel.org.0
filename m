Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78415667C4
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiGEKVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiGEKVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:21:35 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Jul 2022 03:21:32 PDT
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 808AD140CE;
        Tue,  5 Jul 2022 03:21:32 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 87D8128BBF;
        Tue,  5 Jul 2022 13:06:01 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 1F2D628C43;
        Tue,  5 Jul 2022 13:06:00 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 23C2E3C0437;
        Tue,  5 Jul 2022 13:05:56 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 265A5tFs007839;
        Tue, 5 Jul 2022 13:05:56 +0300
Date:   Tue, 5 Jul 2022 13:05:54 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: ipvs: Use the bitmap API to allocate
 bitmaps
In-Reply-To: <420d8b70560e8711726ff639f0a55364e212ff26.1656962678.git.christophe.jaillet@wanadoo.fr>
Message-ID: <b69d7ba1-22f8-80c3-c870-debd7aaf4cea@ssi.bg>
References: <420d8b70560e8711726ff639f0a55364e212ff26.1656962678.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 4 Jul 2022, Christophe JAILLET wrote:

> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

	Looks good to me for -next! Thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_mh.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
> index da0280cec506..e3d7f5c879ce 100644
> --- a/net/netfilter/ipvs/ip_vs_mh.c
> +++ b/net/netfilter/ipvs/ip_vs_mh.c
> @@ -174,8 +174,7 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
>  		return 0;
>  	}
>  
> -	table = kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> -			sizeof(unsigned long), GFP_KERNEL);
> +	table = bitmap_zalloc(IP_VS_MH_TAB_SIZE, GFP_KERNEL);
>  	if (!table)
>  		return -ENOMEM;
>  
> @@ -227,7 +226,7 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
>  	}
>  
>  out:
> -	kfree(table);
> +	bitmap_free(table);
>  	return 0;
>  }
>  
> -- 
> 2.34.1

Regards

--
Julian Anastasov <ja@ssi.bg>

