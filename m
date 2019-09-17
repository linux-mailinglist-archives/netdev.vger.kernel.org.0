Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097E2B4B74
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 12:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfIQKDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 06:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfIQKDk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 06:03:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 71B2583F3C;
        Tue, 17 Sep 2019 10:03:39 +0000 (UTC)
Received: from gondolin (dhcp-192-230.str.redhat.com [10.33.192.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77FB660923;
        Tue, 17 Sep 2019 10:03:35 +0000 (UTC)
Date:   Tue, 17 Sep 2019 12:03:33 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mdev: Introduce sha1 based mdev alias
Message-ID: <20190917120333.3449f62e.cohuck@redhat.com>
In-Reply-To: <20190902042436.23294-2-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <20190902042436.23294-2-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 17 Sep 2019 10:03:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Sep 2019 23:24:32 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Some vendor drivers want an identifier for an mdev device that is
> shorter than the UUID, due to length restrictions in the consumers of
> that identifier.
> 
> Add a callback that allows a vendor driver to request an alias of a
> specified length to be generated for an mdev device. If generated,
> that alias is checked for collisions.
> 
> It is an optional attribute.
> mdev alias is generated using sha1 from the mdev name.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> 
> ---
> Changelog:
> v1->v2:
>  - Kept mdev_device naturally aligned
>  - Added error checking for crypt_*() calls
>  - Corrected a typo from 'and' to 'an'
>  - Changed return type of generate_alias() from int to char*
> v0->v1:
>  - Moved alias length check outside of the parent lock
>  - Moved alias and digest allocation from kvzalloc to kzalloc
>  - &alias[0] changed to alias
>  - alias_length check is nested under get_alias_length callback check
>  - Changed comments to start with an empty line
>  - Fixed cleaunup of hash if mdev_bus_register() fails
>  - Added comment where alias memory ownership is handed over to mdev device
>  - Updated commit log to indicate motivation for this feature
> ---
>  drivers/vfio/mdev/mdev_core.c    | 123 ++++++++++++++++++++++++++++++-
>  drivers/vfio/mdev/mdev_private.h |   5 +-
>  drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
>  include/linux/mdev.h             |   4 +
>  4 files changed, 135 insertions(+), 10 deletions(-)

(...)

> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..f036fe9854ee 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
>   * @mmap:		mmap callback
>   *			@mdev: mediated device structure
>   *			@vma: vma structure
> + * @get_alias_length:	Generate alias for the mdevs of this parent based on the
> + *			mdev device name when it returns non zero alias length.

"Optional: If a non-zero alias length is returned, generate an alias
for this parent's mdevs based upon the mdev device name."

?

> + *			It is optional.
>   * Parent device that support mediated device should be registered with mdev
>   * module with mdev_parent_ops structure.
>   **/
> @@ -92,6 +95,7 @@ struct mdev_parent_ops {
>  	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>  			 unsigned long arg);
>  	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
> +	unsigned int (*get_alias_length)(void);
>  };
>  
>  /* interface for exporting mdev supported type attributes */

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
