Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BCB3232FB
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 22:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhBWVIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 16:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234326AbhBWVI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 16:08:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6414B64E7A;
        Tue, 23 Feb 2021 21:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614114465;
        bh=rCOssPv+IwpIG8OBgzhlbyUEFROVY5qRWGQQRfDcqX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=qAOxV7YlhawQvRRdzq5U3GF24aSyKkrmuawkErkdvagdhwdXCipKhsMjDDojFjsw7
         LgqGJ56vGzDYZbsnqjmFaPw++pM8RSxim39MuNF2YkzRenUIpQv/DxxkEGHmZs9PTb
         ZI6kCMf9Mh0232nIo8rKz8QbDguosV5NMxJkkCc49ZNreCuGBz1j+bUM8Mckv4+ol4
         ED2n2XhvSTBYycZYsVArUPJ+AaNIc4h0xBK4PszW59tSNkpW7xi2m6wS5tU51lhG1J
         i7J3jB0tg2W0G78QWjLl4lrVFIOM1DxYowJu4B2I52RCYy0YGedcK8GH6zFmP/6ZJ/
         pR6+A1xjK9Piw==
Date:   Tue, 23 Feb 2021 15:07:43 -0600
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
Message-ID: <20210223210743.GA1475710@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDIExpismOnU3c4k@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 08:59:18AM +0200, Leon Romanovsky wrote:
> On Sat, Feb 20, 2021 at 01:06:00PM -0600, Bjorn Helgaas wrote:
> > On Fri, Feb 19, 2021 at 09:20:18AM +0100, Greg Kroah-Hartman wrote:
> >
> > > Ok, can you step back and try to explain what problem you are trying to
> > > solve first, before getting bogged down in odd details?  I find it
> > > highly unlikely that this is something "unique", but I could be wrong as
> > > I do not understand what you are wanting to do here at all.
> >
> > We want to add two new sysfs files:
> >
> >   sriov_vf_total_msix, for PF devices
> >   sriov_vf_msix_count, for VF devices associated with the PF
> >
> > AFAICT it is *acceptable* if they are both present always.  But it
> > would be *ideal* if they were only present when a driver that
> > implements the ->sriov_get_vf_total_msix() callback is bound to the
> > PF.
> 
> BTW, we already have all possible combinations: static, static with
> folder, with and without "sriov_" prefix, dynamic with and without
> folders on VFs.
> 
> I need to know on which version I'll get Acked-by and that version I
> will resubmit.

I propose that you make static attributes for both files, so
"sriov_vf_total_msix" is visible for *every* PF in the system and
"sriov_vf_msix_count" is visible for *every* VF in the system.

The PF "sriov_vf_total_msix" show function can return zero if there's
no PF driver or it doesn't support ->sriov_get_vf_total_msix().
(Incidentally, I think the documentation should mention that when it
*is* supported, the contents of this file are *constant*, i.e., it
does not decrease as vectors are assigned to VFs.)

The "sriov_vf_msix_count" set function can ignore writes if there's no
PF driver or it doesn't support ->sriov_get_vf_total_msix(), or if a
VF driver is bound.

Any userspace software must be able to deal with those scenarios
anyway, so I don't think the mere presence or absence of the files is
a meaningful signal to that software.

If we figure out a way to make the files visible only when the
appropriate driver is bound, that might be nice and could always be
done later.  But I don't think it's essential.

Bjorn
