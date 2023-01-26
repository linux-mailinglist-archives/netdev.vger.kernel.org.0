Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E65167D971
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 00:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjAZXNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 18:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjAZXNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 18:13:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B1314E9C;
        Thu, 26 Jan 2023 15:13:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9556B81F2F;
        Thu, 26 Jan 2023 23:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40EFC433EF;
        Thu, 26 Jan 2023 23:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674774799;
        bh=Uk3vn6f4j+4L5HcPRZiVCz8GTDENn5DeqXvYOPL7KxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YPFHOElUkDrP0+ZWOYvjG2W0nIKLQ3Q7iTmKqaxoJyUme4YfxrsK/9ocxwtY2FxkP
         YMwG0qQn7ExAW7O2duRVd0JMPCd9pbkLb/H46P6n1P/iITKVnknj6HdBOBGmWOrCxa
         sX1RSLSpPb7FerRkXAvOCWbyqDBzX/EQbe3dAFMiWGUrmyUq99svPFrnrsdKrwPjo3
         10WDoLnO3/QVJgfelOlhVU9VcV2b6f6iWaHg2KqNrCX/8pFJp2FfuIhblT1abNTbuB
         XO2f4v68MqvJY7ZGCWv9eyxaXyc02V83kUnk9Szdq4fKFQ3SvoLMWUMOVUGm70U8Rs
         +EBC/qXZERckg==
Date:   Thu, 26 Jan 2023 15:13:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nbd@nbd.name, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        lorenzo@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in
 GRO
Message-ID: <20230126151317.73d67045@kernel.org>
In-Reply-To: <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
        <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 11:06:59 -0800 Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> GSO should not merge page pool recycled frames with standard reference
> counted frames. Traditionally this didn't occur, at least not often.
> However as we start looking at adding support for wireless adapters there
> becomes the potential to mix the two due to A-MSDU repartitioning frames in
> the receive path. There are possibly other places where this may have
> occurred however I suspect they must be few and far between as we have not
> seen this issue until now.
> 
> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>

Exciting investigation!
Felix, out of curiosity - the impact of loosing GRO on performance is
not significant enough to care?  We could possibly try to switch to
using the frag list if we can't merge into frags safely.

> diff --git a/net/core/gro.c b/net/core/gro.c
> index 506f83d715f8..4bac7ea6e025 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -162,6 +162,15 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>  	struct sk_buff *lp;
>  	int segs;
>  
> +	/* Do not splice page pool based packets w/ non-page pool
> +	 * packets. This can result in reference count issues as page
> +	 * pool pages will not decrement the reference count and will
> +	 * instead be immediately returned to the pool or have frag
> +	 * count decremented.
> +	 */
> +	if (p->pp_recycle != skb->pp_recycle)
> +		return -ETOOMANYREFS;
> 
>  	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
>  	gro_max_size = READ_ONCE(p->dev->gro_max_size);
>  
> 
> 

