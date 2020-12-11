Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E752E2D7334
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437509AbgLKJzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:55:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:29168 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404840AbgLKJzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 04:55:08 -0500
IronPort-SDR: wIo9AojRuqoUiRNs7KOzp09jCzx/ZsrAkiJVs1C/5xoIyNNGyySDPWhK2HyLN4qqaxXH7SICDS
 T4/vLsO2nLOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="192746911"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="192746911"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 01:54:23 -0800
IronPort-SDR: /ufv3vGNGQifQf4WI2wmyr1gYEo9JLcct/eEa85fh974wAfL2ugGQDoLz9o6bLFhFYPLXeOH+B
 J5isAR9V2pBA==
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="333982962"
Received: from dkreft-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.158.206])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 01:54:06 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: Re: [patch 14/30] drm/i915/pmu: Replace open coded kstat_irqs() copy
In-Reply-To: <20201210194043.957046529@linutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20201210192536.118432146@linutronix.de> <20201210194043.957046529@linutronix.de>
Date:   Fri, 11 Dec 2020 11:54:03 +0200
Message-ID: <87wnxo7jno.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020, Thomas Gleixner <tglx@linutronix.de> wrote:
> Driver code has no business with the internals of the irq descriptor.
>
> Aside of that the count is per interrupt line and therefore takes
> interrupts from other devices into account which share the interrupt line
> and are not handled by the graphics driver.
>
> Replace it with a pmu private count which only counts interrupts which
> originate from the graphics card.
>
> To avoid atomics or heuristics of some sort make the counter field
> 'unsigned long'. That limits the count to 4e9 on 32bit which is a lot and
> postprocessing can easily deal with the occasional wraparound.

I'll let Tvrtko and Chris review the substance here, but assuming they
don't object,

Acked-by: Jani Nikula <jani.nikula@intel.com>

for merging via whichever tree makes most sense.

