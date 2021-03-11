Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C9B337D96
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhCKTV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhCKTVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 14:21:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56F0664F0E;
        Thu, 11 Mar 2021 19:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615490467;
        bh=4nzdDaCG0kYjgpTNhrTOt1hQovgTcOIbi5H3Z+VRkI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YiE8RtarNRjbac5gWsUs8tC1hxmqyPXEsGdi014Tz6Qk4A7/GIiFJMtB7LoQj8qXH
         GOJHORMbzzbCmbsJiXhpanDBKpgBV09gg+sFL4yiVkeVnPJzfrqt2bJ1FeEhXXsa7O
         o3KB880AXXf7ZeGLVoEpr+xSf1d+29YWSmAmfy32nbWkWz3jgqy2JKv9GAvSCQCtqu
         LQXrrO5wxI99Uat7MRLpXaQEMcWWj4/xD6x0nEzl3NUMmPex/gC5CdIwrQuZYJqeU0
         gbErfPdBYvnsNnu8CCjI8hTCM4tAXqa78wFhCkRKn9jn6P1bC2/64zv6Hlp8ThYVWg
         nu+a9NT9kIxsg==
Date:   Thu, 11 Mar 2021 21:21:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YEptn6d9fD4q2b52@unreal>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <20210311191602.GA36893@C02WT3WMHTD6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311191602.GA36893@C02WT3WMHTD6>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 12:16:02PM -0700, Keith Busch wrote:
> On Thu, Mar 11, 2021 at 12:17:29PM -0600, Bjorn Helgaas wrote:
> > On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > >
> > > I'm not so much worried about management software as the fact that
> > > this is a vendor specific implementation detail that is shaping how
> > > the kernel interfaces are meant to work. Other than the mlx5 I don't
> > > know if there are any other vendors really onboard with this sort of
> > > solution.
> >
> > I know this is currently vendor-specific, but I thought the value
> > proposition of dynamic configuration of VFs for different clients
> > sounded compelling enough that other vendors would do something
> > similar.  But I'm not an SR-IOV guy and have no vendor insight, so
> > maybe that's not the case?
>
> NVMe has a similar feature defined by the standard where a PF controller can
> dynamically assign MSIx vectors to VFs. The whole thing is managed in user
> space with an ioctl, though. I guess we could wire up the driver to handle it
> through this sysfs interface too, but I think the protocol specific tooling is
> more appropriate for nvme.

We need this MSI-X thing for IB and ethernet devices too. This is why PCI
sysfs is the best place to put it, so all SR-IOV flavours will have sane
way to configure it.

Thanks
