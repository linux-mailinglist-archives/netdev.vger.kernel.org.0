Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 541FD14F1CC
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgAaSHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:07:14 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 472AA20663;
        Fri, 31 Jan 2020 18:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494033;
        bh=RgD0a05yAr5oVXyE0rsfH+k3SKcawpwF5zZfalvHDN8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gwLauG9XNDz2ScE7FSn24p0X+tmhu2GZBcbzOk6zn/9riChg3Hf3p96UKnFWUhU1h
         dh9try5fDlpO7cYELGYbJSAmL9P59skZXC9rk2v7r/l2EEbd06xTO6ZVIAz/zpwwRS
         kLxNo+BnUzzmwQjtLfQL6wzlCMVInp+rLJrnsvQU=
Date:   Fri, 31 Jan 2020 10:07:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [PATCH 04/15] netdevsim: support taking immediate snapshot via
 devlink
Message-ID: <20200131100712.5ba1ce65@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130225913.1671982-5-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
        <20200130225913.1671982-5-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 14:58:59 -0800, Jacob Keller wrote:
> Implement the .snapshot region operation for the dummy data region. This
> enables a region snapshot to be taken upon request via the new
> DEVLINK_CMD_REGION_SNAPSHOT command.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  drivers/net/netdevsim/dev.c                   | 38 +++++++++++++++----
>  .../drivers/net/netdevsim/devlink.sh          |  5 +++
>  2 files changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index d521b7bfe007..924cd328037f 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -38,24 +38,47 @@ static struct dentry *nsim_dev_ddir;
>  
>  #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
>  
> +static int nsim_dev_take_snapshot(struct devlink *devlink,

nit: break the line after static int, you've done it in other patches
    so I trust you agree it's a superior formatting style :)

> +				  struct netlink_ext_ack *extack,
> +				  u8 **data,
> +				  devlink_snapshot_data_dest_t **destructor)
> +{
> +	void *dummy_data;
> +
> +	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
> +	if (!dummy_data) {
> +		NL_SET_ERR_MSG(extack, "Out of memory");

Unnecessary, there will be an OOM splat, and ENOMEM is basically
exactly the same as the message.

> +		return -ENOMEM;
> +	}
> +
> +	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
> +
> +	*data = dummy_data;
> +	*destructor = kfree;

Is there any driver which uses different destructor for different
snapshots? Looks like something we could put in ops, maybe?

> +	return 0;
> +}
> +
>  static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>  					    const char __user *data,
>  					    size_t count, loff_t *ppos)
>  {
>  	struct nsim_dev *nsim_dev = file->private_data;
> -	void *dummy_data;
> +	devlink_snapshot_data_dest_t *destructor;
> +	u8 *dummy_data;
>  	int err;
>  	u32 id;
>  
> -	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
> -	if (!dummy_data)
> -		return -ENOMEM;
> -
> -	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
> +	err = nsim_dev_take_snapshot(priv_to_devlink(nsim_dev), NULL,
> +				     &dummy_data, &destructor);
> +	if (err) {
> +		pr_err("Failed to capture region snapshot\n");

Also not a very useful message for netdevsim IMHO give the caller
clearly requested a snapshot and will get a more informative error 
from errno.

> +		return err;
> +	}
>  
>  	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
>  	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
> -					     dummy_data, id, kfree);
> +					     dummy_data, id, destructor);
>  	if (err) {
>  		pr_err("Failed to create region snapshot\n");
>  		kfree(dummy_data);
