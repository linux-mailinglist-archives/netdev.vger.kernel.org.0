Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2E32B6B54
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgKQRLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:11:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729409AbgKQRLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 12:11:22 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D6420702;
        Tue, 17 Nov 2020 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605633081;
        bh=SDqIbkBAJGVaB3nLM5KS4BE7PANmli0SwI2jdbQwt2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OGA9bcXqxRHovUoXLDdVpMCzci2T47yYaIauKPZHnsQMqI96ESFUX3PCPRBqF3+DS
         Wdd0inhDJPa0wYmQwP44Y0yTau+ntunqM0fvjy8vk6pvVopCsA5GtFLcO/8EcLHXzq
         H+VyXN7qZSQihEs65z3tdf/l7msQwaX/r9wbRLhQ=
Date:   Tue, 17 Nov 2020 09:11:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
        <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 04:08:57 +0000 Parav Pandit wrote:
> > On Mon, 16 Nov 2020 16:06:02 -0800 Saeed Mahameed wrote:  
> > > > > Subfunction support is discussed in detail in RFC [1] and [2].
> > > > > RFC [1] and extension [2] describes requirements, design, and
> > > > > proposed plumbing using devlink, auxiliary bus and sysfs for
> > > > > systemd/udev support.  
> > > >
> > > > So we're going to have two ways of adding subdevs? Via devlink and
> > > > via the new vdpa netlink thing?  
> Nop.
> Subfunctions (subdevs) are added only one way, 
> i.e. devlink port as settled in RFC [1].
> 
> Just to refresh all our memory, we discussed and settled on the flow
> in [2]; RFC [1] followed this discussion.
> 
> vdpa tool of [3] can add one or more vdpa device(s) on top of already
> spawned PF, VF, SF device.

Nack for the networking part of that. It'd basically be VMDq.

> > > Via devlink you add the Sub-function bus device - think of it as
> > > spawning a new VF - but has no actual characteristics
> > > (netdev/vpda/rdma) "yet" until user admin decides to load an
> > > interface on it via aux sysfs.  
> > 
> > By which you mean it doesn't get probed or the device type is not
> > set (IOW it can still become a block device or netdev depending on
> > the vdpa request)? 
> > > Basically devlink adds a new eswitch port (the SF port) and
> > > loading the drivers and the interfaces is done via the auxbus
> > > subsystem only after the SF is spawned by FW.  
> > 
> > But why?
> > 
> > Is this for the SmartNIC / bare metal case? The flow for spawning
> > on the local host gets highly convoluted.
>
> The flow of spawning for (a) local host or (b) for external host
> controller from smartnic is same.
> 
> $ devlink port add..
> [..]
> Followed by
> $ devlink port function set state...
> 
> Only change would be to specify the destination where to spawn it.
> (controller number, pf, sf num etc) Please refer to the detailed
> examples in individual patch. Patch 12 and 13 mostly covers the
> complete view.

Please share full examples of the workflow.

I'm asking how the vdpa API fits in with this, and you're showing me
the two devlink commands we already talked about in the past.
