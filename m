Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD01687200
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 00:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjBAXkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 18:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBAXkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 18:40:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D6B5DC08
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 15:40:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7470B8228D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 23:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B2DC433D2;
        Wed,  1 Feb 2023 23:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675294801;
        bh=I4TFsNRPmESglSNzkmNXhIwWjL8+hUAmRlGz5l8+FgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nBY7523WX9wvvdlJGuL7kpAfofcpSD2iPE4fCDmk+fMdY95wqQpFHn3Poo0ubwNw8
         +2jvN0BBwwKm7Z+ITQhHtUl06KmSKHwYMS8zvEgSYIteWpc7R6lv81BG+6Nt6hpWfr
         Q984By6BEB9TkIrtz7N9NZCUegucadsInQTIoXCGjHdmX1XSo9Ugbr0dvXeWpiFDdF
         mD5eeb+jAE/I5kD3HewJyd2k8oYZ1rAYtgiIlxhAy6xPiz5br9E1gGNNojbLB3P3yg
         PS3sowZ3fTw1d0M6iBsYOY+eTFK6sVGO3WWhZwZ6wG6kFDYbTOQl6e+kmZXb27dUWH
         Xle15KamFmLJg==
Date:   Wed, 1 Feb 2023 15:40:00 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v4 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Message-ID: <Y9r4UHZUUAdYdTPp@x130>
References: <20230201122605.1350664-1-vadfed@meta.com>
 <20230201122605.1350664-3-vadfed@meta.com>
 <Y9qtPtTMvZUWtRso@x130>
 <56a2ea34-7730-3794-d2df-53c94b4d9a60@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56a2ea34-7730-3794-d2df-53c94b4d9a60@linux.dev>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 Feb 21:36, Vadim Fedorenko wrote:
