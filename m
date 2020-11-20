Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBFF2B9FBA
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgKTB3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgKTB3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:29:32 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8AF922254;
        Fri, 20 Nov 2020 01:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605835772;
        bh=2x0L7N+dOxUc040FilWRnlMxensAbmJn8o+CSDYQitI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EKq6Tsu7BmQrj0qQbbFkn1GCpIt1ekTazRPxFwvn1p2WFkG5R4y0kU2vwdXJnbf6u
         upIE55URdqtIRFvIG3MzJjiY3qNi4a0qpLbAdv6VLrZcWu3fmhCE7VifDO40mHos8G
         im4xisv9fgp+LSufQzGTeXRixZgQ650bCt7SH7uk=
Date:   Thu, 19 Nov 2020 17:29:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201119172930.11ab9e68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 21:35:29 -0700 David Ahern wrote:
> On 11/18/20 7:14 PM, Jakub Kicinski wrote:
> > On Tue, 17 Nov 2020 14:49:54 -0400 Jason Gunthorpe wrote:  
> >> On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski wrote:
> >>  
> >>>> Just to refresh all our memory, we discussed and settled on the flow
> >>>> in [2]; RFC [1] followed this discussion.
> >>>>
> >>>> vdpa tool of [3] can add one or more vdpa device(s) on top of already
> >>>> spawned PF, VF, SF device.    
> >>>
> >>> Nack for the networking part of that. It'd basically be VMDq.    
> >>
> >> What are you NAK'ing?   
> > 
> > Spawning multiple netdevs from one device by slicing up its queues.  
> 
> Why do you object to that? Slicing up h/w resources for virtual what
> ever has been common practice for a long time.

My memory of the VMDq debate is hazy, let me rope in Alex into this.
I believe the argument was that we should offload software constructs,
not create HW-specific APIs which depend on HW availability and
implementation. So the path we took was offloading macvlan.
