Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6169D2B8B35
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 06:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgKSF6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 00:58:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgKSF6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 00:58:00 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B04EA22227;
        Thu, 19 Nov 2020 05:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605765479;
        bh=sD2iiq/12hPcB8kmqa7deoaiI00UM3+87N7HjtezNkM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Grzm4MSsgk4FMtokVhJnb2U/hq2x9Jb2ZLs0EXDAFKVeiZUC5HyX5X+Vj+c8Xc8v2
         FExVMPzm/DPKQW3b/raACwgwDToaoJFHwKldC+o8rvpHKuquTHyevoh0xtr9t0TDMw
         81BJQDj6qyfZghczMNe/W1qnonLOUw47AfnsZe9U=
Message-ID: <29c4d7854faaea6db33136a448a8d2f53d0cfd72.camel@kernel.org>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Date:   Wed, 18 Nov 2020 21:57:57 -0800
In-Reply-To: <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com>
References: <20201112192424.2742-1-parav@nvidia.com>
         <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
         <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
         <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <20201117184954.GV917484@nvidia.com>
         <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-18 at 21:35 -0700, David Ahern wrote:
> On 11/18/20 7:14 PM, Jakub Kicinski wrote:
> > On Tue, 17 Nov 2020 14:49:54 -0400 Jason Gunthorpe wrote:
> > > On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski wrote:
> > > 
> > > > > Just to refresh all our memory, we discussed and settled on
> > > > > the flow
> > > > > in [2]; RFC [1] followed this discussion.
> > > > > 
> > > > > vdpa tool of [3] can add one or more vdpa device(s) on top of
> > > > > already
> > > > > spawned PF, VF, SF device.  
> > > > 
> > > > Nack for the networking part of that. It'd basically be VMDq.  
> > > 
> > > What are you NAK'ing? 
> > 
> > Spawning multiple netdevs from one device by slicing up its queues.
> 
> Why do you object to that? Slicing up h/w resources for virtual what
> ever has been common practice for a long time.
> 
> 

We are not slicing up any queues, from our HW and FW perspective SF ==
VF literally, a full blown HW slice (Function), with isolated control
and data plane of its own, this is very different from VMDq and more
generic and secure. an SF device is exactly like a VF, doesn't steal or
share any HW resources or control/data path with others. SF is
basically SRIOV done right.

this series has nothing to do with netdev, if you look at the list of
files Parav is touching, there is 0 change in our netdev stack :) ..
all Parav is doing is adding the API to create/destroy SFs and
represents the low level SF function to devlink as a device, just
like a VF.






