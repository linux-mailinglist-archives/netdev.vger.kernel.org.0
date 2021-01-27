Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352BB305101
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbhA0Efj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:35:39 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:28778 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238121AbhA0EGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 23:06:39 -0500
Received: from localhost (kumbhalgarh.blr.asicdesigners.com [10.193.185.255])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 10R45lLT000954;
        Tue, 26 Jan 2021 20:05:48 -0800
Date:   Wed, 27 Jan 2021 09:35:47 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     Yang Li <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] cxgb4: remove redundant NULL check
Message-ID: <20210127040545.GB21071@chelsio.com>
References: <1611568045-121839-1-git-send-email-abaci-bugfix@linux.alibaba.com>
 <1611568045-121839-3-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611568045-121839-3-git-send-email-abaci-bugfix@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, January 01/25/21, 2021 at 17:47:24 +0800, Yang Li wrote:
> Fix below warnings reported by coccicheck:
> ./drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c:161:2-7: WARNING:
> NULL check before some freeing functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
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
and continue without compression.

> -		vfree(pdbg_init->compress_buff);
> +	vfree(pdbg_init->compress_buff);
>  }
>  
>  int cxgb4_cudbg_collect(struct adapter *adap, void *buf, u32 *buf_size,
> -- 
> 1.8.3.1
> 
