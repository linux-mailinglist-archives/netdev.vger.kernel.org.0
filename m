Return-Path: <netdev+bounces-1458-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A256FDD0B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:43:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A21FA280F21
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5CDF9E1;
	Wed, 10 May 2023 11:43:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19D20B58
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:43:41 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3629D6A4B
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:43:39 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QGY313PTzzpTwG;
	Wed, 10 May 2023 19:39:25 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 10 May
 2023 19:43:37 +0800
Subject: Re: [PATCH net-next v4 2/7] net: wangxun: libwx add rx offload
 functions
To: Mengyuan Lou <mengyuanlou@net-swift.com>, <netdev@vger.kernel.org>
CC: <jiawenwu@trustnetic.com>
References: <20230510093845.47446-1-mengyuanlou@net-swift.com>
 <20230510093845.47446-3-mengyuanlou@net-swift.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b26664c9-7df9-f2dc-ca49-3e5abd3dab70@huawei.com>
Date: Wed, 10 May 2023 19:43:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230510093845.47446-3-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/10 17:38, Mengyuan Lou wrote:
...

> +/**
> + * wx_rx_checksum - indicate in skb if hw indicated a good cksum
> + * @ring: structure containing ring specific data
> + * @rx_desc: current Rx descriptor being processed
> + * @skb: skb currently being received and modified
> + **/
> +static void wx_rx_checksum(struct wx_ring *ring,
> +			   union wx_rx_desc *rx_desc,
> +			   struct sk_buff *skb)
> +{
> +	struct wx_dec_ptype dptype = wx_decode_ptype(WX_RXD_PKTTYPE(rx_desc));
> +
> +	skb->ip_summed = CHECKSUM_NONE;
> +	skb_checksum_none_assert(skb);

It does not make much to check skb->ip_summed when it is just
set one line above.

Also the "skb->ip_summed = CHECKSUM_NONE" seems unnecessary,
as alloc/build_skb() all have the below to make sure
skb->ip_summed is zero:

memset(skb, 0, offsetofstruct sk_buff, tail))

> +	/* Rx csum disabled */
> +	if (!(ring->netdev->features & NETIF_F_RXCSUM))
> +		return;
> +
> +	/* if IPv4 header checksum error */
> +	if ((wx_test_staterr(rx_desc, WX_RXD_STAT_IPCS) &&
> +	     wx_test_staterr(rx_desc, WX_RXD_ERR_IPE)) ||
> +	    (wx_test_staterr(rx_desc, WX_RXD_STAT_OUTERIPCS) &&
> +	     wx_test_staterr(rx_desc, WX_RXD_ERR_OUTERIPER))) {
> +		ring->rx_stats.csum_err++;
> +		return;
> +	}
> +
> +	/* L4 checksum offload flag must set for the below code to work */
> +	if (!wx_test_staterr(rx_desc, WX_RXD_STAT_L4CS))
> +		return;
> +
> +	/*likely incorrect csum if IPv6 Dest Header found */

What does "likely incorrect" mean here? If it is incorrect,
does ring->rx_stats.csum_err need incrementing?

> +	if (dptype.prot != WX_DEC_PTYPE_PROT_SCTP && WX_RXD_IPV6EX(rx_desc))
> +		return;
> +
> +	/* if L4 checksum error */
> +	if (wx_test_staterr(rx_desc, WX_RXD_ERR_TCPE)) {
> +		ring->rx_stats.csum_err++;
> +		return;
> +	}
> +
> +	/* If there is an outer header present that might contain a checksum
> +	 * we need to bump the checksum level by 1 to reflect the fact that
> +	 * we are indicating we validated the inner checksum.
> +	 */
> +	if (dptype.etype >= WX_DEC_PTYPE_ETYPE_IG) {
> +		skb->csum_level = 1;
> +		skb->encapsulation = 1;
> +	}
> +
> +	/* It must be a TCP or UDP or SCTP packet with a valid checksum */
> +	skb->ip_summed = CHECKSUM_UNNECESSARY;
> +	ring->rx_stats.csum_good_cnt++;
> +}
> +
> +/**
> + * wx_process_skb_fields - Populate skb header fields from Rx descriptor
> + * @rx_ring: rx descriptor ring packet is being transacted on
> + * @rx_desc: pointer to the EOP Rx descriptor
> + * @skb: pointer to current skb being populated
> + *
> + * This function checks the ring, descriptor, and packet information in
> + * order to populate the hash, checksum, VLAN, timestamp, protocol, and

For now VLAN, timestamp are not populated yet.

> + * other fields within the skb.
> + **/
> +static void wx_process_skb_fields(struct wx_ring *rx_ring,
> +				  union wx_rx_desc *rx_desc,
> +				  struct sk_buff *skb)
> +{
> +	wx_rx_hash(rx_ring, rx_desc, skb);
> +	wx_rx_checksum(rx_ring, rx_desc, skb);
> +	skb_record_rx_queue(skb, rx_ring->queue_index);
> +	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
> +}
> +
>  /**
>   * wx_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
>   * @q_vector: structure containing interrupt and ring information
> @@ -491,8 +586,8 @@ static int wx_clean_rx_irq(struct wx_q_vector *q_vector,
>  		/* probably a little skewed due to removing CRC */
>  		total_rx_bytes += skb->len;
>  
> -		skb_record_rx_queue(skb, rx_ring->queue_index);
> -		skb->protocol = eth_type_trans(skb, rx_ring->netdev);
> +		/* populate checksum, timestamp, VLAN, and protocol */
> +		wx_process_skb_fields(rx_ring, rx_desc, skb);
>  		napi_gro_receive(&q_vector->napi, skb);
>  
>  		/* update budget accounting */
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> index 70f5fd168e40..69a9ed7bc2df 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> @@ -321,8 +321,31 @@

...

> +
> +static inline struct wx_dec_ptype wx_decode_ptype(const u8 ptype)

If the above is only used in one .c file, maybe it does not need
to be in the .h file?

> +{
> +	return wx_ptype_lookup[ptype];
> +}
> +
>  /* Host Interface Command Structures */
>  struct wx_hic_hdr {
>  	u8 cmd;
> @@ -624,6 +853,11 @@ struct wx_queue_stats {
>  	u64 bytes;
>  };
>  
> +struct wx_rx_queue_stats {
> +	u64 csum_good_cnt;
> +	u64 csum_err;
> +};
> +
>  /* iterator for handling rings in ring container */
>  #define wx_for_each_ring(posm, headm) \
>  	for (posm = (headm).ring; posm; posm = posm->next)
> @@ -665,6 +899,9 @@ struct wx_ring {
>  
>  	struct wx_queue_stats stats;
>  	struct u64_stats_sync syncp;
> +	union {
> +		struct wx_rx_queue_stats rx_stats;
> +	};
>  } ____cacheline_internodealigned_in_smp;
>  
>  struct wx_q_vector {
> @@ -680,6 +917,7 @@ struct wx_q_vector {
>  	struct napi_struct napi;
>  	struct rcu_head rcu;    /* to avoid race with update stats on free */
>  
> +	bool netpoll_rx;

Unused?

>  	char name[IFNAMSIZ + 17];
>  
>  	/* for dynamic allocation of rings associated with this q_vector */
> 

