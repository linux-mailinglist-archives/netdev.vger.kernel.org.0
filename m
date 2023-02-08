Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C3068F3DD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjBHQ7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjBHQ7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:59:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728F31C317;
        Wed,  8 Feb 2023 08:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675875540; x=1707411540;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c53B/yNcCsESxMoBF6QG2HTSGIloM209wckUOgRNIKg=;
  b=Uxy6PXqXvf9wNzBS5Tt83JEPunuFVEuN02tG+mDy+AzSwiuKx4BiCzX3
   hq/pc5E87h5+LZs2wCuMH88TgPLfUk9aNFnXRzUluJ+GqaerdJAnuK8NM
   wIgYmmBjh+CevLW2CwcnhemcOu6EiPqy3B5YR6/ebq68ZEqaLbw3UvrBP
   sZ8oFxSIaH6vcobdbkVcHYv1pjRozyqaToD700TK/OrlG36j2KJEAhjmm
   nJdMa4NrIWkOIfJnss8KR+ei5naS7l5tc0g0/v4DgKclmyMgy63h34GeR
   LKalgXZ6tQivXY6kee02eMUHb99grmPKzNVfX9TcQ0f+8HIEbhW/SsLi0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="317861121"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="317861121"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 08:58:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="841256000"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="841256000"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 08 Feb 2023 08:58:51 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pPnmR-004DaH-1g;
        Wed, 08 Feb 2023 18:58:47 +0200
Date:   Wed, 8 Feb 2023 18:58:47 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Jonathan.Cameron@huawei.com, baohua@kernel.org, bristot@redhat.com,
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
        vschneid@redhat.com
Subject: Re: [PATCH 1/1] ice: Change assigning method of the CPU affinity
 masks
Message-ID: <Y+PUx8M6mrsMilZg@smile.fi.intel.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <20230208153905.109912-1-pawel.chmielewski@intel.com>
 <Y+PQOCHCh78aAcAm@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+PQOCHCh78aAcAm@yury-laptop>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 08:39:20AM -0800, Yury Norov wrote:
> On Wed, Feb 08, 2023 at 04:39:05PM +0100, Pawel Chmielewski wrote:

...

> > +	v_idx = 0;
> > +	for_each_numa_hop_mask(aff_mask, numa_node) {
> > +		for_each_cpu_andnot(cpu, aff_mask, last_aff_mask)
> > +			if (v_idx < vsi->num_q_vectors) {
> > +				if (cpu_online(cpu))
> > +					cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
> > +				v_idx++;
> > +			}

>                         else
>                                 goto out;

In this case the inverted conditional makes more sense:

			if (v_idx >= vsi->num_q_vectors)
				goto out;

			if (cpu_online(cpu))
				cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
			v_idx++;

(indentation level will be decreased).

> > +		last_aff_mask = aff_mask;
> > +	}
> > +
>         out:
> 
> >  	return 0;

-- 
With Best Regards,
Andy Shevchenko


