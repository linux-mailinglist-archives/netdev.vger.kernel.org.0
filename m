Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B964165C90
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 12:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgBTLOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 06:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgBTLOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 06:14:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63D91207FD;
        Thu, 20 Feb 2020 11:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582197285;
        bh=NGuLTwqRIowTiv67qF2Ws5o1JHHbOVRKWl2IuI/0+lk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nb5h0Fn91B3r8V7cp16RJOaxvkgOzkcCLXlaqC1G7Zw6dDKaFM1y6nB+KalNjERYH
         HEQ2ADpe10DqFFwxvjiIbM/mnKhwVmlxfAw6BTywQ5gd5pnAwIx6qZn/PZZMmMxkdR
         ji3YFBO6gRPS96E42BY1ZfFmn7Hw27gaQXfe4FiI=
Date:   Thu, 20 Feb 2020 12:14:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/9] sysfs: add sysfs_link_change_owner()
Message-ID: <20200220111443.GD3374196@kroah.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-3-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218162943.2488012-3-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 05:29:36PM +0100, Christian Brauner wrote:
> Add a helper to change the owner of a sysfs link.
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
>  fs/sysfs/file.c       | 40 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/sysfs.h | 10 ++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 32bb04b4d9d9..df5107d7b3fd 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -570,6 +570,46 @@ static int internal_change_owner(struct kernfs_node *kn, struct kobject *kobj,
>  	return kernfs_setattr(kn, &newattrs);
>  }
>  
> +/**
> + *	sysfs_link_change_owner - change owner of a link.
> + *	@kobj:	object of the kernfs_node the symlink is located in.
> + *	@targ:	object of the kernfs_node the symlink points to.
> + *	@name:	name of the link.
> + *	@kuid:	new owner's kuid
> + *	@kgid:	new owner's kgid
> + */
> +int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
> +			    const char *name, kuid_t kuid, kgid_t kgid)
> +{
> +	struct kernfs_node *parent, *kn = NULL;
> +	int error;
> +
> +	if (!kobj)
> +		parent = sysfs_root_kn;
> +	else
> +		parent = kobj->sd;

I don't understand this, why would (!kobj) ever be a valid situation?

> +	if (!targ->state_in_sysfs)
> +		return -EINVAL;

Should you also check kobj->state_in_sysfs as well?

thanks,

greg k-h
