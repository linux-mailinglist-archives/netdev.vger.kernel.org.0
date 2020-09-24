Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D633277AB1
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIXUsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgIXUsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 16:48:01 -0400
Received: from localhost (52.sub-72-107-123.myvzw.com [72.107.123.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DF20221EB;
        Thu, 24 Sep 2020 20:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600980480;
        bh=TDET0KJhptmVV4U8HQItYgWqOFf8omZjfxwMJ+5agMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=dWf495VGJ3RD0bVS+U8XzYa7chztO2nbrjbuq6mP8pxvrgwyBakjREbEpiAH8iA/j
         q8RdZOWrBC9/rf8FUkAq2qFpo/Cj9bw0BIOgxEnOBR/3sb7m/9vewM6AHeKrcS4kr2
         G6VvZMaqsuCzkjvm+htdbZuD0cV6fRN7kpswGxSQ=
Date:   Thu, 24 Sep 2020 15:47:59 -0500
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
Subject: Re: [PATCH v2 1/4] sched/isolation: API to get housekeeping online
 CPUs
Message-ID: <20200924204759.GA2342589@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923181126.223766-2-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:11:23PM -0400, Nitesh Narayan Lal wrote:
> Introduce a new API hk_num_online_cpus(), that can be used to
> retrieve the number of online housekeeping CPUs that are meant to handle
> managed IRQ jobs.
> 
> This API is introduced for the drivers that were previously relying only
> on num_online_cpus() to determine the number of MSIX vectors to create.
> In an RT environment with large isolated but fewer housekeeping CPUs this
> was leading to a situation where an attempt to move all of the vectors
> corresponding to isolated CPUs to housekeeping CPUs were failing due to
> per CPU vector limit.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  include/linux/sched/isolation.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index cc9f393e2a70..2e96b626e02e 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -57,4 +57,17 @@ static inline bool housekeeping_cpu(int cpu, enum hk_flags flags)
>  	return true;
>  }
>  
> +static inline unsigned int hk_num_online_cpus(void)
> +{
> +#ifdef CONFIG_CPU_ISOLATION
> +	const struct cpumask *hk_mask;
> +
> +	if (static_branch_unlikely(&housekeeping_overridden)) {
> +		hk_mask = housekeeping_cpumask(HK_FLAG_MANAGED_IRQ);
> +		return cpumask_weight(hk_mask);
> +	}
> +#endif
> +	return cpumask_weight(cpu_online_mask);

Just curious: why is this not

  #ifdef CONFIG_CPU_ISOLATION
  ...
  #endif
    return num_online_cpus();

> +}
> +
>  #endif /* _LINUX_SCHED_ISOLATION_H */
> -- 
> 2.18.2
> 
