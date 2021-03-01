Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B643278A1
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 08:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhCAHy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 02:54:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232630AbhCAHy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 02:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614585179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0CNsQ5PANkIBnhwAb5s093rNx2yiWanVGyrgP1R4R4=;
        b=SLtD17zJDmikrX7aX9/5Qqv4I/HSXaZc9nYvPV/6KeP5eLj1DfQKNlwR6s+cDc2PPRQMBR
        xqLHdpdOeFtdbLWzYA7RP/RhOuUNrh6IlIDKf6tdAuYzWAn/IitAUF4B3LDxXhExBV/Fov
        b9yQyUH9B0oAiu52LyZ56aX7BUVdlxw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-og48gR6wNbKswwmGmqyYpw-1; Mon, 01 Mar 2021 02:52:54 -0500
X-MC-Unique: og48gR6wNbKswwmGmqyYpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8770E107ACF5;
        Mon,  1 Mar 2021 07:52:53 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CC1C6A8EA;
        Mon,  1 Mar 2021 07:52:47 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: Fix wrong use of bit numbers
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20210301062817.39331-1-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <959916f2-5fc9-bdb4-31ca-632fe0d98979@redhat.com>
Date:   Mon, 1 Mar 2021 15:52:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210301062817.39331-1-elic@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/1 2:28 下午, Eli Cohen wrote:
> VIRTIO_F_VERSION_1 is a bit number. Use BIT_ULL() with mask
> conditionals.
>
> Also, in mlx5_vdpa_is_little_endian() use BIT_ULL for consistency with
> the rest of the code.
>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index dc7031132fff..7d21b857a94a 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -821,7 +821,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
>   	MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
>   	MLX5_SET(virtio_q, vq_ctx, queue_size, mvq->num_ent);
>   	MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0,
> -		 !!(ndev->mvdev.actual_features & VIRTIO_F_VERSION_1));
> +		 !!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_F_VERSION_1)));
>   	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
>   	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
>   	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
> @@ -1578,7 +1578,7 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
>   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
>   {
>   	return virtio_legacy_is_little_endian() ||
> -		(mvdev->actual_features & (1ULL << VIRTIO_F_VERSION_1));
> +		(mvdev->actual_features & BIT_ULL(VIRTIO_F_VERSION_1));
>   }
>   
>   static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u16 val)

