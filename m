Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F8E3684F8
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbhDVQhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232670AbhDVQhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 12:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 023DC61404;
        Thu, 22 Apr 2021 16:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619109404;
        bh=i4lRkN7p1tsfC9NSLLYOKCy3KLbnbHD0lXcp73poxZc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FwfXXMmV07CnbXj+TM9iwIHAEIyPWH7ZHOs0Qq4evnw0exEnkh61xLcRy8LaQc6nK
         KfXgqxhvi5JHOohjCx5X4O8pD3LGQsp/76ibJC+ZM9ReVSFuNlY22tNtHmXwrYpj68
         F/XJjiwLiWx5+azmitIsNJFT7Y984uDqODAe7G4rEvbVizncL7H/B94QuCzGpwxmy1
         Wh2UaAdfhHlL4oC8xAtJW0y3LmR57tcqoOd0IAqzvJ1cCu0CukOpYG8xUbjSm2zc7E
         S3XXE4hDliwU4VmjLx7+9o836FdPGuv2BCeerBHDRfpbmdO1EWJpdorKWR/ueQflWx
         fGsU0ecYCTBtg==
Date:   Thu, 22 Apr 2021 09:36:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 06/11] devlink: Extend SF port attributes to have
 external attribute
Message-ID: <20210422093642.20c9e89e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB4322B0D056D310687E3CEA58DC469@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210421174723.159428-1-saeed@kernel.org>
        <20210421174723.159428-7-saeed@kernel.org>
        <20210421122008.2877c21f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322B0D056D310687E3CEA58DC469@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 03:55:50 +0000 Parav Pandit wrote:
> > On Wed, 21 Apr 2021 10:47:18 -0700 Saeed Mahameed wrote:  
> > > From: Parav Pandit <parav@nvidia.com>
> > >
> > > Extended SF port attributes to have optional external flag similar to
> > > PCI PF and VF port attributes.
> > >
> > > External atttibute is required to generate unique phys_port_name when
> > > PF number and SF number are overlapping between two controllers
> > > similar to SR-IOV VFs.
> > >
> > > When a SF is for external controller an example view of external SF
> > > port and config sequence.
> > >
> > > On eswitch system:
> > > $ devlink dev eswitch set pci/0033:01:00.0 mode switchdev
> > >
> > > $ devlink port show
> > > pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour
> > > physical port 0 splittable false
> > > pci/0033:01:00.0/131072: type eth netdev eth0 flavour pcipf controller 1  
> > pfnum 0 external true splittable false  
> > >   function:
> > >     hw_addr 00:00:00:00:00:00
> > >
> > > $ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77
> > > controller 1
> > > pci/0033:01:00.0/163840: type eth netdev eth1 flavour pcisf controller 1  
> > pfnum 0 sfnum 77 splittable false  
> > >   function:
> > >     hw_addr 00:00:00:00:00:00 state inactive opstate detached
> > >
> > > phys_port_name construction:
> > > $ cat /sys/class/net/eth1/phys_port_name
> > > c1pf0sf77
> > >
> > > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > Reviewed-by: Vu Pham <vuhuong@nvidia.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>  
> > 
> > I have a feeling I nacked this in the past, but can't find the thread.
> > Was something similar previously posted?  
> Your memory is correct.
> In past external flag was present but it was always set to false.
> So you asked to move out until we set it to true, which we did.
> This series uses it as true similar to existing PF and VF eswitch ports of an external controller.
> Hence, it was removed from past series and done in this series that actually uses it.

Right. I still think it's a weird model to instantiate an SF from 
the controller side, but if your HW is too limited to support
nested switching that's fine. Fine as long as Melvidia won't object
to other vendors adding different models of operation in the future,
that is.
