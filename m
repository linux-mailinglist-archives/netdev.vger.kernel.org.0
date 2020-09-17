Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9133726E37F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgIQS0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:26:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:26062 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbgIQSZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 14:25:48 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 14:25:43 EDT
IronPort-SDR: OAQrGXnofE2ix3QRRVleUwYmAlE6vjAZIGibBdpXLt/flMsxHVckRqBtyd0juqiepdb1BVwuaO
 fZEpp5aOdY6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="221321883"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="221321883"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 11:18:10 -0700
IronPort-SDR: kkf8DHurafAM1VSYqAAV2BJk2FzaMJxjF7+wDR/y4P+41vjGqfRSxJQo2xlOcYnKH0JPjLLL3m
 GnyV5m2HTutw==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="483850364"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.251.16.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 11:18:10 -0700
Date:   Thu, 17 Sep 2020 11:18:07 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <frederic@kernel.org>,
        <mtosatti@redhat.com>, <sassmann@redhat.com>,
        <jeffrey.t.kirsher@intel.com>, <jacob.e.keller@intel.com>,
        <jlelli@redhat.com>, <hch@infradead.org>, <bhelgaas@google.com>,
        <mike.marciniszyn@intel.com>, <dennis.dalessandro@intel.com>,
        <thomas.lendacky@amd.com>, <jerinj@marvell.com>,
        <mathias.nyman@intel.com>, <jiri@nvidia.com>
Subject: Re: [RFC][Patch v1 1/3] sched/isolation: API to get num of
 hosekeeping CPUs
Message-ID: <20200917111807.00002eac@intel.com>
In-Reply-To: <20200909150818.313699-2-nitesh@redhat.com>
References: <20200909150818.313699-1-nitesh@redhat.com>
        <20200909150818.313699-2-nitesh@redhat.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh Narayan Lal wrote:

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
> 
> If there are no isolated CPUs specified then the API returns the number
> of all online CPUs.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  include/linux/sched/isolation.h |  7 +++++++
>  kernel/sched/isolation.c        | 23 +++++++++++++++++++++++
>  2 files changed, 30 insertions(+)

I'm not a scheduler expert, but a couple comments follow.

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

use correct kdoc style, and you get free documentation from your source
(you're so close!)

should be (note the first line and the function title line change to
remove parens:
/**
 * num_housekeeping_cpus - Read the number of housekeeping CPUs.
 *
 * This function returns the number of available housekeeping CPUs
 * based on __num_housekeeping_cpus which is of type atomic_t
 * and is initialized at the time of the housekeeping setup.
 */

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

you need to crash the kernel because of this? maybe a WARN_ON? How did
the global even get set to the bad value? It's going to blame the poor
caller for this in the trace, but the caller likely had nothing to do
with setting the value incorrectly!

> +		return cpus;
> +	}
> +	return num_online_cpus();
> +}
> +EXPORT_SYMBOL_GPL(num_housekeeping_cpus);

