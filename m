Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1751C2736B7
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgIUXks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgIUXks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 19:40:48 -0400
Received: from localhost (lfbn-ncy-1-588-162.w81-51.abo.wanadoo.fr [81.51.203.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BF4622574;
        Mon, 21 Sep 2020 23:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600731647;
        bh=hhXBMZeIvO1UMKlXhXoAyN9wTX+oKmSJfODYTDEXzFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T1y5Wa1aDfJxCvE3Y05b7WTzoZP9YqQ2V5sRHe+m2BTyoiFl3TDR/vOKJuG1NTJ+I
         UHjmrCMGcO7vy12OlpkAefdM/4v0iFFq3qRNRDPXvFG+O05CWl6Rme+GMLC8XW2LUS
         H95gXLDY8MeP4Q9XXHSFQ1UiQp1oM2ZK5PnuVPws=
Date:   Tue, 22 Sep 2020 01:40:45 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, mtosatti@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
Subject: Re: [RFC][Patch v1 1/3] sched/isolation: API to get num of
 hosekeeping CPUs
Message-ID: <20200921234044.GA31047@lenoir>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-2-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909150818.313699-2-nitesh@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 11:08:16AM -0400, Nitesh Narayan Lal wrote:
> +/*
> + * num_housekeeping_cpus() - Read the number of housekeeping CPUs.
> + *
> + * This function returns the number of available housekeeping CPUs
> + * based on __num_housekeeping_cpus which is of type atomic_t
> + * and is initialized at the time of the housekeeping setup.
> + */
> +unsigned int num_housekeeping_cpus(void)
> +{
> +	unsigned int cpus;
> +
> +	if (static_branch_unlikely(&housekeeping_overridden)) {
> +		cpus = atomic_read(&__num_housekeeping_cpus);
> +		/* We should always have at least one housekeeping CPU */
> +		BUG_ON(!cpus);
> +		return cpus;
> +	}
> +	return num_online_cpus();
> +}
> +EXPORT_SYMBOL_GPL(num_housekeeping_cpus);
> +
>  int housekeeping_any_cpu(enum hk_flags flags)
>  {
>  	int cpu;
> @@ -131,6 +153,7 @@ static int __init housekeeping_setup(char *str, enum hk_flags flags)
>  
>  	housekeeping_flags |= flags;
>  
> +	atomic_set(&__num_housekeeping_cpus, cpumask_weight(housekeeping_mask));

So the problem here is that it takes the whole cpumask weight but you're only
interested in the housekeepers who take the managed irq duties I guess
(HK_FLAG_MANAGED_IRQ ?).

>  	free_bootmem_cpumask_var(non_housekeeping_mask);
>  
>  	return 1;
> -- 
> 2.27.0
> 
