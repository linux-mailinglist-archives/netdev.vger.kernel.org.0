Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7F52EF9F8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbhAHVJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbhAHVJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 16:09:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2BF323A5A;
        Fri,  8 Jan 2021 21:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610140155;
        bh=ojGhrHfNQK2SNPN5lQcE7SdOhTZeRmvGT8stlz24KBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=XF32wVwH5bNYvhjAlGQew+lq2auuThz+oZdR8Fve/mUqbPX+Eb0ky8r47r5b5Z1I1
         C9ejggwguGrcbu2NSqidnRk+JgXliUao3uWFzZW5YKMaXaLgA9TLMbp8VDrNGlJ/g6
         CtCwE2FW5fVJiGHJhTLGP7sUW8SZog6P2R0B2IGjdPDDIm4Q295kY5D+uFGsdiKFIr
         AtovQODWm1CXFeLZ/BW2a0vFSHVKxonEJU0RmRefc39hYH1SobuxncylHqauy6/tr1
         7haVglFMl7c0inigjJ8+B8NxoZ2nlXguallA6g8qMFqIy4knI54kocphsPbEmGUSxS
         yBT2zkiPFg3Dg==
Date:   Fri, 8 Jan 2021 15:09:13 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Don Dutile <ddutile@redhat.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next 1/4] PCI: Configure number of MSI-X vectors for
 SR-IOV VFs
Message-ID: <20210108210913.GA1471923@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba1e7c38-2a21-40ba-787f-458b979b938f@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:54:38PM -0500, Don Dutile wrote:
> On 1/7/21 7:57 PM, Bjorn Helgaas wrote:
> > On Sun, Jan 03, 2021 at 10:24:37AM +0200, Leon Romanovsky wrote:

> > > + **/
> > > +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
> > > +{
> > > +	struct pci_dev *pdev = pci_physfn(dev);
> > > +
> > > +	if (!dev->msix_cap || !pdev->msix_cap)
> > > +		return -EINVAL;
> > > +
> > > +	if (dev->driver || !pdev->driver ||
> > > +	    !pdev->driver->sriov_set_msix_vec_count)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	if (numb < 0)
> > > +		/*
> > > +		 * We don't support negative numbers for now,
> > > +		 * but maybe in the future it will make sense.
> > > +		 */
> > > +		return -EINVAL;
> > > +
> > > +	return pdev->driver->sriov_set_msix_vec_count(dev, numb);
> >
> > So we write to a VF sysfs file, get here and look up the PF, call a PF
> > driver callback with the VF as an argument, the callback (at least for
> > mlx5) looks up the PF from the VF, then does some mlx5-specific magic
> > to the PF that influences the VF somehow?
>
> There's no PF lookup above.... it's just checking if a pdev has a
> driver with the desired msix-cap setting(reduction) feature.

We started with the VF (the sysfs file is attached to the VF).  "pdev"
is the corresponding PF; that's what I meant by "looking up the PF".
Then we call the PF driver sriov_set_msix_vec_count() method.

I asked because this raises questions of whether we need mutual
exclusion or some other coordination between setting this for multiple
VFs.

Obviously it's great to answer all these in email, but at the end of
the day, the rationale needs to be in the commit, either in code
comments or the commit log.
