Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6591B292DFB
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgJSTBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:01:04 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10851 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730842AbgJSTBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 15:01:04 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8de2630000>; Mon, 19 Oct 2020 12:00:51 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 19 Oct
 2020 19:01:03 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 19 Oct 2020 19:01:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nN7DDGIzeKsqP7lR+EtrEntUecH424vsuP7vYE6BmkxJdqP1ipEKOjlmoCpyPRX+OJhC8keEsQNlz2f8RyOd63nA1w4IoGPCxJ90ucso71QWkJuvy88AzLsWd0rFqa2RlUeOxjpCmJGNT6RoghxeVeIlYAkkb3E6Y5bfno+QBdzLibVnJI/AIePmMDQaXVgD9qrxJnTzfu8V/6y/4y+g14LrEEvIG8RuVvoYZjUgnomJNT6v8qzlfn0vqP/B7nU98biiSfrqyzAiRri0oL44USPiL72atd5AKb7pACvyLHJmAgovJW2LRvySVLW6Ox2HuQ+8k75Hm2haUtlpOCKIsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ungdr2ZKqvNyGtPqMYHLSnw+XIu5ok+S5tkm0qBgZM=;
 b=Tci+BlCfMInE43CB3zfuekFlDxnhk1sK/2c2xO+/7O3mTa39mc1/d80y1hsYtrP/NPFFcYWz7plaxX0OCkCTXCzGimu1WM5L7vTNIB7JonJNuK4d2Osn6CmhH2JTjiOAp2z9Yf+C0j/0qo9jZeUF/cqbK4aTH8AL3wMKTY5oceJh+L82lffuAYKjlvbycMdr/MMilGY3xmmCQ6VoBeSLWHRqPjk71W14P8hV8iIsKkhiILixEtvjJUEH/WJteDemnpwjiKGVxShgpoQysi+NSNvN5xtkVncuumaKQp2hLlKjrVNVFNCtrK3FvvohiWTRfdY1sYqJpfwmDGJmTaPhvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Mon, 19 Oct
 2020 19:01:02 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 19:01:02 +0000
Date:   Mon, 19 Oct 2020 16:01:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Message-ID: <20201019190100.GA6219@nvidia.com>
References: <20201019052736.628909-1-leon@kernel.org>
 <20201019130751.GE6219@nvidia.com>
 <BY5PR12MB4322102A3DD0EC976FF317E7DC1E0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BY5PR12MB4322102A3DD0EC976FF317E7DC1E0@BY5PR12MB4322.namprd12.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0161.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL1PR13CA0161.namprd13.prod.outlook.com (2603:10b6:208:2bd::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.4 via Frontend Transport; Mon, 19 Oct 2020 19:01:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kUaOy-002dBP-EY; Mon, 19 Oct 2020 16:01:00 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603134051; bh=3ungdr2ZKqvNyGtPqMYHLSnw+XIu5ok+S5tkm0qBgZM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=gmVJOSMXnWYmjlJ3+aRgHFbhT4sizee3pSF5RwUOrUBGGugJhXCkEkRDMBR6aVTcN
         230EatcHANpRToxJXDxrnFng0JSBYKikJaLIfBW5+wv6ji420EK7lrGy43L4D5UDUd
         0UsvaNFTw9bMT6fMJ0EEAQY1rEg3yjtjxX06KM/Gpp+i/AdzlYXsNyL6AALSuJpCux
         1CbHkuJSrVbPO0UMyyGJDxKV1Ur1F17aLE1Z3vaHVu1R1G7rqVAxovE8EhwhufJhic
         B7QunhH8B5DPaXrsCFAcDJ74ffbHm6ZYAFNk3AkPdlwTyK3BH7R9VR1BD6l++EVc5m
         9PukEAoGmHItA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 01:23:23PM +0000, Parav Pandit wrote:
> > > -	err = register_netdevice_notifier(&dev->port[port_num].roce.nb);
> > > +	err = register_netdevice_notifier_net(mlx5_core_net(dev->mdev),
> > > +					      &dev->port[port_num].roce.nb);
> > 
> > This looks racy, what lock needs to be held to keep *mlx5_core_net() stable?
> 
> mlx5_core_net() cannot be accessed outside of mlx5 driver's load, unload, reload path.
> 
> When this is getting executed, devlink cannot be executing reload.
> This is guarded by devlink_reload_enable/disable calls done by mlx5 core.

A comment that devlink_reload_enable/disable() must be held would be
helpful
 
> > 
> > >  	if (err) {
> > >  		dev->port[port_num].roce.nb.notifier_call = NULL;
> > >  		return err;
> > > @@ -3335,7 +3336,8 @@ static int mlx5_add_netdev_notifier(struct
> > > mlx5_ib_dev *dev, u8 port_num)  static void
> > > mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)  {
> > >  	if (dev->port[port_num].roce.nb.notifier_call) {
> > > -		unregister_netdevice_notifier(&dev-
> > >port[port_num].roce.nb);
> > > +		unregister_netdevice_notifier_net(mlx5_core_net(dev-
> > >mdev),
> > > +						  &dev-
> > >port[port_num].roce.nb);
> > 
> > This seems dangerous too, what if the mlx5_core_net changed before we
> > get here?
>
> When I inspected driver, code, I am not aware of any code flow where
> this can change before reaching here, because registration and
> unregistration is done only in driver load, unload and reload path.
> Reload can happen only after devlink_reload_enable() is done.

But we enable reload right after init_one

> > What are the rules for when devlink_net() changes?
> > 
> devlink_net() changes only after unload() callback is completed in driver.

You mean mlx5_devlink_reload_down ?

That seems OK then

Jason
