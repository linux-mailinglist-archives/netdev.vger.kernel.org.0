Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B2DB55D9
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 21:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfIQTAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 15:00:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729728AbfIQTAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 15:00:51 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C53AA3D38C;
        Tue, 17 Sep 2019 19:00:51 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 541C160852;
        Tue, 17 Sep 2019 19:00:45 +0000 (UTC)
Date:   Tue, 17 Sep 2019 13:00:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kwankhede@nvidia.com,
        cohuck@redhat.com, tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, idos@mellanox.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com
Subject: Re: [RFC PATCH 2/4] mdev: introduce helper to set per device dma
 ops
Message-ID: <20190917130044.4fb97637@x1.home>
In-Reply-To: <20190910081935.30516-3-jasowang@redhat.com>
References: <20190910081935.30516-1-jasowang@redhat.com>
        <20190910081935.30516-3-jasowang@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 17 Sep 2019 19:00:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Sep 2019 16:19:33 +0800
Jason Wang <jasowang@redhat.com> wrote:

> This patch introduces mdev_set_dma_ops() which allows parent to set
> per device DMA ops. This help for the kernel driver to setup a correct
> DMA mappings.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 7 +++++++
>  include/linux/mdev.h          | 2 ++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b558d4cfd082..eb28552082d7 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -13,6 +13,7 @@
>  #include <linux/uuid.h>
>  #include <linux/sysfs.h>
>  #include <linux/mdev.h>
> +#include <linux/dma-mapping.h>
>  
>  #include "mdev_private.h"
>  
> @@ -27,6 +28,12 @@ static struct class_compat *mdev_bus_compat_class;
>  static LIST_HEAD(mdev_list);
>  static DEFINE_MUTEX(mdev_list_lock);
>  
> +void mdev_set_dma_ops(struct mdev_device *mdev, struct dma_map_ops *ops)
> +{
> +	set_dma_ops(&mdev->dev, ops);
> +}
> +EXPORT_SYMBOL(mdev_set_dma_ops);
> +

Why does mdev need to be involved here?  Your sample driver in 4/4 calls
this from its create callback, where it could just as easily call:

  set_dma_ops(mdev_dev(mdev), ops);

Thanks,
Alex

>  struct device *mdev_parent_dev(struct mdev_device *mdev)
>  {
>  	return mdev->parent->dev;
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..7195f40bf8bf 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -145,4 +145,6 @@ struct device *mdev_parent_dev(struct mdev_device *mdev);
>  struct device *mdev_dev(struct mdev_device *mdev);
>  struct mdev_device *mdev_from_dev(struct device *dev);
>  
> +void mdev_set_dma_ops(struct mdev_device *mdev, struct dma_map_ops *ops);
> +
>  #endif /* MDEV_H */

