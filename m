Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F17165CAE
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 12:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgBTLXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 06:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbgBTLXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 06:23:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0BE82071E;
        Thu, 20 Feb 2020 11:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582197796;
        bh=OYctspxIYHSv6yDvP7rXR6piUUUL1NVMDyxFcK3m/9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hawlT1+YH9ja/u2zOslPZ78rpzxzx5E3IcIQ8aqI6Sy1/mfU4qplsnl91nQc4PKUI
         oHSqogw+fLT+WuE+PKstI/taadvuxEQ0fnMEn9jYFeSeaAyEbtt8GHTjQ0Zd8/LBvY
         EpSkF7on45GLSwWStJ7mkbfQg/EwjoFmDGnqFDcs=
Date:   Thu, 20 Feb 2020 12:23:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/9] sysfs: add sysfs_change_owner()
Message-ID: <20200220112314.GG3374196@kroah.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-5-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218162943.2488012-5-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 05:29:38PM +0100, Christian Brauner wrote:
> Add a helper to change the owner of sysfs objects.
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
> ---
>  fs/sysfs/file.c       | 39 +++++++++++++++++++++++++++++++++++++++
>  include/linux/sysfs.h |  6 ++++++
>  2 files changed, 45 insertions(+)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index df5107d7b3fd..02f7e852aad4 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -665,3 +665,42 @@ int sysfs_file_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid)
>  	return error;
>  }
>  EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
> +
> +/**
> + *	sysfs_change_owner - change owner of the given object.

"and all of the files associated with this kobject", right?

> + *	@kobj:	object.
> + *	@kuid:	new owner's kuid
> + *	@kgid:	new owner's kgid
> + */
> +int sysfs_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid)
> +{
> +	int error;
> +	const struct kobj_type *ktype;
> +
> +	if (!kobj->state_in_sysfs)
> +		return -EINVAL;
> +
> +	error = sysfs_file_change_owner(kobj, kuid, kgid);

Ok, this changes the attributes of the sysfs directory for the kobject
itself.

> +	if (error)
> +		return error;
> +
> +	ktype = get_ktype(kobj);
> +	if (ktype) {
> +		struct attribute **kattr;
> +
> +		for (kattr = ktype->default_attrs; kattr && *kattr; kattr++) {
> +			error = sysfs_file_change_owner_by_name(
> +				kobj, (*kattr)->name, kuid, kgid);
> +			if (error)
> +				return error;
> +		}

And here you change all of the files of the kobject.

But what about files that have a subdir?  Does that also happen here?

> +
> +		error = sysfs_groups_change_owner(kobj, ktype->default_groups,
> +						  kuid, kgid);

Then what are you changing here?

I think the kerneldoc needs a lot more explaination as to what is going
on in this function and why you would call it, and not some of the other
functions you are adding.

thanks,

greg k-h
