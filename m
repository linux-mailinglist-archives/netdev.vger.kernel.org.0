Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD392850B3
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 19:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgJFRXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 13:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgJFRXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 13:23:22 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB0420782;
        Tue,  6 Oct 2020 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602005002;
        bh=O8037/XQX9BMZhwDeVVw/xrgcB1aBDB18FxCjX2E5Bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gEvAWCYYLyEIbgMzIMDzaE1mi8CXHQt4WiqgEJzlzaS35baukykaJVSXX150gy+kv
         EbaFpf1GvtUgK9iNI9VMmmvhBGYcoQlCkM2ZvTiyIqZaK4/IkigHEgO2YT2XNBervS
         OFpTXKQc7GZgOgtU8WDmPPctfymrriTdmVZgesdg=
Date:   Tue, 6 Oct 2020 20:23:17 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dave Ertman <david.m.ertman@intel.com>
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201006172317.GN1874917@unreal>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005182446.977325-2-david.m.ertman@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 11:24:41AM -0700, Dave Ertman wrote:
> Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> It enables drivers to create an ancillary_device and bind an
> ancillary_driver to it.
>
> The bus supports probe/remove shutdown and suspend/resume callbacks.
> Each ancillary_device has a unique string based id; driver binds to
> an ancillary_device based on this id through the bus.
>
> Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> ---

<...>

> +/**
> + * __ancillary_driver_register - register a driver for ancillary bus devices
> + * @ancildrv: ancillary_driver structure
> + * @owner: owning module/driver
> + */
> +int __ancillary_driver_register(struct ancillary_driver *ancildrv, struct module *owner)
> +{
> +	if (WARN_ON(!ancildrv->probe) || WARN_ON(!ancildrv->remove) ||
> +	    WARN_ON(!ancildrv->shutdown) || WARN_ON(!ancildrv->id_table))
> +		return -EINVAL;

In our driver ->shutdown is empty, it will be best if ancillary bus will
do "if (->remove) ..->remove()" pattern.

> +
> +	ancildrv->driver.owner = owner;
> +	ancildrv->driver.bus = &ancillary_bus_type;
> +	ancildrv->driver.probe = ancillary_probe_driver;
> +	ancildrv->driver.remove = ancillary_remove_driver;
> +	ancildrv->driver.shutdown = ancillary_shutdown_driver;
> +

I think that this part is wrong, probe/remove/shutdown functions should
come from ancillary_bus_type. You are overwriting private device_driver
callbacks that makes impossible to make container_of of ancillary_driver
to chain operations.

> +	return driver_register(&ancildrv->driver);
> +}
> +EXPORT_SYMBOL_GPL(__ancillary_driver_register);

Thanks
