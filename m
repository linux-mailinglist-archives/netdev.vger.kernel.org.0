Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB27630535E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhA0Gor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:44:47 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:38427 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhA0GgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 01:36:17 -0500
Received: from localhost (kumbhalgarh.blr.asicdesigners.com [10.193.185.255])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 10R6YRFJ001537;
        Tue, 26 Jan 2021 22:34:28 -0800
Date:   Wed, 27 Jan 2021 12:04:27 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     Yang Li <abaci-bugfix@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] cxgb4: remove redundant NULL check
Message-ID: <20210127063426.GC21071@chelsio.com>
References: <1611629413-81373-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611629413-81373-1-git-send-email-abaci-bugfix@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, January 01/26/21, 2021 at 10:50:13 +0800, Yang Li wrote:
> Fix below warnings reported by coccicheck:
> ./drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c:323:3-9: WARNING:
> NULL check before some freeing functions is not needed.
> ./drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c:3554:2-8: WARNING:
> NULL check before some freeing functions is not needed.
> ./drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c:157:2-7: WARNING:
> NULL check before some freeing functions is not needed.
> ./drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c:525:3-9: WARNING:
> NULL check before some freeing functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c     | 3 +--
>  drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 3 +--
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c  | 3 +--
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c | 6 ++----
>  4 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
> index ce28820..12fcf84 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
> @@ -323,8 +323,7 @@ void t4_cleanup_clip_tbl(struct adapter *adap)
>  	struct clip_tbl *ctbl = adap->clipt;
>  
>  	if (ctbl) {
> -		if (ctbl->cl_list)
> -			kvfree(ctbl->cl_list);
> +		kvfree(ctbl->cl_list);
>  		kvfree(ctbl);
>  	}
>  }
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> index 75474f8..94eb8a6 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> @@ -3554,8 +3554,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
>  	}
>  
>  out_free:
> -	if (data)
> -		kvfree(data);
> +	kvfree(data);
>  
>  #undef QDESC_GET_FLQ
>  #undef QDESC_GET_RXQ
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
> index 77648e4..dd66b24 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
> @@ -157,8 +157,7 @@ static int cudbg_alloc_compress_buff(struct cudbg_init *pdbg_init)
>  
>  static void cudbg_free_compress_buff(struct cudbg_init *pdbg_init)
>  {
> -	if (pdbg_init->compress_buff)

NAK. The above check is necessary.

pdbg_init->compress_buff may be NULL when Zlib is unavailable or when
pdbg_init->compress_buff allocation fails, in which case we ignore error
and continue without compression. Check is necessary before calling
vfree().

> -		vfree(pdbg_init->compress_buff);
> +	vfree(pdbg_init->compress_buff);
>  }
>  
>  int cxgb4_cudbg_collect(struct adapter *adap, void *buf, u32 *buf_size,
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
> +		kvfree(link->tid_map);

The above change is wrong. NAK.

If the call to link->tid_map = kvcalloc() above fails, it still
goes ahead and calls kvfree(link->tid_map) even for failed cases, which is
wrong. Check is necessary before calling kvfree().


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
