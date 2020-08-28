Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2781B255EEF
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 18:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgH1Qns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 12:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgH1Qnq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 12:43:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0180E20872;
        Fri, 28 Aug 2020 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598633025;
        bh=UXZZNLZwCVGEXXARDMMy+zxA0wJxGFliW6r9B1hLEXs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LmPblYKL/xZpOrqinO4kGkfqGwseqWlmcDYA9Sx2pdrzvep9zpPdqDN8lseek1k8W
         /GNu+Fo+uywYgi9i1o1oJO4Hpf6YvXuVVS83e27hl06cXz/T8v6Rw5v0mqDVEOiCHr
         pw+Xh2ZV4Ru19ztjk5gtl+QzB7KOKs/XcQd4sfD8=
Date:   Fri, 28 Aug 2020 09:43:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
        <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Aug 2020 04:27:19 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Friday, August 28, 2020 3:12 AM
> > 
> > On Thu, 27 Aug 2020 20:15:01 +0000 Parav Pandit wrote:  
> > > > From: Jakub Kicinski <kuba@kernel.org>
> > > >
> > > > I find it strange that you have pfnum 0 everywhere but then
> > > > different controllers.  
> > > There are multiple PFs, connected to different PCI RC. So device has
> > > same pfnum for both the PFs.
> > >  
> > > > For MultiHost at Netronome we've used pfnum to distinguish between
> > > > the hosts. ASIC must have some unique identifiers for each PF.  
> > > Yes. there is. It is identified by a unique controller number;
> > > internally it is called host_number. But internal host_number is
> > > misleading term as multiple cables of same physical card can be
> > > plugged into single host. So identifying based on a unique
> > > (controller) number and matching that up on external cable is desired.
> > >  
> > > > I'm not aware of any practical reason for creating PFs on one RC
> > > > without reinitializing all the others.  
> > > I may be misunderstanding, but how is initialization is related
> > > multiple PFs?  
> > 
> > If the number of PFs is static it should be possible to understand which one is on
> > which system.
>
> How? How do we tell that pfnum A means external system.
> Want to avoid such 'implicit' notion.

How do you tell that controller A means external system?

> > > > I can see how having multiple controllers may make things clearer,
> > > > but adding another layer of IDs while the one under it is unused
> > > > (pfnum=0) feels very unnecessary.  
> > > pfnum=0 is used today. not sure I understand your comment about being
> > > unused. Can you please explain?  
> > 
> > You examples only ever have pfnum 0:
> >   
> Because both controllers have pfnum 0.
> 
> > From patch 2:
> > 
> > $ devlink port show pci/0000:00:08.0/2
> > pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour pcivf pfnum 0
> > vfnum 1 splittable false
> >   function:
> >     hw_addr 00:00:00:00:00:00
> > 
> > $ devlink port show -jp pci/0000:00:08.0/2 {
> >     "port": {
> >         "pci/0000:00:08.0/1": {
> >             "type": "eth",
> >             "netdev": "eth7",
> >             "controller": 0,
> >             "flavour": "pcivf",
> >             "pfnum": 0,
> >             "vfnum": 1,
> >             "splittable": false,
> >             "function": {
> >                 "hw_addr": "00:00:00:00:00:00"
> >             }
> >         }
> >     }
> > }
> > 
> > From earlier email:
> > 
> > pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
> > pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
> > 
> > If you never use pfnum, you can just put the controller ID there, like Netronome.
> >  
> It likely not going to work for us. Because pfnum is not some randomly generated number.
> It is linked to the underlying PCI pf number. {pf0, pf1...}
> Orchestration sw uses this to identify representor of a PF-VF pair.

For orchestration software which is unaware of controllers ports will
still alias on pf/vf nums.

Besides you have one devlink instance per port currently so I'm guessing
there is no pf1 ever, in your case...

> Replacing pfnum with controller number breaks this; and it still doesn't tell user that it's the pf on other_host.

Neither does the opaque controller id. Maybe now you understand better
why I wanted peer objects :/

> So it is used, and would like to continue to use even if there are multiple PFs port (that has same pfnum) under the same eswitch.
> 
> In an alternative,
> Currently we have pcipf, pcivf (and pcisf) flavours. May be if we introduce new flavour say 'epcipf' to indicate external pci PF/VF/SF ports?
> There can be better name than epcipf. I just put epcipf to differentiate it.
> However these ports have same attributes as pcipf, pcivf, pcisf flavours.

I don't think the controllers are a terrible idea. Seems like a fairly
reasonable extension. But MLX don't seem to need them. And you have a
history of trying to make the Linux APIs look like your FW API.

Jiri, would you mind chiming in? What's your take?
