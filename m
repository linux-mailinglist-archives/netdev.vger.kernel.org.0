Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570CC27B883
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgI1Xzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgI1Xzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:55:32 -0400
Received: from localhost (52.sub-72-107-123.myvzw.com [72.107.123.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFCA52083B;
        Mon, 28 Sep 2020 21:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601330373;
        bh=0n1xJcdLngQdEbL6h/atc0mGb4YVbGMJlbNqrb3rWc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=TPpxBphvz+2D9Uwv5VqfQh0wF+3Q/7TSzzgny4d7237sTORHdrdkk58bs1BWlGT6v
         zx70R2QzsjjCdGSPdGWmHX1ifdjxKDGigQo4yWcs4p9sTTOTpGuvhuao0t38NmeFAX
         O1xWNs/AwwHQU1IqkaFmk4+tPRE2S87hvWuuckTY=
Date:   Mon, 28 Sep 2020 16:59:31 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>, hch@infradead.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20200928215931.GA2499944@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928183529.471328-5-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[to: Christoph in case he has comments, since I think he wrote this code]

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

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

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
> +	}
> +
>  	if (flags & PCI_IRQ_AFFINITY) {
>  		if (!affd)
>  			affd = &msi_default_affd;
> -- 
> 2.18.2
> 
