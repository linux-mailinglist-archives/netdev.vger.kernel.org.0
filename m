Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570F964CED0
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 18:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiLNRUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 12:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiLNRUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 12:20:46 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CD85FEA
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 09:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671038444; x=1702574444;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=aoQDKxcbgkz88mq+Z+NChHYJbtwIPvbJRPyZBzcaLlU=;
  b=btkfe57FgOgUfAwxJZU2bGx0tdfGV9KSFMPtyM01tN7duv12HAnRyuER
   To7XP0QP1hmAKtLDE948XqgXiMPRfJzROc5YJ03cZJQIZ7ouYxAhWo081
   9JsoSdgRCTCNbPy9dy/b9WgjsFCestK41vmA/Hch31ZAbd6SfqVd5TDJ+
   DcUAzHF0E+kKOxYC2bMUJrXVRZ4+3tyaTl6bQtLuSwPSCJ44G+hgPja5e
   4MrUQjcNznZfovwsde6Z9FC9b5JP9lQM8jryGy6yg31vqr3U6IomWuMLx
   0CjG8kAWIJZDITW4XCPmvSV7iuN1QcM/sPR3HaPUIjdGMuDCTCHYLpJ0f
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="382764806"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="382764806"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 09:17:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="712583562"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="712583562"
Received: from seetaram-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.66.98])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 09:17:24 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        intel-wired-lan@osuosl.org
Cc:     tee.min.tan@linux.intel.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, muhammad.husaini.zulkifli@intel.com,
        naamax.meir@linux.intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1] igc: offload queue max SDU from tc-taprio
In-Reply-To: <20221214144514.15931-1-muhammad.husaini.zulkifli@intel.com>
References: <20221214144514.15931-1-muhammad.husaini.zulkifli@intel.com>
Date:   Wed, 14 Dec 2022 14:17:20 -0300
Message-ID: <87tu1xc3bz.fsf@intel.com>
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

Hi,

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com> writes:

> From: Tan Tee Min <tee.min.tan@linux.intel.com>
>
> Add support for configuring the max SDU for each Tx queue.
> If not specified, keep the default.
>
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc.h      |  1 +
>  drivers/net/ethernet/intel/igc/igc_main.c | 45 +++++++++++++++++++++++
>  include/net/pkt_sched.h                   |  1 +
>  net/sched/sch_taprio.c                    |  4 +-
>  4 files changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
> index 5da8d162cd38..ce9e88687d8c 100644
> --- a/drivers/net/ethernet/intel/igc/igc.h
> +++ b/drivers/net/ethernet/intel/igc/igc.h
> @@ -99,6 +99,7 @@ struct igc_ring {
>  
>  	u32 start_time;
>  	u32 end_time;
> +	u32 max_sdu;
>  
>  	/* CBS parameters */
>  	bool cbs_enable;                /* indicates if CBS is enabled */
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index e07287e05862..7ce05c31e371 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -1508,6 +1508,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
>  	__le32 launch_time = 0;
>  	u32 tx_flags = 0;
>  	unsigned short f;
> +	u32 max_sdu = 0;
>  	ktime_t txtime;
>  	u8 hdr_len = 0;
>  	int tso = 0;
> @@ -1527,6 +1528,16 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
>  		return NETDEV_TX_BUSY;
>  	}
>  
> +	if (tx_ring->max_sdu > 0) {
> +		if (skb_vlan_tagged(skb))
> +			max_sdu = tx_ring->max_sdu + VLAN_HLEN;
> +		else
> +			max_sdu = tx_ring->max_sdu;

perhaps this?
    max_sdu = tx_ring->max_sdu + (skb_vlan_tagged(skb) ? VLAN_HLEN : 0);

Totally optional.

> +
> +		if (skb->len > max_sdu)
> +			goto skb_drop;
> +	}
> +

I don't think the overhead would be measurable for the pkt/s rates that
a 2.5G link can handle. But a test and a note in the commit message
confirming that would be nice.

>  	if (!tx_ring->launchtime_enable)
>  		goto done;
>  
> @@ -1606,6 +1617,12 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
>  	dev_kfree_skb_any(first->skb);
>  	first->skb = NULL;
>  
> +	return NETDEV_TX_OK;
> +
> +skb_drop:
> +	dev_kfree_skb_any(skb);
> +	skb = NULL;
> +
>  	return NETDEV_TX_OK;
>  }
>  
> @@ -6015,6 +6032,7 @@ static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
>  
>  		ring->start_time = 0;
>  		ring->end_time = NSEC_PER_SEC;
> +		ring->max_sdu = 0;
>  	}
>  
>  	return 0;
> @@ -6097,6 +6115,15 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
>  		}
>  	}
>  
> +	for (i = 0; i < adapter->num_tx_queues; i++) {
> +		struct igc_ring *ring = adapter->tx_ring[i];
> +
> +		if (qopt->max_frm_len[i] == U32_MAX)
> +			ring->max_sdu = 0;
> +		else
> +			ring->max_sdu = qopt->max_frm_len[i];
> +	}
> +
>  	return 0;
>  }
>  
> @@ -6184,12 +6211,30 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
>  	return igc_tsn_offload_apply(adapter);
>  }
>  
> +static int igc_tsn_query_caps(struct tc_query_caps_base *base)
> +{
> +	switch (base->type) {
> +	case TC_SETUP_QDISC_TAPRIO: {
> +		struct tc_taprio_caps *caps = base->caps;
> +
> +		caps->supports_queue_max_sdu = true;
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
> +		return igc_tsn_query_caps(type_data);
> +
>  	case TC_SETUP_QDISC_TAPRIO:
>  		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
>  
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index 38207873eda6..d2539b1f6529 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -178,6 +178,7 @@ struct tc_taprio_qopt_offload {
>  	u64 cycle_time;
>  	u64 cycle_time_extension;
>  	u32 max_sdu[TC_MAX_QUEUE];
> +	u32 max_frm_len[TC_MAX_QUEUE];
>

'max_frm_len' is an internal taprio optimization, to simplify the code
where the underlying HW doesn't support offload.

For offloading, only 'max_sdu' should be used. Unless you have a strong
reason. If you have that reason, it should be a separate commit.

>  	size_t num_entries;
>  	struct tc_taprio_sched_entry entries[];
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 570389f6cdd7..d39164074756 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1263,8 +1263,10 @@ static int taprio_enable_offload(struct net_device *dev,
>  	offload->enable = 1;
>  	taprio_sched_to_offload(dev, sched, offload);
>  
> -	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
> +	for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
>  		offload->max_sdu[tc] = q->max_sdu[tc];
> +		offload->max_frm_len[tc] = q->max_frm_len[tc];
> +	}
>  
>  	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
>  	if (err < 0) {
> -- 
> 2.17.1
>

-- 
Vinicius
