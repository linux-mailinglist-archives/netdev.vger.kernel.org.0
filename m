Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725ED31FD87
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 17:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhBSQ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 11:59:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhBSQ7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 11:59:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DF136024A;
        Fri, 19 Feb 2021 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613753905;
        bh=NMo5yhyTlIxLySt+nSwX0SRCkEKanmzR/cCYJOgr3iI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bNOPbzHSaM4/vVw3+4RymgErrpNZfj8y/7buzxo2BkSuoUfn1cxTW1zvwW6Jr5J8N
         NdYj5KxrzgbVy53zttyqJDHLjUxkzTKya+unKCcFG70MVf35cjEqXyFuV9lgNUSRf8
         d1xEEXqhTARJIYpzLMQlS6kKlhzVcBZ3CktHc/DqE3YrZCxMRlrc6ozfR/zg26W70Y
         iX4UOo2let49EMToU1mHhFqkSTAPSRArVTUoCjQW1vKrkxB7UHOw2ZORTS2PfTUutZ
         AdyNYjkjJxfVd6My+aSZiXhCAzjFtW8bAdnU4B139cO9iF2cppDQgUszMRPfdT04xq
         L7VbwLFauDCaQ==
Date:   Fri, 19 Feb 2021 18:58:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <YC/uLNk2YMPMVL5c@unreal>
References: <YC4+V6W7s7ytwiC6@unreal>
 <20210218223950.GA1004646@bjorn-Precision-5520>
 <YC9uLDAQJK9KgxbB@unreal>
 <YC90wkwk/CdgcYY6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YC90wkwk/CdgcYY6@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 09:20:18AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 19, 2021 at 09:52:12AM +0200, Leon Romanovsky wrote:
