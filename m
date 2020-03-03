Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B326D177ADC
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgCCPps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgCCPps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 10:45:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E05920866;
        Tue,  3 Mar 2020 15:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583250347;
        bh=z5nWKuS/khPhliMHj8TpNY3sQbtrknIN7DQujN39tZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P7wXwy2Bz4x0RvuzC/DhA4EJpLvVXX2PXb8Xixn51bGROSb4aa1trnHIJJRIQkIme
         ZcCkcCnUin0SUXPe9u0eeJyVEO3z0/LgFOfGvWQuOhdV6c2z6ytx3osCVFsmN5AeoI
         cgcfFt9n1taTxnAzB+UuXifUkL5rAynZKAFLT5VM=
Date:   Tue, 3 Mar 2020 16:45:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yangerkun <yangerkun@huawei.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH linux-4.4.y/linux-4.9.y v2] slip: stop double free
 sl->dev in slip_open
Message-ID: <20200303154545.GC372992@kroah.com>
References: <20200228134048.19675-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228134048.19675-1-yangerkun@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 09:40:48PM +0800, yangerkun wrote:
> After include 3b5a39979daf ("slip: Fix memory leak in slip_open error path")
> and e58c19124189 ("slip: Fix use-after-free Read in slip_open") with 4.4.y/4.9.y.
> We will trigger a bug since we can double free sl->dev in slip_open. Actually,
> we should backport cf124db566e6 ("net: Fix inconsistent teardown and release
> of private netdev state.") too since it has delete free_netdev from sl_free_netdev.
> Fix it by delete free_netdev from slip_open.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  drivers/net/slip/slip.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index 0f8d5609ed51..d4a33baa33b6 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -868,7 +868,6 @@ err_free_chan:
>  	tty->disc_data = NULL;
>  	clear_bit(SLF_INUSE, &sl->flags);
>  	sl_free_netdev(sl->dev);
> -	free_netdev(sl->dev);

Thanks for this, now queued up.

greg k-h
