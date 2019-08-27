Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D9D9DB64
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 03:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfH0Bxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 21:53:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbfH0Bxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 21:53:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C297C5945E;
        Tue, 27 Aug 2019 01:53:50 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 394746092D;
        Tue, 27 Aug 2019 01:53:50 +0000 (UTC)
Date:   Mon, 26 Aug 2019 19:53:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     jiri@mellanox.com, kwankhede@nvidia.com, cohuck@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
Message-ID: <20190826195349.2ed6c1dc@x1.home>
In-Reply-To: <20190826204119.54386-4-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-4-parav@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 27 Aug 2019 01:53:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 15:41:18 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Expose mdev alias as string in a sysfs tree so that such attribute can
> be used to generate netdevice name by systemd/udev or can be used to
> match other kernel objects based on the alias of the mdev.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 13 +++++++++++++
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

Wouldn't it be better to not create the alias at all?  Thanks,

Alex

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

