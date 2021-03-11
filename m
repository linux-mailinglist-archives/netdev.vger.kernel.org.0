Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697A1336DED
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 09:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhCKIha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 03:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231362AbhCKIhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 03:37:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB06E64F87;
        Thu, 11 Mar 2021 08:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615451827;
        bh=WTRYhIbXBuo/t5BkaB+NdSfbK6vNcQ7O2pTkFSkZ2ZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OFUY4tcN4rgrDUp7yv4hcD2Js8LhS1pItQ8BCFEpxRm8Vp6WuYOhDwCTtbJlDTjMD
         rEDZvL8W/B7LtpwWh0BxLRQR/3pkBiMcSgE+OAXAa2HScEklnzz2uJDixwJafV2APg
         ZGCkkNF0Yvf+b+qvkk1ICzRoWP4EEAATWRyyWttOeyb+oUcOhgoIItEM3k2dTc4vh/
         kZSgjAy4aJ+1U0evadfnEOLq0qHfDGmu2MLFyTcbGM/3UBuUN5zGMzMc24CcNW4vmn
         FcHPTe7s4dlhZVRknHp6asfa5Ft9VJlPqMVe4uO+eH3+98PZJis0weHCXpLxsT/Qz/
         iRtNgLEfNtgxQ==
Date:   Thu, 11 Mar 2021 10:37:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YEnWr/xufSXvszIw@unreal>
References: <CAKgT0Ue=g+1pZCct8Kd0OnkPEP0qhggBF96s=noDoWHMJTL6FA@mail.gmail.com>
 <20210310190906.GA2020121@bjorn-Precision-5520>
 <YEknweta9TXcw1l5@unreal>
 <YEkqY5ZJLXp8dork@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEkqY5ZJLXp8dork@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 09:21:55PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 10, 2021 at 10:10:41PM +0200, Leon Romanovsky wrote:
> > On Wed, Mar 10, 2021 at 01:09:06PM -0600, Bjorn Helgaas wrote:
> > > On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> > > > On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > >
> > > > > @Alexander Duyck, please update me if I can add your ROB tag again
> > > > > to the series, because you liked v6 more.
> > > > >
> > > > > Thanks
> > > > >
> > > > > ---------------------------------------------------------------------------------
> > > > > Changelog
> > > > > v7:
> > > > >  * Rebase on top v5.12-rc1
> > > > >  * More english fixes
> > > > >  * Returned to static sysfs creation model as was implemented in v0/v1.
> >
> > <...>
> >
> > >   2) Should a VF sysfs file use the PF to implement this?
> > >
> > >      Can you elaborate on your idea here?  I guess
> > >      pci_iov_sysfs_link() makes a "virtfnX" link from the PF to the
> > >      VF, and you're thinking we could also make a "virtfnX_msix_count"
> > >      in the PF directory?  That's a really interesting idea.
> >
> > I want to remind that we are talking about mlx5 devices that support
> > upto 255 VFs and they indeed are used to their limits. So seeing 255
> > links of virtfnX_msix_count in the same directory looks too much unpleasant
> > to me.
>
> 255 files are nothing, if that's what the hardware supports, what is the
> problem?  If it's "unpleasant", go complain to the hardware designers :)

It is 255 same files that every SR-IOV user will see in /sys/bus/pci/devices/*/
folder, unless we will do dynamic creation of those files and this is something
that Bjorn didn't like in v7.

So instead of complaining to the hardware designers, I will complain here.
I probably implemented all possible variants already. :)

Thanks

>
> greg k-h
