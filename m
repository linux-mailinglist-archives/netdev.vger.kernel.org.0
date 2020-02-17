Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDF31617E6
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgBQQ3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgBQQ3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 11:29:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B0A214D8;
        Mon, 17 Feb 2020 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581956954;
        bh=3RyDHdCvjIDVivxlLYCUY6FAPAIB2sXqUpmcgkCzhL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDAcdCoNIDDp07PhuKaqUFmG3j2kkYyX4AI8GwU+iW2xs9ifI+alAwc7jSsNjnWNC
         izXx4On2CO3plUbt+zfIs+pCQT1kvPFnPUUw8rglZ7wWKybI6Y0/BVULDe0zpjMXQ8
         nmRLuzkDAjLOhPAHZuSzp7CyF1i7uzQHP4+XxcC8=
Date:   Mon, 17 Feb 2020 17:29:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/10] sysfs: add
 sysfs_file_change_owner{_by_name}()
Message-ID: <20200217162912.GB1502885@kroah.com>
References: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
 <20200217161436.1748598-2-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217161436.1748598-2-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 05:14:27PM +0100, Christian Brauner wrote:
> Add helpers to change owner of a sysfs files.
> The ownership of a sysfs object is determined based on the ownership of
> the corresponding kobject, i.e. only if the ownership of a kobject is
> changed will this function change the ownership of the corresponding
> sysfs entry.
> This function will be used to correctly account for kobject ownership
> changes, e.g. when moving network devices between network namespaces.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> /* v2 */
> -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>    - Better naming for sysfs_file_change_owner() to reflect the fact that it
>      can be used to change the owner of the kobject itself by passing NULL as
>      argument.
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - Split sysfs_file_change_owner() into two helpers sysfs_change_owner() and
>     sysfs_change_owner_by_name(). The former changes the owner of the kobject
>     itself, the latter the owner of the kobject looked up via the name
>     argument.
> ---
>  fs/sysfs/file.c       | 82 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/sysfs.h | 14 ++++++++
>  2 files changed, 96 insertions(+)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 130fc6fbcc03..8f2607de2456 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -558,3 +558,85 @@ void sysfs_remove_bin_file(struct kobject *kobj,
>  	kernfs_remove_by_name(kobj->sd, attr->attr.name);
>  }
>  EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
> +
> +static int internal_change_owner(struct kernfs_node *kn, struct kobject *kobj)
> +{
> +	kuid_t uid;
> +	kgid_t gid;
> +	struct iattr newattrs = {
> +		.ia_valid = ATTR_UID | ATTR_GID,
> +	};
> +
> +	kobject_get_ownership(kobj, &uid, &gid);
> +	newattrs.ia_uid = uid;
> +	newattrs.ia_gid = gid;
> +
> +	return kernfs_setattr(kn, &newattrs);
> +}
> +
> +/**
> + *	sysfs_file_change_owner_by_name - change owner of a file.
> + *	@kobj:	object.
> + *	@name:	name of the file to change.
> + *
> + * To change the ownership of a sysfs object, the caller must first change the
> + * uid/gid of the kobject and then call this function.

Why have the caller do this?  Why not pass the uid/gid as a parameter
here?  That would make it totally obvious as to what is happening here,
right?

Otherwise this function is depending on someone doing something before
calling it, and that's going to be a very very hard thing to always
ensure/audit.

thanks,

greg k-h
