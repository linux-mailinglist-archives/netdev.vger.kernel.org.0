Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7776862486E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiKJRgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiKJRgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:36:04 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D625B1B1C8
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668101757; x=1699637757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BAv6Aj9iwJIeO2xE1Kwh5gf5t9kO4HIS2g5oLXHtY7M=;
  b=G5mXzjy9hZ0DqMHXzcDnaT5qPKN6FlCwwOngXvYiz8HyCqP4V0IDHunh
   5zpNYSg6uc7YgZsiRoz0kuFh8S4pzh1G4wcqFlzubbnizYk034Ruwl4tl
   2+qDTD2Ca92eg3HPKidAGKNuFFGArANQ8Hl9yEkcE0kwVkBA9kZhRHNlE
   z9PHpwnwtlEr4khwuX1XBJO1Oi/idby2VaQ/pphNY7MmklqUVC7OXA+pU
   2SoXXTW3O7BwZeqCJkeoIte8AwbKcnBX3gWNo08/FOLpleyADyXI2/3nD
   B+8X77SaXN7F+aQvInPK8CmKWyD0RAxnRMQ2+GtL60VLMIYT1erdirHKH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="291101429"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="291101429"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 09:35:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="631737863"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="631737863"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 10 Nov 2022 09:35:49 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AAHZl4S029191;
        Thu, 10 Nov 2022 17:35:47 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
Date:   Thu, 10 Nov 2022 18:32:22 +0100
Message-Id: <20221110173222.3536589-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109180249.4721-3-dnlplm@gmail.com>
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>
Date: Wed,  9 Nov 2022 19:02:48 +0100

> Bidirectional TCP throughput tests through iperf with low-cat
> Thread-x based modems showed performance issues both in tx
> and rx.
> 
> The Windows driver does not show this issue: inspecting USB
> packets revealed that the only notable change is the driver
> enabling tx packets aggregation.
> 
> Tx packets aggregation, by default disabled, requires flag
> RMNET_FLAGS_EGRESS_AGGREGATION to be set (e.g. through ip command).
> 
> The maximum number of aggregated packets and the maximum aggregated
> size are by default set to reasonably low values in order to support
> the majority of modems.
> 
> This implementation is based on patches available in Code Aurora
> repositories (msm kernel) whose main authors are
> 
> Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Sean Tranchetti <stranche@codeaurora.org>
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
>  .../ethernet/qualcomm/rmnet/rmnet_config.c    |   5 +
>  .../ethernet/qualcomm/rmnet/rmnet_config.h    |  19 ++
>  .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  25 ++-
>  .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |   7 +
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 196 ++++++++++++++++++
>  include/uapi/linux/if_link.h                  |   1 +
>  6 files changed, 251 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> index 27b1663c476e..39d24e07f306 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> @@ -12,6 +12,7 @@
>  #include "rmnet_handlers.h"
>  #include "rmnet_vnd.h"
>  #include "rmnet_private.h"
> +#include "rmnet_map.h"
>  
>  /* Local Definitions and Declarations */
>  
> @@ -39,6 +40,8 @@ static int rmnet_unregister_real_device(struct net_device *real_dev)
>  	if (port->nr_rmnet_devs)
>  		return -EINVAL;
>  
> +	rmnet_map_tx_aggregate_exit(port);
> +
>  	netdev_rx_handler_unregister(real_dev);
>  
>  	kfree(port);
> @@ -79,6 +82,8 @@ static int rmnet_register_real_device(struct net_device *real_dev,
>  	for (entry = 0; entry < RMNET_MAX_LOGICAL_EP; entry++)
>  		INIT_HLIST_HEAD(&port->muxed_ep[entry]);
>  
> +	rmnet_map_tx_aggregate_init(port);
> +
>  	netdev_dbg(real_dev, "registered with rmnet\n");
>  	return 0;
>  }
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> index 3d3cba56c516..d341df78e411 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> @@ -6,6 +6,7 @@
>   */
>  
>  #include <linux/skbuff.h>
> +#include <linux/time.h>
>  #include <net/gro_cells.h>
>  
>  #ifndef _RMNET_CONFIG_H_
> @@ -19,6 +20,12 @@ struct rmnet_endpoint {
>  	struct hlist_node hlnode;
>  };
>  
> +struct rmnet_egress_agg_params {
> +	u16 agg_size;

skbs can now be way longer than 64 Kb.

> +	u16 agg_count;
> +	u64 agg_time_nsec;
> +};
> +
>  /* One instance of this structure is instantiated for each real_dev associated
>   * with rmnet.
>   */

[...]

