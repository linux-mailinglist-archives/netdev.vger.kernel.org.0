Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389A6678C3D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 00:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjAWXtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 18:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjAWXtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 18:49:45 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F11D32E57
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 15:49:43 -0800 (PST)
Received: from [192.168.0.18] (unknown [37.228.234.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id CDD7F505269;
        Tue, 24 Jan 2023 02:44:10 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru CDD7F505269
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1674517461; bh=Tc76f1STnwK7Mk0xvx845TrTXO0qiIiExUWemYvHVPo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IlyVMl9H78NYGEj4yVo3q6o3pac/PA4wy/8q4DpfBFPgM1zNvNB8Y86AW42rKn2fP
         39y0I9iP2WDT8WVTQqFej+luZ+xr/YeeDtiy5LXmmNIH6TCLrd6/Df4do+FAc8yyvZ
         By51IjVU3lTwLXZVL0BydeEplc5Q7hAFVjaiFnEU=
Message-ID: <facabfb3-953c-2a48-a980-97bf2b9f70d3@novek.ru>
Date:   Mon, 23 Jan 2023 23:49:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
To:     Gal Pressman <gal@nvidia.com>, Vadim Fedorenko <vadfed@meta.com>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-2-vadfed@meta.com>
 <220db544-01b5-ead7-bc57-b7c7d482ec39@nvidia.com>
Content-Language: en-US
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <220db544-01b5-ead7-bc57-b7c7d482ec39@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.01.2023 12:32, Gal Pressman wrote:
> Hi Vadim,
> 
> On 22/01/2023 18:16, Vadim Fedorenko wrote:
>> Fifo pointers are not checked for overflow and this could potentially
>> lead to overflow and double free under heavy PTP traffic.
>>
>> Also there were accidental OOO cqe which lead to absolutely broken fifo.
>> Add checks to workaround OOO cqe and add counters to show the amount of
>> such events.
>>
>> Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")
> 
> Isn't 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port
> timestamp") more appropriate?
> 
I re-checked the log and realised that you are absolutely right, I'll update it 
in v2, thanks!


>> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
>> ---
>>   .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 28 ++++++++++++++-----
>>   .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++-
>>   .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 ++
>>   .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
>>   4 files changed, 30 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> index 903de88bab53..11a99e0f00c6 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> @@ -86,20 +86,31 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
>>   	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
>>   }
>>   
>> -static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
>> +static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
>>   {
>>   	struct skb_shared_hwtstamps hwts = {};
>>   	struct sk_buff *skb;
>>   
>>   	ptpsq->cq_stats->resync_event++;
>>   
>> -	while (skb_cc != skb_id) {
>> -		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>> +	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id) {
>> +		ptpsq->cq_stats->ooo_cqe++;
>> +		return false;
>> +	}
> 
> I honestly don't understand how this could happen, can you please
> provide more information about your issue? Did you actually witness ooo
> completions or is it a theoretical issue?
> We know ptp CQEs can be dropped in some rare cases (that's the reason we
> implemented this resync flow), but completions should always arrive
> in-order.
> 
>> +
>> +	while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
>>   		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
>>   		skb_tstamp_tx(skb, &hwts);
>>   		ptpsq->cq_stats->resync_cqe++;
>>   		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>>   	}
>> +
>> +	if (!skb) {
>> +		ptpsq->cq_stats->fifo_empty++;
> 
> Hmm, for this to happen you need _all_ ptp CQEs to drop and wraparound
> the SQ?
> 
>> +		return false;> +	}
>> +
>> +	return true;
>>   }
>>   
>>   static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>> @@ -109,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>>   	u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
>>   	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>>   	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
>> -	struct sk_buff *skb;
>> +	struct sk_buff *skb = NULL;
>>   	ktime_t hwtstamp;
>>   
>>   	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
>> @@ -118,8 +129,10 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>>   		goto out;
>>   	}
>>   
>> -	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
>> -		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id);
>> +	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id) &&
>> +	    !mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id)) {
>> +		goto out;
>> +	}
>>   
>>   	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>>   	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
>> @@ -128,7 +141,8 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>>   	ptpsq->cq_stats->cqe++;
>>   
>>   out:
>> -	napi_consume_skb(skb, budget);
>> +	if (skb)
>> +		napi_consume_skb(skb, budget);
>>   }
>>   
>>   static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> index aeed165a2dec..0bd2dd694f04 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> @@ -81,7 +81,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
>>   static inline bool
>>   mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
>>   {
>> -	return (*fifo->pc - *fifo->cc) < fifo->mask;
>> +	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;
> 
> What is this cast for?
> 
>>   }
>>   
>>   static inline bool
>> @@ -291,12 +291,16 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
>>   {
>>   	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
>>   
>> +	WARN_ONCE((u16)(*fifo->pc - *fifo->cc) > fifo->mask, "%s overflow", __func__);
> 
> The fifo is the same size of the SQ, how can it overflow?
> 
>>   	*skb_item = skb;
>>   }

