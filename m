Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CD42C7CB0
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 03:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgK3CNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 21:13:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbgK3CNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 21:13:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606702332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8sjd/83plcp606/47bcrLZsq1LEBw7/fWpUkizclFBY=;
        b=ecGK0+IFzPR7sE/meotYJ/ztJvgKr+oVZt6EuyvzIOYv0d4dg4+7Mmi7l95+EwQaaGDLBn
        lgX9RSJx4btZv28i+88JsfGAD/9NlxM62PAXtxDqUkU3XbJ576cAhgNzCgkge7Wa8KoZb/
        ouT7jnAKPOArMsxQFlXZw8a+9HwkQIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-Uhpc5TRBME2471aFym3k7Q-1; Sun, 29 Nov 2020 21:12:09 -0500
X-MC-Unique: Uhpc5TRBME2471aFym3k7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D928D1074641;
        Mon, 30 Nov 2020 02:12:07 +0000 (UTC)
Received: from [10.72.13.173] (ovpn-13-173.pek2.redhat.com [10.72.13.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D03CA272DF;
        Mon, 30 Nov 2020 02:12:01 +0000 (UTC)
Subject: Re: [PATCH v4] vdpa: mlx5: fix vdpa/vhost dependencies
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>, Eli Cohen <eli@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
References: <20201128213905.27409-1-rdunlap@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b6a1231c-8b81-6c69-3c63-74bf438da866@redhat.com>
Date:   Mon, 30 Nov 2020 10:12:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201128213905.27409-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/29 上午5:39, Randy Dunlap wrote:
> drivers/vdpa/mlx5/ uses vhost_iotlb*() interfaces, so select
> VHOST_IOTLB to make them be built.
>
> However, if VHOST_IOTLB is the only VHOST symbol that is
> set/enabled, the object file still won't be built because
> drivers/Makefile won't descend into drivers/vhost/ to build it,
> so make drivers/Makefile build the needed binary whenever
> VHOST_IOTLB is set, like it does for VHOST_RING.
>
> Fixes these build errors:
> ERROR: modpost: "vhost_iotlb_itree_next" [drivers/vdpa/mlx5/mlx5_vdpa.ko] undefined!
> ERROR: modpost: "vhost_iotlb_itree_first" [drivers/vdpa/mlx5/mlx5_vdpa.ko] undefined!
>
> Fixes: 29064bfdabd5 ("vdpa/mlx5: Add support library for mlx5 VDPA implementation")
> Fixes: aff90770e54c ("vdpa/mlx5: Fix dependency on MLX5_CORE")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Eli Cohen <eli@mellanox.com>
> Cc: Parav Pandit <parav@mellanox.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: netdev@vger.kernel.org
> ---
> v2: change from select to depends on VHOST (Saeed)
> v3: change to depends on VHOST_IOTLB (Jason)
> v4: use select VHOST_IOTLB (Michael); also add to drivers/Makefile
>
>   drivers/Makefile     |    1 +
>   drivers/vdpa/Kconfig |    1 +
>   2 files changed, 2 insertions(+)
>
> --- linux-next-20201127.orig/drivers/vdpa/Kconfig
> +++ linux-next-20201127/drivers/vdpa/Kconfig
> @@ -32,6 +32,7 @@ config IFCVF
>   
>   config MLX5_VDPA
>   	bool
> +	select VHOST_IOTLB
>   	help
>   	  Support library for Mellanox VDPA drivers. Provides code that is
>   	  common for all types of VDPA drivers. The following drivers are planned:
> --- linux-next-20201127.orig/drivers/Makefile
> +++ linux-next-20201127/drivers/Makefile
> @@ -143,6 +143,7 @@ obj-$(CONFIG_OF)		+= of/
>   obj-$(CONFIG_SSB)		+= ssb/
>   obj-$(CONFIG_BCMA)		+= bcma/
>   obj-$(CONFIG_VHOST_RING)	+= vhost/
> +obj-$(CONFIG_VHOST_IOTLB)	+= vhost/
>   obj-$(CONFIG_VHOST)		+= vhost/
>   obj-$(CONFIG_VLYNQ)		+= vlynq/
>   obj-$(CONFIG_GREYBUS)		+= greybus/
>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

