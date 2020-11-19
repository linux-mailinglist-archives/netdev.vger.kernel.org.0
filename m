Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4C12B8B96
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 07:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgKSGWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 01:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgKSGWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 01:22:54 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E4BE246AD;
        Thu, 19 Nov 2020 06:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605766973;
        bh=Flg8FSn6jtiUD6lsTxWCt3rDnH7Rd+y0XZDO992S1sI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lkZI1WJm47cDfpIAyS6iqYxQvs8isYaqF139cwwN+uUR7p+VZ0HplLmywEA9rlk+w
         SjytbsoYUF+A79rbp0WeYGbTFg8aqNRAse2Z0/Ot5DoYYYKlVjswWa1x7NoKt0FIL0
         ktH3LUaXKA99fxGGyuiwCNO70qaiel8EkQMRDXjQ=
Message-ID: <28239ff66a27c0ddf8be4f1461e27b0ac0b02871.camel@kernel.org>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Parav Pandit <parav@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Date:   Wed, 18 Nov 2020 22:22:51 -0800
In-Reply-To: <20201118182319.7bad1ca6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201112192424.2742-1-parav@nvidia.com>
         <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
         <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
         <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <BY5PR12MB4322F01A4505AF21F696DCA2DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
         <20201118182319.7bad1ca6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-18 at 18:23 -0800, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 18:50:57 +0000 Parav Pandit wrote:
> > At this point vdpa tool of [1] can create one or more vdpa net
> > devices on this subfunction device in below sequence.
> > 
> > $ vdpa parentdev list
> > auxiliary/mlx5_core.sf.4
> >   supported_classes
> >     net
> > 
> > $ vdpa dev add parentdev auxiliary/mlx5_core.sf.4 type net name
> > foo0
> > 
> > $ vdpa dev show foo0
> > foo0: parentdev auxiliary/mlx5_core.sf.4 type network parentdev
> > vdpasim vendor_id 0 max_vqs 2 max_vq_size 256
> > 
> > > I'm asking how the vdpa API fits in with this, and you're showing
> > > me the two
> > > devlink commands we already talked about in the past.  
> > Oh ok, sorry, my bad. I understood your question now about relation
> > of vdpa commands with this.
> > Please look at the above example sequence that covers the vdpa
> > example also.
> > 
> > [1] 
> > https://lore.kernel.org/netdev/20201112064005.349268-1-parav@nvidia.com/
> 
> I think the biggest missing piece in my understanding is what's the
> technical difference between an SF and a VDPA device.
> 

Same difference as between a VF and netdev.
SF == VF, so a full HW function.
VDPA/RDMA/netdev/SCSI/nvme/etc.. are just interfaces (ULPs) sharing the
same functions as always been, nothing new about this.

Today on a VF we load a RDMA/VDPA/netdev interfaces
SF will do exactly the same and the ULPs will simply load, and we don't
need to modify them.

> Isn't a VDPA device an SF with a particular descriptor format for the
> queues?
No :/, 
I hope the above answer clarifies things a bit.
SF is a device function that provides all kinds of queues.