>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> ---
>  drivers/gpu/drm/i915/i915_irq.c |   34 ++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/i915_pmu.c |   18 +-----------------
>  drivers/gpu/drm/i915/i915_pmu.h |    8 ++++++++
>  3 files changed, 43 insertions(+), 17 deletions(-)
>
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -60,6 +60,24 @@
>   * and related files, but that will be described in separate chapters.
>   */
>  
> +/*
> + * Interrupt statistic for PMU. Increments the counter only if the
> + * interrupt originated from the the GPU so interrupts from a device which
> + * shares the interrupt line are not accounted.
> + */
> +static inline void pmu_irq_stats(struct drm_i915_private *priv,
> +				 irqreturn_t res)
> +{
> +	if (unlikely(res != IRQ_HANDLED))
> +		return;
> +
> +	/*
> +	 * A clever compiler translates that into INC. A not so clever one
> +	 * should at least prevent store tearing.
> +	 */
> +	WRITE_ONCE(priv->pmu.irq_count, priv->pmu.irq_count + 1);
> +}
> +
>  typedef bool (*long_pulse_detect_func)(enum hpd_pin pin, u32 val);
>  
>  static const u32 hpd_ilk[HPD_NUM_PINS] = {
> @@ -1599,6 +1617,8 @@ static irqreturn_t valleyview_irq_handle
>  		valleyview_pipestat_irq_handler(dev_priv, pipe_stats);
>  	} while (0);
>  
> +	pmu_irq_stats(dev_priv, ret);
> +
>  	enable_rpm_wakeref_asserts(&dev_priv->runtime_pm);
>  
>  	return ret;
> @@ -1676,6 +1696,8 @@ static irqreturn_t cherryview_irq_handle
>  		valleyview_pipestat_irq_handler(dev_priv, pipe_stats);
>  	} while (0);
>  
> +	pmu_irq_stats(dev_priv, ret);
> +
>  	enable_rpm_wakeref_asserts(&dev_priv->runtime_pm);
>  
>  	return ret;
> @@ -2103,6 +2125,8 @@ static irqreturn_t ilk_irq_handler(int i
>  	if (sde_ier)
>  		raw_reg_write(regs, SDEIER, sde_ier);
>  
> +	pmu_irq_stats(i915, ret);
> +
>  	/* IRQs are synced during runtime_suspend, we don't require a wakeref */
>  	enable_rpm_wakeref_asserts(&i915->runtime_pm);
>  
> @@ -2419,6 +2443,8 @@ static irqreturn_t gen8_irq_handler(int
>  
>  	gen8_master_intr_enable(regs);
>  
> +	pmu_irq_stats(dev_priv, IRQ_HANDLED);
> +
>  	return IRQ_HANDLED;
>  }
>  
> @@ -2514,6 +2540,8 @@ static __always_inline irqreturn_t
>  
>  	gen11_gu_misc_irq_handler(gt, gu_misc_iir);
>  
> +	pmu_irq_stats(i915, IRQ_HANDLED);
> +
>  	return IRQ_HANDLED;
>  }
>  
> @@ -3688,6 +3716,8 @@ static irqreturn_t i8xx_irq_handler(int
>  		i8xx_pipestat_irq_handler(dev_priv, iir, pipe_stats);
>  	} while (0);
>  
> +	pmu_irq_stats(dev_priv, ret);
> +
>  	enable_rpm_wakeref_asserts(&dev_priv->runtime_pm);
>  
>  	return ret;
> @@ -3796,6 +3826,8 @@ static irqreturn_t i915_irq_handler(int
>  		i915_pipestat_irq_handler(dev_priv, iir, pipe_stats);
>  	} while (0);
>  
> +	pmu_irq_stats(dev_priv, ret);
> +
>  	enable_rpm_wakeref_asserts(&dev_priv->runtime_pm);
>  
>  	return ret;
> @@ -3941,6 +3973,8 @@ static irqreturn_t i965_irq_handler(int
>  		i965_pipestat_irq_handler(dev_priv, iir, pipe_stats);
>  	} while (0);
>  
> +	pmu_irq_stats(dev_priv, IRQ_HANDLED);
> +
>  	enable_rpm_wakeref_asserts(&dev_priv->runtime_pm);
>  
>  	return ret;
> --- a/drivers/gpu/drm/i915/i915_pmu.c
> +++ b/drivers/gpu/drm/i915/i915_pmu.c
> @@ -423,22 +423,6 @@ static enum hrtimer_restart i915_sample(
>  	return HRTIMER_RESTART;
>  }
>  
> -static u64 count_interrupts(struct drm_i915_private *i915)
> -{
> -	/* open-coded kstat_irqs() */
> -	struct irq_desc *desc = irq_to_desc(i915->drm.pdev->irq);
> -	u64 sum = 0;
> -	int cpu;
> -
> -	if (!desc || !desc->kstat_irqs)
> -		return 0;
> -
> -	for_each_possible_cpu(cpu)
> -		sum += *per_cpu_ptr(desc->kstat_irqs, cpu);
> -
> -	return sum;
> -}
> -
>  static void i915_pmu_event_destroy(struct perf_event *event)
>  {
>  	struct drm_i915_private *i915 =
> @@ -581,7 +565,7 @@ static u64 __i915_pmu_event_read(struct
>  				   USEC_PER_SEC /* to MHz */);
>  			break;
>  		case I915_PMU_INTERRUPTS:
> -			val = count_interrupts(i915);
> +			val = READ_ONCE(pmu->irq_count);
>  			break;
>  		case I915_PMU_RC6_RESIDENCY:
>  			val = get_rc6(&i915->gt);
> --- a/drivers/gpu/drm/i915/i915_pmu.h
> +++ b/drivers/gpu/drm/i915/i915_pmu.h
> @@ -108,6 +108,14 @@ struct i915_pmu {
>  	 */
>  	ktime_t sleep_last;
>  	/**
> +	 * @irq_count: Number of interrupts
> +	 *
> +	 * Intentionally unsigned long to avoid atomics or heuristics on 32bit.
> +	 * 4e9 interrupts are a lot and postprocessing can really deal with an
> +	 * occasional wraparound easily. It's 32bit after all.
> +	 */
> +	unsigned long irq_count;
> +	/**
>  	 * @events_attr_group: Device events attribute group.
>  	 */
>  	struct attribute_group events_attr_group;
>

-- 
Jani Nikula, Intel Open Source Graphics Center
