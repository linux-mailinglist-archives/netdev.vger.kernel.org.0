Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D748531E056
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 21:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhBQU3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 15:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234306AbhBQU3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 15:29:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A6A264E6C;
        Wed, 17 Feb 2021 20:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613593717;
        bh=a6QpZqU55gjL/Q8QuodHxez8YphzyIG5Bvnh/4G8tTw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ieoQudFwwpQvs5BmFauSnEZg0zrCInvuf/VyTvsvsVyaJ5U/tDzg1ds69gmZejZzN
         ndjXSjXSPJtfmLNrswe7Ue2BWGTpbYpgdF+qJW/8cu3ccozGcTLD5rRshMYP+WA5Jk
         Bzr7EowEXop/cU0FdEMt8WgevBGTCbUg2dsdxmZF8l9D6/8a1UiyTKvgo5wWo7Iwjz
         WPSnT0YyVSnaKIlC4frmlPwPDwhedav02EzHZTg6zNaIJUEWlptY455KWfKA0h+Rot
         L95ZEe1MfrFuAbazo6h9dKMSVlbqXwS3h3GKBidFFPUicSiS8LMORWC2IUHNooeiMr
         PHNK8+n/2PIPg==
Date:   Wed, 17 Feb 2021 14:28:35 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210217202835.GA906388@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217192522.GW4247@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 03:25:22PM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 17, 2021 at 12:02:39PM -0600, Bjorn Helgaas wrote:
> 
> > > BTW, I asked more than once how these sysfs knobs should be handled
> > > in the PCI/core.
> > 
> > Thanks for the pointers.  This is the first instance I can think of
> > where we want to create PCI core sysfs files based on a driver
> > binding, so there really isn't a precedent.
> 
> The MSI stuff does it today, doesn't it? eg:
> 
> virtblk_probe (this is a driver bind)
>   init_vq
>    virtio_find_vqs
>     vp_modern_find_vqs
>      vp_find_vqs
>       vp_find_vqs_msix
>        vp_request_msix_vectors
>         pci_alloc_irq_vectors_affinity
>          __pci_enable_msi_range
>           msi_capability_init
> 	   populate_msi_sysfs
> 	    	ret = sysfs_create_groups(&pdev->dev.kobj, msi_irq_groups);
> 
> And the sysfs is removed during pci_disable_msi(), also called by the
> driver

Yes, you're right, I didn't notice that one.

I'm not quite convinced that we clean up correctly in all cases --
pci_disable_msix(), pci_disable_msi(), pci_free_irq_vectors(),
pcim_release(), etc are called by several drivers, but in my quick
look I didn't see a guaranteed-to-be-called path to the cleanup during
driver unbind.  I probably just missed it.
