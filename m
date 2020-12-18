Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85822DE9F0
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387394AbgLRTvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:51:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733281AbgLRTvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 14:51:52 -0500
Date:   Fri, 18 Dec 2020 11:51:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608321072;
        bh=RSO0yLTp2FUp2v/AQEcpoKcMsAnSeDJ+jiiYucr5iLg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=WlIBXvf4edN/BDeOtbvA4nzTLj7ZR5rw1LTEyD2FXH2u83mlABZBaRkAgyI97S4l0
         x/XteeuzLUNkLp54QG/hbbFBgSMtozyWfD1S11ztnyOjLRD8w3YhnPcvZiBy68do6b
         VTkdx6yA/rtsIj57Iv8sEAPac+uC/J39H5gsPmKypRDMCtMvS+0e3mflgn7am8pnsH
         mwr21h2mv2zIdxJJZd3Jq+94Xty7kRwlzbWYHPBh23CYpE2Gnq7OLE/G6fPAK1dCgj
         3bl1e4nGv74N6hIe4zbyv3s5QdnseJdFVWy5/DbYRKcK9+JA9sggq9ByeT94SgFT1x
         OQfaZkaQUdPLw==
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
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 05/15] devlink: Support get and set state of port
 function
Message-ID: <20201218115110.33701ded@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB43229F0FB38429E826DE1060DCC40@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-6-saeed@kernel.org>
        <20201215163747.4091ff61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43225346806029AA31D63918DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201216160850.78223a1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F0FB38429E826DE1060DCC40@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 05:46:45 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Thursday, December 17, 2020 5:39 AM
> > 
> > On Wed, 16 Dec 2020 05:15:04 +0000 Parav Pandit wrote:  
> > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > Sent: Wednesday, December 16, 2020 6:08 AM
> > > >
> > > > On Tue, 15 Dec 2020 01:03:48 -0800 Saeed Mahameed wrote:  
> > > > > From: Parav Pandit <parav@nvidia.com>
> > > > >
> > > > > devlink port function can be in active or inactive state.
> > > > > Allow users to get and set port function's state.
> > > > >
> > > > > When the port function it activated, its operational state may
> > > > > change after a while when the device is created and driver binds to it.
> > > > > Similarly on deactivation flow.  
> > > >
> > > > So what's the flow device should implement?
> > > >
> > > > User requests deactivated, the device sends a notification to the
> > > > driver bound to the device. What if the driver ignores it?
> > > >  
> > > If driver ignores it, those devices are marked unusable for new allocation.
> > > Device becomes usable only after it has act on the event.  
> > 
> > But the device remains fully operational?
> > 
> > So if I'm an admin who wants to unplug a misbehaving "entity"[1] the
> > deactivate is not gonna help me, it's just a graceful hint?  
> Right.
> > Is there no need for a forceful shutdown?  
> In this patchset, no. I didn't add the knob for it. It is already at 15 patches.
> But yes, forceful shutdown extension can be done by the admin in future patchset as,
> 
> $ devlink port del pci/0000:06:00.0/<port_index> force true
>                                                                                          ^^^^^^^^
> Above will be the extension in control of the admin.

Can we come up with operational states that would encompass that?

The "force true" does not look too clean.

And let's document meaning of the states. We don't want the next vendor
to just "assume" the states match their own interpretation.
