Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128D02F05FE
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 09:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbhAJIeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 03:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbhAJIea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 03:34:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEA6B22273;
        Sun, 10 Jan 2021 08:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610267629;
        bh=17YS8s3EjM6sWQuB97FEADF0NZ+04BjztX50LXKwNK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i94+pQwcWx12Nw/bfTA+ZsseA3RP+x6djXFvBOjdUUF2yiUX00QzTHU0XzwKTsvpM
         qfV53/RAO44E9d6tyf0CYxmul9f3+pSaKDqiDRAo9Ob8Bt6w3mzuTaOGzrAhcGgDLl
         SnL5ZTCwkAzxcTjwGxW5p3IRh92Qjolrr1+3nPguNWbIFJIpQWw8ef2Brha+o48h3S
         9t1cU8z198y+7n9lH+Ub5a88MPcz+4ju52gSVG93QywvlRWY7nQC0cJe2HMAmQ4Ig+
         qKjM+34D1vMFdjY56ERUcAVSL4tu3FHpkrMg8m4Nw4VeJiHfB1I6cgNn4LYnchHfjb
         pSRnAxWqnzxrg==
Date:   Sun, 10 Jan 2021 10:33:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Don Dutile <ddutile@redhat.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next 1/4] PCI: Configure number of MSI-X vectors for
 SR-IOV VFs
Message-ID: <20210110083345.GG31158@unreal>
References: <20210108210913.GA1471923@bjorn-Precision-5520>
 <96209762-64a8-c710-1b1e-c0cc5207df03@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96209762-64a8-c710-1b1e-c0cc5207df03@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 09:54:47PM -0500, Don Dutile wrote:
> On 1/8/21 4:09 PM, Bjorn Helgaas wrote:
> > On Thu, Jan 07, 2021 at 10:54:38PM -0500, Don Dutile wrote:
> > > On 1/7/21 7:57 PM, Bjorn Helgaas wrote:
> > > > On Sun, Jan 03, 2021 at 10:24:37AM +0200, Leon Romanovsky wrote:
> > > > > + **/
> > > > > +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
> > > > > +{
> > > > > +	struct pci_dev *pdev = pci_physfn(dev);
> > > > > +
> > > > > +	if (!dev->msix_cap || !pdev->msix_cap)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (dev->driver || !pdev->driver ||
> > > > > +	    !pdev->driver->sriov_set_msix_vec_count)
> > > > > +		return -EOPNOTSUPP;
> > > > > +
> > > > > +	if (numb < 0)
> > > > > +		/*
> > > > > +		 * We don't support negative numbers for now,
> > > > > +		 * but maybe in the future it will make sense.
> > > > > +		 */
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	return pdev->driver->sriov_set_msix_vec_count(dev, numb);
> > > > So we write to a VF sysfs file, get here and look up the PF, call a PF
> > > > driver callback with the VF as an argument, the callback (at least for
> > > > mlx5) looks up the PF from the VF, then does some mlx5-specific magic
> > > > to the PF that influences the VF somehow?
> > > There's no PF lookup above.... it's just checking if a pdev has a
> > > driver with the desired msix-cap setting(reduction) feature.
> > We started with the VF (the sysfs file is attached to the VF).  "pdev"
> > is the corresponding PF; that's what I meant by "looking up the PF".
> > Then we call the PF driver sriov_set_msix_vec_count() method.
> ah, got how your statement relates to the files &/or pdev.
>
> > I asked because this raises questions of whether we need mutual
> > exclusion or some other coordination between setting this for multiple
> > VFs.
> >
> > Obviously it's great to answer all these in email, but at the end of
> > the day, the rationale needs to be in the commit, either in code
> > comments or the commit log.
> >
> I'm still not getting why this is not per-(vf)pdev -- just b/c a device has N-number of MSIX capability doesn't mean it has to all be used/configured,
> Setting max-MSIX for VFs in the PF's pdev means it is the same number for all VFs ... and I'm not sure that's the right solution either.
> It should still be (v)pdev-based, IMO.

The proposed solution is per-VF, am I missing anything in this discussion?

> --dd
>
