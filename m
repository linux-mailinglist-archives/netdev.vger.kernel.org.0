Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FEB6876F5
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBBIFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBBIFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:05:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6158A13D5E
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3D5E615EB
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E774C433EF;
        Thu,  2 Feb 2023 08:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675325100;
        bh=UlTcWALKBKKsj4fsxx0SFYlFcCYOZA5QjldwoUPcF0c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Syc+ztiEgwy9M/iTYE7yK/F3CXgOAr2iDypfm3vhPCKmJv0DXsb0Yk28hX4wVMPsi
         8n02Efo7+Fpw9m22cBGRaNT6GHPaRsE9NAhFuxagcjtDoVssvuOxu42+XqnZfLRBab
         YDdI4lCnAYwe0wH5VLjVl9pV4HSTCIJay3sJ/N0zY1IhX6+6su8Y/sS9EkQfhROrmu
         iTIr911T2ld2wxdhHBVpaFaxxk/4DCBRL6ak3ogAIylXcaoAMJ26LDy7cmgp9yKXK2
         W82KmcA60j9gix1fh249eQw+oIkY7Ooh2bI6mM8WuanH78nT7LC97/U7LpDvD8zSq5
         cQwhBPcavoE2g==
Message-ID: <8fb9048b-059c-f965-8cfc-e5fd480481b8@kernel.org>
Date:   Thu, 2 Feb 2023 10:04:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 net-next 14/17] net/sched: taprio: only calculate gate
 mask per TXQ for igc, stmmac and tsnep
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Pekka Varis <p-varis@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-15-vladimir.oltean@nxp.com>
Content-Language: en-US
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230202003621.2679603-15-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 02/02/2023 02:36, Vladimir Oltean wrote:
> There are 2 classes of in-tree drivers currently:
> 
> - those who act upon struct tc_taprio_sched_entry :: gate_mask as if it
>   holds a bit mask of TXQs
> 
> - those who act upon the gate_mask as if it holds a bit mask of TCs
> 
> When it comes to the standard, IEEE 802.1Q-2018 does say this in the
> second paragraph of section 8.6.8.4 Enhancements for scheduled traffic:
> 
> | A gate control list associated with each Port contains an ordered list
> | of gate operations. Each gate operation changes the transmission gate
> | state for the gate associated with each of the Port's traffic class
> | queues and allows associated control operations to be scheduled.
> 
> In typically obtuse language, it refers to a "traffic class queue"
> rather than a "traffic class" or a "queue". But careful reading of
> 802.1Q clarifies that "traffic class" and "queue" are in fact
> synonymous (see 8.6.6 Queuing frames):
> 
> | A queue in this context is not necessarily a single FIFO data structure.
> | A queue is a record of all frames of a given traffic class awaiting
> | transmission on a given Bridge Port. The structure of this record is not
> | specified.
> 
> i.o.w. their definition of "queue" isn't the Linux TX queue.
> 
> The gate_mask really is input into taprio via its UAPI as a mask of
> traffic classes, but taprio_sched_to_offload() converts it into a TXQ
> mask.
> 
> The breakdown of drivers which handle TC_SETUP_QDISC_TAPRIO is:
> 
> - hellcreek, felix, sja1105: these are DSA switches, it's not even very
>   clear what TXQs correspond to, other than purely software constructs.
>   Only the mqprio configuration with 8 TCs and 1 TXQ per TC makes sense.
>   So it's fine to convert these to a gate mask per TC.
> 
> - enetc: I have the hardware and can confirm that the gate mask is per
>   TC, and affects all TXQs (BD rings) configured for that priority.
> 
> - igc: in igc_save_qbv_schedule(), the gate_mask is clearly interpreted
>   to be per-TXQ.
> 
> - tsnep: Gerhard Engleder clarifies that even though this hardware
>   supports at most 1 TXQ per TC, the TXQ indices may be different from
>   the TC values themselves, and it is the TXQ indices that matter to
>   this hardware. So keep it per-TXQ as well.
> 
> - stmmac: I have a GMAC datasheet, and in the EST section it does
>   specify that the gate events are per TXQ rather than per TC.
> 
> - lan966x: again, this is a switch, and while not a DSA one, the way in
>   which it implements lan966x_mqprio_add() - by only allowing num_tc ==
>   NUM_PRIO_QUEUES (8) - makes it clear to me that TXQs are a purely
>   software construct here as well. They seem to map 1:1 with TCs.
> 
> - am65_cpsw: from looking at am65_cpsw_est_set_sched_cmds(), I get the
>   impression that the fetch_allow variable is treated like a prio_mask.
>   I haven't studied this driver's interpretation of the prio_tc_map, but
>   that definitely sounds closer to a per-TC gate mask rather than a
>   per-TXQ one.

