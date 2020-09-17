Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA41826E657
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgIQULl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgIQULl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:11:41 -0400
Received: from localhost (52.sub-72-107-123.myvzw.com [72.107.123.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46EC6206B7;
        Thu, 17 Sep 2020 20:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600373484;
        bh=U/TSXspbUHQHp2IjHc8xcgoC/95vhBzwyLQ+rvvEyUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=WAuVWb5n0Y0idAVKi6/3xBq7O6nIQjGkrHzP/QC/mAnVhT+DkBdtjV4wkcmrdPa7E
         VzLP3NvEwLSXZWkth1Mo3c7xZx5knRzPXZL/Zrt4tdjUmjX0tGwUijVcts7O5e67uz
         Ew0dxDpkOIliI5OhcTUKMBG2ld9OG3Q987ml6HZg=
Date:   Thu, 17 Sep 2020 15:11:23 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [RFC][Patch v1 1/3] sched/isolation: API to get num of
 hosekeeping CPUs
Message-ID: <20200917201123.GA1726926@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909150818.313699-2-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Ingo, Peter, Juri, Vincent (scheduler maintainers)]

s/hosekeeping/housekeeping/ (in subject)

On Wed, Sep 09, 2020 at 11:08:16AM -0400, Nitesh Narayan Lal wrote:
> Introduce a new API num_housekeeping_cpus(), that can be used to retrieve
> the number of housekeeping CPUs by reading an atomic variable
> __num_housekeeping_cpus. This variable is set from housekeeping_setup().
> 
> This API is introduced for the purpose of drivers that were previously
> relying only on num_online_cpus() to determine the number of MSIX vectors
> to create. In an RT environment with large isolated but a fewer
> housekeeping CPUs this was leading to a situation where an attempt to
> move all of the vectors corresponding to isolated CPUs to housekeeping
> CPUs was failing due to per CPU vector limit.

Totally kibitzing here, but AFAICT the concepts of "isolated CPU" and
"housekeeping CPU" are not currently exposed to drivers, and it's not
completely clear to me that they should be.

We have carefully constructed notions of possible, present, online,
active CPUs, and it seems like whatever we do here should be
somehow integrated with those.

> If there are no isolated CPUs specified then the API returns the number
> of all online CPUs.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  include/linux/sched/isolation.h |  7 +++++++
>  kernel/sched/isolation.c        | 23 +++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index cc9f393e2a70..94c25d956d8a 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -25,6 +25,7 @@ extern bool housekeeping_enabled(enum hk_flags flags);
>  extern void housekeeping_affine(struct task_struct *t, enum hk_flags flags);
>  extern bool housekeeping_test_cpu(int cpu, enum hk_flags flags);
>  extern void __init housekeeping_init(void);
> +extern unsigned int num_housekeeping_cpus(void);
>  
>  #else
>  
> @@ -46,6 +47,12 @@ static inline bool housekeeping_enabled(enum hk_flags flags)
>  static inline void housekeeping_affine(struct task_struct *t,
>  				       enum hk_flags flags) { }
>  static inline void housekeeping_init(void) { }
> +
> +static unsigned int num_housekeeping_cpus(void)
> +{
> +	return num_online_cpus();
> +}
> +
>  #endif /* CONFIG_CPU_ISOLATION */
>  
>  static inline bool housekeeping_cpu(int cpu, enum hk_flags flags)
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 5a6ea03f9882..7024298390b7 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -13,6 +13,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>  EXPORT_SYMBOL_GPL(housekeeping_overridden);
>  static cpumask_var_t housekeeping_mask;
>  static unsigned int housekeeping_flags;
> +static atomic_t __num_housekeeping_cpus __read_mostly;
>  
>  bool housekeeping_enabled(enum hk_flags flags)
>  {
> @@ -20,6 +21,27 @@ bool housekeeping_enabled(enum hk_flags flags)
>  }
>  EXPORT_SYMBOL_GPL(housekeeping_enabled);
>  
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
>  	free_bootmem_cpumask_var(non_housekeeping_mask);
>  
>  	return 1;
> -- 
> 2.27.0
> 
