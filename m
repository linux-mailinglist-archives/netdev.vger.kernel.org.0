Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4238153F2D4
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 01:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbiFFXzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 19:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiFFXzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 19:55:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DEA62FD
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 16:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654559722; x=1686095722;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=oGEaRpmwAAbwcKnM8W/c07vo7oKHFWnwE4lA6ls7ItU=;
  b=cJkJRNyMBi/K14JQ3GL68XWqM9olIATF3YNgYbHgg3VQ5WL3VFkskDEq
   s3BR50B2LhxdKjlYGO3+ENgdxJIIuvpoVfxonPsR6UQsJBXs1QkWThYHI
   js+/3RtkMgst1304u7Y6cC9VjIe6Zazp5Yh3UMPmt1jU395RAjp6dFygy
   toQbfi98ceHObkY8TPR8gOF0e8poC668H2EgWwPFX2uxwu9EVmS5bha23
   MBzzlnM/GSq+d5qIVSZtNIGV+9DvkjPXtGXE4NOQPus4082E/vk+4KU3E
   5c1cIzHsFdf/7LgWvzNtrU2bHDSIJ7wEeH+5kIDJbqJsUJk+9pPVjScu+
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="337854173"
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; 
   d="scan'208";a="337854173"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 16:55:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; 
   d="scan'208";a="682496664"
Received: from vcostago-mobl3.jf.intel.com (HELO vcostago-mobl3) ([10.24.14.83])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 16:55:21 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net-next] igc: Lift TAPRIO schedule restriction
In-Reply-To: <20220606092747.16730-1-kurt@linutronix.de>
References: <20220606092747.16730-1-kurt@linutronix.de>
Date:   Mon, 06 Jun 2022 16:55:21 -0700
Message-ID: <8735ghny8m.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

Kurt Kanzenbach <kurt@linutronix.de> writes:

> Add support for Qbv schedules where one queue stays open
> in consecutive entries. Currently that's not supported.
>
> Example schedule:
>
> |tc qdisc replace dev ${INTERFACE} handle 100 parent root taprio num_tc 3 \
> |   map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
> |   queues 1@0 1@1 2@2 \
> |   base-time ${BASETIME} \
> |   sched-entry S 0x01 300000 \ # Stream High/Low
> |   sched-entry S 0x06 500000 \ # Management and Best Effort
> |   sched-entry S 0x04 200000 \ # Best Effort
> |   flags 0x02
>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index ae17af44fe02..4758bdbe5df3 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -5813,9 +5813,10 @@ static bool validate_schedule(struct igc_adapter *adapter,
>  		return false;
>  
>  	for (n = 0; n < qopt->num_entries; n++) {
> -		const struct tc_taprio_sched_entry *e;
> +		const struct tc_taprio_sched_entry *e, *prev;
>  		int i;
>  
> +		prev = n ? &qopt->entries[n - 1] : NULL;
>  		e = &qopt->entries[n];
>  
>  		/* i225 only supports "global" frame preemption
> @@ -5828,7 +5829,12 @@ static bool validate_schedule(struct igc_adapter *adapter,
>  			if (e->gate_mask & BIT(i))
>  				queue_uses[i]++;
>  
> -			if (queue_uses[i] > 1)
> +			/* There are limitations: A single queue cannot be
> +			 * opened and closed multiple times per cycle unless the
> +			 * gate stays open. Check for it.
> +			 */
> +			if (queue_uses[i] > 1 &&
> +			    !(prev->gate_mask & BIT(i)))

Perhaps I am missing something, I didn't try to run, but not checking if
'prev' can be NULL, could lead to crashes for some schedules, no?

What I have in mind is a schedule that queue 0 is mentioned multiple
times, for example:

 |   sched-entry S 0x01 300000 \ # Stream High/Low
 |   sched-entry S 0x03 500000 \ # Management and Best Effort
 |   sched-entry S 0x05 200000 \ # Best Effort

Anyway, looks much cleaner than what I had in mind when I wrote that
fixme.


Cheers,
-- 
Vinicius
