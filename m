Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6967A846
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 02:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjAYBLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 20:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjAYBLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 20:11:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC002BF03
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 17:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674609096; x=1706145096;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=6VuUDtmER4sNmZ4k3ZCWpxqebkz1fhjMNARJ4V6+Ui0=;
  b=jZhJ/hV6RLwweRrFvWfDcXq5/NMnyuwmupc08MdsBGHoaKi337XB70Cb
   3SfjYFg5rmVsO10gfHIKnhJgHv0BGhqOY599j5UraPrLwI75KUqAm3gzD
   R7TBOaRYyAo25z/j0eDI5fCWq1WgGTowV0KFOsuWMDzv+3P0G6E8igEqR
   fX9b68ZHNy3MCWzLIGu6b18LnwEMpiZqU4O6g4jvbybbk+56+WLOXIrMi
   zC3cnUgcAMpSgD1hIzKlPZtn1KZz+5bKdVF+Vk+vlfab9I9kDRdYGySJW
   Kv8WlJwgYSbe0OfXU/tuVfT1NBKVZlxP7XShK9mCWeiF3jnitbh2YPR9p
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="324154878"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="324154878"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 17:11:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="639770228"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="639770228"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 17:11:36 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [RFC PATCH net-next 11/11] net/sched: taprio: only calculate
 gate mask per TXQ for igc
In-Reply-To: <20230120141537.1350744-12-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <20230120141537.1350744-12-vladimir.oltean@nxp.com>
Date:   Tue, 24 Jan 2023 17:11:36 -0800
Message-ID: <87r0vjh0zb.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> Vinicius has repeated a couple of times in our discussion that it was a
> mistake for the taprio UAPI to take as input the Qbv gate mask per TC
> rather than per TXQ. In the Frame Preemption RFC thread:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220816222920.1952936-3-vladimir.oltean@nxp.com/#25011225
>
> I had this unanswered question:
>
> | > And even that it works out because taprio "translates" from traffic
> | > classes to queues when it sends the offload information to the driver,
> | > i.e. the driver knows the schedule of queues, not traffic classes.
> |
> | Which is incredibly strange to me, since the standard clearly defines
> | Qbv gates to be per traffic class, and in ENETC, even if we have 2 TX
> | queues for the same traffic class (one per CPU), the hardware schedule
> | is still per traffic class and not per independent TX queue (BD ring).
> |
> | How does this work for i225/i226, if 2 queues are configured for the
> | same dequeue priority? Do the taprio gates still take effect per
> | queue?

Sorry that I haven't answered this before.

Two things, for i225/i226:
  - The gates open/close registers are per-queue, i.e. I control
  explicitly when each gate is going to close/open inside each cycle
  (yes, this design does have limitations);
  - Looking at the datasheet there's also this: "Each queue must be
  assigned with a unique priority level". Not sure what happens if I set
  the same, I would expect that the ordering would be undefined, but I
  never tested that.

>
> I haven't gotten an answer, and some things are still unclear, but I
> suspect that igc is the outlier, and all the other hardware actually has
> the gate mask per TC and not per TXQ, just like the standard says.
>
> For example, in ENETC up until now, we weren't passed the mqprio queue
> configuration via struct tc_taprio_qopt_offload, and hence, we needed to
> assume that the TC:TXQ mapping was 1:1. So "per TC" or "per TXQ" did not
> make a practical difference. I suspect that other drivers are in the
> same position.
>
> Benefit from the TC_QUERY_CAPS feature that Jakub suggested we add, and
> query the device driver before calling the proper ndo_setup_tc(), and
> figure out if it expects the gate mask to be per TC or per TXQ.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 17 +++++++++++++++++
>  include/net/pkt_sched.h                   |  1 +
>  net/sched/sch_taprio.c                    | 11 ++++++++---
>  3 files changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index e86b15efaeb8..9b6f2aaf78c2 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6205,12 +6205,29 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
>  	return igc_tsn_offload_apply(adapter);
>  }
>  
> +static int igc_tc_query_caps(struct tc_query_caps_base *base)
> +{
> +	switch (base->type) {
> +	case TC_SETUP_QDISC_TAPRIO: {
> +		struct tc_taprio_caps *caps = base->caps;
> +
> +		caps->gate_mask_per_txq = true;
> +
> +		return 0;
> +	}
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
>  			void *type_data)
>  {
>  	struct igc_adapter *adapter = netdev_priv(dev);
>  
>  	switch (type) {
> +	case TC_QUERY_CAPS:
> +		return igc_tc_query_caps(type_data);
>  	case TC_SETUP_QDISC_TAPRIO:
>  		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
>  
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index ace8be520fb0..fd889fc4912b 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -176,6 +176,7 @@ struct tc_mqprio_qopt_offload {
>  
>  struct tc_taprio_caps {
>  	bool supports_queue_max_sdu:1;
> +	bool gate_mask_per_txq:1;
>  };
>  
>  struct tc_taprio_sched_entry {
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index a3fa5debe513..58efa982db65 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1212,7 +1212,8 @@ static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
>  
>  static void taprio_sched_to_offload(struct net_device *dev,
>  				    struct sched_gate_list *sched,
> -				    struct tc_taprio_qopt_offload *offload)
> +				    struct tc_taprio_qopt_offload *offload,
> +				    bool gate_mask_per_txq)
>  {
>  	struct sched_entry *entry;
>  	int i = 0;
> @@ -1226,7 +1227,11 @@ static void taprio_sched_to_offload(struct net_device *dev,
>  
>  		e->command = entry->command;
>  		e->interval = entry->interval;
> -		e->gate_mask = tc_map_to_queue_mask(dev, entry->gate_mask);
> +		if (gate_mask_per_txq)
> +			e->gate_mask = tc_map_to_queue_mask(dev,
> +							    entry->gate_mask);
> +		else
> +			e->gate_mask = entry->gate_mask;
>  
>  		i++;
>  	}
> @@ -1273,7 +1278,7 @@ static int taprio_enable_offload(struct net_device *dev,
>  	offload->enable = 1;
>  	if (mqprio)
>  		offload->mqprio.qopt = *mqprio;
> -	taprio_sched_to_offload(dev, sched, offload);
> +	taprio_sched_to_offload(dev, sched, offload, caps.gate_mask_per_txq);
>  
>  	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
>  		offload->max_sdu[tc] = q->max_sdu[tc];
> -- 
> 2.34.1
>

-- 
Vinicius
