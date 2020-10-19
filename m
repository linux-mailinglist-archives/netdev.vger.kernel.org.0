Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CBA2927E4
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 15:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgJSNH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 09:07:59 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:64501 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbgJSNH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 09:07:58 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8d8fad0000>; Mon, 19 Oct 2020 21:07:57 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 19 Oct
 2020 13:07:56 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 19 Oct 2020 13:07:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvArQowf0yQkzo/xpV/rsI2KKOsBpqJtI2o+5UiGuPK7oCrb2203PuuNL917+cvtnpztrWoanmv2G1xB/YEfXRiEmUhwLhpOwJoYf1UHHvBNTS0Yo77TsTXpa+J4XAZixDHkLLHSm5EJmnZ3wZmCfrMEGbTsyNygZaHSp5IDJNQTYYxvp2W4rFDfa803LAv0rV3aLm/+KACUWHX9ZoWBtAFDEejaRlqLleRlPOtxM584fOU9ZR7UXh0jZWiQ2dQanzDxUoHzSGoKcKq0Mq7tUgTVR//XRrYyGbZBixY6eW51mzhyvo7UC0WZEDJfzNqCseQ0p/jZV4KibWr68URi6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=097NwGjpIIx8sEtxMBLE+GWTGs0qgymU8Bo/6QZMedI=;
 b=D9eAru01dHqzafV4nFqaU0++MC4OR9WEroQzFwxm4qpO0cMViVyszzqdwPtnAEe3jLexs4Zd7aeW08pxhl7qv+M8CCVYc8rQZvd/8GknkyNzBtHbNiAFaLAByOE2BOZBZfqlVsrV7Ypo+5VQI1ZG0us9zyMJ0WyJ4tVwt7h6RON5G349Swv1TA9BsVCGXhUM55D8LcC0c2QMgL3xoZdygULSkvyY1y4xSjM3Z9zVvV+BVrE/qbBOJHQC1t5Zwucy7/9YduOKg2rw5zrYns3phDv/WW2oLbdZPK3I6f1A11EOCZYXJqcBWzBB94oNY+a2x8nb6F6wRZR7r1w9VjD6TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4973.namprd12.prod.outlook.com (2603:10b6:5:1b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 19 Oct
 2020 13:07:54 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 13:07:53 +0000
Date:   Mon, 19 Oct 2020 10:07:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Message-ID: <20201019130751.GE6219@nvidia.com>
References: <20201019052736.628909-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201019052736.628909-1-leon@kernel.org>
X-ClientProxiedBy: BL0PR0102CA0072.prod.exchangelabs.com
 (2603:10b6:208:25::49) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0072.prod.exchangelabs.com (2603:10b6:208:25::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23 via Frontend Transport; Mon, 19 Oct 2020 13:07:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kUUtD-002J3n-Ti; Mon, 19 Oct 2020 10:07:51 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603112877; bh=097NwGjpIIx8sEtxMBLE+GWTGs0qgymU8Bo/6QZMedI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=M5jdZNnsBtY/AJB84xyhRMn/Q6vgGr2RKDJxajyzfrQ/xt18gYDHuZrFMC+9ZTqZH
         fcmWOhYoL2eRKXSiG9slzs90Z6tYQta9A7ByUha8ykW62Rf08+9skZOOeSkyPtjBD+
         waEkYhsQxaOoeE8JWIiGbYaG9ugd4AP6jOWDzSOUzNhVhq/7YGTfi3fAVN+JIP/0kO
         snvXDnthh/TRTCXm1q8NSMQLvHdILG6ZQpw104bTa+khW+BMWWT9of6G6RXEwBieJT
         bFAkujd035JquY8rBwjALgs3iRC99wqvDMmoBlRFnubTXfxib+ewyyU8S0+3z4PCYu
         gSG1mASREQPBg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 08:27:36AM +0300, Leon Romanovsky wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> When a mlx5 core devlink instance is reloaded in different net
> namespace, its associated IB device is deleted and recreated.
> 
> Example sequence is:
> $ ip netns add foo
> $ devlink dev reload pci/0000:00:08.0 netns foo
> $ ip netns del foo
> 
> mlx5 IB device needs to attach and detach the netdevice to it
> through the netdev notifier chain during load and unload sequence.
> A below call graph of the unload flow.
> 
> cleanup_net()
>    down_read(&pernet_ops_rwsem); <- first sem acquired
>      ops_pre_exit_list()
>        pre_exit()
>          devlink_pernet_pre_exit()
>            devlink_reload()
>              mlx5_devlink_reload_down()
>                mlx5_unload_one()
>                [...]
>                  mlx5_ib_remove()
>                    mlx5_ib_unbind_slave_port()
>                      mlx5_remove_netdev_notifier()
>                        unregister_netdevice_notifier()
>                          down_write(&pernet_ops_rwsem);<- recurrsive lock
> 
> Hence, when net namespace is deleted, mlx5 reload results in deadlock.
> 
> When deadlock occurs, devlink mutex is also held. This not only deadlocks
> the mlx5 device under reload, but all the processes which attempt to access
> unrelated devlink devices are deadlocked.
> 
> Hence, fix this by mlx5 ib driver to register for per net netdev
> notifier instead of global one, which operats on the net namespace
> without holding the pernet_ops_rwsem.
> 
> Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>  drivers/infiniband/hw/mlx5/main.c                  | 6 ++++--
>  drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h | 5 -----
>  include/linux/mlx5/driver.h                        | 5 +++++
>  3 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 944bb7691913..b1b3e563c15e 100644
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3323,7 +3323,8 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
>  	int err;
> 
>  	dev->port[port_num].roce.nb.notifier_call = mlx5_netdev_event;
> -	err = register_netdevice_notifier(&dev->port[port_num].roce.nb);
> +	err = register_netdevice_notifier_net(mlx5_core_net(dev->mdev),
> +					      &dev->port[port_num].roce.nb);

This looks racy, what lock needs to be held to keep *mlx5_core_net()
stable?

>  	if (err) {
>  		dev->port[port_num].roce.nb.notifier_call = NULL;
>  		return err;
> @@ -3335,7 +3336,8 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
>  static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
>  {
>  	if (dev->port[port_num].roce.nb.notifier_call) {
> -		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
> +		unregister_netdevice_notifier_net(mlx5_core_net(dev->mdev),
> +						  &dev->port[port_num].roce.nb);

This seems dangerous too, what if the mlx5_core_net changed before we
get here?

What are the rules for when devlink_net() changes?

Jason
