Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C36E69988E
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjBPPRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPPRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:17:20 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B623A850;
        Thu, 16 Feb 2023 07:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676560639; x=1708096639;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=czBrdtmfqsO6ogQKrhfZw9fg6fpcZJLQg9g+S8v9inc=;
  b=VPMUKajcs1hq06daAccUDr1s9JLbwZKchGi88n4c4/BnkiGpRlNbF72y
   /MVkCsXodaEe5j/HCCddn5gc6E0uIcvLG47Ef3U5K+spz+7pnYcAVWOxH
   65CfrpV6MdLCj4Sq8XVgaYjmIRE04U9X2kALWDJo7f7mLVxzaG93RoWje
   NY74SyYy/dLSo/0J2dAACPUPzhXyUh87F/z4mnpkqKBPZPuwS4HEoxjT5
   gXM01myQ4LJpvHiO0YhIub+wfWk/ziy3u6/zoX/ERHLrrIwjHAr4rYPz5
   OyLjmT3iA6MA+tI8nfFj76KrfREmUM+2dqQKxJefNhEXi9qU6ESDiusyY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="330377902"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="330377902"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:14:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="700523052"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="700523052"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP; 16 Feb 2023 07:14:36 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pSfxx-007poA-16;
        Thu, 16 Feb 2023 17:14:33 +0200
Date:   Thu, 16 Feb 2023 17:14:32 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Pawel Chmielewski <pawel.chmielewski@intel.com>
Cc:     Jonathan.Cameron@huawei.com, baohua@kernel.org, bristot@redhat.com,
        bsegall@google.com, davem@davemloft.net, dietmar.eggemann@arm.com,
        gal@nvidia.com, gregkh@linuxfoundation.org, hca@linux.ibm.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        jgg@nvidia.com, juri.lelli@redhat.com, kuba@kernel.org,
        leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@redhat.com,
        netdev@vger.kernel.org, peter@n8pjl.ca, peterz@infradead.org,
        rostedt@goodmis.org, saeedm@nvidia.com, tariqt@nvidia.com,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        ttoukan.linux@gmail.com, vincent.guittot@linaro.org,
        vschneid@redhat.com, yury.norov@gmail.com
Subject: Re: [PATCH v2 1/1] ice: Change assigning method of the CPU affinity
 masks
Message-ID: <Y+5IWLpC1uTaa4Ks@smile.fi.intel.com>
References: <20230208153905.109912-1-pawel.chmielewski@intel.com>
 <20230216145455.661709-1-pawel.chmielewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216145455.661709-1-pawel.chmielewski@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 03:54:55PM +0100, Pawel Chmielewski wrote:
> With the introduction of sched_numa_hop_mask() and for_each_numa_hop_mask(),
> the affinity masks for queue vectors can be conveniently set by preferring the
> CPUs that are closest to the NUMA node of the parent PCI device.

...

> +	v_idx = 0;

> +

Redundant blank line.

> +	for_each_numa_hop_mask(aff_mask, numa_node) {
> +		for_each_cpu_andnot(cpu, aff_mask, last_aff_mask) {
> +			if (v_idx >= vsi->num_q_vectors)

> +				goto out;

Useless. You can return 0; here.

> +			if (cpu_online(cpu)) {
> +				cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
> +				v_idx++;
> +			}
> +		}
> +
> +		last_aff_mask = aff_mask;
> +	}
> +
> +out:
>  	return 0;

-- 
With Best Regards,
Andy Shevchenko


