Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83641334792
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbhCJTJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:09:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232880AbhCJTJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:09:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 609A764F93;
        Wed, 10 Mar 2021 19:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403348;
        bh=/zpyjVEYsl5qnKnsooOKZ2w+XT7cw6yuEAItNuarinc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=hVtTJdMIu4SQ2XrTyYP3PKyc0zktSkjizJJujRecAM+7qc/DqUUZEsM8+aKrf+SwE
         UZiSJb42rwlhmkT2RTD+C/slo+LmD9Nnae8qFtSYGdPBJWL/yBm4WB3D1YmGFJ0PLI
         8d3s6/fZbRFHNmSwcZWgSin3kExP4X+LXNy9Y/KODfuyysAxvezcxwAqLEIJImjULA
         QTLUFEY+znsoSooI6UYYbJoz806X8HVfCKYy43Ayi+a1nJ2KxRi8/fBXs9e+8yG9Dv
         y8Mdq5DEUlQ6OZeHRlZGiUvfN2LHsURoIGpEAEixF0PvBZ5Cigd07bLnCEfyqE549N
         qTAJr2GfTPOxg==
Date:   Wed, 10 Mar 2021 13:09:06 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210310190906.GA2020121@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ue=g+1pZCct8Kd0OnkPEP0qhggBF96s=noDoWHMJTL6FA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > @Alexander Duyck, please update me if I can add your ROB tag again
> > to the series, because you liked v6 more.
> >
> > Thanks
> >
> > ---------------------------------------------------------------------------------
> > Changelog
> > v7:
> >  * Rebase on top v5.12-rc1
> >  * More english fixes
> >  * Returned to static sysfs creation model as was implemented in v0/v1.
> 
> Yeah, so I am not a fan of the series. The problem is there is only
> one driver that supports this, all VFs are going to expose this sysfs,
> and I don't know how likely it is that any others are going to
> implement this functionality. I feel like you threw out all the
> progress from v2-v6.

pci_enable_vfs_overlay() turned up in v4, so I think v0-v3 had static
sysfs files regardless of whether the PF driver was bound.

> I really feel like the big issue is that this model is broken as you
> have the VFs exposing sysfs interfaces that make use of the PFs to
> actually implement. Greg's complaint was the PF pushing sysfs onto the
> VFs. My complaint is VFs sysfs files operating on the PF. The trick is
> to find a way to address both issues.
> 
> Maybe the compromise is to reach down into the IOV code and have it
> register the sysfs interface at device creation time in something like
> pci_iov_sysfs_link if the PF has the functionality present to support
> it.

IIUC there are two questions on the table:

  1) Should the sysfs files be visible only when a PF driver that
     supports MSI-X vector assignment is bound?

     I think this is a cosmetic issue.  The presence of the file is
     not a reliable signal to management software; it must always
     tolerate files that don't exist (e.g., on old kernels) or files
     that are visible but don't work (e.g., vectors may be exhausted).

     If we start with the files always being visible, we should be
     able to add smarts later to expose them only when the PF driver
     is bound.

     My concerns with pci_enable_vf_overlay() are that it uses a
     little more sysfs internals than I'd like (although there are
     many callers of sysfs_create_files()) and it uses
     pci_get_domain_bus_and_slot(), which is generally a hack and
     creates refcounting hassles.  Speaking of which, isn't v6 missing
     a pci_dev_put() to match the pci_get_domain_bus_and_slot()?

  2) Should a VF sysfs file use the PF to implement this?

     Can you elaborate on your idea here?  I guess
     pci_iov_sysfs_link() makes a "virtfnX" link from the PF to the
     VF, and you're thinking we could also make a "virtfnX_msix_count"
     in the PF directory?  That's a really interesting idea.

> Also we might want to double check that the PF cannot be unbound while
> the VF is present. I know for a while there it was possible to remove
> the PF driver while the VF was present. The Mellanox drivers may not
> allow it but it might not hurt to look at taking a reference against
> the PF driver if you are allocating the VF MSI-X configuration sysfs
> file.

Unbinding the PF driver will either remove the *_msix_count files or
make them stop working.  Is that a problem?  I'm not sure we should
add a magic link that prevents driver unbinding.  Seems like it would
be hard for users to figure out why the driver can't be removed.

Bjorn
