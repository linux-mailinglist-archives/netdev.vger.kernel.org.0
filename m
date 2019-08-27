Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702E99E608
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfH0KrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:47:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfH0KrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 06:47:13 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59B4E8AC6E1;
        Tue, 27 Aug 2019 10:47:13 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BEAF6012A;
        Tue, 27 Aug 2019 10:47:09 +0000 (UTC)
Date:   Tue, 27 Aug 2019 12:47:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
Message-ID: <20190827124706.7e726794.cohuck@redhat.com>
In-Reply-To: <20190826204119.54386-4-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-4-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Tue, 27 Aug 2019 10:47:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 15:41:18 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Expose mdev alias as string in a sysfs tree so that such attribute can
> be used to generate netdevice name by systemd/udev or can be used to
> match other kernel objects based on the alias of the mdev.

What about

"Expose the optional alias for an mdev device as a sysfs attribute.
This way, userspace tools such as udev may make use of the alias, for
example to create a netdevice name for the mdev."

> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 13 +++++++++++++

I think the documentation should be updated as well.

>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 43afe0e80b76..59f4e3cc5233 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -246,7 +246,20 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
>  
>  static DEVICE_ATTR_WO(remove);
>  
> +static ssize_t alias_show(struct device *device,
> +			  struct device_attribute *attr, char *buf)
> +{
> +	struct mdev_device *dev = mdev_from_dev(device);
> +
> +	if (!dev->alias)
> +		return -EOPNOTSUPP;

I'm wondering how to make this consumable by userspace in the easiest way.
- As you do now (userspace gets an error when trying to read)?
- Returning an empty value (nothing to see here, move along)?
- Or not creating the attribute at all? That would match what userspace
  sees on older kernels, so it needs to be able to deal with that
  anyway.

> +
> +	return sprintf(buf, "%s\n", dev->alias);
> +}
> +static DEVICE_ATTR_RO(alias);
> +
>  static const struct attribute *mdev_device_attrs[] = {
> +	&dev_attr_alias.attr,
>  	&dev_attr_remove.attr,
>  	NULL,
>  };

