Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797432EC958
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 05:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbhAGERe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 23:17:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726812AbhAGERe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 23:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609992967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dos1Q591nOCwG8WlJAPmJhU7Mm8ZerxmXOCBcJyNvs4=;
        b=GUsGs1IUaCXsCHsPM5wa81unwFjqKWOM6yh7Y67ir56utZ22chwDTseE2hwZXAVu2V3t0t
        wfmS6YFK5Odz0+AqCYCgEecAhWj2kwqbgbcemiIWKCF8qz0fbYx8dGX8xab9xDgekFN0DM
        DruK3cCgLyIUBoXv3Qqayrdhw45TArw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-jcuqMUzmPi2B4NMTwRptXg-1; Wed, 06 Jan 2021 23:16:04 -0500
X-MC-Unique: jcuqMUzmPi2B4NMTwRptXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABA8C10054FF;
        Thu,  7 Jan 2021 04:16:02 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B3C55C1D1;
        Thu,  7 Jan 2021 04:15:54 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: Fix memory key MTT population
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     lulu@redhat.com
References: <20210106090557.GA170338@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2d16b2af-f25a-d786-7d24-da45c0dcefaa@redhat.com>
Date:   Thu, 7 Jan 2021 12:15:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210106090557.GA170338@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/6 下午5:05, Eli Cohen wrote:
> map_direct_mr() assumed that the number of scatter/gather entries
> returned by dma_map_sg_attrs() was equal to the number of segments in
> the sgl list. This led to wrong population of the mkey object. Fix this
> by properly referring to the returned value.
>
> In addition, get rid of fill_sg() whjich effect is overwritten bu
> populate_mtts().


Typo.


>
> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>   drivers/vdpa/mlx5/core/mlx5_vdpa.h |  1 +
>   drivers/vdpa/mlx5/core/mr.c        | 28 ++++++++++++----------------
>   2 files changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> index 5c92a576edae..08f742fd2409 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -15,6 +15,7 @@ struct mlx5_vdpa_direct_mr {
>   	struct sg_table sg_head;
>   	int log_size;
>   	int nsg;
> +	int nent;
>   	struct list_head list;
>   	u64 offset;
>   };
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index 4b6195666c58..d300f799efcd 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -25,17 +25,6 @@ static int get_octo_len(u64 len, int page_shift)
>   	return (npages + 1) / 2;
>   }
>   
> -static void fill_sg(struct mlx5_vdpa_direct_mr *mr, void *in)
> -{
> -	struct scatterlist *sg;
> -	__be64 *pas;
> -	int i;
> -
> -	pas = MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
> -	for_each_sg(mr->sg_head.sgl, sg, mr->nsg, i)
> -		(*pas) = cpu_to_be64(sg_dma_address(sg));
> -}
> -
>   static void mlx5_set_access_mode(void *mkc, int mode)
>   {
>   	MLX5_SET(mkc, mkc, access_mode_1_0, mode & 0x3);
> @@ -45,10 +34,18 @@ static void mlx5_set_access_mode(void *mkc, int mode)
>   static void populate_mtts(struct mlx5_vdpa_direct_mr *mr, __be64 *mtt)
>   {
>   	struct scatterlist *sg;
> +	int nsg = mr->nsg;
> +	u64 dma_addr;
> +	u64 dma_len;
> +	int j = 0;
>   	int i;
>   
> -	for_each_sg(mr->sg_head.sgl, sg, mr->nsg, i)
> -		mtt[i] = cpu_to_be64(sg_dma_address(sg));
> +	for_each_sg(mr->sg_head.sgl, sg, mr->nent, i) {
> +		for (dma_addr = sg_dma_address(sg), dma_len = sg_dma_len(sg);
> +		     nsg && dma_len;
> +		     nsg--, dma_addr += BIT(mr->log_size), dma_len -= BIT(mr->log_size))
> +			mtt[j++] = cpu_to_be64(dma_addr);


It looks to me the mtt entry is also limited by log_size. It's better to 
explain this a little bit in the commit log.

Thanks


> +	}
>   }
>   
>   static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
> @@ -64,7 +61,6 @@ static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct
>   		return -ENOMEM;
>   
>   	MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
> -	fill_sg(mr, in);
>   	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
>   	MLX5_SET(mkc, mkc, lw, !!(mr->perm & VHOST_MAP_WO));
>   	MLX5_SET(mkc, mkc, lr, !!(mr->perm & VHOST_MAP_RO));
> @@ -276,8 +272,8 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
>   done:
>   	mr->log_size = log_entity_size;
>   	mr->nsg = nsg;
> -	err = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
> -	if (!err)
> +	mr->nent = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
> +	if (!mr->nent)
>   		goto err_map;
>   
>   	err = create_direct_mr(mvdev, mr);

