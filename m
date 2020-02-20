Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4D1165C96
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 12:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgBTLPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 06:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgBTLPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 06:15:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FF8F207FD;
        Thu, 20 Feb 2020 11:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582197352;
        bh=DwGqJR7vwgavTiM12x46v49zD2NV2riwsvV94EwK5Ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UoS+KT7RMS9xGeLh6laqlJHIm78ee0CaF0wg74A0zXvTOoh6UYbp0viN9wVDwfTP4
         Ne3QjKNuMEo40Ajfujqm42hy6jEuRseZWwiOKwAeXhlR3wzg4AreobnxpiG8oPGpA3
         d4RFH/18tTZKlN2KxUmL+QiCGOK+oUratVUwVTcU=
Date:   Thu, 20 Feb 2020 12:15:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/9] sysfs: add sysfs_group{s}_change_owner()
Message-ID: <20200220111550.GE3374196@kroah.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-4-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218162943.2488012-4-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 05:29:37PM +0100, Christian Brauner wrote:
> Add helpers to change the owner of sysfs groups.
> This function will be used to correctly account for kobject ownership
> changes, e.g. when moving network devices between network namespaces.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> /* v2 */
> -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>    - Add comment how ownership of sysfs object is changed.
> 
> /* v3 */
> -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>    - Add explicit uid/gid parameters.
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - Collapse groups ownership helper patches into a single patch.
> ---
>  fs/sysfs/group.c      | 117 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/sysfs.h |  20 ++++++++
>  2 files changed, 137 insertions(+)
> 
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index c4ab045926b7..bae562d3cba1 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -13,6 +13,7 @@
>  #include <linux/dcache.h>
>  #include <linux/namei.h>
>  #include <linux/err.h>
> +#include <linux/fs.h>
>  #include "sysfs.h"
>  
>  
> @@ -457,3 +458,119 @@ int __compat_only_sysfs_link_entry_to_kobj(struct kobject *kobj,
>  	return PTR_ERR_OR_ZERO(link);
>  }
>  EXPORT_SYMBOL_GPL(__compat_only_sysfs_link_entry_to_kobj);
> +
> +static int sysfs_group_attrs_change_owner(struct kernfs_node *grp_kn,
> +					  const struct attribute_group *grp,
> +					  struct iattr *newattrs)
> +{
> +	struct kernfs_node *kn;
> +	int error;
> +
> +	if (grp->attrs) {
> +		struct attribute *const *attr;
> +
> +		for (attr = grp->attrs; *attr; attr++) {
> +			kn = kernfs_find_and_get(grp_kn, (*attr)->name);
> +			if (!kn)
> +				return -ENOENT;
> +
> +			error = kernfs_setattr(kn, newattrs);
> +			kernfs_put(kn);
> +			if (error)
> +				return error;
> +		}
> +	}
> +
> +	if (grp->bin_attrs) {
> +		struct bin_attribute *const *bin_attr;
> +
> +		for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++) {
> +			kn = kernfs_find_and_get(grp_kn, (*bin_attr)->attr.name);
> +			if (!kn)
> +				return -ENOENT;
> +
> +			error = kernfs_setattr(kn, newattrs);
> +			kernfs_put(kn);
> +			if (error)
> +				return error;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * sysfs_group_change_owner - change owner of an attribute group.
> + * @kobj:	The kobject containing the group.
> + * @grp:	The attribute group.
> + * @kuid:	new owner's kuid
> + * @kgid:	new owner's kgid
> + *
> + * Returns 0 on success or error code on failure.

This is fine to document, just funny it's the only one documented about
the return value so far in this series.

Anyway, looks good to me:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
