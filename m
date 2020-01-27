Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B8714A6A3
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgA0O55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgA0O55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 09:57:57 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C6E520716;
        Mon, 27 Jan 2020 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580137076;
        bh=QoX5BQawDTzvqFEyrF8WyQ+rpOdNfBu49l9GjfnLaGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sG5QyCkb0e38UnGeGghOQ2nieLmH4mXt46uFIsfd7t9Jl4NGUXe+29MPPRSEHiUct
         1OK0UlVsI3M6pgCdd5gBItoGZW9HcJ6gihFWhYhLsXFjG3gSC0sneWsLSz++TYbQkl
         QPROXJVHAJQPi/jGrk6WWrQNWNV+mqyL27vUEn9w=
Date:   Mon, 27 Jan 2020 06:57:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/6] netdevsim: fix race conditions in netdevsim
 operations
Message-ID: <20200127065755.12cf7eb6@cakuba>
In-Reply-To: <20200127142957.1177-1-ap420073@gmail.com>
References: <20200127142957.1177-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 14:29:57 +0000, Taehee Yoo wrote:
> This patch fixes a several locking problem.
> 
> 1. netdevsim basic operations(new_device, del_device, new_port,
> and del_port) are called with sysfs.
> These operations use the same resource so they should acquire a lock for
> the whole resource not only for a list.
> 2. devices are managed by nsim_bus_dev_list. and all devices are deleted
> in the __exit() routine. After delete routine, new_device() and
> del_device() should be disallowed. So, the global flag variable 'enable'
> is added.
> 3. new_port() and del_port() would be called before resources are
> allocated or initialized. If so, panic will occur.
> In order to avoid this scenario, variable 'nsim_bus_dev->init' is added.

> Fixes: f9d9db47d3ba ("netdevsim: add bus attributes to add new and delete devices")
> Fixes: 794b2c05ca1c ("netdevsim: extend device attrs to support port addition and deletion")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> 
> v1 -> v2
>  - Do not use trylock
>  - Do not include code, which fixes devlink reload problem
>  - Update Fixes tags
>  - Update comments

Thank you for the update!

> diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
> index 6aeed0c600f8..a3205fd73c8f 100644
> --- a/drivers/net/netdevsim/bus.c
> +++ b/drivers/net/netdevsim/bus.c
> @@ -16,7 +16,8 @@
>  
>  static DEFINE_IDA(nsim_bus_dev_ids);
>  static LIST_HEAD(nsim_bus_dev_list);
> -static DEFINE_MUTEX(nsim_bus_dev_list_lock);
> +static DEFINE_MUTEX(nsim_bus_dev_ops_lock);
> +static bool enable;
>  
>  static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
>  {
> @@ -99,6 +100,8 @@ new_port_store(struct device *dev, struct device_attribute *attr,
>  	unsigned int port_index;
>  	int ret;
>  
> +	if (!nsim_bus_dev->init)
> +		return -EBUSY;

I think we should use the acquire/release semantics on those variables.
The init should be smp_store_release() and the read in ops should use
smp_load_acquire().

With that we should be able to move the new variable manipulation out
of the bus_dev lock section. Having a lock for operations/code is a
little bit of a bad code trait, as locks should generally protect data.
The lock could then remain as is just for protecting operations on the
list.

>  	ret = kstrtouint(buf, 0, &port_index);
>  	if (ret)
>  		return ret;
> @@ -116,6 +119,8 @@ del_port_store(struct device *dev, struct device_attribute *attr,
>  	unsigned int port_index;
>  	int ret;
>  
> +	if (!nsim_bus_dev->init)
> +		return -EBUSY;
>  	ret = kstrtouint(buf, 0, &port_index);
>  	if (ret)
>  		return ret;
> @@ -179,13 +184,21 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
>  		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
>  		return -EINVAL;
>  	}
> +	mutex_lock(&nsim_bus_dev_ops_lock);
> +	if (!enable) {
> +		mutex_unlock(&nsim_bus_dev_ops_lock);
> +		return -EBUSY;
> +	}
>  	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
> -	if (IS_ERR(nsim_bus_dev))
> +	if (IS_ERR(nsim_bus_dev)) {
> +		mutex_unlock(&nsim_bus_dev_ops_lock);
>  		return PTR_ERR(nsim_bus_dev);
> +	}
> +
> +	nsim_bus_dev->init = true;

Not sure it matters but perhaps set it to init after its added to the
list? Should it also be set to false before remove?

Thanks again for this work, I'll look at the other patches later today.
