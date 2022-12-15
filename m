Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C08564DE3B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLOQMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLOQME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:12:04 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399C01658B
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671120723; x=1702656723;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=Q9kv+MsdAnsAc58+1nylMk7S0A7SHKAhCdv85+TqGdw=;
  b=LB5U9mybe63W59aXeuts0Dd4nBLbLM4D473W6SVJFOc2Qz8JWXFefsiw
   5GYLA78kf0lj9VetNnNq7fpzz2egf1bwH43f9ZwWvw8TxL+6q2j3MZ77L
   z25G534tEKN3HE4MNHE8JvaAopy89J+jfN3xdzGT9Msxhm8cTmss372Og
   Cx6jHpiJC1mn+DHAaRgukBUsSP1BmvrFplo+4S/Rq9774PjpPX/I40p1x
   C6rODdcTw1b60LfCRvfS/VCwuWuCUJ/iubGlEIzGKhKtD9gWuDKHSMWm7
   XA8nTvRb7OA+5BVR8M0oMtKZ5LvjxVnjnCfaABmHAuiv2O/EAnQl3MwGI
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="316352521"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="316352521"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 08:04:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="651585479"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="651585479"
Received: from nikitana-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.87.186])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 08:04:43 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>
Cc:     "tee.min.tan@linux.intel.com" <tee.min.tan@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "naamax.meir@linux.intel.com" <naamax.meir@linux.intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next v1] igc: offload queue max SDU from tc-taprio
In-Reply-To: <SJ1PR11MB61804722400A816E3DB0AD51B8E19@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20221214144514.15931-1-muhammad.husaini.zulkifli@intel.com>
 <87tu1xc3bz.fsf@intel.com>
 <SJ1PR11MB61804722400A816E3DB0AD51B8E19@SJ1PR11MB6180.namprd11.prod.outlook.com>
Date:   Thu, 15 Dec 2022 13:04:40 -0300
Message-ID: <87ilicbqlj.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Husaini,

"Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
writes:

