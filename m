Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A344320B0C
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 15:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhBUOp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 09:45:26 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12146 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhBUOpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 09:45:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603271db0000>; Sun, 21 Feb 2021 06:44:43 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 21 Feb 2021 14:44:41 +0000
Date:   Sun, 21 Feb 2021 16:44:37 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210221144437.GA82010@mtl-vdi-166.wap.labs.mlnx>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613918683; bh=KFhK9bCtV7ddilpo8Ewwd3hq/9ml35nO7e2soESeI3s=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=TnqYFNB08pr15LIniy+uJB2D/nPxR92cSRdLo8udUTaQO9ydV3/CLNp90cyl++M31
         m2ZVZHhWn+9hnBchyn9l1HvrEICrskWLA9n1vmC+KtzOYUOb4oTrVhSPuLQgbBiUTR
         ADaA9oPVMBeuJj5g20s2muHYH2lMy1c1ec2t0coNWTXfNDmgRh8Ra6kWwWATLEqhdw
         okZI2Ey7ncMT51i+SqAFy4aapGVEy16RBfBEMhDynCaK/FpiEMyy87UDtUT8zmvzQB
         gNnxDG44lyRt0hmM/VIfNFvd/QvcTSfeFh0XAKoypX7xIMtidTp6Wo2TGfogkrhLb0
         Pj7C8LaLrDJEg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 06:54:58AM -0500, Si-Wei Liu wrote:
> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> for legacy") made an exception for legacy guests to reset
> features to 0, when config space is accessed before features
> are set. We should relieve the verify_min_features() check
> and allow features reset to 0 for this case.
> 
> It's worth noting that not just legacy guests could access
> config space before features are set. For instance, when
> feature VIRTIO_NET_F_MTU is advertised some modern driver
> will try to access and validate the MTU present in the config
> space before virtio features are set. Rejecting reset to 0
> prematurely causes correct MTU and link status unable to load
> for the very first config space access, rendering issues like
> guest showing inaccurate MTU value, or failure to reject
> out-of-range MTU.
> 
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 7c1f789..540dd67 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
>  	return mvdev->mlx_features;
>  }
>  
> -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> -{
> -	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> -		return -EOPNOTSUPP;
> -
> -	return 0;
> -}
> -

But what if VIRTIO_F_ACCESS_PLATFORM is not offerred? This does not
support such cases.

Maybe we should call verify_min_features() from mlx5_vdpa_set_status()
just before attempting to call setup_driver().

>  static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
>  {
>  	int err;
> @@ -1558,18 +1550,13 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
>  {
>  	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>  	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> -	int err;
>  
>  	print_features(mvdev, features, true);
>  
> -	err = verify_min_features(mvdev, features);
> -	if (err)
> -		return err;
> -
>  	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
>  	ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
>  	ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
> -	return err;
> +	return 0;
>  }
>  
>  static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)
> -- 
> 1.8.3.1
> 
