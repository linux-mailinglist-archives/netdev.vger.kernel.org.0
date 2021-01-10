Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDE22F05F2
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 09:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbhAJIZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 03:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbhAJIZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 03:25:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA0F7239CF;
        Sun, 10 Jan 2021 08:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610267116;
        bh=7EhG0J5JpQO3L1iVUb23M31Y6IJpycb65agr16WKfh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VU4mst4ECpvLEX5v2qFYMTaEqLJKdBc/zFJ8j7tmiep4crceVIv6UyurUXuF51Kyb
         hKW6Q+G6IhdHylagZKyk2Gh0wBuBmGmwNE6W3hIX6uXtKnRDeS5wMH+K5bVdfqujjJ
         Kr+x8HTbmz2ubWe5K3FgZArWuatXrbVzNkJRrmhsg+fanjoy1/eQGpFVqoQtY7Kc3f
         xahDNfIyN9QLxHpP511HJoeQDaYDIdXiRJMc6TK6IP6tQJxcGgTXM4hZFmwA5jtuXo
         ZV5D70HS0bvCIjZCF/XEwbdGnzoAKokOl3paDojC2OPBkYrDXZHbemshNOJY5TZl20
         +eD58o/HqvvsA==
Date:   Sun, 10 Jan 2021 10:25:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next 1/4] PCI: Configure number of MSI-X vectors for
 SR-IOV VFs
Message-ID: <20210110082512.GE31158@unreal>
References: <ba1e7c38-2a21-40ba-787f-458b979b938f@redhat.com>
 <20210108210913.GA1471923@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108210913.GA1471923@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 03:09:13PM -0600, Bjorn Helgaas wrote:
> On Thu, Jan 07, 2021 at 10:54:38PM -0500, Don Dutile wrote:
> > On 1/7/21 7:57 PM, Bjorn Helgaas wrote:
> > > On Sun, Jan 03, 2021 at 10:24:37AM +0200, Leon Romanovsky wrote:
>
> > > > + **/
> > > > +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
> > > > +{
> > > > +	struct pci_dev *pdev = pci_physfn(dev);
> > > > +
> > > > +	if (!dev->msix_cap || !pdev->msix_cap)
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (dev->driver || !pdev->driver ||
> > > > +	    !pdev->driver->sriov_set_msix_vec_count)
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	if (numb < 0)
> > > > +		/*
> > > > +		 * We don't support negative numbers for now,
> > > > +		 * but maybe in the future it will make sense.
> > > > +		 */
> > > > +		return -EINVAL;
> > > > +
> > > > +	return pdev->driver->sriov_set_msix_vec_count(dev, numb);
> > >
> > > So we write to a VF sysfs file, get here and look up the PF, call a PF
> > > driver callback with the VF as an argument, the callback (at least for
> > > mlx5) looks up the PF from the VF, then does some mlx5-specific magic
> > > to the PF that influences the VF somehow?
> >
> > There's no PF lookup above.... it's just checking if a pdev has a
> > driver with the desired msix-cap setting(reduction) feature.
>
> We started with the VF (the sysfs file is attached to the VF).  "pdev"
> is the corresponding PF; that's what I meant by "looking up the PF".
> Then we call the PF driver sriov_set_msix_vec_count() method.
>
> I asked because this raises questions of whether we need mutual
> exclusion or some other coordination between setting this for multiple
> VFs.

MSI-X are managed by HW and they are separated between VFs.
IMHO, it will be better if SW won't do too much coordination.

Thanks

>
> Obviously it's great to answer all these in email, but at the end of
> the day, the rationale needs to be in the commit, either in code
> comments or the commit log.
