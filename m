Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEC83E328B
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 03:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhHGBPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 21:15:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:56740 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhHGBPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 21:15:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="214493814"
X-IronPort-AV: E=Sophos;i="5.84,301,1620716400"; 
   d="scan'208";a="214493814"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 18:15:31 -0700
X-IronPort-AV: E=Sophos;i="5.84,301,1620716400"; 
   d="scan'208";a="669719406"
Received: from yuhshiua-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.8.244])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 18:15:30 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: Re: [net-next, v5, 02/11] ptp: support ptp physical/virtual clocks
 conversion
In-Reply-To: <20210630081202.4423-3-yangbo.lu@nxp.com>
References: <20210630081202.4423-1-yangbo.lu@nxp.com>
 <20210630081202.4423-3-yangbo.lu@nxp.com>
Date:   Fri, 06 Aug 2021 18:15:29 -0700
Message-ID: <87r1f6kqby.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yangbo Lu <yangbo.lu@nxp.com> writes:

> Support ptp physical/virtual clocks conversion via sysfs.
> There will be a new attribute n_vclocks under ptp physical
> clock sysfs.
>
> - In default, the value is 0 meaning only ptp physical clock
>   is in use.
> - Setting the value can create corresponding number of ptp
>   virtual clocks to use. But current physical clock is guaranteed
>   to stay free running.
> - Setting the value back to 0 can delete virtual clocks and back
>   use physical clock again.
>
> Another new attribute max_vclocks control the maximum number of
> ptp vclocks.
>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
> Changes for v2:
> 	- Split from v1 patch #2.
> 	- Converted to num_vclocks for creating virtual clocks.
> 	- Guranteed physical clock free running when using virtual
> 	  clocks.
> 	- Fixed build warning.
> 	- Updated copyright.
> Changes for v3:
> 	- Protected concurrency of ptp->num_vclocks accessing.
> Changes for v4:
> 	- Rephrased description in doc.
> 	- Used unsigned int for vclocks number, and max_vclocks
> 	  for limitiation.
> 	- Fixed mutex locking.
> 	- Other minor fixes.
> Changes for v5:
> 	- Fixed checkpatch.
> 	- Checked pointer parent->class->name.
> ---
>  Documentation/ABI/testing/sysfs-ptp |  20 ++++
>  drivers/ptp/ptp_clock.c             |  26 ++++++
>  drivers/ptp/ptp_private.h           |  21 +++++
>  drivers/ptp/ptp_sysfs.c             | 138 ++++++++++++++++++++++++++++
>  4 files changed, 205 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
> index 2363ad810ddb..d378f57c1b73 100644
> --- a/Documentation/ABI/testing/sysfs-ptp
> +++ b/Documentation/ABI/testing/sysfs-ptp
> @@ -33,6 +33,13 @@ Description:
>  		frequency adjustment value (a positive integer) in
>  		parts per billion.
>  
> +What:		/sys/class/ptp/ptpN/max_vclocks
> +Date:		May 2021
> +Contact:	Yangbo Lu <yangbo.lu@nxp.com>
> +Description:
> +		This file contains the maximum number of ptp vclocks.
> +		Write integer to re-configure it.
> +
>  What:		/sys/class/ptp/ptpN/n_alarms
>  Date:		September 2010
>  Contact:	Richard Cochran <richardcochran@gmail.com>
> @@ -61,6 +68,19 @@ Description:
>  		This file contains the number of programmable pins
>  		offered by the PTP hardware clock.
>  
> +What:		/sys/class/ptp/ptpN/n_vclocks
> +Date:		May 2021
> +Contact:	Yangbo Lu <yangbo.lu@nxp.com>
> +Description:
> +		This file contains the number of virtual PTP clocks in
> +		use.  By default, the value is 0 meaning that only the
> +		physical clock is in use.  Setting the value creates
> +		the corresponding number of virtual clocks and causes
> +		the physical clock to become free running.  Setting the
> +		value back to 0 deletes the virtual clocks and
> +		switches the physical clock back to normal, adjustable
> +		operation.
> +
>  What:		/sys/class/ptp/ptpN/pins
>  Date:		March 2014
>  Contact:	Richard Cochran <richardcochran@gmail.com>
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index a23a37a4d5dc..7334f478dde7 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -76,6 +76,11 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
>  {
>  	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
>  
> +	if (ptp_vclock_in_use(ptp)) {
> +		pr_err("ptp: virtual clock in use\n");
> +		return -EBUSY;
> +	}
> +
>  	return  ptp->info->settime64(ptp->info, tp);
>  }
>  
> @@ -97,6 +102,11 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
>  	struct ptp_clock_info *ops;
>  	int err = -EOPNOTSUPP;
>  
> +	if (ptp_vclock_in_use(ptp)) {
> +		pr_err("ptp: virtual clock in use\n");
> +		return -EBUSY;
> +	}
> +
>  	ops = ptp->info;
>  
>  	if (tx->modes & ADJ_SETOFFSET) {
> @@ -161,6 +171,7 @@ static void ptp_clock_release(struct device *dev)
>  	ptp_cleanup_pin_groups(ptp);
>  	mutex_destroy(&ptp->tsevq_mux);
>  	mutex_destroy(&ptp->pincfg_mux);
> +	mutex_destroy(&ptp->n_vclocks_mux);
>  	ida_simple_remove(&ptp_clocks_map, ptp->index);
>  	kfree(ptp);
>  }
> @@ -208,6 +219,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  	spin_lock_init(&ptp->tsevq.lock);
>  	mutex_init(&ptp->tsevq_mux);
>  	mutex_init(&ptp->pincfg_mux);
> +	mutex_init(&ptp->n_vclocks_mux);
>  	init_waitqueue_head(&ptp->tsev_wq);
>  
>  	if (ptp->info->do_aux_work) {
> @@ -221,6 +233,14 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  		ptp->pps_source->lookup_cookie = ptp;
>  	}
>  
> +	/* PTP virtual clock is being registered under physical clock */
> +	if (parent->class && parent->class->name &&
> +	    strcmp(parent->class->name, "ptp") == 0)
> +		ptp->is_virtual_clock = true;
> +
> +	if (!ptp->is_virtual_clock)
> +		ptp->max_vclocks = PTP_DEFAULT_MAX_VCLOCKS;
> +
>  	err = ptp_populate_pin_groups(ptp);
>  	if (err)
>  		goto no_pin_groups;
> @@ -270,6 +290,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  kworker_err:
>  	mutex_destroy(&ptp->tsevq_mux);
>  	mutex_destroy(&ptp->pincfg_mux);
> +	mutex_destroy(&ptp->n_vclocks_mux);
>  	ida_simple_remove(&ptp_clocks_map, index);
>  no_slot:
>  	kfree(ptp);
> @@ -280,6 +301,11 @@ EXPORT_SYMBOL(ptp_clock_register);
>  
>  int ptp_clock_unregister(struct ptp_clock *ptp)
>  {
> +	if (ptp_vclock_in_use(ptp)) {
> +		pr_err("ptp: virtual clock in use\n");
> +		return -EBUSY;
> +	}
> +

None of the drivers (that I looked) expect ptp_clock_unregister() to
return an error.

So, what should we do?
 1. Fix all the drivers to return an error on module unloading (that's
 usually the path ptp_clock_unregister() is called)?
 2. Remove all the PTP virtual clocks when the physical clock is
 unregistered?

(And as always, I could be missing something obvious here)

Sorry for being (extremely) late about this.


Cheers,
-- 
Vinicius
