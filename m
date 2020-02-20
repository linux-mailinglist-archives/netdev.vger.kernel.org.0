Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4AB165CB8
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 12:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbgBTLZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 06:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbgBTLZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 06:25:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E6E42071E;
        Thu, 20 Feb 2020 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582197915;
        bh=79ixthYwiZXZ5uYd6owAPf1t4ZeXoH8DH9rSjQ8vPy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZN0EBeuYDJRGU/2HM5cOBHEChC5qutvLimQgrHC+Q6lt8Rbp07ZnOLGVDHiCKWSzf
         qUhJ6R638E6kt97exa+eS72EzsLQsqBvo6vibfUpJXYpyXu1+pUhnvZ2jWQK5ItSB7
         Th9mLEyxVStZL8ZBO9/oQ+0jedUbjygjn4EgVB80=
Date:   Thu, 20 Feb 2020 12:25:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 5/9] device: add device_change_owner()
Message-ID: <20200220112513.GH3374196@kroah.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-6-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218162943.2488012-6-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 05:29:39PM +0100, Christian Brauner wrote:
> Add a helper to change the owner of a device's sysfs entries. This
> needs to happen when the ownership of a device is changed, e.g. when
> moving network devices between network namespaces.
> This function will be used to correctly account for ownership changes,
> e.g. when moving network devices between network namespaces.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> /* v2 */
> unchanged
> 
> /* v3 */
> -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>    - Add explicit uid/gid parameters.
> ---
>  drivers/base/core.c    | 80 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device.h |  1 +
>  2 files changed, 81 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 42a672456432..ec0d5e8cfd0f 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -3458,6 +3458,86 @@ int device_move(struct device *dev, struct device *new_parent,
>  }
>  EXPORT_SYMBOL_GPL(device_move);
>  
> +static int device_attrs_change_owner(struct device *dev, kuid_t kuid,
> +				     kgid_t kgid)
> +{
> +	struct kobject *kobj = &dev->kobj;
> +	struct class *class = dev->class;
> +	const struct device_type *type = dev->type;
> +	int error;
> +
> +	if (class) {
> +		error = sysfs_groups_change_owner(kobj, class->dev_groups, kuid,
> +						  kgid);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (type) {
> +		error = sysfs_groups_change_owner(kobj, type->groups, kuid,
> +						  kgid);
> +		if (error)
> +			return error;
> +	}
> +
> +	error = sysfs_groups_change_owner(kobj, dev->groups, kuid, kgid);
> +	if (error)
> +		return error;
> +
> +	if (device_supports_offline(dev) && !dev->offline_disabled) {
> +		error = sysfs_file_change_owner_by_name(
> +			kobj, dev_attr_online.attr.name, kuid, kgid);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * device_change_owner - change the owner of an existing device.

The "owner" and what else gets changed here?  Please document this
better.


> + * @dev: device.
> + * @kuid: new owner's kuid
> + * @kgid: new owner's kgid
> + */
> +int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
> +{
> +	int error;
> +	struct kobject *kobj = &dev->kobj;
> +
> +	dev = get_device(dev);
> +	if (!dev)
> +		return -EINVAL;
> +
> +	error = sysfs_change_owner(kobj, kuid, kgid);

the kobject of the device is changed, good.

> +	if (error)
> +		goto out;
> +
> +	error = sysfs_file_change_owner_by_name(kobj, dev_attr_uevent.attr.name,
> +						kuid, kgid);

Why call out the uevent file explicitly here?

> +	if (error)
> +		goto out;
> +
> +	error = device_attrs_change_owner(dev, kuid, kgid);
> +	if (error)
> +		goto out;

Doesn't this also change the uevent file?

> +
> +#ifdef CONFIG_BLOCK
> +	if (sysfs_deprecated && dev->class == &block_class)
> +		goto out;
> +#endif

Ugh, we still need this?

> +
> +	error = sysfs_link_change_owner(&dev->class->p->subsys.kobj, &dev->kobj,
> +					dev_name(dev), kuid, kgid);

Now what is this changing?

Again, more documentation please as to exactly what is being changed in
this function is needed.

thanks,

greg k-h
