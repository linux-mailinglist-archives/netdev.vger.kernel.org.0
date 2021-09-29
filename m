Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1928641C265
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245337AbhI2KPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:15:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:22647 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245330AbhI2KPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:15:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="221702740"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="221702740"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 03:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="554726505"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Sep 2021 03:13:32 -0700
Date:   Wed, 29 Sep 2021 14:14:57 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, nathan@kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] xsk: fix clang build error in __xp_alloc
Message-ID: <YVRYwRc9iUXuP8/v@boxer>
References: <20210929061403.8587-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929061403.8587-1-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 08:14:03AM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a build error with clang in __xp_alloc().
> 
> net/xdp/xsk_buff_pool.c:465:15: error: variable 'xskb' is uninitialized
> when used here [-Werror,-Wuninitialized]
>                         xp_release(xskb);
>                                    ^~~~
> 
> This is correctly detected by clang, but not gcc. In fact, the
> xp_release() statement should not be there at all in the refactored
> code, so just remove it.

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Fixes: 94033cd8e73b ("xsk: Optimize for aligned case")
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  net/xdp/xsk_buff_pool.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 96b14e51ba7e..90c4e1e819d3 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -462,7 +462,6 @@ static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
>  	for (;;) {
>  		if (!xskq_cons_peek_addr_unchecked(pool->fq, &addr)) {
>  			pool->fq->queue_empty_descs++;
> -			xp_release(xskb);
>  			return NULL;
>  		}
>  
> 
> base-commit: 72e1781a5de9e3ee804e24f7ce9a7dd85596fc51
> -- 
> 2.29.0
> 
