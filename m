Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599332DC9D1
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbgLQAJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:09:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729023AbgLQAJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:09:32 -0500
Date:   Wed, 16 Dec 2020 16:08:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608163731;
        bh=g801CA1mP6r8B24edAn5HCOD7wX68sdbO7aF1eAwbMs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=a8mnTHoLnYVS/FWf0dLopw1Dth2zfC1Pfx8NxFC7qlZ5kge18lx+OMb5pWDlKiU8N
         wivCZTyYQ7zeeg8beWlyL3vwdffC/+96fIxWM30vxorVUXyc2EQPKrvgk0lqTAat48
         tPEfSbF7rUdH7xkANxCh1bE45sBS0GDXjaYsDExeD9Qo9MI/O3+b0XTiI3X9WMKDXY
         GPazBaUgq0gYN+GiELoE6ArrPEo1cEdwVGhHiszWuIuLBMOfMiTkrajjR9Q0D0jIWM
         boWSlujpfyudxGxqVRQ6AaCbGz7t3ygWjSJlrAKcEWViKyhxdnrUQwg/m3Kco33eSQ
         AOt1VueIwyvkw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 05/15] devlink: Support get and set state of port
 function
Message-ID: <20201216160850.78223a1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB43225346806029AA31D63918DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-6-saeed@kernel.org>
        <20201215163747.4091ff61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43225346806029AA31D63918DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 05:15:04 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, December 16, 2020 6:08 AM
> > 
> > On Tue, 15 Dec 2020 01:03:48 -0800 Saeed Mahameed wrote:  
> > > From: Parav Pandit <parav@nvidia.com>
> > >
> > > devlink port function can be in active or inactive state.
> > > Allow users to get and set port function's state.
> > >
> > > When the port function it activated, its operational state may change
> > > after a while when the device is created and driver binds to it.
> > > Similarly on deactivation flow.  
> > 
> > So what's the flow device should implement?
> > 
> > User requests deactivated, the device sends a notification to the driver
> > bound to the device. What if the driver ignores it?
> >  
> If driver ignores it, those devices are marked unusable for new allocation.
> Device becomes usable only after it has act on the event.

But the device remains fully operational?

So if I'm an admin who wants to unplug a misbehaving "entity"[1]
the deactivate is not gonna help me, it's just a graceful hint?
Is there no need for a forceful shutdown?

[1] refer to earlier email, IDK what entity is supposed to use this

> > > + * @DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED: Driver is detached  
> > from the function of port; it is  
> > > + *					    safe to delete the port.
> > > + */
> > > +enum devlink_port_function_opstate {
> > > +	DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED,  
> > 
> > The port function must be some Mellanox speak - for the second time - I
> > have no idea what it means. Please use meaningful names.
> >  
> It is not a Mellanox term.
> Port function object is the one that represents function behind this port.
> It is not a new term. Port function already exists in devlink whose operational state attribute is defined here.

I must have missed that in review. PCI functions can host multiple
ports. So "port function" does not compute for me. Can we drop the
"function"?
