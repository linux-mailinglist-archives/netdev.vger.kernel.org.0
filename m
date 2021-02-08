Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223E43129CC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 05:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhBHEjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 23:39:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229590AbhBHEjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 23:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612759054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AXyJJxjVxwqQYUGq8cjXowIkJ5w7ooor07ZQr4A7YuY=;
        b=DKoyP3hD3h7y0/ZKU7vHPen+rVClgp04DKMYJ0PegFqfThrSz9Duqc+VIM1ieG4ZVQyx5b
        bBIkXkhn4SRVdEw4xJt2Jnb1hKFe69VcSY3AxKT13SA9RWwtJJxKmRCBt12FUKgq671E62
        nSJkNgb7MI7dXAaGDDxdzGlcvZU0ewA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-1ibjxQD5NdS8YIl3FSaJFw-1; Sun, 07 Feb 2021 23:37:32 -0500
X-MC-Unique: 1ibjxQD5NdS8YIl3FSaJFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32416192D786;
        Mon,  8 Feb 2021 04:37:31 +0000 (UTC)
Received: from [10.72.13.185] (ovpn-13-185.pek2.redhat.com [10.72.13.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 436F05C1C2;
        Mon,  8 Feb 2021 04:37:25 +0000 (UTC)
Subject: Re: [PATCH 2/3] mlx5_vdpa: fix feature negotiation across device
 reset
To:     Si-Wei Liu <si-wei.liu@oracle.com>, mst@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
 <1612614564-4220-2-git-send-email-si-wei.liu@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4d6b8fc7-e697-d027-7763-8e56e0669a31@redhat.com>
Date:   Mon, 8 Feb 2021 12:37:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1612614564-4220-2-git-send-email-si-wei.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/6 下午8:29, Si-Wei Liu wrote:
> The mlx_features denotes the capability for which
> set of virtio features is supported by device. In
> principle, this field needs not be cleared during
> virtio device reset, as this capability is static
> and does not change across reset.
>
> In fact, the current code may have the assumption
> that mlx_features can be reloaded from firmware
> via the .get_features ops after device is reset
> (via the .set_status ops), which is unfortunately
> not true. The userspace VMM might save a copy
> of backend capable features and won't call into
> kernel again to get it on reset.


This is not the behavior of Qemu but it's valid.


> This causes all
> virtio features getting disabled on newly created
> virtqs after device reset, while guest would hold
> mismatched view of available features. For e.g.,
> the guest may still assume tx checksum offload
> is available after reset and feature negotiation,
> causing frames with bogus (incomplete) checksum
> transmitted on the wire.
>
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index b8416c4..aa6f8cd 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1788,7 +1788,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>   		clear_virtqueues(ndev);
>   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>   		ndev->mvdev.status = 0;
> -		ndev->mvdev.mlx_features = 0;
>   		++mvdev->generation;
>   		return;
>   	}

