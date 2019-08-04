Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092F580B0C
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 14:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfHDM7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 08:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbfHDM7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 08:59:02 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B804206C1;
        Sun,  4 Aug 2019 12:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564923541;
        bh=vfQ5c7E4RyLpa5ot8AofSGWxzc5hrr2Zrq97933cUnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oMobUdKWKkBQRn6k1Pno/ICxDpI2iFgTC8KZbp6kT9OEWf15ISumu57tVoMsJWSfK
         7mj/cosRzrTOR/w/W3DToV2GPJ8lk8cn1YrT3u8eZLy8WiLDOD+AcrYIv9KmOM8TB3
         NT1dbdPIOXif12FRyxS3Oc3x+sR8iKEOuoixnRWk=
Date:   Sun, 4 Aug 2019 15:58:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Message-ID: <20190804125858.GJ4832@mtr-leonro.mtl.com>
References: <20190802164828.20243-1-hslester96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802164828.20243-1-hslester96@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 03, 2019 at 12:48:28AM +0800, Chuhong Yuan wrote:
> refcount_t is better for reference counters since its
> implementation can prevent overflows.
> So convert atomic_t ref counters to refcount_t.

I'm not thrilled to see those automatic conversion patches, especially
for flows which can't overflow. There is nothing wrong in using atomic_t
type of variable, do you have in mind flow which will cause to overflow?

Thanks
>
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
> Changes in v2:
>   - Add #include.
>
>  drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
> index b9d4f4e19ff9..148b55c3db7a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
> @@ -32,6 +32,7 @@
>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/refcount.h>
>  #include <linux/mlx5/driver.h>
>  #include <net/vxlan.h>
>  #include "mlx5_core.h"
> @@ -48,7 +49,7 @@ struct mlx5_vxlan {
>
>  struct mlx5_vxlan_port {
>  	struct hlist_node hlist;
> -	atomic_t refcount;
> +	refcount_t refcount;
>  	u16 udp_port;
>  };
>
> @@ -113,7 +114,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
>
>  	vxlanp = mlx5_vxlan_lookup_port(vxlan, port);
>  	if (vxlanp) {
> -		atomic_inc(&vxlanp->refcount);
> +		refcount_inc(&vxlanp->refcount);
>  		return 0;
>  	}
>
> @@ -137,7 +138,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
>  	}
>
>  	vxlanp->udp_port = port;
> -	atomic_set(&vxlanp->refcount, 1);
> +	refcount_set(&vxlanp->refcount, 1);
>
>  	spin_lock_bh(&vxlan->lock);
>  	hash_add(vxlan->htable, &vxlanp->hlist, port);
> @@ -170,7 +171,7 @@ int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
>  		goto out_unlock;
>  	}
>
> -	if (atomic_dec_and_test(&vxlanp->refcount)) {
> +	if (refcount_dec_and_test(&vxlanp->refcount)) {
>  		hash_del(&vxlanp->hlist);
>  		remove = true;
>  	}
> --
> 2.20.1
>
