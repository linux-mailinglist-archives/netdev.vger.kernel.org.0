Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F47687087
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 22:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjBAVlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 16:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBAVlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 16:41:52 -0500
X-Greylist: delayed 337 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Feb 2023 13:41:50 PST
Received: from out-26.mta0.migadu.com (out-26.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2413145887
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 13:41:49 -0800 (PST)
Message-ID: <56a2ea34-7730-3794-d2df-53c94b4d9a60@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675287368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x9J7CRDgXk8dbsTIqLYy73tOaxfXKKwvmaKISlG680I=;
        b=ilBYD6pw9FttH7sS3zmkFtBo1GzJ4VXbD1M4P5q9o0qjFivI6Y7kqtxLInYgb/iQFLvo62
        akfWqKY0bAPN+uTL4XCJSQeUsPvO/3gae87n3EJxvHiIePjw4pGIC6vwlfXwaK740Jis6j
        Q8a3upJ3T+xpXzG7ItM0HyoyT86dLSk=
Date:   Wed, 1 Feb 2023 21:36:01 +0000
MIME-Version: 1.0
Subject: Re: [PATCH net v4 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
To:     Saeed Mahameed <saeed@kernel.org>,
        Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
References: <20230201122605.1350664-1-vadfed@meta.com>
 <20230201122605.1350664-3-vadfed@meta.com> <Y9qtPtTMvZUWtRso@x130>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <Y9qtPtTMvZUWtRso@x130>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/02/2023 18:19, Saeed Mahameed wrote:
> On 01 Feb 04:26, Vadim Fedorenko wrote:
>> Fifo indexes were not checked during pop operations and it leads to
>> potential use-after-free when poping from empty queue. Such case was
>> possible during re-sync action.
>>
>> There were out-of-order cqe spotted which lead to drain of the queue and
>> use-after-free because of lack of fifo pointers check. Special check
>> is added to avoid resync operation if SKB could not exist in the fifo
>> because of OOO cqe (skb_id must be between consumer and producer index).
>>
>> Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port 
>> timestamp")
>> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
>> ---
>> .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 23 ++++++++++++++-----
>> .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 +++-
>> 2 files changed, 20 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> index b72de2b520ec..5df726185192 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> @@ -86,7 +86,7 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq 
>> *ptpsq, u16 skb_cc, u16 skb
>>     return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
>> }
>>
>> -static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq 
>> *ptpsq, u16 skb_cc,
>> +static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq 
>> *ptpsq, u16 skb_cc,
>>                          u16 skb_id, int budget)
>> {
>>     struct skb_shared_hwtstamps hwts = {};
>> @@ -94,14 +94,23 @@ static void 
>> mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
>>
>>     ptpsq->cq_stats->resync_event++;
>>
>> -    while (skb_cc != skb_id) {
>> -        skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>> +    if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < 
>> skb_id) {
> 
> To avoid returning boolean and add more functionality to this function,
> I prefer to put this check in mlx5e_ptp_handle_ts_cqe(), see below.
>

Let's discuss this point, see comments below.

>> +        mlx5_core_err_rl(ptpsq->txqsq.mdev, "out-of-order ptp cqe\n");
> 
> it's better to add a counter for this, eg: ptpsq->cq_stats->ooo_cqe_drop++;

Sure, will do.

> 
>> +        return false;
>> +    }
>> +
>> +    while (skb_cc != skb_id && (skb = 
>> mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
>>         hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
>>         skb_tstamp_tx(skb, &hwts);
>>         ptpsq->cq_stats->resync_cqe++;
>>         napi_consume_skb(skb, budget);
>>         skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>>     }
>> +
>> +    if (!skb)
>> +        return false;
>> +
>> +    return true;
>> }
>>
>> static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>> @@ -111,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct 
>> mlx5e_ptpsq *ptpsq,
>>     u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
>>     u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>>     struct mlx5e_txqsq *sq = &ptpsq->txqsq;
>> -    struct sk_buff *skb;
>> +    struct sk_buff *skb = NULL;
>>     ktime_t hwtstamp;
>>
>>     if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
>> @@ -120,8 +129,10 @@ static void mlx5e_ptp_handle_ts_cqe(struct 
>> mlx5e_ptpsq *ptpsq,
>>         goto out;
>>     }
>>
>> -    if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
>> -        mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
> 
> you can check here:
>      /* ignore ooo cqe as it was already handled by a previous resync */
>      if (ooo_cqe(cqe))
>          return;

I assume that mlx5e_ptp_skb_fifo_ts_cqe_resync() is error-recovery path 
and should not happen frequently. If we move this check to 
mlx5e_ptp_handle_ts_cqe() we will have additional if with 2 checks for 
every cqe coming from ptp queue - the fast path. With our load of 1+Mpps 
it could be countable. Another point is that 
mlx5e_ptp_skb_fifo_ts_cqe_resync() will assume that skb_id must always 
be within fifo indexes and any other (future?) code has to implement 
this check. Otherwise it will cause use-after-free, double-free and then 
crash, especially if we remove check in mlx5e_skb_fifo_pop() that you 
commented below. I think it's ok to have additional check in error path 
to prevent anything like that in the future.

If you stongly against converting mlx5e_ptp_skb_fifo_ts_cqe_resync() to 
return bool, I can add the check to 'if mlx5e_ptp_ts_cqe_drop()' scope 
before calling resync(), but it will not remove problems from my second 
point and I just would like to see explicit 'yes, we agree to have 
dangerous code in our driver' from you or other maintainers in this case.

>> +    if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id) &&
>> +        !mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, 
>> budget)) {
>> +        goto out;
>> +    }
>>
>>     skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>>     hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, 
>> get_cqe_ts(cqe));
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> index d5afad368a69..e599b86d94b5 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> @@ -295,13 +295,15 @@ static inline
>> void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff 
>> *skb)
>> {
>>     struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
>> -
> 
> redundant change.

yep, will remove this artefact.

> 
>>     *skb_item = skb;
>> }
>>
>> static inline
>> struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
>> {
>> +    if (*fifo->pc == *fifo->cc)
>> +        return NULL;
>> +
> 
> I think this won't be necessary if you check for ooo early on
> mlx5e_ptp_handle_ts_cqe() like i suggested above.
> 
And again the only concern here is that we don't have any checks whether 
FIFO has anything to pop before actually poping the value. That can 
easily bring use-after-free in the futuee, especially because the 
function is not ptp specific and is already used for other fifos. I can 
add unlikely() for this check if it helps, but I would like to have this 
check in the code.

>>     return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
>> }
>>
>> -- 
>> 2.30.2
>>

