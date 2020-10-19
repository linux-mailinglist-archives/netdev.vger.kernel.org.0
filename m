Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0807F2930E3
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbgJSWDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387737AbgJSWDF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 18:03:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D686222C4;
        Mon, 19 Oct 2020 22:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603144985;
        bh=t1EKTPwHj9BPTTOQC2pwMvjH58RNQREHuxXIddzZiB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EAjmI4zyT9sERS2kiHOLt8RuSJAC5SS4Mj35nCqQo0XvFQ8ppQTkGZoc742e4ud9Y
         S1JjA+XfLIczwoueacuYvXlLzb/uKrgzMThR7pLnXUfrY6kQAMlM/+gjzNA90nPYLa
         9LTD3/RhoqSfPzf9ZZo0T/1xaeYnwbL7J2C3JoDU=
Date:   Mon, 19 Oct 2020 15:02:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     eli@mellanox.com, netdev@vger.kernel.org, jasowang@redhat.com,
        parav@mellanox.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] vdpa/mlx5: Fix miss to set VIRTIO_NET_S_LINK_UP for
 virtio_net_config
Message-ID: <20201019150254.70ff3050@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1603117027-24054-1-git-send-email-wenxu@ucloud.cn>
References: <1603117027-24054-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 22:17:07 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Qemu get virtio_net_config from the vdpa driver. So The vdpa driver
> should set the VIRTIO_NET_S_LINK_UP flag to virtio_net_config like
> vdpa_sim. Or the link of virtio net NIC in the virtual machine will
> never up.
> 
> Fixes:1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")

        ^ missing space

Please keep CCing netdev on future submissions, but the vdpa patches
actually go through Michael's tree, so make sure to CC
virtualization@lists.linux-foundation.org

> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 74264e59..af6c74c 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1537,6 +1537,8 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
>  	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
>  	ndev->config.mtu = __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mvdev),
>  					     ndev->mtu);
> +	ndev->config.status = __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mvdev),
> +					       VIRTIO_NET_S_LINK_UP);
>  	return err;
>  }
>  

