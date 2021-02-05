Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CF43103EE
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhBED6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:58:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20555 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230170AbhBED6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 22:58:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612497444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XNDRjK2k4hYr251fYAwJiovjLPZ7/aDsH67J1vk1NvU=;
        b=gNs2cZ5trGgVzgqmxfSOBsyHiWoSDEIzuFPQ5dE+JEaAXkGLDvxtz+qBnwsqPL6h7V68Hl
        7EArTsAtnLvD5ZZFmdp3ExlsnXTOLbHCMmYg4aA2mJdthGtNL+Den7lh84IxLMVziviyYZ
        SNvE4HYIujgt5wuxm0EOf+f+RoNcYeQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-_eQcZEbrMcyx-IifS4jTFA-1; Thu, 04 Feb 2021 22:57:22 -0500
X-MC-Unique: _eQcZEbrMcyx-IifS4jTFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E578AFA80;
        Fri,  5 Feb 2021 03:57:21 +0000 (UTC)
Received: from [10.72.12.112] (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 616AA2B0A5;
        Fri,  5 Feb 2021 03:57:15 +0000 (UTC)
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com, si-wei.liu@oracle.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     lulu@redhat.com
References: <20210204073618.36336-1-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a23e0ea0-8471-4c97-73c5-e6e8fcf634ea@redhat.com>
Date:   Fri, 5 Feb 2021 11:57:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210204073618.36336-1-elic@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/4 下午3:36, Eli Cohen wrote:
> When a change of memory map occurs, the hardware resources are destroyed
> and then re-created again with the new memory map. In such case, we need
> to restore the hardware available and used indices. The driver failed to
> restore the used index which is added here.
>
> Also, since the driver also fails to reset the available and used
> indices upon device reset, fix this here to avoid regression caused by
> the fact that used index may not be zero upon device reset.
>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
> v0 -> v1:
> Clear indices upon device reset


Acked-by: Jason Wang <jasowang@redhat.com>


>
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 88dde3455bfd..b5fe6d2ad22f 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
>   	u64 device_addr;
>   	u64 driver_addr;
>   	u16 avail_index;
> +	u16 used_index;
>   	bool ready;
>   	struct vdpa_callback cb;
>   	bool restore;
> @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
>   	u32 virtq_id;
>   	struct mlx5_vdpa_net *ndev;
>   	u16 avail_idx;
> +	u16 used_idx;
>   	int fw_state;
>   
>   	/* keep last in the struct */
> @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
>   
>   	obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in, obj_context);
>   	MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail_idx);
> +	MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
>   	MLX5_SET(virtio_net_q_object, obj_context, queue_feature_bit_mask_12_3,
>   		 get_features_12_3(ndev->mvdev.actual_features));
>   	vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
> @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>   struct mlx5_virtq_attr {
>   	u8 state;
>   	u16 available_index;
> +	u16 used_index;
>   };
>   
>   static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq,
> @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
>   	memset(attr, 0, sizeof(*attr));
>   	attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
>   	attr->available_index = MLX5_GET(virtio_net_q_object, obj_context, hw_available_index);
> +	attr->used_index = MLX5_GET(virtio_net_q_object, obj_context, hw_used_index);
>   	kfree(out);
>   	return 0;
>   
> @@ -1535,6 +1540,16 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
>   	}
>   }
>   
> +static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
> +{
> +	int i;
> +
> +	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
> +		ndev->vqs[i].avail_idx = 0;
> +		ndev->vqs[i].used_idx = 0;
> +	}
> +}
> +
>   /* TODO: cross-endian support */
>   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
>   {
> @@ -1610,6 +1625,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>   		return err;
>   
>   	ri->avail_index = attr.available_index;
> +	ri->used_index = attr.used_index;
>   	ri->ready = mvq->ready;
>   	ri->num_ent = mvq->num_ent;
>   	ri->desc_addr = mvq->desc_addr;
> @@ -1654,6 +1670,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
>   			continue;
>   
>   		mvq->avail_idx = ri->avail_index;
> +		mvq->used_idx = ri->used_index;
>   		mvq->ready = ri->ready;
>   		mvq->num_ent = ri->num_ent;
>   		mvq->desc_addr = ri->desc_addr;
> @@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>   	if (!status) {
>   		mlx5_vdpa_info(mvdev, "performing device reset\n");
>   		teardown_driver(ndev);
> +		clear_virtqueues(ndev);
>   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>   		ndev->mvdev.status = 0;
>   		ndev->mvdev.mlx_features = 0;

