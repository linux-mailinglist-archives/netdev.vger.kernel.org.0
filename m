Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1109540549
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346244AbiFGRYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346273AbiFGRXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:23:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696481091A1
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654622498; x=1686158498;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=LiSe1LDqlMypTndNF75ktuzk1D7Qf2I7Oy09Hpeq6p0=;
  b=JoZB7RQ4KUNLD++8yHU0JKjVGmFI6i90ctcU8jaVF6MUUww1Bma9ac4u
   WUu9o0dsGuNqO8U1eW4pgTX7oeBCickLpP0V36qY4bt1/W8EvSF6WJVpI
   YWWN8FFzAl738kGGpJprtWyulPv8kSfCiRKX5O/jR8Rjixum7A13b4eAm
   7iMMW0UcXM0remE9AF45Hj+vI2oBBlkpk8Y2H2APaSM/ryFm6NAiDh3G0
   I2gH7yTgwm6W5GZuPwfAOYhm6CwAEirdTeYRV3ij2R+Us7QRPoIXU6vVc
   poErAYim5LRXp1xPOAdHd0u7PIvt+/LUA8Y1UL0Asm0hRpx1AZfu+YvK6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="259627480"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="259627480"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 10:14:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="826449311"
Received: from jurbank-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.41.17])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 10:14:52 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] igc: Lift TAPRIO schedule restriction
In-Reply-To: <87k09tar5e.fsf@kurt>
References: <20220606092747.16730-1-kurt@linutronix.de>
 <8735ghny8m.fsf@intel.com> <87k09tar5e.fsf@kurt>
Date:   Tue, 07 Jun 2022 10:14:52 -0700
Message-ID: <87wndsmm43.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

Kurt Kanzenbach <kurt@linutronix.de> writes:

> Hi Vinicius,
>
> On Mon Jun 06 2022, Vinicius Costa Gomes wrote:
>> Hi Kurt,
>>
>> Kurt Kanzenbach <kurt@linutronix.de> writes:
>>
>>> Add support for Qbv schedules where one queue stays open
>>> in consecutive entries. Currently that's not supported.
>>>
>>> Example schedule:
>>>
>>> |tc qdisc replace dev ${INTERFACE} handle 100 parent root taprio num_tc 3 \
>>> |   map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>>> |   queues 1@0 1@1 2@2 \
>>> |   base-time ${BASETIME} \
>>> |   sched-entry S 0x01 300000 \ # Stream High/Low
>>> |   sched-entry S 0x06 500000 \ # Management and Best Effort
>>> |   sched-entry S 0x04 200000 \ # Best Effort
>>> |   flags 0x02
>>>
>>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>>> ---
>>>  drivers/net/ethernet/intel/igc/igc_main.c | 23 +++++++++++++++++------
>>>  1 file changed, 17 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
>>> index ae17af44fe02..4758bdbe5df3 100644
>>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>>> @@ -5813,9 +5813,10 @@ static bool validate_schedule(struct igc_adapter *adapter,
>>>  		return false;
>>>  
>>>  	for (n = 0; n < qopt->num_entries; n++) {
>>> -		const struct tc_taprio_sched_entry *e;
>>> +		const struct tc_taprio_sched_entry *e, *prev;
>>>  		int i;
>>>  
>>> +		prev = n ? &qopt->entries[n - 1] : NULL;
>>>  		e = &qopt->entries[n];
>>>  
>>>  		/* i225 only supports "global" frame preemption
>>> @@ -5828,7 +5829,12 @@ static bool validate_schedule(struct igc_adapter *adapter,
>>>  			if (e->gate_mask & BIT(i))
>>>  				queue_uses[i]++;
>>>  
>>> -			if (queue_uses[i] > 1)
>>> +			/* There are limitations: A single queue cannot be
>>> +			 * opened and closed multiple times per cycle unless the
>>> +			 * gate stays open. Check for it.
>>> +			 */
>>> +			if (queue_uses[i] > 1 &&
>>> +			    !(prev->gate_mask & BIT(i)))
>>
>> Perhaps I am missing something, I didn't try to run, but not checking if
>> 'prev' can be NULL, could lead to crashes for some schedules, no?
>
> My thinking was that `prev` can never be NULL, as `queue_uses[i] > 1` is
> checked first. This condition can only be true if there are at least two
> entries.
>

Oh, yeah! That's true. I have missed that.

>>
>> What I have in mind is a schedule that queue 0 is mentioned multiple
>> times, for example:
>>
>>  |   sched-entry S 0x01 300000 \ # Stream High/Low
>>  |   sched-entry S 0x03 500000 \ # Management and Best Effort
>>  |   sched-entry S 0x05 200000 \ # Best Effort
>>
>
> So, this schedule works with the proposed patch. Queue 0 is opened in
> all three entries. My debug code shows:
>
> |tc-6145    [010] .......   616.190589: igc_setup_tc: Qbv configuration:
> |tc-6145    [010] .......   616.190592: igc_setup_tc: Queue 0 -- start_time=0 [ns]
> |tc-6145    [010] .......   616.190592: igc_setup_tc: Queue 0 -- end_time=1000000 [ns]
> |tc-6145    [010] .......   616.190593: igc_setup_tc: Queue 1 -- start_time=300000 [ns]
> |tc-6145    [010] .......   616.190593: igc_setup_tc: Queue 1 -- end_time=800000 [ns]
> |tc-6145    [010] .......   616.190593: igc_setup_tc: Queue 2 -- start_time=800000 [ns]
> |tc-6145    [010] .......   616.190594: igc_setup_tc: Queue 2 -- end_time=1000000 [ns]
> |tc-6145    [010] .......   616.190594: igc_setup_tc: Queue 3 -- start_time=800000 [ns]
> |tc-6145    [010] .......   616.190594: igc_setup_tc: Queue 3 -- end_time=1000000 [ns]
>
> Anyway, I'd appreciate some testing on your side too :).

Sure, I can give it a spin, but it'll have to be later in the week, kind
of swamped right now.

>
> Thanks,
> Kurt

-- 
Vinicius
