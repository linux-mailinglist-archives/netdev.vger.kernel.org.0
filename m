Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38A227923D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgIYUdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbgIYUXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:23:10 -0400
Received: from localhost (52.sub-72-107-123.myvzw.com [72.107.123.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06632086A;
        Fri, 25 Sep 2020 20:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601065390;
        bh=aAD9nZhpTjqZoeBXICyqCwtEuwV7OkIfU4T3ggIlc10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=IP0ezM9Hn3/SEbnXK8TrCpPU7kRkkU4GntqwiLY9scgvlBhza9gfYs4fDlR+UTw5E
         7meYkbHytKkecaciibT3kRIDoZvHZ5bhjtn7r5lSZ6JMAEMa0Fxet1Bn5KanI+X0A2
         EvYfgyhUyriYf30OHWamCVzv44rklq3Ah2VB2B4o=
Date:   Fri, 25 Sep 2020 15:23:07 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jiri@nvidia.com, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
Subject: Re: [PATCH v3 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20200925202307.GA2456332@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925182654.224004-5-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 02:26:54PM -0400, Nitesh Narayan Lal wrote:
> If we have isolated CPUs dedicated for use by real-time tasks, we try to
> move IRQs to housekeeping CPUs from the userspace to reduce latency
> overhead on the isolated CPUs.
> 
> If we allocate too many IRQ vectors, moving them all to housekeeping CPUs
> may exceed per-CPU vector limits.
> 
> When we have isolated CPUs, limit the number of vectors allocated by
> pci_alloc_irq_vectors() to the minimum number required by the driver, or
> to one per housekeeping CPU if that is larger.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  include/linux/pci.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 835530605c0d..a7b10240b778 100644
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
> @@ -1797,6 +1798,22 @@ static inline int
>  pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
>  		      unsigned int max_vecs, unsigned int flags)
>  {
> +	unsigned int hk_cpus;
> +
> +	hk_cpus = housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);

Add blank line here before the block comment.

> +	/*
> +	 * If we have isolated CPUs for use by real-time tasks, to keep the
> +	 * latency overhead to a minimum, device-specific IRQ vectors are moved
> +	 * to the housekeeping CPUs from the userspace by changing their
> +	 * affinity mask. Limit the vector usage to keep housekeeping CPUs from
> +	 * running out of IRQ vectors.
> +	 */
> +	if (hk_cpus < num_online_cpus()) {
> +		if (hk_cpus < min_vecs)
> +			max_vecs = min_vecs;
> +		else if (hk_cpus < max_vecs)
> +			max_vecs = hk_cpus;
> +	}

It seems like you'd want to do this inside
pci_alloc_irq_vectors_affinity() since that's an exported interface,
and drivers that use it will bypass the limiting you're doing here.

>  	return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags,
>  					      NULL);
>  }
> -- 
> 2.18.2
> 
