Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B3F14AE90
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 05:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgA1EER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 23:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgA1EEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 23:04:16 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 841C42173E;
        Tue, 28 Jan 2020 04:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580184255;
        bh=9tOpVc1d3p99Nigt+fYdy50b08XiJa5V0dzKgQVxDFw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xlaf4402HyIIGGhGkBlOCuTz8bON6Y2/6DkQtBNodjITLbvSJjAt7maf5swWDi2v/
         XgLIK/NyfQIoGvWKwwcwsv103hx/1Im4tb3F6f36i6wTQunHVe0jRDDmlCfSd4S/Ps
         7+oXb5TvIqqcX/Y7GRz+dZADyWFI1J23x6kL4pC8=
Date:   Mon, 27 Jan 2020 20:04:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 2/6] netdevsim: disable devlink reload when
 resources are being used
Message-ID: <20200127200414.41a6d521@cakuba>
In-Reply-To: <20200127143015.1264-1-ap420073@gmail.com>
References: <20200127143015.1264-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 14:30:15 +0000, Taehee Yoo wrote:
> devlink reload destroys resources and allocates resources again.
> So, when devices and ports resources are being used, devlink reload
> function should not be executed. In order to avoid this race, a new
> lock is added and new_port() and del_port() call devlink_reload_disable()
> and devlink_reload_enable().
> 
> Thread0                      Thread1
> {new/del}_port()             {new/del}_port()
> devlink_reload_disable()
>                              devlink_reload_disable()
> devlink_reload_enable()      //here
>                              devlink_reload_enable()
> 
> Before Thread1's devlink_reload_enable(), the devlink is already allowed
> to execute reload because Thread0 allows it. devlink reload disable/enable
> variable type is bool. So the above case would exist.
> So, disable/enable should be executed atomically.
> In order to do that, a new lock is used.
> 
> Test commands:
>     modprobe netdevsim
>     echo 1 > /sys/bus/netdevsim/new_device
> 
>     while :
>     do
>         echo 1 > /sys/devices/netdevsim1/new_port &
>         echo 1 > /sys/devices/netdevsim1/del_port &
>         devlink dev reload netdevsim/netdevsim1 &
>     done
> 
> Splat looks like:
> [ 1067.313531][ T1480] kernel BUG at lib/list_debug.c:53!
> [ 1067.314519][ T1480] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
> [ 1067.315948][ T1480] CPU: 3 PID: 1480 Comm: bash Tainted: G        W         5.5.0-rc6+ #318
> [ 1067.326082][ T1480] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [ 1067.356308][ T1480] RIP: 0010:__list_del_entry_valid+0xe6/0x150
> [ 1067.357006][ T1480] Code: 89 ea 48 c7 c7 a0 64 1e 9f e8 7f 5b 4d ff 0f 0b 48 c7 c7 00 65 1e 9f e8 71 5b 4d ff 4
> [ 1067.395359][ T1480] RSP: 0018:ffff8880a316fb58 EFLAGS: 00010282
> [ 1067.396016][ T1480] RAX: 0000000000000054 RBX: ffff8880c0e76718 RCX: 0000000000000000
> [ 1067.402370][ T1480] RDX: 0000000000000054 RSI: 0000000000000008 RDI: ffffed101462df61
> [ 1067.430844][ T1480] RBP: ffff8880a31bfca0 R08: ffffed101b5404f9 R09: ffffed101b5404f9
> [ 1067.432165][ T1480] R10: 0000000000000001 R11: ffffed101b5404f8 R12: ffff8880a316fcb0
> [ 1067.433526][ T1480] R13: ffff8880a310d440 R14: ffffffffa117a7c0 R15: ffff8880c0e766c0
> [ 1067.435818][ T1480] FS:  00007f001c026740(0000) GS:ffff8880da800000(0000) knlGS:0000000000000000
> [ 1067.441677][ T1480] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1067.451305][ T1480] CR2: 00007f001afb7180 CR3: 00000000a3170003 CR4: 00000000000606e0
> [ 1067.453416][ T1480] Call Trace:
> [ 1067.453832][ T1480]  mutex_remove_waiter+0x101/0x520
> [ 1067.455949][ T1480]  __mutex_lock+0xac7/0x14b0
> [ 1067.456880][ T1480]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
> [ 1067.458946][ T1480]  ? mutex_lock_io_nested+0x1380/0x1380
> [ 1067.460614][ T1480]  ? _parse_integer+0xf0/0xf0
> [ 1067.472498][ T1480]  ? kstrtouint+0x86/0x110
> [ 1067.473327][ T1480]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
> [ 1067.474187][ T1480]  nsim_dev_port_add+0x50/0x150 [netdevsim]
> [ 1067.474980][ T1480]  new_port_store+0xc4/0xf0 [netdevsim]
> [ 1067.475717][ T1480]  ? del_port_store+0xf0/0xf0 [netdevsim]
> [ 1067.476478][ T1480]  ? sysfs_kf_write+0x3b/0x180
> [ 1067.477106][ T1480]  ? sysfs_file_ops+0x160/0x160
> [ 1067.477744][ T1480]  kernfs_fop_write+0x276/0x410
> [ ... ]
> 
> Fixes: 4418f862d675 ("netdevsim: implement support for devlink region and snapshots")
> Fixes: 75ba029f3c07 ("netdevsim: implement proper devlink reload")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/net/netdevsim/bus.c       | 21 ++++++++++++++++++++-
>  drivers/net/netdevsim/dev.c       | 14 ++++++++++++++
>  drivers/net/netdevsim/netdevsim.h |  4 ++++
>  3 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
> index a3205fd73c8f..b1aed37a0574 100644
> --- a/drivers/net/netdevsim/bus.c
> +++ b/drivers/net/netdevsim/bus.c
> @@ -16,7 +16,7 @@
>  
>  static DEFINE_IDA(nsim_bus_dev_ids);
>  static LIST_HEAD(nsim_bus_dev_list);
> -static DEFINE_MUTEX(nsim_bus_dev_ops_lock);
> +DEFINE_MUTEX(nsim_bus_dev_ops_lock);
>  static bool enable;
>  
>  static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
> @@ -97,6 +97,8 @@ new_port_store(struct device *dev, struct device_attribute *attr,
>  	       const char *buf, size_t count)
>  {
>  	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
> +	struct nsim_dev *nsim_dev = dev_get_drvdata(dev);
> +	struct devlink *devlink;
>  	unsigned int port_index;
>  	int ret;
>  
> @@ -105,7 +107,14 @@ new_port_store(struct device *dev, struct device_attribute *attr,
>  	ret = kstrtouint(buf, 0, &port_index);
>  	if (ret)
>  		return ret;
> +
> +	devlink = priv_to_devlink(nsim_dev);
> +
> +	mutex_lock(&nsim_bus_dev->port_ops_lock);
> +	devlink_reload_disable(devlink);
>  	ret = nsim_dev_port_add(nsim_bus_dev, port_index);
> +	devlink_reload_enable(devlink);
> +	mutex_unlock(&nsim_bus_dev->port_ops_lock);
>  	return ret ? ret : count;
>  }
>  
> @@ -116,6 +125,8 @@ del_port_store(struct device *dev, struct device_attribute *attr,
>  	       const char *buf, size_t count)
>  {
>  	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
> +	struct nsim_dev *nsim_dev = dev_get_drvdata(dev);
> +	struct devlink *devlink;
>  	unsigned int port_index;
>  	int ret;
>  
> @@ -124,7 +135,14 @@ del_port_store(struct device *dev, struct device_attribute *attr,
>  	ret = kstrtouint(buf, 0, &port_index);
>  	if (ret)
>  		return ret;
> +
> +	devlink = priv_to_devlink(nsim_dev);
> +
> +	mutex_lock(&nsim_bus_dev->port_ops_lock);
> +	devlink_reload_disable(devlink);
>  	ret = nsim_dev_port_del(nsim_bus_dev, port_index);
> +	devlink_reload_enable(devlink);
> +	mutex_unlock(&nsim_bus_dev->port_ops_lock);
>  	return ret ? ret : count;
>  }
>  
> @@ -301,6 +319,7 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
>  	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
>  	nsim_bus_dev->port_count = port_count;
>  	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
> +	mutex_init(&nsim_bus_dev->port_ops_lock);
>  
>  	err = device_register(&nsim_bus_dev->dev);
>  	if (err)

Disabling reload around port add/del makes perfect sense

> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 4b39aba2e9c4..0dfaf999e8db 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -43,6 +43,8 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>  					    size_t count, loff_t *ppos)
>  {
>  	struct nsim_dev *nsim_dev = file->private_data;
> +	struct nsim_bus_dev *nsim_bus_dev;
> +	struct devlink *devlink;
>  	void *dummy_data;
>  	int err;
>  	u32 id;
> @@ -51,11 +53,23 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>  	if (!dummy_data)
>  		return -ENOMEM;
>  
> +	devlink = priv_to_devlink(nsim_dev);
> +	nsim_bus_dev = nsim_dev->nsim_bus_dev;
> +
>  	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
>  
> +	mutex_lock(&nsim_bus_dev_ops_lock);

Not sure why we have to lock the big lock here?

> +	mutex_lock(&nsim_bus_dev->port_ops_lock);
> +	devlink_reload_disable(devlink);

Or the port lock, or disable reload - the reload path unregisters and
re-registers the snapshot, so snapshot can't be taken during reload, 
I don't think.

>  	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
>  	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
>  					     dummy_data, id, kfree);
> +
> +	devlink_reload_enable(devlink);
> +	mutex_unlock(&nsim_bus_dev->port_ops_lock);
> +	mutex_unlock(&nsim_bus_dev_ops_lock);
> +
>  	if (err) {
>  		pr_err("Failed to create region snapshot\n");
>  		kfree(dummy_data);
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index ea3931391ce2..a8b6c9e6f79f 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -74,6 +74,8 @@ struct netdevsim {
>  	struct nsim_ipsec ipsec;
>  };
>  
> +extern struct mutex nsim_bus_dev_ops_lock;
> +
>  struct netdevsim *
>  nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port);
>  void nsim_destroy(struct netdevsim *ns);
> @@ -240,6 +242,8 @@ struct nsim_bus_dev {
>  				  */
>  	unsigned int num_vfs;
>  	struct nsim_vf_config *vfconfigs;
> +	/* Lock for new_port() and del_port() to disable devlink reload */

It'd be good to have the comment point out which fields the lock
protects, rather than code.

> +	struct mutex port_ops_lock;
>  	bool init;
>  };
>  

