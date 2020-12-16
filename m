Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A742DC9C6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgLQAA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgLQAA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:00:28 -0500
Date:   Wed, 16 Dec 2020 15:59:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608163187;
        bh=UHUln+VffhOtlnaM/FbAJpt+TQFlYpAye9uDBpb430w=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=UnrwKEN61UwZ8pGUaUJIKv2B7TJ38rOQaH0l+cRRAhm4SaM9xSoNmUHnlpAUp2Aij
         9azDzhZGChfxRE0QzUu6jS/6QKnL9hbyILV80mp4PlvTeIjCNo64XKl5uU5+RZ6Gdc
         Y8aIXK9rPa450qK7CxlnVKedQC6r15I+X2zldigjYfeILBoNeksOTHNteiYGY52KMq
         50d9nAfqEfww0A7YDb+Eo0l/UgOqM3Tzy27in50sXszffNcVvsx7Um6eguPNBUjJam
         +jg34tytJQEJ04IVjP4NitTruUsSsetsXeuFmIhlI73I8pSXriegC3xcslZkcUyuh6
         fskQrc+qGqvhw==
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
Subject: Re: [net-next v5 03/15] devlink: Introduce PCI SF port flavour and
 port attribute
Message-ID: <20201216155945.63f07c80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB432268C16D118BC435C0EF5CDCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-4-saeed@kernel.org>
        <20201215152740.0b3ed376@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432268C16D118BC435C0EF5CDCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 03:42:51 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > So subfunctions don't have a VF id but they may have a controller?
> >  
> Right. SF can be on external controller.
>  
> > Can you tell us more about the use cases and deployment models you're
> > intending to support? Let's not add attributes and info which will go unused.
> >   
> External will be used the same way how it is used for PF and VF.
> 
> > How are SFs supposed to be used with SmartNICs? Are you assuming single
> > domain of control?  
> No. it is not assumed. SF can be deployed from smartnic to external host.
> A user has to pass appropriate controller number, pf number attributes during creation time.

My problem with this series is that I've gotten some real life
application exposure over the last year, and still I have no idea 
who is going to find this feature useful and why.

That's the point of my questions in the previous email - what
are the use cases, how are they going to operate.

It's hard to review an API without knowing the use of it. iproute2
is low level plumbing.

Here the patch is adding the ability to apparently create a SF on 
a remote controller. If you haven't thought that use case through
just don't allow it until you know how it will work.

> > It seems that the way the industry is moving the major
> > use case for SmartNICs is bare metal.
> > 
> > I always assumed nested eswitches when thinking about SmartNICs, what
> > are you intending to do?
> >  
> Mlx5 doesn't support nested eswitch. SF can be deployed on the external controller PCI function.
> But this interface neither limited nor enforcing nested or flat eswitch.
>  
> > What are your plans for enabling this feature in user space project?  
> Do you mean K8s plugin or iproute2? Can you please tell us what user space project?

That's my question. For SR-IOV it'd be all the virt stacks out there.
But this can't do virt. So what can it do?

> If iproute2, will send the iproute2 patchset like other patchset pointing to kernel uapi headers..
