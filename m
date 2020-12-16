Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759D42DB7E6
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgLPAsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:48:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgLPAsf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 19:48:35 -0500
Date:   Tue, 15 Dec 2020 16:47:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608079675;
        bh=u71LDZWR3y9gBgZhKpkQuboGI4XDbkgTQuveYnRzu9w=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zu8iVmKXJUagjUt24sD1roLIm2k6YosYr0di3dWnuo29H/uJon16YNDBXHTDnLJS6
         IBV1UB/jNgtlYiZRzNfuuimzo0U5AGt50WHhPMVq5xuP3YGG3rPJNunlDgSJqzsbg1
         VyLJfDhW1JdNUaRxxBnvzFSqs1iXZGRL4x5nCuKI+TCrq0qFDTZFz32Jw15EDNGsbJ
         BH93L5SkiRDpsho4G4W8TotL5AQFXjbJQ6/iQdORZsGK+EB1i5DPhky3yzO/voV4LV
         JyugcU6oulCEYAzU1V4NYffPa9OnvyLnZgnqJijPu8opWMlttMTl6u4ejSM7+HcrJW
         VtmmIh3eOc3Qg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Vu Pham <vuhuong@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 09/15] net/mlx5: E-switch, Prepare eswitch to
 handle SF vport
Message-ID: <20201215164753.4f6c4c9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215090358.240365-10-saeed@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-10-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 01:03:52 -0800 Saeed Mahameed wrote:
> From: Vu Pham <vuhuong@nvidia.com>
> 
> Prepare eswitch to handle SF vport during
> (a) querying eswitch functions
> (b) egress ACL creation
> (c) account for SF vports in total vports calculation
> 
> Assign a dedicated placeholder for SFs vports and their representors.
> They are placed after VFs vports and before ECPF vports as below:
> [PF,VF0,...,VFn,SF0,...SFm,ECPF,UPLINK].
> 
> Change functions to map SF's vport numbers to indices when
> accessing the vports or representors arrays, and vice versa.
> 
> Signed-off-by: Vu Pham <vuhuong@nvidia.com>
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> index d6c48582e7a8..ad45d20f9d44 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> @@ -212,3 +212,13 @@ config MLX5_SF
>  	Build support for subfuction device in the NIC. A Mellanox subfunction
>  	device can support RDMA, netdevice and vdpa device.
>  	It is similar to a SRIOV VF but it doesn't require SRIOV support.
> +
> +config MLX5_SF_MANAGER
> +	bool
> +	depends on MLX5_SF && MLX5_ESWITCH
> +	default y
> +	help
> +	Build support for subfuction port in the NIC. A Mellanox subfunction
> +	port is managed through devlink.  A subfunction supports RDMA, netdevice
> +	and vdpa device. It is similar to a SRIOV VF but it doesn't require
> +	SRIOV support.

Why is this a separate knob?

And it's not used anywhere AFAICS.
