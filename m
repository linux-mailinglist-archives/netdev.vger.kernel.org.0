Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B85452169
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 05:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfFYDxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 23:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfFYDxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 23:53:51 -0400
Received: from localhost (unknown [116.226.249.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8450520665;
        Tue, 25 Jun 2019 03:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561434830;
        bh=E4nE1EjWI33jbz4SGyWmu9sYfD082jUQXQQfrNoLQXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qZ7XYeo+I3dPO32jVSB6vo+lkkvvs2U54y9HoEjCetrb+kFfpvNKInrA0qvFV3IPw
         IOt7m52Bjp6jnuCYyATUxw1wgbaU9HAoFSXZHVEZj9cGM5NZa0d1grdnDe4CJ8ddBC
         PFaIesiJ+pkH4VGEoyAaQYY1YbdOoOKJEJ6ubYLk=
Date:   Tue, 25 Jun 2019 11:32:16 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eiichi Tsukata <devel@etsukata.com>
Cc:     jslaby@suse.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] tty: ldisc: Fix misuse of proc_dointvec
 "ldisc_autoload"
Message-ID: <20190625033216.GA11902@kroah.com>
References: <20190625030801.24538-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625030801.24538-1-devel@etsukata.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 12:08:00PM +0900, Eiichi Tsukata wrote:
> /proc/sys/dev/tty/ldisc_autoload assumes given value to be 0 or 1. Use
> proc_dointvec_minmax instead of proc_dointvec.
> 
> Fixes: 7c0cca7c847e "(tty: ldisc: add sysctl to prevent autoloading of ldiscs)"
> Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
> ---
>  drivers/tty/tty_ldisc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index e38f104db174..a8ea7a35c94e 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -863,7 +863,7 @@ static struct ctl_table tty_table[] = {
>  		.data		= &tty_ldisc_autoload,
>  		.maxlen		= sizeof(tty_ldisc_autoload),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= &zero,
>  		.extra2		= &one,

Ah, nice catch.  But this really isn't an issue as if you use a bigger
value, things will not "break", right?

thanks,

greg k-h