>On 01/02/2023 18:19, Saeed Mahameed wrote:
>>On 01 Feb 04:26, Vadim Fedorenko wrote:
>>>Fifo indexes were not checked during pop operations and it leads to
>>>potential use-after-free when poping from empty queue. Such case was
>>>possible during re-sync action.
>>>
>>>There were out-of-order cqe spotted which lead to drain of the queue and
>>>use-after-free because of lack of fifo pointers check. Special check
>>>is added to avoid resync operation if SKB could not exist in the fifo
>>>because of OOO cqe (skb_id must be between consumer and producer index).
>>>
>>>Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port 
>>>timestamp")
>>>Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
>>>---
>>>.../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 23 ++++++++++++++-----
>>>.../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 +++-
>>>2 files changed, 20 insertions(+), 7 deletions(-)
>>>
>>>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c 
>>>b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>>>index b72de2b520ec..5df726185192 100644
>>>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>>>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>>>@@ -86,7 +86,7 @@ static bool mlx5e_ptp_ts_cqe_drop(struct 
>>>mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
>>>    return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
>>>}
>>>
>>>-static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq 
>>>*ptpsq, u16 skb_cc,
>>>+static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq 
>>>*ptpsq, u16 skb_cc,
>>>                         u16 skb_id, int budget)
>>>{
>>>    struct skb_shared_hwtstamps hwts = {};
>>>@@ -94,14 +94,23 @@ static void 
>>>mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 
>>>skb_
>>>
>>>    ptpsq->cq_stats->resync_event++;
>>>
>>>-    while (skb_cc != skb_id) {
>>>-        skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>>>+    if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < 
>>>skb_id) {
>>
>>To avoid returning boolean and add more functionality to this function,
>>I prefer to put this check in mlx5e_ptp_handle_ts_cqe(), see below.
>>
>
>Let's discuss this point, see comments below.
>
>>>+        mlx5_core_err_rl(ptpsq->txqsq.mdev, "out-of-order ptp cqe\n");
>>
>>it's better to add a counter for this, eg: ptpsq->cq_stats->ooo_cqe_drop++;
>
>Sure, will do.
>
>>
>>>+        return false;
>>>+    }
>>>+
>>>+    while (skb_cc != skb_id && (skb = 
>>>mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
>>>        hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
>>>        skb_tstamp_tx(skb, &hwts);
>>>        ptpsq->cq_stats->resync_cqe++;
>>>        napi_consume_skb(skb, budget);
>>>        skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>>>    }
>>>+
>>>+    if (!skb)
>>>+        return false;
>>>+
>>>+    return true;
>>>}
>>>
>>>static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>>>@@ -111,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct 
>>>mlx5e_ptpsq *ptpsq,
>>>    u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
>>>    u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>>>    struct mlx5e_txqsq *sq = &ptpsq->txqsq;
>>>-    struct sk_buff *skb;
>>>+    struct sk_buff *skb = NULL;
>>>    ktime_t hwtstamp;
>>>
>>>    if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
>>>@@ -120,8 +129,10 @@ static void mlx5e_ptp_handle_ts_cqe(struct 
>>>mlx5e_ptpsq *ptpsq,
>>>        goto out;
>>>    }
>>>
>>>-    if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
>>>-        mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
>>
>>you can check here:
>>     /* ignore ooo cqe as it was already handled by a previous resync */
>>     if (ooo_cqe(cqe))
>>         return;
>
>I assume that mlx5e_ptp_skb_fifo_ts_cqe_resync() is error-recovery 
>path and should not happen frequently. If we move this check to 
>mlx5e_ptp_handle_ts_cqe() we will have additional if with 2 checks for 
>every cqe coming from ptp queue - the fast path. With our load of 

we could do:

if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
{
    if (ooo_cqe) /* already handled by a previous resync */
          return;
    mlx5e_ptp_skb_fifo_ts_cqe_resync(..);
}
    

>1+Mpps it could be countable. Another point is that 
>mlx5e_ptp_skb_fifo_ts_cqe_resync() will assume that skb_id must always 
>be within fifo indexes and any other (future?) code has to implement 
>this check. Otherwise it will cause use-after-free, double-free and 
>then crash, especially if we remove check in mlx5e_skb_fifo_pop() that 
>you commented below. I think it's ok to have additional check in error 
>path to prevent anything like that in the future.
>
>If you stongly against converting mlx5e_ptp_skb_fifo_ts_cqe_resync() 
>to return bool, I can add the check to 'if mlx5e_ptp_ts_cqe_drop()' 
>scope before calling resync(), but it will not remove problems from my 
>second point and I just would like to see explicit 'yes, we agree to 
>have dangerous code in our driver' from you or other maintainers in

what do you mean ? define dangerous..
we don't willingly push dangerous code :) the code is built and designed
for the current HW spec under the assumption that HW/FW is bug free,
otherwise what's the point of the spec if we are going to write doubtful,
inefficient, paranoid driver code.. 

I understand your concern but we don't design data path code to be future
proof.

This patch is just a temporary fix for another underlying issue that
we need to continue debug. so let's keep it minimal until we find the
real issue.

keep in mind that the whole code is designed with fifos and only in-order
queues guaranteed by both HW and Firmware, so there's no reason to be
too-paranoid .. just fix the known bugs :).

>>static inline
>>>struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
>>>{
>>>+    if (*fifo->pc == *fifo->cc)
>>>+        return NULL;
>>>+
>>
>>I think this won't be necessary if you check for ooo early on
>>mlx5e_ptp_handle_ts_cqe() like i suggested above.
>>
>And again the only concern here is that we don't have any checks 
>whether FIFO has anything to pop before actually poping the value. 
>That can easily bring use-after-free in the futuee, especially because 
>the function is not ptp specific and is already used for other fifos. 
>I can add unlikely() for this check if it helps, but I would like to 
>have this check in the code.
>

you shouldn't access the fifo if by design it's guaranteed nothing is there.
We don't build for a future/fool proof code, the fifo is only accessed
when we know there's something there by design, this is not a general
purpose fifo, it's a fifo used by mlx5 ordered cqs.. 

According to your logic, kfree should also check for double free.. ? :) 

