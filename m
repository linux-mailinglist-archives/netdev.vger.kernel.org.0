Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7633185B6
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 08:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBKHe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 02:34:27 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14672 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhBKHd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 02:33:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6024ddb30001>; Wed, 10 Feb 2021 23:33:07 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Thu, 11 Feb 2021 07:33:04 +0000
Date:   Thu, 11 Feb 2021 09:33:00 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] vdpa/mlx5: fix feature negotiation across device
 reset
Message-ID: <20210211073300.GA100783@mtl-vdi-166.wap.labs.mlnx>
References: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
 <1612993680-29454-3-git-send-email-si-wei.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1612993680-29454-3-git-send-email-si-wei.liu@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613028787; bh=Jb5vgiCfWSfNtEu95oNyAIE8t6IaV8AzCWh8B39PaLM=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=ZQbT/0qHciVcaAPTYedUyNfyCTq1yQySYe7d5cEgMgjbum7Sk5qu8FUKKV/Df/93G
         dKPVBaXn6b/YoUHFVKDO/DTpNsxwsQh2N6kezZ2ezA1zfRUp5f41qvFRbXb2CE2Am1
         WLIdgs0X93YKuoMRTCJGH/npjdF56/x59cxQ8mtQQ86ECuia1yLjR56cX84WSnpgGP
         9GUEoxrslLL9ky/TyYAClb3hMJpkqOWBj5jHt2A2YclxL4UWy+CT6A8WUP9wdzHS7R
         dNix/4HpOJTmwGv+cUsSmG4+UMnc95qKh8yx6/awmHxAdymrpl1sicbzoyGcL5pssd
         /C3IxX5MiW8Kg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 01:47:59PM -0800, Si-Wei Liu wrote:
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

Acked-by: Eli Cohen <elic@nvidia.com>

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index b8416c4..7c1f789 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1486,16 +1486,8 @@ static u64 mlx_to_vritio_features(u16 dev_features)
>  static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
>  {
>  	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
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
>  }
>  
>  static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> @@ -1788,7 +1780,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>  		clear_virtqueues(ndev);
>  		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>  		ndev->mvdev.status = 0;
> -		ndev->mvdev.mlx_features = 0;
>  		++mvdev->generation;
>  		return;
>  	}
> @@ -1907,6 +1898,19 @@ static int mlx5_get_vq_irq(struct vdpa_device *vdv, u16 idx)
>  	.free = mlx5_vdpa_free,
>  };
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
>  static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
>  {
>  	u16 hw_mtu;
> @@ -2005,6 +2009,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>  	init_mvqs(ndev);
>  	mutex_init(&ndev->reslock);
>  	config = &ndev->config;
> +	query_virtio_features(ndev);
>  	err = query_mtu(mdev, &ndev->mtu);
>  	if (err)
>  		goto err_mtu;
> -- 
> 1.8.3.1
> 
