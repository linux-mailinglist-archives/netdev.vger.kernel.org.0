Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5925308462
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhA2Dt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:49:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231517AbhA2Dt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:49:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611892108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fzFvyTbz2UvsYBfZzFs744TP0/6WmLw0eTkB57Sb6vo=;
        b=NXBNcHcMKicBnjUOBdQcRrxOWfBU20F7EGpgZ9QjyvEGCp9qeVukEVvrRkyx3YvttF95c+
        FXgwE/S4MXJR8AOWujujNJPKMrm+z70f60s0UsNx5UkkvPSqqJRRqck4+3AxqFC9FukRdM
        KassqO0RsWu9x2vBHgXSZlitGIIj/+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-sGcZvseiNOaFYvzAPvTNQg-1; Thu, 28 Jan 2021 22:48:26 -0500
X-MC-Unique: sGcZvseiNOaFYvzAPvTNQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAACA10054FF;
        Fri, 29 Jan 2021 03:48:25 +0000 (UTC)
Received: from [10.72.14.10] (ovpn-14-10.pek2.redhat.com [10.72.14.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D91DA2B394;
        Fri, 29 Jan 2021 03:48:20 +0000 (UTC)
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-2-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <024560f4-51bd-af11-a9aa-48682d4e7f5f@redhat.com>
Date:   Fri, 29 Jan 2021 11:48:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128134130.3051-2-elic@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/28 下午9:41, Eli Cohen wrote:
> suspend_vq should only suspend the VQ on not save the current available
> index. This is done when a change of map occurs when the driver calls
> save_channel_info().
>
> Signed-off-by: Eli Cohen <elic@nvidia.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 88dde3455bfd..549ded074ff3 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
>   
>   static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
>   {
> -	struct mlx5_virtq_attr attr;
> -
>   	if (!mvq->initialized)
>   		return;
>   
> @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>   
>   	if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
>   		mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
> -
> -	if (query_virtqueue(ndev, mvq, &attr)) {
> -		mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> -		return;
> -	}
> -	mvq->avail_idx = attr.available_index;
>   }
>   
>   static void suspend_vqs(struct mlx5_vdpa_net *ndev)

