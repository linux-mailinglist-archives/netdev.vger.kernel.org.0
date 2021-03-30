Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9890F34F095
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 20:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhC3SLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 14:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhC3SKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 14:10:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70C5B619D1;
        Tue, 30 Mar 2021 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617127847;
        bh=E4CSAOav2miwBccqpWx6Wl4oB6R4c2qqsJVd8NGrcos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pU90oj8QlnmK3EtLJzLSRK50ZsjvBKKwT+Hljpotn2sk/KlEr5oS2o3mCP2tlf+bh
         lX4qI5onDRKex/2Db4BTok3V0yfSkh/99x5HRFESSbJH0rVZeZXELeZu/yNWow7axx
         ZennwI3NBGTbOscxZmECAUhpaIRQJ1WUYGQq7RHNs5TbpDLz79EdTAQ3aY2kdIYYXR
         43i6a7NcAJJmaA5B9VAppcwA1i25ZtSP6NBf5Ioc5bIMAmx3z1NJvmuXfNcJx3M+PG
         aMEV4faG8gfbVol7bdb7qS4xGb9+RNJiMRl0Luai9DF4lEBGTCin/SXYJ4vifVGfIP
         x6MUqJNBmNy0Q==
Date:   Wed, 31 Mar 2021 03:10:39 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <20210330181039.GA22898@redsun51.ssa.fujisawa.hgst.com>
References: <20210326190148.GN2710221@ziepe.ca>
 <20210330012949.GA1205505@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330012949.GA1205505@bjorn-Precision-5520>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 08:29:49PM -0500, Bjorn Helgaas wrote:
> On Fri, Mar 26, 2021 at 04:01:48PM -0300, Jason Gunthorpe wrote:
> > On Fri, Mar 26, 2021 at 11:50:44AM -0700, Alexander Duyck wrote:
> > 
> > > My concern would be that we are defining the user space interface.
> > > Once we have this working as a single operation I could see us having
> > > to support it that way going forward as somebody will script something
> > > not expecting an "offline" sysfs file, and the complaint would be that
> > > we are breaking userspace if we require the use of an "offline"
> > > file.
> > 
> > Well, we wouldn't do that. The semantic we define here is that the
> > msix_count interface 'auto-offlines' if that is what is required. If
> > we add some formal offline someday then 'auto-offline' would be a NOP
> > when the device is offline and do the same online/offline sequence as
> > today if it isn't.
> 
> Alexander, Keith, any more thoughts on this?
> 
> I think I misunderstood Greg's subdirectory comment.  We already have
> directories like this:
> 
>   /sys/bus/pci/devices/0000:01:00.0/link/
>   /sys/bus/pci/devices/0000:01:00.0/msi_irqs/
>   /sys/bus/pci/devices/0000:01:00.0/power/
> 
> and aspm_ctrl_attr_group (for "link") is nicely done with static
> attributes.  So I think we could do something like this:
> 
>   /sys/bus/pci/devices/0000:01:00.0/   # PF directory
>     sriov/                             # SR-IOV related stuff
>       vf_total_msix
>       vf_msix_count_BB:DD.F        # includes bus/dev/fn of first VF
>       ...
>       vf_msix_count_BB:DD.F        # includes bus/dev/fn of last VF
> 
> And I think this could support the mlx5 model as well as the NVMe
> model.
> 
> For NVMe, a write to vf_msix_count_* would have to auto-offline the VF
> before asking the PF to assign the vectors, as Jason suggests above.
> Before VF Enable is set, the vf_msix_count_* files wouldn't exist and
> we wouldn't be able to assign vectors to VFs; IIUC that's a difference
> from the NVMe interface, but maybe not a terrible one?

Yes, that's fine, nvme can handle this flow. It is a little easier to
avoid nvme user error if we could mainpulate the counts prior to VF Enable,
but it's really not a problem this way either.

I think it's reasonable for nvme to subscribe to this interface, but I
will have to defer to someone with capable nvme devices to implement it.
