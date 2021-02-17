Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AF631DEC3
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhBQSDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234708AbhBQSD1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 13:03:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9A1564E28;
        Wed, 17 Feb 2021 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613584961;
        bh=ITx9kpyYGrtDDs+FqbWm9mIa5z882OIHwezCiMY2pNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ZMn167je5YaTeRaqjcApDljVQ6Ywgh0Mi7QvrMCPEBWPHSqabjwWv3yjJUsHObdPk
         VkkT+ThgjE3Aw5x5RStbb+oGrVUhdoWEB8vEfph42WnYXAblb0i68M28P9y6JydeN1
         0E1uK39eZLWISx25+FndvAm5fQTtKv2VuKX2UfDr0FU1jjoGWSTDcfojVvvHACweRX
         pigRybcFSb85JsOBT0RijPPnIpnyvS1dJd9+cxMpBvv0QAzKDgFM8DJyWNs0Thj3+T
         EMP2A5cRJ/NEtN6a6ED15+0Ucn3A+H2qUr5E7FYA2RsTKwUsw3DC+/VbtmHZ1cb/Or
         Ubqif6IS/2mVA==
Date:   Wed, 17 Feb 2021 12:02:39 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210217180239.GA896669@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCwj4WsrVeklgl7i@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Greg in case he wants to chime in on the sysfs discussion.
TL;DR: we're trying to add/remove sysfs files when a PCI driver that
supports certain callbacks binds or unbinds; series at
https://lore.kernel.org/r/20210209133445.700225-1-leon@kernel.org]

On Tue, Feb 16, 2021 at 09:58:25PM +0200, Leon Romanovsky wrote:
> On Tue, Feb 16, 2021 at 10:12:12AM -0600, Bjorn Helgaas wrote:
> > On Tue, Feb 16, 2021 at 09:33:44AM +0200, Leon Romanovsky wrote:
> > > On Mon, Feb 15, 2021 at 03:01:06PM -0600, Bjorn Helgaas wrote:
> > > > On Tue, Feb 09, 2021 at 03:34:42PM +0200, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>

> > > > > +int pci_enable_vf_overlay(struct pci_dev *dev)
> > > > > +{
> > > > > +	struct pci_dev *virtfn;
> > > > > +	int id, ret;
> > > > > +
> > > > > +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> > > > > +		return 0;
> > > > > +
> > > > > +	ret = sysfs_create_files(&dev->dev.kobj, sriov_pf_dev_attrs);
> > > >
> > > > But I still don't like the fact that we're calling
> > > > sysfs_create_files() and sysfs_remove_files() directly.  It makes
> > > > complication and opportunities for errors.
> > >
> > > It is not different from any other code that we have in the kernel.
> >
> > It *is* different.  There is a general rule that drivers should not
> > call sysfs_* [1].  The PCI core is arguably not a "driver," but it is
> > still true that callers of sysfs_create_files() are very special, and
> > I'd prefer not to add another one.
> 
> PCI for me is a bus, and bus is the right place to manage sysfs.
> But it doesn't matter, we understand each other positions.
> 
> > > Let's be concrete, can you point to the errors in this code that I
> > > should fix?
> >
> > I'm not saying there are current errors; I'm saying the additional
> > code makes errors possible in future code.  For example, we hope that
> > other drivers can use these sysfs interfaces, and it's possible they
> > may not call pci_enable_vf_overlay() or pci_disable_vfs_overlay()
> > correctly.
> 
> If not, we will fix, we just need is to ensure that sysfs name won't
> change, everything else is easy to change.
> 
> > Or there may be races in device addition/removal.  We have current
> > issues in this area, e.g., [2], and they're fairly subtle.  I'm not
> > saying your patches have these issues; only that extra code makes more
> > chances for mistakes and it's more work to validate it.
> >
> > > > I don't see the advantage of creating these files only when
> > > > the PF driver supports this.  The management tools have to
> > > > deal with sriov_vf_total_msix == 0 and sriov_vf_msix_count ==
> > > > 0 anyway.  Having the sysfs files not be present at all might
> > > > be slightly prettier to the person running "ls", but I'm not
> > > > sure the code complication is worth that.
> > >
> > > It is more than "ls", right now sriov_numvfs is visible without
> > > relation to the driver, even if driver doesn't implement
> > > ".sriov_configure", which IMHO bad. We didn't want to repeat.
> > >
> > > Right now, we have many devices that supports SR-IOV, but small
> > > amount of them are capable to rewrite their VF MSI-X table siz.
> > > We don't want "to punish" and clatter their sysfs.
> >
> > I agree, it's clutter, but at least it's just cosmetic clutter
> > (but I'm willing to hear discussion about why it's more than
> > cosmetic; see below).
> 
> It is more than cosmetic and IMHO it is related to the driver role.
> This feature is advertised, managed and configured by PF. It is very
> natural request that the PF will view/hide those sysfs files.

Agreed, it's natural if the PF driver adds/removes those files.  But I
don't think it's *essential*, and they *could* be static because of
this:

> > From the management software point of view, I don't think it matters.
> > That software already needs to deal with files that don't exist (on
> > old kernels) and files that contain zero (feature not supported or no
> > vectors are available).

I wonder if sysfs_update_group() would let us have our cake and eat
it, too?  Maybe we could define these files as static attributes and
call sysfs_update_group() when the PF driver binds or unbinds?

Makes me wonder if the device core could call sysfs_update_group()
when binding/unbinding drivers.  But there are only a few existing
callers, and it looks like none of them are for the bind/unbind
situation, so maybe that would be pointless.

> > From my point of view, pci_enable_vf_overlay() or
> > pci_disable_vfs_overlay() are also clutter, at least compared to
> > static sysfs attributes.
> >
> > > > I see a hint that Alex might have requested this "only visible when PF
> > > > driver supports it" functionality, but I don't see that email on
> > > > linux-pci, so I missed the background.
> > >
> > > First version of this patch had static files solution.
> > > https://lore.kernel.org/linux-pci/20210103082440.34994-2-leon@kernel.org/#Z30drivers:pci:iov.c
> >
> > Thanks for the pointer to the patch.  Can you point me to the
> > discussion about why we should use the "only visible when PF driver
> > supports it" model?
> 
> It is hard to pinpoint specific sentence, this discussion is spread
> across many emails and I implemented it in v4.
> 
> See this request from Alex:
> https://lore.kernel.org/linux-pci/20210114170543.143cce49@omen.home.shazbot.org/
> and this is my acknowledge:
> https://lore.kernel.org/linux-pci/20210116082331.GL944463@unreal/
> 
> BTW, I asked more than once how these sysfs knobs should be handled
> in the PCI/core.

Thanks for the pointers.  This is the first instance I can think of
where we want to create PCI core sysfs files based on a driver
binding, so there really isn't a precedent.

> > [1] https://lore.kernel.org/linux-pci/YBmG7qgIDYIveDfX@kroah.com/
> > [2] https://lore.kernel.org/linux-pci/20200716110423.xtfyb3n6tn5ixedh@pali/