> @@ -518,3 +519,198 @@ int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
>  
>  	return 0;
>  }
> +
> +long rmnet_agg_bypass_time __read_mostly = 10000L * NSEC_PER_USEC;

Why __read_mostly if you don't change it anywhere? Could be const.
Why here if you use it only in one file? Could be static there.
Why variable if it could be a definition?

> +
> +bool rmnet_map_tx_agg_skip(struct sk_buff *skb)
> +{
> +	bool is_icmp = 0;
> +
> +	if (skb->protocol == htons(ETH_P_IP)) {
> +		struct iphdr *ip4h = ip_hdr(skb);

[...]

> +static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
> +{
> +	struct sk_buff *skb = NULL;
> +	struct rmnet_port *port;
> +	unsigned long flags;
> +
> +	port = container_of(work, struct rmnet_port, agg_wq);
> +
> +	spin_lock_irqsave(&port->agg_lock, flags);

I don't see aggregation fields used in any hardware interrupt
handlers, are you sure you need _irq*(), not _bh()?

> +	if (likely(port->agg_state == -EINPROGRESS)) {
> +		/* Buffer may have already been shipped out */
> +		if (likely(port->agg_skb)) {
> +			skb = port->agg_skb;
> +			reset_aggr_params(port);
> +		}
> +		port->agg_state = 0;
> +	}
> +
> +	spin_unlock_irqrestore(&port->agg_lock, flags);
> +	if (skb)
> +		dev_queue_xmit(skb);
> +}
> +
> +enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
> +{
> +	struct rmnet_port *port;
> +
> +	port = container_of(t, struct rmnet_port, hrtimer);
> +
> +	schedule_work(&port->agg_wq);
> +
> +	return HRTIMER_NORESTART;
> +}
> +
> +void rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
> +			    struct net_device *orig_dev)
> +{
> +	struct timespec64 diff, last;
> +	int size = 0;

RCT style?

> +	struct sk_buff *agg_skb;
> +	unsigned long flags;
> +
> +new_packet:
> +	spin_lock_irqsave(&port->agg_lock, flags);
> +	memcpy(&last, &port->agg_last, sizeof(struct timespec64));
> +	ktime_get_real_ts64(&port->agg_last);
> +
> +	if (!port->agg_skb) {
> +		/* Check to see if we should agg first. If the traffic is very
> +		 * sparse, don't aggregate.
> +		 */
> +		diff = timespec64_sub(port->agg_last, last);
> +		size = port->egress_agg_params.agg_size - skb->len;
> +
> +		if (size < 0) {
> +			struct rmnet_priv *priv;
> +
> +			/* dropped */

So if a packet is smaller than the aggregation threshold, you just
drop it? Why, if you could just let it go the "standard" way, like
ICMP does?

> +			dev_kfree_skb_any(skb);
> +			spin_unlock_irqrestore(&port->agg_lock, flags);

You could release this lock a line above, so that
dev_kfree_skb_any() wouldn't be called in the HWIRQ context and
postpone skb freeing via the softnet queue.

> +			priv = netdev_priv(orig_dev);
> +			this_cpu_inc(priv->pcpu_stats->stats.tx_drops);
> +
> +			return;
> +		}
> +
> +		if (diff.tv_sec > 0 || diff.tv_nsec > rmnet_agg_bypass_time ||
> +		    size == 0) {
> +			spin_unlock_irqrestore(&port->agg_lock, flags);
> +			skb->protocol = htons(ETH_P_MAP);
> +			dev_queue_xmit(skb);
> +			return;
> +		}
> +
> +		port->agg_skb = skb_copy_expand(skb, 0, size, GFP_ATOMIC);

You could use skb_cow_head(skb, 0) and skip allocating a new skb if
the current one is writable, which usually is the case.

> +		if (!port->agg_skb) {
> +			reset_aggr_params(port);
> +			spin_unlock_irqrestore(&port->agg_lock, flags);
> +			skb->protocol = htons(ETH_P_MAP);
> +			dev_queue_xmit(skb);
> +			return;
> +		}
> +		port->agg_skb->protocol = htons(ETH_P_MAP);
> +		port->agg_count = 1;
> +		ktime_get_real_ts64(&port->agg_time);
> +		dev_kfree_skb_any(skb);
> +		goto schedule;
> +	}
> +	diff = timespec64_sub(port->agg_last, port->agg_time);
> +	size = port->egress_agg_params.agg_size - port->agg_skb->len;
> +
> +	if (skb->len > size ||
> +	    diff.tv_sec > 0 || diff.tv_nsec > port->egress_agg_params.agg_time_nsec) {
> +		agg_skb = port->agg_skb;
> +		reset_aggr_params(port);
> +		spin_unlock_irqrestore(&port->agg_lock, flags);
> +		hrtimer_cancel(&port->hrtimer);
> +		dev_queue_xmit(agg_skb);
> +		goto new_packet;
> +	}
> +
> +	skb_put_data(port->agg_skb, skb->data, skb->len);

IIUC, RMNet netdevs support %NETIF_F_SG. Which means you could just
attach skb data as frags to the first skb in the aggregation
session instead of copying the data all the time.
...or even add %NETIF_F_FRAGLIST handling, that would save even more
-- just use skb->frag_list once you run out of skb_shinfo()->frags.

> +	port->agg_count++;
> +	dev_kfree_skb_any(skb);
> +
> +	if (port->agg_count == port->egress_agg_params.agg_count ||
> +	    port->agg_skb->len == port->egress_agg_params.agg_size) {

I think ::agg_count and ::agg_size are the thresholds, so the
comparison should be >= I guess (especially ::agg_size which gets
increased by a random value each time, not by 1)?

> +		agg_skb = port->agg_skb;
> +		reset_aggr_params(port);
> +		spin_unlock_irqrestore(&port->agg_lock, flags);
> +		hrtimer_cancel(&port->hrtimer);
> +		dev_queue_xmit(agg_skb);
> +		return;
> +	}
> +
> +schedule:
> +	if (!hrtimer_active(&port->hrtimer) && port->agg_state != -EINPROGRESS) {
> +		port->agg_state = -EINPROGRESS;
> +		hrtimer_start(&port->hrtimer,
> +			      ns_to_ktime(port->egress_agg_params.agg_time_nsec),
> +			      HRTIMER_MODE_REL);
> +	}
> +	spin_unlock_irqrestore(&port->agg_lock, flags);
> +}
> +
> +void rmnet_map_update_ul_agg_config(struct rmnet_port *port, u16 size,
> +				    u16 count, u32 time)
> +{
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&port->agg_lock, irq_flags);
> +	port->egress_agg_params.agg_size = size;
> +	port->egress_agg_params.agg_count = count;
> +	port->egress_agg_params.agg_time_nsec = time * NSEC_PER_USEC;
> +	spin_unlock_irqrestore(&port->agg_lock, irq_flags);
> +}
> +
> +void rmnet_map_tx_aggregate_init(struct rmnet_port *port)
> +{
> +	hrtimer_init(&port->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	port->hrtimer.function = rmnet_map_flush_tx_packet_queue;
> +	spin_lock_init(&port->agg_lock);
> +	rmnet_map_update_ul_agg_config(port, 4096, 16, 800);
> +	INIT_WORK(&port->agg_wq, rmnet_map_flush_tx_packet_work);
> +}
> +
> +void rmnet_map_tx_aggregate_exit(struct rmnet_port *port)
> +{
> +	unsigned long flags;
> +
> +	hrtimer_cancel(&port->hrtimer);
> +	cancel_work_sync(&port->agg_wq);
> +
> +	spin_lock_irqsave(&port->agg_lock, flags);
> +	if (port->agg_state == -EINPROGRESS) {
> +		if (port->agg_skb) {
> +			kfree_skb(port->agg_skb);
> +			reset_aggr_params(port);
> +		}
> +
> +		port->agg_state = 0;
> +	}
> +
> +	spin_unlock_irqrestore(&port->agg_lock, flags);
> +}

Do I get the whole logics correctly, you allocate a new big skb and
just copy several frames into it, then send as one chunk once its
size reaches the threshold? Plus linearize every skb to be able to
do that... That's too much of overhead I'd say, just handle S/G and
fraglists and make long trains of frags from them without copying
anything? Also BQL/DQL already does some sort of aggregation via
::xmit_more, doesn't it? Do you have any performance numbers?

> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 5e7a1041df3a..09a30e2b29b1 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -1351,6 +1351,7 @@ enum {
>  #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
>  #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
>  #define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
> +#define RMNET_FLAGS_EGRESS_AGGREGATION            (1U << 6)

But you could rely on the aggregation parameters passed via Ethtool
to decide whether to enable aggregation or not. If any of them is 0,
it means the aggregation needs to be disabled.
Otherwise, to enable it you need to use 2 utilities: the one that
creates RMNet devices at first and Ethtool after, isn't it too
complicated for no reason?

>  
>  enum {
>  	IFLA_RMNET_UNSPEC,
> -- 
> 2.37.1

Thanks,
Olek
