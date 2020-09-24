Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF467277C10
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIXW7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:59:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgIXW7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 18:59:11 -0400
Received: from localhost (52.sub-72-107-123.myvzw.com [72.107.123.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EED182344C;
        Thu, 24 Sep 2020 22:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600988350;
        bh=lvsTiRX9MRyqiIaTRVynMwfGHPPFwZX9ut7maU5MkAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Hl/Vlvmo1E7oAa1BexBNa8RKAX9MOEA8uUVVhQxoCXhlOI/SlZGSV5PN2ycFhhB4m
         VOcpgQfsTu2KXTYCGlNl2zxDGU0ZXDrpIWPRrFdiwfrCraM4slePzKQp87kJ/drQWz
         R8Ou2aVDStw2jjJ5rE3uFHTuPeC/tQFVIwYwoBjc=
Date:   Thu, 24 Sep 2020 17:59:08 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH v2 4/4] PCI: Limit pci_alloc_irq_vectors as per
 housekeeping CPUs
Message-ID: <20200924225908.GA2367591@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493a6fe5-f33f-85b2-6149-809f3cb4390f@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 05:39:07PM -0400, Nitesh Narayan Lal wrote:
> 
> On 9/24/20 4:45 PM, Bjorn Helgaas wrote:
> > Possible subject:
> >
> >   PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
> 
> Will switch to this.
> 
> > On Wed, Sep 23, 2020 at 02:11:26PM -0400, Nitesh Narayan Lal wrote:
> >> This patch limits the pci_alloc_irq_vectors, max_vecs argument that is
> >> passed on by the caller based on the housekeeping online CPUs (that are
> >> meant to perform managed IRQ jobs).
> >>
> >> A minimum of the max_vecs passed and housekeeping online CPUs is derived
> >> to ensure that we don't create excess vectors as that can be problematic
> >> specifically in an RT environment. In cases where the min_vecs exceeds the
> >> housekeeping online CPUs, max vecs is restricted based on the min_vecs
> >> instead. The proposed change is required because for an RT environment
> >> unwanted IRQs are moved to the housekeeping CPUs from isolated CPUs to
> >> keep the latency overhead to a minimum. If the number of housekeeping CPUs
> >> is significantly lower than that of the isolated CPUs we can run into
> >> failures while moving these IRQs to housekeeping CPUs due to per CPU
> >> vector limit.
> > Does this capture enough of the log?
> >
> >   If we have isolated CPUs dedicated for use by real-time tasks, we
> >   try to move IRQs to housekeeping CPUs to reduce overhead on the
> >   isolated CPUs.
> 
> How about:
> "
> If we have isolated CPUs or CPUs running in nohz_full mode for the purpose
> of real-time, we try to move IRQs to housekeeping CPUs to reduce latency
> overhead on these real-time CPUs.
> "
> 
> What do you think?

It's OK, but from the PCI core perspective, "nohz_full mode" doesn't
really mean anything.  I think it's a detail that should be inside the
"housekeeping CPU" abstraction.

> >   If we allocate too many IRQ vectors, moving them all to housekeeping
> >   CPUs may exceed per-CPU vector limits.
> >
> >   When we have isolated CPUs, limit the number of vectors allocated by
> >   pci_alloc_irq_vectors() to the minimum number required by the
> >   driver, or to one per housekeeping CPU if that is larger
> 
> I think this is good, I can adopt this.
> 
> > .
> >
> >> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> >> ---
> >>  include/linux/pci.h | 15 +++++++++++++++
> >>  1 file changed, 15 insertions(+)
> >>
> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
> >> index 835530605c0d..cf9ca9410213 100644
> >> --- a/include/linux/pci.h
> >> +++ b/include/linux/pci.h
> >> @@ -38,6 +38,7 @@
> >>  #include <linux/interrupt.h>
> >>  #include <linux/io.h>
> >>  #include <linux/resource_ext.h>
> >> +#include <linux/sched/isolation.h>
> >>  #include <uapi/linux/pci.h>
> >>  
> >>  #include <linux/pci_ids.h>
> >> @@ -1797,6 +1798,20 @@ static inline int
> >>  pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
> >>  		      unsigned int max_vecs, unsigned int flags)
> >>  {
> >> +	unsigned int hk_cpus = hk_num_online_cpus();
> >> +
> >> +	/*
> >> +	 * For a real-time environment, try to be conservative and at max only
> >> +	 * ask for the same number of vectors as there are housekeeping online
> >> +	 * CPUs. In case, the min_vecs requested exceeds the housekeeping
> >> +	 * online CPUs, restrict the max_vecs based on the min_vecs instead.
> >> +	 */
> >> +	if (hk_cpus != num_online_cpus()) {
> >> +		if (min_vecs > hk_cpus)
> >> +			max_vecs = min_vecs;
> >> +		else
> >> +			max_vecs = min_t(int, max_vecs, hk_cpus);
> >> +	}
> > Is the below basically the same?
> >
> > 	/*
> > 	 * If we have isolated CPUs for use by real-time tasks,
> > 	 * minimize overhead on those CPUs by moving IRQs to the
> > 	 * remaining "housekeeping" CPUs.  Limit vector usage to keep
> > 	 * housekeeping CPUs from running out of IRQ vectors.
> > 	 */
> 
> How about the following as a comment:
> 
> "
> If we have isolated CPUs or CPUs running in nohz_full mode for real-time,
> latency overhead is minimized on those CPUs by moving the IRQ vectors to
> the housekeeping CPUs. Limit the number of vectors to keep housekeeping
> CPUs from running out of IRQ vectors.
> 
> "
> 
> > 	if (housekeeping_cpus < num_online_cpus()) {
> > 		if (housekeeping_cpus < min_vecs)
> > 			max_vecs = min_vecs;
> > 		else if (housekeeping_cpus < max_vecs)
> > 			max_vecs = housekeeping_cpus;
> > 	}
> 
> The only reason I went with hk_cpus instead of housekeeping_cpus is because
> at other places in the kernel I found a similar naming convention (eg.
> hk_mask, hk_flags etc.).
> But if housekeeping_cpus makes things more clear, I can switch to that
> instead.
> 
> Although after Frederic and Peter's suggestion the previous call will change
> to something like:
> 
> "
> housekeeping_cpus = housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
> "
> 
> Which should still falls in the that 80 chars per line limit.

I don't really care whether it's "hk_cpus" or "housekeeping_cpus" as
long as "housekeeping" appears in the code somewhere.  If we call
"housekeeping_num_online_cpus()" that should be enough.

> > My comment isn't quite right because this patch only limits the number
> > of vectors; it doesn't actually *move* IRQs to the housekeeping CPUs.
> 
> Yeap it doesn't move IRQs to the housekeeping CPUs.
> 
> > I don't know where the move happens (or maybe you just avoid assigning
> > IRQs to isolated CPUs, and I don't know how that happens either).
> 
> This can happen in the userspace, either manually or by some application
> such as tuned.

Some brief hint about this might be helpful.

> >>  	return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags,
> >>  					      NULL);
> >>  }
> >> -- 
> >> 2.18.2
> >>
> -- 
> Thanks
> Nitesh
> 



