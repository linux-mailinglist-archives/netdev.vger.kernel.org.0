Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF85289EF7
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 09:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgJJHdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 03:33:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729238AbgJJHcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 03:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602315125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3smJnnUNNJVW08T6/JEs8wo9FTXzfgaaDu4X4ohk75g=;
        b=dwbofwSyGsJAnpVgrdYTDqVAvkEh9RqoWL4XgvO4invxEqA30xzGiafrFY9klbd1NMTkhS
        yOU9RrRo9ahy4guLwwuMrs4n1mLdYrpqAZk0KSFjde9iCsX8NVnE12sW5cIXql/XealgFT
        K/grYz3rrnLsil3KYWJop4P1hh05DFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-3gHG7GwIPQS-bW_Dcxw8gA-1; Sat, 10 Oct 2020 03:32:00 -0400
X-MC-Unique: 3gHG7GwIPQS-bW_Dcxw8gA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 754983FE7;
        Sat, 10 Oct 2020 07:31:59 +0000 (UTC)
Received: from [10.72.13.27] (ovpn-13-27.pek2.redhat.com [10.72.13.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 681C755786;
        Sat, 10 Oct 2020 07:31:53 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: should keep avail_index despite device status
To:     Si-Wei Liu <si-wei.liu@oracle.com>, netdev@vger.kernel.org,
        mst@redhat.com
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1601583511-15138-1-git-send-email-si-wei.liu@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f3d1af9e-9164-dd42-1de4-7a40da46abba@redhat.com>
Date:   Sat, 10 Oct 2020 15:31:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1601583511-15138-1-git-send-email-si-wei.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/2 上午4:18, Si-Wei Liu wrote:
> A VM with mlx5 vDPA has below warnings while being reset:
>
> vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
> vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)
>
> We should allow userspace emulating the virtio device be
> able to get to vq's avail_index, regardless of vDPA device
> status. Save the index that was last seen when virtq was
> stopped, so that userspace doesn't complain.
>
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 70676a6..74264e59 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1133,15 +1133,17 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>   	if (!mvq->initialized)
>   		return;
>   
> -	if (query_virtqueue(ndev, mvq, &attr)) {
> -		mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> -		return;
> -	}
>   	if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
>   		return;
>   
>   	if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
>   		mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
> +
> +	if (query_virtqueue(ndev, mvq, &attr)) {
> +		mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> +		return;
> +	}
> +	mvq->avail_idx = attr.available_index;
>   }
>   
>   static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> @@ -1411,8 +1413,14 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>   	struct mlx5_virtq_attr attr;
>   	int err;
>   
> -	if (!mvq->initialized)
> -		return -EAGAIN;
> +	/* If the virtq object was destroyed, use the value saved at
> +	 * the last minute of suspend_vq. This caters for userspace
> +	 * that cares about emulating the index after vq is stopped.
> +	 */
> +	if (!mvq->initialized) {
> +		state->avail_index = mvq->avail_idx;
> +		return 0;
> +	}
>   
>   	err = query_virtqueue(ndev, mvq, &attr);
>   	if (err) {

