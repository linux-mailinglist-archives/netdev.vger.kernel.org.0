Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64074E7E1E
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiCZA3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 20:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCZA3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 20:29:02 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9011740A2A
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 17:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648254446; x=1679790446;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=DNDQsmiw6Lkwk7Z50hRsEFPKTraAvD3QLAAaZx9mchw=;
  b=YtC+V8MbO7m6jKk+lFPd4foX9xnA8rUN4HHUPv4EFdEYAtSYdsEw1IJM
   wBOmpdkqegPUILHvsF3PhBk8EZBsEl0XMr6iqFKw241lbXmWflDDicr4T
   6uaAMAJvxct0hKetUHf2kIfnsne8E9uV4AX6Gru2RKRkCk+gR3ZkQwO4I
   dPAK730RXT7H69u+5tLGdggoityBn339tXljxDMcprwz/2l/EoUDt3bhW
   qPctHXM117x3HQNn8PNuse1rCuGpOAvi0+aS7EX30YZ20th623MrwwCQm
   GkrW620j2FerGcnGdie0F+tCGT84iH59dKS24Azplke+hJ0LOq3pxDbLQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10297"; a="246228427"
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="246228427"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 17:27:26 -0700
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="520378447"
Received: from hsinying-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.20.221])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 17:27:25 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH net-next v1 5/6] ptp: Support late timestamp determination
In-Reply-To: <20220322210722.6405-6-gerhard@engleder-embedded.com>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-6-gerhard@engleder-embedded.com>
Date:   Fri, 25 Mar 2022 17:27:25 -0700
Message-ID: <87mthd4kya.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gerhard Engleder <gerhard@engleder-embedded.com> writes:

