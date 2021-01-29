Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEEF30846A
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhA2Dv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:51:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231878AbhA2DvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611892195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wOMLsnl3srevdmRDL22qVzg7hZeq9Vx6iIhsGCDt5g=;
        b=RvRsDBAitIKccBq9TyYEweAYh4dDdyJOfNVMLE+71IE50StzOkbYIrho8fCOF/z6VAaQlC
        nH9iA+3vECwDjTuFti6AtWbeR1X0Cd0fCnT23TSL6VCMY4DD3ubtN0OzobKWdneP+T1iT4
        QvsgmpiuT0VB0mT0QLixSSX2/7LsBOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-bVMfGUOKOKOQJgtd-AiNww-1; Thu, 28 Jan 2021 22:49:53 -0500
X-MC-Unique: bVMfGUOKOKOQJgtd-AiNww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0FEA107ACE3;
        Fri, 29 Jan 2021 03:49:51 +0000 (UTC)
Received: from [10.72.14.10] (ovpn-14-10.pek2.redhat.com [10.72.14.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E0221894E;
        Fri, 29 Jan 2021 03:49:46 +0000 (UTC)
Subject: Re: [PATCH 2/2] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-3-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <54239b51-918c-3475-dc88-4da1a4548da8@redhat.com>
Date:   Fri, 29 Jan 2021 11:49:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128134130.3051-3-elic@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/28 下午9:41, Eli Cohen wrote:
> When a change of memory map occurs, the hardware resources are destroyed
> and then re-created again with the new memory map. In such case, we need
> to restore the hardware available and used indices. The driver failed to
> restore the used index which is added here.
>
> Fixes 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>


A question. Does this mean after a vq is suspended, the hw used index is 
not equal to vq used index?

Thanks


> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 549ded074ff3..3fc8588cecae 100644
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
> @@ -1602,6 +1607,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>   		return err;
>   
>   	ri->avail_index = attr.available_index;
> +	ri->used_index = attr.used_index;
>   	ri->ready = mvq->ready;
>   	ri->num_ent = mvq->num_ent;
>   	ri->desc_addr = mvq->desc_addr;
> @@ -1646,6 +1652,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
>   			continue;
>   
>   		mvq->avail_idx = ri->avail_index;
> +		mvq->used_idx = ri->used_index;
>   		mvq->ready = ri->ready;
>   		mvq->num_ent = ri->num_ent;
>   		mvq->desc_addr = ri->desc_addr;

