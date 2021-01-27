Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8183051D3
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhA0FRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:17:39 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:40733 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237652AbhA0D5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 22:57:08 -0500
Received: from localhost (kumbhalgarh.blr.asicdesigners.com [10.193.185.255])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 10R3u5WG000912;
        Tue, 26 Jan 2021 19:56:06 -0800
Date:   Wed, 27 Jan 2021 09:26:06 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     Yang Li <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] cxgb4: remove redundant NULL check
Message-ID: <20210127035604.GA21071@chelsio.com>
References: <1611568045-121839-1-git-send-email-abaci-bugfix@linux.alibaba.com>
 <1611568045-121839-4-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611568045-121839-4-git-send-email-abaci-bugfix@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, January 01/25/21, 2021 at 17:47:25 +0800, Yang Li wrote:
> Fix below warnings reported by coccicheck:
>  ./drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c:533:2-8: WARNING:
> NULL check before some freeing functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
> index dede025..97a811f 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
> @@ -525,12 +525,10 @@ struct cxgb4_tc_u32_table *cxgb4_init_tc_u32(struct adapter *adap)
>  	for (i = 0; i < t->size; i++) {
>  		struct cxgb4_link *link = &t->table[i];
>  
> -		if (link->tid_map)
> -			kvfree(link->tid_map);

This patch is wrong. NAK.

What if the call to link->tid_map = kvcalloc() fails above? it still goes ahead
and calls kvfree(link->tid_map), which is wrong.


> +		kvfree(link->tid_map);
>  	}
>  
> -	if (t)
> -		kvfree(t);
> +	kvfree(t);
>  
>  	return NULL;
>  }
> -- 
> 1.8.3.1
> 