> If a physical clock supports a free running time called cycles, then
> timestamps shall be based on this time too. For TX it is known in
> advance before the transmission if a timestamp based on cycles is
> needed. For RX it is impossible to know which timestamp is needed before
> the packet is received and assigned to a socket.
>
> Support late timestamp determination by a physical clock. Therefore, an
> address/cookie is stored within the new phc_data field of struct
> skb_shared_hwtstamps. This address/cookie is provided to a new physical
> clock method called gettstamp(), which returns a timestamp based on the
> normal/adjustable time or based on cycles.
>
> The previously introduced flag SKBTX_HW_TSTAMP_USE_CYCLES is reused with
> an additional alias to request the late timestamp determination by the
> physical clock. That is possible, because SKBTX_HW_TSTAMP_USE_CYCLES is
> not used in the receive path.
>
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/ptp/ptp_clock.c          | 27 ++++++++++++++++++++++++
>  include/linux/ptp_clock_kernel.h | 30 +++++++++++++++++++++++++++
>  include/linux/skbuff.h           |  8 +++++++-
>  net/socket.c                     | 35 ++++++++++++++++++++++----------
>  4 files changed, 88 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index 54b9f54ac0b2..b7a8cf27c349 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -450,6 +450,33 @@ void ptp_cancel_worker_sync(struct ptp_clock *ptp)
>  }
>  EXPORT_SYMBOL(ptp_cancel_worker_sync);
>  
> +ktime_t ptp_get_timestamp(int index,
> +			  const struct skb_shared_hwtstamps *hwtstamps,
> +			  bool cycles)
> +{
> +	char name[PTP_CLOCK_NAME_LEN] = "";
> +	struct ptp_clock *ptp;
> +	struct device *dev;
> +	ktime_t ts;
> +
> +	snprintf(name, PTP_CLOCK_NAME_LEN, "ptp%d", index);
> +	dev = class_find_device_by_name(ptp_class, name);
> +	if (!dev)
> +		return 0;
> +
> +	ptp = dev_get_drvdata(dev);
> +
> +	if (ptp->info->gettstamp)
> +		ts = ptp->info->gettstamp(ptp->info, hwtstamps, cycles);
> +	else
> +		ts = hwtstamps->hwtstamp;
> +
> +	put_device(dev);
> +
> +	return ts;
> +}
> +EXPORT_SYMBOL(ptp_get_timestamp);
> +
>  /* module operations */
>  
>  static void __exit ptp_exit(void)
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index cc6a7b2e267d..f4f0d8a880c6 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -133,6 +133,16 @@ struct ptp_system_timestamp {
>   *                   parameter cts: Contains timestamp (device,system) pair,
>   *                   where system time is realtime and monotonic.
>   *
> + * @gettstamp:  Get hardware timestamp based on normal/adjustable time or free
> + *              running time. If @getcycles64 or @getcyclesx64 are supported,
> + *              then this method is required to provide timestamps based on the
> + *              free running time. This method will be called if
> + *              SKBTX_HW_TSTAMP_PHC is set by the driver.
> + *              parameter hwtstamps: skb_shared_hwtstamps structure pointer.
> + *              parameter cycles: If false, then hardware timestamp based on
> + *              normal/adjustable time is requested. If true, then hardware
> + *              timestamp based on free running time is requested.
> + *
>   * @enable:   Request driver to enable or disable an ancillary feature.
>   *            parameter request: Desired resource to enable or disable.
>   *            parameter on: Caller passes one to enable or zero to disable.
> @@ -185,6 +195,9 @@ struct ptp_clock_info {
>  			    struct ptp_system_timestamp *sts);
>  	int (*getcrosscycles)(struct ptp_clock_info *ptp,
>  			      struct system_device_crosststamp *cts);
> +	ktime_t (*gettstamp)(struct ptp_clock_info *ptp,
> +			     const struct skb_shared_hwtstamps *hwtstamps,
> +			     bool cycles);
>  	int (*enable)(struct ptp_clock_info *ptp,
>  		      struct ptp_clock_request *request, int on);
>  	int (*verify)(struct ptp_clock_info *ptp, unsigned int pin,
> @@ -364,6 +377,19 @@ static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
>   * a loadable module.
>   */
>  
> +/**
> + * ptp_get_timestamp() - get timestamp of ptp clock
> + *
> + * @index:     phc index of ptp pclock.
> + * @hwtstamps: skb_shared_hwtstamps structure pointer.
> + * @cycles:    true for timestamp based on cycles.
> + *
> + * Returns timestamp, or 0 on error.
> + */
> +ktime_t ptp_get_timestamp(int index,
> +			  const struct skb_shared_hwtstamps *hwtstamps,
> +			  bool cycles);
> +
>  /**
>   * ptp_get_vclocks_index() - get all vclocks index on pclock, and
>   *                           caller is responsible to free memory
> @@ -386,6 +412,10 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
>   */
>  ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index);
>  #else
> +static inline ktime_t ptp_get_timestamp(int index,
> +					const struct skb_shared_hwtstamps *hwtstamps,
> +					bool cycles);
> +{ return 0; }
>  static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
>  { return 0; }
>  static inline ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp,
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index f494ddbfc826..38929c113953 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -564,7 +564,10 @@ static inline bool skb_frag_must_loop(struct page *p)
>   * &skb_shared_info. Use skb_hwtstamps() to get a pointer.
>   */
>  struct skb_shared_hwtstamps {
> -	ktime_t	hwtstamp;
> +	union {
> +		ktime_t	hwtstamp;
> +		void *phc_data;
> +	};
>  };
>  
>  /* Definitions for tx_flags in struct skb_shared_info */
> @@ -581,6 +584,9 @@ enum {
>  	/* generate hardware time stamp based on cycles if supported */
>  	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
>  
> +	/* call PHC to get actual hardware time stamp */
> +	SKBTX_HW_TSTAMP_PHC = 1 << 3,
> +
>  	/* generate wifi status information (where possible) */
>  	SKBTX_WIFI_STATUS = 1 << 4,
>  
> diff --git a/net/socket.c b/net/socket.c
> index 2e932c058002..fe765d559086 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -804,21 +804,17 @@ static bool skb_is_swtx_tstamp(const struct sk_buff *skb, int false_tstamp)
>  	return skb->tstamp && !false_tstamp && skb_is_err_queue(skb);
>  }
>  
> -static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
> +static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
> +			   int if_index)
>  {
>  	struct scm_ts_pktinfo ts_pktinfo;
> -	struct net_device *orig_dev;
>  
>  	if (!skb_mac_header_was_set(skb))
>  		return;
>  
>  	memset(&ts_pktinfo, 0, sizeof(ts_pktinfo));
>  
> -	rcu_read_lock();
> -	orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> -	if (orig_dev)
> -		ts_pktinfo.if_index = orig_dev->ifindex;
> -	rcu_read_unlock();
> +	ts_pktinfo.if_index = if_index;
>  
>  	ts_pktinfo.pkt_length = skb->len - skb_mac_offset(skb);
>  	put_cmsg(msg, SOL_SOCKET, SCM_TIMESTAMPING_PKTINFO,
> @@ -838,6 +834,9 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  	int empty = 1, false_tstamp = 0;
>  	struct skb_shared_hwtstamps *shhwtstamps =
>  		skb_hwtstamps(skb);
> +	struct net_device *orig_dev;
> +	int if_index = 0;
> +	int phc_index = -1;
>  	ktime_t hwtstamp;
>  
>  	/* Race occurred between timestamp enabling and packet
> @@ -886,18 +885,32 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  	if (shhwtstamps &&
>  	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
>  	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
> -		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
> -			hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
> -							 sk->sk_bind_phc);
> +		rcu_read_lock();
> +		orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> +		if (orig_dev) {
> +			if_index = orig_dev->ifindex;
> +			if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_PHC)
> +				phc_index = ethtool_get_phc(orig_dev);
> +		}
> +		rcu_read_unlock();
> +
> +		if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_PHC) &&
> +		    (phc_index != -1))
> +			hwtstamp = ptp_get_timestamp(phc_index, shhwtstamps,
> +						     sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC);
>  		else

I think that the only part that I don't like is how ethtool_get_phc()
and ptp_get_timestamp() work together. Would it make sense for
ethtool_get_phc() to return a 'struct ptp_clock' directly? And make
ptp_get_timestamp() accept a ptp_clock?

I always get worried that by using indexes it's hard to guarantee that
we are using the "right" device (thinking when the user is creating and
destrying devices non stop).

It could be that by addressing Richard comments you will handle this
concern as well.

>  			hwtstamp = shhwtstamps->hwtstamp;
>  
> +		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
> +			hwtstamp = ptp_convert_timestamp(&hwtstamp,
> +							 sk->sk_bind_phc);
> +
>  		if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
>  			empty = 0;
>  
>  			if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
>  			    !skb_is_err_queue(skb))
> -				put_ts_pktinfo(msg, skb);
> +				put_ts_pktinfo(msg, skb, if_index);
>  		}
>  	}
>  	if (!empty) {
> -- 
> 2.20.1
>

Cheers,
-- 
Vinicius
