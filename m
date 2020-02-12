Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C415A9E3
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 14:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgBLNSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 08:18:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgBLNSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 08:18:11 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B4EF2073C;
        Wed, 12 Feb 2020 13:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581513489;
        bh=9lC0NLLMXRwM/8N7YwMQM48/0FD5N7I+tSFUZTrgg8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=veYP90b3VCLa7J6+E0JrAnlQXvFD1YCR9D+Bhuba8wyocvmCOc7o8LpPSS/PcU5Dh
         i4W3vx+L/ssQ9OE1/qNgOz9rdzzzikiotkNEUjNu1vKWZceXFl7sgUlhBhpA9o5dM7
         PLd8FL6mj5lUvo8XqCiEjLnynBKXMyt/o9nnFI3k=
Date:   Wed, 12 Feb 2020 05:18:08 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next 05/10] sysfs: add sysfs_change_owner()
Message-ID: <20200212131808.GA1789899@kroah.com>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
 <20200212104321.43570-6-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212104321.43570-6-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 11:43:16AM +0100, Christian Brauner wrote:
> Add a helper to change the owner of sysfs objects.

Seems sane, but:

> The ownership of a sysfs object is determined based on the ownership of
> the corresponding kobject, i.e. only if the ownership of a kobject is
> changed will this function change the ownership of the corresponding
> sysfs entry.

A "sysfs object" is a kobject.  So I don't understand this sentance,
sorry.

> This function will be used to correctly account for kobject ownership
> changes, e.g. when moving network devices between network namespaces.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/sysfs/file.c       | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/sysfs.h |  6 ++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 6239d9584f0b..6a0fe88061fd 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -642,3 +642,38 @@ int sysfs_file_change_owner(struct kobject *kobj, const char *name)
>  	return error;
>  }
>  EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
> +
> +/**
> + *	sysfs_change_owner - change owner of the given object.
> + *	@kobj:	object.
> + */
> +int sysfs_change_owner(struct kobject *kobj)

What does this change the owner of the given object _to_?

> +{
> +	int error;
> +	const struct kobj_type *ktype;
> +
> +	if (!kobj->state_in_sysfs)
> +		return -EINVAL;
> +
> +	error = sysfs_file_change_owner(kobj, NULL);

It passes NULL?


> +	if (error)
> +		return error;
> +
> +	ktype = get_ktype(kobj);
> +	if (ktype) {
> +		struct attribute **kattr;
> +
> +		for (kattr = ktype->default_attrs; kattr && *kattr; kattr++) {
> +			error = sysfs_file_change_owner(kobj, (*kattr)->name);
> +			if (error)
> +				return error;
> +		}
> +
> +		error = sysfs_groups_change_owner(kobj, ktype->default_groups);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(sysfs_change_owner);

I can understand wanting to change owners/groups/whatever of existing
sysfs objects and their files, but I can't figure out how to call this
function to set the attribute I want to change.

With only one parameter, how does this work?  It guesses?  :)

thanks,

greg k-h