> > On Thu, Feb 18, 2021 at 04:39:50PM -0600, Bjorn Helgaas wrote:
> > > On Thu, Feb 18, 2021 at 12:15:51PM +0200, Leon Romanovsky wrote:
> > > > On Wed, Feb 17, 2021 at 12:02:39PM -0600, Bjorn Helgaas wrote:
> > > > > [+cc Greg in case he wants to chime in on the sysfs discussion.
> > > > > TL;DR: we're trying to add/remove sysfs files when a PCI driver that
> > > > > supports certain callbacks binds or unbinds; series at
> > > > > https://lore.kernel.org/r/20210209133445.700225-1-leon@kernel.org]
> > > > >
> > > > > On Tue, Feb 16, 2021 at 09:58:25PM +0200, Leon Romanovsky wrote:
> > > > > > On Tue, Feb 16, 2021 at 10:12:12AM -0600, Bjorn Helgaas wrote:
> > > > > > > On Tue, Feb 16, 2021 at 09:33:44AM +0200, Leon Romanovsky wrote:
> > > > > > > > On Mon, Feb 15, 2021 at 03:01:06PM -0600, Bjorn Helgaas wrote:
> > > > > > > > > On Tue, Feb 09, 2021 at 03:34:42PM +0200, Leon Romanovsky wrote:
> > > > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > >
> > > > > > > > > > +int pci_enable_vf_overlay(struct pci_dev *dev)
> > > > > > > > > > +{
> > > > > > > > > > +	struct pci_dev *virtfn;
> > > > > > > > > > +	int id, ret;
> > > > > > > > > > +
> > > > > > > > > > +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> > > > > > > > > > +		return 0;
> > > > > > > > > > +
> > > > > > > > > > +	ret = sysfs_create_files(&dev->dev.kobj, sriov_pf_dev_attrs);
> > > > > > > > >
> > > > > > > > > But I still don't like the fact that we're calling
> > > > > > > > > sysfs_create_files() and sysfs_remove_files() directly.  It makes
> > > > > > > > > complication and opportunities for errors.
> > > > > > > >
> > > > > > > > It is not different from any other code that we have in the kernel.
> > > > > > >
> > > > > > > It *is* different.  There is a general rule that drivers should not
> > > > > > > call sysfs_* [1].  The PCI core is arguably not a "driver," but it is
> > > > > > > still true that callers of sysfs_create_files() are very special, and
> > > > > > > I'd prefer not to add another one.
> > > > > >
> > > > > > PCI for me is a bus, and bus is the right place to manage sysfs.
> > > > > > But it doesn't matter, we understand each other positions.
> > > > > >
> > > > > > > > Let's be concrete, can you point to the errors in this code that I
> > > > > > > > should fix?
> > > > > > >
> > > > > > > I'm not saying there are current errors; I'm saying the additional
> > > > > > > code makes errors possible in future code.  For example, we hope that
> > > > > > > other drivers can use these sysfs interfaces, and it's possible they
> > > > > > > may not call pci_enable_vf_overlay() or pci_disable_vfs_overlay()
> > > > > > > correctly.
> > > > > >
> > > > > > If not, we will fix, we just need is to ensure that sysfs name won't
> > > > > > change, everything else is easy to change.
> > > > > >
> > > > > > > Or there may be races in device addition/removal.  We have current
> > > > > > > issues in this area, e.g., [2], and they're fairly subtle.  I'm not
> > > > > > > saying your patches have these issues; only that extra code makes more
> > > > > > > chances for mistakes and it's more work to validate it.
> > > > > > >
> > > > > > > > > I don't see the advantage of creating these files only when
> > > > > > > > > the PF driver supports this.  The management tools have to
> > > > > > > > > deal with sriov_vf_total_msix == 0 and sriov_vf_msix_count ==
> > > > > > > > > 0 anyway.  Having the sysfs files not be present at all might
> > > > > > > > > be slightly prettier to the person running "ls", but I'm not
> > > > > > > > > sure the code complication is worth that.
> > > > > > > >
> > > > > > > > It is more than "ls", right now sriov_numvfs is visible without
> > > > > > > > relation to the driver, even if driver doesn't implement
> > > > > > > > ".sriov_configure", which IMHO bad. We didn't want to repeat.
> > > > > > > >
> > > > > > > > Right now, we have many devices that supports SR-IOV, but small
> > > > > > > > amount of them are capable to rewrite their VF MSI-X table siz.
> > > > > > > > We don't want "to punish" and clatter their sysfs.
> > > > > > >
> > > > > > > I agree, it's clutter, but at least it's just cosmetic clutter
> > > > > > > (but I'm willing to hear discussion about why it's more than
> > > > > > > cosmetic; see below).
> > > > > >
> > > > > > It is more than cosmetic and IMHO it is related to the driver role.
> > > > > > This feature is advertised, managed and configured by PF. It is very
> > > > > > natural request that the PF will view/hide those sysfs files.
> > > > >
> > > > > Agreed, it's natural if the PF driver adds/removes those files.  But I
> > > > > don't think it's *essential*, and they *could* be static because of
> > > > > this:
> > > > >
> > > > > > > From the management software point of view, I don't think it matters.
> > > > > > > That software already needs to deal with files that don't exist (on
> > > > > > > old kernels) and files that contain zero (feature not supported or no
> > > > > > > vectors are available).
> > > > >
> > > > > I wonder if sysfs_update_group() would let us have our cake and eat
> > > > > it, too?  Maybe we could define these files as static attributes and
> > > > > call sysfs_update_group() when the PF driver binds or unbinds?
> > > > >
> > > > > Makes me wonder if the device core could call sysfs_update_group()
> > > > > when binding/unbinding drivers.  But there are only a few existing
> > > > > callers, and it looks like none of them are for the bind/unbind
> > > > > situation, so maybe that would be pointless.
> > > >
> > > > Also it will be not an easy task to do it in driver/core. Our
> > > > attributes need to be visible if driver is bound -> we will call to
> > > > sysfs_update_group() after ->bind() callback. It means that in
> > > > uwind, we will call to sysfs_update_group() before ->unbind() and
> > > > the driver will be still bound. So the check is is_supported() for
> > > > driver exists/or not won't be possible.
> > >
> > > Poking around some more, I found .dev_groups, which might be
> > > applicable?  The test patch below applies to v5.11 and makes the "bh"
> > > file visible in devices bound to the uhci_hcd driver if the function
> > > number is odd.
> >
> > This solution can be applicable for generic drivers where we can afford
> > to have custom sysfs files for this driver. In our case, we are talking
> > about hardware device driver. Both RDMA and netdev are against allowing
> > for such drivers to create their own sysfs. It will be real nightmare to
> > have different names/layout/output for the same functionality.
> >
> > This .dev_groups moves responsibility over sysfs to the drivers and it
> > is no-go for us.
>
> But it _is_ the driver's responsibility for sysfs files, right?

It depends on how you declare "responsibility". Direct creating/deletion of
sysfs files is prohibited in netdev and RDMA subsystems. We want to provide
to our users and stack uniformed way of interacting with the system.

It is super painful to manage large fleet of NICs and/or HCAs if every device
driver provides something different for the same feature.

>
> If not, what exactly are you trying to do here, as I am very confused.

https://lore.kernel.org/linux-rdma/20210216203726.GH4247@nvidia.com/T/#m899d883c8a10d95959ac0cd2833762f93729b8ef
Please see more details below.

>
> > Another problem with this approach is addition of VFs, not only every
> > driver will start to manage its own sysfs, but it will need to iterate
> > over PCI bus or internal lists to find VFs, because we want to create
> > .set_msix_vec on VFs after PF is bound.
>
> What?  I don't understand at all.
>
> > So instead of one, controlled place, we will find ourselves with many
> > genius implementations of the same thing in the drivers.
>
> Same _what_ thing?

This thread is part of conversation with Bjorn where he is looking for a
way to avoid creation of sysfs files in the PCI/core.
https://lore.kernel.org/linux-rdma/20210216203726.GH4247@nvidia.com/T/#madc000cf04b5246b450f7183a1d80abdf408a949

https://lore.kernel.org/linux-rdma/20210216203726.GH4247@nvidia.com/T/#Z2e.:..:20210209133445.700225-2-leon::40kernel.org:0drivers:pci:iov.c

>
> > Bjorn, we really do standard enable/disable flow with out overlay thing.
>
> Ok, can you step back and try to explain what problem you are trying to
> solve first, before getting bogged down in odd details?  I find it
> highly unlikely that this is something "unique", but I could be wrong as
> I do not understand what you are wanting to do here at all.

I don't know if you are familiar with SR-IOV concepts, if yes, just skip
the following paragraph.

SR-IOV capable devices have two types of their hardware functions which visible
as PCI devices: physical functions (PF) and virtual functions (VF). Both types
have PCI BDF and driver which probes them during initialization. The PF has extra
properties and it is the one who creates (spawns) new VFs (everything according to
he PCI-SIG).

This series adds new sysfs files to the VFs which are not bound yet (without driver attached)
while the PF driver is loaded. The change to VFs is needed to be done before their driver is
loaded because MSI-X table vector size (the property which we are changing) is used very early
in the initialization sequence.
https://lore.kernel.org/linux-rdma/20210216203726.GH4247@nvidia.com/T/#m899d883c8a10d95959ac0cd2833762f93729b8ef

We have two different flows for supported devices:
1. PF starts and initiates VFs.
2. PF starts and connects to already existing VFs.

So there is nothing "unique" here, as long as this logic is handled by the PCI/core.

Thanks

>
> thanks,
>
> greg k-h
