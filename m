Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87CFC15A9E9
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 14:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgBLNTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 08:19:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbgBLNTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 08:19:15 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFFC62073C;
        Wed, 12 Feb 2020 13:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581513554;
        bh=pfctPxOq3Oo0fWEre5o1ODVRSA3mnXI9LwI3me2Urp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AdW7nT74rFgHlaQGBzyCzDkoOyzSDCQO7LWj4oNAruw8Lgl58LeRPboqdMKRTFSOF
         cuTaw4WjmLo6r8DYZhQQuK4etJs3SYMZzE1QYpq05GTNm5n6zF3cigjHrLI2mq+O/1
         izDsP56w08aHfaNzsCHXPZYyr7jCluUXR8CUPbEU=
Date:   Wed, 12 Feb 2020 05:19:14 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next 01/10] sysfs: add sysfs_file_change_owner()
Message-ID: <20200212131914.GB1789899@kroah.com>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
 <20200212104321.43570-2-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212104321.43570-2-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 11:43:12AM +0100, Christian Brauner wrote:
> Add a helper to change the owner of a sysfs file.
> The ownership of a sysfs object is determined based on the ownership of
> the corresponding kobject, i.e. only if the ownership of a kobject is
> changed will this function change the ownership of the corresponding
> sysfs entry.
> This function will be used to correctly account for kobject ownership
> changes, e.g. when moving network devices between network namespaces.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/sysfs/file.c       | 46 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/sysfs.h |  7 +++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 130fc6fbcc03..007b97ca8165 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -558,3 +558,49 @@ void sysfs_remove_bin_file(struct kobject *kobj,
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
> + *	sysfs_file_change_owner - change owner of a file.
> + *	@kobj:	object.
> + *	@name:	name of the file to change.
> + *	        can be NULL to change current file.
> + */
> +int sysfs_file_change_owner(struct kobject *kobj, const char *name)

Same meta-question I did for the other call, what does this set the file
owner to?  How to you specify this?

I understand your overall goal/need here, I'm just not understanding how
this actually changes anything.

lost,

greg k-h
