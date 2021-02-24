Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC76F3240BD
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbhBXPX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:23:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234191AbhBXPId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 10:08:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 829DD64ECE;
        Wed, 24 Feb 2021 15:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614179226;
        bh=iOc+6lUyUTnfAX8UjxQy0Si4XlePusKhqCbHzsETH/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=pL11se+h7pLwH99CWU1IQWpZxmmM9majEU9UIpTOjripHJyBxLckvzfTshlJBcjWC
         Z2Hx00CKxPxJW9DQU5hzGIBFuETina/jn90LVbBLnAVoOT99P7rMKvVuWo5sS1ca+s
         YFrWrWm5+YGyZlG7+JLdofl2DZmmZY0yre6c/0L/vtEX07SOW2OUGAHA5di2FcI66H
         /D35naGLcRJVEH/huoTwZG4qHDHlz6OWHgP0MH6D2mycYLArGZ0lVvEDQj2gI99PeF
         znFHPqZGN0TY4diUUOPFzXrvuYmTZoWgB7uvFmcfeD0bnYwe9ssy7MMoL6CtDFcl2r
         hDyREhxOOD/sA==
Date:   Wed, 24 Feb 2021 09:07:04 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20210224150704.GA1540010@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDYiGmpWDx9I59Qx@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 11:53:30AM +0200, Leon Romanovsky wrote:
> On Tue, Feb 23, 2021 at 03:07:43PM -0600, Bjorn Helgaas wrote:
> > On Sun, Feb 21, 2021 at 08:59:18AM +0200, Leon Romanovsky wrote:
> > > On Sat, Feb 20, 2021 at 01:06:00PM -0600, Bjorn Helgaas wrote:
> > > > On Fri, Feb 19, 2021 at 09:20:18AM +0100, Greg Kroah-Hartman wrote:
> > > >
> > > > > Ok, can you step back and try to explain what problem you are trying to
> > > > > solve first, before getting bogged down in odd details?  I find it
> > > > > highly unlikely that this is something "unique", but I could be wrong as
> > > > > I do not understand what you are wanting to do here at all.
> > > >
> > > > We want to add two new sysfs files:
> > > >
> > > >   sriov_vf_total_msix, for PF devices
> > > >   sriov_vf_msix_count, for VF devices associated with the PF
> > > >
> > > > AFAICT it is *acceptable* if they are both present always.  But it
> > > > would be *ideal* if they were only present when a driver that
> > > > implements the ->sriov_get_vf_total_msix() callback is bound to the
> > > > PF.
> > >
> > > BTW, we already have all possible combinations: static, static with
> > > folder, with and without "sriov_" prefix, dynamic with and without
> > > folders on VFs.
> > >
> > > I need to know on which version I'll get Acked-by and that version I
> > > will resubmit.
> >
> > I propose that you make static attributes for both files, so
> > "sriov_vf_total_msix" is visible for *every* PF in the system and
> > "sriov_vf_msix_count" is visible for *every* VF in the system.
> 
> No problem, this is close to v0/v1.
> 
> > The PF "sriov_vf_total_msix" show function can return zero if there's
> > no PF driver or it doesn't support ->sriov_get_vf_total_msix().
> > (Incidentally, I think the documentation should mention that when it
> > *is* supported, the contents of this file are *constant*, i.e., it
> > does not decrease as vectors are assigned to VFs.)
> >
> > The "sriov_vf_msix_count" set function can ignore writes if there's no
> > PF driver or it doesn't support ->sriov_get_vf_total_msix(), or if a
> > VF driver is bound.
> 
> Just to be clear, why don't we return EINVAL/EOPNOTSUPP instead of
> silently ignore?

Returning some error is fine.  I just meant that the reads/writes
would have no effect on the PCI core or the device driver.
