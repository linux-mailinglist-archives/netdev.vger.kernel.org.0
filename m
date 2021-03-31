Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B8934F7B2
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 06:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhCaEIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 00:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCaEIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 00:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68F4B619CA;
        Wed, 31 Mar 2021 04:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617163691;
        bh=UMlsOs6Dbxca83C/3FBS5+AJAtMOOVGiJGMuoOu1ndc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SYYDIOtIi0+N9w8MwEQgQLYHde5HWkZSry+zXS6MTOxYNu1xLn28tauXTw4DjwkZs
         RgHynOg7nt4m83nPp9iHMDvMrqazLNA2FSzED2PkXlUaIqEKXwT84/hUHRHoB8nRGb
         ziU4+c5gD5kvQHpfAsQcZFR+ZjAvHrASmqz0JdZ/I5AChKN3LZE5bHCLk9ogosqoGY
         9K702KBOy4PgLC/EBbKvU+7iAETpj+3AVjygOaAtyf6dTW42R+/66PE2vg9g+m0FgX
         KXiAenyhx13NsV5L/JiPK1WLGyXSGA5qMALAyh7hO92FjH6o43ZfXVZxJJiRzCvqFb
         pBVSXB3LD75pg==
Date:   Wed, 31 Mar 2021 07:08:07 +0300
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YGP1p7KH+/gL4NAU@unreal>
References: <20210330194716.GV2710221@ziepe.ca>
 <20210330204141.GA1305530@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330204141.GA1305530@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 03:41:41PM -0500, Bjorn Helgaas wrote:
> On Tue, Mar 30, 2021 at 04:47:16PM -0300, Jason Gunthorpe wrote:
> > On Tue, Mar 30, 2021 at 10:00:19AM -0500, Bjorn Helgaas wrote:
> > > On Tue, Mar 30, 2021 at 10:57:38AM -0300, Jason Gunthorpe wrote:
> > > > On Mon, Mar 29, 2021 at 08:29:49PM -0500, Bjorn Helgaas wrote:
> > > > 
> > > > > I think I misunderstood Greg's subdirectory comment.  We already have
> > > > > directories like this:
> > > > 
> > > > Yes, IIRC, Greg's remark applies if you have to start creating
> > > > directories with manual kobjects.
> > > > 
> > > > > and aspm_ctrl_attr_group (for "link") is nicely done with static
> > > > > attributes.  So I think we could do something like this:
> > > > > 
> > > > >   /sys/bus/pci/devices/0000:01:00.0/   # PF directory
> > > > >     sriov/                             # SR-IOV related stuff
> > > > >       vf_total_msix
> > > > >       vf_msix_count_BB:DD.F        # includes bus/dev/fn of first VF
> > > > >       ...
> > > > >       vf_msix_count_BB:DD.F        # includes bus/dev/fn of last VF
> > > > 
> > > > It looks a bit odd that it isn't a subdirectory, but this seems
> > > > reasonable.
> > > 
> > > Sorry, I missed your point; you'll have to lay it out more explicitly.
> > > I did intend that "sriov" *is* a subdirectory of the 0000:01:00.0
> > > directory.  The full paths would be:
> > >
> > >   /sys/bus/pci/devices/0000:01:00.0/sriov/vf_total_msix
> > >   /sys/bus/pci/devices/0000:01:00.0/sriov/vf_msix_count_BB:DD.F
> > >   ...
> > 
> > Sorry, I was meaning what you first proposed:
> > 
> >    /sys/bus/pci/devices/0000:01:00.0/sriov/BB:DD.F/vf_msix_count
> > 
> > Which has the extra sub directory to organize the child VFs.
> > 
> > Keep in mind there is going to be alot of VFs here, > 1k - so this
> > will be a huge directory.
> 
> With 0000:01:00.0/sriov/vf_msix_count_BB:DD.F, sriov/ will contain
> 1 + 1K files ("vf_total_msix" + 1 per VF).
> 
> With 0000:01:00.0/sriov/BB:DD.F/vf_msix_count, sriov/ will contain
> 1 file and 1K subdirectories.

This is racy by design, in order to add new file and create BB:DD.F
directory, the VF will need to do it after or during it's creation.
During PF creation it is unknown to PF those BB:DD.F values.

The race here is due to the events of PF,VF directory already sent but
new directory structure is not ready yet.

From code perspective, we will need to add something similar to pci_iov_sysfs_link()
with the code that you didn't like in previous variants (the one that messes with
sysfs_create_file API).

It looks not good for large SR-IOV systems with >1K VFs with gazillion
subdirectories inside PF, while the more natural is to see them in VF.

So I'm completely puzzled why you want to do these files on PF and not
on VF as v0, v7 and v8 proposed.

Thanks