> Hi Vinicius,
>
>> -----Original Message-----
>> From: Gomes, Vinicius <vinicius.gomes@intel.com>
>> Sent: Thursday, 15 December, 2022 1:17 AM
>> To: Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>;
>> intel-wired-lan@osuosl.org
>> Cc: tee.min.tan@linux.intel.com; davem@davemloft.net; kuba@kernel.org;
>> netdev@vger.kernel.org; Zulkifli, Muhammad Husaini
>> <muhammad.husaini.zulkifli@intel.com>; naamax.meir@linux.intel.com;
>> Nguyen, Anthony L <anthony.l.nguyen@intel.com>
>> Subject: Re: [PATCH net-next v1] igc: offload queue max SDU from tc-taprio
>> 
>> Hi,
>> 
>> Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com> writes:
>> 
>> > From: Tan Tee Min <tee.min.tan@linux.intel.com>
>> >
>> > Add support for configuring the max SDU for each Tx queue.
>> > If not specified, keep the default.
>> >
>> > Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
>> > Signed-off-by: Muhammad Husaini Zulkifli
>> > <muhammad.husaini.zulkifli@intel.com>
>> > ---
>> >  drivers/net/ethernet/intel/igc/igc.h      |  1 +
>> >  drivers/net/ethernet/intel/igc/igc_main.c | 45
>> +++++++++++++++++++++++
>> >  include/net/pkt_sched.h                   |  1 +
>> >  net/sched/sch_taprio.c                    |  4 +-
>> >  4 files changed, 50 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/net/ethernet/intel/igc/igc.h
>> > b/drivers/net/ethernet/intel/igc/igc.h
>> > index 5da8d162cd38..ce9e88687d8c 100644
>> > --- a/drivers/net/ethernet/intel/igc/igc.h
>> > +++ b/drivers/net/ethernet/intel/igc/igc.h
>> > @@ -99,6 +99,7 @@ struct igc_ring {
>> >
>> >  	u32 start_time;
>> >  	u32 end_time;
>> > +	u32 max_sdu;
>> >
>> >  	/* CBS parameters */
>> >  	bool cbs_enable;                /* indicates if CBS is enabled */
>> > diff --git a/drivers/net/ethernet/intel/igc/igc_main.c
>> > b/drivers/net/ethernet/intel/igc/igc_main.c
>> > index e07287e05862..7ce05c31e371 100644
>> > --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> > +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> > @@ -1508,6 +1508,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct
>> sk_buff *skb,
>> >  	__le32 launch_time = 0;
>> >  	u32 tx_flags = 0;
>> >  	unsigned short f;
>> > +	u32 max_sdu = 0;
>> >  	ktime_t txtime;
>> >  	u8 hdr_len = 0;
>> >  	int tso = 0;
>> > @@ -1527,6 +1528,16 @@ static netdev_tx_t igc_xmit_frame_ring(struct
>> sk_buff *skb,
>> >  		return NETDEV_TX_BUSY;
>> >  	}
>> >
>> > +	if (tx_ring->max_sdu > 0) {
>> > +		if (skb_vlan_tagged(skb))
>> > +			max_sdu = tx_ring->max_sdu + VLAN_HLEN;
>> > +		else
>> > +			max_sdu = tx_ring->max_sdu;
>> 
>> perhaps this?
>>     max_sdu = tx_ring->max_sdu + (skb_vlan_tagged(skb) ? VLAN_HLEN : 0);
>> 
>> Totally optional.
>
> Sure. We can change to above suggestion.
>
>> 
>> > +
>> > +		if (skb->len > max_sdu)
>> > +			goto skb_drop;
>> > +	}
>> > +
>> 
>> I don't think the overhead would be measurable for the pkt/s rates that a
>> 2.5G link can handle. But a test and a note in the commit message confirming
>> that would be nice.
>
> IMHO, it should not depends on the link speed but the packet size only.
> If we detect packet size greater than max_sdu, we will just drop it.
>

I was thinking more about the added conditional on the hot path, if it
had some performance impact for the case when packets are not dropped. I
really don't think there will be any, but it's nice to have some numbers
to confirm that.

>> 
>> >  	if (!tx_ring->launchtime_enable)
>> >  		goto done;
>> >
>> > @@ -1606,6 +1617,12 @@ static netdev_tx_t igc_xmit_frame_ring(struct
>> sk_buff *skb,
>> >  	dev_kfree_skb_any(first->skb);
>> >  	first->skb = NULL;
>> >
>> > +	return NETDEV_TX_OK;
>> > +
>> > +skb_drop:
>> > +	dev_kfree_skb_any(skb);
>> > +	skb = NULL;
>> > +
>> >  	return NETDEV_TX_OK;
>> >  }
>> >
>> > @@ -6015,6 +6032,7 @@ static int igc_tsn_clear_schedule(struct
>> > igc_adapter *adapter)
>> >
>> >  		ring->start_time = 0;
>> >  		ring->end_time = NSEC_PER_SEC;
>> > +		ring->max_sdu = 0;
>> >  	}
>> >
>> >  	return 0;
>> > @@ -6097,6 +6115,15 @@ static int igc_save_qbv_schedule(struct
>> igc_adapter *adapter,
>> >  		}
>> >  	}
>> >
>> > +	for (i = 0; i < adapter->num_tx_queues; i++) {
>> > +		struct igc_ring *ring = adapter->tx_ring[i];
>> > +
>> > +		if (qopt->max_frm_len[i] == U32_MAX)
>> > +			ring->max_sdu = 0;
>> > +		else
>> > +			ring->max_sdu = qopt->max_frm_len[i];
>> > +	}
>> > +
>> >  	return 0;
>> >  }
>> >
>> > @@ -6184,12 +6211,30 @@ static int igc_tsn_enable_cbs(struct igc_adapter
>> *adapter,
>> >  	return igc_tsn_offload_apply(adapter);  }
>> >
>> > +static int igc_tsn_query_caps(struct tc_query_caps_base *base) {
>> > +	switch (base->type) {
>> > +	case TC_SETUP_QDISC_TAPRIO: {
>> > +		struct tc_taprio_caps *caps = base->caps;
>> > +
>> > +		caps->supports_queue_max_sdu = true;
>> > +
>> > +		return 0;
>> > +	}
>> > +	default:
>> > +		return -EOPNOTSUPP;
>> > +	}
>> > +}
>> > +
>> >  static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
>> >  			void *type_data)
>> >  {
>> >  	struct igc_adapter *adapter = netdev_priv(dev);
>> >
>> >  	switch (type) {
>> > +	case TC_QUERY_CAPS:
>> > +		return igc_tsn_query_caps(type_data);
>> > +
>> >  	case TC_SETUP_QDISC_TAPRIO:
>> >  		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
>> >
>> > diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h index
>> > 38207873eda6..d2539b1f6529 100644
>> > --- a/include/net/pkt_sched.h
>> > +++ b/include/net/pkt_sched.h
>> > @@ -178,6 +178,7 @@ struct tc_taprio_qopt_offload {
>> >  	u64 cycle_time;
>> >  	u64 cycle_time_extension;
>> >  	u32 max_sdu[TC_MAX_QUEUE];
>> > +	u32 max_frm_len[TC_MAX_QUEUE];
>> >
>> 
>> 'max_frm_len' is an internal taprio optimization, to simplify the code where
>> the underlying HW doesn't support offload.
>
> The max_sdu only comes with MTU payload size. The reason why we are using 
> this max_frm_len is to get the header + MTU size together. 
>
> We can use max_sdu + header in the igc_save_qbv_schedule() and remove 
> this piece of code from pkt_sched.h

This sounds better, only exposing max_sdu to the drivers, even if it
causes a bit of duplicated code.

>
>> 
>> For offloading, only 'max_sdu' should be used. Unless you have a strong
>> reason. If you have that reason, it should be a separate commit.
>> 
>> >  	size_t num_entries;
>> >  	struct tc_taprio_sched_entry entries[]; diff --git
>> > a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c index
>> > 570389f6cdd7..d39164074756 100644
>> > --- a/net/sched/sch_taprio.c
>> > +++ b/net/sched/sch_taprio.c
>> > @@ -1263,8 +1263,10 @@ static int taprio_enable_offload(struct
>> net_device *dev,
>> >  	offload->enable = 1;
>> >  	taprio_sched_to_offload(dev, sched, offload);
>> >
>> > -	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
>> > +	for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
>> >  		offload->max_sdu[tc] = q->max_sdu[tc];
>> > +		offload->max_frm_len[tc] = q->max_frm_len[tc];
>> > +	}
>> >
>> >  	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
>> >  	if (err < 0) {
>> > --
>> > 2.17.1
>> >
>> 
>> --
>> Vinicius

-- 
Vinicius
