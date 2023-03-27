Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A016CA16A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbjC0K3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbjC0K2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:28:54 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335836A7D;
        Mon, 27 Mar 2023 03:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679912907; x=1711448907;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ezCh01c1kVevA4lZGyADwIi6B7zornrw82CM0FaX2dM=;
  b=DlwCmmrMibCRSkstjsfjnNpa6Cwin1gRCftBUSiK7cTHNtJ+W33SXsgN
   7COeSO8UoNvsRBnmvBS9uXeEeGzaPWQ9lJzDai64sNa5sku7+OVJMtGcr
   XTxR1AMD8bYu88xS+2Iw8ziEEZtFrOvsYs1fJ/NXULzgCOFCAEsKn6lXE
   FSYgK9JsOLOCyni8qdceRCmx/AOlL/tZnfCH+naiot0KEb1ng8NAeASUK
   0XVUAnci3O4GfMt8pI1Fo0Nepqya6bYDqyvEgKtg8ml482qTxc5Ct9F4F
   P+hzHpxJhejC0h+NSkybEnvO1kNunwxI9gk3h3omnRk4D0g7ZNcdLISp0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="319887069"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="319887069"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 03:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="747949267"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="747949267"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 27 Mar 2023 03:28:15 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pgk5E-009AxP-1y;
        Mon, 27 Mar 2023 13:28:12 +0300
Date:   Mon, 27 Mar 2023 13:28:12 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 2/8] sched/topology: introduce sched_numa_find_next_cpu()
Message-ID: <ZCFvvHZXT/dqjOOb@smile.fi.intel.com>
References: <20230325185514.425745-1-yury.norov@gmail.com>
 <20230325185514.425745-3-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325185514.425745-3-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 11:55:08AM -0700, Yury Norov wrote:
> The function searches for the next CPU in a given cpumask according to
> NUMA topology, so that it traverses cpus per-hop.
> 
> If the CPU is the last cpu in a given hop, sched_numa_find_next_cpu()
> switches to the next hop, and picks the first CPU from there, excluding
> those already traversed.

...

> +/*

Hmm... Is it deliberately not a kernel doc?

> + * sched_numa_find_next_cpu() - given the NUMA topology, find the next cpu
> + * cpumask: cpumask to find a cpu from
> + * cpu: current cpu
> + * node: local node
> + * hop: (in/out) indicates distance order of current CPU to a local node
> + *
> + * The function searches for next cpu at a given NUMA distance, indicated
> + * by hop, and if nothing found, tries to find CPUs at a greater distance,
> + * starting from the beginning.
> + *
> + * returns: cpu, or >= nr_cpu_ids when nothing found.
> + */

-- 
With Best Regards,
Andy Shevchenko


