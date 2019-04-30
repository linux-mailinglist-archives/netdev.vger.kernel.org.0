Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B1FFD03
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfD3Phy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:37:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53415 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfD3Phx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 11:37:53 -0400
Received: from 162-237-133-238.lightspeed.rcsntx.sbcglobal.net ([162.237.133.238] helo=lindsey)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <tyhicks@canonical.com>)
        id 1hLUp6-00087j-33; Tue, 30 Apr 2019 15:37:36 +0000
Date:   Tue, 30 Apr 2019 10:37:31 -0500
From:   Tyler Hicks <tyhicks@canonical.com>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net-sysfs: Fix error path for kobject_init_and_add()
Message-ID: <20190430153730.GC13709@lindsey>
References: <20190430002817.10785-1-tobin@kernel.org>
 <20190430002817.10785-4-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430002817.10785-4-tobin@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-04-30 10:28:17, Tobin C. Harding wrote:
> Currently error return from kobject_init_and_add() is not followed by a
> call to kobject_put().  This means there is a memory leak.
> 
> Add call to kobject_put() in error path of kobject_init_and_add().
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> ---
>  net/core/net-sysfs.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 8f8b7b6c2945..9d4e3f47b789 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -925,8 +925,10 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
>  	kobj->kset = dev->queues_kset;
>  	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
>  				     "rx-%u", index);
> -	if (error)
> +	if (error) {
> +		kobject_put(kobj);
>  		return error;
> +	}

The commit message of the second patch in this series states, "The
correct cleanup function if a call to kobject_init_and_add() has
returned _successfully_ is kobject_del()." Doesn't that mean that
kobject_del() needs to be called instead of kobject_put() when
sysfs_create_group() fails a little lower in this function?

>  
>  	dev_hold(queue->dev);
>  
> @@ -1462,8 +1464,10 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
>  	kobj->kset = dev->queues_kset;
>  	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
>  				     "tx-%u", index);
> -	if (error)
> +	if (error) {
> +		kobject_put(kobj);
>  		return error;
> +	}
>  
>  	dev_hold(queue->dev);

I think the same s/kobject_put/kobject_del/ substitution may be needed
in this function when sysfs_create_group() fails.

Tyler

>  
> -- 
> 2.21.0
> 
