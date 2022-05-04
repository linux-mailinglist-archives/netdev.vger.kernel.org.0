Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1690851ACEA
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 20:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377120AbiEDShR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 14:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377135AbiEDShG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 14:37:06 -0400
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D42E53E17
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 11:24:06 -0700 (PDT)
Received: (qmail 20359 invoked by uid 89); 4 May 2022 18:24:04 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 4 May 2022 18:24:04 -0000
Date:   Wed, 4 May 2022 11:24:02 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/6] ptp: Support late timestamp determination
Message-ID: <20220504182402.m6vsxy3hc6ofd2ni@bsd-mbp.dhcp.thefacebook.com>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
 <20220501111836.10910-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501111836.10910-5-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 01, 2022 at 01:18:34PM +0200, Gerhard Engleder wrote:
> If a physical clock supports a free running cycle counter, then
> timestamps shall be based on this time too. For TX it is known in
> advance before the transmission if a timestamp based on the free running
> cycle counter is needed. For RX it is impossible to know which timestamp
> is needed before the packet is received and assigned to a socket.
> 
> Support late timestamp determination by a network device. Therefore, an
> address/cookie is stored within the new netdev_data field of struct
> skb_shared_hwtstamps. This address/cookie is provided to a new network
> device function called ndo_get_tstamp(), which returns a timestamp based
> on the normal/adjustable time or based on the free running cycle
> counter. If function is not supported, then timestamp handling is not
> changed.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  include/linux/netdevice.h | 21 ++++++++++++++++++++
>  include/linux/skbuff.h    | 16 ++++++++++++---
>  net/socket.c              | 42 +++++++++++++++++++++++++++++----------
>  3 files changed, 66 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 4aba92a4042a..47dca9adfb17 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1356,6 +1356,12 @@ struct netdev_net_notifier {
>   *	The caller must be under RCU read context.
>   * int (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx, struct net_device_path *path);
>   *     Get the forwarding path to reach the real device from the HW destination address
> + * ktime_t (*ndo_get_tstamp)(struct net_device *dev,
> + *			     const struct skb_shared_hwtstamps *hwtstamps,
> + *			     bool cycles);
> + *	Get hardware timestamp based on normal/adjustable time or free running
> + *	cycle counter. This function is required if physical clock supports a
> + *	free running cycle counter.
>   */
>  struct net_device_ops {
>  	int			(*ndo_init)(struct net_device *dev);
> @@ -1578,6 +1584,9 @@ struct net_device_ops {
>  	struct net_device *	(*ndo_get_peer_dev)(struct net_device *dev);
>  	int                     (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx,
>                                                           struct net_device_path *path);
> +	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
> +						  const struct skb_shared_hwtstamps *hwtstamps,
> +						  bool cycles);
>  };
>  
>  /**
> @@ -4738,6 +4747,18 @@ static inline void netdev_rx_csum_fault(struct net_device *dev,
>  void net_enable_timestamp(void);
>  void net_disable_timestamp(void);
>  
> +static inline ktime_t netdev_get_tstamp(struct net_device *dev,
> +					const struct skb_shared_hwtstamps *hwtstamps,
> +					bool cycles)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +
> +	if (ops->ndo_get_tstamp)
> +		return ops->ndo_get_tstamp(dev, hwtstamps, cycles);
> +
> +	return hwtstamps->hwtstamp;
> +}
> +
>  static inline netdev_tx_t __netdev_start_xmit(const struct net_device_ops *ops,
>  					      struct sk_buff *skb, struct net_device *dev,
>  					      bool more)
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index fa03e02b761d..732b995fe54e 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -588,8 +588,10 @@ static inline bool skb_frag_must_loop(struct page *p)
>  
>  /**
>   * struct skb_shared_hwtstamps - hardware time stamps
> - * @hwtstamp:	hardware time stamp transformed into duration
> - *		since arbitrary point in time
> + * @hwtstamp:		hardware time stamp transformed into duration
> + *			since arbitrary point in time
> + * @netdev_data:	address/cookie of network device driver used as
> + *			reference to actual hardware time stamp
>   *
>   * Software time stamps generated by ktime_get_real() are stored in
>   * skb->tstamp.
> @@ -601,7 +603,10 @@ static inline bool skb_frag_must_loop(struct page *p)
>   * &skb_shared_info. Use skb_hwtstamps() to get a pointer.
>   */
>  struct skb_shared_hwtstamps {
> -	ktime_t	hwtstamp;
> +	union {
> +		ktime_t	hwtstamp;
> +		void *netdev_data;
> +	};
>  };
>  
>  /* Definitions for tx_flags in struct skb_shared_info */
> @@ -620,6 +625,11 @@ enum {
>  	 */
>  	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
>  
> +	/* determine hardware time stamp based on time or cycles, flag is used
> +	 * only for RX path
> +	 */
> +	SKBTX_HW_TSTAMP_NETDEV = 1 << 3,
> +
>  	/* generate wifi status information (where possible) */
>  	SKBTX_WIFI_STATUS = 1 << 4,

I follow what is being done here, although it seems a bit messy:
  - abusing tx_flags for recive
  - keeping a pointer into skb->data for later use.


> diff --git a/net/socket.c b/net/socket.c
> index 0f680c7d968a..ee81e25e9b98 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -805,7 +805,8 @@ static bool skb_is_swtx_tstamp(const struct sk_buff *skb, int false_tstamp)
>  	return skb->tstamp && !false_tstamp && skb_is_err_queue(skb);
>  }
>  
> -static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
> +static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
> +			   int if_index)
>  {
>  	struct scm_ts_pktinfo ts_pktinfo;
>  	struct net_device *orig_dev;
> @@ -815,11 +816,15 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
>  
>  	memset(&ts_pktinfo, 0, sizeof(ts_pktinfo));
>  
> -	rcu_read_lock();
> -	orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> -	if (orig_dev)
> -		ts_pktinfo.if_index = orig_dev->ifindex;
> -	rcu_read_unlock();
> +	if (if_index == -1) {
> +		rcu_read_lock();
> +		orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> +		if (orig_dev)
> +			ts_pktinfo.if_index = orig_dev->ifindex;
> +		rcu_read_unlock();
> +	} else {
> +		ts_pktinfo.if_index = if_index;
> +	}

if_index of 0 is invalid - see dev_new_index().
So this optimization would be better written as:

        if (!if_index) {
                rcu_read_lock();
                orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
                if (orig_dev)
                        if_index = orig_dev->ifindex;
                rcu_read_unlock();
        }
        ts_pktinfo.if_index = if_index;


>  	ts_pktinfo.pkt_length = skb->len - skb_mac_offset(skb);
>  	put_cmsg(msg, SOL_SOCKET, SCM_TIMESTAMPING_PKTINFO,
> @@ -839,6 +844,8 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  	int empty = 1, false_tstamp = 0;
>  	struct skb_shared_hwtstamps *shhwtstamps =
>  		skb_hwtstamps(skb);
> +	struct net_device *orig_dev;
> +	int if_index = -1;

This should be set to 0 in the SOF_TIMESTAMPING_RAW_HARDWARE block.
(see below)


>  	ktime_t hwtstamp;
>  
>  	/* Race occurred between timestamp enabling and packet
> @@ -887,18 +894,33 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  	if (shhwtstamps &&
>  	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
>  	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
> +		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV) {
> +			rcu_read_lock();
> +			orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> +			if (orig_dev) {
> +				if_index = orig_dev->ifindex;
> +				hwtstamp = netdev_get_tstamp(orig_dev,
> +							     shhwtstamps,
> +							     sk->sk_tsflags &
> +							     SOF_TIMESTAMPING_BIND_PHC);
> +			} else {
> +				hwtstamp = shhwtstamps->hwtstamp;
> +			}
> +			rcu_read_unlock();
> +		} else {
> +			hwtstamp = shhwtstamps->hwtstamp;
> +		}
> +

I'd suggest moving all this into a helper function, so it reads 
something like this:

                if_index = 0;

                if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
                        hwtstamp = recover_hw_tstamp(skb, sk, &if_index);
                else
                        hwtstamp = shhwtstamps->hwtstamp;



>  		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
> -			hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
> +			hwtstamp = ptp_convert_timestamp(&hwtstamp,
>  							 sk->sk_bind_phc);
> -		else
> -			hwtstamp = shhwtstamps->hwtstamp;
>  
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

-- 
Jonathan
