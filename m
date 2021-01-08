Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA582EEDD7
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 08:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbhAHH0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 02:26:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbhAHH0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 02:26:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A3D233EA;
        Fri,  8 Jan 2021 07:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610090729;
        bh=W3fjBukYtXVl70AvmnapadWSfI3WRh1WbQCJUo+GdaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ddzU5ARDokZ5f4kjFmpZOujvVpCG5y8N+uTbuF4d2vCCKQYABEzI4MI+OEVoGZHHz
         5O09JTsfkSJAuLP0cRjSthbTeiifo4RzSw9SEmTfAXicHUWCACfdHQQtEvH3vPJWy8
         ZJSi/GyEbYxJyIVSumlAwGPjp9zMn0YC8iTcqjvIhZNa8YxNEZ7MIXZRL2F42tPSc0
         Bs4vGQDQdoG6+5d0lNgVCxkpEp7ytSEIb99DrsQyRiA3kmuZH/QUh99XBeAv9oSmnQ
         KNP3bZOq2HHD+A/0qqUGBbrqEcF4oy63i2rr3w0R7wxZTUULCULqH/KixMg9WIQygf
         N4QrinhFv3AJA==
Date:   Fri, 8 Jan 2021 09:25:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next 1/4] PCI: Configure number of MSI-X vectors for
 SR-IOV VFs
Message-ID: <20210108072525.GB31158@unreal>
References: <20210108005721.GA1403391@bjorn-Precision-5520>
 <ba1e7c38-2a21-40ba-787f-458b979b938f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba1e7c38-2a21-40ba-787f-458b979b938f@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:54:38PM -0500, Don Dutile wrote:
> On 1/7/21 7:57 PM, Bjorn Helgaas wrote:
> > [+cc Alex, Don]

<...>

> > Help me connect the dots here.  Is this required because of something
> > peculiar to mlx5, or is something like this required for all SR-IOV
> > devices because of the way the PCIe spec is written?
> So, overall, I'm guessing the mlx5 device can have 1000's of MSIX -- say, one per send/receive/completion queue.
> This device capability may exceed the max number MSIX a VM can have/support (depending on guestos).
> So, a sysfs tunable is used to set the max MSIX available, and thus, the device puts >1 send/rcv/completion queue intr on a given MSIX.
>
> ok, time for Leon to better state what this patch does,
> and why it's needed on mlx5 (and may be applicable to other/future high-MSIX devices assigned to VMs (NVME?)).
> Hmmm, now that I said it, why is it SRIOV-centric and not pci-device centric (can pass a PF w/high number of MSIX to a VM).

Thanks Don and Bjorn,

I will answer on all comments a little bit later when I will return
to the office (Sunday).

However it is important for me to present the use case.

Our mlx5 SR-IOV devices were always capable to drive many MSI-X (upto 2K,
don't catch me on exact number), however when user created VFs, the FW has
no knowledge of how those VFs will be used. So FW had no choice but statically
and equally assign same amount of MSI-X to all VFs.

After SR-IOV VF creation, user will bind those new VFs to the VMs, but
the VMs have different number of CPUs and despite HW being able to deliver
all needed number of vectors (in mlx5 netdev world, number of channels == number
of CPUs == number of vectors), we will be limited by already set low number
of vectors.

So it is not for vector reduction, but more for vector re-partition.

As an example, imagine mlx5 with two VFs. One VF is bounded to VM with 200 CPUs
and another is bounded to VM with 1 CPU. They need different amount of MSI-X vectors.

Hope that I succeeded to explain :).

Regarding why it is SR-IOV and not PCI, the amount of MSI-X vectors is
read-only field in the PCI, so we can't write from pci/core toward
PF device and expect HW update it. It means that if we really need it,
we will need to do it after driver already loaded on that PF, so driver
will forward to HW and lspci will work correctly. This will require
reload of whole PCI device initialization sequence, because MSI-X table
size pre-calculated very early in the init flow.

Thanks

>
> -Don
