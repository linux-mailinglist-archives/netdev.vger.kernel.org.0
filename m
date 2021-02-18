Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8CB31E68E
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 08:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhBRG4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 01:56:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231264AbhBRGtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 01:49:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613630882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0xSBP2JIYUC8xWmwZs/YoFdX+EUOlZ0kViYULbocJus=;
        b=KwQnpwzZiRbrXd7x6Se6f/dhnFjrr5ypojdIUleEQYIvrF1WwO3ySJ7GhkgblykSfSgOqw
        ebrIvc/Efgy/yshMW540SklfoyurGZDzMCSGLSNuFEY7CtoJXbBH4r5xq0r3MnJ2J7Yr13
        Ll8ytZlWyVGVVw1NmNzM88QW18vUE+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-NL4_CLGsNk2Km3TLHXsk0Q-1; Thu, 18 Feb 2021 01:36:52 -0500
X-MC-Unique: NL4_CLGsNk2Km3TLHXsk0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCF14107ACE4;
        Thu, 18 Feb 2021 06:36:50 +0000 (UTC)
Received: from [10.72.13.28] (ovpn-13-28.pek2.redhat.com [10.72.13.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 662645B6AB;
        Thu, 18 Feb 2021 06:36:45 +0000 (UTC)
Subject: Re: [PATCH v2 2/3] vdpa/mlx5: fix feature negotiation across device
 reset
To:     Si-Wei Liu <si-wei.liu@oracle.com>, mst@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
 <1612993680-29454-3-git-send-email-si-wei.liu@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <386fffb2-be75-9ce0-0a4d-1d47f91e7d16@redhat.com>
Date:   Thu, 18 Feb 2021 14:36:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1612993680-29454-3-git-send-email-si-wei.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/11 上午5:47, Si-Wei Liu wrote:
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
> kernel again to get it on reset. This causes all
> virtio features getting disabled on newly created
> virtqs after device reset, while guest would hold
> mismatched view of available features. For e.g.,
> the guest may still assume tx checksum offload
> is available after reset and feature negotiation,
> causing frames with bogus (incomplete) checksum
> transmitted on the wire.
>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 25 +++++++++++++++----------
>   1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index b8416c4..7c1f789 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1486,16 +1486,8 @@ static u64 mlx_to_vritio_features(u16 dev_features)
>   static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
>   {
>   	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> -	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> -	u16 dev_features;
>   
> -	dev_features = MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, device_features_bits_mask);
> -	ndev->mvdev.mlx_features = mlx_to_vritio_features(dev_features);
> -	if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, virtio_version_1_0))
> -		ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_F_VERSION_1);
> -	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_F_ACCESS_PLATFORM);
> -	print_features(mvdev, ndev->mvdev.mlx_features, false);
> -	return ndev->mvdev.mlx_features;
> +	return mvdev->mlx_features;
>   }
>   
>   static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> @@ -1788,7 +1780,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>   		clear_virtqueues(ndev);
>   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>   		ndev->mvdev.status = 0;
> -		ndev->mvdev.mlx_features = 0;
>   		++mvdev->generation;
>   		return;
>   	}
> @@ -1907,6 +1898,19 @@ static int mlx5_get_vq_irq(struct vdpa_device *vdv, u16 idx)
>   	.free = mlx5_vdpa_free,
>   };
>   
> +static void query_virtio_features(struct mlx5_vdpa_net *ndev)
> +{
> +	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
> +	u16 dev_features;
> +
> +	dev_features = MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, device_features_bits_mask);
> +	mvdev->mlx_features = mlx_to_vritio_features(dev_features);
> +	if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, virtio_version_1_0))
> +		mvdev->mlx_features |= BIT_ULL(VIRTIO_F_VERSION_1);
> +	mvdev->mlx_features |= BIT_ULL(VIRTIO_F_ACCESS_PLATFORM);
> +	print_features(mvdev, mvdev->mlx_features, false);
> +}
> +
>   static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
>   {
>   	u16 hw_mtu;
> @@ -2005,6 +2009,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>   	init_mvqs(ndev);
>   	mutex_init(&ndev->reslock);
>   	config = &ndev->config;
> +	query_virtio_features(ndev);
>   	err = query_mtu(mdev, &ndev->mtu);
>   	if (err)
>   		goto err_mtu;

