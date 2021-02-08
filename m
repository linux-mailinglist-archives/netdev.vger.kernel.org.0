Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F1B312A24
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 06:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhBHFg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 00:36:59 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8772 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhBHFgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 00:36:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6020cdbc0001>; Sun, 07 Feb 2021 21:35:56 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 8 Feb 2021 05:35:54 +0000
Date:   Mon, 8 Feb 2021 07:35:50 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] mlx5_vdpa: should exclude header length and fcs from
 mtu
Message-ID: <20210208053550.GB137517@mtl-vdi-166.wap.labs.mlnx>
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612762556; bh=kJv37owGshrcok8ORA1NrOtxbQmJyzVIQ92qZvpDxbc=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=ZL+RYN+qth0RK4hfvlutVouAx1iQ4udUTeAa7NcOi1MLpPTcAbMg0wPZmMQC35hDi
         Oj/eS4gaUErkjdZ39qRhlx3GwTunaUwVpsYRO6aZnCjVyxtgE2Gqn8D3InuCJEBBHS
         zitjPi10A6+QOG/nJ1pe5JYKvBgIwVEL5JGzzIToIvJ679MmThK46HDqMDPMQkg2UI
         QJtjVbgmViQcg0fx+B+vbDp6Dxw1T+8lzRTlwtSAVJmJC8laTu1CREy5fZJ8rsYah3
         rxFnUI+7TYi8TK+i5asWB/iloLQA0JndTi5pLyikwIsWHwkDO2BlMPNK9xMb2O0Zc/
         J9yOZSIuJAerQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 06, 2021 at 04:29:22AM -0800, Si-Wei Liu wrote:
> When feature VIRTIO_NET_F_MTU is negotiated on mlx5_vdpa,
> 22 extra bytes worth of MTU length is shown in guest.
> This is because the mlx5_query_port_max_mtu API returns
> the "hardware" MTU value, which does not just contain the
> Ethernet payload, but includes extra lengths starting
> from the Ethernet header up to the FCS altogether.
> 
> Fix the MTU so packets won't get dropped silently.
> 
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>

Acked-by: Eli Cohen <elic@nvidia.com>

> ---
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++++
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 15 ++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> index 08f742f..b6cc53b 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -4,9 +4,13 @@
>  #ifndef __MLX5_VDPA_H__
>  #define __MLX5_VDPA_H__
>  
> +#include <linux/etherdevice.h>
> +#include <linux/if_vlan.h>
>  #include <linux/vdpa.h>
>  #include <linux/mlx5/driver.h>
>  
> +#define MLX5V_ETH_HARD_MTU (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN)
> +
>  struct mlx5_vdpa_direct_mr {
>  	u64 start;
>  	u64 end;
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index dc88559..b8416c4 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1907,6 +1907,19 @@ static int mlx5_get_vq_irq(struct vdpa_device *vdv, u16 idx)
>  	.free = mlx5_vdpa_free,
>  };
>  
> +static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
> +{
> +	u16 hw_mtu;
> +	int err;
> +
> +	err = mlx5_query_nic_vport_mtu(mdev, &hw_mtu);
> +	if (err)
> +		return err;
> +
> +	*mtu = hw_mtu - MLX5V_ETH_HARD_MTU;
> +	return 0;
> +}
> +
>  static int alloc_resources(struct mlx5_vdpa_net *ndev)
>  {
>  	struct mlx5_vdpa_net_resources *res = &ndev->res;
> @@ -1992,7 +2005,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>  	init_mvqs(ndev);
>  	mutex_init(&ndev->reslock);
>  	config = &ndev->config;
> -	err = mlx5_query_nic_vport_mtu(mdev, &ndev->mtu);
> +	err = query_mtu(mdev, &ndev->mtu);
>  	if (err)
>  		goto err_mtu;
>  
> -- 
> 1.8.3.1
> 
