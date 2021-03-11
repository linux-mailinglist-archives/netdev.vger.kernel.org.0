Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5542337D82
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCKTSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:18:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhCKTRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 14:17:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC6B64F00;
        Thu, 11 Mar 2021 19:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615490264;
        bh=LTJl889g0VnVx3/pVzoNcb6cScgKkV/3Qo9yuGEPNvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ipAFNFKcd/22U41LbjCBA8GlWbGUm6Sy6YK9K0bHP7+l0Rw4bUJ5xmB0E/JLP4SXG
         Nb1hNqznUwUXdnFE3XkYXOXx0CWLXq+8X2M92xCCXQTIXAhTIYRnj+srfpDvO9Bzmx
         r2b11HQNDbwo/Lam5XQGwjigEMZVMBbQnD6WCdUpiWAfXbYJM0GCoEJ3Mlv7F1zvHu
         JbSuWdUJLRVEss8NUDs+o6+0uOmaoGduH7+PCJseejVSeOJ0g4P4zP1z+t0RdKaP3p
         Aowovv20xCdlYDvbeM1/qha1xwDhSvAgK+FKdqVmvkm6NWsULlSQtZwF+4n41PCC4F
         BMW7xPY7Avjfg==
Date:   Thu, 11 Mar 2021 21:17:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
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
Message-ID: <YEps1B+DEztFfy8R@unreal>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311181729.GA2148230@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 12:17:29PM -0600, Bjorn Helgaas wrote:
> On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > On Wed, Mar 10, 2021 at 11:09 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
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
> > > >
> > > > Yeah, so I am not a fan of the series. The problem is there is only
> > > > one driver that supports this, all VFs are going to expose this sysfs,
> > > > and I don't know how likely it is that any others are going to
> > > > implement this functionality. I feel like you threw out all the
> > > > progress from v2-v6.
> > >
> > > pci_enable_vfs_overlay() turned up in v4, so I think v0-v3 had static
> > > sysfs files regardless of whether the PF driver was bound.
> > >
> > > > I really feel like the big issue is that this model is broken as you
> > > > have the VFs exposing sysfs interfaces that make use of the PFs to
> > > > actually implement. Greg's complaint was the PF pushing sysfs onto the
> > > > VFs. My complaint is VFs sysfs files operating on the PF. The trick is
> > > > to find a way to address both issues.
> > > >
> > > > Maybe the compromise is to reach down into the IOV code and have it
> > > > register the sysfs interface at device creation time in something like
> > > > pci_iov_sysfs_link if the PF has the functionality present to support
> > > > it.
> > >
> > > IIUC there are two questions on the table:
> > >
> > >   1) Should the sysfs files be visible only when a PF driver that
> > >      supports MSI-X vector assignment is bound?
> > >
> > >      I think this is a cosmetic issue.  The presence of the file is
> > >      not a reliable signal to management software; it must always
> > >      tolerate files that don't exist (e.g., on old kernels) or files
> > >      that are visible but don't work (e.g., vectors may be exhausted).
> > >
> > >      If we start with the files always being visible, we should be
> > >      able to add smarts later to expose them only when the PF driver
> > >      is bound.
> > >
> > >      My concerns with pci_enable_vf_overlay() are that it uses a
> > >      little more sysfs internals than I'd like (although there are
> > >      many callers of sysfs_create_files()) and it uses
> > >      pci_get_domain_bus_and_slot(), which is generally a hack and
> > >      creates refcounting hassles.  Speaking of which, isn't v6 missing
> > >      a pci_dev_put() to match the pci_get_domain_bus_and_slot()?
> >
> > I'm not so much worried about management software as the fact that
> > this is a vendor specific implementation detail that is shaping how
> > the kernel interfaces are meant to work. Other than the mlx5 I don't
> > know if there are any other vendors really onboard with this sort of
> > solution.
>
> I know this is currently vendor-specific, but I thought the value
> proposition of dynamic configuration of VFs for different clients
> sounded compelling enough that other vendors would do something
> similar.  But I'm not an SR-IOV guy and have no vendor insight, so
> maybe that's not the case?

It is not the case, any vendor who wants to compete with Mellanox
devices in large scale clouds, will be asked to implement this feature.

You can't provide reliable VM service without it.

<...>

> > I checked it again, it will make the *_msix_count files stop working.
> > In order to guarantee it cannot happen in the middle of things though
> > we are sitting on the device locks for both the PF and the VF. I'm not
> > a fan of having to hold 2 locks while we perform a firmware operation
> > for one device, but I couldn't find anything where we would deadlock
> > so it should be fine.
>
> I agree again, it's not ideal to hold two locks.  Is it possible we
> could get by without the VF lock?  If we simply check whether a VF
> driver is bound (without a lock), a VF driver bind can race with the
> PF sriov_set_msix_vec_count().

We are holding huge amount of locks simultaneously. I don't understand
why two locks can be so big deal now.

Alex said that my locking scheme is correct, I think you also said that.
Why do we need to add races and make correct solution to be half baked?

>
> If the VF driver bind wins, it reads the old Table Size.  If it reads
> a too-small size, it won't use all the vectors.  If it reads a
> too-large size, it will try to use too many vectors and some won't
> work.  But the race would be caused by a bug in the management
> software, and the consequence doesn't seem *terrible*.

It will present to the user/administrator incorrect picture where lspci
output won't be aligned with the real situation.

Thanks

>
> Bjorn
