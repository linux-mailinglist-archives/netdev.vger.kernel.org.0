Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF5277AA8
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgIXUpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXUph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 16:45:37 -0400
Received: from localhost (52.sub-72-107-123.myvzw.com [72.107.123.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B72239CF;
        Thu, 24 Sep 2020 20:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600980337;
        bh=CSiygoRkkeEiJ5Dg4g8lESgmoDARtWg5wsRqboDJATg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=lbvEvN+hi7Xe6uDbbh0duG3bBFI4mlVC2eLJrkDrq0bm+QX7ibnnVWghVPjb8tcG0
         YuJ+SGj7QBP8e0C3IlVs85IP5aYMRgjvFPdd5lkXT1H90pXt715BN77X7Al+8maXGt
         XDHdgpcD74XDD+iMJSb18S06YsjZkz/XA9eYamuE=
Date:   Thu, 24 Sep 2020 15:45:35 -0500
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
Message-ID: <20200924204535.GA2337207@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923181126.223766-5-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Possible subject:

  PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs

On Wed, Sep 23, 2020 at 02:11:26PM -0400, Nitesh Narayan Lal wrote:
> This patch limits the pci_alloc_irq_vectors, max_vecs argument that is
> passed on by the caller based on the housekeeping online CPUs (that are
> meant to perform managed IRQ jobs).
>
> A minimum of the max_vecs passed and housekeeping online CPUs is derived
> to ensure that we don't create excess vectors as that can be problematic
> specifically in an RT environment. In cases where the min_vecs exceeds the
> housekeeping online CPUs, max vecs is restricted based on the min_vecs
> instead. The proposed change is required because for an RT environment
> unwanted IRQs are moved to the housekeeping CPUs from isolated CPUs to
> keep the latency overhead to a minimum. If the number of housekeeping CPUs
> is significantly lower than that of the isolated CPUs we can run into
> failures while moving these IRQs to housekeeping CPUs due to per CPU
> vector limit.

Does this capture enough of the log?

  If we have isolated CPUs dedicated for use by real-time tasks, we
  try to move IRQs to housekeeping CPUs to reduce overhead on the
  isolated CPUs.

  If we allocate too many IRQ vectors, moving them all to housekeeping
  CPUs may exceed per-CPU vector limits.

  When we have isolated CPUs, limit the number of vectors allocated by
  pci_alloc_irq_vectors() to the minimum number required by the
  driver, or to one per housekeeping CPU if that is larger.

> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  include/linux/pci.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 835530605c0d..cf9ca9410213 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -38,6 +38,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/resource_ext.h>
> +#include <linux/sched/isolation.h>
>  #include <uapi/linux/pci.h>
>  
>  #include <linux/pci_ids.h>
> @@ -1797,6 +1798,20 @@ static inline int
>  pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
>  		      unsigned int max_vecs, unsigned int flags)
>  {
> +	unsigned int hk_cpus = hk_num_online_cpus();
> +
> +	/*
> +	 * For a real-time environment, try to be conservative and at max only
> +	 * ask for the same number of vectors as there are housekeeping online
> +	 * CPUs. In case, the min_vecs requested exceeds the housekeeping
> +	 * online CPUs, restrict the max_vecs based on the min_vecs instead.
> +	 */
> +	if (hk_cpus != num_online_cpus()) {
> +		if (min_vecs > hk_cpus)
> +			max_vecs = min_vecs;
> +		else
> +			max_vecs = min_t(int, max_vecs, hk_cpus);
> +	}

Is the below basically the same?

	/*
	 * If we have isolated CPUs for use by real-time tasks,
	 * minimize overhead on those CPUs by moving IRQs to the
	 * remaining "housekeeping" CPUs.  Limit vector usage to keep
	 * housekeeping CPUs from running out of IRQ vectors.
	 */
	if (housekeeping_cpus < num_online_cpus()) {
		if (housekeeping_cpus < min_vecs)
			max_vecs = min_vecs;
		else if (housekeeping_cpus < max_vecs)
			max_vecs = housekeeping_cpus;
	}

My comment isn't quite right because this patch only limits the number
of vectors; it doesn't actually *move* IRQs to the housekeeping CPUs.
I don't know where the move happens (or maybe you just avoid assigning
IRQs to isolated CPUs, and I don't know how that happens either).

>  	return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags,
>  					      NULL);
>  }
> -- 
> 2.18.2
> 
