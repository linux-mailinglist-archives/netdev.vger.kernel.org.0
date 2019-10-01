Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6A3C38B2
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbfJAPOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:14:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:42270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389129AbfJAPOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 11:14:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 71301AFC6;
        Tue,  1 Oct 2019 15:14:40 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E9E8FE0083; Tue,  1 Oct 2019 17:14:39 +0200 (CEST)
Date:   Tue, 1 Oct 2019 17:14:39 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>, Alex Vesker <valex@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Message-ID: <20191001151439.GA24815@unicorn.suse.cz>
References: <20190930141316.GG29694@zn.tnic>
 <20190930154535.GC22120@unicorn.suse.cz>
 <20190930162910.GI29694@zn.tnic>
 <20190930095516.0f55513a@hermes.lan>
 <20190930184031.GJ29694@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930184031.GJ29694@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 08:40:31PM +0200, Borislav Petkov wrote:
> On Mon, Sep 30, 2019 at 09:55:16AM -0700, Stephen Hemminger wrote:
> > Could also us div_u64_rem here?
> 
> Yah, the below seems to work and the resulting asm looks sensible to me
> but someone should definitely double-check me as I don't know this code
> at all.
> 
> Thx.
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
> index 913f1e5aaaf2..b4302658e5f8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
> @@ -137,7 +137,7 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool,
>  
>  	icm_mr->icm_start_addr = icm_mr->dm.addr;
>  
> -	align_diff = icm_mr->icm_start_addr % align_base;
> +	div_u64_rem(icm_mr->icm_start_addr, align_base, &align_diff);
>  	if (align_diff)
>  		icm_mr->used_length = align_base - align_diff;
>  
> 

While this fixes 32-bit builds, it breaks 64-bit ones as align_diff is
64-bit and div_u64_rem expects pointer to u32. :-(

I checked that align_base is always a power of two so that we could get
away with

	align_diff = icm_mr->icm_start_addr & (align_base - 1)

I'm not sure, however, if it's safe to assume align_base will always
have to be a power of two or if we should add a check for safety.

(Cc-ing also author of commit 29cf8febd185 ("net/mlx5: DR, ICM pool
memory allocator").)

Michal
