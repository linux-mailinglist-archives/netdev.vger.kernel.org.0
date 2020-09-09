Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498F02624CE
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIICIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:08:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21376 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726002AbgIICIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599617322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cK43OIRzcGZJEOVLkDpteaSOuuBLunxsaFHU/AarU6A=;
        b=edeB5OsfD1Q9s9zuU+VIc3pXPNYGsGkEKkFFvkYlzPbAQCSyYL0CR8U8fTtiBJ5o6b/J86
        SqiKBXxtp6sU8hwdPtnBAOVLhowmhkpBmPIV/HKgqnDgMXo3RPvrlSXLBT1R78GZMw4xsG
        5shF18WoN4+8Ey6jgUn7m9SyLzKDF8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-62f7pSR1P-6oeJmgDXQcmQ-1; Tue, 08 Sep 2020 22:08:41 -0400
X-MC-Unique: 62f7pSR1P-6oeJmgDXQcmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01845807335;
        Wed,  9 Sep 2020 02:08:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED3A65C22E;
        Wed,  9 Sep 2020 02:08:39 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5F5A79DBA;
        Wed,  9 Sep 2020 02:08:39 +0000 (UTC)
Date:   Tue, 8 Sep 2020 22:08:39 -0400 (EDT)
From:   Jason Wang <jasowang@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Message-ID: <1004346338.16284947.1599617319808.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200908123346.GA169007@mtl-vdi-166.wap.labs.mlnx>
References: <20200908123346.GA169007@mtl-vdi-166.wap.labs.mlnx>
Subject: Re: [PATCH v2] vdpa/mlx5: Setup driver only if
 VIRTIO_CONFIG_S_DRIVER_OK
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.20, 10.4.195.13]
Thread-Topic: vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Thread-Index: qaNSGDz/X0Zzbl+zuoh4Dhhl+VkUUQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> set_map() is used by mlx5 vdpa to create a memory region based on the
> address map passed by the iotlb argument. If we get successive calls, we
> will destroy the current memory region and build another one based on
> the new address mapping. We also need to setup the hardware resources
> since they depend on the memory region.
> 
> If these calls happen before DRIVER_OK, It means that driver VQs may
> also not been setup and we may not create them yet. In this case we want
> to avoid setting up the other resources and defer this till we get
> DRIVER OK.
> 
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
> V1->V2: Improve changelog description
> 
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

Is there any reason that we still need to do vq suspending and saving before?

Thanks

>  	restore_channels_info(ndev);
>  	err = setup_driver(ndev);
>  	if (err)
> --
> 2.26.0
> 
> 

