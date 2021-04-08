Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A56357FA0
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhDHJpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:45:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231392AbhDHJpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 05:45:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617875106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=42x2upVyYod6eEZwxNE9tSmc24Wlu+lcP45ZijnXyiM=;
        b=IICAilTcuVz2+FD2tPP6XO0wDByxHPillh5ZpIKcy/FdIkfCCxJH+Shh9lcoRQPidFBNR+
        dOERhq1JO1WA9n8I5CpMxgs73XmIKvw3ruslGOUYc88TjbIHaE51TPW7DhGdXLnh6vb4DD
        TyVWZC9/rPpcvkAUf4j2E5XKcywt2Mk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-PX7V1EInNKmfGvDHRpwAKA-1; Thu, 08 Apr 2021 05:45:01 -0400
X-MC-Unique: PX7V1EInNKmfGvDHRpwAKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 550078189C6;
        Thu,  8 Apr 2021 09:44:55 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-53.pek2.redhat.com [10.72.13.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 768E65D71D;
        Thu,  8 Apr 2021 09:44:49 +0000 (UTC)
Subject: Re: [PATCH 2/5] vdpa/mlx5: Use the correct dma device when
 registering memory
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com, parav@nvidia.com,
        si-wei.liu@oracle.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210408091047.4269-1-elic@nvidia.com>
 <20210408091047.4269-3-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <37f7982a-d065-1c2e-abcf-00e9fbc5732a@redhat.com>
Date:   Thu, 8 Apr 2021 17:44:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408091047.4269-3-elic@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/8 ÏÂÎç5:10, Eli Cohen Ð´µÀ:
> In cases where the vdpa instance uses a SF (sub function), the DMA
> device is the parent device. Use a function to retrieve the correct DMA
> device.
>
> Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/mlx5/core/mr.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index d300f799efcd..3908ff28eec0 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -219,6 +219,11 @@ static void destroy_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_m
>   	mlx5_vdpa_destroy_mkey(mvdev, &mkey->mkey);
>   }
>   
> +static struct device *get_dma_device(struct mlx5_vdpa_dev *mvdev)
> +{
> +	return &mvdev->mdev->pdev->dev;
> +}
> +
>   static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr,
>   			 struct vhost_iotlb *iotlb)
>   {
> @@ -234,7 +239,7 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
>   	u64 pa;
>   	u64 paend;
>   	struct scatterlist *sg;
> -	struct device *dma = mvdev->mdev->device;
> +	struct device *dma = get_dma_device(mvdev);
>   
>   	for (map = vhost_iotlb_itree_first(iotlb, mr->start, mr->end - 1);
>   	     map; map = vhost_iotlb_itree_next(map, start, mr->end - 1)) {
> @@ -291,7 +296,7 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
>   
>   static void unmap_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
>   {
> -	struct device *dma = mvdev->mdev->device;
> +	struct device *dma = get_dma_device(mvdev);
>   
>   	destroy_direct_mr(mvdev, mr);
>   	dma_unmap_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);

