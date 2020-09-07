Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6B325F8E3
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgIGKxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:53:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728669AbgIGKxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599476006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i89UCCXKKan+5I1+ppu2tBoEuwjXgdxp6aLWE1Reto8=;
        b=gRGmlq/U+L+tQL8KaUbH/3POvcZJWhXQ/z/awG/CusomwnUk/EEMwyoP2il5LlghsR7CYk
        v8QBBBj6wl2fSSsGO62/JVz26ZeRK30dSyqvwoB86NlnV4k6XJD6EmINA0q4RtjZQpXBk7
        5X6hVe7n1AxhyrBSM5Eo210kyiuyIXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-nUGUxhcHPwyWfgbwno-P9Q-1; Mon, 07 Sep 2020 06:53:24 -0400
X-MC-Unique: nUGUxhcHPwyWfgbwno-P9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DE2D8030BD;
        Mon,  7 Sep 2020 10:53:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7677A5D9D2;
        Mon,  7 Sep 2020 10:53:23 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FDCC79A16;
        Mon,  7 Sep 2020 10:53:23 +0000 (UTC)
Date:   Mon, 7 Sep 2020 06:53:23 -0400 (EDT)
From:   Jason Wang <jasowang@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Message-ID: <507166908.16038290.1599476003292.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200907075136.GA114876@mtl-vdi-166.wap.labs.mlnx>
References: <20200907075136.GA114876@mtl-vdi-166.wap.labs.mlnx>
Subject: Re: [PATCH] vdpa/mlx5: Setup driver only if
 VIRTIO_CONFIG_S_DRIVER_OK
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.20, 10.4.195.28]
Thread-Topic: vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Thread-Index: lEsps6GGs64HEps5Kq4yQPAU9yMKuQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> If the memory map changes before the driver status is
> VIRTIO_CONFIG_S_DRIVER_OK, don't attempt to create resources because it
> may fail. For example, if the VQ is not ready there is no point in
> creating resources.
> 
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 9df69d5efe8c..c89cd48a0aab 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1645,6 +1645,9 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_net
> *ndev, struct vhost_iotlb *
>  	if (err)
>  		goto err_mr;
>  
> +	if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK))
> +		return 0;
> +

I'm not sure I get this.

It looks to me if set_map() is called before DRIVER_OK, we won't build
any mapping?

Thanks

>  	restore_channels_info(ndev);
>  	err = setup_driver(ndev);
>  	if (err)
> --
> 2.26.0
> 
> 

