Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F21E3129D3
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 05:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBHEki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 23:40:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229763AbhBHEk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 23:40:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612759140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ua7Jkm4OPahNFhX/PVXIUgObMy5pUjSLw7j6xYHr7zs=;
        b=Rp65uE1vfJaJ2DvcbLxVAUptOT+xI+xjVMaVJR/guylqzhaYQquxCHpuELAweTirzazvbP
        NkJ1583wc2OWTw502c8SBZBEt77N32SH+P35t5TA53gvZr0w46ujj/+1iu7AkX+upQ44VQ
        asd/cwbPLvcBFArScqpv58DvqjQOf3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-O8rd9CjoPXykP3ZI3MXqXQ-1; Sun, 07 Feb 2021 23:38:56 -0500
X-MC-Unique: O8rd9CjoPXykP3ZI3MXqXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B935801977;
        Mon,  8 Feb 2021 04:38:55 +0000 (UTC)
Received: from [10.72.13.185] (ovpn-13-185.pek2.redhat.com [10.72.13.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 528A75B4B5;
        Mon,  8 Feb 2021 04:38:48 +0000 (UTC)
Subject: Re: [PATCH 1/3] mlx5_vdpa: should exclude header length and fcs from
 mtu
To:     Si-Wei Liu <si-wei.liu@oracle.com>, mst@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <735a1b40-09f0-4fec-4d59-98e7c650297d@redhat.com>
Date:   Mon, 8 Feb 2021 12:38:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/6 下午8:29, Si-Wei Liu wrote:
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


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++++
>   drivers/vdpa/mlx5/net/mlx5_vnet.c  | 15 ++++++++++++++-
>   2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> index 08f742f..b6cc53b 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -4,9 +4,13 @@
>   #ifndef __MLX5_VDPA_H__
>   #define __MLX5_VDPA_H__
>   
> +#include <linux/etherdevice.h>
> +#include <linux/if_vlan.h>
>   #include <linux/vdpa.h>
>   #include <linux/mlx5/driver.h>
>   
> +#define MLX5V_ETH_HARD_MTU (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN)
> +
>   struct mlx5_vdpa_direct_mr {
>   	u64 start;
>   	u64 end;
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index dc88559..b8416c4 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1907,6 +1907,19 @@ static int mlx5_get_vq_irq(struct vdpa_device *vdv, u16 idx)
>   	.free = mlx5_vdpa_free,
>   };
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
>   static int alloc_resources(struct mlx5_vdpa_net *ndev)
>   {
>   	struct mlx5_vdpa_net_resources *res = &ndev->res;
> @@ -1992,7 +2005,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>   	init_mvqs(ndev);
>   	mutex_init(&ndev->reslock);
>   	config = &ndev->config;
> -	err = mlx5_query_nic_vport_mtu(mdev, &ndev->mtu);
> +	err = query_mtu(mdev, &ndev->mtu);
>   	if (err)
>   		goto err_mtu;
>   