Here is some documentation for this driver with usage example
https://software-dl.ti.com/processor-sdk-linux/esd/AM65X/08_02_00_02/exports/docs/linux/Foundational_Components/Kernel/Kernel_Drivers/Network/CPSW2g.html#enhancements-for-scheduled-traffic-est-offload

It looks like it is suggesting to create a TXQ for each TC?
I'm not sure if this patch will break that usage example. 

Here is explanation of fetch_allow register from TRM [1] 12.2.1.4.6.8.4 Enhanced Scheduled Traffic Fetch Values

"When a fetch allow bit is set, the corresponding priority is enabled to begin packet transmission on an
allowed priority subject to rate limiting. The actual packet transmission on the wire may carry over into the
next fetch count and is the reason for the wire clear time in the fetch zero allow.
When a fetch allow bit is cleared, the corresponding priority is not enabled to transmit for the fetch count time."

I can try to do some tests and confirm if it still works in a few days.

cheers,
-roger
[1] - https://www.ti.com/lit/pdf/spruim2

> 
> Based on this breakdown, we have 6 drivers with a gate mask per TC and
> 3 with a gate mask per TXQ. So let's make the gate mask per TXQ the
> opt-in and the gate mask per TC the default.
> 
> Benefit from the TC_QUERY_CAPS feature that Jakub suggested we add, and
> query the device driver before calling the proper ndo_setup_tc(), and
> figure out if it expects one or the other format.
> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Cc: Siddharth Vadapalli <s-vadapalli@ti.com>
> Cc: Roger Quadros <rogerq@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek
> Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
> v3->v5: none
> v2->v3: adjust commit message in light of what Kurt has said
> v1->v2:
> - rewrite commit message
> - also opt in stmmac and tsnep
> 
>  drivers/net/ethernet/engleder/tsnep_tc.c      | 21 +++++++++++++++++
>  drivers/net/ethernet/intel/igc/igc_main.c     | 23 +++++++++++++++++++
>  drivers/net/ethernet/stmicro/stmmac/hwif.h    |  5 ++++
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 ++
>  .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 ++++++++++++++++
>  include/net/pkt_sched.h                       |  1 +
>  net/sched/sch_taprio.c                        | 11 ++++++---
>  7 files changed, 80 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
> index c4c6e1357317..d083e6684f12 100644
> --- a/drivers/net/ethernet/engleder/tsnep_tc.c
> +++ b/drivers/net/ethernet/engleder/tsnep_tc.c
> @@ -403,12 +403,33 @@ static int tsnep_taprio(struct tsnep_adapter *adapter,
>  	return 0;
>  }
>  
> +static int tsnep_tc_query_caps(struct tsnep_adapter *adapter,
> +			       struct tc_query_caps_base *base)
> +{
> +	switch (base->type) {
> +	case TC_SETUP_QDISC_TAPRIO: {
> +		struct tc_taprio_caps *caps = base->caps;
> +
> +		if (!adapter->gate_control)
> +			return -EOPNOTSUPP;
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
>  int tsnep_tc_setup(struct net_device *netdev, enum tc_setup_type type,
>  		   void *type_data)
>  {
>  	struct tsnep_adapter *adapter = netdev_priv(netdev);
>  
>  	switch (type) {
> +	case TC_QUERY_CAPS:
> +		return tsnep_tc_query_caps(adapter, type_data);
>  	case TC_SETUP_QDISC_TAPRIO:
>  		return tsnep_taprio(adapter, type_data);
>  	default:
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index e86b15efaeb8..cce1dea51f76 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6205,12 +6205,35 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
>  	return igc_tsn_offload_apply(adapter);
>  }
>  
> +static int igc_tc_query_caps(struct igc_adapter *adapter,
> +			     struct tc_query_caps_base *base)
> +{
> +	struct igc_hw *hw = &adapter->hw;
> +
> +	switch (base->type) {
> +	case TC_SETUP_QDISC_TAPRIO: {
> +		struct tc_taprio_caps *caps = base->caps;
> +
> +		if (hw->mac.type != igc_i225)
> +			return -EOPNOTSUPP;
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
> +		return igc_tc_query_caps(adapter, type_data);
>  	case TC_SETUP_QDISC_TAPRIO:
>  		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
>  
> diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
> index 592b4067f9b8..16a7421715cb 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
> @@ -567,6 +567,7 @@ struct tc_cbs_qopt_offload;
>  struct flow_cls_offload;
>  struct tc_taprio_qopt_offload;
>  struct tc_etf_qopt_offload;
> +struct tc_query_caps_base;
>  
>  struct stmmac_tc_ops {
>  	int (*init)(struct stmmac_priv *priv);
> @@ -580,6 +581,8 @@ struct stmmac_tc_ops {
>  			    struct tc_taprio_qopt_offload *qopt);
>  	int (*setup_etf)(struct stmmac_priv *priv,
>  			 struct tc_etf_qopt_offload *qopt);
> +	int (*query_caps)(struct stmmac_priv *priv,
> +			  struct tc_query_caps_base *base);
>  };
>  
>  #define stmmac_tc_init(__priv, __args...) \
> @@ -594,6 +597,8 @@ struct stmmac_tc_ops {
>  	stmmac_do_callback(__priv, tc, setup_taprio, __args)
>  #define stmmac_tc_setup_etf(__priv, __args...) \
>  	stmmac_do_callback(__priv, tc, setup_etf, __args)
> +#define stmmac_tc_query_caps(__priv, __args...) \
> +	stmmac_do_callback(__priv, tc, query_caps, __args)
>  
>  struct stmmac_counters;
>  
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index b7e5af58ab75..17a7ea1cb961 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5991,6 +5991,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>  	struct stmmac_priv *priv = netdev_priv(ndev);
>  
>  	switch (type) {
> +	case TC_QUERY_CAPS:
> +		return stmmac_tc_query_caps(priv, priv, type_data);
>  	case TC_SETUP_BLOCK:
>  		return flow_block_cb_setup_simple(type_data,
>  						  &stmmac_block_cb_list,
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> index 2cfb18cef1d4..9d55226479b4 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> @@ -1107,6 +1107,25 @@ static int tc_setup_etf(struct stmmac_priv *priv,
>  	return 0;
>  }
>  
> +static int tc_query_caps(struct stmmac_priv *priv,
> +			 struct tc_query_caps_base *base)
> +{
> +	switch (base->type) {
> +	case TC_SETUP_QDISC_TAPRIO: {
> +		struct tc_taprio_caps *caps = base->caps;
> +
> +		if (!priv->dma_cap.estsel)
> +			return -EOPNOTSUPP;
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
>  const struct stmmac_tc_ops dwmac510_tc_ops = {
>  	.init = tc_init,
>  	.setup_cls_u32 = tc_setup_cls_u32,
> @@ -1114,4 +1133,5 @@ const struct stmmac_tc_ops dwmac510_tc_ops = {
>  	.setup_cls = tc_setup_cls,
>  	.setup_taprio = tc_setup_taprio,
>  	.setup_etf = tc_setup_etf,
> +	.query_caps = tc_query_caps,
>  };
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
> index aba8a16842c1..1c95785932b9 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1170,7 +1170,8 @@ static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
>  
>  static void taprio_sched_to_offload(struct net_device *dev,
>  				    struct sched_gate_list *sched,
> -				    struct tc_taprio_qopt_offload *offload)
> +				    struct tc_taprio_qopt_offload *offload,
> +				    const struct tc_taprio_caps *caps)
>  {
>  	struct sched_entry *entry;
>  	int i = 0;
> @@ -1184,7 +1185,11 @@ static void taprio_sched_to_offload(struct net_device *dev,
>  
>  		e->command = entry->command;
>  		e->interval = entry->interval;
> -		e->gate_mask = tc_map_to_queue_mask(dev, entry->gate_mask);
> +		if (caps->gate_mask_per_txq)
> +			e->gate_mask = tc_map_to_queue_mask(dev,
> +							    entry->gate_mask);
> +		else
> +			e->gate_mask = entry->gate_mask;
>  
>  		i++;
>  	}
> @@ -1229,7 +1234,7 @@ static int taprio_enable_offload(struct net_device *dev,
>  	}
>  	offload->enable = 1;
>  	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
> -	taprio_sched_to_offload(dev, sched, offload);
> +	taprio_sched_to_offload(dev, sched, offload, &caps);
>  
>  	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
>  		offload->max_sdu[tc] = q->max_sdu[tc];
