Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F4B273EFC
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgIVJyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgIVJyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 05:54:45 -0400
Received: from localhost (lfbn-ncy-1-588-162.w81-51.abo.wanadoo.fr [81.51.203.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 379F22388B;
        Tue, 22 Sep 2020 09:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600768484;
        bh=wVsuNscc6uO1wPqCG+l9fv4OFQ2ZNZAjEW/5B3rgRLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cglr/Y6QgsCnfxxoYaxARk5NUazh3bvXU7+VXVr5xkaJVyKgewoev6uEEaZW6rNOD
         nhVcDXt0qjUWUdWd4n2OuBHvAxf1kiaW9BpVPkOcBAqcYE1VZUz981BpJ1kUcDFrLD
         bbk0oZfvCh/WzemWd9QF0N+5nwOS/zyRibOK7ZpQ=
Date:   Tue, 22 Sep 2020 11:54:41 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, mtosatti@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
Subject: Re: [RFC][Patch v1 2/3] i40e: limit msix vectors based on
 housekeeping CPUs
Message-ID: <20200922095440.GA5217@lenoir>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-3-nitesh@redhat.com>
 <20200917112359.00006e10@intel.com>
 <20200921225834.GA30521@lenoir>
 <65513ee8-4678-1f96-1850-0e13dbf1810c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65513ee8-4678-1f96-1850-0e13dbf1810c@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 11:08:20PM -0400, Nitesh Narayan Lal wrote:
> 
> On 9/21/20 6:58 PM, Frederic Weisbecker wrote:
> > On Thu, Sep 17, 2020 at 11:23:59AM -0700, Jesse Brandeburg wrote:
> >> Nitesh Narayan Lal wrote:
> >>
> >>> In a realtime environment, it is essential to isolate unwanted IRQs from
> >>> isolated CPUs to prevent latency overheads. Creating MSIX vectors only
> >>> based on the online CPUs could lead to a potential issue on an RT setup
> >>> that has several isolated CPUs but a very few housekeeping CPUs. This is
> >>> because in these kinds of setups an attempt to move the IRQs to the
> >>> limited housekeeping CPUs from isolated CPUs might fail due to the per
> >>> CPU vector limit. This could eventually result in latency spikes because
> >>> of the IRQ threads that we fail to move from isolated CPUs.
> >>>
> >>> This patch prevents i40e to add vectors only based on available
> >>> housekeeping CPUs by using num_housekeeping_cpus().
> >>>
> >>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> >> The driver changes are straightforward, but this isn't the only driver
> >> with this issue, right?  I'm sure ixgbe and ice both have this problem
> >> too, you should fix them as well, at a minimum, and probably other
> >> vendors drivers:
> >>
> >> $ rg -c --stats num_online_cpus drivers/net/ethernet
> >> ...
> >> 50 files contained matches
> > Ouch, I was indeed surprised that these MSI vector allocations were done
> > at the driver level and not at some $SUBSYSTEM level.
> >
> > The logic is already there in the driver so I wouldn't oppose to this very patch
> > but would a shared infrastructure make sense for this? Something that would
> > also handle hotplug operations?
> >
> > Does it possibly go even beyond networking drivers?
> 
> From a generic solution perspective, I think it makes sense to come up with a
> shared infrastructure.
> Something that can be consumed by all the drivers and maybe hotplug operations
> as well (I will have to further explore the hotplug part).

That would be great. I'm completely clueless about those MSI things and the
actual needs of those drivers. Now it seems to me that if several CPUs become
offline, or as is planned in the future, CPU isolation gets enabled/disabled
through cpuset, then the vectors may need some reorganization.

But I don't also want to push toward a complicated solution to handle CPU hotplug
if there is no actual problem to solve there. So I let you guys judge.

> However, there are RT workloads that are getting affected because of this
> issue, so does it make sense to go ahead with this per-driver basis approach
> for now?

Yep that sounds good.

> 
> Since a generic solution will require a fair amount of testing and
> understanding of different drivers. Having said that, I can definetly start
> looking in that direction.

Thanks a lot!
