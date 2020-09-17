Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65CF26E5AB
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgIQTzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbgIQTza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 15:55:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 894D921D41;
        Thu, 17 Sep 2020 19:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600372017;
        bh=qxHLxUPwGGwNfTlng/eAv1kLQCE/oayJrAReryr/hTE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FI8gtXtVLGZ0+cPmoUQ1yaSWJMt0go0DdxZpKGAL8DXBBC5QD7bFhUQwRKMnYxVDy
         GyRtkX+pGaeFKd2Qc/PTqgnSn4u5pPXUDPIV12o9Pf0GOX1a/LAWZWBdjKUUFBi6vd
         y4cBtZtQwLhnOcQcxCMXp1MAWgEkSzv4IjQ3jtWo=
Date:   Thu, 17 Sep 2020 12:46:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4 net-next 1/5] devlink: add timeout information to
 status_notify
Message-ID: <20200917124655.6bc16d99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200917030204.50098-2-snelson@pensando.io>
References: <20200917030204.50098-1-snelson@pensando.io>
        <20200917030204.50098-2-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Sep 2020 20:02:00 -0700 Shannon Nelson wrote:
> Add a timeout element to the DEVLINK_CMD_FLASH_UPDATE_STATUS
> netlink message for use by a userland utility to show that
> a particular firmware flash activity may take a long but
> bounded time to finish.  Also add a handy helper for drivers
> to make use of the new timeout value.
> 
> UI usage hints:
>  - if non-zero, add timeout display to the end of the status line
>  	[component] status_msg  ( Xm Ys : Am Bs )
>      using the timeout value for Am Bs and updating the Xm Ys
>      every second
>  - if the timeout expires while awaiting the next update,
>    display something like
>  	[component] status_msg  ( timeout reached : Am Bs )
>  - if new status notify messages are received, remove
>    the timeout and start over
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Minor nits, otherwise LGTM:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

> @@ -3052,6 +3054,9 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
>  	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
>  			      total, DEVLINK_ATTR_PAD))
>  		goto nla_put_failure;
> +	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,
> +			      timeout, DEVLINK_ATTR_PAD))
> +		goto nla_put_failure;

nit: since old kernels don't report this user space has to deal with it
     not being present so I'd be tempted to only report it if timeout
     is not 0

> +void devlink_flash_update_timeout_notify(struct devlink *devlink,
> +					 const char *status_msg,
> +					 const char *component,
> +					 unsigned long timeout)
> +{
> +	__devlink_flash_update_notify(devlink,
> +				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
> +				      status_msg, component, 0, 0, timeout);

nit: did we ever report cmd == UPDATE_STATUS and total == 0?
     could this cause a division by zero in some unsuspecting
     implementation? Perhaps we should pass 1 here?

> +}
> +EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);

