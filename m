Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885072904FA
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407445AbgJPMVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405384AbgJPMVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:21:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8BBC061755;
        Fri, 16 Oct 2020 05:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZUmWjNg65V6AiFrCgaLFBLQXLIVV8qim1PDjDYaGvo4=; b=KfVXg1CGrkJBMgna6XMAK92lmy
        rZ2nMvNRNI6MsIvb7H6Ot9k6iXWvJDUsz4Nifz9deCLlH8Fc6JWNPrBEa69q20Xn8cg1w1GiS7ZD/
        SlOv8NPpdHDXcyNfo1C6pWTC+kKcZHRwprCMys5LCGK87ukyg8NEtiodChPxwTz9t1uqNL5akXq52
        OBBf6HNe1bua1XTzhReL2j3vae+lhlaZzjElMEmlD+X54wI1hd3LKbrz06HUpcZ8/iH75eyfKmOIh
        D84WSri5aJOa64SHb+vddNKk82n2Hp41rbRUdJOHsLsxQfnmR2quEjFJXw/ZMyoCbIuUL7BdNOER6
        9Edddoxw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kTOj4-0007HQ-FF; Fri, 16 Oct 2020 12:20:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DA3F13050F0;
        Fri, 16 Oct 2020 14:20:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C6543203EB17E; Fri, 16 Oct 2020 14:20:46 +0200 (CEST)
Date:   Fri, 16 Oct 2020 14:20:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20201016122046.GP2611@hirez.programming.kicks-ass.net>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928183529.471328-5-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 02:35:29PM -0400, Nitesh Narayan Lal wrote:
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
>  drivers/pci/msi.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 30ae4ffda5c1..8c156867803c 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -23,6 +23,7 @@
>  #include <linux/slab.h>
>  #include <linux/irqdomain.h>
>  #include <linux/of_irq.h>
> +#include <linux/sched/isolation.h>
>  
>  #include "pci.h"
>  
> @@ -1191,8 +1192,25 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
>  				   struct irq_affinity *affd)
>  {
>  	struct irq_affinity msi_default_affd = {0};
> +	unsigned int hk_cpus;
>  	int nvecs = -ENOSPC;
>  
> +	hk_cpus = housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
> +
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

is that:

		max_vecs = clamp(hk_cpus, min_vecs, max_vecs);

Also, do we really need to have that conditional on hk_cpus <
num_online_cpus()? That is, why can't we do this unconditionally?

And what are the (desired) semantics vs hotplug? Using a cpumask without
excluding hotplug is racy.

> +	}
> +
>  	if (flags & PCI_IRQ_AFFINITY) {
>  		if (!affd)
>  			affd = &msi_default_affd;
> -- 
> 2.18.2
> 
