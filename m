Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553133517CB
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbhDARmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234554AbhDARiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 13:38:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4156060FE9;
        Thu,  1 Apr 2021 11:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617277761;
        bh=EPJNwswEK3h3kT/GAaC4gGLGB4JsVi5vkwcbC4qJ+gc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SN6ebFFYdpXC2UgZWgK0FeQoi2POcoYkUGaKApeATMNlqher71O6Z2tPhH38GiHMv
         TH0avdiy7E3oU4BpD54K0RWVuf4eglisvGF6fEFLNF8a8CweTkKOSmF8ptzNMrfbqc
         id1fUXBj2TD3UlFlNfj2pOO8DmO1QCXbbs0je+OC6GmT/yyKp+ytJpeu/8yLRnL5Iz
         mlIHmNx49uctrLSKUoQIawjkdb5STWWS/RXZcAGMIDDeDmNos5lJyJjyXz5nL5WIiA
         YGxBGMFTnhZ3raBm18sZlucFiYr/y2pjLDz8qU++3vKLE6hE0Wt8vq2ELxlrCdVWBt
         lFaBAk/DbZiyQ==
Date:   Thu, 1 Apr 2021 14:49:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YGWzPklSzw97gI3D@unreal>
References: <YGP1p7KH+/gL4NAU@unreal>
 <20210401012340.GA1423690@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401012340.GA1423690@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 08:23:40PM -0500, Bjorn Helgaas wrote:
> [+cc Rafael, in case you're interested in the driver core issue here]
> 
> On Wed, Mar 31, 2021 at 07:08:07AM +0300, Leon Romanovsky wrote:
> > On Tue, Mar 30, 2021 at 03:41:41PM -0500, Bjorn Helgaas wrote:
> > > On Tue, Mar 30, 2021 at 04:47:16PM -0300, Jason Gunthorpe wrote:
> > > > On Tue, Mar 30, 2021 at 10:00:19AM -0500, Bjorn Helgaas wrote:
> > > > > On Tue, Mar 30, 2021 at 10:57:38AM -0300, Jason Gunthorpe wrote:
> > > > > > On Mon, Mar 29, 2021 at 08:29:49PM -0500, Bjorn Helgaas wrote:
> > > > > > 
> > > > > > > I think I misunderstood Greg's subdirectory comment.  We already have
> > > > > > > directories like this:
> > > > > > 
> > > > > > Yes, IIRC, Greg's remark applies if you have to start creating
> > > > > > directories with manual kobjects.
> > > > > > 
> > > > > > > and aspm_ctrl_attr_group (for "link") is nicely done with static
> > > > > > > attributes.  So I think we could do something like this:
> > > > > > > 
> > > > > > >   /sys/bus/pci/devices/0000:01:00.0/   # PF directory
> > > > > > >     sriov/                             # SR-IOV related stuff
> > > > > > >       vf_total_msix
> > > > > > >       vf_msix_count_BB:DD.F        # includes bus/dev/fn of first VF
> > > > > > >       ...
> > > > > > >       vf_msix_count_BB:DD.F        # includes bus/dev/fn of last VF
> > > > > > 
> > > > > > It looks a bit odd that it isn't a subdirectory, but this seems
> > > > > > reasonable.
> > > > > 
> > > > > Sorry, I missed your point; you'll have to lay it out more explicitly.
> > > > > I did intend that "sriov" *is* a subdirectory of the 0000:01:00.0
> > > > > directory.  The full paths would be:
> > > > >
> > > > >   /sys/bus/pci/devices/0000:01:00.0/sriov/vf_total_msix
> > > > >   /sys/bus/pci/devices/0000:01:00.0/sriov/vf_msix_count_BB:DD.F
> > > > >   ...
> > > > 
> > > > Sorry, I was meaning what you first proposed:
> > > > 
> > > >    /sys/bus/pci/devices/0000:01:00.0/sriov/BB:DD.F/vf_msix_count
> > > > 
> > > > Which has the extra sub directory to organize the child VFs.
> > > > 
> > > > Keep in mind there is going to be alot of VFs here, > 1k - so this
> > > > will be a huge directory.
> > > 
> > > With 0000:01:00.0/sriov/vf_msix_count_BB:DD.F, sriov/ will contain
> > > 1 + 1K files ("vf_total_msix" + 1 per VF).
> > > 
> > > With 0000:01:00.0/sriov/BB:DD.F/vf_msix_count, sriov/ will contain
> > > 1 file and 1K subdirectories.
> > 
> > This is racy by design, in order to add new file and create BB:DD.F
> > directory, the VF will need to do it after or during it's creation.
> > During PF creation it is unknown to PF those BB:DD.F values.
> > 
> > The race here is due to the events of PF,VF directory already sent
> > but new directory structure is not ready yet.
> >
> > From code perspective, we will need to add something similar to
> > pci_iov_sysfs_link() with the code that you didn't like in previous
> > variants (the one that messes with sysfs_create_file API).
> > 
> > It looks not good for large SR-IOV systems with >1K VFs with
> > gazillion subdirectories inside PF, while the more natural is to see
> > them in VF.
> > 
> > So I'm completely puzzled why you want to do these files on PF and
> > not on VF as v0, v7 and v8 proposed.
> 
> On both mlx5 and NVMe, the "assign vectors to VF" functionality is
> implemented by the PF, so I think it's reasonable to explore the idea
> of "associate the vector assignment sysfs file with the PF."

As you said, it is our (Linux kernel) implementation, but from user space
perspective it is seen different. The user "configures" specific VF and
doesn't need to know that we are routing his requests through PF.

> 
> Assume 1K VFs.  Either way we have >1K subdirectories of
> /sys/devices/pci0000:00/.  I think we should avoid an extra
> subdirectory level, so I think the choices on the table are:

Right, we already have 1k subdirectories and PF will have 1k virtfnX
links anyway. So for me it doesn't look appealing to see extra 1K files.

In case someone else will need to add another parameter to this sriov
overlay directory, we will find an extra 1K files and repeat again for
any new parameter.

At the end, the discussion here is to make this sysfs feature to be very
general and 1k files in one folder for every parameter is not nice (IMHO).

In theory, SR-IOV spec allows up-to 64K VFs per-PF.

> 
> Associate "vf_msix_count" with the PF:
> 
>   - /sys/.../<PF>/sriov/vf_total_msix    # all on PF
> 
>   - /sys/.../<PF>/sriov/vf_msix_count_BB:DD.F (1K of these).  Greg
>     says the number of these is not a problem.
> 
>   - The "vf_total_msix" and "vf_msix_count_*" files are all related
>     and are grouped together in PF/sriov/.
> 
>   - The "vf_msix_count_*" files operate directly on the PF.  Lock the
>     PF for serialization, lookup and lock the VF to ensure no VF
>     driver, call PF driver callback to assign vectors.
> 
>   - Requires special sysfs code to create/remove "vf_msix_count_*"
>     files when setting/clearing VF Enable.  This code could create
>     them only when the PF driver actually supports vector assignment.
>     Unavoidable sysfs/uevent race, see below.
> 
> Associate "vf_msix_count" with the VF:
> 
>   - /sys/.../<PF>/sriov_vf_total_msix    # on PF
> 
>   - /sys/.../<VF>/sriov_vf_msix_count    # on each VF
> 
>   - The "sriov_vf_msix_count" files enter via the VF.  Lock the VF to
>     ensure no VF driver, lookup and lock the PF for serialization,
>     call PF driver callback to assign vectors.
> 
>   - Can be done with static sysfs attributes.  This means creating
>     "sriov_vf_msix_count" *always*, even if PF driver doesn't support
>     vector assignment.

The same goes for the next parameter that someone will add.

> 
> IIUC, putting "vf_msix_count_*" under the PF involves a race.  When we
> call device_add() for each new VF, it creates the VF sysfs directory
> and emits the KOBJ_ADD uevent, but the "vf_msix_count_*" file doesn't
> exist yet.  It can't be created before device_add() because the sysfs
> directory doesn't exist.  If we create it after device_add(), the "add
> VF" uevent has already been emitted, so userspace may consume it
> before "vf_msix_count_*" is created.
> 
>   sriov_enable
>     <set VF Enable>                     <-- VFs created on PCI
>     sriov_add_vfs
>       for (i = 0; i < num_vfs; i++) {
>         pci_iov_add_virtfn
>           pci_device_add
>             device_initialize
>             device_add
>               device_add_attrs          <-- add VF sysfs attrs
>               kobject_uevent(KOBJ_ADD)  <-- emit uevent
>                                         <-- add "vf_msix_count_*" sysfs attr
>           pci_iov_sysfs_link
>           pci_bus_add_device
>             pci_create_sysfs_dev_files
>             device_attach
>       }
> 
> Conceptually, I like having the "vf_total_msix" and "vf_msix_count_*"
> files associated directly with the PF.  I think that's more natural
> because they both operate directly on the PF.

And this is where we disagree :)

> 
> But I don't like the race, and using static attributes seems much
> cleaner implementation-wise.

Right, so what should be my next steps in order to do not miss this merge
window?

Thanks

> 
> Bjorn
