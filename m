Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E3D34F25A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhC3UmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhC3Uln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C96C61968;
        Tue, 30 Mar 2021 20:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617136903;
        bh=MLaLzXNLH8ULiTWMZmz1Y7DMZIk4SvSPzN74yWr68XY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=nP29/ZsJOGdpOqo7SvU3MAbDGBG36Vs6Bk6U9QnA13rB+gQXijd1zpMuEpQia5RrR
         XG+kAWRHhp9xZchIATf5sIWga1+VVq9o73UQ1U/rLel/RjuCEVyFyQcuSBTcB+mCv8
         y/y3FHUaYmoIKxU6kcXUVb/tF0LXbFY6DXKeKujM3YWBVRLWQTdDsGjO7biXfSktgT
         T7fS83EE2jshC0QSb8GP9KFLAnWDwASpS7otEPBtvOmywJv9GPb60p1ZpUC5dqAu/z
         S1cksVESTyayoQ695EaeMnmjKD+wzp4wPvXI9cZAwH1FnMjw3u5NPgRH1q6PrPLZ76
         lSV0/PVzNjxQg==
Date:   Tue, 30 Mar 2021 15:41:41 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <20210330204141.GA1305530@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330194716.GV2710221@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 04:47:16PM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 30, 2021 at 10:00:19AM -0500, Bjorn Helgaas wrote:
> > On Tue, Mar 30, 2021 at 10:57:38AM -0300, Jason Gunthorpe wrote:
> > > On Mon, Mar 29, 2021 at 08:29:49PM -0500, Bjorn Helgaas wrote:
> > > 
> > > > I think I misunderstood Greg's subdirectory comment.  We already have
> > > > directories like this:
> > > 
> > > Yes, IIRC, Greg's remark applies if you have to start creating
> > > directories with manual kobjects.
> > > 
> > > > and aspm_ctrl_attr_group (for "link") is nicely done with static
> > > > attributes.  So I think we could do something like this:
> > > > 
> > > >   /sys/bus/pci/devices/0000:01:00.0/   # PF directory
> > > >     sriov/                             # SR-IOV related stuff
> > > >       vf_total_msix
> > > >       vf_msix_count_BB:DD.F        # includes bus/dev/fn of first VF
> > > >       ...
> > > >       vf_msix_count_BB:DD.F        # includes bus/dev/fn of last VF
> > > 
> > > It looks a bit odd that it isn't a subdirectory, but this seems
> > > reasonable.
> > 
> > Sorry, I missed your point; you'll have to lay it out more explicitly.
> > I did intend that "sriov" *is* a subdirectory of the 0000:01:00.0
> > directory.  The full paths would be:
> >
> >   /sys/bus/pci/devices/0000:01:00.0/sriov/vf_total_msix
> >   /sys/bus/pci/devices/0000:01:00.0/sriov/vf_msix_count_BB:DD.F
> >   ...
> 
> Sorry, I was meaning what you first proposed:
> 
>    /sys/bus/pci/devices/0000:01:00.0/sriov/BB:DD.F/vf_msix_count
> 
> Which has the extra sub directory to organize the child VFs.
> 
> Keep in mind there is going to be alot of VFs here, > 1k - so this
> will be a huge directory.

With 0000:01:00.0/sriov/vf_msix_count_BB:DD.F, sriov/ will contain
1 + 1K files ("vf_total_msix" + 1 per VF).

With 0000:01:00.0/sriov/BB:DD.F/vf_msix_count, sriov/ will contain
1 file and 1K subdirectories.

No real difference now, but if we add more files per VF, a BB:DD.F/
subdirectory would certainly be nicer.

I'm dense and don't fully understand Greg's subdirectory comment.

The VF will have its own "pci/devices/DDDD:BB:DD.F/" directory, so
adding sriov/BB:DD.F/ under the PF shouldn't affect any udev events or
rules for the VF.

I see "ATTR{power/control}" in lots of udev rules, so I guess udev
could manage a single subdirectory like "ATTR{sriov/vf_total_msix}".
I doubt it could do "ATTR{sriov/adm/vf_total_msix}" (with another
level) or "ATTR{sriov/BBB:DD.F/vf_msix_count}" (with variable VF text
in the path).

But it doesn't seem like that level of control would be in a udev rule
anyway.  A PF udev rule might *start* a program to manage MSI-X
vectors, but such a program should be able to deal with whatever
directory structure we want.

If my uninformed udev speculation makes sense *and* we think there
will be more per-VF files later, I think I'm OK either way.

Bjorn
