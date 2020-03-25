Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BA0193007
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgCYSE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgCYSE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 14:04:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2B320774;
        Wed, 25 Mar 2020 18:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585159466;
        bh=oQMG5rv39wkicOhqgox4y3rucJaGE4AleOjEWeglIjA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iYGRH1ABzjQn2eMhaSOIoJ4nuAD4iDWebQ91iq7pDwlQJrWfe4DR0Hh5SQW/wSP5l
         72k81UDagPUgFH/4xOGGMDotk7ddIHnyoBRYNUxawJ2/+HEixIwVX6dgSdLpcbYUu9
         tzMrRkxbKbd2YtfLxqFIlT+gJa+eKn/gnSOig7zE=
Date:   Wed, 25 Mar 2020 11:04:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH 06/10] devlink: convert snapshot id getter to return an
 error
Message-ID: <20200325110425.6fdf6cb3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200324223445.2077900-7-jacob.e.keller@intel.com>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
        <20200324223445.2077900-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 15:34:41 -0700 Jacob Keller wrote:
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index f7621ccb7b88..f9420b77e5fd 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -45,8 +45,7 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>  {
>  	struct nsim_dev *nsim_dev = file->private_data;
>  	void *dummy_data;
> -	int err;
> -	u32 id;
> +	int err, id;
>  
>  	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
>  	if (!dummy_data)
> @@ -55,6 +54,10 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>  	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
>  
>  	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
> +	if (id < 0) {
> +		pr_err("Failed to get snapshot id\n");
> +		return id;
> +	}
>  	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
>  					     dummy_data, id);
>  	if (err) {

Hmm... next patch introduces some ref counting on the ID AFAICT,
should there be some form of snapshot_id_put(), once the driver is 
done creating the regions it wants?

First what if driver wants to create two snapshots with the same ID but
user space manages to delete the first one before second one is created.

Second what if create fails, won't the snapshot ID just stay in XA with
count of 0 forever?
