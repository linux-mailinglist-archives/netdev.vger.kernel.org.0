Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558596E05CC
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDMEKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjDMEJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:09:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A149778
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2847F633DE
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248F0C433EF;
        Thu, 13 Apr 2023 04:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681358897;
        bh=1Scbp7tQff2W0CG9YzqTB4ukEzAJVYXq8XuEwU4M338=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HR6wZ9XucAL8omu+IRvhG72RMF0sEXEu7PDnwXMoRm6LLglmGSDD2fCwb6UtRaR38
         x3mgOsSKWKpKLCaLaPT9y1R1ZdnDKN6RCQn1N6vUXxetbU+m4o+Jetxw+urCMq733O
         WwgXHyyhVJVsArmNnO6+dVm69ZvS74HHrw0ua65x83f7UDkbri4U1fiQS6SQK3C8xm
         t1LJL8CQuLqNVCI8cYtd2xT64RzG6ZQBw38EjDlu75+4jk3po3/V9W9RR1YI1cenFc
         xfhBu5ddZ+epI3sdi/eepFMs0WCn4QUZiIQdoHEGBiyETYpVdbHb4wIVhcM4W5LzYP
         1QXYtUe0FvNmw==
Date:   Wed, 12 Apr 2023 21:08:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     ilias.apalodimas@linaro.org, edumazet@google.com, hawk@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        alexander.duyck@gmail.com, linyunsheng@huawei.com
Subject: Re: [PATCH v3] skbuff: Fix a race between coalescing and releasing
 SKBs
Message-ID: <20230412210816.072b5fe3@kernel.org>
In-Reply-To: <20230411022640.8453-1-liangchen.linux@gmail.com>
References: <20230411022640.8453-1-liangchen.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 10:26:40 +0800 Liang Chen wrote:
>  	/* In general, avoid mixing slab allocated and page_pool allocated
> -	 * pages within the same SKB. However when @to is not pp_recycle and
> -	 * @from is cloned, we can transition frag pages from page_pool to
> -	 * reference counted.
> -	 *
> -	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
> -	 * @from is cloned, in case the SKB is using page_pool fragment
> -	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
> -	 * references for cloned SKBs at the moment that would result in
> -	 * inconsistent reference counts.
> +	 * pages within the same SKB. However don't allow coalescing two

The word 'however' no longer works here because there's no
contradiction, it's an additional rule.

> +	 * pp_recycle SKBs if @from is cloned, in case the SKB is using
> +	 * page_pool fragment references (PP_FLAG_PAGE_FRAG). Since we only
> +	 * take full page references for cloned SKBs at the moment that would
> +	 * result in inconsistent reference counts.
>  	 */
> -	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
> +	if (to->pp_recycle != from->pp_recycle ||
> +	    (from->pp_recycle && skb_cloned(from)))

How about we change the comment to:

 	/* In general, avoid mixing page_pool and non-page_pool allocated
 	 * pages within the same SKB. Additionally avoid dealing with clones
 	 * containing page_pool pages, in case the SKB is using page_pool fragment
	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
	 * references for cloned SKBs at the moment that would result in
	 * inconsistent reference counts.
	 * In theory we could take full references if from is cloned and 
	 * !@to->pp_recycle but its tricky (due to potential race with the clone 
 	 * disappearing) and rare, so not worth dealing with.
 	 */

Please also add:

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")

and Eric's review tag.
