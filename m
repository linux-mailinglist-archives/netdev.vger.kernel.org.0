Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA6F434D62
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 16:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhJTOYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 10:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhJTOYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 10:24:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4984610E6;
        Wed, 20 Oct 2021 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634739711;
        bh=hdk2wiyhvHwL1F04NVmZSyDGavwMY8ARY9qWFEo85NE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lSJOkLx04pslsmqnJNCPjKbSbQ5cSe7cohfWD+/omsQcFysf2CCPQ3LopAiRhx7ac
         VhT2XD3WgLwRJvFoJ6PqYVixK1so0MzgJFgXxJ2Gv+sG7QcZDT4Jg5hihqqdz5yQRa
         Tm6SsyDeRqbbZm53HPfBbSQhvoE+q8KDQLYkAkKOPS0tWo2WuXCDX/QXJGEqj9/67q
         ml8VjglQl/n/OFq6rOxHXrnY9C22md43mKpKurfuJo+xMtW79SIF2H2FeD7ZTqjc4I
         S+wwrkVmp1pb4KA1kVG6Y6SIEA5WiEcjUdO8RALnKeXh85VlVMyDHKHEkZB32kFAGN
         gCknjyWoB5Ekg==
Date:   Wed, 20 Oct 2021 07:21:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>
Subject: Re: [PATCH] ptp: Fix possible memory leak in ptp_clock_register()
Message-ID: <20211020072150.5e2873e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211020081834.2952888-1-yangyingliang@huawei.com>
References: <20211020081834.2952888-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Oct 2021 16:18:34 +0800 Yang Yingliang wrote:
> I got memory leak as follows when doing fault injection test:
> 
> unreferenced object 0xffff88800906c618 (size 8):
>   comm "i2c-idt82p33931", pid 4421, jiffies 4294948083 (age 13.188s)
>   hex dump (first 8 bytes):
>     70 74 70 30 00 00 00 00                          ptp0....
>   backtrace:
>     [<00000000312ed458>] __kmalloc_track_caller+0x19f/0x3a0
>     [<0000000079f6e2ff>] kvasprintf+0xb5/0x150
>     [<0000000026aae54f>] kvasprintf_const+0x60/0x190
>     [<00000000f323a5f7>] kobject_set_name_vargs+0x56/0x150
>     [<000000004e35abdd>] dev_set_name+0xc0/0x100
>     [<00000000f20cfe25>] ptp_clock_register+0x9f4/0xd30 [ptp]
>     [<000000008bb9f0de>] idt82p33_probe.cold+0x8b6/0x1561 [ptp_idt82p33]
> 
> When posix_clock_register() returns an error, the name allocated
> in dev_set_name() will be leaked, the put_device() should be used
> to give up the device reference, then the name will be freed in
> kobject_cleanup() and other memory will be freed in ptp_clock_release().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock and cdev")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index 4dfc52e06704..7fd02aabd79a 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -283,15 +283,22 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  	/* Create a posix clock and link it to the device. */
>  	err = posix_clock_register(&ptp->clock, &ptp->dev);
>  	if (err) {
> +	        if (ptp->pps_source)
> +	                pps_unregister_source(ptp->pps_source);
> +
> +		kfree(ptp->vclock_index);

I think the way ptp->vclock_index is freed is also buggy.

It's accessed from sysfs so it should be freed from the release
function, not directly here or in ptp_clock_unregister(), right?

If that makes sense please submit a separate fix for the issue.

> +		if (ptp->kworker)
> +	                kthread_destroy_worker(ptp->kworker);
> +
> +		put_device(&ptp->dev);
> +
>  		pr_err("failed to create posix clock\n");
> -		goto no_clock;
> +		return ERR_PTR(err);
>  	}
>  
>  	return ptp;
>  
> -no_clock:
> -	if (ptp->pps_source)
> -		pps_unregister_source(ptp->pps_source);
>  no_pps:
>  	ptp_cleanup_pin_groups(ptp);
>  no_pin_groups:

