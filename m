Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93269E598
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfH0KYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:24:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbfH0KYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 06:24:34 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 84C4118012FA;
        Tue, 27 Aug 2019 10:24:34 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6BED10018F9;
        Tue, 27 Aug 2019 10:24:30 +0000 (UTC)
Date:   Tue, 27 Aug 2019 12:24:28 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Message-ID: <20190827122428.37442fe1.cohuck@redhat.com>
In-Reply-To: <20190826204119.54386-2-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-2-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Tue, 27 Aug 2019 10:24:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 15:41:16 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Whenever a parent requests to generate mdev alias, generate a mdev
> alias.
> It is an optional attribute that parent can request to generate
> for each of its child mdev.
> mdev alias is generated using sha1 from the mdev name.

Maybe add some motivation here as well?

"Some vendor drivers want an identifier for an mdev device that is
shorter than the uuid, due to length restrictions in the consumers of
that identifier.

Add a callback that allows a vendor driver to request an alias of a
specified length to be generated (via sha1) for an mdev device. If
generated, that alias is checked for collisions."

> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 98 +++++++++++++++++++++++++++++++-
>  drivers/vfio/mdev/mdev_private.h |  5 +-
>  drivers/vfio/mdev/mdev_sysfs.c   | 13 +++--
>  include/linux/mdev.h             |  4 ++
>  4 files changed, 111 insertions(+), 9 deletions(-)
> 

(...)

> @@ -406,6 +495,10 @@ EXPORT_SYMBOL(mdev_get_iommu_device);
>  
>  static int __init mdev_init(void)
>  {
> +	alias_hash = crypto_alloc_shash("sha1", 0, 0);
> +	if (!alias_hash)
> +		return -ENOMEM;
> +
>  	return mdev_bus_register();

Don't you need to call crypto_free_shash() if mdev_bus_register() fails?

>  }
>  
> @@ -415,6 +508,7 @@ static void __exit mdev_exit(void)
>  		class_compat_unregister(mdev_bus_compat_class);
>  
>  	mdev_bus_unregister();
> +	crypto_free_shash(alias_hash);
>  }
>  
>  module_init(mdev_init)

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
> + *			It is optional.

What about:

* @get_alias_length: optional callback to specify length of the alias to create
*                    Returns unsigned integer: length of the alias to be created,
*                                              0 to not create an alias

I also think it might be beneficial to add a device parameter here now
(rather than later); that seems to be something that makes sense.

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

