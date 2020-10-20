Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009A62932ED
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 04:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390200AbgJTCDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 22:03:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729737AbgJTCDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 22:03:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603159386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NmXOqvehNGfDTXL8WpvpklVjPy36AdPv8PbsuxvLCiQ=;
        b=gDgHHG+yAxSGH+pfMoeL0VfBFVXumm7VajS/Hq+XuS8Alwz/0cvpd8AvpP9MkTW4PAGOJa
        hEgWecq9rfHBXX3viaLRwKsrkRbqoenHD0d/1xcfCmuq5jy1CiTFedtjX2gEqgY/42oEdw
        qEYazXhqyp0uNxeX8tjfcBxMdamJnR0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-aeqafFxiMFuRUvUU2Uju5g-1; Mon, 19 Oct 2020 22:03:04 -0400
X-MC-Unique: aeqafFxiMFuRUvUU2Uju5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BBBB8049C8;
        Tue, 20 Oct 2020 02:03:03 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDDC85C1A3;
        Tue, 20 Oct 2020 02:03:01 +0000 (UTC)
Subject: Re: [PATCH net] vdpa/mlx5: Fix miss to set VIRTIO_NET_S_LINK_UP for
 virtio_net_config
To:     wenxu@ucloud.cn, netdev@vger.kernel.org, eli@mellanox.com
References: <1603098438-20200-1-git-send-email-wenxu@ucloud.cn>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b2ceb319-8447-b804-2965-4e5844b6fa36@redhat.com>
Date:   Tue, 20 Oct 2020 10:03:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1603098438-20200-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/19 下午5:07, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Qemu get virtio_net_config from the vdpa driver. So The vdpa driver
> should set the VIRTIO_NET_S_LINK_UP flag to virtio_net_config like
> vdpa_sim. Or the link of virtio net NIC in the virtual machine will
> never up.
>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 74264e59..af6c74c 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1537,6 +1537,8 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
>   	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
>   	ndev->config.mtu = __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mvdev),
>   					     ndev->mtu);
> +	ndev->config.status = __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mvdev),
> +					       VIRTIO_NET_S_LINK_UP);
>   	return err;
>   }
>   


Other than the small issue pointed out by Jakub.

Acked-by: Jason Wang <jasowang@redhat.com>


